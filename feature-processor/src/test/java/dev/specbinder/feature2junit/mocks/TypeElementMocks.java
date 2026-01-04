package dev.specbinder.feature2junit.mocks;

import com.squareup.javapoet.ClassName;
import dev.specbinder.annotations.Feature2JUnit;
import dev.specbinder.annotations.Feature2JUnitOptions;
import org.mockito.Mockito;

import javax.lang.model.element.ElementKind;
import javax.lang.model.element.Name;
import javax.lang.model.element.TypeElement;
import javax.lang.model.type.DeclaredType;
import javax.lang.model.type.NoType;
import javax.lang.model.type.TypeKind;
import java.util.Collections;

final class TypeElementMocks {

    private TypeElementMocks() {
        throw new UnsupportedOperationException("This is a utility class and cannot be instantiated");
    }

    public static TypeElement annotatedBaseClass(Feature2JUnit feature2junitAnnotation, Feature2JUnitOptions options) {

        TypeElement annotatedClass = Mockito.mock(TypeElement.class);

        // TypeElement must report its kind as CLASS for JavaPoet
        Mockito.when(annotatedClass.getKind()).thenReturn(ElementKind.CLASS);

        Name simpleName = Mockito.mock(Name.class);
        String simpleClassName = "MockedAnnotatedTestClass";
        Mockito.when(simpleName.toString()).thenReturn(simpleClassName);
        Mockito.when(annotatedClass.getSimpleName()).thenReturn(simpleName);
        // Default qualified name is same as simple name (no package)
        // This will be overridden by Steps.java if a package is specified
        Mockito.when(annotatedClass.getQualifiedName()).thenReturn(simpleName);

        DeclaredType annotatedClassMirror = Mockito.mock(DeclaredType.class);
        Mockito.when(annotatedClass.asType()).thenReturn(annotatedClassMirror);
        Mockito.when(annotatedClassMirror.getKind()).thenReturn(TypeKind.DECLARED);
        // CRITICAL: JavaPoet calls asElement() to extract the class name for the extends clause
        Mockito.when(annotatedClassMirror.asElement()).thenReturn(annotatedClass);
        // JavaPoet also checks for type arguments (generics) - return empty list for non-generic class
        Mockito.when(annotatedClassMirror.getTypeArguments()).thenReturn(Collections.emptyList());
        // Enclosing type should be NONE for top-level classes
        NoType noType = Mockito.mock(NoType.class);
        Mockito.when(noType.getKind()).thenReturn(TypeKind.NONE);
        Mockito.when(annotatedClassMirror.getEnclosingType()).thenReturn(noType);

        // Default: no package (enclosing element is null)
        // This will be overridden by Steps.java if a package is specified in the Given step
        Mockito.when(annotatedClass.getEnclosingElement()).thenReturn(null);

        // Type parameters (empty for non-generic class)
        Mockito.when(annotatedClass.getTypeParameters()).thenReturn(Collections.emptyList());

        // Set up getSuperclass to return NoType (no superclass in hierarchy)
        NoType noSuperclass = Mockito.mock(NoType.class);
        Mockito.when(noSuperclass.getKind()).thenReturn(TypeKind.NONE);
        Mockito.when(annotatedClass.getSuperclass()).thenReturn(noSuperclass);

        // Create a real ClassName for JavaPoet to use (will be updated dynamically via qualified name)
        Mockito.when(annotatedClassMirror.accept(Mockito.any(), Mockito.any())).thenAnswer(invocation -> {
            // Get the current qualified name (which may have been updated by Steps.java)
            String currentQualifiedName = annotatedClass.getQualifiedName().toString();
            int lastDot = currentQualifiedName.lastIndexOf('.');
            String pkgName = lastDot > 0 ? currentQualifiedName.substring(0, lastDot) : "";
            String className = lastDot > 0 ? currentQualifiedName.substring(lastDot + 1) : currentQualifiedName;
            return ClassName.get(pkgName, className);
        });

        Mockito.when(annotatedClass.getAnnotation(Feature2JUnit.class)).thenReturn(feature2junitAnnotation);
        Mockito.when(annotatedClass.getAnnotation(Feature2JUnitOptions.class)).thenReturn(options);
        return annotatedClass;
    }
}
