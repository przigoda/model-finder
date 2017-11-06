package de.agra.emf.metamodels.SMTlib2extended.tests

import de.agra.emf.metamodels.SMTlib2extended.Expression
import de.agra.emf.metamodels.SMTlib2extended.Instance
import de.agra.emf.metamodels.SMTlib2extended.SMTlib2extendedFactory
import de.agra.emf.metamodels.SMTlib2extended.Variable
import de.agra.emf.metamodels.SMTlib2extended.solver.Z3Solver
import junit.framework.TestCase

class ServerTest extends TestCase {
    val factory = SMTlib2extendedFactory::eINSTANCE

    def void testSimple() {
        val x = newBitvector("x", 3)
        val y = newBitvector("y", 3)
        val z = newBitvector("z", 6)

        val expr = equals(concat(variableExpression(x), variableExpression(y)), variableExpression(z))

        val instance = factory.createInstance
        instance.variables += x
        instance.variables += y
        instance.variables += z
        instance.assertions += expr

        solve(instance, true)
    }

    def private solve(Instance instance, boolean expectedValue) {
        val solver = new Z3Solver
        val result = solver.solve()
        assertEquals(expectedValue, result)

        if (result) {
            val solution = solver.getSolution(instance.variables)
            for (v : instance.variables) {
                println(v.name + ": " + (solution.get(v)))
            }
        }
    }

    def private newBitvector(String name, int width) {
        val x = factory.createBitvector
        x.name = name
        x.width = width
        x
    }

    def private variableExpression(Variable v) {
        val expr = factory.createVariableExpression
        expr.variable = v
        expr
    }

    def private concat(Expression a, Expression b) {
        val expr = factory.createConcatExpression
        expr.expressions += a
        expr.expressions += b
        expr
    }

    def private equals(Expression a, Expression b) {
        val expr = factory.createEqualsExpression
        expr.lhs = a
        expr.rhs = b
        expr
    }
}
