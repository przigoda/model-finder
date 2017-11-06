package de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.utils

import de.agra.emf.metamodels.SMTlib2extended.Expression
import de.agra.emf.metamodels.SMTlib2extended.Instance
import de.agra.emf.metamodels.SMTlib2extended.VariableExpression
import de.agra.emf.modelfinder.encoding.PlaceholderExpression
import de.agra.emf.modelfinder.statesequence.state.StateObject
import de.agra.emf.modelfinder.statesequence.state.StateResource
import java.util.Map
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EOperation
import org.eclipse.emf.ecore.EParameter
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.ocl.ecore.PrimitiveType
import org.eclipse.ocl.expressions.AssociationClassCallExp
import org.eclipse.ocl.expressions.BooleanLiteralExp
import org.eclipse.ocl.expressions.CallExp
import org.eclipse.ocl.expressions.CollectionItem
import org.eclipse.ocl.expressions.CollectionLiteralExp
import org.eclipse.ocl.expressions.EnumLiteralExp
import org.eclipse.ocl.expressions.FeatureCallExp
import org.eclipse.ocl.expressions.IfExp
import org.eclipse.ocl.expressions.IntegerLiteralExp
import org.eclipse.ocl.expressions.InvalidLiteralExp
import org.eclipse.ocl.expressions.IterateExp
import org.eclipse.ocl.expressions.IteratorExp
import org.eclipse.ocl.expressions.LetExp
import org.eclipse.ocl.expressions.LiteralExp
import org.eclipse.ocl.expressions.LoopExp
import org.eclipse.ocl.expressions.MessageExp
import org.eclipse.ocl.expressions.NavigationCallExp
import org.eclipse.ocl.expressions.NullLiteralExp
import org.eclipse.ocl.expressions.NumericLiteralExp
import org.eclipse.ocl.expressions.OCLExpression
import org.eclipse.ocl.expressions.OperationCallExp
import org.eclipse.ocl.expressions.PrimitiveLiteralExp
import org.eclipse.ocl.expressions.PropertyCallExp
import org.eclipse.ocl.expressions.RealLiteralExp
import org.eclipse.ocl.expressions.StateExp
import org.eclipse.ocl.expressions.StringLiteralExp
import org.eclipse.ocl.expressions.TupleLiteralExp
import org.eclipse.ocl.expressions.TypeExp
import org.eclipse.ocl.expressions.UnspecifiedValueExp
import org.eclipse.ocl.expressions.Variable
import org.eclipse.ocl.expressions.VariableExp
import org.eclipse.ocl.types.SetType

import static de.agra.emf.modelfinder.encoding.LoadParametersExtensions.*

import static de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.utils.IteratorExpressionsExtensions.*
import static de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.utils.PlaceholderExtensions.*
import static de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.utils.PropertyCallExpressionsExtensions.*

import static extension de.agra.emf.metamodels.SMTlib2extended.util.MetaModelExtensions.*
import static extension de.agra.emf.modelfinder.statesequence.utils.EcoreExtensions.*

class ExpressionsExtensions {

