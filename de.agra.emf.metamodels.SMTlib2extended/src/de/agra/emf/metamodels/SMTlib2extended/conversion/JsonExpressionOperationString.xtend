package de.agra.emf.metamodels.SMTlib2extended.conversion

import de.agra.emf.metamodels.SMTlib2extended.AddExpression
import de.agra.emf.metamodels.SMTlib2extended.AndExpression
import de.agra.emf.metamodels.SMTlib2extended.EqualsExpression
import de.agra.emf.metamodels.SMTlib2extended.Expression
import de.agra.emf.metamodels.SMTlib2extended.GreaterEqualsExpression
import de.agra.emf.metamodels.SMTlib2extended.GreaterExpression
import de.agra.emf.metamodels.SMTlib2extended.ImpliesExpression
import de.agra.emf.metamodels.SMTlib2extended.LessEqualsExpression
import de.agra.emf.metamodels.SMTlib2extended.LessExpression
import de.agra.emf.metamodels.SMTlib2extended.NotExpression
import de.agra.emf.metamodels.SMTlib2extended.OrExpression
import de.agra.emf.metamodels.SMTlib2extended.util.SMTlib2extendedSwitch
import org.eclipse.emf.ecore.EObject

class JsonExpressionOperationString extends SMTlib2extendedSwitch<String> {
    def static getOperationString(Expression expression) {
        (new JsonExpressionOperationString).doSwitch(expression)
    }

    override caseImpliesExpression(ImpliesExpression expression) {
        "implies"
    }

    override caseEqualsExpression(EqualsExpression expression) {
        "="
    }

    override caseLessEqualsExpression(LessEqualsExpression expression) {
        "bvsle"
    }

    override caseLessExpression(LessExpression expression) {
        "bvslt"
    }

    override caseGreaterEqualsExpression(GreaterEqualsExpression expression) {
        "bvsge"
    }

    override caseGreaterExpression(GreaterExpression expression) {
        "bvsgt"
    }

    override caseAddExpression(AddExpression expression) {
        "+"
    }

    override caseNotExpression(NotExpression expression) {
        "not"
    }

    override caseAndExpression(AndExpression expression) {
        "&&"
    }

    override caseOrExpression(OrExpression expression) {
        "||"
    }

    override defaultCase(EObject object) {
        throw new UnsupportedOperationException(
            "(JsonExpressionOperationString.xtend) Not implemented: " + object.^class.name)
    }
}
