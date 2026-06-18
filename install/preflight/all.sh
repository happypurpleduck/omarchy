source $OMARCHY_INSTALL/preflight/guard.sh
source $OMARCHY_INSTALL/preflight/begin.sh
run_logged $OMARCHY_INSTALL/preflight/show-env.sh
run_logged $OMARCHY_INSTALL/preflight/migrations.sh
run_logged $OMARCHY_INSTALL/preflight/first-run-mode.sh
[[ -f $OMARCHY_INSTALL/personal/preflight/all.sh ]] && source $OMARCHY_INSTALL/personal/preflight/all.sh
