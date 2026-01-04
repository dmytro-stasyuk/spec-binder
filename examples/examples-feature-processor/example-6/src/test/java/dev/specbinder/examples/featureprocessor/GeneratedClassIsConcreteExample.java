package dev.specbinder.examples.featureprocessor;

import dev.specbinder.annotations.Feature2JUnit;
import dev.specbinder.annotations.Feature2JUnitOptions;
import dev.specbinder.examples.featureprocessor.steps.CalculatorSteps;
import dev.specbinder.examples.featureprocessor.steps.LoginSteps;
import dev.specbinder.examples.featureprocessor.steps.ShoppingCartSteps;

/**
 * Demonstrates the {@code shouldBeConcrete = true} option for generating executable test classes.
 * The default behavior produces abstract test classes that must be extended and implemented.
 * Enabling this option creates concrete classes ready for immediate test execution.
 * <p>
 * Missing step methods are automatically added to the generated class with failing assumption
 * statements as placeholders. Developers then move these stubs into the base class hierarchy
 * and provide implementations. Once implemented, subsequent generation runs detect the method's
 * presence in the hierarchy and exclude it from the generated output. Step implementations can
 * reside either in the annotated class itself or in interfaces it implements using default methods,
 * as shown with {@code ShoppingCartSteps}, {@code LoginSteps}, and {@code CalculatorSteps}.
 * <p>
 * For glob patterns like "specs/*.feature" that match multiple feature files, consider creating
 * a JUnit suite class (such as {@code TestSuite} in this package) that explicitly references each
 * generated test class. This provides better organization for running tests in logical groups and
 * serves as an early warning system for generation failures. When the processor encounters errors,
 * the missing generated classes will trigger compile-time failures in the suite, preventing issues
 * from going undetected.
 */
@Feature2JUnitOptions(
        shouldBeConcrete = true
)
@Feature2JUnit("specs/*.feature")
public abstract class GeneratedClassIsConcreteExample
        implements ShoppingCartSteps, LoginSteps, CalculatorSteps {

}