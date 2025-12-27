package dev.specbinder.feature2junit.tests;

import org.junit.platform.suite.api.SelectClasses;
import org.junit.platform.suite.api.Suite;
import org.junit.platform.suite.api.SuiteDisplayName;

@Suite
@SuiteDisplayName("All Tests")
@SelectClasses({
        MappingBackgroundTest.class,
        MappingCommentsTest.class,
        MappingFeatureTest.class,
        MappingRuleTest.class,
        MappingScenarioOutlineTest.class,
        MappingScenarioTest.class,
        MappingStepsTest.class,
})
public class AllTests {

}
