package dev.specbinder.feature2junit.mocks;

import dev.specbinder.annotations.Feature2JUnit;
import dev.specbinder.annotations.Feature2JUnitOptions;
import dev.specbinder.feature2junit.Feature2JUnitGenerator;
import dev.specbinder.feature2junit.steps.BaseClassInfo;

import javax.annotation.processing.Filer;
import javax.annotation.processing.ProcessingEnvironment;
import javax.annotation.processing.RoundEnvironment;
import javax.lang.model.element.TypeElement;
import java.io.StringWriter;
import java.util.List;
import java.util.Map;

/**
 * Facade for creating test mocks. Delegates to specialized mock classes.
 */
public final class Mocks {

    private Mocks() {
        throw new UnsupportedOperationException("This is a utility class and cannot be instantiated");
    }

    // Generator mocks
    public static Feature2JUnitGenerator generator(ProcessingEnvironment processingEnvironment) {
        return GeneratorMocks.generator(processingEnvironment);
    }

    // Annotation mocks
    public static TypeElement feature2junitAnnotationTypeMirror() {
        return AnnotationMocks.feature2junitAnnotationTypeMirror();
    }

    public static Feature2JUnit feature2junit() {
        return AnnotationMocks.feature2junit();
    }

    public static Feature2JUnitOptions defaultFeature2junitOptions() {
        return AnnotationMocks.defaultFeature2junitOptions();
    }

    // TypeElement mocks
    public static TypeElement annotatedBaseClass(Feature2JUnit feature2junitAnnotation, Feature2JUnitOptions options) {
        return TypeElementMocks.annotatedBaseClass(feature2junitAnnotation, options);
    }

    // Processing environment mocks
    public static ProcessingEnvironment processingEnvironment(List<BaseClassInfo> baseClassHierarchy) {
        return ProcessingEnvironmentMocks.processingEnvironment(baseClassHierarchy);
    }

    public static RoundEnvironment roundEnvironment() {
        return ProcessingEnvironmentMocks.roundEnvironment();
    }

    // Filer mocks
    public static Filer filer(ProcessingEnvironment processingEnvironment) {
        return FilerMocks.filer(processingEnvironment);
    }

    public static StringWriter generatedClassWriter(Filer filer, Map<String, String> generatedClasses) {
        return FilerMocks.generatedClassWriter(filer, generatedClasses);
    }
}
