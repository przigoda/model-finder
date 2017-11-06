package de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.utils

import de.agra.emf.metamodels.SMTlib2extended.Expression
import de.agra.emf.metamodels.SMTlib2extended.Instance
import de.agra.emf.metamodels.SMTlib2extended.Variable
import de.agra.emf.modelfinder.encoding.LoadParametersExtensions
import de.agra.emf.modelfinder.encoding.PlaceholderExpression
import de.agra.emf.modelfinder.statesequence.StateSequence
import de.agra.emf.modelfinder.statesequence.state.StateObject
import de.agra.emf.modelfinder.statesequence.state.StateResource
import java.util.ArrayList
import java.util.List
import java.util.Map
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.ocl.ecore.Constraint
import org.eclipse.ocl.ecore.PrimitiveType
import org.eclipse.ocl.ecore.VariableExp
import org.eclipse.ocl.expressions.CollectionLiteralExp
import org.eclipse.ocl.expressions.IteratorExp
import org.eclipse.ocl.expressions.PropertyCallExp
import org.eclipse.ocl.types.BagType
import org.eclipse.ocl.types.CollectionType
import org.eclipse.ocl.types.SetType

import static de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.utils.ExpressionsExtensions.*

import static extension de.agra.emf.metamodels.SMTlib2extended.util.MetaModelExtensions.*
import static extension de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.utils.AlphaExtensions.*
import static extension de.agra.emf.modelfinder.statesequence.utils.EcoreExtensions.*
import static extension de.agra.emf.modelfinder.utils.OCLExtensions.*
import static extension de.agra.emf.modelfinder.utils.StringUtilsExtensions.*
import de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.InstanceGeneratorImplTwoValuedOCL

class ModifyPropertiesStatementExtensions
{
    public static def Expression encodeFinalizingModifyPropertiesExpression
    (
        StateSequence sequence,
        Instance instance,
        List<Variable> variablesOfPostState,
        Variable gModifiesBV
    )
    {
        val gModifiesBVExpr = gModifiesBV.variableExpression
        val andList = factory.createAndExpression
        val state = sequence.states.head as StateResource
        val const1 = "1".newBitstringExpression

        val modelElements = sequence.modelElements;
        val modelElementsIterator = modelElements.iterator
        
        val variablesOfPostStateIterator = variablesOfPostState.iterator
        var index = 0
        while (modelElementsIterator.hasNext)
        {
            val currentModelElement = modelElementsIterator.next
            val variableInPostState = variablesOfPostStateIterator.next

            val preVarName = decStateNoInVariableName(variableInPostState.name)
            val variableInPreState = instance.getVariable(preVarName)
            val varPreExpr = variableInPreState.variableExpression
            val varPostExpr = variableInPostState.variableExpression

            // prohibit changes in all variables where the corresponding bit equals 1
            val extractEStructExpr = gModifiesBVExpr.newExtractIndexExpression(index)

            val eStruct = currentModelElement.value
            if (    eStruct instanceof EReference
                 && (eStruct as EReference).getEOpposite != null)
            {
                val currentObject = currentModelElement.key
                val EReference reference = eStruct as EReference
                val EClass referenceClass =  reference.getEReferenceType
                val referenceObjects = state.allObjectsOfType(referenceClass)
                val EReference eOpposite = reference.getEOpposite
                val EClass oppositeClass = eOpposite.getEReferenceType
                val oppositeObjects = state.allObjectsOfType(oppositeClass)
                val ownIndex = oppositeObjects.indexOf(currentObject)
                referenceObjects.forEach[ refObject, localBitIndex |
                    andList.expressions += factory.createImpliesExpression => [
                        lhs = factory.createAndExpression => [
                            if (LoadParametersExtensions.useAlpha)
                            {
                                val alphaExtractPre = instance.extractAlphaBit( variableInPreState.name )
                                val alphaExtractPost = instance.extractAlphaBit( variableInPostState.name )
                                val alphaEqExpr = alphaExtractPre.newEqualsExpression(alphaExtractPost)
                                expressions += alphaEqExpr
                            }
                            expressions += extractEStructExpr.newEqualsExpression(const1)
//                            val variableName = refObject.name + "::" + eOpposite.name
//                            val oppVarExpr = instance.getVariable(variableName).variableExpression
//                            expressions += oppVarExpr.newExtractIndexExpression(ownIndex)
//                                                     .newEqualsExpression(const1)
                            val otherModifiesIndex = calculateIndex
                            (
                                modelElements,
                                refObject,
                                eOpposite
                            )
                            expressions += gModifiesBVExpr.newExtractIndexExpression(otherModifiesIndex)
                        ]
                        val innerEq = factory.createEqualsExpression => [
                            lhs = varPreExpr.newExtractIndexExpression(localBitIndex)
                            rhs = varPostExpr.newExtractIndexExpression(localBitIndex)
                        ]
                        rhs = innerEq
                    ]
                ]
            }
            else
            {
                andList.expressions += factory.createImpliesExpression => [
                    lhs = factory.createAndExpression => [
                        if (LoadParametersExtensions.useAlpha)
                        {
                            val alphaExtractPre = instance.extractAlphaBit( variableInPreState.name )
                            val alphaExtractPost = instance.extractAlphaBit( variableInPostState.name )
                            val alphaEqExpr = alphaExtractPre.newEqualsExpression(alphaExtractPost)
                            expressions += alphaEqExpr
                        }
                        expressions += extractEStructExpr.newEqualsExpression(const1)
                    ]
                    val innerEq = factory.createEqualsExpression => [
                        lhs = varPreExpr
                        rhs = varPostExpr
                    ]
                    rhs = innerEq
                ]
            }
            index++;
        }
        return andList
    }

