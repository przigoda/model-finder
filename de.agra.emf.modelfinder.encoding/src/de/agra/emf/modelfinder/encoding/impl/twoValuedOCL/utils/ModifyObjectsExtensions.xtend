package de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.utils

import de.agra.emf.metamodels.SMTlib2extended.Expression
import de.agra.emf.metamodels.SMTlib2extended.Instance
import de.agra.emf.metamodels.SMTlib2extended.Variable
import de.agra.emf.modelfinder.statesequence.StateSequence
import de.agra.emf.modelfinder.statesequence.state.StateResource
import java.util.ArrayList
import java.util.List
import java.util.Map
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.ocl.ecore.Constraint
import org.eclipse.ocl.ecore.OperationCallExp
import org.eclipse.ocl.ecore.TypeType

import static de.agra.emf.modelfinder.utils.StringUtilsExtensions.*

import static extension de.agra.emf.metamodels.SMTlib2extended.util.MetaModelExtensions.*
import static extension de.agra.emf.modelfinder.utils.OCLExtensions.*
import de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.InstanceGeneratorImplTwoValuedOCL

class ModifyObjectsExtensions
{
    public static def Expression encodeFinalizingModifyObjectsExpression
    (
        StateSequence sequence,
        Instance instance,
        List<EClass> possibleRealEClasses,
        Integer preStateNo,
        Variable gModifiesOnlyBV
    )
    {
        val gModifiesOnlyBVExpr = gModifiesOnlyBV.variableExpression
        val andList = factory.createAndExpression;
        val modelName = sequence.model.name
        possibleRealEClasses.forEach[ eClass, index |
            val alphaPreVarName = modelName + "::" +
                                  "state" + preStateNo + "::" +
                                  eClass.name + "::alpha"
            val alphaPostVarName = incStateNoInVariableName(alphaPreVarName)
            val alphaVarExprInPreState = instance.getVariable(alphaPreVarName).variableExpression
            val alphaVarExprInPostState = instance.getVariable(alphaPostVarName).variableExpression
            val impliesExpr = factory.createImpliesExpression => [
                lhs = gModifiesOnlyBVExpr.newExtractIndexExpression(index)
            ]
            val innerEq = factory.createEqualsExpression => [
                lhs = alphaVarExprInPreState
                rhs = alphaVarExprInPostState
            ]
            impliesExpr.rhs = innerEq
            andList.expressions += impliesExpr
        ]
        return andList
    }

    public static def Expression encodeSingleModifyObjectsExpression
    (
        StateSequence sequence,
        Instance instance,
        StateResource state,
        List<EClass> possibleRealEClasses,
        Constraint modifiesOnlyConstraint,
        Map<String, EObject> varmap,
        Integer modifyCounter,
        Integer omegaValue,
        Integer omegaIndex
    )
    {
        val expression = modifiesOnlyConstraint.bodyExpression
        switch (expression)
        {
            OperationCallExp:
            {
                val String operationName = expression.referredOperation.name
                if (operationName == "allInstances")
                {
                    val _width = possibleRealEClasses.length
                    val classType = (expression.source.type as TypeType).referredType as EClass
                    val pModifiesOnlyBV = factory.createBitvector => [
                        name = "omega"+omegaIndex+"::"+InstanceGeneratorImplTwoValuedOCL.modifyObjectsStatementNameInSMT+"@"+omegaValue+"::part@"+modifyCounter
                        width = _width
                    ]
                    instance.variables += pModifiesOnlyBV
                    val pModifiesOnlyBVExpr = pModifiesOnlyBV.newVariableExpression;
                    val List<Expression> singleBitExprList = new ArrayList<Expression>();
                    possibleRealEClasses.forEach[ currentEClass, index |
                        val extractIndex = pModifiesOnlyBVExpr.newExtractIndexExpression(index)
                        if (classType.isSuperTypeOf(currentEClass))
                        {
                            singleBitExprList +=
                                factory.createEqualsExpression => [
                                    lhs = extractIndex
                                    rhs = newBitstringExpression("0")
                                ]
                        }
                        else
                        {
                            singleBitExprList +=
                                factory.createEqualsExpression => [
                                    lhs = extractIndex
                                    rhs = newBitstringExpression("1")
                                ]
                        }
                    ]
                    instance.assertions += singleBitExprList.newAndExpression
                    return pModifiesOnlyBVExpr
                }
                throw new UnsupportedOperationException("ModifiesOnly is currently only "
                    + "supported with [CLASSNAME].allInstances()")
            }
            default:
            {
                throw new UnsupportedOperationException("ModifiesOnly is currently only "
                    + "supported with [CLASSNAME].allInstances()")
            }
        }
    }

    static private def String errorCase(String className)
    {
        "Error in ModifiesOnlyExtensions::encodeModifyOnlyExpression :\n" + className + " not implemented"
    }
}
