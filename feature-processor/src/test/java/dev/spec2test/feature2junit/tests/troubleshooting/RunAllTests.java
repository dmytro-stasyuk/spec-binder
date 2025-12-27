package dev.spec2test.feature2junit.tests.troubleshooting;

import org.junit.platform.suite.api.ExcludeTags;
import org.junit.platform.suite.api.IncludeEngines;
import org.junit.platform.suite.api.SelectClasspathResource;
import org.junit.platform.suite.api.Suite;

//@Disabled("use individual test classes instead")
@Suite
@IncludeEngines("cucumber")
@SelectClasspathResource("features")
@ExcludeTags("wip")
public class RunAllTests {

}
