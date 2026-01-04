package dev.specbinder.feature2junit.gherkin.utils;

import com.squareup.javapoet.FieldSpec;
import com.squareup.javapoet.MethodSpec;
import com.squareup.javapoet.TypeSpec;
import dev.specbinder.feature2junit.utils.ParameterNamingUtils;

import javax.lang.model.element.Modifier;
import java.util.List;

/**
 * Generates JavaPoet TypeSpec for record-like class types based on RecordMetadata.
 * Since JavaPoet 1.13.0 doesn't support Java records directly, we generate
 * an immutable class that behaves like a record (public static class with
 * private final fields and public accessor methods).
 */
public class RecordGenerator {

    /**
     * Private constructor to prevent instantiation.
     */
    private RecordGenerator() {
        /**
         * utility class
         */
    }

    /**
     * Generates a record-style class TypeSpec from RecordMetadata.
     * The generated class will be public static, with private final fields
     * and public accessor methods for each column.
     * Field names are sanitized to valid Java identifiers using ParameterNamingUtils.
     *
     * @param metadata the record metadata containing name and column information
     * @return a TypeSpec representing the record-like class type
     */
    public static TypeSpec generateRecord(RecordMetadata metadata) {
        String recordName = metadata.getRecordName();
        List<String> columnNames = metadata.getColumnNames();

        // Create a public static class (record-like pattern)
        TypeSpec.Builder classBuilder = TypeSpec.classBuilder(recordName)
                .addModifiers(Modifier.PUBLIC, Modifier.STATIC);

        // Build constructor parameters and add fields
        MethodSpec.Builder constructorBuilder = MethodSpec.constructorBuilder()
                .addModifiers(Modifier.PUBLIC);

        for (String columnName : columnNames) {
            // Convert column name to valid Java field name (camelCase)
            String fieldName = ParameterNamingUtils.toMethodParameterName(columnName);

            // Add private final field
            FieldSpec field = FieldSpec.builder(String.class, fieldName)
                    .addModifiers(Modifier.PRIVATE, Modifier.FINAL)
                    .build();
            classBuilder.addField(field);

            // Add parameter to constructor
            constructorBuilder.addParameter(String.class, fieldName);
            constructorBuilder.addStatement("this.$N = $N", fieldName, fieldName);

            // Add public accessor method (same name as field, record-style)
            MethodSpec accessor = MethodSpec.methodBuilder(fieldName)
                    .addModifiers(Modifier.PUBLIC)
                    .returns(String.class)
                    .addStatement("return this.$N", fieldName)
                    .build();
            classBuilder.addMethod(accessor);
        }

        classBuilder.addMethod(constructorBuilder.build());

        return classBuilder.build();
    }
}
