package dev.specbinder.feature2junit;

import com.google.auto.service.AutoService;
import com.squareup.javapoet.JavaFile;
import dev.specbinder.common.GeneratorOptions;
import dev.specbinder.common.LoggingSupport;
import dev.specbinder.feature2junit.gherkin.utils.TypeMirrorUtils;
import org.apache.commons.lang3.exception.ExceptionUtils;

import javax.annotation.processing.*;
import javax.lang.model.SourceVersion;
import javax.lang.model.element.Element;
import javax.lang.model.element.TypeElement;
import javax.lang.model.type.TypeKind;
import javax.lang.model.type.TypeMirror;
import javax.lang.model.util.Types;
import javax.tools.FileObject;
import javax.tools.JavaFileObject;
import javax.tools.StandardLocation;
import java.io.IOException;
import java.io.PrintWriter;
import java.lang.annotation.Annotation;
import java.util.Set;

/**
 * Annotation processor that generates JUnit test subclasses for classes annotated with {@link Feature2JUnit} annotation.
 */
@SupportedAnnotationTypes("dev.specbinder.feature2junit.Feature2JUnit")
@SupportedSourceVersion(SourceVersion.RELEASE_8)
@AutoService(Processor.class)
public class Feature2JUnitGenerator extends AbstractProcessor implements LoggingSupport {

    static final String defaultSuffixForGeneratedClass = "Test";

    /**
     * Default constructor.
     */
    public Feature2JUnitGenerator() {
        super();
    }

    @Override
    public boolean process(Set<? extends TypeElement> annotations, RoundEnvironment roundEnv) {

        if (roundEnv.processingOver() || roundEnv.errorRaised()) {
            return false;
        }

        int totalClassesProcessed = 0;

        logInfo("Running " + this.getClass().getSimpleName());

        for (TypeElement annotation : annotations) {

            String annotationName = annotation.getQualifiedName().toString();
            if (!annotationName.equals(Feature2JUnit.class.getName())) {
                continue;
            }

            Set<? extends Element> annotatedElements = roundEnv.getElementsAnnotatedWith(annotation);
            for (Element annotatedElement : annotatedElements) {

                totalClassesProcessed++;

                TypeElement annotatedClass = (TypeElement) annotatedElement;

                logInfo("Processing '" + annotatedClass.getQualifiedName() + "'");

                Feature2JUnit targetAnnotation = annotatedClass.getAnnotation(Feature2JUnit.class);

                Feature2JUnitOptions optionsAnnotation = TypeMirrorUtils.findAnnotationOnHierarchy(
                        annotatedClass, Feature2JUnitOptions.class, getProcessingEnv()
                );

                if (optionsAnnotation != null) {
                    logOther("Found Feature2JUnitOptions annotation");
                } else {
                    logOther("No Feature2JUnitOptions annotation found, using default options");
                }

                GeneratorOptions generatorOptions;
                if (optionsAnnotation != null) {
                    generatorOptions = new GeneratorOptions(
                            optionsAnnotation.shouldBeAbstract(),
                            optionsAnnotation.classSuffixIfAbstract(),
                            optionsAnnotation.classSuffixIfConcrete(),
                            optionsAnnotation.addSourceLineAnnotations(),
                            optionsAnnotation.addSourceLineBeforeStepCalls(),
                            optionsAnnotation.failScenariosWithNoSteps(),
                            optionsAnnotation.failRulesWithNoScenarios(),
                            optionsAnnotation.tagForScenariosWithNoSteps().trim(),
                            optionsAnnotation.tagForRulesWithNoScenarios().trim(),
                            optionsAnnotation.addCucumberStepAnnotations(),
                            optionsAnnotation.placeGeneratedClassNextToAnnotatedClass()
                    );
                } else {
                    generatorOptions = new GeneratorOptions();
                }

                TestSubclassCreator subclassGenerator = new TestSubclassCreator(getProcessingEnv(), generatorOptions);

                JavaFile javaFile = null;
                JavaFileObject subclassFile;

                try {
                    javaFile = subclassGenerator.createTestSubclass(annotatedClass, targetAnnotation.value());
                } catch (IOException e) {
                    logException(e, annotatedClass);
                    continue;
                }

                boolean placeInSameDir = generatorOptions.isPlaceGeneratedClassNextToAnnotatedClass();

                if (placeInSameDir) {

                    try {
                        writeGeneratedSourceFileNextToAnnotatedClass(javaFile, annotatedClass, generatorOptions);
                    } catch (IOException e) {
                        logException(e, annotatedClass);
                    }

                } else {

                    String subclassFullyQualifiedName = annotatedClass.getQualifiedName().toString();
                    String suffix = generatorOptions.isShouldBeAbstract()
                            ? generatorOptions.getClassSuffixIfAbstract()
                            : generatorOptions.getClassSuffixIfConcrete();

                    subclassFullyQualifiedName += suffix;

                    Filer filer = getProcessingEnv().getFiler();

                    PrintWriter out = null;
                    try {
                        subclassFile = filer.createSourceFile(subclassFullyQualifiedName);

                        out = new PrintWriter(subclassFile.openWriter());
                        javaFile.writeTo(out);

                    } catch (Throwable t) {
                        logException(t, annotatedClass);
                    } finally {
                        if (out != null) {
                            out.close();
                        }
                    }
                }

                logInfo("Generated test class: " + javaFile.packageName + "." + javaFile.typeSpec.name);
            }
        }

        logInfo("Finished, total classes processed: " + totalClassesProcessed);

        return true;
    }

