package dev.specbinder.feature2junit.utils;

import dev.specbinder.annotations.Feature2JUnitOptions;
import dev.specbinder.common.GeneratorOptions;

import javax.annotation.processing.ProcessingEnvironment;
import javax.lang.model.element.TypeElement;
import java.util.List;

/**
 * Utility class for resolving and merging Feature2JUnitOptions annotations from a class hierarchy.
 * 
 * This class supports partial inheritance of options, where a child class can override specific
 * options while inheriting others from its parent classes.
 */
public class Feature2JUnitOptionsResolver {

    private Feature2JUnitOptionsResolver() {
        // utility class
    }

    /**
     * Resolves GeneratorOptions from the Feature2JUnitOptions annotation hierarchy.
     * 
     * This method collects all Feature2JUnitOptions annotations from the class hierarchy
     * and merges them, with child values taking precedence over parent values.
     * 
     * The merging strategy:
     * - For String properties: if the child's value matches the annotation's default value,
     *   it is considered "not explicitly set" and the parent's value is used instead.
     * - For boolean properties: the child's value is always used (we cannot distinguish
     *   between explicitly set and default values for booleans).
     * 
     * @param annotatedClass the class to resolve options for
     * @param processingEnv the processing environment
     * @return the resolved GeneratorOptions, or a default instance if no annotations are found
     */
    public static GeneratorOptions resolveOptions(TypeElement annotatedClass, ProcessingEnvironment processingEnv) {
        List<Feature2JUnitOptions> annotations = TypeMirrorUtils.collectAnnotationsFromHierarchy(
                annotatedClass, Feature2JUnitOptions.class, processingEnv
        );

        if (annotations.isEmpty()) {
            return new GeneratorOptions();
        }

        // Start with defaults
        String generatedClassSuffix = "Scenarios";
        boolean addSourceLineAnnotations = false;
        boolean addSourceLineBeforeStepCalls = false;
        boolean failScenariosWithNoSteps = true;
        boolean failRulesWithNoScenarios = true;
        String tagForScenariosWithNoSteps = "new";
        String tagForRulesWithNoScenarios = "new";
        boolean addCucumberStepAnnotations = false;
        boolean placeGeneratedClassNextToAnnotatedClass = false;

        // Merge annotations from parent to child (so child values override parent values)
        for (Feature2JUnitOptions options : annotations) {
            // For boolean properties, we always take the value (can't detect if explicitly set)
            addSourceLineAnnotations = options.addSourceLineAnnotations();
            addSourceLineBeforeStepCalls = options.addSourceLineBeforeStepCalls();
            failScenariosWithNoSteps = options.failScenariosWithNoSteps();
            failRulesWithNoScenarios = options.failRulesWithNoScenarios();
            addCucumberStepAnnotations = options.addCucumberStepAnnotations();
            placeGeneratedClassNextToAnnotatedClass = options.placeGeneratedClassNextToAnnotatedClass();

            // For String properties, only override if the value differs from the default
            // This allows child classes to inherit parent's string values
            if (!"Scenarios".equals(options.generatedClassSuffix())) {
                generatedClassSuffix = options.generatedClassSuffix();
            }
            if (!"new".equals(options.tagForScenariosWithNoSteps())) {
                tagForScenariosWithNoSteps = options.tagForScenariosWithNoSteps();
            }
            if (!"new".equals(options.tagForRulesWithNoScenarios())) {
                tagForRulesWithNoScenarios = options.tagForRulesWithNoScenarios();
            }
        }

        return new GeneratorOptions(
                generatedClassSuffix,
                addSourceLineAnnotations,
                addSourceLineBeforeStepCalls,
                failScenariosWithNoSteps,
                failRulesWithNoScenarios,
                tagForScenariosWithNoSteps,
                tagForRulesWithNoScenarios,
                addCucumberStepAnnotations,
                placeGeneratedClassNextToAnnotatedClass
        );
    }
}
