package de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.utils

import de.agra.emf.metamodels.SMTlib2extended.BitstringExpression
import de.agra.emf.metamodels.SMTlib2extended.Expression
import de.agra.emf.modelfinder.encoding.PlaceholderExpression
import de.agra.emf.modelfinder.statesequence.state.StateObject
import org.eclipse.emf.ecore.EObject

import static de.agra.emf.metamodels.SMTlib2extended.util.MetaModelExtensions.*

class PlaceholderExtensions {

    static def Expression newPlaceholderExpression
    (
        EObject object,
        int index,
        int bitWidth
    )
    {
        val result = new PlaceholderExpression(object)
        result.intExpression = newBitstringExpression(
            getOneHotBitstring(
                bitWidth,
                index
            )
        ) as BitstringExpression
        result 
    }

    static def Expression newPlaceholderExpressionAttr
    (
        StateObject object,
        String _attributeName,
        int _attributeWidth
    )
    {
        new PlaceholderExpression(object) => [
            attributeString = _attributeName
            attributeWidth = _attributeWidth
        ]
    }

    /**
     * Check whether expression is of type PlaceholderExpression and
     * variable has not yet been set
     */
    static def isEmptyPlaceholder(Expression expression)
    {
            (expression instanceof PlaceholderExpression)
        &&  ((expression as PlaceholderExpression).varExpression == null)
    }
}
