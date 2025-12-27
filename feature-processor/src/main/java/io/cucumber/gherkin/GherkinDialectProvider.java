package io.cucumber.gherkin;

import java.util.LinkedHashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

import static java.util.Objects.requireNonNull;

/**
 * Provides access to Gherkin dialects.
 * <p>
 * The default dialect is "en" (English).
 */
public class GherkinDialectProvider {

    /**
     * Additional feature keywords to be added to the default dialect.
     */
    public static Set<String> additionalFeatureKeywords;

    private final String defaultDialectName;
    private GherkinDialect defaultDialect;

    /**
     * Creates a GherkinDialectProvider with the specified default dialect name.
     * @param defaultDialectName the name of the default dialect, e.g. "en" for English
     */
    public GherkinDialectProvider(String defaultDialectName) {
        this.defaultDialectName = requireNonNull(defaultDialectName);
    }

    /**
     * Creates a GherkinDialectProvider with the default dialect set to "en" (English).
     */
    public GherkinDialectProvider() {
        this("en");
    }

    /**
     * Returns the default Gherkin dialect.
     * @return the default Gherkin dialect
     */
    public GherkinDialect getDefaultDialect() {
        if (defaultDialect == null) {
            this.defaultDialect = getDialect(defaultDialectName)
                    .orElseThrow(() -> new ParserException.NoSuchLanguageException(defaultDialectName, null));
            this.defaultDialect = extendGherkinDialect(defaultDialect);
        }
        return defaultDialect;
    }

    /**
     * Returns the Gherkin dialect for the specified language.
     * @param language the language code, e.g. "en" for English
     * @return an Optional containing the Gherkin dialect for the specified language, or an empty Optional if no such dialect exists
     */
    public Optional<GherkinDialect> getDialect(String language) {
        requireNonNull(language);
        Optional<GherkinDialect> dialectResult = Optional.ofNullable(GherkinDialects.DIALECTS.get(language));
        if (dialectResult.isPresent()) {
            GherkinDialect gherkinDialect = dialectResult.get();
            gherkinDialect = extendGherkinDialect(gherkinDialect);
            dialectResult = Optional.of(gherkinDialect);
        }
        return dialectResult;
    }

    private static GherkinDialect extendGherkinDialect(GherkinDialect gherkinDialect) {

        List<String> featureKeywords = gherkinDialect.getFeatureKeywords();
        if (additionalFeatureKeywords != null) {
            Set<String> extendedFeatureKeywords = new LinkedHashSet<>(additionalFeatureKeywords);
            extendedFeatureKeywords.addAll(featureKeywords);
            featureKeywords = extendedFeatureKeywords.stream().toList();
        }

        GherkinDialect extendedDialect = new GherkinDialect(
                gherkinDialect.getLanguage(),
                gherkinDialect.getName(),
                gherkinDialect.getNativeName(),
                featureKeywords,
                gherkinDialect.getRuleKeywords(),
                gherkinDialect.getScenarioKeywords(),
                gherkinDialect.getScenarioOutlineKeywords(),
                gherkinDialect.getBackgroundKeywords(),
                gherkinDialect.getExamplesKeywords(),
                gherkinDialect.getGivenKeywords(),
                gherkinDialect.getWhenKeywords(),
                gherkinDialect.getThenKeywords(),
                gherkinDialect.getAndKeywords(),
                gherkinDialect.getButKeywords()
        );

        return extendedDialect;
    }

    /**
     * Returns a set of all available Gherkin dialects.
     * @return a set of language codes for all available Gherkin dialects
     */
    public Set<String> getLanguages() {
        return GherkinDialects.DIALECTS.keySet();
    }
}
