package dev.spec2test.feature2junit.steps;

import dev.spec2test.feature2junit.Feature2JUnit;
import dev.spec2test.feature2junit.Feature2JUnitGenerator;
import dev.spec2test.feature2junit.Feature2JUnitOptions;
import dev.spec2test.feature2junit.mocks.Mocks;
import io.cucumber.java.Before;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.junit.jupiter.api.Assertions;
import org.mockito.Mockito;

import javax.annotation.processing.Filer;
import javax.annotation.processing.ProcessingEnvironment;
import javax.annotation.processing.RoundEnvironment;
import javax.lang.model.element.TypeElement;
import javax.tools.FileObject;
import java.io.IOException;
import java.io.StringWriter;
import java.util.Set;

public class Steps {

    protected RoundEnvironment roundEnv;

    protected ProcessingEnvironment processingEnvironment;

    protected Feature2JUnitGenerator generator;

    protected Set<TypeElement> annotationSetToProcess;

    protected Feature2JUnit feature2JUnitAnnotation;

    protected Feature2JUnitOptions feature2JUnitOptions;

    protected TypeElement annotatedBaseClass;

    protected Filer filer;

    protected StringWriter generatedClassWriter;

    protected Exception generatorException;


    public Steps() {

        processingEnvironment = Mocks.processingEnvironment();

        filer = Mocks.filer(processingEnvironment);

        generatedClassWriter = Mocks.generatedClassWriter(filer);

        generator = Mocks.generator(processingEnvironment);

        feature2JUnitAnnotation = Mocks.feature2junit();
        feature2JUnitOptions = Mocks.feature2junitOptions();

        // Pass feature2JUnitOptions so the annotated class returns it when asked for the annotation
        annotatedBaseClass = Mocks.annotatedBaseClass(feature2JUnitAnnotation, feature2JUnitOptions);

        TypeElement feature2junitAnnotationType = Mocks.feature2junitAnnotationTypeMirror();

        roundEnv = Mocks.roundEnvironment(annotatedBaseClass, feature2junitAnnotationType);

        annotationSetToProcess = Set.of(feature2junitAnnotationType);
    }

    @Before
    public void beforeEach() {
        // Reset the generatorException before each scenario
        generatorException = null;
    }

    @Given("the following base class:")
    public void the_following_base_class(String docString) {
        // Parse the @Feature2JUnit annotation value from the base class
        String featureFilePath = extractFeature2JUnitPath(docString);

        if (featureFilePath != null) {
            // Update the mock to return the extracted path
            Mockito.when(feature2JUnitAnnotation.value()).thenReturn(featureFilePath);
        }

        // Extract and apply @Feature2JUnitOptions annotation values
        extractAndApplyOptions(docString);

        // Extract the package name and class name from the base class
        String packageName = extractPackageName(docString);
        String className = extractClassName(docString);

        if (className != null) {
            // Update the annotatedBaseClass mock to return the extracted class name
            javax.lang.model.element.Name simpleName = Mockito.mock(javax.lang.model.element.Name.class);
            Mockito.when(simpleName.toString()).thenReturn(className);
            Mockito.when(annotatedBaseClass.getSimpleName()).thenReturn(simpleName);

            // Build qualified name from extracted package and class name
            String qualifiedNameStr = packageName != null && !packageName.isEmpty()
                    ? packageName + "." + className
                    : className;
            javax.lang.model.element.Name qualifiedName = Mockito.mock(javax.lang.model.element.Name.class);
            Mockito.when(qualifiedName.toString()).thenReturn(qualifiedNameStr);
            Mockito.when(annotatedBaseClass.getQualifiedName()).thenReturn(qualifiedName);

            // Update the enclosing element based on whether package was specified
            if (packageName != null && !packageName.isEmpty()) {
                // Package specified - create and set a PackageElement mock
                javax.lang.model.element.PackageElement packageElement =
                        Mockito.mock(javax.lang.model.element.PackageElement.class);
                javax.lang.model.element.Name pkgName = Mockito.mock(javax.lang.model.element.Name.class);
                Mockito.when(pkgName.toString()).thenReturn(packageName);
                Mockito.when(packageElement.getQualifiedName()).thenReturn(pkgName);
                Mockito.when(annotatedBaseClass.getEnclosingElement()).thenReturn(packageElement);
            } else {
                // No package specified - enclosing element should be null (default package)
                Mockito.when(annotatedBaseClass.getEnclosingElement()).thenReturn(null);
            }
        }
    }

