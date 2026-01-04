package dev.specbinder.feature2junit.mocks;

import dev.specbinder.feature2junit.Feature2JUnitGenerator;
import org.mockito.Mockito;

import javax.annotation.processing.ProcessingEnvironment;

final class GeneratorMocks {

    private GeneratorMocks() {
        throw new UnsupportedOperationException("This is a utility class and cannot be instantiated");
    }

    public static Feature2JUnitGenerator generator(ProcessingEnvironment processingEnvironment) {

        Feature2JUnitGenerator generator = Mockito.mock(Feature2JUnitGenerator.class);
        Mockito.when(generator.process(Mockito.any(), Mockito.any())).thenCallRealMethod();

        Mockito.when(generator.getProcessingEnv()).thenReturn(processingEnvironment);

        return generator;
    }
}
