package de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.utils

import de.agra.emf.metamodels.SMTlib2extended.BitstringExpression
import de.agra.emf.metamodels.SMTlib2extended.Expression
import de.agra.emf.metamodels.SMTlib2extended.Instance
import de.agra.emf.metamodels.SMTlib2extended.VariableExpression
import de.agra.emf.modelfinder.encoding.LoadParametersExtensions
import de.agra.emf.modelfinder.encoding.PlaceholderExpression
import de.agra.emf.modelfinder.statesequence.state.StateResource
import java.util.ArrayList
import java.util.HashMap
import java.util.List
import java.util.Map
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.ocl.ecore.CollectionType
import org.eclipse.ocl.ecore.PrimitiveType
import org.eclipse.ocl.expressions.IteratorExp
import org.eclipse.ocl.expressions.Variable
import org.eclipse.ocl.expressions.impl.ExpressionsFactoryImpl
import org.eclipse.ocl.types.BagType
import org.eclipse.ocl.types.OrderedSetType
import org.eclipse.ocl.types.SequenceType
import org.eclipse.ocl.types.SetType

import static de.agra.emf.modelfinder.encoding.LoadParametersExtensions.*

import static extension de.agra.emf.metamodels.SMTlib2extended.util.MetaModelExtensions.*
import static extension de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.utils.AlphaExtensions.*
import static extension de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.utils.ExpressionsExtensions.*
import static extension de.agra.emf.modelfinder.statesequence.utils.EcoreExtensions.*
import static extension de.agra.emf.modelfinder.utils.StringUtilsExtensions.*

class IteratorExpressionsExtensions {

    private static var int collectNumber = 0
    private static var int collectorHelperNumber = 0

    static def Expression encodeIteratorExpression
    (
        Instance instance,
        StateResource state,
        IteratorExp expression,
        Map<String, EObject> varmap
    )
    {
        // encode source operation
        val source = encodeExpression
        (
            instance,
            state,
            expression.source,
            varmap
        )
        // get source set element type
        // possible types are: SetType, OrderedSetType
        val setElementType = (expression.source.type as CollectionType).getElementType
        if (setElementType instanceof PrimitiveType)
        {
            instance.encodeIteratorForPrimitiveType
            (
                state,
                expression,
                varmap,
                source,
                setElementType
            )
        }
        else if (setElementType instanceof EClass)
        {
            instance.encodeIteratorForEClass
            (
                state,
                expression,
                varmap,
                source,
                setElementType
            )
        }
        else if (setElementType instanceof CollectionType)
        {
            throw new UnsupportedOperationException
        }
    }