    private void writeGeneratedSourceFileNextToAnnotatedClass(JavaFile javaFile, TypeElement annotatedClass, GeneratorOptions generatorOptions) throws IOException {
        // Get the source file location of the annotated class
        FileObject resource = getProcessingEnv().getFiler().getResource(
                StandardLocation.SOURCE_PATH,
                "",
                annotatedClass.getQualifiedName().toString().replace('.', '/') + ".java"
        );

        String sourceFilePath = resource.toUri().getPath();
        java.io.File sourceFile = new java.io.File(sourceFilePath);
        java.io.File sourceDir = sourceFile.getParentFile();

        // Determine the suffix
        String suffix = generatorOptions.isShouldBeAbstract()
                ? generatorOptions.getClassSuffixIfAbstract()
                : generatorOptions.getClassSuffixIfConcrete();

        String generatedClassName = annotatedClass.getSimpleName().toString() + suffix + ".java";
        java.io.File targetFile = new java.io.File(sourceDir, generatedClassName);

        if (targetFile.exists()) {
            boolean deleted = targetFile.delete();
            if (!deleted) {
                throw new IOException("Failed to delete existing generated file: " + targetFile.getAbsolutePath());
            }
        }

        // Write the file
        try (PrintWriter out = new PrintWriter(targetFile)) {
            javaFile.writeTo(out);
        }

        logInfo("Generated test class: " + javaFile.packageName + "." + javaFile.typeSpec.name
                + " at " + targetFile.getAbsolutePath());
    }

    private void logException(Throwable t, TypeElement annotatedClass) {

        logError("An error occurred while processing annotated element - '" + annotatedClass.getQualifiedName() + "'");
        String rootCauseMessage = ExceptionUtils.getRootCauseMessage(t);
        logError("Root cause message: " + rootCauseMessage);
        String stackTrace = ExceptionUtils.getStackTrace(t);
        logError("Stack trace: \n", stackTrace);
    }

    @Override
    public ProcessingEnvironment getProcessingEnv() {
        return processingEnv;
    }

    @Override
    public SourceVersion getSupportedSourceVersion() {
        return SourceVersion.RELEASE_17;
    }

    // Add this helper method inside the Feature2JUnitGenerator class:
    private <A extends Annotation> A findAnnotationOnHierarchy(TypeElement start, Class<A> annotationClass) {

        Types typeUtils = getProcessingEnv().getTypeUtils();
        TypeElement current = start;

        while (current != null && !"java.lang.Object".equals(current.getQualifiedName().toString())) {
            A ann = current.getAnnotation(annotationClass);
            if (ann != null) {
                return ann;
            }

            TypeMirror superMirror = current.getSuperclass();
            if (superMirror == null || superMirror.getKind() == TypeKind.NONE) {
                break;
            }

            Element superElement = typeUtils.asElement(superMirror);
            if (!(superElement instanceof TypeElement)) {
                break;
            }
            current = (TypeElement) superElement;
        }

        return null;
    }
}