package de.agra.emf.metamodels.SMTlib2extended.conversion

import de.agra.emf.metamodels.SMTlib2extended.AndExpression
import de.agra.emf.metamodels.SMTlib2extended.BinaryExpression
import de.agra.emf.metamodels.SMTlib2extended.ConstBooleanExpression
import de.agra.emf.metamodels.SMTlib2extended.ConstIntegerExpression
import de.agra.emf.metamodels.SMTlib2extended.Expression
import de.agra.emf.metamodels.SMTlib2extended.ImpliesExpression
import de.agra.emf.metamodels.SMTlib2extended.OrExpression
import de.agra.emf.metamodels.SMTlib2extended.UnaryExpression
import de.agra.emf.metamodels.SMTlib2extended.VariableExpression
import de.agra.emf.metamodels.SMTlib2extended.util.SMTlib2extendedSwitch
import org.eclipse.emf.ecore.EObject

class JsonConverter extends SMTlib2extendedSwitch<String> {
    def static convert(Expression expression) {
        (new JsonConverter).doSwitch(expression)
    }

    def static convertCompact(Expression expression) {
        convert(expression).replace('\n', ' ').replaceAll("[ ]+", " ").replaceAll(" ,", ",").trim
    }

    override caseUnaryExpression(UnaryExpression expression) '''
        { "op": "«JsonExpressionOperationString::getOperationString(expression)»",
          "operand": «doSwitch(expression.expr)» }
    '''

    override caseBinaryExpression(BinaryExpression expression) '''
        { "op": "«JsonExpressionOperationString::getOperationString(expression)»",
          "lhs": «doSwitch(expression.lhs)»,
          "rhs": «doSwitch(expression.rhs)» }
    '''

    override caseVariableExpression(VariableExpression expression) '''
        { "op": "variable",
          "name": "«expression.variable.name»" }
    '''

    override caseConstIntegerExpression(ConstIntegerExpression expression) '''
        { "op": "integer",
          "value": «expression.value»,
          "width": «expression.width» }
    '''

    override caseImpliesExpression(ImpliesExpression expression) {
        '''
            { "op": "«JsonExpressionOperationString::getOperationString(expression)»",
              "lhs": «doSwitch(expression.lhs)»,
              "rhs": «doSwitch(expression.rhs)» }
        '''
    }

    override caseConstBooleanExpression(ConstBooleanExpression expression) {
        '''{ "op": "boolean", "value": «expression.isValue» } '''
    }

    override caseOrExpression(OrExpression expression) {
        '''
            { "op": "«JsonExpressionOperationString::getOperationString(expression)»",
              "lhs": «doSwitch(expression.expressions.get(0))»,
              "rhs": «doSwitch(expression.expressions.get(1))» }
        '''
    }

    override caseAndExpression(AndExpression expression) {

        //        for (e : expression.expressions) {
        //            println(e)
        //            println(doSwitch(e))
        //        } 
        '''
            { "op": "«JsonExpressionOperationString::getOperationString(expression)»",
              "lhs": «doSwitch(expression.expressions.get(0))»,
              "rhs": «doSwitch(expression.expressions.get(1))» }
        '''
    }

    override defaultCase(EObject object) {
        throw new UnsupportedOperationException("Not implemented: " + object.^class.name)
    }
}
