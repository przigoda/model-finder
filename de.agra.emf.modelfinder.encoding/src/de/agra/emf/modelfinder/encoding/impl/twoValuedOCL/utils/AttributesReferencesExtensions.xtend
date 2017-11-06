package de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.utils

import de.agra.emf.metamodels.SMTlib2extended.Bitvector
import de.agra.emf.metamodels.SMTlib2extended.Expression
import de.agra.emf.metamodels.SMTlib2extended.Instance
import de.agra.emf.metamodels.SMTlib2extended.Variable
import de.agra.emf.metamodels.SMTlib2extended.VariableExpression
import de.agra.emf.modelfinder.encoding.PlaceholderExpression
import de.agra.emf.modelfinder.statesequence.state.StateObject
import de.agra.emf.modelfinder.statesequence.state.StateResource
import java.util.ArrayList
import java.util.List
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EReference

import static de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.utils.AlphaExtensions.*

import static extension de.agra.emf.metamodels.SMTlib2extended.util.MetaModelExtensions.*
import static extension de.agra.emf.modelfinder.statesequence.utils.EcoreExtensions.*

class AttributesReferencesExtensions {

    static def Expression createVariableExpressionFromObject
    (
        Instance instance,
        StateObject object,
        EReference reference,
        int count
    )
    {
        val variableName = object.variableName(reference)
        val _variable    = instance.getVariable(variableName)
        if (_variable == null)
        {
            new PlaceholderExpression(object) => [
                attributeString = variableName
                attributeWidth  = count
            ]
        }
        else
        {
            variableExpression(_variable)
        }
    }

    static private def List<Expression> encodeConsistencyForReference
    (
        Instance instance,
        StateResource state,
        StateObject object,
        EReference reference,
        Expression variableExpression,
        Expression cardExpr
    )
    {
        val List<Expression> cardExpr1 = new ArrayList<Expression>
        if (cardExpr != null)
        {
            cardExpr1 += encodeAlpha(
                instance,
                (variableExpression as VariableExpression).variable.name,
                cardExpr,
                '1'
            )
        }
        /* if opposite of reference isn't processed ("known") so far, only
         * encode the cardinality constraints else also encode the association
         * end correspondence (consistency)
         */
        if (reference.getEOpposite != null)
        {
            val EClass referenceClass = reference.getEReferenceType
            val referenceObjects= state.allObjectsOfType(referenceClass)
            val EClass oppositeClass = reference.getEOpposite.getEReferenceType
            val oppositeObjects= state.allObjectsOfType(oppositeClass)
            val ownIndex = oppositeObjects.indexOf(object)
            val referenceObjectsCount = referenceObjects.length
            if (variableIsKnown(
                    instance,
                    referenceObjects.head.variableName(reference.getEOpposite)
               ))
            {
                (0..<referenceObjectsCount).forEach[ numberOfNextObject |
                    instance.addAssertion
                    (
                        newEqualsExpression
                        (
                            variableExpression.newExtractIndexExpression(numberOfNextObject),
                            newExtractIndexExpression
                            (
                                createVariableExpressionFromObject
                                (
                                    instance,
                                    referenceObjects.get(numberOfNextObject),
                                    reference.getEOpposite,
                                    referenceObjectsCount
                                ),
                                ownIndex
                            )
                        )
                    )
                    instance.assertions.last.name = "relation-constraint"
                ]
            }
        }
        return cardExpr1
    }

    static public def List<Expression> constraintsForReference
    (
        Instance instance,
        StateResource state,
        StateObject object,
        EReference reference,
        Variable _variable
    )
    {
        val lb = reference.lowerBound
        val ub = reference.upperBound
        if (!(_variable instanceof Bitvector))
        {
            throw new IllegalArgumentException("Trying to build constraints for a "
                + "reference where the given variable is not a bitvector!")
        }
        val variable = _variable as Bitvector
        if (lb == 0)
        {
            if ( 1 == ub) return constraintsForReferenceWithAssoc_0_1
            (
                instance, state, object, reference, variable
            )
            if ( 1 <  ub) return constraintsForReferenceWithAssoc_0_m
            (
                instance, state, object, reference, variable
            )
            if (-1 == ub) return constraintsForReferenceWithAssoc_0_n
            (
                instance, state, object, reference, variable
            )
        }
        if (lb == 1)
        {
            if ( 1 == ub) return  constraintsForReferenceWithAssoc_1_1
            (
                instance, state, object, reference, variable
            )
            if ( 1 <  ub) return constraintsForReferenceWithAssoc_1_m
            (
                instance, state, object, reference, variable
            )
            if (-1 == ub) return constraintsForReferenceWithAssoc_1_n
            (
                instance, state, object, reference, variable
            )
        }
        if (1 < lb)
        {
            if (lb == ub) return constraintsForReferenceWithAssoc_m1_m1
            (
                instance, state, object, reference, variable
            )
            if (lb <  ub) return constraintsForReferenceWithAssoc_m1_m2
            (
                instance, state, object, reference, variable
            )
            if (-1 == ub) return constraintsForReferenceWithAssoc_m1_n(
                instance, state, object, reference, variable
            )
        }
        // if (-1 ==lb && -1 == ub) i.e. assoc * = *..* = 0..*
        return constraintsForReferenceWithAssoc_0_n
        (
            instance, state, object, reference, variable
        )
    }


