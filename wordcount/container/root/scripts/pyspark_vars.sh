#!/usr/bin/env bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[38;5;220m'
NC='\033[0m' # No Color

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function log {
  if [[ $1 = "FAIL" ]]; then
    printf "$RED[FAIL]$NC $2\n"
  elif [[ $1 = "WARN" && -z "$SILENT" ]]; then
    printf "$YELLOW[WARN]$NC $2\n"
  elif [[ $1 = "INFO" && -z "$SILENT" ]]; then
    printf "[INFO] $2\n"
  elif [[ $1 = "PASS" && -z "$SILENT" ]]; then
    printf "$GREEN[PASS]$NC $2\n"
  fi
}

function header {
  echo ""
  echo "**************************"
  echo "* $1"
  echo "**************************"
  echo ""
}

# Load utility bash functions
_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Move to our working directory since this will be called via entrypoint
# cd /spark-app

export TERM='xterm-256color'

# NOTE: Parts of this is borrowed from https://github.com/apache/spark/blob/master/bin/pyspark
# We need this to set our pyspark environment to run unit tests.
# This normally gets invoked by a wrapper script like spark-submit, which abstracts all of this from us.
function bootstrap_pyspark_env() {
  if [ -z "${SPARK_HOME}" ]; then
    export SPARK_HOME="/usr/local/spark"
  fi

  source "${SPARK_HOME}"/bin/load-spark-env.sh
  export _SPARK_CMD_USAGE="Usage: ./bin/pyspark [options]"

  # In Spark 2.0, IPYTHON and IPYTHON_OPTS are removed and pyspark fails to launch if either option
  # is set in the user's environment. Instead, users should set PYSPARK_DRIVER_PYTHON=ipython
  # to use IPython and set PYSPARK_DRIVER_PYTHON_OPTS to pass options when starting the Python driver
  # (e.g. PYSPARK_DRIVER_PYTHON_OPTS='notebook').  This supports full customization of the IPython
  # and executor Python executables.

  # Fail noisily if removed options are set
  if [[ -n "$IPYTHON" || -n "$IPYTHON_OPTS" ]]; then
    echo "Error in pyspark startup:"
    echo "IPYTHON and IPYTHON_OPTS are removed in Spark 2.0+. Remove these from the environment and set PYSPARK_DRIVER_PYTHON and PYSPARK_DRIVER_PYTHON_OPTS instead."
    exit 1
  fi

  # Default to standard python interpreter unless told otherwise
  if [[ -z "$PYSPARK_DRIVER_PYTHON" ]]; then
    PYSPARK_DRIVER_PYTHON="${PYSPARK_PYTHON:-"python"}"
  fi

  WORKS_WITH_IPYTHON=$(python -c 'import sys; print(sys.version_info >= (2, 7, 0))')

  # Determine the Python executable to use for the executors:
  if [[ -z "$PYSPARK_PYTHON" ]]; then
    if [[ $PYSPARK_DRIVER_PYTHON == *ipython* && ! $WORKS_WITH_IPYTHON ]]; then
      echo "IPython requires Python 2.7+; please install python2.7 or set PYSPARK_PYTHON" 1>&2
      exit 1
    else
      PYSPARK_PYTHON=python
    fi
  fi
  export PYSPARK_PYTHON

  # Add the PySpark classes to the Python path:
  export PYTHONPATH="${SPARK_HOME}/python/:$PYTHONPATH"
  export PYTHONPATH="${SPARK_HOME}/python/lib/py4j-0.10.4-src.zip:$PYTHONPATH"

  # Load the PySpark shell.py script when ./pyspark is used interactively:
  export OLD_PYTHONSTARTUP="$PYTHONSTARTUP"
  export PYTHONSTARTUP="${SPARK_HOME}/python/pyspark/shell.py"

  # TODO: Do we need this?
  # For pyspark tests
  # if [[ -n "$SPARK_TESTING" ]]; then
  #   unset YARN_CONF_DIR
  #   unset HADOOP_CONF_DIR
  #   export PYTHONHASHSEED=0
  #   exec "$PYSPARK_DRIVER_PYTHON" -m "$1"
  #   exit
  # fi

  export PYSPARK_DRIVER_PYTHON
  export PYSPARK_DRIVER_PYTHON_OPTS

}

show_spark_env(){
  header "[show_spark_env]"
  log "INFO" "SPARK_HOME=${SPARK_HOME}"
  log "INFO" "SPARK_HOME=${SPARK_HOME}"
  log "INFO" "PYTHONSTARTUP=${PYTHONSTARTUP}"
  log "INFO" "PYTHONPATH=${PYTHONPATH}"
  log "INFO" "PYSPARK_PYTHON=${PYSPARK_PYTHON}"
  log "INFO" "PYSPARK_DRIVER_PYTHON=${PYSPARK_DRIVER_PYTHON}"
  log "INFO" "SPARK_SCALA_VERSION=${SPARK_SCALA_VERSION}"
  log "INFO" "HADOOP_CONF_DIR=${HADOOP_CONF_DIR}"
  log "INFO" "MESOS_DIRECTORY=${MESOS_DIRECTORY}"
  log "INFO" "MESOS_NATIVE_JAVA_LIBRARY=${MESOS_NATIVE_JAVA_LIBRARY}"
  log "INFO" "PATH=${PATH}"
  log "INFO" "JAVA_HOME=${JAVA_HOME}"

}

# Setup spark env vars required to import pyspark w/ python
bootstrap_pyspark_env

# Show us what was set
show_spark_env
