package dev.specbinder.feature2junit.steps;

import java.util.ArrayList;
import java.util.List;

/**
 * Test utility for matching file paths against glob patterns.
 * This is used in tests to simulate pattern matching without filesystem access.
 */
public class TestPatternMatcher {

    /**
     * Matches a list of file paths against a glob pattern.
     *
     * @param files       list of file paths to match against
     * @param globPattern the glob pattern to use for matching
     * @return list of files that match the pattern
     */
    public static List<String> matchFilesAgainstPattern(List<String> files, String globPattern) {
        List<String> matchingFiles = new ArrayList<>();
        String regex = convertGlobToRegex(globPattern);

        for (String file : files) {
            if (file.matches(regex)) {
                matchingFiles.add(file);
            }
        }

        return matchingFiles;
    }

    /**
     * Converts a glob pattern to a regex pattern for matching.
     * This is a simple implementation that handles basic glob patterns.
     */
    private static String convertGlobToRegex(String glob) {
        StringBuilder regex = new StringBuilder();

        for (int i = 0; i < glob.length(); i++) {
            char c = glob.charAt(i);

            switch (c) {
                case '\\':
                    regex.append("\\\\");
                    break;
                case '/':
                    regex.append('/');
                    break;
                case '$':
                case '^':
                case '.':
                case '+':
                case '(':
                case ')':
                case '|':
                    regex.append('\\').append(c);
                    break;
                case '*':
                    if (i + 1 < glob.length() && glob.charAt(i + 1) == '*') {
                        // ** matches any number of directories
                        regex.append(".*");
                        i++; // Skip next *
                    } else {
                        // * matches anything except /
                        regex.append("[^/]*");
                    }
                    break;
                case '?':
                    regex.append("[^/]");
                    break;
                case '[':
                    regex.append('[');
                    break;
                case ']':
                    regex.append(']');
                    break;
                default:
                    regex.append(c);
            }
        }

        return regex.toString();
    }
}
