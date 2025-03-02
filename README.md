HELP! My Test Suite is too BIG for my PABOT!
============================================

## Or: How to fun with too many tests!


This presentation gives examples of some problems and possible solutions.

Every so often someone in Slack or the Forum asks how to run extremely large test suites in parallel using [Pabot] (a parallel test runner for RF). This demo will demonstrate problems we have run into and solutions using [Pabot] and the [DataDriver] (extension to RF to run data driven tests from data files).

The demo is not intended to complain about [Pabot] or the [DataDriver], but to mention some of the challenges with large test suites, and hopefully inspire people to create even better tests using these tools!

It will also introduce several techniques to reduce the number of test cases while increasing test effectiveness.

### Intro...

   #### Challenge

   * It can be easy to have a combinatorial explosions of possible tests, *especially* when filling out forms
   * Some projects also have requirements where they must prove that everything works exactly as promised.
   * However, you can use scripts or other tools to automatically generate data driven testcases!
   * Robot Framework's [DataDriver] makes it easy to run these tests and 
   * [Pabot] makes it easy to run tests in parallel reducing the execution time
   * Nonetheless, a combinatorial explosion may have thousands and thousands of tests and there are limits to space-time, like the life time of the universe, that get in the way This demo will discuss some of things I have used solve this


   #### Our Problem

   * This demo has code examples inspired by issues we had in a project while trying to test software for importing lots of different products from all the different countries.
   * You can imagine all the thousands of combinations of products, countries, treaties and comsumer protection laws.
   * The rules for countries change depending on political spats - and there can't be mistakes because some products will not last if badly tied up at borders.

   This demo is not long enough to go into very much depth, but I hope it will give you some ideas you can research further to solve your specific problems. There will also be links in these notes to help
   
