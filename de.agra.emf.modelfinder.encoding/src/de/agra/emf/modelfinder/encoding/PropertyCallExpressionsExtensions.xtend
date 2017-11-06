package de.agra.emf.modelfinder.encoding

import de.agra.emf.metamodels.SMTlib2extended.Expression
import de.agra.emf.metamodels.SMTlib2extended.Instance
import de.agra.emf.metamodels.SMTlib2extended.Variable
import de.agra.emf.metamodels.SMTlib2extended.VariableExpression
import de.agra.emf.modelfinder.encoding.PlaceholderExpression
//import de.agra.emf.modelfinder.encoding.PlaceholderReplacer
import de.agra.emf.modelfinder.statesequence.state.StateObject
import de.agra.emf.modelfinder.statesequence.state.StateResource
import java.lang.instrument.IllegalClassFormatException
import java.util.Map
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.ocl.ecore.FeatureCallExp
import org.eclipse.ocl.expressions.OCLExpression

import com.google.common.base.Optional

import static extension de.agra.emf.metamodels.SMTlib2extended.util.MetaModelExtensions.*
import static extension de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.utils.PlaceholderExtensions.*
import static extension de.agra.emf.modelfinder.statesequence.utils.EcoreExtensions.*
import static extension com.google.common.base.Preconditions.*
import de.agra.emf.metamodels.SMTlib2extended.IteExpression
import org.eclipse.ocl.expressions.PropertyCallExp

import static extension de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.utils.AttributesExtensions.*
import static extension de.agra.emf.modelfinder.utils.StringUtilsExtensions.*

import static extension de.agra.emf.modelfinder.encoding.LoadParametersExtensions.*
import de.agra.emf.modelfinder.statesequence.StateSequenceGenerator
import de.agra.emf.metamodels.SMTlib2extended.BitstringExpression
import de.agra.emf.metamodels.SMTlib2extended.util.MetaModelExtensions

abstract class PropertyCallExpressionsExtensions {

    def static Optional<String> checkForMFflag
    (
        EStructuralFeature property,
        String keyName
    )
    {
        if (MetaModelExtensions.optimizeConstraints == false)
        {
            return Optional.absent
        }
        property.checkNotNull("propery may not be null")
        keyName.checkNotNull("keyName may not be null")
        val mfAnnotations = property.getEAnnotations.findFirst[it.source.equals("ModelFinder")]
        if (mfAnnotations == null)
        {
            return Optional.absent;
        }
        val mfFlag = mfAnnotations.details.findFirst[it?.key?.equals(keyName)]
        if (mfFlag == null)
        {
            return Optional.absent;
        }
        return Optional.of(mfFlag.value)
    }

    def static Map<String, EObject> preStateVarmap
    (
        Map<String, EObject> varmap,
        StateResource prestate
    )
    {
        varmap.mapValues[ v |
            if (v instanceof Expression)
            {
                v
            }
            else
            {
                prestate.contents.findFirst[ object |
                        object.toString.split("::").get(2)
                    ==  v.toString.split("::").get(2)
                ]
            }
        ]
    }

    def static Map<String, EObject> chooseVarmap
    (
        OCLExpression<?> expression,
        Map<String, EObject> varmap,
        StateResource state
    )
    {
        if (!(expression instanceof FeatureCallExp))
        {
            throw new IllegalClassFormatException("chooseVarmap was called with an "
                + "OCLExpression which is no instance of \"FeatureCallExp<?>\"."
            )
        }
        // if expression is marked @pre use updated varmap otherwise use unchanged varmap
        if ((expression as FeatureCallExp).markedPre)
        {
            preStateVarmap(
                varmap,
                state.preState as StateResource
            )
        }
        else
        {
            varmap
        }
    }

    def static StateResource chooseState
    (
        OCLExpression<?> expression,
        StateResource state
    )
    {
        if (!(expression instanceof FeatureCallExp))
        {
            throw new IllegalClassFormatException("chooseVarmap was called with an "
                + "OCLExpression which is no instance of \"FeatureCallExp<?>\"."
            )
        }
        // if expression is marked @pre use pre state otherwise use old one
        if ((expression as FeatureCallExp).markedPre)
        {
            state.preState as StateResource
        }
        else
        {
            state
        }
    }

    def static findObjectInState
    (
        StateResource state,
        EObject object,
        String stateName
    )
    {
        val stateSep = object.toString.split("::")
        stateSep.set(1, stateName)
        val objectName = stateSep.join("::")
        state.allObjects.findFirst[it.name.equals(objectName)]
    }

/*
 * The following functions are always causing problems during code generation
 * process, thus, they have been removed.
 */
//    def static Expression encodePropertyCallExpression
//    (
//        Instance instance,
//        StateResource state,
//        EStructuralFeature property,
//        PropertyCallExp<?,EStructuralFeature> expression,
//        Expression sourceExpr
//    )
//    {
//        throw new UnsupportedOperationException("If a class extends from \"PropertyCallExpressionsExtensions\""
//            + " the \"encodePropertyCallExpression\" should overridden!")
//    }
//
//    def static Expression encodePropertyCallExpression__forFixedEStructuralFeature
//    (
//        Instance instance,
//        StateResource state,
//        EStructuralFeature struct,
//        PropertyCallExp<?,EStructuralFeature> expression,
//        Expression sourceExpression
//    )
//    {
//        throw new UnsupportedOperationException("If a class extends from \"PropertyCallExpressionsExtensions\""
//            + " the \"encodePropertyCallExpression__forFixedEStructuralFeature\" should overridden!")
//    }
//
//    /**
//     * Returns a variable expression from a Property, i.e. attributes and references
//     */
//    def static VariableExpression varExpressionFromProperty
//    (
//        Instance instance,
//        EStructuralFeature property,
//        StateObject object
//    )
//    {
//        throw new UnsupportedOperationException("If a class extends from \"PropertyCallExpressionsExtensions\""
//            + " the \"varExpressionFromProperty\" should overridden!")
//    }
}