package dev.specbinder.examples.featureprocessor;

import dev.specbinder.annotations.Feature2JUnit;
import io.cucumber.datatable.DataTable;

import java.util.ArrayList;
import java.util.List;

/**
 * Demonstrates how Gherkin data tables are converted to DataTable parameters in step methods.
 * Data tables allow passing structured tabular data to steps for complex test scenarios.
 * Inherits generation options from {@link BaseFeatureTest}.
 * <p>
 * Unlike {@link DataTablesFeature} where the createDataTable & getTableConverter conversion helper methods
 * are generated into each scenario class, this example defines these helper methods directly in the
 * base class. This approach promotes code reuse and allows customization of the conversion logic
 * across all scenarios and features that extend this base class.
 */
@Feature2JUnit("specs/DataTables.feature")
public abstract class DataTablesWithHelperInBaseClassFeature extends BaseFeatureTest {

    protected abstract DataTable.TableConverter getTableConverter();

    protected DataTable createDataTable(String tableLines) {

        String[] tableRows = tableLines.split("\\n");
        List<List<String>> rawDataTable = new ArrayList<>(tableRows.length);

        for (String tableRow : tableRows) {
            String trimmedLine = tableRow.trim();
            if (!trimmedLine.isEmpty()) {
                String[] columns = trimmedLine.split("\\|");
                List<String> rowColumns = new ArrayList<>(columns.length);
                for (int i = 1; i < columns.length; i++) {
                    String column = columns[i].trim();
                    rowColumns.add(column);
                }
                rawDataTable.add(rowColumns);
            }
        }

        DataTable dataTable = DataTable.create(rawDataTable, getTableConverter());
        return dataTable;
    }
}
