*** Comments ***
Based on:
https://github.com/Snooz82/robotframework-datadriver/blob/main/atest/TestCases/Defaults/PICT/pict_arguments.robot

*** Settings ***
Library             DataDriver    file=${TESTFILE}     
...                               encoding=utf-16   dialect=excel-tab  # use appropriate values
...                               reader_class=my_slice_reader.py
...                               slice=${SLICE}                       # arguments for custom reader
...                               num_slices=${NUM_SLICES}
Test Template       Check Variables

*** Variables ***
${TESTFILE}=    data/56_tests.csv
${SLICE}=       1
${NUM_SLICES}=  1

*** Test Cases ***
T${Line}    0   NODATA   NODATA   NODATA   NODATA   NODATA   NODATA

*** Keywords ***
Check Variables
    [Arguments]    ${Line}  ${Type}    ${Size}    ${Format method}    ${File system}    ${Cluster size}    ${Compression}

    Set Test Documentation   
    ...    ${Type} ${Size} ${Format method} ${File system} ${Cluster size} ${Compression}

    # sleep   1s
    Pass Execution   OK
