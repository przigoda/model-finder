package de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.utils

import de.agra.emf.metamodels.SMTlib2extended.Expression
import de.agra.emf.metamodels.SMTlib2extended.Instance

import static extension de.agra.emf.metamodels.SMTlib2extended.util.MetaModelExtensions.*
import static extension de.agra.emf.modelfinder.encoding.LoadParametersExtensions.*

class AlphaExtensions {

    static def Expression encodeAlpha
    (
        Instance instance,
        String objectName,
        Expression rhs,
        char comparisonBit
    )
    {
        if (useAlpha)
        {
            val alphaConstraint = createAlphaConstraint(instance,objectName,comparisonBit)
            alphaConstraint.newImpliesExpression(rhs)
        }
        else
        {
            rhs
        }
    }

    static def Expression createAlphaVarExpression
    (
        Instance instance,
        String objectName
    )
    {
        val splitObject     = objectName.split("::")
        val objectNameSplit = splitObject.get(2).split("@")
        val className       = objectNameSplit.head
        val objectNo        = Integer.parseInt(objectNameSplit.get(1))
        val alphaVarName    = splitObject.head + "::" +
                              splitObject.get(1) + "::" +
                              className + "::alpha"
        instance.getVariable(alphaVarName).variableExpression
    }

    static def Expression extractAlphaBit
    (
        Instance instance,
        String objectName
    )
    {
        if (objectName.endsWith("alpha"))
        {
            throw new Exception("could not extract an alpha bit from a alpha bitvector")
        }
        val splitObject     = objectName.split("::")
        val objectNameSplit = splitObject.get(2).split("@")
        val className       = objectNameSplit.head
        val objectNo        = Integer.parseInt(objectNameSplit.get(1))
        val alphaVarName    = splitObject.head + "::" +
                              splitObject.get(1) + "::" +
                              className + "::alpha"
        val alphaVarExpr    = instance.getVariable(alphaVarName).variableExpression
        factory.createExtractIndexExpression => [
            start = objectNo
            end = objectNo
            expr = alphaVarExpr
        ]
    }

    static def Expression createAlphaConstraint
    (
        Instance instance,
        String objectName,
        char comparisonBit
    )
    {
        val splitObject     = objectName.split("::")
        val objectNameSplit = splitObject.get(2).split("@")
//        val className       = objectNameSplit.head
        val objectNo        = Integer.parseInt(objectNameSplit.get(1))
//        val alphaVarName    = splitObject.head + "::" +
//                              splitObject.get(1) + "::" +
//                              className + "::alpha"
        val alphaVarExpression = createAlphaVarExpression
        (
            instance,
            objectName
        )
        newEqualsExpression(
            newBitstringExpression(comparisonBit.toString),
            newExtractIndexExpression(
                alphaVarExpression,
                objectNo
            )
        )
    }
}
