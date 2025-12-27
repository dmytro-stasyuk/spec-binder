package dev.spec2test.feature2junit.gherkin;

import com.squareup.javapoet.AnnotationSpec;
import com.squareup.javapoet.CodeBlock;
import com.squareup.javapoet.MethodSpec;
import com.squareup.javapoet.ParameterSpec;
import dev.spec2test.common.GeneratorOptions;
import dev.spec2test.common.LoggingSupport;
import dev.spec2test.common.OptionsSupport;
import dev.spec2test.common.ProcessingException;
import dev.spec2test.feature2junit.gherkin.utils.MethodNamingUtils;
import dev.spec2test.feature2junit.gherkin.utils.TableUtils;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.messages.types.DataTable;
import io.cucumber.messages.types.DocString;
import io.cucumber.messages.types.Location;
import io.cucumber.messages.types.Step;
import org.apache.commons.lang3.StringUtils;
import org.junit.jupiter.api.Assertions;

import javax.annotation.processing.ProcessingEnvironment;
import javax.lang.model.element.Modifier;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

class StepProcessor implements LoggingSupport, OptionsSupport {

    private final ProcessingEnvironment processingEnv;
    private final GeneratorOptions options;

    private static final Pattern parameterPattern = Pattern.compile("(?<parameter>(\")(?<parameterValue>[^\"]+?)(\"))");

    public StepProcessor(ProcessingEnvironment processingEnv, GeneratorOptions options) {
        this.processingEnv = processingEnv;
        this.options = options;
    }

    public ProcessingEnvironment getProcessingEnv() {
        return processingEnv;
    }

    public GeneratorOptions getOptions() {
        return options;
    }

    private record MethodSignatureAttributes(
            String stepPattern,
            String methodName,
            List<String> parameterValues
    ) {

    }

    MethodSpec processStep(
            Step step, MethodSpec.Builder scenarioMethodBuilder,
            List<MethodSpec> scenarioStepsMethodSpecs) {

        return processStep(step, scenarioMethodBuilder, scenarioStepsMethodSpecs, null, null);
    }

    public MethodSpec processStep(
            Step step,
            MethodSpec.Builder scenarioMethodBuilder,
            List<MethodSpec> scenarioStepsMethodSpecs,
            List<String> scenarioParameterNames,
            List<String> testMethodParameterNames
    ) {

        long stepLine = step.getLocation().getLine();

        /**
         * use only the first line of the step text for creating a method name
         */
        String stepText = step.getKeyword() + " " + step.getText();
        String[] lines = stepText.trim().split("\\n");
        String stepFirstLine = lines[0].trim();

        /**
         * create a potential new method to add to the test class
         * it won't be actually added if a method with exactly the same signature already exists
         */
        MethodSignatureAttributes stepMethodSignatureAttributes = extractMethodSignature(
                stepFirstLine, scenarioParameterNames, scenarioStepsMethodSpecs, stepLine
        );
        String stepMethodName = stepMethodSignatureAttributes.methodName;
        MethodSpec.Builder stepMethodBuilder = MethodSpec
                .methodBuilder(stepMethodName)
                .addModifiers(Modifier.PUBLIC);

        if (options.isShouldBeAbstract()) {
            stepMethodBuilder.addModifiers(Modifier.ABSTRACT);
        }
        else {
            // in case the generated test class is not abstract the body of the method should simply throw a
            // failing exception
            stepMethodBuilder.addStatement("$T.fail(\"Step is not yet implemented\")", Assertions.class);
        }

        if (options.isAddCucumberStepAnnotations()) {
            AnnotationSpec annotationSpec = buildGWTAnnotation(scenarioStepsMethodSpecs,
                    step.getKeyword().trim(), stepMethodName,
                    stepLine, stepMethodSignatureAttributes
            );
            stepMethodBuilder.addAnnotation(annotationSpec);
        }

        /**
         * construct our method parameter
         */
        List<String> parameterValues = stepMethodSignatureAttributes.parameterValues;
        for (int j = 0; j < parameterValues.size(); j++) {
            String parameterName = "p" + (j + 1);
            ParameterSpec parameterSpec = ParameterSpec
                    .builder(String.class, parameterName)
                    .build();
            stepMethodBuilder.addParameter(parameterSpec);
        }
        /**
         * check if step has a data table
         */
        if (step.getDataTable().isPresent()) {
            //            String parameterName = "p" + (parameterValues.size()); // data table is the last parameter
            ParameterSpec dataTableParameterSpec = ParameterSpec
                    .builder(io.cucumber.datatable.DataTable.class, "dataTable")
                    .build();
            stepMethodBuilder.addParameter(dataTableParameterSpec);
        }
        /**
         * check if step has doc string
         */
        else if (step.getDocString().isPresent()) {
            ParameterSpec docStringSpec = ParameterSpec
                    .builder(String.class, "docString")
                    .build();
            stepMethodBuilder.addParameter(docStringSpec);
        }

        // add a call to the step method in the scenario method
        addACallToTheStepMethod(scenarioMethodBuilder,
                stepMethodName,
                parameterValues,
                step,
                scenarioParameterNames,
                testMethodParameterNames);

        MethodSpec stepMethodSpec = stepMethodBuilder.build();
        return stepMethodSpec;
    }