    private String extractFeature2JUnitPath(String baseClassCode) {
        // Extract the path from @Feature2JUnit("path/to/file.feature")
        // or detect @Feature2JUnit without parentheses (default value)
        String patternWithValue = "@Feature2JUnit\\(\"([^\"]+)\"\\)";
        java.util.regex.Pattern regexWithValue = java.util.regex.Pattern.compile(patternWithValue);
        java.util.regex.Matcher matcherWithValue = regexWithValue.matcher(baseClassCode);

        if (matcherWithValue.find()) {
            return matcherWithValue.group(1);
        }

        // Check if @Feature2JUnit exists without parentheses or with empty value
        String patternNoValue = "@Feature2JUnit(?:\\(\\)|(?![\\(]))";
        java.util.regex.Pattern regexNoValue = java.util.regex.Pattern.compile(patternNoValue);
        if (regexNoValue.matcher(baseClassCode).find()) {
            return ""; // Return empty string to trigger path construction
        }

        return null;
    }

    private String extractPackageName(String baseClassCode) {
        // Extract the package name from "package com.example.foo;"
        String pattern = "package\\s+([\\w.]+)\\s*;";
        java.util.regex.Pattern regex = java.util.regex.Pattern.compile(pattern);
        java.util.regex.Matcher matcher = regex.matcher(baseClassCode);

        if (matcher.find()) {
            return matcher.group(1);
        }
        return null;
    }

    private String extractClassName(String baseClassCode) {
        // Extract the class name from patterns like:
        // "public class FeatureTestBase" or "public abstract class FeatureTestBase"
        String pattern = "(?:public|private|protected)?\\s*(?:abstract)?\\s*class\\s+(\\w+)";
        java.util.regex.Pattern regex = java.util.regex.Pattern.compile(pattern);
        java.util.regex.Matcher matcher = regex.matcher(baseClassCode);

        if (matcher.find()) {
            return matcher.group(1);
        }
        return null;
    }

    private void extractAndApplyOptions(String baseClassCode) {
        // Extract shouldBeAbstract
        Boolean shouldBeAbstract = extractBooleanOption(baseClassCode, "shouldBeAbstract");
        if (shouldBeAbstract != null) {
            Mockito.when(feature2JUnitOptions.shouldBeAbstract()).thenReturn(shouldBeAbstract);
        }

        // Extract classSuffixIfAbstract
        String classSuffixIfAbstract = extractStringOption(baseClassCode, "classSuffixIfAbstract");
        if (classSuffixIfAbstract != null) {
            Mockito.when(feature2JUnitOptions.classSuffixIfAbstract()).thenReturn(classSuffixIfAbstract);
        }

        // Extract classSuffixIfConcrete
        String classSuffixIfConcrete = extractStringOption(baseClassCode, "classSuffixIfConcrete");
        if (classSuffixIfConcrete != null) {
            Mockito.when(feature2JUnitOptions.classSuffixIfConcrete()).thenReturn(classSuffixIfConcrete);
        }

        // Extract failRulesWithNoScenarios
        Boolean failRulesWithNoScenarios = extractBooleanOption(baseClassCode, "failRulesWithNoScenarios");
        if (failRulesWithNoScenarios != null) {
            Mockito.when(feature2JUnitOptions.failRulesWithNoScenarios()).thenReturn(failRulesWithNoScenarios);
        }

        // Extract tagForRulesWithNoScenarios
        String tagForRulesWithNoScenarios = extractStringOption(baseClassCode, "tagForRulesWithNoScenarios");
        if (tagForRulesWithNoScenarios != null) {
            Mockito.when(feature2JUnitOptions.tagForRulesWithNoScenarios()).thenReturn(tagForRulesWithNoScenarios);
        }

        // Extract failScenariosWithNoSteps
        Boolean failScenariosWithNoSteps = extractBooleanOption(baseClassCode, "failScenariosWithNoSteps");
        if (failScenariosWithNoSteps != null) {
            Mockito.when(feature2JUnitOptions.failScenariosWithNoSteps()).thenReturn(failScenariosWithNoSteps);
        }

        // Extract tagForScenariosWithNoSteps
        String tagForScenariosWithNoSteps = extractStringOption(baseClassCode, "tagForScenariosWithNoSteps");
        if (tagForScenariosWithNoSteps != null) {
            Mockito.when(feature2JUnitOptions.tagForScenariosWithNoSteps()).thenReturn(tagForScenariosWithNoSteps);
        }

        // Extract addCucumberStepAnnotations
        Boolean addCucumberStepAnnotations = extractBooleanOption(baseClassCode, "addCucumberStepAnnotations");
        if (addCucumberStepAnnotations != null) {
            Mockito.when(feature2JUnitOptions.addCucumberStepAnnotations()).thenReturn(addCucumberStepAnnotations);
        }

        // Extract addSourceLineAnnotations
        Boolean addSourceLineAnnotations = extractBooleanOption(baseClassCode, "addSourceLineAnnotations");
        if (addSourceLineAnnotations != null) {
            Mockito.when(feature2JUnitOptions.addSourceLineAnnotations()).thenReturn(addSourceLineAnnotations);
        }
    }

