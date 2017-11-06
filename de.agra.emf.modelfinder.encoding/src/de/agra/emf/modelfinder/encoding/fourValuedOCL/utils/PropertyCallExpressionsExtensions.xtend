package de.agra.emf.modelfinder.encoding.fourValuedOCL.utils

import de.agra.emf.metamodels.SMTlib2extended.Expression
import de.agra.emf.metamodels.SMTlib2extended.Instance
import de.agra.emf.metamodels.SMTlib2extended.Variable
import de.agra.emf.metamodels.SMTlib2extended.VariableExpression
import de.agra.emf.modelfinder.encoding.PlaceholderExpression
import de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.utils.PlaceholderReplacer
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

class PropertyCallExpressionsExtensions extends de.agra.emf.modelfinder.encoding.PropertyCallExpressionsExtensions {

    def static Expression encodePropertyCallExpression
    (
        Instance instance,
        StateResource state,
        EStructuralFeature property,
        PropertyCallExp<?,EStructuralFeature> expression,
        Expression sourceExpr
    )
    {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }

    def static Expression encodePropertyCallExpression__forFixedEStructuralFeature
    (
        Instance instance,
        StateResource state,
        EStructuralFeature struct,
        PropertyCallExp<?,EStructuralFeature> expression,
        Expression sourceExpression
    )
    {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }

    /**
     * Returns a variable expression from a Property, i.e. attributes and references
     */
    def static VariableExpression varExpressionFromProperty
    (
        Instance instance,
        EStructuralFeature property,
        StateObject object
    )
    {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }

    //TODO there was a comment suggesting, this could still produce errors when using @pre... not certain if already fixed or not
    def private static Expression replacePlaceholdersByVariables
    (
        Instance instance,
        EStructuralFeature property,
        PropertyCallExp propertyExp,
        Expression sourceExpr,
        StateResource state
    )
    {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }

    def private static Expression encodePropertyCallExpression__EAttribute
    (
        Instance instance,
        StateResource state,
        EAttribute attribute,
        PropertyCallExp propertyCallExp,
        Expression sourceExpr
    )
    {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }

    def private static Expression encodePropertyCallExpression__EReference
    (
        Instance instance,
        StateResource state,
        EReference reference,
        PropertyCallExp propertyCallExp,
        Expression sourceExpr
    )
    {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
}