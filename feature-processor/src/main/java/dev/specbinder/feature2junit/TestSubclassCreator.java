package dev.specbinder.feature2junit;

import com.squareup.javapoet.*;
import dev.specbinder.annotations.Feature2JUnit;
import dev.specbinder.annotations.output.FeatureFilePath;
import dev.specbinder.feature2junit.config.GeneratorOptions;
import dev.specbinder.feature2junit.support.LoggingSupport;
import dev.specbinder.feature2junit.support.OptionsSupport;
import dev.specbinder.feature2junit.exception.ProcessingException;
import dev.specbinder.feature2junit.gherkin.FeatureFileParser;
import dev.specbinder.feature2junit.gherkin.FeatureProcessor;
import dev.specbinder.feature2junit.gherkin.utils.DataTableCollector;
import dev.specbinder.feature2junit.gherkin.utils.RecordGenerator;
import dev.specbinder.feature2junit.gherkin.utils.RecordMetadata;
import dev.specbinder.feature2junit.utils.*;
import io.cucumber.messages.types.Background;
import io.cucumber.messages.types.Feature;
import io.cucumber.messages.types.FeatureChild;
import io.cucumber.messages.types.Rule;
import io.cucumber.messages.types.RuleChild;
import io.cucumber.messages.types.Scenario;
import io.cucumber.messages.types.Step;
import io.cucumber.messages.types.TableCell;
import io.cucumber.messages.types.Tag;
import org.apache.commons.lang3.StringUtils;
import org.junit.jupiter.api.*;

import javax.annotation.processing.Generated;
import javax.annotation.processing.ProcessingEnvironment;
import javax.lang.model.element.Element;
import javax.lang.model.element.Modifier;
import javax.lang.model.element.PackageElement;
import javax.lang.model.element.TypeElement;
import javax.lang.model.type.TypeMirror;
import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.Set;

import static dev.specbinder.annotations.Feature2JUnitOptions.DATA_TABLE_PARAMETER_TYPE.LIST_OF_MAPS;

/**
 * Creates a JUnit test subclass for a given type element annotated with {@link Feature2JUnit}.
 */
class TestSubclassCreator implements LoggingSupport, OptionsSupport {

    private final ProcessingEnvironment processingEnv;
    private final GeneratorOptions options;

    protected FeatureFileParser featureFileParser;

    /**
     * Constructor for TestSubclassCreator.
     *
     * @param generatorOptions the generator options to use for test generation
     * @param processingEnv    the processing environment used for annotation processing
     */
    public TestSubclassCreator(ProcessingEnvironment processingEnv, GeneratorOptions generatorOptions) {
        this.processingEnv = processingEnv;
        this.options = generatorOptions;

        featureFileParser = new FeatureFileParser(processingEnv);
    }

    public GeneratorOptions getOptions() {
        return options;
    }

    /**
     * Creates a JUnit test subclass for the given type element annotated with {@link Feature2JUnit}.
     *
     * @param annotatedClass  the type element to create a test subclass for
     * @param featureFilePath the feature file path
     * @return a {@link JavaFile} representing the generated test subclass
     * @throws IOException if an error occurs during file generation
     */
    public JavaFile createTestSubclass(TypeElement annotatedClass, String featureFilePath) throws IOException {
        return createTestSubclass(annotatedClass, featureFilePath, false);
    }

    /**
     * Creates a JUnit test subclass for the given type element annotated with {@link Feature2JUnit}.
     *
     * @param annotatedClass           the type element to create a test subclass for
     * @param featureFilePath          the feature file path
     * @param deriveClassNameFromFile  if true, derives the generated class name from the feature file name;
     *                                 if false, derives it from the annotated class name
     * @return a {@link JavaFile} representing the generated test subclass
     * @throws IOException if an error occurs during file generation
     */
    public JavaFile createTestSubclass(TypeElement annotatedClass, String featureFilePath, boolean deriveClassNameFromFile) throws IOException {
        String suffixToApply;
        if (options.isShouldBeConcrete()) {
            suffixToApply = options.getClassSuffixIfConcrete();
        } else {
            suffixToApply = options.getGeneratedClassSuffix();
        }
        String generatedClassName;
        String featureFilePathForParsing;

        if (deriveClassNameFromFile) {
            // Pattern-matched files: derive class name from feature file name
            String featureFileName = extractFeatureFileName(featureFilePath);
            generatedClassName = featureFileName + suffixToApply;
            // Use the feature file path as-is (no default derivation)
            featureFilePathForParsing = featureFilePath;
        } else {
            // Single file: derive class name from annotated class name
            String annotatedClassName = annotatedClass.getSimpleName().toString();
            generatedClassName = annotatedClassName + suffixToApply;
            // Allow default path derivation if path is blank
            featureFilePathForParsing = determineFeatureFilePath(featureFilePath, annotatedClass);
        }

        return createTestSubclassInternal(annotatedClass, featureFilePathForParsing, featureFilePath, generatedClassName);
    }