    private Boolean extractBooleanOption(String code, String optionName) {
        // Extract boolean option like: shouldBeAbstract = true
        // Pattern handles multi-line formatting with DOTALL flag
        String pattern = optionName + "\\s*=\\s*(true|false)";
        java.util.regex.Pattern regex = java.util.regex.Pattern.compile(pattern, java.util.regex.Pattern.DOTALL);
        java.util.regex.Matcher matcher = regex.matcher(code);

        if (matcher.find()) {
            return Boolean.parseBoolean(matcher.group(1));
        }
        return null;
    }

    private String extractStringOption(String code, String optionName) {
        // Extract string option like: classSuffixIfAbstract = "TestCases"
        // Pattern handles multi-line formatting with DOTALL flag
        String pattern = optionName + "\\s*=\\s*\"([^\"]+)\"";
        java.util.regex.Pattern regex = java.util.regex.Pattern.compile(pattern, java.util.regex.Pattern.DOTALL);
        java.util.regex.Matcher matcher = regex.matcher(code);

        if (matcher.find()) {
            return matcher.group(1);
        }
        return null;
    }

    @When("the generator is run")
    public void the_generator_is_run() {
        // Write code here that turns the phrase above into concrete actions
        //        throw new io.cucumber.java.PendingException();

        try {
            boolean finished = generator.process(annotationSetToProcess, roundEnv);
        } catch (Exception e) {
            // Store the exception for later verification in Then steps
            generatorException = e;
        }
    }

    @Then("the content of the generated class should be:")
    public void the_content_of_the_generated_class_should_be(String docString) {
        // Write code here that turns the phrase above into concrete actions

        if (generatorException != null) {
            Assertions.fail("Expected the generator to complete without exceptions, but an exception was thrown: "
                    + generatorException.getMessage(), generatorException);
            generatorException.printStackTrace(System.err);
        }

        String generatedClas = generatedClassWriter.toString().trim();
        String expectedClass = docString.trim();
        Assertions.assertEquals(expectedClass, generatedClas);
    }

    @Then("the generator should report an error:")
    public void the_generator_should_report_an_error(String expectedErrorMessage) {
        // Verify that an exception was thrown during generator execution
        Assertions.assertNotNull(
                generatorException,
                "Expected the generator to throw an exception, but no exception was thrown"
        );

        String actualMessage = generatorException.getMessage();
        String expectedMessage = expectedErrorMessage.trim();

        Assertions.assertEquals(expectedMessage, actualMessage);

        // Check if the actual exception message contains the expected error description
        //Assertions.assertTrue(
        //        actualMessage.contains(expectedMessage) || actualMessage.contains(expectedMessage),
        //        "Expected error message about - \"" + expectedMessage + "\", but got: " + actualMessage
    }

    @Given("the following feature file:")
    public void the_following_feature_file(String docString) throws IOException {

        Filer filer = processingEnvironment.getFiler();

        FileObject specFile = Mockito.mock(FileObject.class);
        Mockito.when(filer.getResource(Mockito.any(), Mockito.any(), Mockito.any()))
                .thenReturn(specFile);

        Mockito.when(specFile.getCharContent(Mockito.anyBoolean()))
                .thenReturn(docString);
    }

}