    static def Expression encodeExpression
    (
        Instance instance,
        StateResource state,
        OCLExpression<?> expression,
        Map<String, EObject> varmap
    )
    {
        // beware of the following order!
        /*
Interface PrimitiveLiteralExp

All Known Subinterfaces:
    BooleanLiteralExp, IntegerLiteralExp, NumericLiteralExp, RealLiteralExp, StringLiteralExp

All Known Implementing Classes:
    BooleanLiteralExpImpl, IntegerLiteralExpImpl, NumericLiteralExpImpl, PrimitiveLiteralExpImpl, RealLiteralExpImpl, StringLiteralExpImpl 

*/
        switch (expression) {
            AssociationClassCallExp<?,?>:
                throw new Exception (errorCase("AssociationClassCallExp<?,?>"))
            PropertyCallExp<?,?>:{
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
                return encodePropertyCallExp(
                    instance,state,castedExpression,varmap
                )
            }
            NavigationCallExp<?,?>:
                throw new Exception (errorCase("NavigationCallExp<?,?>"))
            OperationCallExp<?,?>:{
                val castedExpression = 
                try
                {
                    expression as OperationCallExp<?,EOperation>
                }
                catch (ClassCastException e)
                {
                    println(e.message)
                    throw new ClassCastException(
                          "Found OperationCallExp<?,?> which could not be cast to "
                        + "OperationCallExp<?,EOperation>\n"
                        + e.message)
                }
                return encodeOperationCallExp(
                    instance,state,castedExpression,varmap
                )
            }
            /*
Interface FeatureCallExp

All Superinterfaces:
    CallExp, ...

All Known Subinterfaces:
    AssociationClassCallExp, NavigationCallExp, OperationCallExp, PropertyCallExp

All Known Implementing Classes:
    AssociationClassCallExpImpl, NavigationCallExpImpl, OperationCallExpImpl, PropertyCallExpImpl,
    FeatureCallExpImpl 
                 */
            BooleanLiteralExp<?>:
                return encodeBooleanLiteralExp(instance,state,expression,varmap)
            FeatureCallExp<?>:
                throw new Exception (errorCase("FeatureCallExp<?>"))
            IterateExp<?,?>:
                throw new Exception (errorCase("IterateExp<?,?>"))
            IteratorExp<?,?>:
                // refer to special handler
                return encodeIteratorExpression(instance, state, expression, varmap)
            LoopExp<?,?>:
                throw new Exception (errorCase("LoopExp<?,?>"))
/*
Interface CallExp

All Known Subinterfaces:
    AssociationClassCallExp, FeatureCallExp, IterateExp, IteratorExp, LoopExp, NavigationCallExp, OperationCallExp, PropertyCallExp

All Known Implementing Classes:
    AssociationClassCallExpImpl, CallExpImpl, FeatureCallExpImpl, IterateExpImpl, IteratorExpImpl, LoopExpImpl, NavigationCallExpImpl, OperationCallExpImpl, PropertyCallExpImpl


 */
            CallExp<?>:
                throw new Exception (errorCase("CallExp<?>"))
            CollectionLiteralExp:
                encodeCollectionLiteralExp(instance,state,expression,varmap)
            EnumLiteralExp<?,?>:
                encodeEnumLiteralExp(instance,state,expression)
            IfExp<?>:
                return encodeIfExp(instance,state,expression,varmap)
            InvalidLiteralExp<?>:
                throw new Exception (errorCase("InvalidLiteralExp<?>"))
            LetExp<?,?>:
                return encodeLetExp(instance,state,expression,varmap)
            NullLiteralExp<?>:
                throw new Exception (errorCase("NullLiteralExp<?>"))
            IntegerLiteralExp<?>:
                return encodeIntegerLiteralExp(instance, state, expression, varmap)
            RealLiteralExp<?>:
                throw new Exception (errorCase("RealLiteralExp<?>"))
/*
Interface NumericLiteralExp

All Known Subinterfaces:
    IntegerLiteralExp, RealLiteralExp

All Known Implementing Classes:
    IntegerLiteralExpImpl, NumericLiteralExpImpl, RealLiteralExpImpl 
 */
            NumericLiteralExp<?>:
                throw new Exception (errorCase("NumericLiteralExp<?>"))
            StringLiteralExp<?>:
                throw new Exception (errorCase("StringLiteralExp<?>"))
            PrimitiveLiteralExp<?>:
                throw new Exception (errorCase("PrimitiveLiteralExp<?>"))
            TupleLiteralExp<?,?>:
                throw new Exception (errorCase("TupleLiteralExp<?,?>"))
            LiteralExp<?>:
                throw new Exception (errorCase("LiteralExp<?>"))
            MessageExp<?,?,?>:
                throw new Exception (errorCase("MessageExp<?,?,?>"))
            StateExp<?,?>:
                throw new Exception (errorCase("StateExp<?,?>"))
            TypeExp<?>:
                throw new Exception (errorCase("TypeExp<?>"))
            UnspecifiedValueExp<?>:
                throw new Exception (errorCase("UnspecifiedValueExp<?>"))
            VariableExp<?,?>:
                encodeVariableExp(instance,state,expression,varmap)
        }
    }

    static private def Expression encodeEnumLiteralExp
    (
        Instance instance,
        StateResource state,
        EnumLiteralExp<?,?> expression
    )
    {
        EnumLiteralExtensions.encodeEnumLiteral
        (
            instance,
            state,
            expression
        )
    }

    static private def String errorCase(String className)
    {
        "Error in ExpressionsExtensions::encodeExpression :\n" + className + " not implemented"
    }

