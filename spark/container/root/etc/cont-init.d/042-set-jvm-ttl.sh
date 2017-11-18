#!/bin/bash -e

source /scripts/with-bigcontenv

JAVA_SECURITY_FILE=${JAVA_HOME}/jre/lib/security/java.security

# remove any white space
remove_white_space() {
  echo -e "${1}"
}

# test if ttl value input by user is a valid number
test_valid_ttl_value() {
  local re='^[0-9]+$'
  if ! [[ ${2} =~ ${re} ]] ; then
    echo "[set-jvm-ttl] ${1}=${2} is not valid"
    exit 1
  fi
}

# update networkaddress.cache.ttl only if NETWORKADDRESS_CACHE_TTL is set
if [ "${NETWORKADDRESS_CACHE_TTL}" ]; then
  NETWORKADDRESS_CACHE_TTL=`remove_white_space "${NETWORKADDRESS_CACHE_TTL}"`
  test_valid_ttl_value "networkaddress.cache.ttl" "${NETWORKADDRESS_CACHE_TTL}"
  sed -i s/networkaddress.cache.ttl=10/networkaddress.cache.ttl=${NETWORKADDRESS_CACHE_TTL}/ ${JAVA_SECURITY_FILE}
fi

# update networkaddress.cache.negative.ttl only if NETWORKADDRESS_CACHE_NEGATIVE_TTL is set
if [ "${NETWORKADDRESS_CACHE_NEGATIVE_TTL}" ]; then
  NETWORKADDRESS_CACHE_NEGATIVE_TTL=`remove_white_space "${NETWORKADDRESS_CACHE_NEGATIVE_TTL}"`
  test_valid_ttl_value "networkaddress.cache.negative.ttl" "${NETWORKADDRESS_CACHE_NEGATIVE_TTL}"
  sed -i s/networkaddress.cache.negative.ttl=0/networkaddress.cache.negative.ttl=${NETWORKADDRESS_CACHE_NEGATIVE_TTL}/ ${JAVA_SECURITY_FILE}
fi

echo "[set-jvm-ttl] Setting "`grep networkaddress.cache.ttl ${JAVA_SECURITY_FILE}`
echo "[set-jvm-ttl] Setting "`grep networkaddress.cache.negative.ttl ${JAVA_SECURITY_FILE}`
