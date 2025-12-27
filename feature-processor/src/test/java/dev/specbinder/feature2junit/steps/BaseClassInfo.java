package dev.specbinder.feature2junit.steps;

import dev.specbinder.annotations.Feature2JUnit;
import dev.specbinder.annotations.Feature2JUnitOptions;

import javax.lang.model.element.TypeElement;

/**
 * Holds information about a base class in the inheritance hierarchy
 */
public class BaseClassInfo {

    public String packageName;

    public String className;

    public String sourceCode;

    public TypeElement typeElement;

    public Feature2JUnit feature2JUnitAnnotation;

    public Feature2JUnitOptions feature2JUnitOptions;

    BaseClassInfo(String packageName, String className, String sourceCode) {
        this.packageName = packageName;
        this.className = className;
        this.sourceCode = sourceCode;
    }
}
