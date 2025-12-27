package dev.specbinder.annotations;

import dev.specbinder.annotations.output.SourceLine;

import java.lang.annotation.*;

/**
 * Specifies configuration options for generating JUnit test classes from classes annotated with {@link Feature2JUnit}.
 * Use this annotation to customize the structure and behavior of the generated test classes.
 *
 * This annotation is inherited, so it can be specified on a parent class in your test hierarchy to apply its options to all subclasses.
 */
@Inherited
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.SOURCE)
public @interface Feature2JUnitOptions {

    /**
     * If set to true, the generator will add a failing test method for rules that have no scenarios.
     * An example of what the generated inner class would look like for an empty rule is:
     * <pre>
     *     &#64;Nested
     *     &#64;Order(1)
     *     &#64;DisplayName("Rule: Processing rules")
     *     public class Rule_1 {
     *         &#64;Test
     *         &#64;Tag("new")
     *         public void noScenariosInRule() {
     *             Assertions.fail("Rule doesn't have any scenarios");
     *         }
     *     }
     * </pre>
     * @return true if rules with no scenarios should fail, false otherwise
     */
    boolean failRulesWithNoScenarios() default true;

    /**
     * The value for JUnit's @{@link org.junit.jupiter.api.Tag} annotation that will be added to failing test method
     * that was added for rules that do not contain any scenarios. By default, this is set to "new".
     * If an empty or blank value is specified, no tag will be added.
     *
     * @return the tag for rules with no scenarios
     */
    String tagForRulesWithNoScenarios() default "new";

    /**
     * If set to true, the generator will add a call to a failing JUnit assumption for scenarios that have no steps.
     * An example of what the generated test method would look like for an empty scenario is:
     * <pre>
     *     &#64;Test
     *     &#64;Order(1)
     *     &#64;Tag("new")
     *     &#64;DisplayName("Scenario: Empty scenario")
     *     public void scenario_Empty_scenario() {
     *         Assertions.fail("Scenario has no steps");
     *     }
     * </pre>
     * @return true if scenarios with no steps should fail, false otherwise
     */
    boolean failScenariosWithNoSteps() default true;

    /**
     * The value for JUnit's @{@link org.junit.jupiter.api.Tag} annotation that will be added to scenarios that do not
     * contain any steps. By default, this is set to "new".
     * If an empty or blank value is specified, no tag will be added.
     *
     * @return true if features with no rules should fail, false otherwise
     */
    String tagForScenariosWithNoSteps() default "new";

    /**
     * If set to true, the generator will add {@link SourceLine} annotation to test methods and
     * nested test classes containing line numbers where these elements appear in the Feature file.
     *
     * An example of what the generated annotation would look like is:
     * <pre>
     *     &#64;Test
     *     &#64;Order(1)
     *     &#64;SourceLine(12)
     *     &#64;DisplayName("Scenario: Successful login")
     *     public void scenario_Successful_login() {
     *     ...
     *     }
     *     </pre>
     *
     * @return true if source line annotations should be added, false otherwise
     */
    boolean addSourceLineAnnotations() default false;

    /**
     * If set to true, the generator will append the source location in the java block comment just before a call
     * to each step method.
     * An example of what the generated comment would look like is:
     * <pre>
     *     &#64;Test
     *     &#64;Order(1)
     *     &#64;SourceLine(2)
     *     &#64;DisplayName("Scenario: Test")
     *     public void scenario_1() {
     *        &#47;*
     *          * Given user exists
     *          * (source line - 3)
     *          *&#47;
     *         givenUserExists();
     *         &#47;*
     *           * When user clicks button
     *           * (source line - 4)
     *           *&#47;
     *          whenUserClicksButton();
     *          &#47;*
     *           * Then result is displayed
     *           * (source line - 5)
     *           *&#47;
     *          thenResultIsDisplayed();
     *      }
     *     </pre>
     *
     * @return true if source line comments should be added before step calls, false otherwise
     */
    boolean addSourceLineBeforeStepCalls() default false;

    /**
     * Suffix that will be used for the name of the generated test class.
     *
     * @return the suffix for the generated abstract test class name
     */
    String generatedClassSuffix() default "Scenarios";

    /* =============================================================================
     * The rest of the options below are experimental and subject to change/removal.
     * =============================================================================
     */

    /**
     * -- EXPERIMENTAL OPTION --
     * <br/><br/>
     * If set to true, the generator will add Cucumber step annotations (e.g. @Given, @When, @Then) to the generated
     * step methods. This can be useful inside IDEs with installed Cucumber/Gherkin plugins to facilitate navigation
     * from textual steps in a Gherkin feature file to step method java code.
     * <br/><br/>
     * Note that this would introduce a dependency on Cucumber annotations in the generated test class, which the client
     * project would need to have on its classpath.
     * @return true if Cucumber step annotations should be added, false otherwise
     */
    boolean addCucumberStepAnnotations() default false;

    /**
     * -- EXPERIMENTAL OPTION --
     * <br/><br/>
     * If set to true, the generated test class will be placed in the same package and directory as the annotated
     * class. If false, it will be placed according to standard source generation conventions.
     *
     * @return true if the generated class should be placed next to the annotated class, false otherwise
     */
    boolean placeGeneratedClassNextToAnnotatedClass() default false;
}