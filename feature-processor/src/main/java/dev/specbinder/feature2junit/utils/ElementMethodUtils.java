package dev.specbinder.feature2junit.utils;

import javax.annotation.processing.ProcessingEnvironment;
import javax.lang.model.element.Element;
import javax.lang.model.element.ElementKind;
import javax.lang.model.element.Modifier;
import javax.lang.model.element.TypeElement;
import javax.lang.model.util.Elements;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * Utility class useful when working with base class's methods.
 */
public class ElementMethodUtils {

    private ElementMethodUtils() {
        /**
         * utility class
         */
    }

    /**
     * Gets all inherited method names from the specified base type, excluding private methods.
     * @param processingEnv the processing environment
     * @param baseType the base type element
     * @return a set of inherited method names
     */
    public static Set<String> getAllInheritedMethodNames(ProcessingEnvironment processingEnv, TypeElement baseType) {

        Elements elementUtils = processingEnv.getElementUtils();

        List<? extends Element> allMembers = elementUtils.getAllMembers(baseType);

        Set<String> baseClassMethodNames = new HashSet<>();

        allMembers.stream().filter(element ->
                element.getKind() == ElementKind.METHOD
                        && (element.getModifiers().isEmpty() || !element.getModifiers().contains(Modifier.PRIVATE))
        ).forEach(field -> {
            baseClassMethodNames.add(field.getSimpleName().toString());
        });

        return baseClassMethodNames;
    }

}
