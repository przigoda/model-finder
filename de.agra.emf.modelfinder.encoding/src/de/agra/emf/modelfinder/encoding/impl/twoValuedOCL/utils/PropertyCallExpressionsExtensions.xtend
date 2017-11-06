package de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.utils

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
        sourceExpr.checkNotNull("sourceExpr is NULL in "
                + "PropertyCallExpressionsExtensions::encodePropertyCallExpression( .. )")
        if (sourceExpr instanceof BitstringExpression
            && !(sourceExpr as BitstringExpression).value.contains('1') )
        {
            // the reference is null special handling is required
            System.err.println("Trying to get a property of sourceExpr which represents null!")
            return newConstIntegerExpression(0,intBitwidth)
            
        }
        else
        {
            print("")
        }
        val flagValue = property.checkForMFflag("groundSettingProperty")
        switch (property) {
            EAttribute:{
                if (   flagValue.present
                    && flagValue.get.toLowerCase.equals(("true")) )
                {
                    return instance.encodePropertyCallExpression__forFixedEStructuralFeature
                    (
                        state,
                        property,
                        expression,
                        sourceExpr
                    )
                }
                else
                {
//                    if (!(sourceExpr instanceof PlaceholderExpression))
//                    {
//                        throw new Exception("sourceExpr in encodePropertyCallExpression is called "
//                            + "which EAttribute while sourceExpr is no PlaceholderExpression!\n"
//                            + "sourceExpr.class = " + sourceExpr.class
//                        )
//                    }
                    val result =
                    instance.encodePropertyCallExpression__EAttribute
                    (
                        state,
                        property,
                        expression,
                        sourceExpr
                    )
                    return result
                }
            }
            EReference:{
                if (   flagValue.present
                    && flagValue.get.toLowerCase.equals(("true")) )
                {
                    return instance.encodePropertyCallExpression__forFixedEStructuralFeature
                    (
                        state,
                        property,
                        expression,
                        sourceExpr
                    )
                }
                else
                {
                    return instance.encodePropertyCallExpression__EReference
                    (
                        state,
                        property,
                        expression,
                        sourceExpr
                    )
                }
            }
            default: 
                throw new Exception("Property \""+property.class.name+"\" "
                    + "is not implemented!"
                )
        }
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
        if (sourceExpression instanceof PlaceholderExpression)
        {
            if (struct instanceof EAttribute)
            {
                sourceExpression.attributeString = struct.name
                val EAttribute attribute = struct
                if (attribute.getEType.name.typeFlag.equals("bool"))
                {
                    if (attribute.many)
                    {
                        if (attribute.set)
                        {
//                            sourceExpression.attributeWidth = boolSetBitwidth
                        }
                        else
                        {
                            throw new UnsupportedOperationException
                        }
                    }
                    else
                    {
                        sourceExpression.attributeWidth = boolBitwidth
                    }
                    var StateObject eObject = sourceExpression.object as StateObject
                    if (expression.markedPre)
                    {
                        val nameSplit = (state.contents.head as StateObject).name.split("::")
                        eObject = state.findObjectInState
                        (
                            eObject,
                            nameSplit.get(1)
                        )
                    }
                    sourceExpression.varExpression = instance.varExpressionFromProperty
                    (
                        attribute,
                        eObject
                    )
                    return sourceExpression
                }
                else if (attribute.getEType.name.typeFlag.equals("int"))
                {
                    var resultWidth = -1
                    if (attribute.many)
                    {
                        if (attribute.set)
                        {
                            resultWidth  = intSetBitwidth
                        }
                        else
                        {
                            throw new UnsupportedOperationException
                        }
                    }
                    else
                    {
                        resultWidth = intBitwidth
                    }
                    var StateObject eObject = sourceExpression.object as StateObject
                    val value =  eObject.eGet(attribute)
                    if (value instanceof Integer)
                    {
                        return value.newConstIntegerExpression(resultWidth)
                    }
                    else if (value instanceof EList)
                    {
                        var String bitstring = constString("0",resultWidth)
                        val valuesIt = value.iterator
                        while (valuesIt.hasNext)
                        {
                            val cValue = valuesIt.next as Integer
                            bitstring = bitstring.replaceCharAt("1",cValue)
                        }
                        return bitstring.reverse.newBitstringExpression
                    }
                }
            }
            else if (struct instanceof EReference)
            {
                val EReference reference = struct
                val sourceType = expression.source.type
                if (sourceType instanceof EClass)
                {
                    val StateObject eObject = sourceExpression.object as StateObject
                    val posObjects = state.contents.filter[reference.getEReferenceType.isSuperTypeOf(it.eClass)]
                    val stateOfPO = (posObjects.head as StateObject).name.split("::").get(1)
                    val resultWidth = posObjects.length()
                    var String bitstring = constString("0",resultWidth)
                    val value =  eObject.eGet(reference)
                    if (value == null)
                    {
                        return bitstring.newBitstringExpression
                    }
                    else if (value instanceof StateObject)
                    {
                        val stateOfValue = value.name.split("::").get(1)
                        var indexOfEObject = -1
                        if (!stateOfValue.equals(stateOfPO))
                        {
                            val prePosObjects = state.preState.contents.filter[reference.getEReferenceType.isSuperTypeOf(it.eClass)]
                            indexOfEObject = StateSequenceGenerator::indexOf(prePosObjects, value)
                        }
                        else
                        {
                            indexOfEObject = StateSequenceGenerator::indexOf(posObjects, value)
                        }
                        return bitstring.replaceCharAt("1", indexOfEObject)
                                        .reverse
                                        .newBitstringExpression
                    }
                    else if (value instanceof EList)
                    {
                        val stateOfValue = (value.head as StateObject).name.split("::").get(1)
                        var Iterable<EObject> itObjects = null
                        if (!stateOfValue.equals(stateOfPO))
                        {
                            itObjects = state.preState.contents.filter[reference.getEReferenceType.isSuperTypeOf(it.eClass)]
                        }
                        else
                        {
                            itObjects = posObjects
                        }
                        val valuesIt = value.iterator
                        while (valuesIt.hasNext)
                        {
                            val cValue = valuesIt.next
                            val indexOfEObject = StateSequenceGenerator::indexOf(itObjects, cValue)
                            bitstring = bitstring.replaceCharAt("1",indexOfEObject)
                        }
                        return bitstring.reverse.newBitstringExpression
                    }
//                    println("tmp = " + tmp)
//                    sourceExpression.attributeString = reference.name
//                    sourceExpression.attributeWidth = state.contents.filter[reference.EReferenceType.isSuperTypeOf(it.eClass)].length()
//                    var StateObject eObject = sourceExpression.object as StateObject
//                    if (expression.markedPre)
//                    {
//                        val nameSplit = (state.contents.head as StateObject).name.split("::")
//                        eObject = state.findObjectInState
//                        (
//                            eObject,
//                            nameSplit.get(1)
//                        )
//                    }
//                    sourceExpression.varExpression = instance.varExpressionFromProperty
//                    (
//                        reference,
//                        eObject
//                    )
//                    return sourceExpression
                }
            }
            throw new UnsupportedOperationException("unsupported sourceExpression case")
        }
        else if (sourceExpression instanceof IteExpression)
        {
            val sourceType = expression.source.type
            if (sourceType instanceof EClass)
            {
                if (sourceExpression.thenexpr instanceof PlaceholderExpression)
                {
                    sourceExpression.thenexpr = instance.encodePropertyCallExpression__forFixedEStructuralFeature
                    (
                        state,
                        struct,
                        expression,
                        sourceExpression.thenexpr
                    )
                    sourceExpression.elseexpr = instance.encodePropertyCallExpression__forFixedEStructuralFeature
                    (
                        state,
                        struct,
                        expression,
                        sourceExpression.elseexpr
                    )
                    return sourceExpression
                }
            }
        }
        else if (sourceExpression instanceof BitstringExpression)
        {
            val bitstring = sourceExpression.value
            val eObjectIndex = bitstring.indexOf("1")
            // TODO more than one "1" handling
            val sourceType = expression.source.type
            if (sourceType instanceof EClass)
            {
                val eObject = state.contents.filter[sourceType.isSuperTypeOf(it.eClass)].get(eObjectIndex)
                val placeholder = newPlaceholderExpression(eObject,eObjectIndex,bitstring.length)
                return instance.encodePropertyCallExpression__forFixedEStructuralFeature
                (
                    state,
                    struct,
                    expression,
                    placeholder
                )
            }
            else
            {
                //
            }
        }
        throw new UnsupportedOperationException()
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
        // obtain variable name
        val String varName = object.variableName(property)
        // get the variable from the SMT instance
        val Variable variable = instance.getVariable(varName)
        if (variable == null)
        {
            println("variable was not found")
        }
        // create variable expression from it
        newVariableExpression(variable) as VariableExpression
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
        val flagValue = property.checkForMFflag
        (
            if (MetaModelExtensions.optimizeConstraints)
                "groundSettingProperty"
            else
                "?"
        )
        val EList<Expression> expr = expressionEList( sourceExpr as Expression )
        // Die EList is Quatsch! Hier sollte eigentlich ein Visitor genutzt werden
        expr.forEach[ it, index |
            //get all empty placeholder expressions in the source
            if (   flagValue.present
                && flagValue.get.toLowerCase.equals(("true")) )
            {
                if (property instanceof EAttribute)
                {
                    print("")
                    // TODO: check this lines
                }
                else if (property instanceof EReference)
                {
                    instance.encodePropertyCallExpression__forFixedEStructuralFeature
                    (
                        state,
                        property,
                        propertyExp,
                        it
                    )
                }
                throw new UnsupportedOperationException
            }
            else
            {
                if (isEmptyPlaceholder(it))
                {
                    var phExpr = it as PlaceholderExpression
                    var stateObject = phExpr.object as StateObject
                    val splitName = stateObject.name.split("::")
                    val newStateObject = state.allObjects.findFirst[
                        val splitTemp = it.name.split("::")
                        splitName.get(2) == splitTemp.get(2)
                    ]
                    phExpr.varExpression =
                        varExpressionFromProperty(
                            instance,
                            property,
                            newStateObject
                        )
                }
                else if (it instanceof BitstringExpression)
                {
                    // how should I override the object where the reference is pointing to
//                    val sourceType = propertyExp.source.type as EClass
//                    val possibleObjects = state.allObjectsOfType(sourceType)
//                    val first1 = it.value.reverse.indexOf('1')
//                    if (first1 == -1)
//                    {
//                        print("")
//                    }
//                    else
//                    {
//                        val eObject = possibleObjects.get(first1) as StateObject
//                        val result = newPlaceholderExpression(eObject,first1,possibleObjects.length) as PlaceholderExpression
//                        result.varExpression = instance.varExpressionFromProperty
//                        (
//                            property,
//                            eObject
//                        )
//                        var Expression itRef = it
//                        itRef = result
//                    }
                }
            }
        ]
        sourceExpr
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
        /*
         * If the sourceExpr is a BitstringExpresssion, then it hopefully points to specific object
         * and the VariableExpression can be directly encoded:
         */
        if (sourceExpr instanceof BitstringExpression)
        {
            val index = sourceExpr.value.reverse.indexOf("1")
            val eObject = state.allObjectsOfType(propertyCallExp.source.type as EClass).get(index)
            return instance.varExpressionFromProperty
            (
                attribute,
                eObject
            )
        }
        instance.replacePlaceholdersByVariables
        (
            attribute,
            propertyCallExp,
            sourceExpr,
            state
        )
    }

//    private static def Expression encodePropertyCallExpression__EStructuralFeature
    def private static Expression encodePropertyCallExpression__EReference
    (
        Instance instance,
        StateResource state,
        EReference reference,
        PropertyCallExp propertyCallExp,
        Expression sourceExpr
    )
    {
        if (reference.many)
        { // MANY
            replacePlaceholdersByVariables(
                instance,
                reference,
                propertyCallExp,
                sourceExpr,
                state
            )
        }
        else
        { // SINGLE
            val objects = state.allObjectsOfType(reference.getEReferenceType)
            val replacer = new PlaceholderReplacer
            (
                instance,
                reference,
                objects
            )
            replacer.doSwitch(sourceExpr)
        }
    }
}