    static private def List<Expression> constraintsForReferenceWithAssoc_0_1
    (
        Instance instance,
        StateResource state,
        StateObject object,
        EReference reference,
        Bitvector variable
    )
    {
        val Expression variableExpression = variableExpression(variable)
        val List<Expression> orList = new ArrayList<Expression>
        orList.add(newEqualsExpression(
            variableExpression,
            newConstIntegerExpression(
                0,
                variable.width
            )))
        orList.add(newOneHotExpression(variableExpression))
        val cardExpr = newOrExpression( orList )
        encodeConsistencyForReference(
            instance,
            state,
            object,
            reference,
            variableExpression,
            cardExpr
        )
    }

    static private def List<Expression> constraintsForReferenceWithAssoc_0_m
    (
        Instance instance,
        StateResource state,
        StateObject object,
        EReference reference,
        Bitvector variable
    )
    {
        val Expression variableExpression = variable.variableExpression
        val List<Expression> variableExpressionList = new ArrayList<Expression>();
        variableExpressionList.add(variableExpression)
        val cardExpr = variableExpressionList.newCardLeExpression(reference.upperBound)
        encodeConsistencyForReference(
            instance,
            state,
            object,
            reference,
            variableExpression,
            cardExpr
        )
    }

    static private def List<Expression> constraintsForReferenceWithAssoc_0_n
    (
        Instance instance,
        StateResource state,
        StateObject object,
        EReference reference,
        Bitvector variable
    )
    {
        encodeConsistencyForReference(
            instance,
            state,
            object,
            reference,
            variable.variableExpression,
            null
        )
    }

    static private def List<Expression> constraintsForReferenceWithAssoc_1_1
    (
        Instance instance,
        StateResource state,
        StateObject object,
        EReference reference,
        Bitvector variable
    )
    {
        val Expression variableExpression = variable.variableExpression
        encodeConsistencyForReference(
            instance,
            state,
            object,
            reference,
            variableExpression,
            variableExpression.newOneHotExpression
        )
    }

    static private def List<Expression> constraintsForReferenceWithAssoc_1_m
    (
        Instance instance,
        StateResource state,
        StateObject object,
        EReference reference,
        Bitvector variable
    )
    {
        val Expression variableExpression = variable.variableExpression
        val List<Expression> variableExpressionList = new ArrayList<Expression>
        variableExpressionList.add(variableExpression)
        val cardExpr = variableExpressionList.newCardLeExpression(reference.upperBound)
        val notZeroExpr = newNotExpression(
            newEqualsExpression(
                variableExpression,
                newConstIntegerExpression(0,variable.width)
            )
        )
        val List<Expression> andExprList= new ArrayList<Expression>
        andExprList.add(cardExpr)
        andExprList.add(notZeroExpr)
        encodeConsistencyForReference(
            instance,
            state,
            object,
            reference,
            variableExpression,
            andExprList.newAndExpression
        )
    }

    static private def List<Expression> constraintsForReferenceWithAssoc_1_n
    (
        Instance instance,
        StateResource state,
        StateObject object,
        EReference reference,
        Bitvector variable
    )
    {
        val Expression variableExpression = variable.variableExpression
        val notZeroExpr = newNotExpression(
            newEqualsExpression(
                variableExpression,
                newConstIntegerExpression(0,variable.width)
            )
        )
        encodeConsistencyForReference(
            instance,
            state,
            object,
            reference,
            variableExpression,
            notZeroExpr
        )
    }

    static private def List<Expression> constraintsForReferenceWithAssoc_m1_m1
    (
        Instance instance,
        StateResource state,
        StateObject object,
        EReference reference,
        Bitvector variable
    )
    {
        val Expression variableExpression = variable.variableExpression
        val List<Expression> variableExpressionList = new ArrayList<Expression>
        variableExpressionList.add(variableExpression)
        encodeConsistencyForReference(
            instance,
            state,
            object,
            reference,
            variableExpression,
            variableExpressionList.newCardEqExpression(reference.upperBound)
        )
    }

    static private def List<Expression> constraintsForReferenceWithAssoc_m1_m2
    (
        Instance instance,
        StateResource state,
        StateObject object,
        EReference reference,
        Bitvector variable
    )
    {
        val Expression variableExpression = variable.variableExpression
        val List<Expression> variableExpressionList = new ArrayList<Expression>
        variableExpressionList.add(variableExpression)
        val List<Expression> andExprList = new ArrayList<Expression>
        andExprList += encodeConsistencyForReference(
            instance,
            state,
            object,
            reference,
            variableExpression,
            variableExpressionList.newCardGeExpression(reference.lowerBound)
        )
        andExprList += encodeConsistencyForReference(
            instance,
            state,
            object,
            reference,
            variableExpression,
            variableExpressionList.newCardLeExpression(reference.upperBound)
        )
        val List<Expression> resultExpressionList= new ArrayList<Expression>
        resultExpressionList.add(andExprList.newAndExpression)
        resultExpressionList
    }

    static private def List<Expression> constraintsForReferenceWithAssoc_m1_n
    (
        Instance instance,
        StateResource state,
        StateObject object,
        EReference reference,
        Bitvector variable
    )
    {
        val Expression variableExpression = variable.variableExpression
        val List<Expression> variableExpressionList = new ArrayList<Expression>
        variableExpressionList.add(variableExpression)
        encodeConsistencyForReference(
            instance,
            state,
            object,
            reference,
            variableExpression,
            variableExpressionList.newCardGeExpression(reference.lowerBound)
        )
    }
}