    private static def Integer calculateIndex
    (
        List<Pair<StateObject, EStructuralFeature>> modelElements,
        StateObject object,
        EReference reference
    )
    {
        val modelElementsIterator = modelElements.iterator
        var index = 0
        while (modelElementsIterator.hasNext)
        {
            val modelElement = modelElementsIterator.next
            if (    modelElement.key.equals(object)
                 && modelElement.value.equals(reference) )
            {
                return index
            }
            index++;
        }
        return -1
    }

    public static def Expression encodeSingleModifyPropertiesExpression
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
        val expression = modifiesConstraint.bodyExpression
        switch (expression)
        {
            PropertyCallExp<?,?>:
            {
                val castedExpression =
                    try
                    {
                        expression as PropertyCallExp<?,EStructuralFeature>
                    }
                    catch (ClassCastException e)
                    {
                        e.message
                        throw new ClassCastException(
                              "Found PropertyCallExp<?,?> which could not be cast to "
                            + "PropertyCallExp<?,EStructuralFeature>\n"
                            + e.message)
                    }
                val expressionFromSource = encodeExpression
                (
                    instance,
                    state,
                    castedExpression.source,
                    varmap
                )
                switch (castedExpression.type)
                {
                    PrimitiveType:
                    {
                        switch (castedExpression.source.type)
                        {
                            PrimitiveType:
                            {
                                
                            }
                            SetType:
                            {
                                
                            }
                            BagType:
                            {
                                
                            }
                            CollectionType:
                            {
                                
                            }
                            EClass:
                            {
                                return sequence.PrimitiveType_in_Expression_and_EClass_in_Source
                                (
                                    instance,
                                    state,
                                    variablesOfPostState,
                                    varmap,
                                    castedExpression.type as PrimitiveType,
                                    castedExpression.source.type as EClass,
                                    expressionFromSource,
                                    modifyCounter,
                                    omegaValue,
                                    omegaIndex,
                                    castedExpression.referredProperty
                                )
                            }
                        }
                    }
                    SetType:
                    {
                        switch (castedExpression.source.type)
                        {
                            PrimitiveType:
                            {
                                
                            }
                            SetType:
                            {
                                
                            }
                            BagType:
                            {
                                
                            }
                            CollectionType:
                            {
                                
                            }
                            EClass:
                            {
                                return sequence.SetType_in_Expression_and_EClass_in_Source
                                (
                                    instance,
                                    state,
                                    variablesOfPostState,
                                    varmap,
                                    castedExpression.type as SetType,
                                    castedExpression.source.type as EClass,
                                    expressionFromSource,
                                    modifyCounter,
                                    omegaValue,
                                    omegaIndex,
                                    castedExpression.referredProperty
                                )
                            }
                        }
                    }
                    BagType:
                    {
                        switch (castedExpression.source.type)
                        {
                            PrimitiveType:
                            {
                                
                            }
                            SetType:
                            {
                                
                            }
                            BagType:
                            {
                                
                            }
                            CollectionType:
                            {
                                
                            }
                            EClass:
                            {
                                sequence.BagType_in_Expression_and_EClass_in_Source
                                (
                                    instance,
                                    state,
                                    varmap,
                                    castedExpression.type as BagType,
                                    castedExpression.source.type as EClass,
                                    expressionFromSource,
                                    modifyCounter
                                )
                            }
                        }
                    }
                    CollectionType:
                    {
                        
                    }
                    EClass:
                    {
                        return sequence.EClass_in_Expression_and_EClass_in_Source
                        (
                            instance,
                            state,
                            variablesOfPostState,
                            varmap,
                            castedExpression.type as EClass,
                            castedExpression.source.type as EClass,
                            expressionFromSource,
                            modifyCounter,
                            omegaValue,
                            omegaIndex,
                            castedExpression.referredProperty
                        )
                    }
                    default:
                    {
                        throw new Exception("Unknown expression type")
                    }
                }
                null
            }
            IteratorExp:
            {
                if (expression.name == "collect")
                {
                    val source = expression.source
                    val expressionFromSource = encodeExpression
                    (
                        instance,
                        state,
                        source,
                        varmap
                    )
                    val EClass eClass = (source.type as SetType).elementType as EClass
                    val bodyExpr = expression.body
                    switch (bodyExpr) {
                        PropertyCallExp: {
                            val variable = bodyExpr.source
                            if (variable instanceof VariableExp)
                            {
                                return Collect_Property_on_Set_of_EClass_in_Source
                                (
                                    sequence,
                                    instance,
                                    state,
                                    variablesOfPostState,
                                    varmap,
                                    bodyExpr,
                                    eClass,
                                    expressionFromSource,
                                    modifyCounter,
                                    omegaValue,
                                    omegaIndex,
                                    bodyExpr.referredProperty as EStructuralFeature
                                )
                            }
                        }
                    }
//                    print( expressionFromSource + bodyExpr.toString + eClass)
                    throw new Exception("Modifies and collect are used in an illegal/unsupported way!")
                }
                throw new Exception("Modifies only does only support one IteratorExp so far, and "
                    + "this is collect. You are using: " + expression.name)
            }
            CollectionLiteralExp:
            {
                println("expression.type = " + expression.type)
                throw new UnsupportedOperationException("TODO: auto-generated method stub")
            }
            default:
            {
                println("expression.class = " + expression.class)
                println("expression.type = " + expression.type)
                throw new UnsupportedOperationException("TODO: auto-generated method stub")
            }
        }
    }
    

    static private def String errorCase(String className)
    {
        "Error in ModifiesExtensions::encodeModifyExpression :\n" + className + " not implemented"
    }

    static private def Expression EClassExpression_without_Source
    (
        
    )
    {
        
    }

    // TODO The following method should be globally available
    static def getAllVariablesOfState( String stateName, int stateNo, Instance instance)
    {
        instance.variables.filter[    it.name.contains( "::")
                                   && it.name.split("::").get(1) == stateName + stateNo]
    }

    static private def Expression EClass_in_Expression_and_EClass_in_Source
    (
        StateSequence sequence,
        Instance instance,
        StateResource state,
        List<Variable> variablesOfPostState,
        Map<String, EObject> varmap,
        EClass expresiontType,
        EClass sourceType,
        Expression expressionFromSource,
        Integer modifyCounter,
        Integer omegaValue,
        Integer omegaIndex,
        EStructuralFeature property
    )
    {
        /*
         * In this case, a reference is expected and, thus, a lot of model elements can bed affected
         * by this case. Furthermore, it has to be ensured, in case of an reference with an
         * EOpposite part, the specific parts are also changeable!
         * 
         * TODO the other end of an association should be handled by the finalizer..?
         */

        val pfcBV = factory.createBitvector => [
            name = "omega"+omegaIndex+"::"+InstanceGeneratorImplTwoValuedOCL.modifyObjectsStatementNameInSMT+"@"+omegaValue+"::part@"+modifyCounter
            width = variablesOfPostState.length
        ]
        instance.variables += pfcBV
        val pfcBVExpr = pfcBV.newVariableExpression
        val List<Expression> singleBitExprList = new ArrayList<Expression>();
        val placeExpr = expressionFromSource as PlaceholderExpression
        val objectNameSplit = ((placeExpr.object) as StateObject).name.split("::")
        variablesOfPostState.forEach[ variable, index |
            val nameSplit = variable.name.split("::")
            val extractIndex = pfcBVExpr.newExtractIndexExpression(index)
            if (nameSplit.get(3) == property.name)
            {
                if (nameSplit.get(2) == objectNameSplit.get(2))
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

        return pfcBVExpr
    }

    static private def Expression Collect_Property_on_Set_of_EClass_in_Source
    (
        StateSequence sequence,
        Instance instance,
        StateResource state,
        List<Variable> variablesOfPostState,
        Map<String, EObject> varmap,
        PropertyCallExp propExp,
        EClass sourceType,
        Expression expressionFromSource,
        Integer modifyCounter,
        Integer omegaValue,
        Integer omegaIndex,
        EStructuralFeature property
    )
    {
        val pfcBV = factory.createBitvector => [
            name = "omega"+omegaIndex+"::"+InstanceGeneratorImplTwoValuedOCL.modifyObjectsStatementNameInSMT+"@"+omegaValue+"::part@"+modifyCounter
            width = variablesOfPostState.length
        ]
        instance.variables += pfcBV
        val pfcBVExpr = pfcBV.newVariableExpression
        val List<Expression> singleBitExprList = new ArrayList<Expression>();

        val modelElements = sequence.modelElements;
        val modelElementsIterator = modelElements.iterator
        val possibleObjects = state.allObjectsOfType(sourceType)
        var index = 0
        while (modelElementsIterator.hasNext)
        {
            val extractIndex = pfcBVExpr.newExtractIndexExpression(index)

            val currentModelElement = modelElementsIterator.next

            val currentObject = currentModelElement.key
            val currentEStruct = currentModelElement.value

            if (    sourceType.isSuperTypeOf(currentObject.eClass)
                 && property.equals(currentEStruct) )
            {
                val objectNameIndex = currentObject.name.split("::").get(2)
                var localIndex = -1
                for(var int i = 0; i < possibleObjects.length; i++)
                {
                    val possibleObjectName = possibleObjects.get(i).name.split("::").get(2)
                    if (objectNameIndex == possibleObjectName)
                    {
                        localIndex = i
                        i = possibleObjects.length
                    }
                }

                val extractSetElem = expressionFromSource.newExtractIndexExpression(localIndex)
                val elemInside = extractSetElem.newEqualsExpression("1".newBitstringExpression)
                singleBitExprList +=
                    factory.createIteExpression => [
                        condition = true.newConstBooleanExpression //elemInside
                        condition = elemInside
                        thenexpr = factory.createEqualsExpression => [
                            lhs = extractIndex
                            rhs = newBitstringExpression("0")
                        ]
                        elseexpr = factory.createEqualsExpression => [
                            lhs = extractIndex
                            rhs = newBitstringExpression("1")
                        ]
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

            index++;
        }
        instance.assertions += singleBitExprList

        return pfcBVExpr
    }

    static private def Expression PrimitiveType_in_Expression_and_EClass_in_Source
    (
        StateSequence sequence,
        Instance instance,
        StateResource state,
        List<Variable> variablesOfPostState,
        Map<String, EObject> varmap,
        PrimitiveType expresiontType,
        EClass sourceType,
        Expression expressionFromSource,
        Integer modifyCounter,
        Integer omegaValue,
        Integer omegaIndex,
        EStructuralFeature property
    )
    {
        /*
         * It should be impossible, that more than one model element is affected by this case.
         * Furthermore, the specific model element must be an attribute because its type is a
         * PrimitiveType.
         */
        val pfcBV = factory.createBitvector => [
            name = "omega"+omegaIndex+"::"+InstanceGeneratorImplTwoValuedOCL.modifyObjectsStatementNameInSMT+"@"+omegaValue+"::part@"+modifyCounter
            width = variablesOfPostState.length
        ]
        instance.variables += pfcBV
        val pfcBVExpr = pfcBV.newVariableExpression
        val List<Expression> singleBitExprList = new ArrayList<Expression>();
        val placeExpr = expressionFromSource as PlaceholderExpression
        val objectNameSplit = ((placeExpr.object) as StateObject).name.split("::")
        variablesOfPostState.forEach[ variable, index |
            val nameSplit = variable.name.split("::")
            val extractIndex = pfcBVExpr.newExtractIndexExpression(index)
            if (nameSplit.get(3) == property.name)
            {
                // TODO check the naive class/superClass ensuring
                if (nameSplit.get(2) == objectNameSplit.get(2))
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

        return pfcBVExpr
    }


    static private def Expression PrimitiveType_in_Expression_and_EClass_in_Source__
    (
        StateSequence sequence,
        Instance instance,
        StateResource state,
        List<Variable> variablesOfPostState,
        Map<String, EObject> varmap,
        PrimitiveType expresiontType,
        EClass sourceType,
        Expression expressionFromSource,
        Integer modifyCounter,
        Integer omegaValue,
        Integer omegaIndex,
        EStructuralFeature property
    )
    {
        val pfcBV = factory.createBitvector => [
            name = "omega"+omegaIndex+"::"+InstanceGeneratorImplTwoValuedOCL.modifyObjectsStatementNameInSMT+"@"+omegaValue+"::part@"+modifyCounter
            width = variablesOfPostState.length
        ]
        instance.variables += pfcBV
        val pfcBVExpr = pfcBV.newVariableExpression
        val List<Expression> singleBitExprList = new ArrayList<Expression>();

        val modelElements = sequence.modelElements;
        val modelElementsIterator = modelElements.iterator
        val possibleObjects = state.allObjectsOfType(sourceType)
        var index = 0
        while (modelElementsIterator.hasNext)
        {
            val extractIndex = pfcBVExpr.newExtractIndexExpression(index)

            val currentModelElement = modelElementsIterator.next

            val currentObject = currentModelElement.key
            val currentEStruct = currentModelElement.value

            if (    sourceType.isSuperTypeOf(currentObject.eClass)
                 && property.equals(currentEStruct) )
            {
                val objectNameIndex = currentObject.name.split("::").get(2)
                var localIndex = -1
                for(var int i = 0; i < possibleObjects.length; i++)
                {
                    val possibleObjectName = possibleObjects.get(i).name.split("::").get(2)
                    if (objectNameIndex == possibleObjectName)
                    {
                        localIndex = i
                        i = possibleObjects.length
                    }
                }

                val extractSetElem = expressionFromSource.newExtractIndexExpression(localIndex)
                val elemInside = extractSetElem.newEqualsExpression("1".newBitstringExpression)
                singleBitExprList +=
                    factory.createIteExpression => [
                        condition = true.newConstBooleanExpression //elemInside
                        condition = elemInside
                        thenexpr = factory.createEqualsExpression => [
                            lhs = extractIndex
                            rhs = newBitstringExpression("0")
                        ]
                        elseexpr = factory.createEqualsExpression => [
                            lhs = extractIndex
                            rhs = newBitstringExpression("1")
                        ]
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

            index++;
        }
        instance.assertions += singleBitExprList

        return pfcBVExpr
    }



    static private def Expression SetType_in_Expression_and_EClass_in_Source
    (
        StateSequence sequence,
        Instance instance,
        StateResource state,
        List<Variable> variablesOfPostState,
        Map<String, EObject> varmap,
        SetType expresionType,
        EClass sourceType,
        Expression expressionFromSource,
        Integer modifyCounter,
        Integer omegaValue,
        Integer omegaIndex,
        EStructuralFeature property
    )
    {
        val setElementType = expresionType.elementType
        switch (setElementType)
        {
            EClass:
            {
                val pfcBV = factory.createBitvector => [
                    name = "omega"+omegaIndex+"::"+InstanceGeneratorImplTwoValuedOCL.modifyObjectsStatementNameInSMT+"@"+omegaValue+"::part@"+modifyCounter
                    width = variablesOfPostState.length
                ]
                // calculate be possible object which the source could return
                val possibleObjects =  (sequence.states.head as StateResource).allObjectsOfType(sourceType)
                val width = possibleObjects.length
                val bitstring = constString("0",width)
                instance.variables += pfcBV
                val pfcBVExpr = pfcBV.newVariableExpression
                val List<Expression> singleBitExprList = new ArrayList<Expression>();
                val modelElements = sequence.modelElements;
                (0..<variablesOfPostState.length).forEach[ index |
                    val extractIndexExpr = pfcBVExpr.newExtractIndexExpression(index)
                    val modelElement = modelElements.get(index)
                    val StateObject modelObject = modelElement.key
                    val modelStruct = modelElement.value
                    // TODO check is isSuperTypeOf is used in the right way!
                    if (    sourceType.isSuperTypeOf( modelObject.eClass )
                         && property.equals(modelStruct) )
                    {
                        singleBitExprList += factory.createEqualsExpression => [
                            lhs = extractIndexExpr
                            rhs = factory.createIteExpression => [
                                condition = factory.createEqualsExpression => [
                                    lhs = expressionFromSource
                                    // calculate the index of the modelObject in
                                    val indexOfModelObject = possibleObjects.indexOf(modelObject)
                                    rhs = bitstring.replaceCharAt("1", indexOfModelObject)
                                                   .reverse.newBitstringExpression
                                ]
                                thenexpr = newBitstringExpression("0")
                                elseexpr = newBitstringExpression("1")
                            ]
                        ]
                    }
                    else
                    {
                        singleBitExprList +=
                            factory.createEqualsExpression => [
                                lhs = extractIndexExpr
                                rhs = newBitstringExpression("1")
                            ]
                    }
                ]
                instance.assertions += singleBitExprList.newAndExpression
                return pfcBVExpr
            }
            PrimitiveType:
            {
                return sequence.PrimitiveType_in_Expression_and_EClass_in_Source__
                (
                    instance,
                    state,
                    variablesOfPostState,
                    varmap,
                    setElementType as PrimitiveType,
                    sourceType,
                    expressionFromSource,
                    modifyCounter,
                    omegaValue,
                    omegaIndex,
                    property
                )
            }
            default:
            {
                println("TODO black magic and voodoo are missing")
                throw new Exception("Congratulations")
            }
        }
    }

    static private def Expression BagType_in_Expression_and_EClass_in_Source
    (
        StateSequence sequence,
        Instance instance,
        StateResource state,
        Map<String, EObject> varmap,
        BagType expresiontType,
        EClass sourceType,
        Expression expressionFromSource,
        Integer modifyCounter
    )
    {
        println("todo black magic")
        null
    }
}
