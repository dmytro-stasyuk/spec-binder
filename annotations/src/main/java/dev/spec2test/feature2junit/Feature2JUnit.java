package dev.spec2test.feature2junit;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Annotation to specify a Gherkin feature file for JUnit test generation.
 */
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.SOURCE)
public @interface Feature2JUnit {

    /**
     * Path to the feature file
     * @return the path to the Gherkin feature file, relative to the classpath
     */
    String value() default "";
}