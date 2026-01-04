package dev.specbinder.examples.featureprocessor;

import dev.specbinder.annotations.Feature2JUnit;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Demonstrates how Gherkin data tables are converted to DataTable parameters in step methods.
 * Data tables allow passing structured tabular data to steps for complex test scenarios.
 *
 * The only difference between this class and DataTablesFeature is that this class contains
 * the helper method to convert Gherkin data tables into List<Map<String, String>> format,
 * while in DataTablesFeature the helper method is generated into each scenario class.
 * This approach enables customization and reuse of the helper method across multiple features or scenarios.
 */
@Feature2JUnit("specs/DataTables.feature")
public abstract class DataTablesWithHelperInBaseClassFeature {

    /**
     * Helper method to convert a Gherkin data table string into a list of maps.
     * Each map represents a row, with column headers as keys.
     * @param tableLines
     * @return
     */
    protected List<Map<String, String>> createListOfMaps(String tableLines) {

        String[] tableRows = tableLines.split("\\n");
        List<Map<String, String>> listOfMaps = new ArrayList<>();

        if (tableRows.length < 2) {
            return listOfMaps;
        }

        String[] headers = null;
        for (int i = 0; i < tableRows.length; i++) {
            String trimmedLine = tableRows[i].trim();
            if (!trimmedLine.isEmpty()) {
                String[] columns = trimmedLine.split("\\|");
                List<String> rowColumns = new ArrayList<>(columns.length);
                for (int j = 1; j < columns.length; j++) {
                    String column = columns[j].trim();
                    rowColumns.add(column);
                }

                if (headers == null) {
                    headers = rowColumns.toArray(new String[0]);
                } else {
                    Map<String, String> rowMap = new HashMap<>();
                    for (int j = 0; j < Math.min(headers.length, rowColumns.size()); j++) {
                        rowMap.put(headers[j], rowColumns.get(j));
                    }
                    listOfMaps.add(rowMap);
                }
            }
        }

        return listOfMaps;
    }
}
