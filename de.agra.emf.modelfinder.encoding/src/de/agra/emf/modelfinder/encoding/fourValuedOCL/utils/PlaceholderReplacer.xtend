package de.agra.emf.modelfinder.encoding.fourValuedOCL.utils

import de.agra.emf.metamodels.SMTlib2extended.BinaryExpression
import de.agra.emf.metamodels.SMTlib2extended.Expression
import de.agra.emf.metamodels.SMTlib2extended.ExtractIndexExpression
import de.agra.emf.metamodels.SMTlib2extended.Instance
import de.agra.emf.metamodels.SMTlib2extended.IteExpression
import de.agra.emf.metamodels.SMTlib2extended.NAryExpression
import de.agra.emf.metamodels.SMTlib2extended.UnaryExpression
import de.agra.emf.metamodels.SMTlib2extended.util.SMTlib2extendedSwitch
import de.agra.emf.modelfinder.statesequence.state.StateObject
import java.util.List
import org.eclipse.emf.ecore.EStructuralFeature

import static extension de.agra.emf.metamodels.SMTlib2extended.util.MetaModelExtensions.*
import static de.agra.emf.modelfinder.encoding.fourValuedOCL.utils.PropertyCallExpressionsExtensions.*
import static extension de.agra.emf.modelfinder.encoding.fourValuedOCL.utils.PlaceholderExtensions.*

import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.Data
import de.agra.emf.modelfinder.encoding.PlaceholderExpression
import de.agra.emf.modelfinder.encoding.ExpressionSwitch

class PlaceholderReplacer extends ExpressionSwitch<Expression>
{
    new
    (
        Instance instace,
        EStructuralFeature eStruct,
        List<StateObject> objects
    )
    {
        this.instance = instance
        this.eStruct = eStruct
        this.objects = objects
    }
    
    @Accessors Instance instance
    @Accessors EStructuralFeature eStruct
    @Accessors List<StateObject> objects

    private def placeholder(int index)
    {
        if (    index <  0
            ||  index >= objects.length
        )
        {
            throw new IllegalArgumentException("Calling placeholder in PlaceholderReplacer with a non valid index")
        }
        newPlaceholderExpression
        (
            objects.get(index),
            index,
            objects.length
        )
    }

    override caseNAryExpression(NAryExpression object) {
        object.expressions.forEach[doSwitch]
        object
    }

    override caseExtractIndexExpression(ExtractIndexExpression object) {
        doSwitch(object.expr)
        object
    }

    override caseIteExpression(IteExpression object) {
        newIteExpression
        (
            doSwitch(object.condition),
            doSwitch(object.thenexpr),
            doSwitch(object.elseexpr)
        )
    }

    override casePlaceholderExpression(PlaceholderExpression object) {
        // TODO check if it is possible to optimize this in the following case:
        // if (reference.lowerBound == 1 && reference.upperBound == 1)
        if (object.isEmptyPlaceholder)
        {
            if (objects.length == 1)
            {
                placeholder(0)
            }
            else
            {
                val varExpr = de.agra.emf.modelfinder.encoding.fourValuedOCL.utils.PropertyCallExpressionsExtensions::varExpressionFromProperty
                (
                    instance,
                    eStruct,
                    object.object as StateObject
                )
                var subExpr = placeholder(objects.length - 1)
                for (var index = objects.length - 2; index >= 0; index--)
                {
                    subExpr = newIteExpression
                    (
                        newEqualsExpression
                        (
                            varExpr.newExtractIndexExpression(index),
                            newBitstringExpression("1")
                        ),
                        placeholder(index),
                        subExpr
                    )
                }
                return subExpr
            }
        }
        else
        {
            throw new Exception("Check if this can happen")
        }
    }
}