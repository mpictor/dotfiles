#!/bin/bash

script_dir=$(dirname $(realpath $(which $0)))

#ugly ugly fonts
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on"

err_usage(){
  cat <<EOU
use: $0 ip username password
   all parameters are optional
   works with some (all?) ATEN and AMI implementations.
   while this can detect Avocent implementations, support is incomplete and broken.
if $script_dir/.ipmi-defaults exists, it is sourced.
   .ipmi-defaults example:
DEF_HOST=myipmi.example.com
DEF_ATEN_USER=ADMIN
DEF_ATEN_PW=ADMIN
DEF_AVO_USER=admin
DEF_AVO_PW=password
DEF_AMI_USER=admin
DEF_AMI_PW=1234

EOU
exit 1
}

dump=0
if [[ $1 == "-d" ]]; then
  shift
  echo "dumping jnlp, not running java"
  dump=1
fi

if [[ -f $script_dir/.ipmi-defaults ]]; then
  source $script_dir/.ipmi-defaults
fi

#default host ip
HOST=${1:-$DEF_HOST}

ping -c1 $HOST || err_usage

if [[ $dump -eq 0 ]]; then
  jnlp=$(mktemp)
else
  jnlp=/dev/stderr
fi

home=$(curl "http://${HOST}")
rc=$?
if [ $rc -ne 0 ]; then
  echo "curl error $rc, retry with ip from /etc/hosts..."
  ip=$(grep ' $HOST$' /etc/hosts|cut -d ' ' -f1)
  if [ "x$ip" == "x" ]; then
    echo "error, exiting"
    exit 1
  fi
  HOST=$ip
  home=$(curl "http://${HOST}")
  rc=$?
fi
if [ $rc -ne 0 ]; then
  echo "curl exited with $rc... you may need to use a FQDN to make it happy"
  exit $rc
fi
if grep -q "ATEN International Co Ltd" <<<"$home" ; then
  echo "detected ATEN implementation"
  #some supermicro use ATEN
  #derived from https://gist.github.com/DavidWittman/10748460
  USER=${2:-$DEF_ATEN_USER}
  PASS=${3:-$DEF_ATEN_PW}
  SESSION_ID=$(curl -s "http://${HOST}/cgi/login.cgi" --data "name=${USER}&pwd=${PASS}" -i | awk '/SID=[^;]/ { print $2 }')
  URL="http://${HOST}/cgi/url_redirect.cgi?url_name=ikvm&url_type=jwsk"
  # Some versions of the SuperMicro webserver return a 500 w/o the referer set
  # The sed is to fix the "no iKVM64 in java.library.path" bug on Linux. Source: http://blog.coffeebeans.at/?p=83
  curl -s "${URL}" -H 'Referer: http://localhost' -H "Cookie: ${SESSION_ID}" 2>/dev/null | sed 's/Linux" arch="a.*/&\n    <property name="jnlp.packEnabled" value="true"\/>\n    <property name="jnlp.versionEnabled" value="true"\/>/' >$jnlp
else
  curl -kL "http://${HOST}" 2>/dev/null | grep -q "Avocent Corporation"
  if [ $? -eq 0 ]; then
    echo "detected Avocent implementation"
    echo "not fully implemented!!!"
    USER=${2:-$DEF_AVO_USER}
    PASS=${3:-$DEF_AVO_PW}
    auth="user=$USER&password=$PASS"
   curl -kL --data "$auth" https://$HOST/data/login -D h -o b
    curl -kL --cookie Cookie=SessionCookie=$COOKIE "https://$HOST/data?type=jnlp&get=vmStart($HOST@0@$(date +%s)" -o $jnlp 2>/dev/null
     echo "Avocent not supported";rm $jnlp;exit
  else
    #http://stackoverflow.com/questions/26160165/supermirco-ipmi-kvm-remote-connection-without-webbrowser/28040677#28040677
    echo "detected AMI implementation"
    #intel s2400ep uses this
    USER=${2:-$DEF_AMI_USER}
    PASS=${3:-$DEF_AMI_PW}
    auth="WEBVAR_USERNAME=$USER&WEBVAR_PASSWORD=$PASS"
    COOKIE=`curl --data "$auth" http://$HOST/rpc/WEBSES/create.asp 2> /dev/null | grep SESSION_COOKIE | cut -d\' -f 4`
    curl --cookie Cookie=SessionCookie=$COOKIE http://$HOST/Java/jviewer.jnlp -o $jnlp 2>/dev/null
  fi

fi

if [[ $dump -eq 0 ]]; then
  (javaws $jnlp >/dev/null 2>&1; rm $jnlp) &
fi
