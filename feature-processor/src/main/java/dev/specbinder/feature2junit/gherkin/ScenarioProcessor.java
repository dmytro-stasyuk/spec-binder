package dev.specbinder.feature2junit.gherkin;

import com.squareup.javapoet.AnnotationSpec;
import com.squareup.javapoet.MethodSpec;
import com.squareup.javapoet.TypeSpec;
import dev.specbinder.common.*;
import dev.specbinder.feature2junit.gherkin.utils.*;
import io.cucumber.messages.types.*;
import org.apache.commons.lang3.StringUtils;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

import javax.annotation.processing.ProcessingEnvironment;
import javax.lang.model.element.Modifier;
import javax.lang.model.element.TypeElement;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

class ScenarioProcessor implements LoggingSupport, OptionsSupport, BaseTypeSupport {

    private final ProcessingEnvironment processingEnv;
    private final GeneratorOptions options;
    private final TypeElement baseType;
    private final Set<String> baseClassMethodNames;

    public ScenarioProcessor(ProcessingEnvironment processingEnv, GeneratorOptions options, TypeElement baseType) {
        this.processingEnv = processingEnv;
        this.options = options;
        this.baseType = baseType;

        baseClassMethodNames = ElementMethodUtils.getAllInheritedMethodNames(processingEnv, baseType);
    }

    public ProcessingEnvironment getProcessingEnv() {
        return processingEnv;
    }

    public GeneratorOptions getOptions() {
        return options;
    }

    public TypeElement getBaseType() {
        return baseType;
    }


    MethodSpec.Builder processScenario(int scenarioNumber, Scenario scenario, TypeSpec.Builder classBuilder) {

        List<MethodSpec> allMethodSpecs = classBuilder.methodSpecs;

        List<Step> scenarioSteps = scenario.getSteps();
        List<MethodSpec> scenarioStepsMethodSpecs = new ArrayList<>(scenarioSteps.size());

        String scenarioMethodName = "scenario_" + scenarioNumber;
        MethodSpec.Builder scenarioMethodBuilder = MethodSpec
                .methodBuilder(scenarioMethodName)
                //                .addParameter(TestInfo.class, "testInfo")
                .addModifiers(Modifier.PUBLIC);

        String description = scenario.getDescription();
        if (StringUtils.isNotBlank(description)) {
            description = JavaDocUtils.trimLeadingAndTrailingWhitespace(description);
            scenarioMethodBuilder.addJavadoc(description);
        }

        List<Examples> examples = scenario.getExamples();
        List<String> scenarioParameterNames;
        List<String> testMethodParameterNames;

        if (examples != null && !examples.isEmpty()) {

            scenarioParameterNames = addJUnitAnnotationsForParameterizedTest(scenarioMethodBuilder, scenario);
            testMethodParameterNames = new ArrayList<>(scenarioParameterNames.size());

            for (String scenarioParameterName : scenarioParameterNames) {
                String methodParameterName = ParameterNamingUtils.toMethodParameterName(scenarioParameterName);
                testMethodParameterNames.add(methodParameterName);
                scenarioMethodBuilder.addParameter(String.class, methodParameterName);
            }
        } else {
            scenarioParameterNames = null;
            testMethodParameterNames = null;

            addJUnitAnnotationsForSingleTest(scenarioMethodBuilder, scenario);
        }

        addOrderAnnotation(scenarioMethodBuilder, scenarioNumber);

        List<Tag> tags = scenario.getTags();
        if (tags != null && !tags.isEmpty()) {
            AnnotationSpec jUnitTagsAnnotation = TagUtils.toJUnitTagsAnnotation(tags);
            scenarioMethodBuilder.addAnnotation(jUnitTagsAnnotation);
        }

        // Add tag for empty scenarios before @DisplayName
        if (scenarioSteps.isEmpty()) {
            String tagForEmptyScenarios = options.getTagForScenariosWithNoSteps();
            if (StringUtils.isNotBlank(tagForEmptyScenarios)) {
                AnnotationSpec jUnitTagsAnnotation = TagUtils.toJUnitTagsAnnotation(tagForEmptyScenarios);
                scenarioMethodBuilder.addAnnotation(jUnitTagsAnnotation);
            }
        }

        if (options.isAddSourceLineAnnotations()) {
            AnnotationSpec locationAnnotation = LocationUtils.toJUnitTagsAnnotation(scenario.getLocation());
            scenarioMethodBuilder.addAnnotation(locationAnnotation);
        }

        addDisplayNameAnnotation(scenarioMethodBuilder, scenario);

        if (scenarioSteps.isEmpty()) {

            if (options.isFailScenariosWithNoSteps()) {
                /**
                 * add an empty method that throws an exception
                 */
                scenarioMethodBuilder.addStatement("$T.fail(\"Scenario has no steps\")", Assertions.class);
            }

        } else {

            for (Step scenarioStep : scenarioSteps) {

                StepProcessor stepProcessor = new StepProcessor(processingEnv, options);
                MethodSpec stepMethodSpec = stepProcessor.processStep(
                        scenarioStep, scenarioMethodBuilder, scenarioStepsMethodSpecs,
                        scenarioParameterNames, testMethodParameterNames
                );
                scenarioStepsMethodSpecs.add(stepMethodSpec);

                String stepMethodName = stepMethodSpec.name;
                MethodSpec existingMethodSpec =
                        allMethodSpecs.stream().filter(methodSpec -> methodSpec.name.equals(stepMethodName))
                                .findFirst()
                                .orElse(null);

                if (existingMethodSpec == null) {
                    // If the method already exists, we can skip creating it again
                    boolean baseClassHasMethod = baseClassMethodNames.contains(stepMethodName);
                    if (baseClassHasMethod) {
                        logInfo("Skipping generation of method '" + stepMethodName + "', as base class already contains it");
//                        logInfo("Skipping generation of  Base class " + baseType.getQualifiedName() + " already has method '" + stepMethodName + "', ");
                    } else {
                        classBuilder.addMethod(stepMethodSpec);
                    }
                }
            }

        }

        return scenarioMethodBuilder;
    }

