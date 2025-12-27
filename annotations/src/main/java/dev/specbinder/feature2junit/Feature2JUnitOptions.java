package dev.specbinder.feature2junit;

import java.lang.annotation.*;

/**
 * Specifies configuration options for generating JUnit test classes from classes annotated with {@link Feature2JUnit}.
 * Use this annotation to customize the structure and behavior of the generated test classes.
 *
 * This annotation is inherited, so it can be specified on a parent class in your test hierarchy to apply its options to all subclasses.
 */
@Inherited
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
public @interface Feature2JUnitOptions {

    /**
     * If set to true, the generated test class will be abstract and will include abstract method
     * signatures for all methods required for the feature file to run. Implementing subclasses will then need to
     * implement these methods.
     *
     * @return true if the generated test class should be abstract, false otherwise
     */
    boolean shouldBeAbstract() default true;

    /**
     * Suffix that will be used for the name of the generated test class in case it is abstract.
     *
     * @return the suffix for the generated abstract test class name
     */
    String classSuffixIfAbstract() default "Scenarios";

    /**
     * Suffix that will be used for the name of the generated test class in case it is concrete.
     *
     * @return the suffix for the generated test class name
     */
    String classSuffixIfConcrete() default "Test";

    /**
     * If set to true, the generator will add {@link dev.specbinder.common.SourceLine} annotation to test methods and
     * nested test classes containing line numbers where these elements appear in the Feature file.
     *
     * @return true if source line annotations should be added, false otherwise
     */
    boolean addSourceLineAnnotations() default false;

    /**
     * If set to true, the generator will add source location as a java comment just before a call to each step method
     * inside the test methods.
     *
     * @return true if source line comments should be added before step calls, false otherwise
     */
    boolean addSourceLineBeforeStepCalls() default false;

    /**
     * If set to true, the generator will add a call to a failing JUnit assumption for scenarios that have no steps.
     *
     * @return true if scenarios with no steps should fail, false otherwise
     */
    boolean failScenariosWithNoSteps() default true;

    /**
     * If set to true, the generator will add a failing test method for rules that have no scenarios.
     *
     * @return true if rules with no scenarios should fail, false otherwise
     */
    boolean failRulesWithNoScenarios() default true;

    /**
     * The value for JUnit's @{@link org.junit.jupiter.api.Tag} annotation that will be added to scenarios that do not
     * contain any steps. If an empty or blank value is specified, no tag will be added.
     *
     * @return true if features with no rules should fail, false otherwise
     */
    String tagForScenariosWithNoSteps() default "new";

    /**
     * The value for JUnit's @{@link org.junit.jupiter.api.Tag} annotation that will be added to failing test method
     * that was added for rules that do not contain any scenarios.
     * If an empty or blank value is specified, no tag will be added.
     *
     * @return the tag for rules with no scenarios
     */
    String tagForRulesWithNoScenarios() default "new";

    /**
     * If set to true, the generator will add Cucumber step annotations (e.g. @Given, @When, @Then) to the generated
     * step methods. This can be useful inside IDEs with installed Cucumber/Gherkin plugins to facilitate navigation
     * from textual steps in Gherkin feature file to step method java code.
     * @return true if Cucumber step annotations should be added, false otherwise
     */
    boolean addCucumberStepAnnotations() default true;

    /**
     * If set to true, the generated test class will be placed in the same package and directory as the annotated
     * class. If false, it will be placed according to standard source generation conventions.
     *
     * @return true if the generated class should be placed next to the annotated class, false otherwise
     */
    boolean placeGeneratedClassNextToAnnotatedClass() default false;
}