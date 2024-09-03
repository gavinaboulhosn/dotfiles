####### ALEXA #########
alias watchme='brazil-build build-watch' ## for elements packages
alias android="open -a /Applications/Android\ Studio.app"
alias androidtunnel='adb reverse tcp:8081 tcp:8081'
alias iosbuild="brazil-recursive-cmd 'brazil-build xcode-env'"

####### AMHS ########
alias register_with_aaa='/apollo/env/AAAWorkspaceSupport/bin/register_with_aaa.py -a AlexaMobileHomeService'
alias register_with_keymaster='/apollo/bin/env -e KeyMasterDaemonWorkspaceSupport cli.py -a AlexaMobileHomeService --start'
alias start_amhs='register_with_aaa && register_with_keymaster'

###### BRAZIL #######
alias bb=brazil-build
alias bba='brazil-build apollo-pkg'
alias bre='brazil-runtime-exec'
alias bbe='brazil-build-tool-exec'
alias brc='brazil-recursive-cmd'
alias bws='brazil ws'
alias bwsuse='bws use --gitMode -p'
alias bwscreate='bws create -n'
alias bbr='brc brazil-build-rainbow'
alias bball='brc --allPackages'
alias bbb='brc --allPackages brazil-build'
alias bbra='bbr apollo-pkg'
alias bwsm='brazil ws --sync --md'
alias cleanup="$HOME/.toolbox/bin/brazil-package-cache clean"
alias sam='brazil-build-tool-exec sam'
alias work='cd ~/workplace'
alias buildup='brc -- brazil-build build:distribute'
alias show='brazil ws show'

######### Workspace operations #########
alias bvs='brazil workspace --use --versionSet'
alias package='brazil workspace --use --package'
alias rpackage='brazil workspace --remove --package'
alias p='package'
alias rp='rpackage'
alias bbxe='bball brazil-build xcode-env'
alias nuke='bws clean; bwsm; bbxe'