    private void addDisplayNameAnnotation(MethodSpec.Builder scenarioMethodBuilder, Scenario scenario) {

        String scenarioKeyword = scenario.getKeyword().trim();
        String scenarioName = scenario.getName();
        if (scenarioName != null) {
            scenarioName = scenarioName.replaceAll("\"", "\\\\\"");
            if (!scenarioName.isEmpty()) {
                scenarioName = " " + scenarioName;
            }
        }
        AnnotationSpec displayNameAnnotation = AnnotationSpec
                .builder(DisplayName.class)
                .addMember("value", "\"" + scenarioKeyword + ":" + scenarioName + "\"")
                .build();
        scenarioMethodBuilder.addAnnotation(displayNameAnnotation);
    }

    private void addOrderAnnotation(MethodSpec.Builder scenarioMethodBuilder, int scenarioNumber) {

        AnnotationSpec orderAnnotation = AnnotationSpec
                .builder(Order.class)
                .addMember("value", "" + scenarioNumber)
                .build();
        scenarioMethodBuilder.addAnnotation(orderAnnotation);
    }

    private void addJUnitAnnotationsForSingleTest(MethodSpec.Builder scenarioMethodBuilder, Scenario scenario) {

        AnnotationSpec testAnnotation = AnnotationSpec
                .builder(Test.class)
                .build();
        scenarioMethodBuilder.addAnnotation(testAnnotation);
    }

    private List<String> addJUnitAnnotationsForParameterizedTest(
            MethodSpec.Builder scenarioMethodBuilder,
            Scenario scenario) {

        List<Examples> examples = scenario.getExamples();
        if (examples.size() > 1) {
            throw new ProcessingException(
                    "ERROR: Multiple Examples sections are not supported. " +
                            "Only one Examples section is allowed per Scenario Outline but found = " + examples.size());
        }

        Examples examplesTable = examples.get(0);

        /**
         * convert Examples into data table so that we can format it easily with pipe characters
         */
        TableRow tableHeader = examplesTable.getTableHeader().get();
        List<TableRow> tableBody = examplesTable.getTableBody();
        List<TableRow> allRows = new ArrayList<>(tableBody.size() + 1);
        allRows.add(tableHeader);
        allRows.addAll(tableBody);

        Location examplesTableLocation = examplesTable.getLocation();
        DataTable examplesDataTable = new DataTable(examplesTableLocation, allRows);

        List<Integer> maxColumnLengths = TableUtils.workOutMaxColumnLength(examplesDataTable);

        StringBuilder textBlockSB = new StringBuilder();
        textBlockSB.append("\"\"\"\n");

        for (TableRow row : allRows) {

            List<TableCell> rowCells = row.getCells();
            List<String> cellValues = new ArrayList<>(rowCells.size());

            for (int i = 0; i < rowCells.size(); i++) {
                TableCell cell = rowCells.get(i);
                String value = cell.getValue();

                // Pad all columns except the last one to avoid trailing spaces
                if (i < rowCells.size() - 1) {
                    int maxColumnLength = maxColumnLengths.get(i);
                    String paddedValue = StringUtils.rightPad(value, maxColumnLength);
                    cellValues.add(paddedValue);
                } else {
                    // Last column - don't pad to avoid trailing spaces
                    cellValues.add(value);
                }
            }

            String rowLine = String.join(" | ", cellValues);
            textBlockSB.append(rowLine);
            textBlockSB.append("\n");
        }

        textBlockSB.append("\"\"\"");

        String textBlock = textBlockSB.toString();

        AnnotationSpec parameterizedTestAnnotation = AnnotationSpec
                .builder(ParameterizedTest.class)
                .addMember("name", "\"Example {index}: [{arguments}]\"")
                .build();
        scenarioMethodBuilder
                .addAnnotation(parameterizedTestAnnotation);

        AnnotationSpec csvSourceAnnotation = AnnotationSpec
                .builder(CsvSource.class)
                .addMember("useHeadersInDisplayName", "true")
                .addMember("delimiter", "'|'")
                .addMember("textBlock", textBlock)
                .build();
        scenarioMethodBuilder
                .addAnnotation(csvSourceAnnotation);

        List<String> headerCells = examplesTable.getTableHeader().get().getCells().stream().map(TableCell::getValue).toList();
        return headerCells;
    }

}