    /**
     * Internal method that contains the common logic for creating a test subclass.
     *
     * @param annotatedClass           the type element to create a test subclass for
     * @param featureFilePathForParsing the path to use for parsing the feature file
     * @param featureFilePathForAnnotation the path to use in the @FeatureFilePath annotation
     * @param generatedClassName       the name for the generated class (without package)
     * @return a {@link JavaFile} representing the generated test subclass
     * @throws IOException if an error occurs during file generation
     */
    private JavaFile createTestSubclassInternal(
            TypeElement annotatedClass,
            String featureFilePathForParsing,
            String featureFilePathForAnnotation,
            String generatedClassName) throws IOException {

        String packageName = extractPackageNameFromFeaturePath(featureFilePathForParsing);
        String annotatedClassName = annotatedClass.getSimpleName().toString();

        // Parse the feature file
        Feature feature = featureFileParser.parseUsingPath(featureFilePathForParsing);

        // Build the class
        TypeMirror asTypeMirror = annotatedClass.asType();
        TypeSpec.Builder classBuilder = TypeSpec
                .classBuilder(generatedClassName)
                .superclass(asTypeMirror)
                .addModifiers(Modifier.PUBLIC);

        if (!options.isShouldBeConcrete()) {
            classBuilder.addModifiers(Modifier.ABSTRACT);
        }

        // Add feature documentation and process feature content
        if (feature != null) {
            String featureTextJavaDoc = JavaDocUtils.toJavaDocContent(
                    feature.getKeyword(), feature.getName(), feature.getDescription());
            classBuilder.addJavadoc(CodeBlock.of(featureTextJavaDoc));

            // Pass 1: Collect data table metadata for LIST_OF_OBJECT_PARAMS option
            DataTableCollector dataTableCollector = null;
            if ("LIST_OF_OBJECT_PARAMS".equals(options.getDataTableParameterType())) {
                dataTableCollector = new DataTableCollector();
                collectDataTableMetadata(feature, dataTableCollector);
            }

            // Pass 2: Process feature and generate code
            FeatureProcessor featureProcessor = new FeatureProcessor(processingEnv, options, annotatedClass, dataTableCollector);
            featureProcessor.processFeature(feature, classBuilder);

            // Generate record types for LIST_OF_OBJECT_PARAMS
            if (dataTableCollector != null && dataTableCollector.hasDataTables()) {
                for (RecordMetadata metadata : dataTableCollector.getRecordMetadataMap().values()) {
                    TypeSpec recordType = RecordGenerator.generateRecord(metadata);
                    classBuilder.addType(recordType);
                }
            }

            // Add createDataTable method if needed
            addDataTableMethodsIfNeeded(annotatedClass, feature, classBuilder, dataTableCollector);
        }

        // Add class annotations
        List<Tag> featureTags = feature != null ? feature.getTags() : Collections.emptyList();
        boolean hasRules = feature != null && feature.getChildren().stream()
                .anyMatch(child -> child.getRule().isPresent());
        boolean hasScenarios = feature != null && feature.getChildren().stream()
                .anyMatch(child -> child.getScenario().isPresent());

        addClassAnnotations(
                featureTags, hasRules, hasScenarios, classBuilder,
                featureFilePathForParsing, featureFilePathForAnnotation,
                packageName, annotatedClassName);

        TypeSpec typeSpec = classBuilder.build();

        return JavaFile.builder(packageName, typeSpec)
                .indent("    ")
                .build();
    }

    /**
     * Extracts the package name from the annotated class element.
     */
    private String extractPackageName(TypeElement annotatedClass) {
        Element enclosingElement = annotatedClass.getEnclosingElement();

        if (enclosingElement != null) {
            if (!(enclosingElement instanceof PackageElement)) {
                throw new ProcessingException(
                        "The class annotated with @" + Feature2JUnit.class.getSimpleName() +
                                " must have package as its enclosing element, but was - " + enclosingElement);
            }

            PackageElement packageElement = (PackageElement) enclosingElement;
            return packageElement.getQualifiedName().toString();
        }

        return "";
    }

