package dev.specbinder.examples.featureprocessor;

import io.cucumber.datatable.DataTable;
import io.cucumber.datatable.DataTableType;
import io.cucumber.datatable.DataTableTypeRegistry;
import io.cucumber.datatable.DataTableTypeRegistryTableConverter;
import specs.DataTablesFeatureScenarios;

import java.util.List;
import java.util.Locale;
import java.util.Map;

/**
 * Implements the test steps for the {@link DataTablesFeatureScenarios} feature.
 */
public class DataTablesFeatureTest extends DataTablesFeatureScenarios {

    protected DataTableTypeRegistry dataTableRegistry;
    protected DataTable.TableConverter tableConverter;

    public DataTablesFeatureTest() {
        dataTableRegistry = new DataTableTypeRegistry(Locale.ENGLISH);

        // Register User POJO mapping
        dataTableRegistry.defineDataTableType(new DataTableType(
                User.class,
                (Map<String, String> row) -> new User(
                        row.get("username"),
                        row.get("email"),
                        row.get("role")
                )
        ));

        // Register Product POJO mapping
        dataTableRegistry.defineDataTableType(new DataTableType(
                Product.class,
                (Map<String, String> row) -> new Product(
                        row.get("product"),
                        Integer.parseInt(row.get("quantity"))
                )
        ));

        tableConverter = new DataTableTypeRegistryTableConverter(dataTableRegistry);
    }

    @Override
    public void givenICreateTheFollowingUsers(DataTable dataTable) {
        // TODO: Implement step with DataTable parameter
        // Example usage with POJO conversion:
         List<User> users = dataTable.asList(User.class);
         for (User user : users) {
             // Create user with user.username, user.email, user.role
         }
    }

    @Override
    public void thenTheSystemShouldHave$p1Users(String p1) {
        // TODO: Implement step with parameter: p1
    }

    @Override
    public void whenICheckTheInventory(DataTable dataTable) {
        // TODO: Implement step with DataTable parameter
        // Example usage with POJO conversion:
         List<Product> products = dataTable.asList(Product.class);
         for (Product product : products) {
             // Check inventory for product.name with product.quantity
         }
    }

    @Override
    public void thenAllProductsShouldBeInStock() {
        // TODO: Implement step
    }

    @Override
    protected DataTable.TableConverter getTableConverter() {
        return tableConverter;
    }

    /**
     * Simple POJO representing a user row from the data table.
     */
    public static class User {
        public final String username;
        public final String email;
        public final String role;

        public User(String username, String email, String role) {
            this.username = username;
            this.email = email;
            this.role = role;
        }
    }

    /**
     * Simple POJO representing a product row from the data table.
     */
    public static class Product {
        public final String name;
        public final int quantity;

        public Product(String name, int quantity) {
            this.name = name;
            this.quantity = quantity;
        }
    }
}
