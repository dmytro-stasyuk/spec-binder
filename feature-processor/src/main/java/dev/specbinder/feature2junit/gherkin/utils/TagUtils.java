package dev.specbinder.feature2junit.gherkin.utils;

import com.squareup.javapoet.AnnotationSpec;
import io.cucumber.messages.types.Tag;
import org.junit.jupiter.api.Tags;

import java.util.Arrays;
import java.util.List;

/**
 * Utility class for converting Gherkin tags to JUnit annotations.
 */
public class TagUtils {

    private TagUtils() {
        /**
         * utility class
         */
    }

    /**
     * Converts an array of tag names to JUnit Tags annotations.
     *
     * @param tagNames the names of the tags to convert
     * @return an {@link AnnotationSpec} representing the JUnit Tags annotation
     */
    public static AnnotationSpec toJUnitTagsAnnotation(String... tagNames) {

        List<String> tagNamesList = Arrays.asList(tagNames);

        AnnotationSpec.Builder annotationSpecBuilderFromTagNames = annotationSpecBuilderFromTagNames(tagNamesList);
        AnnotationSpec annotationSpec = annotationSpecBuilderFromTagNames.build();
        return annotationSpec;
    }

    /**
     * Converts a list of Gherkin tags to a JUnit Tags annotation.
     * @param tags the list of Gherkin tags to convert
     * @return an {@link AnnotationSpec} representing the JUnit Tags annotation
     */
    public static AnnotationSpec toJUnitTagsAnnotation(List<Tag> tags) {

        AnnotationSpec.Builder annotationSpecBuilder;

        List<String> tagNames = tags.stream()
                .map(tag -> tag.getName().trim())
                .map(tagName -> tagName.startsWith("@") ? tagName.substring(1) : tagName)
                .toList();

        annotationSpecBuilder = annotationSpecBuilderFromTagNames(tagNames);

        AnnotationSpec annotationSpec = annotationSpecBuilder.build();
        return annotationSpec;
    }

    private static AnnotationSpec.Builder annotationSpecBuilderFromTagNames(List<String> tagNames) {

        AnnotationSpec.Builder annotationSpecBuilder;

        if (tagNames.size() > 1) {
            /**
             * use {@link Tags}
             */
            annotationSpecBuilder = AnnotationSpec.builder(Tags.class);

            for (String tagName : tagNames) {

                AnnotationSpec tagAnnotationSpec = AnnotationSpec.builder(org.junit.jupiter.api.Tag.class)
                        .addMember("value", "\"" + tagName + "\"")
                        .build();
                annotationSpecBuilder.addMember("value", "$L", tagAnnotationSpec);
            }

        } else {
            /**
             * use {@link org.junit.jupiter.api.Tag}
             */
            String tagName = tagNames.get(0);

            annotationSpecBuilder = AnnotationSpec.builder(org.junit.jupiter.api.Tag.class)
                    .addMember("value", "\"" + tagName + "\"");
        }

        return annotationSpecBuilder;
    }

}