    /**
     * Extracts the package name from the feature file path.
     * Example: "features/checkout/cart/cart.feature" → "features.checkout.cart"
     */
    private String extractPackageNameFromFeaturePath(String featureFilePath) {
        String packagePath = featureFilePath;

        // Remove the file name (everything after the last /)
        if (packagePath.contains("/")) {
            packagePath = packagePath.substring(0, packagePath.lastIndexOf("/"));
        } else {
            // If there's no directory separator, the file is in the root, return empty package
            return "";
        }

        // Replace / with . to create a valid Java package name
        return packagePath.replace("/", ".");
    }

    /**
     * Determines the feature file path to use for parsing.
     * If the provided path is blank, constructs a default path based on the package and class name.
     */
    private String determineFeatureFilePath(String featureFilePath, TypeElement annotatedClass) {
        if (StringUtils.isBlank(featureFilePath)) {
            String packageName = extractPackageName(annotatedClass);
            String annotatedClassName = annotatedClass.getSimpleName().toString();

            String path = "";
            if (StringUtils.isNotBlank(packageName)) {
                path = packageName.replaceAll("\\.", "/") + "/";
            }
            path += annotatedClassName + ".feature";
            return path;
        }

        return featureFilePath;
    }

    /**
     * Extracts the feature file name (without extension) from a feature file path.
     * Example: "features/user/Login.feature" → "Login"
     */
    String extractFeatureFileName(String featureFilePath) {
        String fileName = featureFilePath;

        // Remove directory path
        if (fileName.contains("/")) {
            fileName = fileName.substring(fileName.lastIndexOf("/") + 1);
        }

        // Remove .feature extension
        if (fileName.endsWith(".feature")) {
            fileName = fileName.substring(0, fileName.lastIndexOf("."));
        }

        return fileName;
    }

    /**
     * Collects data table metadata from all steps in the feature.
     * This is the first pass that identifies all record types needed for LIST_OF_OBJECT_PARAMS generation.
     */
    private void collectDataTableMetadata(Feature feature, DataTableCollector collector) {
        for (FeatureChild child : feature.getChildren()) {
            if (child.getScenario().isPresent()) {
                Scenario scenario = child.getScenario().get();
                collectDataTableMetadataFromSteps(scenario.getSteps(), collector);
            } else if (child.getRule().isPresent()) {
                Rule rule = child.getRule().get();
                for (RuleChild ruleChild : rule.getChildren()) {
                    if (ruleChild.getBackground().isPresent()) {
                        Background background = ruleChild.getBackground().get();
                        collectDataTableMetadataFromSteps(background.getSteps(), collector);
                    }
                    if (ruleChild.getScenario().isPresent()) {
                        Scenario scenario = ruleChild.getScenario().get();
                        collectDataTableMetadataFromSteps(scenario.getSteps(), collector);
                    }
                }
            } else if (child.getBackground().isPresent()) {
                Background background = child.getBackground().get();
                collectDataTableMetadataFromSteps(background.getSteps(), collector);
            }
        }
    }

    /**
     * Collects data table metadata from a list of steps.
     */
    private void collectDataTableMetadataFromSteps(List<Step> steps, DataTableCollector collector) {
        for (Step step : steps) {
            if (step.getDataTable().isPresent()) {
                io.cucumber.messages.types.DataTable dt = step.getDataTable().get();
                List<String> headers = dt.getRows().get(0).getCells()
                        .stream()
                        .map(TableCell::getValue)
                        .toList();
                String stepText = step.getKeyword() + step.getText();
                collector.registerDataTable(stepText, headers);
            }
        }
    }