### 1. [DataDriver], [Pabot] and [PICT]
   #### Sample Data

   * Instead of using our project data a standard example for Microsoft's [PICT] test case generation tool will be used because the model: 
   [data/pict_arg.pict](https://github.com/burrk/RBCN_2025_Big_Test_Demo/blob/main/data/pict_arg.pict) 
   is easier to understand what all the combinations are than looking at the CSV file: 
   [data/3360_tests.csv](https://github.com/burrk/RBCN_2025_Big_Test_Demo/blob/main/data/3360_tests.csv)
   * These are different ways of configuring a hard drive in windows. Many of the combinations are not valid and could have been removed with rules. However the actual data is not really important to the demo, so the rules were left out for simplicity.
   * [PICT] was used specifically because it is easy to generate test data with, and the [DataDriver] can call it directly. However, the generated CSV files will be used in the examples because that is what people are most accustomed to.
   * There are 3360 exhaustive testcases, but I will typically use smaller sets.

   #### [DataDriver]

   * explain csv_data_driver.robot
   * EXPLAIN TESTCASE NAME
   * When running examples I'm not going to use any argument files so you can see all the options.


```shell
robot --outputdir results --variable TESTFILE:data\56_tests.csv --suite csv_data_driver .
```

file:///D:/VSCode/Robocon2025/results/report.html

c. [Pabot]

* Must use --testlevelsplit otherwise test suite runs in a single process
* *add 1 second delay - explain wait is for tests to run*

```shell
pabot --verbose --processes 10 --testlevelsplit -d results -v TESTFILE:data\56_tests.csv -s sleepy_data_driver .
```

file:///D:/VSCode/Robocon2025/results/report.html

2. Demo "The command line is too long"

```shell
pabot --verbose --processes 2 --testlevelsplit -d results -v TESTFILE:data\281_tests.csv -s csv_data_driver .
```

* The [DataDriver], [Pabot], and Robot do not have to communicate via the command line, that is just the default.
* You could create a custom [DataDriver] which passes the testcases to [Pabot] using a different mechanism (even while tests are running) But not documented and we will limit ourselves to what can be done in Robot code

3. Reduce size with...
   * increase number of processes

```shell
pabot --processes 5 --testlevelsplit -d results -v TESTFILE:data\281_tests.csv -s csv_data_driver .
pabot --processes 20 --testlevelsplit -d results -v TESTFILE:data\3360_tests.csv -s csv_data_driver .
```

* Shorter suite name
* run robot file directly so no suite hierarchy
  ```shell
  pabot --verbose --processes 2 --testlevelsplit -d results -v TESTFILE:data\281_tests.csv .\tests\demonstration\lines.robot
  ```
* Move descrptive name to test documentation
* Add line numbers

```shell
pabot --verbose --processes 2 --testlevelsplit -d results -v TESTFILE:data\281_lines.csv .\tests\demonstration\lines.robot
pabot --processes 5 --testlevelsplit -d results -v TESTFILE:data\3360_lines.csv .\tests\demonstration\lines.robot
```

file:///D:/VSCode/Robocon2025/results/report.html

```
pabot --verbose --processes 2 --testlevelsplit -d results -v TESTFILE:data\281_tests.csv -s csv_data_driver .
pabot --processes 10 --testlevelsplit -d results -v TESTFILE:data\3360_tests.csv -s csv_data_driver .
pabot --processes 10 --testlevelsplit -d results -v TESTFILE:data\3360_lines.csv .\tests\demonstration\lines.robot
pabot --verbose --processes 6 --testlevelsplit -d results -v TESTFILE:data\281_lines.csv  -s lines .
```

4. Increase processes by running on more machines
   a. Break data into smaller files That can be a pain manually and takes away the advantage of easily generating TCs with models You could automatically split your automatically generated test data before running pabot on each server...
   b. [Pabot] has "--shard [SHARD]/[SHARD COUNT]" to break up test suites

```shell
pabot --processes 2 --testlevelsplit --shard 1/5 -d results -v TESTFILE:data\56_tests.csv  -s csv_data_driver .
```

but [Pabot] initially treats a [DataDriver] suite as a single test [Pabot] breaks the test cases into shards before the [DataDriver] expands the data driven testcases

c. Use a Pre-run modifier that selects only every Xth test for execution
From User Guide:
[https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#example-select-every-xth-test](https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#example-select-every-xth-test)

```shell
pabot --processes 2 --testlevelsplit --prerunmodifier .\tests\demonstration\SelectEveryXthTest.py:5:0 -d results -v TESTFILE:data\56_tests.csv  -s csv_data_driver .
```

* Have to use proper path
  NOTE: This also runs before the [DataDriver] generates test cases ALTHOUGH PreRunModifiers can still be very useful in other cases.
  ```mermaid
  sequenceDiagram
     Pabot->>Robot: Pre-runs test cases
     Robot->>Robot: Runs PreRunMmodifiers
     Robot->>DataDriver: Testsuite is loaded
     DataDriver-->>Robot: Generates more test cases
     Robot-->>Pabot: These are the testcases
     DataDriver-->>Pabot: Here are some more
     Pabot->>Robot: Sends TCs to multiple Robots
     Robot->>SUT: Runs test cases
  ```

d. Use a Config_Keyword: [https://github.com/Snooz82/robotframework-datadriver?tab=readme-ov-file#configure-datadriver-by-pre-run-keyword](https://github.com/Snooz82/robotframework-datadriver?tab=readme-ov-file#configure-datadriver-by-pre-run-keyword)

* Allows you to programically change/set the datadriver's configuration
* You could also use it to dynamically create testcases...

```shell
pabot --processes 2 --testlevelsplit -d results -v SLICE:5 -v NUM_SLICES:5 -v TESTFILE:data\56_tests.csv  -s config_keyword .
```

e. Or a Custom Reader: [https://github.com/Snooz82/robotframework-datadriver?tab=readme-ov-file#custom-datareader-classes](https://github.com/Snooz82/robotframework-datadriver?tab=readme-ov-file#custom-datareader-classes)

```shell
pabot --processes 2 --testlevelsplit -d results -v SLICE:5 -v NUM_SLICES:5 -v TESTFILE:data\56_tests.csv  -s custom_reader .

pabot --processes 5 --testlevelsplit -d results -v SLICE:5 -v NUM_SLICES:10 -v TESTFILE:data\3360_tests.csv  -s custom_reader .
pabot --processes 5 --testlevelsplit -d results -v SLICE:1 -v NUM_SLICES:5 -v TESTFILE:data\3360_lines.csv  -s custom_lines .
```

5. This may still not be enough. Do you really need to test all the combinations all the time?
   a. Break data into equivalence classes

   * **Equivalence classes:**
     * If all the values in a set are functionally equivalent, why test all of them?
     * Values can be randomly chosen from those sets to find surprise subsets...
     * or use with **Operational Profiles** , so most tests test the values customers use the most (because that is where they will find bugs!)
   * **Boundary testing:**
     * Only test values at the boundaries of the classes (i.e. 0 & +/-1, especially if you are told there is no "-1" value)

   b. **Combinatorial tests** (e.g. pair wise) between variables (and still take advantage of equivalence classes)

   * Can create a small set of really complicated tests

   c. **Risk based tests** Only run tests most likely to find bugs. Choose tests based on:

   * how unacceptable their failure would be in the field
   * how likely a user would actually do the (Operational Profile)
   * dynamic metrics like code coverage (as a guide... even if two tests execute the same code, their different data may test different requirements)

6. Conclusion **I** actually think these kinds of problems are fun to solve, and these tests with data explosion are the best fit for automation! If any of you have doubts, or questions, I would be happy to answer them!

[DataDriver]: https://github.com/Snooz82/robotframework-datadriver#readme
[Pabot]:      https://github.com/mkorpela/pabot#readme
[PICT]:       https://github.com/microsoft/pict#readme