#! /bin/bash

# * Copyright (c) 2016, Jim Sher
# * All rights reserved.
# * Redistribution and use in source and binary forms, with or without
# * modification, are permitted provided that the following conditions are met:
# *
# *     * Redistributions of source code must retain the above copyright
# *       notice, this list of conditions and the following disclaimer.
# *     * Redistributions in binary form must reproduce the above copyright
# *       notice, this list of conditions and the following disclaimer in the
# *       documentation and/or other materials provided with the distribution.
# *     * Neither the name of the author, Machtelt Garrels, nor the
# *       names of its contributors may be used to endorse or promote products
# *       derived from this software without specific prior written permission.
# *
# * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS "AS IS" AND ANY
# * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# * DISCLAIMED. IN NO EVENT SHALL THE AUTHOR AND CONTRIBUTORS BE LIABLE FOR ANY
# * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

LCYAN='\033[1;36m'
LRED='\033[1;31m'
REGEX='^\s*((25[0-5]|2[0-4][0-9]|1?([0-9]){1,2})\.){3}((25[0-5]|2[0-4][0-9]|1?([0-9]){1,2}))\s*$'
COUNT=0

check(){
        [[ $IP =~ $REGEX ]] && lookup || reask
}

ask(){
        echo -e "${LCYAN} Enter IPv4 Address and press [ENTER]:\e[0m"
        read IP
        check
}

reask(){
        unset IP
        if [ $COUNT -eq 2 ]; then
                echo -e "${LRED} IPv4 Address format is  xxx.xxx.xxx.xxx where \"xxx\" is a number from 0 to 255."
                COUNT=`expr $COUNT + 1`
                ask
        elif [ $COUNT -eq 3 ]; then
                echo -e "${LRED} Please take this seriously."
                exit 1
        else
                echo -e "${LRED} NOT a valid IPv4 address."
                COUNT=`expr $COUNT + 1`
                ask
        fi
}

lookup(){
        echo $IP >> /usr/local/bin/whois/ip.log
        whois $IP | grep -Ei --color 'netname|inetnum|country|CIDR|inetnumup|descr|^route|^organization'
}

ask

exit 0