    static private def Expression encodeIntegerLiteralExp
    (
        Instance instance,
        StateResource state,
        IntegerLiteralExp<?> expression,
        Map<String, EObject> varmap
    )
    {
        newConstIntegerExpression(
            expression.integerSymbol,
            intBitwidth
        )
    }

    static private def Expression encodeCollectionLiteralExp
    (
        Instance instance,
        StateResource state,
        CollectionLiteralExp expression,
        Map<String, EObject> varmap
    )
    {
        val kind = expression.kind
        val part = expression.part

        if (part.length == 2)
        {
            // dirty quick hack only for emergency car scenario
            val part0OCL = (part.get(0) as CollectionItem).item
            val part0Expr = instance.encodeExpression
            (
                state,
                part0OCL,
                varmap
            )
            val part1OCL = (part.get(1) as CollectionItem).item
            val part1Expr = instance.encodeExpression
            (
                state,
                part1OCL,
                varmap
            )
            return part0Expr.newBvOrExpression(part1Expr)
        }
        if (part.length != 1)
        {
            throw new UnsupportedOperationException("ExpressionsExtensions::encodeCollectionLiteralExp: case CollectionLiteralExp \n"
                + "part.length = "+part.length+" != 1 is not supported so far.")
        }
        val partElem = part.head as CollectionItem
        val splitName = partElem.toString.split("\\.")
        if (splitName.length == 0)
        {
            throw new Exception("ExpressionsExtensions::encodeCollectionLiteralExp:\n"
                + "splitName can not be empty")
        }
        if (splitName.length == 1)
        {
            val partElemItem = partElem.item
            switch (partElemItem) {
                BooleanLiteralExp: {
                    val booleanValue = partElemItem.booleanSymbol
                    if (booleanValue)
                    {
                        return newBitstringExpression("00010000")
                    }
                    else
                    {
                        return newBitstringExpression("00000001")
                    }
                }
                VariableExp: {
                    return encodeExpression(instance, state, partElemItem, varmap)
                }
                default:{
                    throw new Exception("YEAH! Found an example with (splitName.length == 1)! I was not able to construct one!")
                }
            }
        }
        val headName = splitName.get(0)
        if (splitName.length == 2)
        {
            val headBelongsTo = varmap.get(headName) as StateObject
            val referenceVarExpr = instance.getVariableExpression(headBelongsTo.name+"::"+splitName.get(1)) as VariableExpression
            return referenceVarExpr
        }
        if (splitName.length > 2)
        {
            val partElemItem = partElem.item
            println(partElemItem)
            throw new UnsupportedOperationException("ExpressionsExtensions::encodeCollectionLiteralExp \n"
                + "(splitName.length > 2), i.e. nested references calling.\n"
                + "Please rewrite this by using collectNested( r1 | r1.nextRef)->flatten or something similar.")
        }
        
        println("debug")
        val type = expression.type
        switch (type) {
            SetType:{
                val internalType = type.elementType
                switch (internalType) {
                    EClass:{
                        println("debug")
                        // bitstring mit allen gesetzen Bits der Refs
                    }
                    default:{
                        throw new UnsupportedOperationException("TODO")
                    }
                }
                println("type = " + type.toString)
            }
            default:{
                throw new UnsupportedOperationException("ExpressionsExtensions::encodeCollectionLiteralExp: default case\n"
                    + "type is an instance of "+type.class)
            }
        }
        println("debug")
        null
    }

    static private def Expression encodeOperationCallExp
    (
        Instance instance,
        StateResource state,
        OperationCallExp<?,EOperation> expression,
        Map<String, EObject> varmap
    )
    {
        // refer to special handler
        OperationCallExpressionsExtensions.encodeOperationCallExpression(
            instance,
            state,
            expression,
            varmap
        )
    }

    static private def Expression encodePropertyCallExp
    (
        Instance instance,
        StateResource state,
        PropertyCallExp<?,EStructuralFeature> expression,
        Map<String, EObject> varmap
    )
    {
        val StateResource nstate = chooseState(expression,state)
        //for Self
        val sourceState =
            if (expression.source instanceof VariableExp)
                nstate
            else
                state
        //for Self
//        val sourceVarmap =
//            if (expression.source instanceof VariableExp)
//                nvarmap
//            else
//                varmap
        val sourceExpr = encodeExpression
        (
            instance,
            sourceState,
            expression.source, // get property's source
            varmap
        )
        val EStructuralFeature property = expression.referredProperty
        PropertyCallExpressionsExtensions.encodePropertyCallExpression
        (
            instance,
            nstate,
            property,
            expression,
            sourceExpr
        )
    }

