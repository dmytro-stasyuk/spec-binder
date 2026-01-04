package dev.specbinder.feature2junit.mocks;

import dev.specbinder.feature2junit.steps.BaseClassInfo;
import org.mockito.Mockito;

import javax.annotation.processing.Messager;
import javax.annotation.processing.ProcessingEnvironment;
import javax.annotation.processing.RoundEnvironment;
import javax.lang.model.element.TypeElement;
import javax.lang.model.type.TypeMirror;
import javax.lang.model.util.Types;
import java.util.List;

final class ProcessingEnvironmentMocks {

    private ProcessingEnvironmentMocks() {
        throw new UnsupportedOperationException("This is a utility class and cannot be instantiated");
    }

    public static ProcessingEnvironment processingEnvironment(List<BaseClassInfo> baseClassHierarchy) {

        ProcessingEnvironment processingEnvironment = Mockito.mock(ProcessingEnvironment.class);

        // Set up Types utility to support hierarchy navigation
        Types typeUtils = Mockito.mock(Types.class);
        Mockito.when(processingEnvironment.getTypeUtils()).thenReturn(typeUtils);

        // Set up Messager for logging
        Messager messager = Mockito.mock(Messager.class);
        Mockito.when(processingEnvironment.getMessager()).thenReturn(messager);

        // Set up asElement to return the TypeElement from the baseClassHierarchy
        Mockito.when(typeUtils.asElement(Mockito.any())).thenAnswer(invocation -> {
            TypeMirror typeMirror = invocation.getArgument(0);

            // Search through the hierarchy to find the matching TypeElement
            for (BaseClassInfo classInfo : baseClassHierarchy) {
                if (classInfo.typeElement != null && classInfo.typeElement.asType() == typeMirror) {
                    return classInfo.typeElement;
                }
            }

            // Return null if not found in our hierarchy (e.g., for Object)
            return null;
        });

        return processingEnvironment;
    }

    public static RoundEnvironment roundEnvironment() {

        // todo
        TypeElement feature2junitAnnotationType = AnnotationMocks.feature2junitAnnotationTypeMirror();

        RoundEnvironment roundEnv = Mockito.mock(RoundEnvironment.class);

        //Set mockedAnnotatedElements = Set.of(annotatedBaseClass);
        //Mockito.when(roundEnv.getElementsAnnotatedWith(feature2junitAnnotationType))
        //        .thenReturn(mockedAnnotatedElements);

        return roundEnv;
    }
}
