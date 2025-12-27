package dev.specbinder.feature2junit.gherkin.utils;

import javax.annotation.processing.ProcessingEnvironment;
import javax.lang.model.element.TypeElement;
import javax.lang.model.util.Types;

/**
 * Utility class for working with annotations in the Java annotation processing environment.
 */
public class TypeMirrorUtils {

    private TypeMirrorUtils() {
        /**
         * utility class
         */
    }

    /**
     * Searches for a specific annotation on a class and its superclasses.
     *
     * @param start            the starting TypeElement to search
     * @param annotationClass  the annotation class to look for
     * @param processingEnv    the processing environment
     * @param <A>              the type of the annotation
     * @return the found annotation instance, or null if not found
     */
    public static <A extends java.lang.annotation.Annotation> A findAnnotationOnHierarchy(
            TypeElement start, Class<A> annotationClass, ProcessingEnvironment processingEnv
    ) {

        Types typeUtils = processingEnv.getTypeUtils();
        TypeElement current = start;

        while (current != null && !"java.lang.Object".equals(current.getQualifiedName().toString())) {
            A ann = current.getAnnotation(annotationClass);
            if (ann != null) {
                return ann;
            }

            javax.lang.model.type.TypeMirror superMirror = current.getSuperclass();
            if (superMirror == null || superMirror.getKind() == javax.lang.model.type.TypeKind.NONE) {
                break;
            }

            javax.lang.model.element.Element superElement = typeUtils.asElement(superMirror);
            if (!(superElement instanceof TypeElement)) {
                break;
            }
            current = (TypeElement) superElement;
        }

        return null;
    }
}
