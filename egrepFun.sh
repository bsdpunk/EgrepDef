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
    head -n1 $file | rqc > header
    #echo $csvcols
    for i in $(seq 1 $csvcols)
    do
        rqc $1 | awk -F, -v colnumber=$i '{print $colnumber}'  | tail -n+2 > col$i
        prepMetaData $i
        prepJson $i > metaData$1.json
    done
}
function prepMetaData() {
prepLengthData $1
}
function prepLengthData() {

    awk '{ print length }' col$1 | sort | uniq -c | sort -rnk2 > collength$1
}
function prepJson() {
       
    max=$(head -n1 collength$1 | gsed 's/^[ 0-9]\+ /"max": "/' | sed 's/$/",/')
    min=$(tail -n1 collength$1 | gsed 's/^[ 0-9]\+ /"min": "/' | sed 's/$/",/')
    cname=$(awk -F, -v name="$1" '{print $1}' header)
    totalCols=$(echo "\"total\": \"\"")
    echo "{"
    echo '  "metadata":'
    echo "    ["
    echo "      {"
    echo "        \"column\": \"$cname\","
    echo "        \"length\": {"
    echo "          $max"
    echo "          $min"
    echo "          $totalCols"
    echo "          }"
    echo "}]}"

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
