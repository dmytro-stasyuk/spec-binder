package dev.specbinder.feature2junit.gherkin.utils;

import java.util.ArrayList;
import java.util.List;

/**
 * Metadata about a generated record type for LIST_OF_OBJECT_PARAMS data table handling.
 * This class stores information about the record name and its fields (columns),
 * and supports merging columns from multiple data table usages.
 */
public class RecordMetadata {

    private final String recordName;
    private final List<String> columnNames;
    private final List<String> columnTypes;

    /**
     * Creates a new RecordMetadata with the specified record name.
     *
     * @param recordName the name of the record type (e.g., "Users")
     */
    public RecordMetadata(String recordName) {
        this.recordName = recordName;
        this.columnNames = new ArrayList<>();
        this.columnTypes = new ArrayList<>();
    }

    /**
     * Merges columns from a data table into this record.
     * Maintains insertion order and deduplicates column names.
     * All columns are currently treated as String type.
     *
     * @param newColumns the list of column names to merge
     */
    public void mergeColumns(List<String> newColumns) {
        for (String column : newColumns) {
            if (!columnNames.contains(column)) {
                columnNames.add(column);
                columnTypes.add("String");
            }
        }
    }

    /**
     * Gets the record name.
     *
     * @return the record name (e.g., "Users")
     */
    public String getRecordName() {
        return recordName;
    }

    /**
     * Gets the ordered list of column names for this record.
     *
     * @return the list of column names
     */
    public List<String> getColumnNames() {
        return columnNames;
    }

    /**
     * Gets the ordered list of column types for this record.
     * Currently all types are "String".
     *
     * @return the list of column types
     */
    public List<String> getColumnTypes() {
        return columnTypes;
    }
}