    private void addACallToTheStepMethod(
            MethodSpec.Builder scenarioMethodBuilder,
            String stepMethodName,
            List<String> parameterValues, Step step,
            List<String> scenarioParameterNames, List<String> testMethodParameterNames
    ) {

        /**
         * add javadoc for the step as it appears in the feature file
         */
        String stepFirstLine = step.getKeyword() + step.getText();
        //        scenarioMethodBuilder.addCode("/**\n * $L\n */\n", stepFirstLine);
        scenarioMethodBuilder.addCode("/**");
        scenarioMethodBuilder.addCode("\n * $L", stepFirstLine);
        if (options.isAddSourceLineAnnotations()) {
            Location stepLocation = step.getLocation();
            scenarioMethodBuilder.addCode("\n * (source line - $L", stepLocation.getLine() + ")");
        }
        scenarioMethodBuilder.addCode("\n */\n");

        /**
         * replace all occurrences of '$' with a '$L' placeholders and replace back with '$'
         */
        StringBuilder methodNameWithPlaceholdersSB = new StringBuilder();
        int searchingFrom = 0;
        int totalDollarSigns = 0;
        int indexOfDollarSign = stepMethodName.indexOf('$', searchingFrom);
        while (indexOfDollarSign > -1) {

            String beforeDollarSign = stepMethodName.substring(searchingFrom, indexOfDollarSign);
            methodNameWithPlaceholdersSB.append(beforeDollarSign);

            methodNameWithPlaceholdersSB.append("$L"); // placeholder for parameter
            totalDollarSigns++;

            searchingFrom = indexOfDollarSign + 1;
            indexOfDollarSign = stepMethodName.indexOf('$', searchingFrom);
        }
        if (searchingFrom < stepMethodName.length()) {
            String afterDollarSign = stepMethodName.substring(searchingFrom);
            methodNameWithPlaceholdersSB.append(afterDollarSign);
        }
        String methodNameWithPlaceholders = methodNameWithPlaceholdersSB.toString();
        String[] formatArgs = new String[totalDollarSigns]; // todo - implement above replacement using regexp
        Arrays.fill(formatArgs, "$");

        /**
         * construct parameter values
         */
        StringBuilder parameterValuesSB = new StringBuilder();
        for (int j = 0; j < parameterValues.size(); j++) {
            if (j > 0) {
                parameterValuesSB.append(", ");
            }
            String parameterValue = parameterValues.get(j);
            /**
             * in case of scenario with Examples section we check if parameter value is actually a reference
             * to a scenario parameter - if so, we replace it with the reference to the Scenario's test method parameter
             */
            String scenarioParameter = getScenarioParameter(parameterValue, scenarioParameterNames, testMethodParameterNames);
            if (scenarioParameter != null) {
                /**
                 * no quote marks in this case as we are passing a reference to a Scenario test method parameter
                 */
                parameterValuesSB.append(scenarioParameter);
            }
            else {
                parameterValuesSB.append("\"");
                parameterValuesSB.append(parameterValue);
                parameterValuesSB.append("\"");
            }
        }

        if (step.getDataTable().isPresent()) {

            if (!parameterValues.isEmpty()) {
                parameterValuesSB.append(", ");
            }

            DataTable dataTableMsg = step.getDataTable().get();
            List<Integer> maxColumnLength = TableUtils.workOutMaxColumnLength(dataTableMsg);
            String dataTableAsString = TableUtils.convertDataTableToString(dataTableMsg, maxColumnLength);

            parameterValuesSB.append("createDataTable(");
            parameterValuesSB.append("\"\"\"\n");
            parameterValuesSB.append(dataTableAsString);
            parameterValuesSB.append("\n\"\"\"");

            /**
             * in case we are processing a scenario with examples table i.e. Scenario Template type
             * then we need to replace any references to scenario parameters with reference value from the examples table
             */
            if (scenarioParameterNames != null && !scenarioParameterNames.isEmpty()) {
                for (String scenarioParameterName : scenarioParameterNames) {
                    parameterValuesSB.append("\n.replaceAll(");
                    parameterValuesSB.append("\"<" + scenarioParameterName + ">\"");
                    parameterValuesSB.append(", ");
                    parameterValuesSB.append(scenarioParameterName);
                    parameterValuesSB.append(")");
                }
            }

            parameterValuesSB.append(")");

        }
        else if (step.getDocString().isPresent()) {

            if (!parameterValues.isEmpty()) {
                parameterValuesSB.append(", ");
            }

            DocString docString1 = step.getDocString().get();
            String docString = docString1.getContent();

            // need to escape any occurrences of triple quotes in the doc string content
            docString = docString.replaceAll("\"\"\"", "\\\\\"\"\"");

            // Escape $ for JavaPoet ($ is a special character in JavaPoet's format strings)
            // Must be done AFTER triple quote escaping to avoid double-escaping
            docString = docString.replace("$", "$$");

            /**
             * in case we are processing a scenario with examples table i.e. Scenario Template type
             * then we need to replace any references to scenario parameters with reference value from the examples table
             */
            if (scenarioParameterNames != null && !scenarioParameterNames.isEmpty()) {

                parameterValuesSB.append("\"\"\"\n");
                parameterValuesSB.append(docString);
                parameterValuesSB.append("\n\"\"\"");

                for (String scenarioParameterName : scenarioParameterNames) {
                    parameterValuesSB.append("\n.replaceAll(");
                    parameterValuesSB.append("\"<" + scenarioParameterName + ">\"");
                    parameterValuesSB.append(", ");
                    parameterValuesSB.append(scenarioParameterName);
                    parameterValuesSB.append(")");
                }

            }
            else {
                parameterValuesSB.append("\"\"\"\n");
                parameterValuesSB.append(docString);
                parameterValuesSB.append("\n\"\"\"");
            }
        }

        String parameterValuesPart = parameterValuesSB.toString();
        CodeBlock codeBlock =
                CodeBlock.of(methodNameWithPlaceholders + "(" + parameterValuesPart + ")", (Object[]) formatArgs);

        scenarioMethodBuilder.addStatement(codeBlock);
    }

