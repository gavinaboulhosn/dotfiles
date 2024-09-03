#!/bin/bash
# forceably install app even if already installed
function force_adb_install() {
  echo "Uninstalling the app (if possible)"
  adb shell pm list packages | grep com.amazon.dee.app && echo "uninstalling the app since it is already installed" && adb uninstall com.amazon.dee.app

  echo "installing new apk"
  adb install $1
}

function launchRoute() {
  local route="${1:-v2/devices-channel}"
  adb shell am start -a "android.intent.action.VIEW" -d "alexa://any#$route" -n "com.amazon.dee.app/com.amazon.dee.app.ui.main.MainActivity"
}

function startApp() {
    adb shell am start -n com.amazon.dee.app/com.amazon.dee.app.ui.main.MainActivity
}

function stopApp() {
    adb shell am force-stop com.amazon.dee.app
}

function test() {
  timestamp=$(date +"%Y-%m-%d_%H-%M")

  stopApp

  adb logcat -c

  # Launch the route in the background
  launchRoute

  timeout 15s adb logcat -b main >> "logcat_$timestamp.txt"

  # Call the stopApp function if necessary
  stopApp
}

function dcPerf() {
  timestamp=$(date +"%Y-%m-%d_%H-%M")

  stopApp

  adb logcat -c

  startApp

   # Wait for TTA metric, then continue to devices channel
  timeout 15s adb logcat -b main -e "HomeShortcutBar_TimeToAction" -m 1

  # Launch the route in the background
  launchRoute

  # Wait for DC TTC
  # timeout 30s adb logcat -b main -e "" -m 1

  timeout 40s adb logcat -b main | tee -a "logcat_$timestamp.txt" | grep "PMI" >> "pmi_logcat_$timestamp.txt"

  # Call the stopApp function if necessary
  stopApp
}

function perfTest() {
    while getopts "n:f:m:" opt; do
        case $opt in 
            n) num_iterations="$OPTARG";;
            f) output_file="$OPTARG";;
            m) metric_name="$OPTARG";;
            ?) echo "Invalid option: -$OPTARG. Usage: perfTest [-f output_file] [-n num_iterations] [-m metric_name]"; return 1;;
            :) echo "Option -$OPTARG requires an argument. Usage: perfTest [-f output_file] [-n num_iterations] [-m metric_names]"; return 1;;
        esac
    done
    
    timestamp=$(date +"%Y-%m-%d_%H-%M")
    output_file="${output_file:-results_$timestamp.txt}"
    num_iterations="${num_iterations:-10}"
    metric_name="${metric_name:-home/cards-rendered-latency}"

    echo "Running perf test for $num_iterations iterations for $metric_name"

    metric_tag_regex=$(echo "$metric_name" | tr ',' '|')
    max_occurrences=$(echo "$metric_name" | awk -F, '{ print NF }')

    for ((i=1; i<=num_iterations; i++)); do
        echo "Running iteration $i"

        # Kill the app
        stopApp

        # Clear the log buffer
        adb logcat -c

        # Start the app 
        startApp
        
        # Wait for TTA metric, then exit
        adb logcat -b main -e "$metric_tag_regex" -m "$max_occurrences" >> "$output_file"
    done

    stopApp

    # Compute average for each metric separately
    IFS=',' read -rA metric_names <<< "$metric_name"
    for name in "${metric_names[@]}"; do
        result=$(cat "$output_file" | grep -w "$name" | awk '{ sum += $NF; count++ } END { if (count > 0) print sum / count }')
        echo "Average for $name: $result" >> "$output_file"
        echo "Average for $name: $result"
    done
    

    IFS=' '
}


function pullTraces() {
  local save_path="${1:-$HOME/benchmarking}"
  adb pull /data/local/traces "$save_path"
}

export CDD_WS_PATH="/local/home/gavinabo/workspace"

function pullAndroidRelease() {
  local workspace="${1:-android_profiling}"
  scp -rp gavinabo@$CDD:$CDD_WS_PATH/$workspace/src/AlexaMobileAndroid/build/apk-prodRelease ~/builds;
  adb install -d ~/builds/apk-prodRelease/AlexaMobileAndroid-prod-arm64-v8a-release.apk
}

pullAndroidPreviewRelease() {
  local workspace="${1:-android_profiling}"
  scp -rp gavinabo@"$CDD":$CDD_WS_PATH/$workspace/src/AlexaMobileAndroid/build/apk-previewRelease ~/builds; 
  adb install -d ~/builds/apk-previewRelease/AlexaMobileAndroid-preview-arm64-v8a-release.apk

}

pullAndroidDebug() {
  local workspace="${1:-android_profiling}"
  scp -rp gavinabo@"$CDD":$CDD_WS_PATH/$workspace/src/AlexaMobileAndroid/build/apk-prodDebug ~/builds; 
  adb install -d ~/builds/apk-prodDebug/AlexaMobileAndroid-prod-arm64-v8a-debug.apk
}

downloadRemoteBuild() {
  local workspace="${1:-android_profiling}"

  scp -rp gavinabo@$CDD:$CDD_WS_PATH/$workspace/src/AlexaMobileAndroid/build/apk-prodDebug ~/builds

  adb install -d ~/builds/apk-prodDebug/AlexaMobileAndroid-prod-arm64-v8a-debug.apk
}

deleteCache() {
  adb shell run-as com.amazon.dee.app ls /data/data/com.amazon.dee.app/cache
}

reverseTunnel() {
  local port="${1:-8081}"
  ssh -fNT -R 8081:localhost:$port gavinabo@$CDD
}

connectRN() {
  reverseTunnel 8081
}

disablePf() {
  while [ 1 ]; do
    sudo pfctl -d;
    sleep 5;
  done
}

tunnel() {
  ssh -fNT -L localhost:8081:localhost:8081 gavinabo@$CDD
}

