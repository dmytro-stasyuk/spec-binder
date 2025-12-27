package dev.specbinder.feature2junit.utils;

import javax.annotation.processing.ProcessingEnvironment;
import javax.lang.model.element.TypeElement;
import javax.lang.model.util.Types;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

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

    /**
     * Collects all instances of a specific annotation from a class hierarchy, starting from the given class
     * and traversing up through its superclasses.
     *
     * @param start            the starting TypeElement to search
     * @param annotationClass  the annotation class to collect
     * @param processingEnv    the processing environment
     * @param <A>              the type of the annotation
     * @return a list of annotation instances ordered from parent to child (most distant ancestor first)
     */
    public static <A extends java.lang.annotation.Annotation> List<A> collectAnnotationsFromHierarchy(
            TypeElement start, Class<A> annotationClass, ProcessingEnvironment processingEnv
    ) {

        Types typeUtils = processingEnv.getTypeUtils();
        TypeElement current = start;
        List<A> annotations = new ArrayList<>();

        while (current != null && !"java.lang.Object".equals(current.getQualifiedName().toString())) {
            A ann = current.getAnnotation(annotationClass);
            if (ann != null) {
                annotations.add(ann);
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

        // Reverse the list so parent annotations come first
        Collections.reverse(annotations);
        return annotations;
    }
}
