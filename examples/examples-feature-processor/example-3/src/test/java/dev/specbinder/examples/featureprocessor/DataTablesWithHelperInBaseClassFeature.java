package dev.specbinder.examples.featureprocessor;

import dev.specbinder.annotations.Feature2JUnit;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Demonstrates how Gherkin data tables are converted to List&lt;CustomType&gt; parameters
 * when using LIST_OF_OBJECT_PARAMS mode. The generator creates inner POJO classes
 * in the generated test class, with fields matching the table columns. Each data table
 * becomes a List of these custom object types, providing type-safe access to table columns.
 * <p>
 * Unlike {@link DataTablesFeature} where the table-to-map conversion helper is generated into each
 * scenario class, this example defines the {@code createListOfMaps} helper method directly in the
 * base class. This approach promotes code reuse and allows customization of the conversion logic
 * across all scenarios and features that extend this base class.
 * <p>
 * Inherits generation options from {@link BaseFeatureTest}.
 */
@Feature2JUnit("specs/DataTables.feature")
public abstract class DataTablesWithHelperInBaseClassFeature extends BaseFeatureTest {

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
