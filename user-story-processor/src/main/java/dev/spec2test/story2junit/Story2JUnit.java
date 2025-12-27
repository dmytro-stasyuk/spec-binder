package dev.spec2test.story2junit;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Annotation to specify a story file for which to generate a JUnit test subclass.
 */
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.SOURCE)
public @interface Story2JUnit {

    /**
     * Path of the story file for which to generate a JUnit test subclass.
     * @return the path to the story file
     */
    String value();

}