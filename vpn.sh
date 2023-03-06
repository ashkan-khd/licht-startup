#!/bin/bash

set -e

cname="$1"
port="$2"
user="ashkankhd"
pass="a124578"

if [[ $cname == "" ]]; then
    cname="cnl3"
fi


if [[ $port == "" ]]; then
    port="1397"
fi

com="echo \"$pass\" | sudo openconnect $cname.dnsfinde.com:$port --servercert pin-sha256:qgYrqhMY2F/Qai+SvtOZRquKqtCa5yaIZXdMQmV/7rY= --user=$user --passwd-on-stdin
"

eval $com

