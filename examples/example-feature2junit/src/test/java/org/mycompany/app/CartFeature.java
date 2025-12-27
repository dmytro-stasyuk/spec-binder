package org.mycompany.app;

import dev.specbinder.feature2junit.Feature2JUnit;
import dev.specbinder.feature2junit.Feature2JUnitOptions;
import io.cucumber.datatable.DataTable;
import io.cucumber.datatable.DataTableType;
import io.cucumber.datatable.DataTableTypeRegistry;
import io.cucumber.datatable.DataTableTypeRegistryTableConverter;

import java.util.Locale;
import java.util.Map;

@Feature2JUnitOptions(
//    shouldBeAbstract = false
        addCucumberStepAnnotations = false
//        placeGeneratedClassNextToAnnotatedClass = true
)
@Feature2JUnit
abstract class CartFeature {

    public CartFeature() {

        DataTableTypeRegistry dataTableRegistry = new DataTableTypeRegistry(Locale.ENGLISH);

        dataTableRegistry.defineDataTableType(new DataTableType(
                CartItem.class,
                (Map<String, String> row) ->
                        new CartItem(
                                row.get("name"),
                                Integer.parseInt(row.get("qty")),
                                Double.parseDouble(row.get("price"))
                        ))
        );
        DataTable.TableConverter tableConverter = new DataTableTypeRegistryTableConverter(dataTableRegistry);

    }

}