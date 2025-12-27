package dev.spec2test.story2junit.generator;

import dev.spec2test.common.LoggingSupport;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.jbehave.core.model.Story;
import org.jbehave.core.parsers.RegexStoryParser;

import javax.annotation.processing.ProcessingEnvironment;
import javax.tools.FileObject;
import javax.tools.StandardLocation;
import java.io.IOException;

@RequiredArgsConstructor
class CustomRegexStoryParser extends RegexStoryParser implements LoggingSupport {

    @Getter
    private final ProcessingEnvironment processingEnv;

    public CustomRegexStoryParser(ProcessingEnvironment processingEnv, ProcessingEnvironment env) {

        this.processingEnv = processingEnv;
    }

    public Story parseUsingStoryPath(String storyPath) throws IOException {

        String fileContent = loadFileContent(storyPath);

        Story story = super.parseStory(fileContent);
        return story;
    }

    private String loadFileContent(String filePath) throws IOException {

        // works from IDE & maven lifecycle build goal
        FileObject specFile = processingEnv.getFiler().getResource(StandardLocation.CLASS_PATH, "", filePath);
        CharSequence charContent = specFile.getCharContent(false);

        String fileContent = charContent.toString();
        return fileContent;
    }

}