    private String getScenarioParameter(
            String parameterValue, List<String> scenarioParameterNames,
            List<String> testMethodParameterNames
    ) {

        if (scenarioParameterNames == null || scenarioParameterNames.isEmpty()) {
            return null; // no scenario parameters defined
        }

        if (parameterValue.startsWith("<") && parameterValue.endsWith(">") && parameterValue.length() > 2) {

            String valueWithoutBrackets = parameterValue.substring(1, parameterValue.length() - 1);
            int indexOfParameterName = scenarioParameterNames.indexOf(valueWithoutBrackets);
            if (indexOfParameterName > -1) {
                return testMethodParameterNames.get(indexOfParameterName);
            }
        }

        return null; // not a scenario parameter
    }

    private AnnotationSpec buildGWTAnnotation(
            List<MethodSpec> scenarioStepsMethodSpecs,
            String stepKeyword, String stepMethodName,
            long stepLine,
            MethodSignatureAttributes signatureAttributes) {

        List<String> parameterValues = signatureAttributes.parameterValues;

        String keywordLower = stepKeyword.toLowerCase();

        AnnotationSpec.Builder annotationSpecBuilder;
        if (keywordLower.equals("given")) {
            annotationSpecBuilder = AnnotationSpec.builder(Given.class);
        }
        else if (keywordLower.equals("when")) {
            annotationSpecBuilder = AnnotationSpec.builder(When.class);
        }
        else if (keywordLower.equals("then")) {
            annotationSpecBuilder = AnnotationSpec.builder(Then.class);
        }
        else if (
                keywordLower.equals("and") || keywordLower.equals("but")
                        || keywordLower.equals("*")
        ) {
            // 'And' is a special case, which is worked out using previous non And step keyword
            if (scenarioStepsMethodSpecs.isEmpty()) {
                throw new ProcessingException(
                        "Step on line - " + stepLine
                                + " starts with 'And', but there are no previous scenario steps defined");
            }
            MethodSpec lastScenarioMethodSpec = scenarioStepsMethodSpecs.get(scenarioStepsMethodSpecs.size() - 1);

            List<AnnotationSpec> methodAnnotationSpecs = lastScenarioMethodSpec.annotations;
            Class<?> gwtAnnotation = null;
            for (AnnotationSpec methodAnnotationSpec : methodAnnotationSpecs) {
                String annotationName = methodAnnotationSpec.type.toString();
                if (annotationName.equals(Given.class.getName())) {
                    gwtAnnotation = Given.class;
                    break;
                }
                else if (annotationName.equals(When.class.getName())) {
                    gwtAnnotation = When.class;
                    break;
                }
                else if (annotationName.equals(Then.class.getName())) {
                    gwtAnnotation = Then.class;
                    break;
                }
                else {
                    continue; // skip
                }
            }
            if (gwtAnnotation == null) {
                throw new ProcessingException(
                        "Step on line - " + stepLine
                                + " starts with 'And', but there are no previous scenario steps defined that have a step annotation");
            }

            annotationSpecBuilder = AnnotationSpec.builder(gwtAnnotation);

        }
        else {
            throw new ProcessingException(
                    "Step method name does not start with a valid keyword (Given, When, Then, And): "
                            + stepMethodName);
        }

        String stepPattern = signatureAttributes.stepPattern;

        String[] args = new String[parameterValues.size() + 1];
        for (int j = 0; j < parameterValues.size(); j++) {
            //            args[j] = "$p" + (j + 1);
            args[j] = "(?<p" + (j + 1) + ">.*)";
        }
        String stepPatternWithMarkers =
                stepPattern.replaceAll("\s\\$p[0-9]{1,2}(\s|$)", " \\$L$1");

        String[] words = stepPatternWithMarkers.split("\\s+");
        String[] stepTitleWords = Arrays.copyOfRange(words, 1, words.length); // trim the keyword
        String stepAnnotationValueTrimmed = StringUtils.join(stepTitleWords, " ");

        // Escape regex special characters in literal text, but preserve $L placeholders
        stepAnnotationValueTrimmed = escapeRegexSpecialCharacters(stepAnnotationValueTrimmed);

        // Escape literal dollar signs that are not part of JavaPoet placeholders ($L)
        // In JavaPoet, $$ represents a literal $
        stepAnnotationValueTrimmed = stepAnnotationValueTrimmed.replaceAll("\\$(?!L)", "\\$\\$");

        // Escape literal double quotes for regex pattern
        stepAnnotationValueTrimmed = stepAnnotationValueTrimmed.replace("\"", "\\\"");

        // prepend '^' and append '$' to the annotation pattern value so that IDE plugins discover this step
        stepAnnotationValueTrimmed = "^" + stepAnnotationValueTrimmed + "$L";
        args[args.length - 1] = "$"; // for the '$' at the end of the pattern

        annotationSpecBuilder.addMember("value", "\"" + stepAnnotationValueTrimmed + "\"", (Object[]) args);
        AnnotationSpec annotationSpec = annotationSpecBuilder.build();

        return annotationSpec;
    }

