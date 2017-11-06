package de.agra.emf.modelfinder.encoding

import de.agra.emf.metamodels.SMTlib2extended.BinaryExpression
import de.agra.emf.metamodels.SMTlib2extended.Expression
import de.agra.emf.metamodels.SMTlib2extended.ExtractIndexExpression
import de.agra.emf.metamodels.SMTlib2extended.IteExpression
import de.agra.emf.metamodels.SMTlib2extended.NAryExpression
import de.agra.emf.metamodels.SMTlib2extended.UnaryExpression
import de.agra.emf.metamodels.SMTlib2extended.util.SMTlib2extendedSwitch
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtend.lib.annotations.Accessors

/**
 * The ExpressionVisitor<T> is subclass of SMTlib2extendedSwitch<T>. It has been
 * created to support PlaceholderExpression. Furthermore, it provides a
 * mechanism to visit the sub-Expressions of Unary-, Binary-, NAray-, Extract-,
 * and IteExpressions. It is enabled by default, cf. lookInside.
 */

abstract class ExpressionSwitch<T> extends SMTlib2extendedSwitch<T>
{
    @Accessors boolean lookInside = true;

    override T doSwitch(EObject object)
    {
        if (object instanceof Expression)
        {
            switch (object)
            {
                PlaceholderExpression:
                    casePlaceholderExpression(object)
                default:
                    super.doSwitch(object)
            }
        }
        else
        {
            defaultCase(object)
        }
    }

    def T casePlaceholderExpression(PlaceholderExpression object)

    override T caseUnaryExpression(UnaryExpression object)
    {
        if (lookInside)
        {
            doSwitch(object.expr)
        }
        super.caseUnaryExpression(object)
    }

    override T caseBinaryExpression(BinaryExpression object)
    {
        if (lookInside)
        {
            doSwitch(object.lhs)
            doSwitch(object.rhs)
        }
        super.caseBinaryExpression(object)
    }

    override T caseNAryExpression(NAryExpression object) {
        if (lookInside)
        {
            object.expressions.forEach[doSwitch]
        }
        super.caseNAryExpression(object)
    }

    override caseExtractIndexExpression(ExtractIndexExpression object) {
        if (lookInside)
        {
            doSwitch(object.expr)
        }
        super.caseExtractIndexExpression(object)
    }

    override caseIteExpression(IteExpression object) {
        if (lookInside)
        {
            doSwitch(object.condition)
            doSwitch(object.thenexpr)
            doSwitch(object.elseexpr)
        }
        super.caseIteExpression(object)
    }
}