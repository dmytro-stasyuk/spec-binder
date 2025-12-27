package dev.specbinder.annotations;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Annotation to specify a Gherkin feature file path for JUnit test generation.
 */
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.SOURCE)
public @interface Feature2JUnit {

    /**
     * Path to the feature file. If not specified, the generator will look for a feature file
     * with the same name as the annotated class in the same package.
     * @return the path to the Gherkin feature file, relative to the classpath
     */
    String value() default "";
}