    /**
     * Escapes special regex characters in the step text while preserving $L placeholders for JavaPoet.
     * Special regex characters that need escaping: . ^ $ * + ? { } [ ] ( ) | \
     *
     * @param text the step text that may contain regex special characters
     * @return the text with regex special characters escaped
     */
    private String escapeRegexSpecialCharacters(String text) {
        // Characters that have special meaning in regex and need to be escaped with backslash
        // Note: We process the string character by character to preserve $L placeholders
        StringBuilder result = new StringBuilder();

        for (int i = 0; i < text.length(); i++) {
            char ch = text.charAt(i);

            // Check if this is a $L placeholder (skip escaping)
            if (ch == '$' && i + 1 < text.length() && text.charAt(i + 1) == 'L') {
                result.append("$L");
                i++; // skip the 'L'
                continue;
            }

            // Escape regex special characters
            // Use double backslash (\\) so that the generated Java source code has proper escaping
            switch (ch) {
                case '.':
                case '^':
                case '$':
                case '*':
                case '+':
                case '?':
                case '{':
                case '}':
                case '[':
                case ']':
                case '(':
                case ')':
                case '|':
                case '\\':
                    result.append("\\\\").append(ch);
                    break;
                default:
                    result.append(ch);
                    break;
            }
        }

        return result.toString();
    }

