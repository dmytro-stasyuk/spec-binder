package dev.specbinder.examples.featureprocessor;

import dev.specbinder.annotations.Feature2JUnitOptions;

import static dev.specbinder.annotations.Feature2JUnitOptions.DATA_TABLE_PARAMETER_TYPE.CUCUMBER_DATA_TABLE;

/**
 * Base class demonstrating the use of @Feature2JUnitOptions annotation.
 * Options configured here are inherited by all subclasses, allowing centralized
 * configuration of code generation behavior.
 */
@Feature2JUnitOptions(
        dataTableParameterType = CUCUMBER_DATA_TABLE,
        addCucumberStepAnnotations = true
)
public abstract class BaseFeatureTest {
    // Common setup and utility methods can be added here
}
