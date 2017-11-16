#!/bin/bash -e

source /scripts/with-bigcontenv

# Detected container limits
# If found these are exposed as the following environment variables:
#
# - CONTAINER_MAX_MEMORY
#
# This script is meant to be sourced.
#
# This script has been taken from:
# https://github.com/fabric8io-images/java/blob/master/images/jboss/openjdk8/jdk/container-limits


max_memory() {
  # High number which is the max limit until which memory is supposed to be
  # unbounded. 512 TB for now.
  local max_mem_unbounded="562949953421312"
  local mem_file="/sys/fs/cgroup/memory/memory.limit_in_bytes"
  if [ -r "${mem_file}" ]; then
    local max_mem="$(cat ${mem_file})"
    if [ ${max_mem} -lt ${max_mem_unbounded} ]; then
      echo "${max_mem}"
    fi
  fi
}


# =================================================================
# Detect whether running in a container and set appropriate options
# for limiting Java VM resources

# Env Vars evaluated:

# JAVA_OPTIONS: Checked for already set options
# JAVA_MAX_MEM_RATIO: Ratio use to calculate a default maximum Memory, in percent.
#                     E.g. the default value "50" implies that 50% of the Memory
#                     given to the container is used as the maximum heap memory with
#                     '-Xmx'. It is a heuristic and should be better backed up with real
#                     experiments and measurements.
#                     For a good overviews what tuning options are available -->
#                             https://youtu.be/Vt4G-pHXfs4
#                             https://www.youtube.com/watch?v=w1rZOY5gbvk
#                             https://vimeo.com/album/4133413/video/181900266
# Also note that heap is only a small portion of the memory used by a JVM. There are lot
# of other memory areas (metadata, thread, code cache, ...) which adds to the overall
# size. There is no easy solution for this, 50% seems to be are reasonable compromise.
# However, when your container gets killed because of an OOM, then you should tune
# the absolute values
#
# This function has been taken from
# https://github.com/fabric8io-images/java/blob/master/images/jboss/openjdk8/jdk/java-default-options


# Check for memory options and calculate a sane default if not given
optimum_memory() {
# Check for the 'real memory size' and calculate mx from a ratio
# given (default is 50%)
if [ "x$CONTAINER_MAX_MEMORY" != x ]; then
  local max_mem="${CONTAINER_MAX_MEMORY}"
  local ratio=${JAVA_MAX_MEM_RATIO:-50}
  local byte_to_mb_divisor=1048576
  # In the calculation below the total memory that should be allocated to java process is calculated.
  # It multiplies the max_mem (in bytes) with ratio (the value can range from 0 to 100)
  # multiplied 1048576 is 1024 * 1024. In the calculation here, max_mem (in bytes)
  # is multiplied with ratio (the value can range from 0 to 100).
  # It is divided by byte_to_mb_divisor (1048576) which converts mem val in bytes to mb.
  # It is also divided by 100 which converts the ratio value to an actual fraction.
  # And 0.5 is being added to it so that float to integer conversion rounds it off to the integer.
  local mx=$(echo "${max_mem} ${ratio} ${byte_to_mb_divisor}" | awk '{printf "%d\n" , ($1*$2)/(100*$3) + 0.5}')
  echo "${mx}"
fi
}
# JVM_OPTIONS is an optional environment variable that has JVM run options such as -Xmx, -Xms etc.
# Check if explicitly disabled
if [ "x$JAVA_MAX_MEM_RATIO" = "x0" ]; then
  echo "[check-jvm-opts] Exiting check-jvm-opts.sh because JAVA_MAX_MEM_RATIO is 0."
  exit 1
fi

limit="$(max_memory)"

if [ x$limit != x ]; then
  CONTAINER_MAX_MEMORY="$limit"
fi
unset limit

OPTIMUM_JAVA_MAXMEM="$(optimum_memory)"

if [ "x$OPTIMUM_JAVA_MAXMEM" != x ]; then
  if [ "${JVM_OPTIONS}" ]; then
    if [[ $JVM_OPTIONS =~ Xmx([0-9]+)m ]]; then
      USER_PROVIDED_XMX=${BASH_REMATCH[1]}
        if [ ${OPTIMUM_JAVA_MAXMEM} -lt ${USER_PROVIDED_XMX} ]; then
          echo "[check-jvm-opts][WARNING] Xmx option for this java app should not be more than ${OPTIMUM_JAVA_MAXMEM} MB to run in this container."
        fi
    else
      JVM_OPTIONS="${JVM_OPTIONS} -Xmx${OPTIMUM_JAVA_MAXMEM}m"
      echo "[check-jvm-opts] Xmx option is not set. Appending Xmx option as ${OPTIMUM_JAVA_MAXMEM} MB."
    fi
  else
    export JVM_OPTIONS="-Xmx${OPTIMUM_JAVA_MAXMEM}m"
  fi
  echo "[check-jvm-opts] Using JVM_OPTIONS as ${JVM_OPTIONS}"
else
  echo "[check-jvm-opts] JVM_OPTIONS not set"
fi


s6-dumpenv -- /var/run/s6/container_environment