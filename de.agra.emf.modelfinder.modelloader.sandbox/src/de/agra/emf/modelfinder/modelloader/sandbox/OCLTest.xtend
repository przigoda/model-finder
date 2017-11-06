package de.agra.emf.modelfinder.modelloader.sandbox

import de.agra.emf.modelfinder.modelloader.ModelLoader
import junit.framework.TestCase
import org.eclipse.emf.ecore.EOperation
import org.eclipse.ocl.ecore.Variable
import org.eclipse.ocl.expressions.OperationCallExp
import org.junit.Test

class OCLTest extends TestCase {
    @Test
    def void testOCLLoadingFromFile() {
        val loader = new ModelLoader
        val input = loader.loadFromEcoreAndOCL("models/Simple.ecore", "models/Simple.ocl")

        // Working with the constraints
        val constraint = input.constraints.get(0)
        assertEquals(constraint.name, "foo")

        val variable = constraint.specification.contextVariable as Variable
        assertEquals(variable.EType.name, "A")

        val expression = constraint.specification.bodyExpression
        assertTrue(expression instanceof OperationCallExp<?,?>)

        val callExpression = expression as OperationCallExp<?,?>
        val op = callExpression.referredOperation as EOperation
        assertEquals(op.name, "=")
    }

    @Test
    def void testLoadOCLInEcore() {
        val loader = new ModelLoader
        val input = loader.loadFromEcoreWithOCL("../de.agra.emf.modelfinder.encoding.tests/models/people/DifferentAgeAdultsCompact.ecore")
        assertEquals(2, input.constraints.size)
    }

    @Test
    def void testValidation() {
        val loader = new ModelLoader
        val input = loader.loadFromEcoreAndOCL("models/Simple.ecore", "models/Simple.ocl")
        val state = loader.loadState("models/Simple.xmi")
        val stateInconsistent = loader.loadState("models/SimpleInconsistent.xmi")

        assertTrue(loader.validate(state, input.constraints))
        assertFalse(loader.validate(stateInconsistent, input.constraints))
    }
}
