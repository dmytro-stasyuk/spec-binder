package dev.specbinder.feature2junit.tests;

import io.cucumber.java.BeforeAll;
import org.junit.platform.suite.api.ExcludePackages;
import org.junit.platform.suite.api.IncludeClassNamePatterns;
import org.junit.platform.suite.api.SelectPackages;
import org.junit.platform.suite.api.Suite;
import org.junit.platform.suite.api.SuiteDisplayName;

@Suite
@SuiteDisplayName("All Tests")
@SelectPackages("dev.specbinder.feature2junit.tests")
@ExcludePackages("dev.specbinder.feature2junit.tests.troubleshooting")
@IncludeClassNamePatterns(".*Test(s)?$")
public class AllTests {

    @BeforeAll
    public static void beforeAll() {
        // Enable compilation verification for all tests
        // increases test execution time significantly
        //Steps.verifyCompilation = true;
    }
}
