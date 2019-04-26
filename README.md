# Definitions of Unreliable Data

In the event that all data from a particular section, of a given dataset 100% matches the definition, then it matches the definition.

## funCreator.sh
Creates isdataType function for bash, just supply dataType name and regex definition
```
bash funCreator.sh latlong "(^$|^[-]*[0-1]{0,1}[0-9]{1,2}[\.]{1,1}[0-9]{0,7}$)"
```

# Basic:
Starting Definitions for the most basic things.
```
String: "^.+$"
Number: "^[0-9,]+$"
Null "^$"
```
## String Subtypes
Narrowing
```
Word? Dictionary Check: "[A-Za-z]"
```
## Computable Number Subtypes
Narrowing
```
Positive Integer: "^[+]*[0-9]+$"
With Null: "^[+]*[0-9]+$|^$"
Negative Integer: "^-[0-9]+$"
```
## Space
```
Latitude: '^[-]*[0-9]{1,2}[\.]{1,1}[0-9]{0,7}$'
With Null: '(^$|^[-]*[0-9]{1,2}[\.]{1,1}[0-9]{0,7}$)'
Latitude: '^[-]*[0-1]{0,1}[0-9]{1,2}[\.]{1,1}[0-9]{0,7}$'
With Null: '(^$|^[-]*[0-1]{0,1}[0-9]{1,2}[\.]{1,1}[0-9]{0,7}$)'
```
## Time
Precise times, relative and absolute
```
Time of Day: '^[0-2]{1,1}[0-9]{1,1}:[0-5]{1,1}[0-9]{1,1}:[0-5]{1,1}[0-9]$'
Unix Epoch Time: '^[0-9]{1,10}$'
```

### Date and DateTime
Dates, Dates Coupled with times
```
4Year-2Month-2day: "^[0-9]{4,4}-[0-1]{1,1}[0-9]{1,1}-[0-3]{1,1}[0-9]{1,1}$"
4Year-2Month-2Day 2hour:2Minute:2Second "^[0-9]{4,4}-[0-1]{1,1}[0-9]{1,1}-[0-3]{1,1}[0-9]{1,1} [0-2]{1,1}[0-9]{1,1}:[0-5]{1,1}[0-9]{1,1}:[0-5]{1,1}[0-9]$"
```
