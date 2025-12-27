package dev.specbinder.feature2junit.steps;

import dev.specbinder.annotations.Feature2JUnitOptions;
import org.mockito.Mockito;

/**
 * Utility class for extracting and applying @Feature2JUnitOptions from base class code
 * to a mock Feature2JUnitOptions instance. Used by Cucumber step definitions to configure
 * test scenarios based on annotation values in feature file examples.
 */
class OptionsApplier {

    private OptionsApplier() {
        // Utility class, prevent instantiation
    }

    /**
     * Extracts all @Feature2JUnitOptions annotation values from the base class code
     * and applies them to the provided mock Feature2JUnitOptions instance.
     *
     * @param baseClassCode the Java code containing the @Feature2JUnitOptions annotation
     * @param feature2JUnitOptions the mock Feature2JUnitOptions to configure
     */
    public static void extractAndApplyOptions(String baseClassCode, Feature2JUnitOptions feature2JUnitOptions) {
        // Extract generatedClassSuffix
        String generatedClassSuffix = BaseClassCodeParser.extractStringOption(baseClassCode, "generatedClassSuffix");
        if (generatedClassSuffix != null) {
            Mockito.when(feature2JUnitOptions.generatedClassSuffix()).thenReturn(generatedClassSuffix);
        }

        // Extract failRulesWithNoScenarios
        Boolean failRulesWithNoScenarios = BaseClassCodeParser.extractBooleanOption(baseClassCode, "failRulesWithNoScenarios");
        if (failRulesWithNoScenarios != null) {
            Mockito.when(feature2JUnitOptions.failRulesWithNoScenarios()).thenReturn(failRulesWithNoScenarios);
        }

        // Extract tagForRulesWithNoScenarios
        String tagForRulesWithNoScenarios = BaseClassCodeParser.extractStringOption(baseClassCode, "tagForRulesWithNoScenarios");
        if (tagForRulesWithNoScenarios != null) {
            Mockito.when(feature2JUnitOptions.tagForRulesWithNoScenarios()).thenReturn(tagForRulesWithNoScenarios);
        }

        // Extract failScenariosWithNoSteps
        Boolean failScenariosWithNoSteps = BaseClassCodeParser.extractBooleanOption(baseClassCode, "failScenariosWithNoSteps");
        if (failScenariosWithNoSteps != null) {
            Mockito.when(feature2JUnitOptions.failScenariosWithNoSteps()).thenReturn(failScenariosWithNoSteps);
        }

        // Extract tagForScenariosWithNoSteps
        String tagForScenariosWithNoSteps = BaseClassCodeParser.extractStringOption(baseClassCode, "tagForScenariosWithNoSteps");
        if (tagForScenariosWithNoSteps != null) {
            Mockito.when(feature2JUnitOptions.tagForScenariosWithNoSteps()).thenReturn(tagForScenariosWithNoSteps);
        }

        // Extract addCucumberStepAnnotations
        Boolean addCucumberStepAnnotations = BaseClassCodeParser.extractBooleanOption(baseClassCode, "addCucumberStepAnnotations");
        if (addCucumberStepAnnotations != null) {
            Mockito.when(feature2JUnitOptions.addCucumberStepAnnotations()).thenReturn(addCucumberStepAnnotations);
        }

        // Extract addSourceLineAnnotations
        Boolean addSourceLineAnnotations = BaseClassCodeParser.extractBooleanOption(baseClassCode, "addSourceLineAnnotations");
        if (addSourceLineAnnotations != null) {
            Mockito.when(feature2JUnitOptions.addSourceLineAnnotations()).thenReturn(addSourceLineAnnotations);
        }

        // Extract addSourceLineBeforeStepCalls
        Boolean addSourceLineBeforeStepCalls = BaseClassCodeParser.extractBooleanOption(baseClassCode, "addSourceLineBeforeStepCalls");
        if (addSourceLineBeforeStepCalls != null) {
            Mockito.when(feature2JUnitOptions.addSourceLineBeforeStepCalls()).thenReturn(addSourceLineBeforeStepCalls);
        }
    }
}
