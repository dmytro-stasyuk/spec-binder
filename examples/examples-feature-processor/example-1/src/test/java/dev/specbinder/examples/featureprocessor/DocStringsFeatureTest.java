package dev.specbinder.examples.featureprocessor;

import specs.DocStringsFeatureScenarios;

/**
 * Implements the test steps for the {@link DocStringsFeatureScenarios} feature.
 */
public class DocStringsFeatureTest extends DocStringsFeatureScenarios {

    @Override
    public void givenIAmAContentEditor() {
        // TODO: Implement step
    }

    @Override
    public void whenICreateAPostWithContent(String docString) {
        // TODO: Implement step with doc string parameter
        // The docString parameter contains multi-line text
    }

    @Override
    public void thenThePostShouldBeSavedSuccessfully() {
        // TODO: Implement step
    }

    @Override
    public void whenISendAnEmailWithBody(String docString) {
        // TODO: Implement step with doc string parameter
    }

    @Override
    public void thenTheEmailShouldBeSent() {
        // TODO: Implement step
    }
}
