"""Pre-run modifier that selects only every Xth test for execution.

Starts from the first test by default. Tests are selected per suite.
From:
https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#example-select-every-xth-test
"""

from robot.api import SuiteVisitor, logger


class SelectEveryXthTest(SuiteVisitor):

    def __init__(self, x: int, start: int = 0):
        self.x = x
        self.start = start

    def start_suite(self, suite):
        """Modify suite's tests to contain only every Xth."""
        suite.tests = suite.tests[self.start::self.x]

    def end_suite(self, suite):
        """Remove suites that are empty after removing tests."""
        suite.suites = [s for s in suite.suites if s.test_count > 0]

    def visit_test(self, test):
        """Avoid visiting tests and their keywords to save a little time."""
        pass