    static private def Expression encodeParameter
    (
        Instance instance,
        StateResource state,
        EParameter parameter,
        Map<String, EObject> varmap,
        PlaceholderExpression placeholder
    )
    {
        if (!(   parameter.lowerBound == 1
              && parameter.upperBound == 1))
        {
            System.err.println("A parameter with a bounds != 1 has been detected, this can cause a strange behaviour!")
        }
        val paramTypeName = parameter.getEType.name
        val paramVarExpr = instance.getVariableExpression(placeholder.attributeString)
        switch (paramTypeName) {
            case "EBoolean":{
                return paramVarExpr
            }
            case "EInt":{
                return paramVarExpr
            }
            default: {
                val paramType = parameter.getEType as EClass
                val objects  = state.allObjectsOfType(paramType)
                // a bit-width for the const integer
                val bitWidth = objects.length
                if (bitWidth  < 1)
                {
                    throw new Exception("there are no objects for the parameter available")
                }
                if (bitWidth == 1)
                {
                    return new PlaceholderExpression(objects.get(0))
                }
                var Expression iteFieldExpr = newIteExpression(
                    newEqualsExpression(
                        newExtractIndexExpression(
                            paramVarExpr,
                            bitWidth-2
                        ),
                        newBitstringExpression("1")
                    ),
                    new PlaceholderExpression(objects.get(bitWidth-2)),
                    new PlaceholderExpression(objects.get(bitWidth-1))
                )
                for( var index = bitWidth-3; index >= 0; index--)
                {
                    iteFieldExpr = newIteExpression(
                        newEqualsExpression(
                            newExtractIndexExpression(
                                paramVarExpr,
                                index
                            ),
                            newBitstringExpression("1")
                        ),
                        new PlaceholderExpression(objects.get(index)),
                        iteFieldExpr
                    )
                }
                return iteFieldExpr
            }
        }
    }

