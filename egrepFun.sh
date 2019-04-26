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

one=1
function csvcount () { head -n1 "$@" | grep -o , | tr -d "\n" | wc -c; }

function prepCsv() {
    file=$1
    csvcols=$( csvcount $file | tr -d ' \t')
    twoCsvcols=$((csvcols += 1))
    head -n1 $file | rqc > header
    #echo $csvcols
    rm -rf cols

    echo "{" > metaData.json
    echo "\"columns\": [" >> metaData.json
    for i in $(seq 1 $twoCsvcols)
    do
        rqc $1 | awk -F, -v colnumber=$i '{print $colnumber}'  | tail -n+2 > col$i
        prepMetaData $i 
        dataTypesCsv $i >> cols
        prepJson $i > metaData$i.json
        prepJson $i >> metaData.json
        echo "," >> metaData.json
    done
    sed -i '$s/,$//' metaData.json
    echo "]}" >> metaData.json

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
    cname=$(awk -F, -v name="$1" '{print $name}' header)
    dtype=$( grep "Col $i" cols | egrep -o "[A-Za-z]+$"  | tail -n1)
    totalCols=$(echo "\"total\": \"\"")
    echo "{"
    echo "  \"column\": \"$cname\","
    echo "    \"data\": ["
    echo "      {"
    echo "        \"column\": \"$cname\","
    echo "        \"columnNumber\": \"$1\","
    echo "        \"dataType\": \"$dtype\","
    echo "        \"length\": {"
    echo "          $max"
    echo "          $min"
    echo "          $totalCols"
    echo "          }"
    echo "     }"
    echo "   ]"
    echo "}"

}

function dataTypesCsv() {
    i=$1

    total=$(  wc -l col$i | egrep -o '[0-9]+' |  head -n1 |tr -d ' \t')
    if isnumber col$i "10" ; then
        if isnumber col$i $total; then
            echo "Col $i is integer"
        fi
    elif haswhitespace col$i 10; then
        if isdatetime col$i 10; then

            if isdatetime col$i $total; then
                echo "Col $i is DateTime"
            fi
        fi
    elif haspunc col$i 10; then
        echo "Col $i Has Punc"
    fi
}

function isnumber() {

    if [[ "$2" -eq 10 ]]; then 

        count=$(egrep -c "^[0-9,\.]+$" <( head $1) | tr -d ' \t')
    else

        count=$(egrep -c "^[0-9,\.]+$" $1  | tr -d ' \t')
    fi
    if [[ "$count" -eq "$2" ]]; then
        return 0
    else
        return 1
    fi

}
function haswhitespace() {
    if [[ "$2" -eq 10 ]]; then 

        count=$(egrep -c "( |\t)" <( head $1) | tr -d ' \t')
    else

        count=$(egrep -c "( |\t)" $1  | tr -d ' \t')
    fi
    if [[ "$count" -gt 0 ]]; then
        return 0
    else
        return 1
    fi
}

function haspunc() {
    if [[ "$2" -eq 10 ]]; then 

        count=$(egrep -c "[:punct:\.]" <( head $1) | tr -d ' \t')
    else

        count=$(egrep -c "[:punct:\.]" $1  | tr -d ' \t')
    fi
    if [[ "$count" -gt 0 ]]; then
        return 0
    else
        return 1
    fi
}

function isdatetime() {

    if [[ "$2" -eq 10 ]]; then 
        count=$(egrep -c "^[0-9]{4,4}-[0-1]{1,1}[0-9]{1,1}-[0-3]{1,1}[0-9]{1,1} [0-2]{1,1}[0-9]{1,1}:[0-5]{1,1}[0-9]{1,1}:[0-5]{1,1}[0-9]$" <( head $1) )
    else
        count=$(egrep -c "^[0-9]{4,4}-[0-1]{1,1}[0-9]{1,1}-[0-3]{1,1}[0-9]{1,1} [0-2]{1,1}[0-9]{1,1}:[0-5]{1,1}[0-9]{1,1}:[0-5]{1,1}[0-9]$" $1)
    fi
    if [[ "$count" -eq "$2" ]]; then
        return 0
    else
        return 1
    fi



}
