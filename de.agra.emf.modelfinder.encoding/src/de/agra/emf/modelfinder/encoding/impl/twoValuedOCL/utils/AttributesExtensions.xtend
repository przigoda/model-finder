package de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.utils

import de.agra.emf.metamodels.SMTlib2extended.BitstringExpression
import de.agra.emf.metamodels.SMTlib2extended.Bitvector
import de.agra.emf.metamodels.SMTlib2extended.ConstBooleanExpression
import de.agra.emf.metamodels.SMTlib2extended.ConstExpression
import de.agra.emf.metamodels.SMTlib2extended.ConstIntegerExpression
import de.agra.emf.metamodels.SMTlib2extended.Expression
import de.agra.emf.metamodels.SMTlib2extended.Instance
import de.agra.emf.metamodels.SMTlib2extended.Variable
import de.agra.emf.modelfinder.statesequence.StateSequenceGenerator
import de.agra.emf.modelfinder.statesequence.state.StateObject
import de.agra.emf.modelfinder.statesequence.state.StateResource
import de.agra.emf.modelfinder.utils.MathUtilsExtensions
import java.util.List
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EDataType
import org.eclipse.emf.ecore.EEnum
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference

import static de.agra.emf.modelfinder.encoding.LoadParametersExtensions.*

import static extension de.agra.emf.metamodels.SMTlib2extended.util.MetaModelExtensions.*
import static extension de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.utils.AlphaExtensions.*
import static extension de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.utils.AttributesReferencesExtensions.*
import static extension de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.utils.PropertyCallExpressionsExtensions.checkForMFflag
import static extension de.agra.emf.modelfinder.statesequence.utils.EcoreExtensions.*
import static extension de.agra.emf.modelfinder.utils.StringUtilsExtensions.*

class AttributesExtensions {

    static public def typeFlag(String typename)
    {
        if (    typename == "EBoolean"
            ||  typename == "EBooleanObject"
            ||  typename == "Boolean")
        return "bool"
        if (    typename == "EInt"
            ||  typename == "EInteger"
            ||  typename == "EIntegerObject"
            ||  typename == "int"
            ||  typename == "Integer")
        return "int"
        if (    typename == "EString"
            ||  typename == "String")
        return "string"
        // TODO must references be also handle inside this method?
        throw new IllegalArgumentException("The method typeFlag was called with \"" + typename
            + "\" as parameter, but this parameter is illegal")
    }

    /**
     * @brief Creates a new Variable object for a given attribute
     * 
     * @param state The corresponding StateResource
     * @param object The corresponding StateObject 
     * @param attribute The EAttribute for which a variable should be instantiated 
     */
    static private def Variable variableForAttribute
    (
        Instance instance,
        StateResource state,
        StateObject object,
        EAttribute attribute
    )
    {
        if ( (!attribute.unique) || attribute.ordered )
        {
            System.err.println("WARNING: in AttributesExtensions::variableForAttribute\n"
                             + "The attribute "+attribute.name+" is not unique and un-ordered,\n"
                             + "but it will be transformed as an unique and un-ordered!")
        }
        val variableName = variableName(object, attribute)
        if (attribute.getEType instanceof EEnum)
        {
            val enumType = attribute.getEType as EEnum
            val noOfLiterals = enumType.getELiterals.size
            val bitwidth = MathUtilsExtensions.bitwidth(noOfLiterals)
            val enumVariable = newBitvector(variableName, bitwidth)
            instance.assertions += newLessEqualsExpression
            (
                enumVariable.variableExpression,
                (noOfLiterals-1).constIntegerExpression(bitwidth)
            )
            return enumVariable
        }
        else
        {
            if (attribute.getEType.name.typeFlag == "bool")
            {
                if (   attribute.lowerBound == 1
                    && attribute.upperBound == 1)
                {
                    return newPredicate(variableName)
                }
                else
                {
                    System.err.println("The attribute \""+attribute.name+"\" is not"
                        + " a fixed attribute, i.e. the lowerBound or the upperbound"
                        + " is not equal to 1. "
                    )
                    return variableName.newBitvector(2)
                }
            }
            if (attribute.getEType.name.typeFlag == "int")
            {
                if(attribute.upperBound != 1)
                {
                    return newBitvector(variableName, intSetBitwidth)
                }
                else
                {
                    return newBitvector(variableName, intBitwidth)
                }
            }
            if (attribute.getEType.name.typeFlag == "string")
            {
                // for this case we need "StateResource state" as parameter 
                throw new Exception ("Strings are currently not supported")
            }
        }
    }

    /**
     * @brief Creates a new Variable object for a given attribute
     * 
     * @param state The corresponding StateResource
     * @param object The corresponding StateObject 
     * @param attribute The EAttribute for which a variable should be instantiated 
     */
    static private def Variable variableForReference
    (
        StateResource state,
        StateObject object,
        EReference reference
    )
    {
        if ( (!reference.unique) || reference.ordered )
        {
            System.err.println("WARNING: in AttributesExtensions::variableForReference\n"
                             + "The reference "+reference.name+" is not unique and un-ordered, but it will be\n"
                             + "transformed as an unique and un-ordered set!")
        }
        val variableName = variableName(object, reference)
        val noOfCounterpartObjects = state.allObjectsOfType(reference.getEReferenceType).length
        return newBitvector(variableName, noOfCounterpartObjects)
    }

