package dev.specbinder.feature2junit.mocks;

import dev.specbinder.common.GeneratorOptions;
import dev.specbinder.feature2junit.Feature2JUnit;
import dev.specbinder.feature2junit.Feature2JUnitGenerator;
import dev.specbinder.feature2junit.Feature2JUnitOptions;
import org.mockito.Mockito;

import javax.annotation.processing.Filer;
import javax.annotation.processing.ProcessingEnvironment;
import javax.annotation.processing.RoundEnvironment;
import javax.lang.model.element.Name;
import javax.lang.model.element.TypeElement;
import javax.lang.model.type.DeclaredType;
import javax.lang.model.util.Elements;
import javax.tools.JavaFileObject;
import java.io.IOException;
import java.io.StringWriter;
import java.util.Collections;
import java.util.Set;

public final class Mocks {

    private Mocks() {
        throw new UnsupportedOperationException("This is a utility class and cannot be instantiated");
    }

    public static Feature2JUnitGenerator generator(ProcessingEnvironment processingEnvironment) {

        Feature2JUnitGenerator generator = Mockito.mock(Feature2JUnitGenerator.class);
        Mockito.when(generator.process(Mockito.any(), Mockito.any())).thenCallRealMethod();

        Mockito.when(generator.getProcessingEnv()).thenReturn(processingEnvironment);

        return generator;
    }

    public static TypeElement feature2junitAnnotationTypeMirror() {

        TypeElement annotationType = Mockito.mock(TypeElement.class);
        Name annotationName = Mockito.mock(Name.class);
        Mockito.when(annotationName.toString()).thenReturn(Feature2JUnit.class.getName());
        Mockito.when(annotationType.getQualifiedName()).thenReturn(annotationName);
        return annotationType;
    }

    public static Feature2JUnit feature2junit() {

        Feature2JUnit f2j = Mockito.mock(Feature2JUnit.class);
        Mockito.when(f2j.value()).thenReturn("MockedAnnotatedTestClass.feature");
        return f2j;
    }

    public static Feature2JUnitOptions feature2junitOptions() {

        Feature2JUnitOptions options = Mockito.mock(Feature2JUnitOptions.class);

        GeneratorOptions defaultOptions = new GeneratorOptions();

        // Set default values from GeneratorOptions (can be overridden by Steps.java)
        Mockito.when(options.shouldBeAbstract()).thenReturn(defaultOptions.isShouldBeAbstract());
        Mockito.when(options.classSuffixIfAbstract()).thenReturn(defaultOptions.getClassSuffixIfAbstract());
        Mockito.when(options.classSuffixIfConcrete()).thenReturn(defaultOptions.getClassSuffixIfConcrete());
        Mockito.when(options.addSourceLineAnnotations()).thenReturn(defaultOptions.isAddSourceLineAnnotations());
        Mockito.when(options.addSourceLineBeforeStepCalls()).thenReturn(defaultOptions.isAddSourceLineBeforeStepCalls());
        Mockito.when(options.failScenariosWithNoSteps()).thenReturn(defaultOptions.isFailScenariosWithNoSteps());
        Mockito.when(options.failRulesWithNoScenarios()).thenReturn(defaultOptions.isFailRulesWithNoScenarios());
        Mockito.when(options.tagForScenariosWithNoSteps()).thenReturn(defaultOptions.getTagForScenariosWithNoSteps());
        Mockito.when(options.tagForRulesWithNoScenarios()).thenReturn(defaultOptions.getTagForRulesWithNoScenarios());
        Mockito.when(options.addCucumberStepAnnotations()).thenReturn(defaultOptions.isAddCucumberStepAnnotations());
        Mockito.when(options.placeGeneratedClassNextToAnnotatedClass()).thenReturn(defaultOptions.isPlaceGeneratedClassNextToAnnotatedClass());

        return options;
    }

