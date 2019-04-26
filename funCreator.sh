#!/bin/bash - 
#===============================================================================
#
#          FILE: funCreator.sh
# 
#         USAGE: ./funCreator.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 04/26/2019 10:46
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
name=$1
regex=$2

#function haspunc() {
#    if [[ "$2" -eq 10 ]]; then 
#
#        count=$(egrep -c "[:punct:\.]" <( head $1) | tr -d ' \t')
#    else
#
#        count=$(egrep -c "[:punct:\.]" $1  | tr -d ' \t')
#    fi
#    if [[ "$count" -gt 0 ]]; then
#        return 0
#    else
#        return 1
#    fi
#}



cat <<EOF >> newfun.sh
function is$name() {

    if [[ "\$2" -eq 10 ]]; then 
        count=\$(egrep -c "$regex" <( head \$1) )
    else
        count=\$(egrep -c "$regex" \$1)
    fi
    if [[ "\$count" -eq "\$2" ]]; then
        return 0
    else
        return 1
    fi



}
EOF
