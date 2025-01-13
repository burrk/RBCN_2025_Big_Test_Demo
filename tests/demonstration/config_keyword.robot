*** Comments ***
Based on:
https://github.com/Snooz82/robotframework-datadriver/blob/main/atest/TestCases/Defaults/PICT/pict_arguments.robot

*** Settings ***
Library             Collections
Library             OperatingSystem
Library             String
Library             DataDriver    file=${TESTFILE}     
...                               encoding=utf-16   dialect=excel-tab  # use appropriate values
...                               config_keyword=Config
Test Template       Check Variables

*** Variables ***
${TESTFILE}=    data/281_tests.csv
${SLICE}=       1
${NUM_SLICES}=  1

*** Test Cases ***
${Type}_${Size}_${Format method}_${File system}_${Cluster size}_${Compression}
...    NODATA   NODATA   NODATA   NODATA   NODATA   NODATA

*** Keywords ***
Check Variables
    [Arguments]    ${Type}    ${Size}    ${Format method}    ${File system}    ${Cluster size}    ${Compression}
    Pass Execution   OK

Config
    [Arguments]    ${config}
    [Documentation]  This test case reads a file and writes every fifth line to a new file.
    ...
    ${contents}=   Get File  ${config}[file]  encoding=${config}[encoding]
    @{lines}=      Split To Lines  ${contents}
    @{output}=     Create List     ${lines}[0]
    ${output}=     Combine Lists   ${output}   ${lines}[${SLICE}::${NUM_SLICES}]  # start=0 would be titles

    ${tmp_file}=   Evaluate  tempfile.NamedTemporaryFile(delete=False).name  modules=tempfile
    Create File    ${tmp_file}.csv   ${{'\n'.join($output)}}   encoding=${config}[encoding]
    Set To Dictionary   ${config}   file   ${tmp_file}.csv
    RETURN   ${config}
