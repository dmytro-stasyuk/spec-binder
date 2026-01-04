package dev.specbinder.feature2junit.gherkin.utils;

import dev.specbinder.feature2junit.exception.ProcessingException;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Collects metadata about data tables in a feature for LIST_OF_OBJECT_PARAMS generation.
 * This class is used during the first pass of processing to identify all record types
 * that need to be generated and merge their column definitions.
 */
public class DataTableCollector {

    private final Map<String, RecordMetadata> recordMetadataMap = new LinkedHashMap<>();

    /**
     * Constructs a new DataTableCollector.
     */
    public DataTableCollector() {
        /**
         * default constructor
         */
    }

    /**
     * Registers a data table usage with its step text and column headers.
     * If a record with the same name already exists, the columns are merged.
     *
     * @param stepText      the full step text including keyword (e.g., "Given the following users")
     * @param columnHeaders the list of column headers from the data table
     */
    public void registerDataTable(String stepText, List<String> columnHeaders) {
        String recordName = deriveRecordNameFromStepText(stepText);

        RecordMetadata metadata = recordMetadataMap.computeIfAbsent(
                recordName,
                k -> new RecordMetadata(recordName)
        );

        metadata.mergeColumns(columnHeaders);
    }

    /**
     * Derives a record name from step text by extracting the last word.
     * The last word is cleaned of punctuation, capitalized, and "Param" suffix is added.
     *
     * @param stepText the step text (e.g., "Given the following users:")
     * @return the derived record name (e.g., "UsersParam")
     * @throws ProcessingException if a valid record name cannot be derived
     */
    public String deriveRecordNameFromStepText(String stepText) {
        String lastWord = extractLastWord(stepText);

        // Capitalize first letter for record name (PascalCase) and add "Param" suffix
        return Character.toUpperCase(lastWord.charAt(0)) + lastWord.substring(1) + "Param";
    }

    /**
     * Derives a parameter name from step text by extracting the last word.
     * The last word is cleaned of punctuation and converted to camelCase (lowercase first letter).
     *
     * @param stepText the step text (e.g., "Given the following users:")
     * @return the derived parameter name (e.g., "users")
     * @throws ProcessingException if a valid parameter name cannot be derived
     */
    public String deriveParameterNameFromStepText(String stepText) {
        String lastWord = extractLastWord(stepText);

        // Lowercase first letter for parameter name (camelCase)
        return Character.toLowerCase(lastWord.charAt(0)) + lastWord.substring(1);
    }

    /**
     * Extracts and validates the last word from step text.
     * The last word is cleaned of punctuation.
     *
     * @param stepText the step text (e.g., "Given the following users:")
     * @return the cleaned last word (e.g., "users")
     * @throws ProcessingException if a valid word cannot be extracted
     */
    private String extractLastWord(String stepText) {
        String[] words = stepText.trim().split("\\s+");

        if (words.length < 2) {
            throw new ProcessingException(
                    "Cannot derive record name from step: " + stepText +
                            ". Step must have at least two words.");
        }

        // Get last word and remove punctuation
        String lastWord = words[words.length - 1];
        lastWord = lastWord.replaceAll("[^a-zA-Z0-9]", "");

        if (lastWord.isEmpty()) {
            throw new ProcessingException(
                    "Cannot derive valid record name from step: " + stepText +
                            ". Last word contains no alphanumeric characters.");
        }

        if (!Character.isJavaIdentifierStart(lastWord.charAt(0))) {
            throw new ProcessingException(
                    "Cannot derive valid Java record name from step: " + stepText +
                            ". Last word '" + lastWord + "' is not a valid Java identifier.");
        }

        return lastWord;
    }

    /**
     * Gets the map of record metadata collected so far.
     *
     * @return the map of record name to RecordMetadata
     */
    public Map<String, RecordMetadata> getRecordMetadataMap() {
        return recordMetadataMap;
    }

    /**
     * Checks if any data tables have been registered.
     *
     * @return true if at least one data table has been registered, false otherwise
     */
    public boolean hasDataTables() {
        return !recordMetadataMap.isEmpty();
    }
}
