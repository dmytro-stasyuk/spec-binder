package dev.specbinder.annotations.output;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Used to annotate a generated class element with the location of content in the source file that was used to generate
 * the element.
 */
@Target({ElementType.TYPE, ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
public @interface SourceLine {

    /**
     * The line number in the source file where the content is located.
     *
     * @return the line number
     */
    long value();

    // long column() default 0;

}