    def private static encodeIteratorForPrimitiveType
    (
        Instance instance,
        StateResource state,
        IteratorExp expression,
        Map<String, EObject> varmap,
        Expression source,
        PrimitiveType setElementType
    )
    {
        // for each object
        val List<Expression> sourceExpressions = new ArrayList<Expression>();
        val List<String> sourcePropertyVarNames = new ArrayList<String>();
        val List<Expression> bodyExpressions = new ArrayList<Expression>();
        val loopVarName = (expression.iterator.get(0) as Variable).getName

        val objects = new ArrayList<EObject>
        // Check the real primitive type using name
        if (setElementType.name.equals("Boolean"))
        {
            val factory = ExpressionsFactoryImpl::eINSTANCE
            if (source instanceof BitstringExpression)
            {
                if (source.value.substring(0,1).equals("1"))
                {
                    objects += factory.createBooleanLiteralExp => [
                        booleanSymbol = false
                    ]
                }
                if (source.value.substring(1,2).equals("1"))
                {
                    objects += factory.createBooleanLiteralExp => [
                        booleanSymbol = true
                    ]
                }
            }
            else
            {
                objects += factory.createBooleanLiteralExp => [
                    booleanSymbol = false
                ]
                objects += factory.createBooleanLiteralExp => [
                    booleanSymbol = true
                ]
            }
        }
        if (setElementType.name.equals("Integer"))
        {
            val factory = ExpressionsFactoryImpl::eINSTANCE
            if (source instanceof BitstringExpression)
            {
                source.value.reverse.toCharArray.forEach[ c, index |
                    if (c.toString.equals("1"))
                    {
                        objects += factory.createIntegerLiteralExp => [
                            integerSymbol = index
                        ]
                    }
                ]
            }
            else
            {
                val intMax = Math.pow(2, LoadParametersExtensions.intBitwidth) as int
                (0..<intMax).forEach[ index |
                    objects += factory.createIntegerLiteralExp => [
                        integerSymbol = index
                    ]
                ]
            }
        }
        // loop variable name TODO there can be more than just one iterator

        val Map<String, EObject> nvarmap = new HashMap<String,EObject>
        nvarmap.putAll(varmap)
        nvarmap.put
        (
            loopVarName,
            null
        )
        objects.forEach[ obj, index |
            if (source instanceof BitstringExpression)
            {
                sourceExpressions.add(true.newConstBooleanExpression)
            }
            else
            {
                sourceExpressions.add
                (
                    newEqualsExpression
                    (
                        source.newExtractIndexExpression(index),
                        "1".newBitstringExpression
                    )
                )
            }
            // update the new varmap
            nvarmap.put
            (
                loopVarName,
                obj
            )
            // and encode body expression
            bodyExpressions.add
            (
                instance.encodeExpression
                (
                    state,
                    expression.body,
                    nvarmap
                )
            )
        ]
        switch (expression.name) {
            case "forAll":{
                val List<Expression> resultExprList = new ArrayList<Expression>();
                (0..<sourceExpressions.length).forEach[ index |
                    resultExprList += newImpliesExpression(
                        sourceExpressions.get(index),
                        bodyExpressions.get(index)
                    )
                ]
                return newAndExpression(resultExprList)
            }
            case "exists":{
                val List<Expression> resultExprList = new ArrayList<Expression>();
                (0..<sourceExpressions.length).forEach[ index |
                    resultExprList += newIteExpression
                    (
                        sourceExpressions.get(index),
                        bodyExpressions.get(index),
                        newConstBooleanExpression(false)
                    )
                ]
                return newOrExpression(resultExprList)
            }
            case "one":{
                val List<Expression> resultExprList = new ArrayList<Expression>();
                (0..<sourceExpressions.length).forEach[ index |
                    resultExprList += newIteExpression
                    (
                        sourceExpressions.get(index),
                        bodyExpressions.get(index),
                        newConstBooleanExpression(false)
                    )
                ]
                return resultExprList.newCardEqExpression(1)
            }
            case "select":{
                val List<Expression> resultExprList = new ArrayList<Expression>();
                (0..<sourceExpressions.length).forEach[ index |
                    val List<Expression> andList = new ArrayList<Expression>();
                    andList += sourceExpressions.get(index)
                    andList += bodyExpressions.get(index)
                    resultExprList += newAndExpression(andList)
                ]
                return newConcatExpression( resultExprList.reverse )
            }
            case "collect":{
                switch (expression.type) {
                    SetType: {}
                    BagType: {}
                    OrderedSetType: {
                        throw new UnsupportedOperationException("collect for OrderedSet is not supported")
                    }
                    SequenceType: {
                        throw new UnsupportedOperationException("collect for Sequence is not supported")
                    }
                    default: {
                        throw new UnsupportedOperationException("collect have to be called on a CollectionType")
                    }
                }
                val CollectionType collectionType = expression.type as CollectionType
//                val sourceCollectionType = expression.eClass
//                println('''expression.type = «expression.type»''')
//                println('''(expression.type as CollectionType).elementType = «(expression.type as CollectionType).elementType»''')
//                print("")
                
//                val sourceName = (if (expression.source.toString == null) "" else expression.source.name)
//                val sourceName = expression.source.toString
                val sourceName = (source as PlaceholderExpression).varExpression.variable.name 
//                val resultVarName = sourceName+"::collect_Bag@"+collectNumber+"::"+expression.body.toString
                val resultVarName = sourceName+"::collect_Bag::"+expression.body.toString
                val resultVarAlreadyExists = instance.variableIsKnown(resultVarName)
                if (resultVarAlreadyExists)
                {
                    return instance.getVariableExpression(resultVarName)
                }
                val zeroBitStringExpr = newConstIntegerExpression(0,bagElementBitwidth)
                val oneBitStringExpr = newConstIntegerExpression(1,bagElementBitwidth)
                val domain = #[true,false] // TODO more generic!!!
                val List<Expression> collectorTrueHelpList = new ArrayList<Expression>()
                val List<Expression> collectorFalseHelpList = new ArrayList<Expression>()
//                expression.body
                (0..<sourceExpressions.length).forEach[ index |
                    domain.forEach[ value |
                        val helpVarName = sourceName+"::"+"CollectorHelper@"+collectorHelperNumber+"::for::"+value.toString
                        collectorHelperNumber = collectorHelperNumber + 1
                        val helpVar = instance.getAMaybeCreatedBitvector(helpVarName, bagElementBitwidth)
                        val helpVarExpr = newVariableExpression(helpVar)
                        val innerExpr = newIteExpression
                        (
                            sourceExpressions.get(index),
                            newIteExpression
                            (
                                bodyExpressions.get(index),
                                if (value)
                                {
                                    newEqualsExpression(helpVarExpr, oneBitStringExpr)
                                }
                                else
                                {
                                    newEqualsExpression(helpVarExpr, zeroBitStringExpr)
                                },
                                if (value)
                                {
                                    newEqualsExpression(helpVarExpr, zeroBitStringExpr)
                                }
                                else
                                {
                                    newEqualsExpression(helpVarExpr, oneBitStringExpr)
                                }
                            ),
                            newEqualsExpression(helpVarExpr, zeroBitStringExpr)
                        )
                        if (useAlpha)
                        {
                            print("")
                            val foo1 = bodyExpressions.get(index)
                            val foo2 = switch(foo1) {
                                VariableExpression: foo1
                                PlaceholderExpression: foo1.varExpression
                            } as VariableExpression
                            val tmp = foo2.variable.name
                            instance.assertions += newIteExpression
                            (
                                createAlphaConstraint
                                (
                                    instance,
                                    // the next line is the result of the quick hack some lines above!!!
                                    tmp
                                    ,'1'
                                ),
                                innerExpr,
                                newEqualsExpression(helpVarExpr, zeroBitStringExpr)
                            )
                        }
                        else
                        {
                            instance.assertions += innerExpr
                        }
                        if (value)
                        {
                            collectorTrueHelpList += helpVarExpr
                        }
                        else
                        {
                            collectorFalseHelpList += helpVarExpr
                        }
                    ]
                ]
//                val maxNoOfObjects = state.allObjectsOfType(collectionType.eClass).length
                val resultVar = instance.getAMaybeCreatedBitvector(resultVarName, 2 * bagElementBitwidth)
                val resultVarExpr = newVariableExpression(resultVar)
                val falseHalf = newExtractIndexExpression(resultVarExpr, 0, bagElementBitwidth-1)
                val trueHalf = newExtractIndexExpression(resultVarExpr, bagElementBitwidth, 2*bagElementBitwidth-1)
                
                instance.assertions += newEqualsExpression
                (
                    addExpressions(collectorTrueHelpList),
                    trueHalf
                )
                instance.assertions += newEqualsExpression
                (
                    addExpressions(collectorFalseHelpList),
                    falseHalf
                )
                collectNumber = collectNumber + 1
                return resultVarExpr
            }
            default:{
                throw new Exception("Error in IteratorExpressionsExtensions::encodeIteratorExpression:\n"
                    + "default case was called, i.e. the iterator with name " + expression.name + "\n"
                    + "is not implemented"
                )
            }
        }
    }

