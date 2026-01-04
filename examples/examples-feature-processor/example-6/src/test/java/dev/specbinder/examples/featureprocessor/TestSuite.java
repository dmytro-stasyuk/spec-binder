package dev.specbinder.examples.featureprocessor;

import org.junit.platform.suite.api.SelectClasses;
import org.junit.platform.suite.api.Suite;
import specs.AnotherFeatureWithRuleTest;
import specs.ScenarioWithBackgroundTest;
import specs.SimpleCalculatorTest;

@Suite
@SelectClasses({
        SimpleCalculatorTest.class,
        ScenarioWithBackgroundTest.class,
        AnotherFeatureWithRuleTest.class
})
public class TestSuite {

}