    public static TypeElement annotatedBaseClass(Feature2JUnit feature2junitAnnotation, Feature2JUnitOptions options) {

        TypeElement annotatedClass = Mockito.mock(TypeElement.class);

        // TypeElement must report its kind as CLASS for JavaPoet
        Mockito.when(annotatedClass.getKind()).thenReturn(javax.lang.model.element.ElementKind.CLASS);

        Name simpleName = Mockito.mock(Name.class);
        String simpleClassName = "MockedAnnotatedTestClass";
        Mockito.when(simpleName.toString()).thenReturn(simpleClassName);
        Mockito.when(annotatedClass.getSimpleName()).thenReturn(simpleName);
        // Default qualified name is same as simple name (no package)
        // This will be overridden by Steps.java if a package is specified
        Mockito.when(annotatedClass.getQualifiedName()).thenReturn(simpleName);

        DeclaredType annotatedClassMirror = Mockito.mock(DeclaredType.class);
        Mockito.when(annotatedClass.asType()).thenReturn(annotatedClassMirror);
        Mockito.when(annotatedClassMirror.getKind()).thenReturn(javax.lang.model.type.TypeKind.DECLARED);
        // CRITICAL: JavaPoet calls asElement() to extract the class name for the extends clause
        Mockito.when(annotatedClassMirror.asElement()).thenReturn(annotatedClass);
        // JavaPoet also checks for type arguments (generics) - return empty list for non-generic class
        Mockito.when(annotatedClassMirror.getTypeArguments()).thenReturn(java.util.Collections.emptyList());
        // Enclosing type should be NONE for top-level classes
        javax.lang.model.type.NoType noType = Mockito.mock(javax.lang.model.type.NoType.class);
        Mockito.when(noType.getKind()).thenReturn(javax.lang.model.type.TypeKind.NONE);
        Mockito.when(annotatedClassMirror.getEnclosingType()).thenReturn(noType);

        // Default: no package (enclosing element is null)
        // This will be overridden by Steps.java if a package is specified in the Given step
        Mockito.when(annotatedClass.getEnclosingElement()).thenReturn(null);

        // Type parameters (empty for non-generic class)
        Mockito.when(annotatedClass.getTypeParameters()).thenReturn(java.util.Collections.emptyList());

        // Create a real ClassName for JavaPoet to use (will be updated dynamically via qualified name)
        Mockito.when(annotatedClassMirror.accept(Mockito.any(), Mockito.any())).thenAnswer(invocation -> {
            // Get the current qualified name (which may have been updated by Steps.java)
            String currentQualifiedName = annotatedClass.getQualifiedName().toString();
            int lastDot = currentQualifiedName.lastIndexOf('.');
            String pkgName = lastDot > 0 ? currentQualifiedName.substring(0, lastDot) : "";
            String className = lastDot > 0 ? currentQualifiedName.substring(lastDot + 1) : currentQualifiedName;
            return com.squareup.javapoet.ClassName.get(pkgName, className);
        });

        Mockito.when(annotatedClass.getAnnotation(Feature2JUnit.class)).thenReturn(feature2junitAnnotation);
        Mockito.when(annotatedClass.getAnnotation(Feature2JUnitOptions.class)).thenReturn(options);
        return annotatedClass;
    }

    public static ProcessingEnvironment processingEnvironment() {

        ProcessingEnvironment processingEnvironment = Mockito.mock(ProcessingEnvironment.class);

//        FileObject specFile = Mockito.mock(FileObject.class);
//        Mockito.when(filer.getResource(Mockito.any(), Mockito.any(), Mockito.any()))
//                .thenReturn(specFile);
//
//        Mockito.when(specFile.getCharContent(Mockito.anyBoolean()))
//                .thenReturn("Feature: Mocked feature file content");

        return processingEnvironment;
    }

    public static RoundEnvironment roundEnvironment(TypeElement annotatedBaseClass, TypeElement feature2junitAnnotationType) {

        RoundEnvironment roundEnv = Mockito.mock(RoundEnvironment.class);

        Set mockedAnnotatedElements = Set.of(annotatedBaseClass);
        Mockito.when(roundEnv.getElementsAnnotatedWith(feature2junitAnnotationType))
                .thenReturn(mockedAnnotatedElements);

        return roundEnv;
    }

    public static Filer filer(ProcessingEnvironment processingEnvironment) {

        Filer filer = Mockito.mock(Filer.class);
        Mockito.when(processingEnvironment.getFiler()).thenReturn(filer);

        Elements elements = Mockito.mock(Elements.class);
        Mockito.when(processingEnvironment.getElementUtils()).thenReturn(elements);
        Mockito.when(elements.getAllMembers(Mockito.any())).thenReturn(Collections.emptyList());

        return filer;
    }

    public static StringWriter generatedClassWriter(Filer filer) {
        try {
            JavaFileObject generatedJavaFile = Mockito.mock(JavaFileObject.class);
            Mockito.when(filer.createSourceFile(Mockito.any())).thenReturn(generatedJavaFile);

            StringWriter stringWriter = new StringWriter();
            Mockito.when(generatedJavaFile.openWriter()).thenReturn(stringWriter);

            return stringWriter;
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