    def private static encodeIteratorForEClass
    (
        Instance instance,
        StateResource state,
        IteratorExp expression,
        Map<String, EObject> varmap,
        Expression source,
        EClass setElementType
    )
    {
        // all objects of that type
        val objects = state.allObjectsOfType(setElementType as EClass)
        // for each object
        val List<Expression> sourceExpressions = new ArrayList<Expression>();
        val List<String> sourcePropertyVarNames = new ArrayList<String>();
        val List<Expression> bodyExpressions = new ArrayList<Expression>();
        val loopVarName = (expression.iterator.get(0) as Variable).getName
        // loop variable name TODO there can be more than just one iterator

        objects.forEach[ obj, index |
            // access the source expression
            sourceExpressions.add
            (
                newEqualsExpression(
                    source.newExtractIndexExpression(index),
                    "1".newBitstringExpression
                )
            )

            // create a new varmap
            val Map<String, EObject> nvarmap = new HashMap<String,EObject>
            nvarmap.putAll(varmap)
            nvarmap.put(loopVarName, obj)
            // and encode body expression
            bodyExpressions.add(
                encodeExpression(
                    instance,
                    state,
                    expression.body,
                    nvarmap
                )
            )
        ]
        switch (expression.name) {
            case "forAll":{
                val List<Expression> resultExprList = new ArrayList<Expression>();
                (0..<sourceExpressions.length).forEach[ index |
                    resultExprList += newImpliesExpression(
                        sourceExpressions.get(index),
                        bodyExpressions.get(index)
                    )
                ]
                return newAndExpression(resultExprList)
            }
            case "exists":{
                val List<Expression> resultExprList = new ArrayList<Expression>();
                (0..<sourceExpressions.length).forEach[ index |
                    resultExprList += newIteExpression
                    (
                        sourceExpressions.get(index),
                        bodyExpressions.get(index),
                        newConstBooleanExpression(false)
                    )
                ]
                return newOrExpression(resultExprList)
            }
            case "one":{
                val List<Expression> resultExprList = new ArrayList<Expression>();
                (0..<sourceExpressions.length).forEach[ index |
                    resultExprList += newIteExpression
                    (
                        sourceExpressions.get(index),
                        bodyExpressions.get(index),
                        newConstBooleanExpression(false)
                    )
                ]
                return resultExprList.newCardEqExpression(1)
            }
            case "select":{
                val List<Expression> resultExprList = new ArrayList<Expression>();
                (0..<sourceExpressions.length).forEach[ index |
                    val List<Expression> andList = new ArrayList<Expression>();
                    andList += sourceExpressions.get(index)
                    andList += bodyExpressions.get(index)
                    resultExprList += newAndExpression(andList)
                ]
                return newConcatExpression( resultExprList.reverse )
            }
            case "collect":{
                switch (expression.type) {
                    SetType: {}
                    BagType: {}
                    OrderedSetType: {
                        throw new Exception("collect for OrderedSet is not supported")
                    }
                    SequenceType: {
                        throw new Exception("collect for Sequence is not supported")
                    }
                    default: {
                        throw new Exception("collect have to be called on a CollectionType")
                    }
                }
                val CollectionType collectionType = expression.type as CollectionType
//                val sourceCollectionType = expression.eClass
//                println('''expression.type = «expression.type»''')
//                println('''(expression.type as CollectionType).elementType = «(expression.type as CollectionType).elementType»''')
//                print("")
                
//                val sourceName = (if (expression.source.toString == null) "" else expression.source.name)
//                val sourceName = expression.source.toString
                val sourceName = (source as PlaceholderExpression).varExpression.variable.name 
//                val resultVarName = sourceName+"::collect_Bag@"+collectNumber+"::"+expression.body.toString
                val resultVarName = sourceName+"::collect_Bag::"+expression.body.toString
                val resultVarAlreadyExists = instance.variableIsKnown(resultVarName)
                if (resultVarAlreadyExists)
                {
                    return instance.getVariableExpression(resultVarName)
                }
                val zeroBitStringExpr = newConstIntegerExpression(0,bagElementBitwidth)
                val oneBitStringExpr = newConstIntegerExpression(1,bagElementBitwidth)
                val domain = #[true,false] // TODO more generic!!!
                val List<Expression> collectorTrueHelpList = new ArrayList<Expression>()
                val List<Expression> collectorFalseHelpList = new ArrayList<Expression>()
//                expression.body
                (0..<sourceExpressions.length).forEach[ index |
                    domain.forEach[ value |
                        val helpVarName = sourceName+"::"+"CollectorHelper@"+collectorHelperNumber+"::for::"+value.toString
                        collectorHelperNumber = collectorHelperNumber + 1
                        val helpVar = instance.getAMaybeCreatedBitvector(helpVarName, bagElementBitwidth)
                        val helpVarExpr = newVariableExpression(helpVar)
                        val innerExpr = newIteExpression
                        (
                            sourceExpressions.get(index),
                            newIteExpression
                            (
                                bodyExpressions.get(index),
                                if (value)
                                {
                                    newEqualsExpression(helpVarExpr, oneBitStringExpr)
                                }
                                else
                                {
                                    newEqualsExpression(helpVarExpr, zeroBitStringExpr)
                                },
                                if (value)
                                {
                                    newEqualsExpression(helpVarExpr, zeroBitStringExpr)
                                }
                                else
                                {
                                    newEqualsExpression(helpVarExpr, oneBitStringExpr)
                                }
                            ),
                            newEqualsExpression(helpVarExpr, zeroBitStringExpr)
                        )
                        if (useAlpha)
                        {
                            print("")
                            val foo1 = bodyExpressions.get(index)
                            val foo2 = switch(foo1) {
                                VariableExpression: foo1
                                PlaceholderExpression: foo1.varExpression
                            } as VariableExpression
                            val tmp = foo2.variable.name
                            instance.assertions += newIteExpression
                            (
                                instance.createAlphaConstraint
                                (
                                    // the next line is the result of the quick hack some lines above!!!
                                    tmp,
                                    '1'
                                ),
                                innerExpr,
                                newEqualsExpression(helpVarExpr, zeroBitStringExpr)
                            )
                        }
                        else
                        {
                            instance.assertions += innerExpr
                        }
                        if (value)
                        {
                            collectorTrueHelpList += helpVarExpr
                        }
                        else
                        {
                            collectorFalseHelpList += helpVarExpr
                        }
                    ]
                ]
//                val maxNoOfObjects = state.allObjectsOfType(collectionType.eClass).length
                val resultVar = instance.getAMaybeCreatedBitvector(resultVarName, 2 * bagElementBitwidth)
                val resultVarExpr = resultVar.newVariableExpression
                val falseHalf = newExtractIndexExpression(resultVarExpr, 0, bagElementBitwidth-1)
                val trueHalf = newExtractIndexExpression(resultVarExpr, bagElementBitwidth, 2*bagElementBitwidth-1)
                
                instance.assertions += newEqualsExpression
                (
                    addExpressions(collectorTrueHelpList),
                    trueHalf
                )
                instance.assertions += newEqualsExpression
                (
                    addExpressions(collectorFalseHelpList),
                    falseHalf
                )
                collectNumber = collectNumber + 1
                return resultVarExpr
            }
            default:{
                throw new Exception("Error in IteratorExpressionsExtensions::encodeIteratorExpression:\n"
                    + "default case was called, i.e. the iterator with name " + expression.name + "\n"
                    + "is not implemented"
                )
            }
        }
    }

    private static def addExpressions(List<Expression> expressions) {
        var Expression result = 0.newConstIntegerExpression(bagElementBitwidth)
        for (expr : expressions) {
            result = addExpr(result, expr)
        }
        return result
    }

    private static def Expression addExpr (Expression a, Expression b) {
        return a.newAddExpression(b)
    }
}
				