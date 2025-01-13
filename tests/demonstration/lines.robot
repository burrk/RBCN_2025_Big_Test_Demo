*** Comments ***
Based on:
https://github.com/Snooz82/robotframework-datadriver/blob/main/atest/TestCases/Defaults/PICT/pict_arguments.robot

*** Settings ***
Library             DataDriver    file=${TESTFILE}     encoding=utf-16   dialect=excel-tab

Test Template       Check Variables

*** Variables ***
${TESTFILE}=    data/3360_lines.csv

*** Test Cases ***
# ${Type}_${Size}_${Format method}_${File system}_${Cluster size}_${Compression}   
# ...    RAID-5   1000   Quick   FAT32   16384   On
T${Line}
...    0   NODATA   NODATA   NODATA   NODATA   NODATA   NODATA

*** Keywords ***
Check Variables
    [Arguments]    ${Line}  ${Type}    ${Size}    ${Format method}    ${File system}    ${Cluster size}    ${Compression}

    Set Test Documentation   
    ...    ${Type} ${Size} ${Format method} ${File system} ${Cluster size} ${Compression}

    # sleep   1s
    Pass Execution   OK
