package de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.utils

import de.agra.emf.metamodels.SMTlib2extended.Expression
import de.agra.emf.metamodels.SMTlib2extended.Instance
import de.agra.emf.metamodels.SMTlib2extended.Variable
import de.agra.emf.modelfinder.encoding.EncodingUtils
import de.agra.emf.modelfinder.statesequence.StateSequence
import de.agra.emf.modelfinder.statesequence.state.StateObject
import de.agra.emf.modelfinder.statesequence.state.StateResource
import java.util.HashMap
import java.util.List
import java.util.Map
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.ocl.ecore.Constraint

import static de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.utils.AlphaExtensions.*
import static de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.utils.ExpressionsExtensions.*

import static extension de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.utils.AttributesExtensions.*
import static extension de.agra.emf.modelfinder.statesequence.utils.EcoreExtensions.*
import static extension de.agra.emf.modelfinder.utils.OCLExtensions.*
import static extension de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.utils.ModifyObjectsExtensions.*
import static extension de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.utils.ModifyPropertiesStatementExtensions.*

class EncodingUtilsImpl implements EncodingUtils
{
    override void encodeAttributes
    (
        Instance instance,
        StateResource state
    )
    {
        state.contents.forEach[ object |
            instance.encodeAttributesForObject
            (
                state,
                object as StateObject
            )
        ]
    }

    override List<Expression> encodeInvariant
    (
        Instance instance,
        StateResource state,
        Constraint invariant
    )
    {
        state.allObjectsOfType(invariant.context as EClass)
             .map[ object |
            val sObject = object as StateObject
            val Map<String, EObject> varMap = new HashMap<String, EObject>
            varMap.put("self", sObject)
            encodeAlpha(
                instance,
                sObject.toString,
                encodeExpression(
                    instance,
                    state,
                    invariant.bodyExpression,
                    varMap
                ),
                '1'
            )
        ]
    }

    override Expression encodePreCondition
    (
        Instance instance,
        StateResource state,
        Constraint precondition,
        Map<String, EObject> varmap
    )
    {
        encodeExpression
        (
            instance,
            state,
            precondition.bodyExpression,
            varmap
        )
    }

    override Expression encodePostCondition
    (
        Instance instance,
        StateResource state,
        Constraint postcondition,
        Map<String, EObject> varmap
    )
    {
        encodeExpression
        (
            instance,
            state,
            postcondition.bodyExpression,
            varmap
        )
    }

    override Expression encodeSingleModifyPropertiesStatement
    (
        StateSequence sequence,
        Instance instance,
        StateResource state,
        List<Variable> variablesOfPostState,
        Constraint modifiesConstraint,
        Map<String, EObject> varmap,
        Integer modifyCounter,
        Integer omegaValue,
        Integer omegaIndex
    )
    {
        sequence.encodeSingleModifyPropertiesExpression
        (
            instance,
            state,
            variablesOfPostState,
            modifiesConstraint,
            varmap,
            modifyCounter,
            omegaValue,
            omegaIndex
        )
    }

    override encodeFinalizingModifyProperties
    (
        StateSequence sequence,
        Instance instance,
        List<Variable> variablesOfPostState,
        Variable gfcBV
    )
    {
        sequence.encodeFinalizingModifyPropertiesExpression
        (
            instance,
            variablesOfPostState,
            gfcBV
        )
    }

    override encodeSingleModifyObjectsStatement
    (
        StateSequence sequence,
        Instance instance,
        StateResource state,
        List<EClass> possibleEClasses,
        Constraint modifiesConstraint,
        Map<String, EObject> varmap,
        Integer modifyCounter,
        Integer omegaValue,
        Integer omegaIndex
    )
    {
        sequence.encodeSingleModifyObjectsExpression
        (
            instance,
            state,
            possibleEClasses,
            modifiesConstraint,
            varmap,
            modifyCounter,
            omegaValue,
            omegaIndex
        )
    }

    override encodeFinalizingModifyObjects
    (
        StateSequence sequence,
        Instance instance,
        List<EClass> possibleRealEClasses,
        Integer preStateNo,
        Variable gfcBV
    )
    {
        sequence.encodeFinalizingModifyObjectsExpression
        (
            instance,
            possibleRealEClasses,
            preStateNo,
            gfcBV
        )
    }
}