    /**
     * Computes the expression for an attribute value based on the type
     */
    def private static newAttributeValueExpression
    (
        StateObject object,
        EAttribute attribute,
        Variable variable
    )
    {
        if (attribute.getEType.name.typeFlag == "bool")
            return newConstBooleanExpression(object.eGet(attribute) as Boolean)
        if (attribute.getEType.name.typeFlag == "int")
        {
            if (attribute.many)
            {
                if (attribute.isSet)
                {
                    var bitstring = constString("0",intSetBitwidth)
                    val values = object.eGet(attribute) as List
                    val valuesIt = values.iterator
                    while (valuesIt.hasNext)
                    {
                        val int value = valuesIt.next as Integer
                        bitstring = bitstring.replaceCharAt("1",value)
                    }
                    bitstring = bitstring.reverse
                    return bitstring.newBitstringExpression
                }
                throw new UnsupportedOperationException
            }
            else
            {
                return newConstIntegerExpression
                (
                    object.eGet(attribute) as Integer,
                    (variable as Bitvector).width
                )
            }
        }
        if (attribute.getEType.name.typeFlag == "string")
        {
            // for this case we need "StateResource state" as parameter 
            throw new Exception ("Strings are currently not supported")
        }
    }

    static def void encodeAttributesForObject
    (
        Instance instance,
        StateResource state,
        StateObject object
    )
    {
        val objectName = object.name
        object.allAttributes.forEach[ attribute |
            val variable = instance.variableForAttribute
            (
                state,
                object,
                attribute
            )
            instance.addVariable(variable)
            val varExpr = variable.variableExpression

            val flagValue = attribute.checkForMFflag("groundSettingProperty")

            if (   flagValue.present
                && flagValue.get.toLowerCase.equals(("true")) )
            {
                print("")
                val constExpr = instance.encodeValueForFixedEAttribute
                (
                    state,
                    object,
                    attribute
                )
                instance.addAssertion
                (
                    newEqualsExpression
                    (
                        varExpr,
                        constExpr
                    )
               )
            }
            else
            {
                // Force values to false or 0 if the object is not existing (corresponding alpha bit = 0)
                if (useAlpha)
                {
                    val rhs = newEqualsExpression
                    (
                        variableExpression(variable),
                        if (attribute.getEType instanceof EEnum)
                        {
                            val noOfLiterals = (attribute.getEType as EEnum).getELiterals.size
                            val bitwidth = MathUtilsExtensions.bitwidth(noOfLiterals)
                            if (attribute.upperBound == 1)
                            {
                                0.newConstIntegerExpression(bitwidth)
                            }
                            else
                            {
                                0.newConstIntegerExpression(noOfLiterals)
                            }
                        }
                        else if (attribute.getEType instanceof EDataType)
                        {
                            if (attribute.getEType.name.typeFlag == "bool")
                            {
                               newConstBooleanExpression(false)
                            }
                            else // if (attribute.EType.name.typeFlag == "int"))
                            {
                               if (attribute.upperBound != 1) {
                                   0.newConstIntegerExpression(intSetBitwidth)
                               } else {
                                   0.newConstIntegerExpression(intBitwidth)
                               }
                            }
                        }
                        else
                        {
                            throw new Exception("Sollte nicht vorkommen")
                        }
                   )
                   instance.addAssertion
                   (
                       instance.encodeAlpha
                       (
                           objectName,
                           rhs,
                           '0'
                       )
                   )
                   instance.assertions.last.name = "alpha-constraint-for-attr"
                }
                if (object.eIsSet(attribute))
                {
                    instance.addAssertion
                    (
                         newEqualsExpression
                         (
                             varExpr,
                             newAttributeValueExpression
                             (
                                 object,
                                 attribute,
                                 variable
                             )
                         )
                     )
                     instance.assertions.last.name = "fixed-value-constraint-for-attr"
                }
            }
        ]
        object.allReferences.forEach[ reference |
            val variable = variableForReference(
                state,
                object,
                reference
            )
            instance.addVariable(variable)
            val varExpr = variable.variableExpression

            val flagValue = reference.checkForMFflag("groundSettingProperty")

            if (flagValue.present)
            {
                print("")
                val constExpr = instance.encodeValueForFixedEReference
                (
                    state,
                    object,
                    reference
                )
                instance.addAssertion
                (
                    newEqualsExpression
                    (
                        varExpr,
                        constExpr
                    )
               )
            }
            else
            {
                val List<Expression> constraints = instance.constraintsForReference
                (
                    state,
                    object,
                    reference,
                    variable
                )
                // Force values to false or 0 if the object is not exists (corresponding alpha bit = 0)
                if (useAlpha)
                {
                    val noOfCounterpartObjects = state.allObjectsOfType(reference.getEReferenceType).length
                    val rhs = newEqualsExpression
                    (
                         varExpr,
                         newConstIntegerExpression(0,noOfCounterpartObjects)
                    )
                    instance.addAssertion
                    (
                        instance.encodeAlpha
                        (
                            objectName,
                            rhs,
                            '0'
                        )
                    )
                    instance.assertions.last.name = "alpha-constraint-for-ref"
                }
                if (constraints.length > 0)
                {
                    instance.addAssertion(newAndExpression(constraints))
                    instance.assertions.last.name
                        = (reference.eContainer as EClass).name + "%"+ reference.name
                }
            }
        ]
    }

