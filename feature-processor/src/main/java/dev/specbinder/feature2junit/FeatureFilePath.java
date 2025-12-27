package dev.specbinder.feature2junit;

import java.lang.annotation.*;

/**
 * Annotation to specify the path to the feature file used to generate the test class.
 */
@Target(ElementType.TYPE)
@Inherited
@Retention(RetentionPolicy.RUNTIME)
public @interface FeatureFilePath {

    /**
     * Feature file path.
     *
     * @return the path to the feature file based on which the test was generated.
     */
    String value();
}
