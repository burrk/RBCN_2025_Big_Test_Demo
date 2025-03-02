*** Comments ***
Based on:
https://github.com/Snooz82/robotframework-datadriver/blob/main/atest/TestCases/Defaults/PICT/pict_arguments.robot

*** Settings ***
Library             DataDriver    file=${TESTFILE}     encoding=utf-16   dialect=excel-tab

Test Template       Check Variables

*** Variables ***
${TESTFILE}=    data/56_tests.csv

*** Test Cases ***
Combination:__${Type}__${Size}__${Format method}__${File system}__${Cluster size}__${Compression}
...    NODATA   NODATA   NODATA   NODATA   NODATA   NODATA

*** Keywords ***
Check Variables
    [Arguments]   ${Type}   ${Size}   ${Format method}   ${File system}    ${Cluster size}    ${Compression}
    sleep   1s
    Pass Execution   OK