    def public static ConstExpression encodeValueForFixedEAttribute
    (
        Instance instance,
        StateResource state,
        StateObject sObject,
        EAttribute eAttr
    )
    {
        val value =  sObject.eGet(eAttr)
        if (value == null)
        {
            throw new UnsupportedOperationException("Null is an invalid value for a fixed EAttribute!")
        }
        if (eAttr.getEType instanceof EEnum)
        {
            val noOfLiterals = (eAttr.getEType as EEnum).getELiterals.size
            val bitwidth = MathUtilsExtensions.bitwidth(noOfLiterals)
            if (eAttr.many)
            {
                if (eAttr.set)
                {
                    // TODO
                }
                else
                {
                    throw new UnsupportedOperationException("The only supported collection type is set.")
                }
            }
            else
            {
                // TODO
            }
        }
        else if (eAttr.getEType instanceof EDataType)
        {
            val typeString = eAttr.getEType.name.typeFlag
            if (typeString.equals("bool"))
            {
                if (eAttr.many)
                {
                    if (eAttr.set)
                    {
                        if (value instanceof EList)
                        {
                            var String bitstring = "0".constString(intSetBitwidth)
                            val valuesIt = value.iterator
                            while (valuesIt.hasNext)
                            {
                                val cValue = valuesIt.next as Boolean
                                if (cValue == false)
                                {
                                    bitstring = bitstring.replaceCharAt("1",0)
                                }
                                else // if (cValue == true)
                                {
                                    bitstring = bitstring.replaceCharAt("1",1)
                                }
                            }
                            return bitstring.reverse.newBitstringExpression as BitstringExpression
                        }
                        else
                        {
                            throw new UnsupportedOperationException
                            (
                                "The value of an EAttribute set must be an EList"
                            )
                        }
                    }
                    else
                    {
                        throw new UnsupportedOperationException("The only supported collection type is set.")
                    }
                }
                else
                {
                    if (value instanceof Boolean)
                    {
                        return value.newConstBooleanExpression as ConstBooleanExpression
                    }
                }
            }
            else if (typeString.equals("int"))
            {
                if (eAttr.many)
                {
                    if (eAttr.set)
                    {
                        if (value instanceof EList)
                        {
                            var String bitstring = "0".constString(intSetBitwidth)
                            val valuesIt = value.iterator
                            while (valuesIt.hasNext)
                            {
                                val cValue = valuesIt.next as Integer
                                bitstring = bitstring.replaceCharAt("1",cValue)
                            }
                            return bitstring.reverse.newBitstringExpression as BitstringExpression
                        }
                        else
                        {
                            throw new UnsupportedOperationException
                            (
                                "The value of an EAttribute set must be an EList"
                            )
                        }
                    }
                    else
                    {
                        throw new UnsupportedOperationException("The only supported collection type is set.")
                    }
                }
                else
                {
                    if (value instanceof Integer)
                    {
                        return value.newConstIntegerExpression(intBitwidth) as ConstIntegerExpression
                    }
                }
            }
            else
            {
                throw new UnsupportedOperationException
            }
        }
        throw new UnsupportedOperationException("The EAttribute is neither an EEnum nor an EDataType (EBoolean or EInt).")
    }

    def public static ConstExpression encodeValueForFixedEReference
    (
        Instance instance,
        StateResource state,
        StateObject sObject,
        EReference eRef
    )
    {
        val posObjects = state.contents.filter[eRef.getEReferenceType.isSuperTypeOf(it.eClass)]
        val resultWidth = posObjects.length()
        var String bitstring = constString("0",resultWidth)
        val value =  sObject.eGet(eRef)
        if (value == null)
        {
            return bitstring.newBitstringExpression as BitstringExpression
        }
        else if (value instanceof EObject)
        {
            val indexOfEObject = StateSequenceGenerator::indexOf(posObjects, value)
            return bitstring.replaceCharAt("1", indexOfEObject)
                            .reverse
                            .newBitstringExpression as BitstringExpression
        }
        else if (value instanceof EList)
        {
            val valuesIt = value.iterator
            while (valuesIt.hasNext)
            {
                val cValue = valuesIt.next
                val indexOfEObject = StateSequenceGenerator::indexOf(posObjects, cValue)
                bitstring = bitstring.replaceCharAt("1",indexOfEObject)
            }
            return bitstring.reverse.newBitstringExpression as BitstringExpression
        }
        throw new UnsupportedOperationException("Unknown value type for EReference.")
    }
}