    private MethodSignatureAttributes extractMethodSignature(
            String stepFirstLine,
            List<String> scenarioParameterNames, List<MethodSpec> scenarioStepsMethodSpecs,
            long stepLine) {

        List<String> parameterValues = new ArrayList<>();

        String stepPattern = processWithParameterPattern(
                stepFirstLine, parameterPattern, parameterValues);

        if (scenarioParameterNames != null && !scenarioParameterNames.isEmpty()) {
            // process scenario parameters
            String paramsPatternPart = StringUtils.join(scenarioParameterNames, "|");
            Pattern scenarioParametersPattern = Pattern.compile(
                    "(?<parameter>(?<parameterValue>(<)(" + paramsPatternPart + ")(>)))"
            );
            stepPattern = processWithParameterPattern(stepPattern,
                    scenarioParametersPattern,
                    parameterValues);
        }

        String stepMethodName = MethodNamingUtils.getStepMethodName(stepPattern, scenarioStepsMethodSpecs, stepLine);

        MethodSignatureAttributes signatureAttributes = new MethodSignatureAttributes(
                stepPattern,
                stepMethodName,
                parameterValues
        );
        return signatureAttributes;
    }

    private record AnnotationPatternAttributes(
            String stepAnnotationPattern,
            String gwtAnnotationValue
    ) {

    }

    private String processWithParameterPattern(
            String stepFirstLine,
            Pattern parameterPattern,
            List<String> parameterValues) {

        int lastParameterEnd = 0;

        StringBuilder stepAnnotationPatternSB = new StringBuilder();

        Matcher matcher = parameterPattern.matcher(stepFirstLine);

        while (matcher.find()) {

            int parameterStart = matcher.start("parameter");
            int parameterEnd = matcher.end("parameter");

            int searchStartPos = lastParameterEnd;
            if (searchStartPos < parameterStart) {
                String before = stepFirstLine.substring(searchStartPos, parameterStart);
                stepAnnotationPatternSB.append(before);
            }

            stepAnnotationPatternSB.append("$p" + (parameterValues.size() + 1));

            String parameterValue = matcher.group("parameterValue");
            parameterValues.add(parameterValue);

            lastParameterEnd = parameterEnd;
        }

        if (lastParameterEnd < stepFirstLine.length()) {
            // There is some text after the last parameter
            String after = stepFirstLine.substring(lastParameterEnd);
            stepAnnotationPatternSB.append(after);
        }

        String stepAnnotationPattern = stepAnnotationPatternSB.toString();
        return stepAnnotationPattern;
    }

}