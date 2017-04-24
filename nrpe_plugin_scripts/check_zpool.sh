#!/bin/bash
#
# check_zpool: Check status and health of a zpool and return data in an NRPE
#   friendly way.
#
# NRPE Exit Codes: 0 == OK, 1 == Warning, 2 == Critical, 3 == Unknown
#
###############################################################################
# Variable Settings:
#ZPOOL_CMD=/sbin/zpool

#Mode: scrub
SCRUB_FREQUENCY=10    # define the number of days that pool scrubs are expected to run by (10 days is default).

# health



function usage() {
# display help info and then exit
cat << USAGE
  Usage: $0 {-m MODE} {-p POOL}
    Options:
      -h: This helpful information.
      -m: Mode [requires a mode to be defined.]
      -p: Pool [requires a zpool name.]

    Modes:
        scrub:  scrub status
        health: zpool health status
USAGE
exit $exit_code
}

function check_pool_health() {
# is the pool healthy ? tell me and exit accordingly.
CHECK_ZPOOL=`/sbin/zpool status $POOL | egrep 'state|errors' | grep -v scan` >/dev/null 2>&1
HEALTH=`echo $CHECK_ZPOOL | grep state | awk {'print $2'}`
#ERRORS=`echo $CHECK_ZPOOL | grep errors | cut -d ':' -f 2`
ERRORS=`echo $CHECK_ZPOOL | awk {'print $3" "$4" "$5" "$6" "$7" "$8" "$9" "$10" "}'`

## debug ##
echo 'start debug'
echo $HEALTH
echo $ERRORS
echo 'end debug'

# process logic:
  if [[ $HEALTH == 'ONLINE' ]]; then
    if [[ $ERRORS == 'No known data errors' ]]; then
      echo "Zpool Health Check: Pool=$POOL Health=$HEALTH Errors=$ERRORS"
      exit 0
    else
      echo "Zpool Health Check: Pool=$POOL Health=$HEALTH Errors=$ERRORS"
      exit 0
    fi
  elif [[ $HEALTH == 'DEGRADED' ]]; then
    echo "Zpool Health Check: Pool=$POOL Health=$HEALTH Errors=$ERRORS"
    exit 1
  else
    echo "Zpool Health Check: Pool=$POOL Health=$HEALTH Errors=$ERRORS"
    exit 2
  fi
}

function check_scrub_status() {
  # what is the scrub status. Has a scrub happened in X number of days ?
  # todo: Write this part. (ideas avail;able at https://calomel.org/zfs_health_check_script.html )
  SCRUB_EXPIRE=`expr ${SCRUB_FREQUENCY} \* 3600`
  SCRUB_STATE=`/sbin/zpool  status $POOL | grep scan`
  if [[ `$SCRUB_STATE | cut -d ':' -f 2` == 'none requested' ]]; then
    echo "Zpool Scrub Check: [No scrub has been requested. Please request one]."
    exit 1
  fi

  echo $SCRUB_STATE | egrep 'scrub in progress|resilver' >/dev/null 2>&1
  if [[ $? == 0 ]]; then
    echo "Zpool Scrub Check: [Scrub in progress.] Message: [$SCRUB_STATE]."
    exit 0
  fi

  SCRUB_RAW_DATE=`/sbin/zpool  status $POOL grep scrub | awk '{print $11" "$12" " $13" " $14" "$15}'`
  SCRUB_DATE=`date -d SCRUB_RAW_DATE +%s`
  CURRENT_DATE=`date -d +%s`
  SCRUB_ELASPE=`expr $CURRENT_DATE - $SCRUB_STATE`

  if [[ $SCRUB_ELASPE -le $SCRUB_EXPIRE ]]; then
    echo "Zpool Scrub Check: [Last Scrub date: [$SCRUB_RAW_DATE]."
    exit 1
  else
    echo "Zpool Scrub Check: [Last Scrub date: [$SCRUB_RAW_DATE]."
    exit 0
  fi
}

function run_checks() {
# check that variables exist
if [[ -z $POOL ]]; then
  echo "No Zpool was defined."
  exit_code=3
  usage
fi

if [[ -z $MODE ]]; then
  echo "No Mode was defined."
  exit_code=3
  usage
fi


if [[ `whoami` != 'root' ]]; then
  echo "You must be this root to ride."
  exit_code=3
  usage
fi

# process options and run checks
if [[ $MODE == 'health' ]]; then
  check_pool_health
elif [[ $MODE == 'scrub' ]]; then
  check_scrub_status
else
  echo "Unsupported Mode: [$MODE]."
  exit 3
fi
}

while getopts hm:p: OPTION
do
  case $OPTION in
    h) exit_code=0 ; usage ;;
    m) MODE=$OPTARG ;;
    p) POOL=$OPTARG ;;
  esac
done

run_checks