    /**
     * Adds DataTable helper methods to the class builder if the feature contains steps with data tables.
     */
    private void addDataTableMethodsIfNeeded(
            TypeElement annotatedClass,
            Feature feature,
            TypeSpec.Builder classBuilder,
            DataTableCollector dataTableCollector) {

        boolean featureHasStepWithDataTable = FeatureStepUtils.featureHasStepWithDataTable(feature);
        if (featureHasStepWithDataTable) {
            Set<String> allInheritedMethodNames = ElementMethodUtils.getAllInheritedMethodNames(
                    processingEnv, annotatedClass);

            String dataTableParameterType = options.getDataTableParameterType();

            if ("LIST_OF_OBJECT_PARAMS".equals(dataTableParameterType)) {
                // Add createListOfMaps base method if not present in class hierarchy
                boolean alreadyHasCreateListOfMaps = allInheritedMethodNames.contains("createListOfMaps");
                if (!alreadyHasCreateListOfMaps) {
                    MethodSpec createListOfMapsMethod = TableUtils.createListOfMapsMethod(processingEnv);
                    classBuilder.addMethod(createListOfMapsMethod);
                }

                // Add createListOf<RecordName> methods for each record type
                if (dataTableCollector != null && dataTableCollector.hasDataTables()) {
                    for (RecordMetadata recordMetadata : dataTableCollector.getRecordMetadataMap().values()) {
                        String methodName = "createListOf" + recordMetadata.getRecordName();
                        boolean alreadyHasMethod = allInheritedMethodNames.contains(methodName);

                        if (!alreadyHasMethod) {
                            MethodSpec createListOfRecordMethod =
                                    TableUtils.createListOfRecordMethod(processingEnv, recordMetadata);
                            classBuilder.addMethod(createListOfRecordMethod);
                        }
                    }
                }
            } else if (LIST_OF_MAPS.name().equals(dataTableParameterType)) {
                // Add createListOfMaps if not present in class hierarchy
                boolean alreadyHasCreateListOfMaps = allInheritedMethodNames.contains("createListOfMaps");
                if (!alreadyHasCreateListOfMaps) {
                    MethodSpec createListOfMapsMethod = TableUtils.createListOfMapsMethod(processingEnv);
                    classBuilder.addMethod(createListOfMapsMethod);
                }
            } else {
                // Default: CUCUMBER_DATA_TABLE
                // Add getTableConverter if not present in class hierarchy
                boolean alreadyHasGetTableConverter = allInheritedMethodNames.contains("getTableConverter");
                if (!alreadyHasGetTableConverter) {
                    MethodSpec getTableConverterMethod = TableUtils.createGetTableConverterMethod(processingEnv);
                    classBuilder.addMethod(getTableConverterMethod);
                }

                // Add createDataTable if not present in class hierarchy
                boolean alreadyHasCreateDataTable = allInheritedMethodNames.contains("createDataTable");
                if (!alreadyHasCreateDataTable) {
                    MethodSpec createDataTableMethod = TableUtils.createDataTableMethod(processingEnv);
                    classBuilder.addMethod(createDataTableMethod);
                }
            }
        }
    }

    private static void addClassAnnotations(
            List<Tag> featureTags,
            boolean hasRules,
            boolean hasScenarios,
            TypeSpec.Builder classBuilder,
            String featureFilePathForParsing,
            String featureFilePath,
            String packageName,
            String annotatedClassName) {

        if (!featureTags.isEmpty()) {
            AnnotationSpec jUnitTagsAnnotation = TagUtils.toJUnitTagsAnnotation(featureTags);
            classBuilder.addAnnotation(jUnitTagsAnnotation);
        }

        /**
         * {@link DisplayName} annotation
         */
        String featureFileName = featureFilePathForParsing.substring(
                featureFilePathForParsing.lastIndexOf("/") + 1,
                featureFilePathForParsing.lastIndexOf(".")
        );
        classBuilder.addAnnotation(AnnotationSpec
                .builder(DisplayName.class)
                .addMember("value", "\"" + featureFileName + "\"")
                .build()
        );

        /**
         * {@link Generated} annotation
         */
        classBuilder.addAnnotation(AnnotationSpec
                .builder(Generated.class)
                .addMember("value", "\"" + Feature2JUnitGenerator.class.getName() + "\"")
                //                .addMember("comments", "\"GWT methods have been created with failing assumptions. Copy these into the base class and implement them.\"")
                .build()
        );
        if (hasScenarios) {
            /**
             * {@link TestMethodOrder} annotation
             */
            classBuilder.addAnnotation(AnnotationSpec
                    .builder(TestMethodOrder.class)
                    .addMember("value", "$T.class", ClassName.get(MethodOrderer.OrderAnnotation.class))
                    .build()
            );
        }
        if (hasRules) {
            /**
             * {@link TestClassOrder} annotation
             */
            classBuilder.addAnnotation(AnnotationSpec
                    .builder(TestClassOrder.class)
                    .addMember("value", "$T.class", ClassName.get(ClassOrderer.OrderAnnotation.class))
                    .build()
            );
        }
        /**
         * {@link FeatureFilePath} annotation
         */
        String featureFilePathForAnnotation;
        if (featureFilePath == null || featureFilePath.isBlank()) {
            if (StringUtils.isNotBlank(packageName)) {
                featureFilePathForAnnotation = packageName.replaceAll("\\.", "/") + "/" + annotatedClassName + ".feature";
            } else {
                featureFilePathForAnnotation = annotatedClassName + ".feature";
            }
        } else {
            featureFilePathForAnnotation = featureFilePath;
        }
        classBuilder.addAnnotation(AnnotationSpec
                .builder(FeatureFilePath.class)
                .addMember("value", "\"" + featureFilePathForAnnotation + "\"")
                .build()
        );
    }

    @Override
    public ProcessingEnvironment getProcessingEnv() {
        return processingEnv;
    }
}