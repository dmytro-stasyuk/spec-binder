package dev.specbinder.feature2junit.mocks;

import org.mockito.Mockito;

import javax.annotation.processing.Filer;
import javax.annotation.processing.ProcessingEnvironment;
import javax.lang.model.element.Element;
import javax.lang.model.element.TypeElement;
import javax.lang.model.type.DeclaredType;
import javax.lang.model.type.TypeKind;
import javax.lang.model.type.TypeMirror;
import javax.lang.model.util.Elements;
import javax.tools.JavaFileObject;
import java.io.IOException;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

final class FilerMocks {

    private FilerMocks() {
        throw new UnsupportedOperationException("This is a utility class and cannot be instantiated");
    }

    public static Filer filer(ProcessingEnvironment processingEnvironment) {

        Filer filer = Mockito.mock(Filer.class);
        Mockito.when(processingEnvironment.getFiler()).thenReturn(filer);

        Elements elements = Mockito.mock(Elements.class);
        Mockito.when(processingEnvironment.getElementUtils()).thenReturn(elements);
        // Return all members including from ancestor classes (mimics real getAllMembers behavior)
        Mockito.when(elements.getAllMembers(Mockito.any(TypeElement.class)))
                .thenAnswer(invocation -> {
                    TypeElement typeElement = invocation.getArgument(0);
                    return getAllMembersFromHierarchy(typeElement);
                });

        return filer;
    }

    /**
     * Recursively collects all members from the given TypeElement and its ancestors.
     * Mimics the behavior of Elements.getAllMembers() for our mocked hierarchy.
     */
    private static List<? extends Element> getAllMembersFromHierarchy(TypeElement typeElement) {
        List<Element> allMembers = new ArrayList<>();

        // Add members from current class
        allMembers.addAll(typeElement.getEnclosedElements());

        // Traverse superclass chain
        TypeMirror superclass = typeElement.getSuperclass();
        if (superclass != null && superclass.getKind() == TypeKind.DECLARED) {
            Element superElement = ((DeclaredType) superclass).asElement();
            if (superElement instanceof TypeElement) {
                allMembers.addAll(getAllMembersFromHierarchy((TypeElement) superElement));
            }
        }

        return allMembers;
    }

    public static StringWriter generatedClassWriter(Filer filer, Map<String, String> generatedClasses) {
        try {
            // Create a writer that captures the first generated class (backward compatibility)
            StringWriter primaryWriter = new StringWriter();

            // Track if this is the first file generated (for backward compatibility)
            final boolean[] isFirstFile = {true};

            // Set up the filer to create a new StringWriter for each class
            Mockito.when(filer.createSourceFile(Mockito.any())).thenAnswer(invocation -> {
                CharSequence className = invocation.getArgument(0, CharSequence.class);

                JavaFileObject generatedJavaFile = Mockito.mock(JavaFileObject.class);

                // For the first file, use primaryWriter (backward compatibility)
                // For subsequent files, create new StringWriters
                final StringWriter writerToUse = isFirstFile[0] ? primaryWriter : new StringWriter();
                isFirstFile[0] = false;

                StringWriter capturingWriter = new StringWriter() {
                    @Override
                    public void write(int c) {
                        writerToUse.write(c);
                    }

                    @Override
                    public void write(char[] cbuf, int off, int len) {
                        writerToUse.write(cbuf, off, len);
                    }

                    @Override
                    public void write(String str) {
                        writerToUse.write(str);
                    }

                    @Override
                    public void write(String str, int off, int len) {
                        writerToUse.write(str, off, len);
                    }

                    @Override
                    public void flush() {
                        writerToUse.flush();
                    }

                    @Override
                    public void close() throws IOException {
                        writerToUse.close();
                        // Capture the generated class content when the writer is closed
                        String content = writerToUse.toString();
                        String simpleClassName = extractSimpleClassName(className.toString());
                        generatedClasses.put(simpleClassName, content);
                    }

                    @Override
                    public String toString() {
                        return writerToUse.toString();
                    }
                };

                Mockito.when(generatedJavaFile.openWriter()).thenReturn(capturingWriter);

                return generatedJavaFile;
            });

            return primaryWriter;
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    private static String extractSimpleClassName(String fullyQualifiedName) {
        int lastDot = fullyQualifiedName.lastIndexOf('.');
        return lastDot > 0 ? fullyQualifiedName.substring(lastDot + 1) : fullyQualifiedName;
    }
}
