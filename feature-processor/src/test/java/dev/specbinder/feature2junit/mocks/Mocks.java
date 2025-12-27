package dev.specbinder.feature2junit.mocks;

import dev.specbinder.common.GeneratorOptions;
import dev.specbinder.annotations.Feature2JUnit;
import dev.specbinder.feature2junit.Feature2JUnitGenerator;
import dev.specbinder.annotations.Feature2JUnitOptions;
import dev.specbinder.feature2junit.steps.BaseClassInfo;
import org.mockito.Mockito;

import javax.annotation.processing.Filer;
import javax.annotation.processing.Messager;
import javax.annotation.processing.ProcessingEnvironment;
import javax.annotation.processing.RoundEnvironment;
import javax.lang.model.element.ElementKind;
import javax.lang.model.element.Name;
import javax.lang.model.element.TypeElement;
import javax.lang.model.type.DeclaredType;
import javax.lang.model.type.NoType;
import javax.lang.model.type.TypeKind;
import javax.lang.model.type.TypeMirror;
import javax.lang.model.util.Elements;
import javax.lang.model.util.Types;
import javax.tools.JavaFileObject;
import com.squareup.javapoet.ClassName;
import java.io.IOException;
import java.io.StringWriter;
import java.util.Collections;
import java.util.List;

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

    public static Feature2JUnitOptions defaultFeature2junitOptions() {

        Feature2JUnitOptions options = Mockito.mock(Feature2JUnitOptions.class);

        GeneratorOptions defaultOptions = new GeneratorOptions();

        // Set default values from GeneratorOptions (can be overridden by Steps.java)
        Mockito.when(options.generatedClassSuffix()).thenReturn(defaultOptions.getGeneratedClassSuffix());
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
        Mockito.when(annotatedClass.getKind()).thenReturn(ElementKind.CLASS);

        Name simpleName = Mockito.mock(Name.class);
        String simpleClassName = "MockedAnnotatedTestClass";
        Mockito.when(simpleName.toString()).thenReturn(simpleClassName);
        Mockito.when(annotatedClass.getSimpleName()).thenReturn(simpleName);
        // Default qualified name is same as simple name (no package)
        // This will be overridden by Steps.java if a package is specified
        Mockito.when(annotatedClass.getQualifiedName()).thenReturn(simpleName);

        DeclaredType annotatedClassMirror = Mockito.mock(DeclaredType.class);
        Mockito.when(annotatedClass.asType()).thenReturn(annotatedClassMirror);
        Mockito.when(annotatedClassMirror.getKind()).thenReturn(TypeKind.DECLARED);
        // CRITICAL: JavaPoet calls asElement() to extract the class name for the extends clause
        Mockito.when(annotatedClassMirror.asElement()).thenReturn(annotatedClass);
        // JavaPoet also checks for type arguments (generics) - return empty list for non-generic class
        Mockito.when(annotatedClassMirror.getTypeArguments()).thenReturn(Collections.emptyList());
        // Enclosing type should be NONE for top-level classes
        NoType noType = Mockito.mock(NoType.class);
        Mockito.when(noType.getKind()).thenReturn(TypeKind.NONE);
        Mockito.when(annotatedClassMirror.getEnclosingType()).thenReturn(noType);

        // Default: no package (enclosing element is null)
        // This will be overridden by Steps.java if a package is specified in the Given step
        Mockito.when(annotatedClass.getEnclosingElement()).thenReturn(null);

        // Type parameters (empty for non-generic class)
        Mockito.when(annotatedClass.getTypeParameters()).thenReturn(Collections.emptyList());

        // Set up getSuperclass to return NoType (no superclass in hierarchy)
        NoType noSuperclass = Mockito.mock(NoType.class);
        Mockito.when(noSuperclass.getKind()).thenReturn(TypeKind.NONE);
        Mockito.when(annotatedClass.getSuperclass()).thenReturn(noSuperclass);

        // Create a real ClassName for JavaPoet to use (will be updated dynamically via qualified name)
        Mockito.when(annotatedClassMirror.accept(Mockito.any(), Mockito.any())).thenAnswer(invocation -> {
            // Get the current qualified name (which may have been updated by Steps.java)
            String currentQualifiedName = annotatedClass.getQualifiedName().toString();
            int lastDot = currentQualifiedName.lastIndexOf('.');
            String pkgName = lastDot > 0 ? currentQualifiedName.substring(0, lastDot) : "";
            String className = lastDot > 0 ? currentQualifiedName.substring(lastDot + 1) : currentQualifiedName;
            return ClassName.get(pkgName, className);
        });

        Mockito.when(annotatedClass.getAnnotation(Feature2JUnit.class)).thenReturn(feature2junitAnnotation);
        Mockito.when(annotatedClass.getAnnotation(Feature2JUnitOptions.class)).thenReturn(options);
        return annotatedClass;
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

    //public static RoundEnvironment roundEnvironment(TypeElement annotatedBaseClass, TypeElement feature2junitAnnotationType) {
    public static RoundEnvironment roundEnvironment() {

        // todo
        TypeElement feature2junitAnnotationType = Mocks.feature2junitAnnotationTypeMirror();

        RoundEnvironment roundEnv = Mockito.mock(RoundEnvironment.class);

        //Set mockedAnnotatedElements = Set.of(annotatedBaseClass);
        //Mockito.when(roundEnv.getElementsAnnotatedWith(feature2junitAnnotationType))
        //        .thenReturn(mockedAnnotatedElements);

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

    public static StringWriter generatedClassWriter(Filer filer, java.util.Map<String, String> generatedClasses) {
        try {
            // Create a writer that captures the first generated class (backward compatibility)
            StringWriter primaryWriter = new StringWriter();

            // Track if this is the first file generated (for backward compatibility)
            final boolean[] isFirstFile = {true};

            // Set up the filer to create a new StringWriter for each class
            Mockito.when(filer.createSourceFile(Mockito.any())).thenAnswer(invocation -> {
                CharSequence className = invocation.getArgument(0, CharSequence.class);

                JavaFileObject generatedJavaFile = Mockito.mock(JavaFileObject.class);

                // For the first file, use primaryWriter (backward compatibility)
                // For subsequent files, create new StringWriters
                final StringWriter writerToUse = isFirstFile[0] ? primaryWriter : new StringWriter();
                isFirstFile[0] = false;

                StringWriter capturingWriter = new StringWriter() {
                    @Override
                    public void write(int c) {
                        writerToUse.write(c);
                    }

                    @Override
                    public void write(char[] cbuf, int off, int len) {
                        writerToUse.write(cbuf, off, len);
                    }

                    @Override
                    public void write(String str) {
                        writerToUse.write(str);
                    }

                    @Override
                    public void write(String str, int off, int len) {
                        writerToUse.write(str, off, len);
                    }

                    @Override
                    public void flush() {
                        writerToUse.flush();
                    }

                    @Override
                    public void close() throws IOException {
                        writerToUse.close();
                        // Capture the generated class content when the writer is closed
                        String content = writerToUse.toString();
                        String simpleClassName = extractSimpleClassName(className.toString());
                        generatedClasses.put(simpleClassName, content);
                    }

                    @Override
                    public String toString() {
                        return writerToUse.toString();
                    }
                };

                Mockito.when(generatedJavaFile.openWriter()).thenReturn(capturingWriter);

                return generatedJavaFile;
            });

            return primaryWriter;
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    private static String extractSimpleClassName(String fullyQualifiedName) {
        int lastDot = fullyQualifiedName.lastIndexOf('.');
        return lastDot > 0 ? fullyQualifiedName.substring(lastDot + 1) : fullyQualifiedName;
    }
}
