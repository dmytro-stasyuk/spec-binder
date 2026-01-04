#!/bin/bash
# Cucumber Hooks Setup - Creates hook classes for Before/After test execution

set -e

HOOKS_DIR="feature-processor/src/test/java/dev/specbinder/feature2junit/tests/hooks"
PACKAGE="dev.specbinder.feature2junit.tests.hooks"

# Create hooks directory
mkdir -p "$HOOKS_DIR"

echo "Creating Cucumber Hooks..."

# Create TestHooks.java
cat > "$HOOKS_DIR/TestHooks.java" << 'EOF'
package dev.specbinder.feature2junit.tests.hooks;

import io.cucumber.java.After;
import io.cucumber.java.Before;
import io.cucumber.java.Scenario;

/**
 * Cucumber hooks for test setup and teardown.
 * These hooks run before and after each scenario.
 */
public class TestHooks {

    @Before
    public void beforeScenario(Scenario scenario) {
        System.out.println("========================================");
        System.out.println("Starting scenario: " + scenario.getName());
        System.out.println("========================================");
    }

    @After
    public void afterScenario(Scenario scenario) {
        System.out.println("========================================");
        System.out.println("Finished scenario: " + scenario.getName());
        System.out.println("Status: " + scenario.getStatus());
        System.out.println("========================================");
    }

    @Before("@database")
    public void beforeDatabaseScenario() {
        System.out.println("Setting up database for scenario...");
        // Add database setup logic here
    }

    @After("@database")
    public void afterDatabaseScenario() {
        System.out.println("Cleaning up database after scenario...");
        // Add database cleanup logic here
    }
}
EOF

# Create LoggingHooks.java
cat > "$HOOKS_DIR/LoggingHooks.java" << 'EOF'
package dev.specbinder.feature2junit.tests.hooks;

import io.cucumber.java.After;
import io.cucumber.java.Before;
import io.cucumber.java.Scenario;

import java.time.Duration;
import java.time.Instant;

/**
 * Hooks for logging test execution metrics.
 */
public class LoggingHooks {

    private Instant startTime;

    @Before(order = 0)
    public void logStartTime(Scenario scenario) {
        startTime = Instant.now();
    }

    @After(order = Integer.MAX_VALUE)
    public void logEndTime(Scenario scenario) {
        Instant endTime = Instant.now();
        Duration duration = Duration.between(startTime, endTime);

        System.out.printf("Scenario '%s' took %d ms%n",
            scenario.getName(),
            duration.toMillis());
    }
}
EOF

# Create ScreenshotHooks.java (example)
cat > "$HOOKS_DIR/ScreenshotHooks.java" << 'EOF'
package dev.specbinder.feature2junit.tests.hooks;

import io.cucumber.java.After;
import io.cucumber.java.Scenario;

/**
 * Hooks for capturing screenshots on test failure.
 * (This is a template - customize based on your needs)
 */
public class ScreenshotHooks {

    @After
    public void captureScreenshotOnFailure(Scenario scenario) {
        if (scenario.isFailed()) {
            System.out.println("Scenario failed: " + scenario.getName());
            // Add screenshot capture logic here if needed
            // Example: scenario.attach(screenshot, "image/png", "screenshot");
        }
    }
}
EOF

echo "✅ Created Cucumber hooks in: $HOOKS_DIR"
echo ""
echo "Created files:"
echo "  - TestHooks.java (Before/After hooks)"
echo "  - LoggingHooks.java (Execution time logging)"
echo "  - ScreenshotHooks.java (Failure handling)"
echo ""
echo "These hooks will automatically run with your Cucumber tests."
