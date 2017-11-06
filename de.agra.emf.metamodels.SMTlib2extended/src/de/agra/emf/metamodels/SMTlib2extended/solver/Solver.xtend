package de.agra.emf.metamodels.SMTlib2extended.solver;

import de.agra.emf.metamodels.SMTlib2extended.Expression
import de.agra.emf.metamodels.SMTlib2extended.Variable
import java.util.Map
import org.eclipse.emf.common.util.EList

/* TODO: Add an implementation for the Java-SMT, for MathSAT and CVC I've not seen any JavaAPIs so far
 * see: https://github.com/sosy-lab/java-smt
 *      https://sosy-lab.github.io/java-smt/api/index.html
 */
interface Solver<T>
{
    def void init()
    def void finish()

    def void addAssertion(Expression assertion)
    def void addAssertions(EList<Expression> assertions)

    def boolean solve()
    def Map<Variable, Object> getSolution(EList<Variable> variables)
    def int solveCalls()

    def void push()
    def void pop()

    def void setConverter(T c)

    def void setTimeout(int t)
    def int getTimeout()

    def void setShowAddedExpressions(boolean t)
    def boolean getShowAddedExpressions()
}