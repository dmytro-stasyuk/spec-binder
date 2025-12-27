package dev.specbinder.common;

import lombok.Getter;

/**
 * Options for the generator that can be used to customize the generated test classes.
 */
@Getter
public class GeneratorOptions {

    /**
     * If set to true, the generated test class will be abstract, and it will contain abstract method declarations for
     * that would be required to run the Feature file test.
     */
    private final boolean shouldBeAbstract;

    /**
     * Suffix that will be used for the name of the generated test class if it is abstract.
     */
    private final String classSuffixIfAbstract;

    /**
     * Suffix that will be used for the name of the generated test class if it is concrete.
     */
    private final String classSuffixIfConcrete;

    /**
     * If set to true, the generator will add {@link dev.specbinder.common.SourceLine} annotation to test methods and
     * nested test classes containing line numbers where these elements appear in the Feature file.
     */
    private final boolean addSourceLineAnnotations;

    /**
     * If set to true, the generator will add source location as a java comment just before a call to each step method
     * inside the test methods.
     */
    private final boolean addSourceLineBeforeStepCalls;

    /**
     * If set to true, the generator will add a call to a failing JUnit assumption for scenarios that have no steps.
     */
    private final boolean failScenariosWithNoSteps;

    /**
     * If set to true, the generator will add a failing test method for rules that have no scenarios.
     */
    private final boolean failRulesWithNoScenarios;

    /**
     * The value for JUnit's @{@link org.junit.jupiter.api.Tag} annotation that will be added to scenarios that do not
     * contain any steps. If an empty or blank value is specified, no tag will be added.
     */
    private final String tagForScenariosWithNoSteps;

    /**
     * The value for JUnit's @{@link org.junit.jupiter.api.Tag} annotation that will be added to failing test method
     * that was added for rules that do not contain any scenarios.
     * If an empty or blank value is specified, no tag will be added.
     */
    private final String tagForRulesWithNoScenarios;

    /**
     * If set to true, the generator will add Cucumber step annotations (e.g. @Given, @When, @Then) to the generated
     * step methods. This can be useful inside IDEs with installed Cucumber/Gherkin plugins to facilitate navigation
     * from textual steps in Gherkin feature file to step method java code.
     */
    private boolean addCucumberStepAnnotations;

    /**
     * If set to true, the generated class source file will be placed next to the annotated class instead of
     * the default location for generated sources.
     */
    private boolean placeGeneratedClassNextToAnnotatedClass;

    /**
     * Default options
     */
    public GeneratorOptions() {
        this.shouldBeAbstract = true;
        this.classSuffixIfAbstract = "Scenarios";
        this.classSuffixIfConcrete = "Test";
        this.addSourceLineAnnotations = false;
        this.addSourceLineBeforeStepCalls = false;
        this.failScenariosWithNoSteps = true;
        this.failRulesWithNoScenarios = true;
        this.tagForScenariosWithNoSteps = "new";
        this.tagForRulesWithNoScenarios = "new";
        this.addCucumberStepAnnotations = true;
        this.placeGeneratedClassNextToAnnotatedClass = false;
    }

    /**
     * Custom options
     *
     * @param shouldBeAbstract             see {@link #shouldBeAbstract}
     * @param classSuffixIfAbstract        see {@link #classSuffixIfAbstract}
     * @param classSuffixIfConcrete        see {@link #classSuffixIfConcrete}
     * @param addSourceLineAnnotations     see {@link #addSourceLineAnnotations}
     * @param addSourceLineBeforeStepCalls see {@link #addSourceLineBeforeStepCalls}
     * @param failScenariosWithNoSteps     see {@link #failScenariosWithNoSteps}
     * @param failRulesWithNoScenarios     see {@link #failRulesWithNoScenarios}
     * @param tagForScenariosWithNoSteps   see {@link #tagForScenariosWithNoSteps}
     * @param tagForRulesWithNoScenarios   see {@link #tagForRulesWithNoScenarios}
     * @param addCucumberStepAnnotations   see {@link #addCucumberStepAnnotations}
     * @param placeGeneratedClassNextToAnnotatedClass see {@link #placeGeneratedClassNextToAnnotatedClass}
     */
    public GeneratorOptions(
            boolean shouldBeAbstract,
            String classSuffixIfAbstract,
            String classSuffixIfConcrete,
            boolean addSourceLineAnnotations,
            boolean addSourceLineBeforeStepCalls,
            boolean failScenariosWithNoSteps,
            boolean failRulesWithNoScenarios,
            String tagForScenariosWithNoSteps,
            String tagForRulesWithNoScenarios,
            boolean addCucumberStepAnnotations,
            boolean placeGeneratedClassNextToAnnotatedClass
    ) {
        this.shouldBeAbstract = shouldBeAbstract;
        this.classSuffixIfAbstract = classSuffixIfAbstract;
        this.classSuffixIfConcrete = classSuffixIfConcrete;
        this.addSourceLineAnnotations = addSourceLineAnnotations;
        this.addSourceLineBeforeStepCalls = addSourceLineBeforeStepCalls;
        this.failScenariosWithNoSteps = failScenariosWithNoSteps;
        this.failRulesWithNoScenarios = failRulesWithNoScenarios;
        this.tagForScenariosWithNoSteps = tagForScenariosWithNoSteps;
        this.tagForRulesWithNoScenarios = tagForRulesWithNoScenarios;
        this.addCucumberStepAnnotations = addCucumberStepAnnotations;
        this.placeGeneratedClassNextToAnnotatedClass = placeGeneratedClassNextToAnnotatedClass;
    }

}
