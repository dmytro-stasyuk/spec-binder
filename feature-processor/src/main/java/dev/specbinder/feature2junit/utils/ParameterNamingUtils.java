package dev.specbinder.feature2junit.utils;

/**
 * Utility class for generating method parameter names from Gherkin scenario parameters.
 */
public class ParameterNamingUtils {

    private ParameterNamingUtils() {
        /**
         * utility class
         */
    }

    /**
     * Generates a method parameter name from a Gherkin scenario parameter.
     * @param scenarioParameter the scenario parameter to convert
     * @return a sanitized method parameter name suitable for use in Java code
     */
    public static String toMethodParameterName(String scenarioParameter) {

        StringBuilder parameterNameBuilder = new StringBuilder();

        String[] words = scenarioParameter.split("\\s+");

        // Only preserve casing if input is already "proper camelCase":
        // - Single word (no spaces)
        // - Starts with lowercase letter
        // - Contains at least one uppercase letter
        // - No underscores or special characters
        boolean isProperCamelCase = words.length == 1
            && scenarioParameter.length() > 0
            && Character.isLowerCase(scenarioParameter.charAt(0))
            && scenarioParameter.chars().anyMatch(Character::isUpperCase)
            && scenarioParameter.chars().allMatch(Character::isLetterOrDigit);

        for (int i = 0; i < words.length; i++) {

            String word = words[i];

            // Remove invalid characters
            StringBuilder sanitizedWordBuilder = new StringBuilder();
            for (char c : word.toCharArray()) {

                if (sanitizedWordBuilder.length() == 0) {
                    // nothing added yet - so check if char is suitable as a starting char
                    if (Character.isJavaIdentifierStart(c)) {
                        char wordFirstChar;
                        if (parameterNameBuilder.length() == 0) {
                            // first word in method name - so use lower case
                            wordFirstChar = Character.toLowerCase(c);
                        } else {
                            // not the first word - so use upper case
                            wordFirstChar = Character.toUpperCase(c);
                        }
                        sanitizedWordBuilder.append(wordFirstChar);
                    } else if (Character.isJavaIdentifierPart(c) && parameterNameBuilder.length() > 0) {
                        // It's a digit or other valid identifier part, and we already have something in the parameter name
                        // Add it in lowercase (for digits, this has no effect)
                        sanitizedWordBuilder.append(Character.toLowerCase(c));
                    } else {
                        // skip - can't use this character
                    }

                } else {

                    if (Character.isJavaIdentifierPart(c)) {
                        // For proper camelCase parameters, preserve the original casing
                        // For all other cases, convert to lowercase for camelCase convention
                        char charToAppend = isProperCamelCase ? c : Character.toLowerCase(c);
                        sanitizedWordBuilder.append(charToAppend);
                    } else {
                        // skip
                    }
                }

            }

            String sanitizedWord = sanitizedWordBuilder.toString();
            parameterNameBuilder.append(sanitizedWord);

        }

        String sanitizedMethodName = parameterNameBuilder.toString();
        return sanitizedMethodName;
    }
}
