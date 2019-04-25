#!/bin/bash - 
#===============================================================================
#
#          FILE: egrepFun.sh
# 
#         USAGE: ./egrepFun.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 04/25/2019 14:07
#      REVISION:  ---
#===============================================================================

##set -o nounset                              # Treat unset variables as an error


function csvcount () { head -n1 "$@" | grep -o , | tr -d "\n" | wc -c; }

function prepCsv() {
    file=$1
    csvcols=$( csvcount $file | tr -d ' \t')
    #echo $csvcols
    for i in $(seq 1 $csvcols)
    do
        rqc $1 | awk -F, -v colnumber=$i '{print $colnumber}'  | tail -n+2 > col$i
        prepMetaData $i
    done
}
function prepMetaData() {
    awk '{ print length }' col$1 | sort | uniq -c > collength$1
}
function dataTypesCsv() {

    file=$1
    csvcols=$( csvcount $file | tr -d ' \t')
    #echo $csvcols
    total=$(wc -l col$i | tr -d ' \t')
    for i in $(seq 1 $csvcols)
    do
        #echo $i
        #echo $csvcols

        number=$( isnumber col$i | tr -d ' \t') 
        #echo $number
        #echo $total
        if [[ "$number" -eq "$total" ]]; then
            echo "Col $i is number"
        else

                hw=$( haswhitespace <( head col$i) | tr -d ' \t' )
            if [[ "$hw" -eq 9 ]]; then
                dtTest=$( isdatetime <( head col$i) | tr -d ' \t' )
                #echo $dtTest
                if [[ "$dtTest" -eq 9 ]]; then

                    dt=$( isdatetime col$i | tr -d ' \t' )
                    if [[ "$dt" -eq "$total" ]]; then
                        echo "Col $i is DateTime"
                    fi
                fi
            fi
        fi
    done
}

function isnumber() {
    egrep -c "^[0-9,\.]+$" $1    
}
function haswhitespace() {
    egrep -c "( |\t)" $1
}

function isdatetime() {
    egrep -c "^[0-9]{4,4}-[0-1]{1,1}[0-9]{1,1}-[0-3]{1,1}[0-9]{1,1} [0-2]{1,1}[0-9]{1,1}:[0-5]{1,1}[0-9]{1,1}:[0-5]{1,1}[0-9]$" $1
}
