package dev.specbinder.feature2junit.gherkin;

import com.squareup.javapoet.AnnotationSpec;
import com.squareup.javapoet.MethodSpec;
import com.squareup.javapoet.TypeSpec;
import dev.specbinder.common.BaseTypeSupport;
import dev.specbinder.common.GeneratorOptions;
import dev.specbinder.common.LoggingSupport;
import dev.specbinder.common.OptionsSupport;
import dev.specbinder.feature2junit.gherkin.utils.ElementMethodUtils;
import dev.specbinder.feature2junit.gherkin.utils.JavaDocUtils;
import dev.specbinder.feature2junit.gherkin.utils.LocationUtils;
import io.cucumber.messages.types.Background;
import io.cucumber.messages.types.Step;
import org.apache.commons.lang3.StringUtils;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.TestInfo;

import javax.annotation.processing.ProcessingEnvironment;
import javax.lang.model.element.Modifier;
import javax.lang.model.element.TypeElement;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

class BackgroundProcessor implements LoggingSupport, OptionsSupport, BaseTypeSupport {

    private final ProcessingEnvironment processingEnv;
    private final GeneratorOptions options;
    private final TypeElement baseType;
    private final Set<String> baseClassMethodNames;

    BackgroundProcessor(ProcessingEnvironment processingEnv, GeneratorOptions options, TypeElement baseType) {
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


    MethodSpec.Builder processFeatureBackground(Background background, TypeSpec.Builder classBuilder) {

        return processBackground(background, classBuilder, "featureBackground");
    }

    MethodSpec.Builder processRuleBackground(Background background, TypeSpec.Builder classBuilder) {

        return processBackground(background, classBuilder, "ruleBackground");
    }

    private MethodSpec.Builder processBackground(
            Background background,
            TypeSpec.Builder classBuilder,
            String backgroundMethodName) {

        List<MethodSpec> allMethodSpecs = classBuilder.methodSpecs;

        List<Step> backgroundSteps = background.getSteps();
        List<MethodSpec> backgroundStepsMethodSpecs = new ArrayList<>(backgroundSteps.size());

        MethodSpec.Builder backgroundMethodBuilder = MethodSpec
                .methodBuilder(backgroundMethodName)
                .addModifiers(Modifier.PUBLIC);

        if (options.isAddSourceLineAnnotations()) {
            AnnotationSpec locationAnnotation = LocationUtils.toJUnitTagsAnnotation(background.getLocation());
            backgroundMethodBuilder.addAnnotation(locationAnnotation);
        }

        String description = background.getDescription();
        if (StringUtils.isNotBlank(description)) {
            description = JavaDocUtils.trimLeadingAndTrailingWhitespace(description);
            backgroundMethodBuilder.addJavadoc(description);
        }

        addJUnitAnnotations(backgroundMethodBuilder, background);

        backgroundMethodBuilder.addParameter(TestInfo.class, "testInfo");

        for (Step scenarioStep : backgroundSteps) {

            StepProcessor stepProcessor = new StepProcessor(processingEnv, options);
            MethodSpec stepMethodSpec = stepProcessor.processStep(scenarioStep, backgroundMethodBuilder, backgroundStepsMethodSpecs);
            backgroundStepsMethodSpecs.add(stepMethodSpec);

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
                } else {
                    classBuilder.addMethod(stepMethodSpec);
                }
            }
        }

        return backgroundMethodBuilder;
    }

    private void addJUnitAnnotations(MethodSpec.Builder scenarioMethodBuilder, Background background) {

        String backgroundName = background.getName();
        String displayNameValue;
        if (StringUtils.isBlank(backgroundName)) {
            displayNameValue = background.getKeyword() + ":";
        } else {
            backgroundName = backgroundName.replaceAll("\"", "\\\\\"");
            displayNameValue = "Background: " + backgroundName;
        }
        AnnotationSpec displayNameAnnotation = AnnotationSpec
                .builder(DisplayName.class)
                .addMember("value", "\"" + displayNameValue + "\"")
                .build();

        AnnotationSpec testAnnotation = AnnotationSpec
                .builder(BeforeEach.class)
                .build();
        scenarioMethodBuilder
                .addAnnotation(testAnnotation)
                .addAnnotation(displayNameAnnotation);
    }

}