    static private def Expression encodeVariableExp
    (
        Instance instance,
        StateResource state,
        VariableExp<?,?> expression,
        Map<String, EObject> varmap
    )
    {
        // get the referred variable
        val Variable<?,?> variable = expression.referredVariable
        // and the object it is pointing to
        val object = varmap.get(variable.name)
        switch (object) {
            PlaceholderExpression:{
                val eObject = object.object
                switch (eObject) {
                    EParameter:{
                        return encodeParameter
                        (
                            instance,
                            state,
                            eObject,
                            varmap,
                            object
                        )
                    }
                    default:{
                        return object
                    }
                }
            }
            Expression:
                return object
            StateObject:{
                // TODO check this: count only instantiations of the class of the variable
                // all objects of the state
                switch(variable.type) {
                    EClass:{
                        val eClass = variable.type as EClass
                        val objects  = state.allObjectsOfType(eClass)
                        // a bit-width for the const integer
                        val bitWidth = objects.length
                        // index over all objects
                        val splitObject = object.name.split("::")
                        val newObject = 
                        if(state.allObjects.findFirst[true].name.split("::").get(1) != splitObject.get(1)) {
                            state.allObjects.findFirst[
                                it.name.split("::").get(2) == splitObject.get(2) 
                            ]
                        }
                        else
                            object
                        splitObject.set
                        (
                            1,
                            state.allObjects.findFirst[true].name.split("::").get(1)
                        )
                        val objectNameSplit = splitObject.get(2).split("@")
                        val index = Integer::parseInt( objectNameSplit.get(1) )
                        return newPlaceholderExpression(
                            newObject,
                            index,
                            bitWidth
                        )
                    }
                    PrimitiveType:{
                        // TODO
                        newVariableExpression(
                            newVariable("TurnIndicator::state1::Flash_Ctrl@0::setTil_param_l")
                        )
                    }
                }
            }
            BooleanLiteralExp:{
                instance.encodeExpression
                (
                    state,
                    object,
                    varmap
                )
            }
            IntegerLiteralExp:{
                instance.encodeExpression
                (
                    state,
                    object,
                    varmap
                )
            }
            default:{
                throw new Exception("encodeVariableExp on a neither Expression nor StateObject object")
            }
        }
    }


//    static private def Expression encodeVariableExp
//    (
//        Instance instance,
//        StateResource state,
//        VariableExp<?,?> expression,
//        Map<String, EObject> varmap
//    )
//    {
//        // get the referred variable
//        val Variable<?,?> variable = expression.referredVariable
//        // and the object it is pointing to
//        val object = varmap.get(variable.name)
//        switch (object) {
//            PlaceholderExpression:{
//                val eObject = object.object
//                switch (eObject) {
//                    EParameter:{
//                        // only for
//                        if (!(   eObject.lowerBound == 1
//                              && eObject.upperBound == 1))
//                        {
//                            System.err.println("A parameter with a bounds != 1 has been detected, this can cause a strange behaviour!")
//                        }
//                        val paramType = eObject.EType as EClassifier
//                        val objects  = state.allObjectsOfType(paramType as EClass)
//                        // a bit-width for the const integer
//                        val bitWidth = objects.length
//                        val paramVarExpr = instance.getVariableExpression(object.attributeString)
//                        var Expression iteFieldExpr = newIteExpression(
//                            newEqualsExpression(
//                                newExtractIndexExpression(
//                                    paramVarExpr,
//                                    bitWidth-2
//                                ),
//                                newBitstringExpression("1")
//                            ),
//                            new PlaceholderExpression(objects.get(bitWidth-2)),
//                            new PlaceholderExpression(objects.get(bitWidth-1))
//                        )
//                        for( var index = bitWidth-3; index >= 0; index--)
//                        {
//                            iteFieldExpr = newIteExpression(
//                                newEqualsExpression(
//                                    newExtractIndexExpression(
//                                        paramVarExpr,
//                                        index
//                                    ),
//                                    newBitstringExpression("1")
//                                ),
//                                new PlaceholderExpression(objects.get(index)),
//                                iteFieldExpr
//                            )
//                        }
//                        return iteFieldExpr
//                    }
//                    default:{
//                        return object
//                    }
//                }
//            }
//            Expression:
//                return object
//            StateObject:{
//                // TODO check this: count only instantiations of the class of the variable
//                // all objects of the state
//                switch(variable.type) {
//                    EClass:{
//                        val eClass = variable.type as EClass
//                        val objects  = state.allObjectsOfType(eClass)
//                        // a bit-width for the const integer
//                        val bitWidth = objects.length
//                        // index over all objects
//                        val splitObject = object.name.split("::")
//                        val newObject = 
//                        if(state.allObjects.findFirst[true].name.split("::").get(1) != splitObject.get(1)) {
//                            state.allObjects.findFirst[
//                                it.name.split("::").get(2) == splitObject.get(2) 
//                            ]
//                        }
//                        else
//                            object
//                        splitObject.set
//                        (
//                            1,
//                            state.allObjects.findFirst[true].name.split("::").get(1)
//                        )
//                        val objectNameSplit = splitObject.get(2).split("@")
//                        val index = Integer::parseInt( objectNameSplit.get(1) )
//                        return newPlaceholderExpression(
//                            newObject,
//                            index,
//                            bitWidth
//                        )
//                    }
//                    PrimitiveType:{
//                        // TODO
//                        newVariableExpression(
//                            newVariable("TurnIndicator::state1::Flash_Ctrl@0::setTil_param_l")
//                        )
//                    }
//                }
//            }
//            default:{
//                throw new Exception("encodeVariableExp on a neither Expression nor StateObject object")
//            }
//        }
//    }

    static private def Expression encodeBooleanLiteralExp
    (
        Instance instance,
        StateResource state,
        BooleanLiteralExp<?> expression,
        Map<String, EObject> varmap
    )
    {
        newConstBooleanExpression(expression.booleanSymbol)
    }

    static private def Expression encodeIfExp
    (
        Instance instance,
        StateResource state,
        IfExp<?> expression,
        Map<String, EObject> varmap
    )
    {
        // Constraint optimization is done inside newIteExpression
        return newIteExpression
        (
            instance.encodeExpression(state, expression.condition, varmap),
            instance.encodeExpression(state, expression.thenExpression, varmap),
            instance.encodeExpression(state, expression.elseExpression, varmap)
        )
    }

    static private def Expression encodeLetExp
    (
        Instance instance,
        StateResource state,
        LetExp<?,?> expression,
        Map<String, EObject> varmap
    )
    {
        println("variable = " + expression.variable)
        println("variable.name = " + expression.variable.name)
        println("variable.initExpression = " + expression.variable.initExpression)
        throw new UnsupportedOperationException("We need a concept for LetExp")
    }
}
			