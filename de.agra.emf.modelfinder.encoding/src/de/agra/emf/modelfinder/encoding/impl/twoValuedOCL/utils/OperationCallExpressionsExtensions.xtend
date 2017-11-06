package de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.utils

import de.agra.emf.metamodels.SMTlib2extended.Bitvector
import de.agra.emf.metamodels.SMTlib2extended.Expression
import de.agra.emf.metamodels.SMTlib2extended.Instance
import de.agra.emf.metamodels.SMTlib2extended.IteExpression
import de.agra.emf.metamodels.SMTlib2extended.VariableExpression
import de.agra.emf.modelfinder.encoding.PlaceholderExpression
import de.agra.emf.modelfinder.statesequence.state.StateObject
import de.agra.emf.modelfinder.statesequence.state.StateResource
import java.lang.instrument.IllegalClassFormatException
import java.util.ArrayList
import java.util.List
import java.util.Map
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EClassifier
import org.eclipse.emf.ecore.EDataType
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EOperation
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.ocl.expressions.CallExp
import org.eclipse.ocl.expressions.CollectionItem
import org.eclipse.ocl.expressions.CollectionLiteralExp
import org.eclipse.ocl.expressions.IntegerLiteralExp
import org.eclipse.ocl.expressions.OCLExpression
import org.eclipse.ocl.expressions.OperationCallExp
import org.eclipse.ocl.expressions.PropertyCallExp
import org.eclipse.ocl.expressions.VariableExp
import org.eclipse.ocl.types.BagType
import org.eclipse.ocl.types.CollectionType
import org.eclipse.ocl.types.OrderedSetType
import org.eclipse.ocl.types.PrimitiveType
import org.eclipse.ocl.types.SequenceType
import org.eclipse.ocl.types.SetType
import org.eclipse.ocl.types.TypeType

import static extension de.agra.emf.modelfinder.encoding.LoadParametersExtensions.*

import static extension de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.utils.ExpressionsExtensions.*

import static de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.utils.PropertyCallExpressionsExtensions.*

import static extension de.agra.emf.metamodels.SMTlib2extended.util.MetaModelExtensions.*
import static extension de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.utils.AlphaExtensions.*
import static extension de.agra.emf.modelfinder.statesequence.utils.EcoreExtensions.*
import static extension de.agra.emf.modelfinder.utils.StringUtilsExtensions.*
import static extension de.agra.emf.modelfinder.utils.MathUtilsExtensions.*
import org.eclipse.ocl.expressions.IteratorExp
import de.agra.emf.metamodels.SMTlib2extended.ConcatExpression
import org.eclipse.ocl.ecore.TypeExp
import org.eclipse.ocl.expressions.FeatureCallExp
import de.agra.emf.modelfinder.utils.StringUtilsExtensions
import de.agra.emf.metamodels.SMTlib2extended.impl.IteExpressionImpl
import de.agra.emf.metamodels.SMTlib2extended.BitstringExpression
import de.agra.emf.metamodels.SMTlib2extended.ExtractIndexExpression
import de.agra.emf.metamodels.SMTlib2extended.ConstBooleanExpression
import de.agra.emf.metamodels.SMTlib2extended.ConstIntegerExpression
import de.agra.emf.metamodels.SMTlib2extended.util.MetaModelExtensions

class OperationCallExpressionsExtensions {

    static private int selectCounter = 0

    def static Expression encodeOperationCallExpression
    (
        Instance instance,
        StateResource state,
        OperationCallExp<?,EOperation> expression,
        Map<String, EObject> varmap
    )
    {   
        val String operationName = expression.referredOperation.name
        switch (operationName)
        {
            case "allInstances":
                return operationAllInstances(instance,state,expression,varmap)
            case "not":
                return makeUnaryExpression(instance, state, expression, varmap, operationName)
            case "and":
                return makeBinaryAsNaryExpression(instance, state, expression, varmap, operationName)
            case "or":
                return makeBinaryAsNaryExpression(instance, state, expression, varmap, operationName)
            case "xor":
                return operationXor(instance,state,expression, varmap)
            case "implies":
                return makeBinaryExpression(instance, state, expression, varmap, operationName)
            case "=":
                return makeBinaryExpression(instance, state, expression, varmap, operationName)
            case "<>":{
                val binaryExpr = makeBinaryExpression(instance, state, expression, varmap, "=")
                if (    MetaModelExtensions.optimizeConstraints
                     && binaryExpr instanceof ConstBooleanExpression)
                {
                    val lhsValue = (binaryExpr as ConstBooleanExpression).value
                    return (!lhsValue).newConstBooleanExpression
                }
                return binaryExpr.newNotExpression
            }
            case "<":
                return makeBinaryExpression(instance, state, expression, varmap, operationName)
            case "<=":
                return makeBinaryExpression(instance, state, expression, varmap, operationName)
            case ">=":
                return makeBinaryExpression(instance, state, expression, varmap, operationName)
            case ">":
                return makeBinaryExpression(instance, state, expression, varmap, operationName)
            case "+":
                return makeBinaryExpression(instance, state, expression, varmap, operationName)
            case "-":
                return makeBinaryExpression(instance, state, expression, varmap, operationName)
            case "*":
                return makeBinaryExpression(instance, state, expression, varmap, operationName)
            case "/":
                return makeBinaryExpression(instance, state, expression, varmap, operationName)
            case "mod":
                return makeBinaryExpression(instance, state, expression, varmap, operationName)
            case "min":
                return makeBinaryExpression(instance, state, expression, varmap, operationName)
            case "max":
                return makeBinaryExpression(instance, state, expression, varmap, operationName)
            case "size":
                return operationSize(instance,state,expression,varmap)
            case "oclIsUndefined":
                return operationOclIsUndefined(instance,state,expression,varmap)
            case "isEmpty":
                return operation__Is__Not__Empty(instance,state,expression,varmap,operationName)
            case "notEmpty":
                return operation__Is__Not__Empty(instance,state,expression,varmap,operationName)
            case "includes":
                return operationIncludesExcludes__One__or__All(instance,state,expression,varmap)
            case "includesAll":
                return operationIncludesExcludes__One__or__All(instance,state,expression,varmap)
            case "including":
                return operationIncludingExcludingIntersectionUnion(instance,state,expression,varmap)
            case "excludes":
                return operationIncludesExcludes__One__or__All(instance,state,expression,varmap)
            case "excludesAll":
                return operationIncludesExcludes__One__or__All(instance,state,expression,varmap)
            case "excluding":
                return operationIncludingExcludingIntersectionUnion(instance,state,expression,varmap)
            case "intersection":
                return operationIncludingExcludingIntersectionUnion(instance,state,expression,varmap)
            case "union":
                return operationIncludingExcludingIntersectionUnion(instance,state,expression,varmap)
            case "asSet":
                return operationAsSet(instance,state,expression,varmap)
            case "asBag":
                return operationAsBag(instance,state,expression,varmap)
            case "asOrderedSet":
                return operationAsOrderedSet(instance,state,expression,varmap)
            case "asSequence":
                return operationAsSequence(instance,state,expression,varmap)
            case "oclIsTypeOf":
                return operationOclIsTypeOf(instance,state,expression,varmap)
            case "oclAsType":
                return operationOclAsType(instance,state,expression,varmap)
            case "oclIsNew":
                return operationOclIsNew(instance,state,expression,varmap)
            default: {
                val isInlineOperation =
                state.allOperations
                     .contains( Pair::of(
                        expression.source.type as EClass,
                        expression.referredOperation as EOperation))
                if (isInlineOperation)
                {
                    throw new UnsupportedOperationException("The operation \""
                        + operationName + "\" is inline operation which is not supported"
                    )
                }
                throw new UnsupportedOperationException("The operation \""
                    + operationName + "\" is either not implemented or unknown"
                )
            }
        }
    }

    static private def Expression operationOclIsNew
    (
        Instance instance,
        StateResource state,
        OperationCallExp exp,
        Map<String, EObject> varmap
    )
    {
        if (useAlpha == false)
        {
            throw new Exception("oclIsNew can only be used when useAlpha is switch one!")
        }
        System.err.println("WARNING:\nYou are using oclIsNew, this function is experimental and has been tested for only few cases!")
        if (exp.argument.length != 0)
        {
            throw new IllegalArgumentException("oclIsTypeOf must always be called without any parameter!")
        }
        /*
         * oclIsNew combined with an @pre on the calling object or the operation call itself
         * can cause very strange behaviour, thus, the handling is currently nearly completely
         * ignored!
         */

        val sourceOCL = exp.source
//        if (sourceOCL instanceof FeatureCallExp){
//            sourceOCL.markedPre false
//        }
        // validity check for class could be added
        val sourceExpr = encodeExpression(instance,state,sourceOCL,varmap) as PlaceholderExpression
        val currentSourceObject = (sourceExpr.object as StateObject)
        val objectName = currentSourceObject.name
        val alphaExprPost = instance.createAlphaVarExpression(objectName) as VariableExpression
        val alphaVarPostName = alphaExprPost.variable.name
        val alphaVarPreName = alphaVarPostName.decStateNoInVariableName
        val alphaExprPre = instance.getVariableExpression(alphaVarPreName)
        val split = objectName.split("::")
        val objectIndex = Integer.parseInt( split.get(2).split("@").get(1) )
        val Expression preExpr = newEqualsExpression
        (
            alphaExprPre.newExtractIndexExpression(objectIndex),
            "0".newBitstringExpression
        )
        val Expression postExpr = newEqualsExpression
        (
            alphaExprPost.newExtractIndexExpression(objectIndex),
            "1".newBitstringExpression
        )
        return newAndExpression(#[preExpr, postExpr])
    }

    static private def Expression operationOclAsType
    (
        Instance instance,
        StateResource state,
        OperationCallExp exp,
        Map<String, EObject> varmap
    )
    {
        System.err.println("WARNING:\nYou are using oclAsType, this function is experimental and will only work in some cases!")
        if (exp.argument.length != 1)
        {
            throw new IllegalArgumentException("oclIsTypeOf must always be called with exactly one parameter!")
        }
        val argumentEClass = try {
            ((exp.argument.head as TypeExp).referredType as EClass)
        } catch (ClassCastException e) {
            throw new IllegalArgumentException("The given parameter of oclAsType could be casted to an EClass!")
        }
        val allPossibleObjects =
            if (exp.markedPre)
            {
                (state.preState as StateResource).allObjectsOfType(argumentEClass)
            }
            else
            {
                state.allObjectsOfType(argumentEClass)
            }
        val width = allPossibleObjects.length
        val bitstring = constString("0",width)
        val sourceOCL = exp.source
        // validity check for class could be added
        val _sourceExpr = encodeExpression(instance,state,sourceOCL,varmap)
        if (_sourceExpr instanceof PlaceholderExpression)
        {
            val index = allPossibleObjects.indexOf(_sourceExpr.object)
            if (index != -1)
            {
                val BitstringExpression newIntExpr = bitstring.replaceCharAt("1", index)
                    .reverse.newBitstringExpression as BitstringExpression
                _sourceExpr.intExpression = newIntExpr
                return _sourceExpr
            }
            throw new Exception("Could not find element")
        }
        else if (_sourceExpr instanceof IteExpression)
        {
            val sourceExpr = _sourceExpr as IteExpression
            val traversedIte = instance.traverseIteFieldForOCLAsType
            (
                state,
                sourceExpr,
                varmap,
                allPossibleObjects,
                bitstring
            )
            return traversedIte;
        }
        else
        {
            throw new Exception("Congratulations!")
        }
    }

    static private def Expression traverseIteFieldForOCLAsType
    (
        Instance instance,
        StateResource state,
        Expression expr,
        Map<String, EObject> varmap,
        List<StateObject> allPossibleObjects,
        String bitstring
    )
    {
        if (expr instanceof PlaceholderExpression)
        {
            val index = allPossibleObjects.indexOf(expr.object)
            if (index != -1)
            {
                val BitstringExpression newIntExpr = bitstring.replaceCharAt("1", index).newBitstringExpression as BitstringExpression
                expr.intExpression = newIntExpr
                return expr
            }
            return null // the call above handles this
        }
        else if (expr instanceof IteExpression)
        {
            val elseResult = instance.traverseIteFieldForOCLAsType
            (
                state,
                expr.elseexpr,
                varmap,
                allPossibleObjects,
                bitstring
            )
            val thenResult = instance.traverseIteFieldForOCLAsType
            (
                state,
                expr.thenexpr,
                varmap,
                allPossibleObjects,
                bitstring
            )
            if (elseResult == null)
            {
                return thenResult
            }
            else
            {
                if (thenResult == null)
                {
                    return elseResult
                }
                else
                {
                    expr.thenexpr = thenResult
                    return elseResult
                }
            }
        }
        else
        {
            throw new Exception("Congratulations!")
        }
    }

    static private def Expression operationOclIsTypeOf
    (
        Instance instance,
        StateResource state,
        OperationCallExp exp,
        Map<String, EObject> varmap
    )
    {
        System.err.println("WARNING:\nYou are using oclIsTypeOf, this function is experimental and will only work in some cases!")
        if (exp.argument.length != 1)
        {
            throw new IllegalArgumentException("oclIsTypeOf must always be called with exactly one parameter!")
        }
        val argumentEClass = try {
            ((exp.argument.head as TypeExp).referredType as EClass)
        } catch (ClassCastException e) {
            throw new IllegalArgumentException("The given parameter of oclIsTypeOf could be casted to an EClass!")
        }
        val sourceOCL = exp.source
        // validity check for class could be added
        val sourceExpr = encodeExpression(instance,state,sourceOCL,varmap)
        val allPossibleObjects = state.allObjectsOfType(sourceOCL.type as EClass)
        val width = allPossibleObjects.length
        val concreteObjects = state.allObjectsOfType(argumentEClass)
        val List<Expression> validInstances = new ArrayList<Expression>
        val bitstring = constString("0",width)
        allPossibleObjects.forEach[ object, index |
            if (concreteObjects.contains(object))
            {
                validInstances += newEqualsExpression
                (
                    sourceExpr,
                    bitstring.replaceCharAt('1',index).reverse.newBitstringExpression
                )
            }
        ]
        return newOrExpression(validInstances)
    }

    static private def Expression makeUnaryExpression
    (
        Instance instance,
        StateResource state,
        OperationCallExp<?,EOperation> expression,
        Map<String, EObject> varmap,
        String operationName
    )
    {
        // caller of the operation
        val caller = expression.source
        val lhs = encodeExpression(instance,state,caller,varmap)
        switch (operationName) {
            case "not":
                return newNotExpression(lhs)
            default:
                 throw new UnsupportedOperationException("makeUnaryExpression was called "
                    + "with operationName \""+operationName+"\", but there is no expression"
                    + "known for this operationName.")
        }
    }

    def private static Expression makeBinaryExpression
    (
        Instance instance,
        StateResource state,
        OperationCallExp<?,EOperation> expression,
        Map<String, EObject> varmap,
        String operationName
    )
    {
        // caller of the operation
        val caller = expression.source
        // single parameter
        val EList<?> argument = expression.argument
        val param =  argument.head as OCLExpression<?>
        val lhs = encodeExpression(instance,state,caller,varmap)
        val rhs = encodeExpression(instance,state,param,varmap)
        switch (operationName) {
            case "implies":
                return newImpliesExpression(lhs, rhs)
            case "=":
                return newEqualsExpression(lhs, rhs)
            case "<":
                return newLessExpression(lhs, rhs)
            case "<=":
                return newLessEqualsExpression(lhs, rhs)
            case ">=":
                return newGreaterEqualsExpression(lhs, rhs)
            case ">":
                return newGreaterExpression(lhs, rhs)
            case "+":
                return newAddExpression(lhs, rhs)
            case "-":
                return newSubExpression(lhs, rhs)
            case "*":
                return newMulExpression(lhs, rhs)
            case "/":
                return newDivExpression(lhs, rhs)
            case "mod":
                return newModExpression(lhs, rhs)
            case "min":{
                if (    MetaModelExtensions.optimizeConstraints
                     && lhs instanceof ConstIntegerExpression
                     && rhs instanceof ConstIntegerExpression)
                {
                    val lhsWidth = (lhs as ConstIntegerExpression).width
                    val rhsWidth = (rhs as ConstIntegerExpression).width
                    if (lhsWidth == rhsWidth)
                    {
                        val lhsValue = (lhs as ConstIntegerExpression).value
                        val rhsValue = (rhs as ConstIntegerExpression).value
                        return (Math.min(lhsValue, rhsValue)).newConstIntegerExpression(lhsWidth)
                    }
                    else
                    {
                        throw new IllegalArgumentException
                    }
                }
                return newIteExpression(
                    newLessEqualsExpression(lhs, rhs),
                    lhs,
                    rhs
                )
            }
            case "max":{
                if (    MetaModelExtensions.optimizeConstraints
                     && lhs instanceof ConstIntegerExpression
                     && rhs instanceof ConstIntegerExpression)
                {
                    val lhsWidth = (lhs as ConstIntegerExpression).width
                    val rhsWidth = (rhs as ConstIntegerExpression).width
                    if (lhsWidth == rhsWidth)
                    {
                        val lhsValue = (lhs as ConstIntegerExpression).value
                        val rhsValue = (rhs as ConstIntegerExpression).value
                        return (Math.max(lhsValue, rhsValue)).newConstIntegerExpression(lhsWidth)
                    }
                    else
                    {
                        throw new IllegalArgumentException
                    }
                }
                return newIteExpression(
                    newLessEqualsExpression(lhs, rhs),
                    rhs,
                    lhs
                )
            }
            default:
                 throw new UnsupportedOperationException("makeBinaryExpression was called "
                    + "with operationName \""+operationName+"\", but there is no expression"
                    + "known for this operationName.")
        }
    }

    static private def Expression makeBinaryAsNaryExpression
    (
        Instance instance,
        StateResource state,
        OperationCallExp<?,EOperation> expression,
        Map<String, EObject> varmap,
        String operationName
    )
    {
        // caller of the operation
        val caller = expression.source
        // single parameter
        val EList<?> argument = expression.argument
        val param =  argument.head as OCLExpression<?>
        val List<Expression> exprList = new ArrayList<Expression>
        // lhs
        exprList += encodeExpression(instance,state,caller,varmap)
        // rhs
        exprList += encodeExpression(instance,state,param,varmap)
        switch (operationName) {
            case "and":
                return newAndExpression(exprList)
            case "or":
                return newOrExpression(exprList)
            default:
                 throw new UnsupportedOperationException("makeBinaryAsNaryExpression was called "
                    + "with operationName \""+operationName+"\", but there is no expression"
                    + "known for this operationName.")
        }
    }

    static private def Expression operationXor
    (
        Instance instance,
        StateResource state,
        OperationCallExp<?, EOperation> _expr,
        Map<String, EObject> varmap
    )
    {
        // caller of the operation
        val caller = _expr.source
        // single parameter
        val EList<?> argument = _expr.argument
        val param =  argument.head as OCLExpression<?>
        val lhs = encodeExpression(instance,state,caller,varmap)
        val rhs = encodeExpression(instance,state,param,varmap)
        return newOrExpression
        (
            #[
                newAndExpression(#[lhs, newNotExpression(rhs)]),
                newAndExpression(#[newNotExpression(lhs), rhs])
            ]
        )
    }

    static private def Expression operationAllInstances
    (
        Instance instance,
        StateResource _state,
        OperationCallExp<?, EOperation> expression,
        Map<String, EObject> map
    )
    {
        val classType = (expression.source.type as TypeType).referredType as EClass
        val state =
            if (expression.markedPre)
                _state.preState as StateResource
            else
                _state
        if (useAlpha)
        {
            val String objectName = (state.contents.findFirst[classType.isSuperTypeOf(it.eClass)] as StateObject).name
            createAlphaVarExpression
            (
                instance,
                objectName
            )
        }
        else
        {
            val objects = state.allObjectsOfType(classType as EClass)
            val bitstr = constString("1",objects.length)
            newBitstringExpression(bitstr)
        }
    }

    static private def Expression operationSizePropertyHelper
    (
        Instance instance,
        StateResource state,
        PropertyCallExp expr,
        Map<String, EObject> varmap
    )
    {
        val source = expr.source
        switch (source) {
            VariableExp:{
                val property =
                try {
                    expr.referredProperty as EStructuralFeature
                }
                catch (ClassCastException e)
                {
                throw new IllegalArgumentException("CollectionLiteralExp::operationSizePropertyHelper: case VariableExp \n"
                                + "expr.referredProperty could not be cast to EStructuralFeature.")
                }
                val propertyName = property.name
                val StateObject propertyVarBelongsTo =
                    chooseVarmap(
                        expr,
                        varmap,
                        state
                    ).get(source.toString) as StateObject
                val propertyVarExpr = instance.getVariableExpression(propertyVarBelongsTo.name+"::"+propertyName) as VariableExpression
                val helpVarName = propertyVarBelongsTo.name+"::"+propertyName+"::size"
                val alreadyExists = instance.variableIsKnown(helpVarName)
                val helpVar = instance.getAMaybeCreatedBitvector(helpVarName, intBitwidth)
                val helpVarExpr = helpVar.newVariableExpression
                if (alreadyExists)
                {
                    return helpVarExpr
                }
                switch (property) {
                    EAttribute:{
                        if (property.upperBound > 1 || property.upperBound == -1)
                        {
                            if (property.ordered || (!property.unique))
                            {
                                throw new IllegalArgumentException("CollectionLiteralExp::operationSizePropertyHelper: case VariableExp/EAttribute \n"
                                + "The EAttribute CollectionType of "+property.name+" is not a set, size is currently only supported for sets.")
                            }
                            val zeroExpr = newConstIntegerExpression(0,intBitwidth)
                            val oneExpr = newConstIntegerExpression(1,intBitwidth)
                            switch (property.getEType.name) {
                                case "EBoolean":{
                                    instance.assertions += newEqualsExpression(
                                        helpVarExpr,
                                        newAddExpression(
                                            newIteExpression(
                                                newEqualsExpression(
                                                    newExtractIndexExpression(
                                                        propertyVarExpr,
                                                        0
                                                    ),
                                                    newBitstringExpression("1")
                                                ),
                                                oneExpr,
                                                zeroExpr
                                            ),
                                            newIteExpression(
                                                newEqualsExpression(
                                                    newExtractIndexExpression(
                                                        propertyVarExpr,
                                                        1
                                                    ),
                                                    newBitstringExpression("1")
                                                ),
                                                oneExpr,
                                                zeroExpr
                                            )
                                        )
                                    )
                                    return helpVarExpr
                                }
                                case "EInt":{
                                    var Expression addExpr = zeroExpr
                                    for (var index = intSetBitwidth -1 ; index >= 0; index--)
                                    {
                                        addExpr = newAddExpression(
                                            newIteExpression(
                                                newEqualsExpression(
                                                    newExtractIndexExpression(
                                                        propertyVarExpr,
                                                        index
                                                    ),
                                                    newBitstringExpression("1")
                                                ),
                                                oneExpr,
                                                zeroExpr
                                            ),
                                            addExpr
                                        )
                                    }
                                    instance.assertions += newEqualsExpression(
                                        helpVarExpr,
                                        addExpr
                                    )
                                    
                                    addCardinalityConstraintForSizeErrorPrevention(instance, propertyVarBelongsTo.name +"::"+ propertyName, propertyVarExpr)
                                    
                                    return helpVarExpr
                                }
                                default: {
                                    throw new IllegalArgumentException("CollectionLiteralExp::operationSizePropertyHelper: case VariableExp/EAttribute \n"
                                        + "ToDo")
                                }
                            }
                        }
                        else
                        {
                            throw new IllegalArgumentException("CollectionLiteralExp::operationSizePropertyHelper: case VariableExp/EAttribute \n"
                                + "The EAttribute has a upper bound <= 1, i.e. calling ->size() does not make sense: Illegal OCL code.")
                        }
                    }
                    EReference:{
                        val noOfEnds = state.allObjectsOfType(property.getEType as EClass).length;
                        (0..noOfEnds).forEach[ i |
                            val List<Expression> tmp = new ArrayList
                            tmp += propertyVarExpr
                            instance.assertions += newImpliesExpression
                            (
                                tmp.newCardEqExpression(i),
                                newEqualsExpression
                                (
                                    helpVarExpr,
                                    i.newConstIntegerExpression(intBitwidth)
                                )
                            )
                        ]
                        return helpVarExpr
                    }
                    default: 
                        throw new Exception("CollectionLiteralExp::operationSizePropertyHelper: case VariableExp/default \n"
                            + "Property \""+property.class.name+"\" is not implemented!")
                }
            }
            default:{
                throw new UnsupportedOperationException("CollectionLiteralExp::operationSize: case PropertyCallExp \n"
                    + "sourceObject.source is not a VariableExp object, i.e. nested references calling.\n"
                    + "Please rewrite this by using collectNested( r1 | r1.nextRef)->flatten or something similar.")
            }
        }
    }

  static private def Expression operationSizeOnCollectionHelper
    (
        Instance instance,
        StateResource state,
        VariableExpression collectionBvVarExpr,
        Object type,
        Map<String, EObject> varmap
    )
    {
        val bv = collectionBvVarExpr.variable as Bitvector
        val helpVarName = bv.name+"::size"
        val alreadyExists = instance.variableIsKnown(helpVarName)
        val helpVar = instance.getAMaybeCreatedBitvector(helpVarName, intBitwidth)
        val helpVarExpr = helpVar.variableExpression
        if (!alreadyExists)
        {
            switch (type)
            {
                SetType:{
                    (0..(bv.width)).forEach[ i |
                        val List<Expression> tmp = new ArrayList
                        tmp += collectionBvVarExpr
                        instance.assertions += newImpliesExpression
                        (
                            tmp.newCardEqExpression(i),
                            newEqualsExpression
                            (
                                helpVarExpr,
                                i.newConstIntegerExpression(intBitwidth)
                            )
                        )
                    ]
                    return helpVarExpr
                }
                BagType:{
                    val maxNoOfObjects = bv.width / bagElementBitwidth;
                    val zeroExpr = newConstIntegerExpression(0,intBitwidth)
                    val addExpr = new ArrayList<IteExpression>();
                    for ( i: (0..<maxNoOfObjects))
                    {
                        for ( j: (0..<bagElementBitwidth))
                        {
                            addExpr.add
                            (
                                newIteExpression
                                (
                                    newEqualsExpression
                                    (
                                        collectionBvVarExpr.newExtractIndexExpression(i * bagElementBitwidth + j),
                                        newBitstringExpression("0")
                                    ),
                                    zeroExpr,
                                    newConstIntegerExpression(Math.pow(2,j) as int,intBitwidth)
                                ) as IteExpression
                            )
                        }
                    }
                    var Expression result = newConstIntegerExpression(0,intBitwidth)
                    for ( addMe : addExpr) {
                        result = newAddExpression(result, addMe)
                    }
                    val copyResult = result
                    instance.assertions += newEqualsExpression
                    (
                        copyResult,
                        helpVarExpr
                    )
                    return helpVarExpr
                }
                OrderedSetType:{
                    throw new UnsupportedOperationException("CollectionLiteralExp::operationSizeOnCollectionHelper: case asOrderedSet\n"
                        + "Trying to call the operation size after calling the operation \"asOrderedSet\"\n"
                        + "This case is not implemented so far, feel free to implement the case!")
                }
                SequenceType:{
                    throw new UnsupportedOperationException("CollectionLiteralExp::operationSizeOnCollectionHelper: case asSequence\n"
                        + "Trying to call the operation size after calling the operation \"asSequence\"\n"
                        + "This case is not implemented so far, feel free to implement the case!")
                }
                default:{
                    throw new UnsupportedOperationException("CollectionLiteralExp::operationSizeOnCollectionHelper: case default\n"
                        + "Trying to call the operation size after calling an operation which is does not return a collection.\n"
                        + "By the way, this code line should be unreachable, now!")
                }
            }
        }
        return helpVarExpr
    }

    static public def Expression operationConcatToBitvectorHelper
    (
        Instance instance,
        StateResource resource,
        ConcatExpression concatExpr,
        Object type,
        Map<String, EObject> map
    )
    {
        val width = concatExpr.expressions.length
        val selfName = (map.get("self") as StateObject).name
        val helpVarName = selfName+"::select::helper@"+selectCounter//+"::size"
        selectCounter++
        val helpVar = instance.getAMaybeCreatedBitvector(helpVarName, width)
        val helpVarExpr = helpVar.variableExpression;
        if (!(type instanceof SetType))
        {
            throw new Exception("select returns something which is not a SetType, this is currently not supported")
        }
        (0..<width).forEach[ i |
            instance.assertions += newEqualsExpression
            (
                helpVarExpr.newExtractIndexExpression(i),
                concatExpr.newExtractIndexExpression(i)
            )
        ]
        return helpVarExpr
//        (0..(_width)).forEach[ i |
//            instance.assertions += factory.createImpliesExpression => [
//                lhs = factory.createCardEqExpression => [
//                    k = i
//                    expressions += concatExpr.expressions
//                ]
//                rhs = factory.createEqualsExpression => [
//                    lhs = helpVarExpr
//                    rhs = factory.createConstIntegerExpression => [
//                        value = i
//                        width = intBitwidth
//                    ]
//                ]
//            ]
//            instance.assertions.last.name = "stop-wait"
//        ]
//        return helpVarExpr
    }

    static private def Expression operationSize
    (
        Instance instance,
        StateResource state,
        OperationCallExp<?, EOperation> _expr,
        Map<String, EObject> varmap
    )
    {
        val sourceObject = _expr.getSource
        //TODO check if this comment still represents the correct behavior
        /* If sourceObject is called by 0..1 or 1 reference then it should be always a CollectionLiteralExp
         * Inside the CollectionLiteralExp part.item should contain (and hopefully) represent the PropertyCallExp
         * If sourceObject is not called by 0..1 or 1 reference then it should be PropertyCallExp
         */
        switch (sourceObject) {
            CollectionLiteralExp: {
                val part = sourceObject.part
                if (part.length != 1)
                {
                    throw new UnsupportedOperationException("CollectionLiteralExp::operationSize: case CollectionLiteralExp \n"
                        + "part.length = "+part.length+" != 1 is not supported so far.")
                }
                val item = (part.head as CollectionItem).item
                switch (item) {
                    PropertyCallExp:
                        return operationSizePropertyHelper(instance, state, item, varmap)
                    OperationCallExp<?,EOperation>:{
                        val operationName = item.referredOperation.name
                        if (#[ "asSet", "asOrderedSet", "asBag","asSequence","union"
                              ,"intersection","symmetricDifference","including","excluding"
                        ].contains(operationName))
                        {
                            val tmp = encodeOperationCallExpression(instance,state,item,varmap) as VariableExpression
                            return operationSizeOnCollectionHelper(instance, state, tmp, sourceObject.type, varmap)
                        }
                        throw new UnsupportedOperationException("CollectionLiteralExp::operationSize: case CollectionLiteralExp/OperationCallExp \n"
                        + "It is not possible to call size on the result of the operation \""+operationName +"\"")
                    }
                    IntegerLiteralExp: throw new Exception("xxx")
                    default:
                        throw new UnsupportedOperationException("CollectionLiteralExp::operationSize: case CollectionLiteralExp/default \n"
                        + "sourceObject.part.head.item is an instance of "+item.class+" which is not supported so far")
                }
            }
            PropertyCallExp:{
                return operationSizePropertyHelper(instance, state, sourceObject, varmap)
            }
            OperationCallExp<?,EOperation>:{
                /* E.g. possible by calling *->asSet() where * is reference
                 * Example with: asSet, asOrderedSet, asBag, asSequence
                 */
                 // encode the internal operation first
                val operationName = sourceObject.referredOperation.name
                
                if (#["asSet", "asOrderedSet", "asBag","asSequence"].contains(operationName))
                {
                    val tmp = encodeOperationCallExpression(instance,state,sourceObject,varmap) as VariableExpression
                    return operationSizeOnCollectionHelper(instance,state, tmp, sourceObject.type, varmap)
                }
                if (#["allInstances"].contains(operationName))
                {
                    val tmp = encodeOperationCallExpression(instance,state,sourceObject,varmap) as VariableExpression
                    return operationSizeOnCollectionHelper(instance,state, tmp, sourceObject.type, varmap)
                }
                throw new Exception("CollectionLiteralExp::operationSize: case OperationCallExp/noCollection\n"
                    + "Trying to call the operation size after calling the operation \""+ operationName + "\"\n"
                    + "If this case really makes any sense, feel free to implement it!")
            }
            VariableExp:{
                //TODO Patrick: momentane baustelle
                val tmp = encodeExpression(instance,state,sourceObject,varmap) as VariableExpression
                return operationSizeOnCollectionHelper(instance, state, tmp, sourceObject.type, varmap)
            }
            IteratorExp:{
                val iteratorName = sourceObject.name
                // create a bit vector variable for the iterator, for this purpose the source is needed
                val iterateOver = sourceObject.source
//                var Expression iterateOverVariable = null
//                 switch (iterateOver) {
//                    PropertyCallExp:
//                        iterateOverVariable = operationSizePropertyHelper(instance, state, iterateOver, varmap)
//                    default:{
//                        throw new Exception("CollectionLiteralExp::operationSize: case OperationCallExp/noCollection\n"
//                            + "The size of an IteratorExp can currently only be calculated\n"
//                            + "if the source is a PropertyCallExp.")
//                    }
//                }
                switch(iteratorName) {
                    case "select": {
//                        return operationSizeOnConcatHelper(instance,state, concatExpr, sourceObject.type, varmap)
                        val concatExpr = instance.encodeExpression
                        (
                            state,
                            sourceObject,
                            varmap
                        ) as ConcatExpression
                        val concatBVExpr = instance.operationConcatToBitvectorHelper
                        (
                            state,
                            concatExpr,
                            sourceObject.type,
                            varmap
                        ) as VariableExpression
                        return instance.operationSizeOnCollectionHelper
                        (
                            state,
                            concatBVExpr,
                            sourceObject.type,
                            varmap
                        )
                    }
                    default:{
                        throw new Exception("CollectionLiteralExp::operationSize: case OperationCallExp/noCollection\n"
                            + "size is currently only supported for a select IteratorExp if called on a IteratorExp.")
                    }
                }
            }
            default: {
                println("debug")
                throw new Exception("CollectionLiteralExp::operationSize:\n"
                    + "_sourceObject ("+sourceObject.class+") is an either an invalid argument here or\n"
                    + "or an unsupported operation")
            }
        }
    }

    static private def Expression operationOclIsUndefined__VariableExpHelper
    (
        Instance instance,
        StateResource state,
        VariableExp expression,
        Map<String, EObject> varmap
    )
    {
        if (useAlpha)
        {
            if ((expression.eContainer as OperationCallExp).markedPre)
            {
                val varValue = varmap.get(expression.name) as StateObject
                val varBelongsTo = varValue.name
                val alphaBit = instance.extractAlphaBit(varBelongsTo) as ExtractIndexExpression
                val alphaVarName = (alphaBit.expr as VariableExpression).variable.name
                alphaBit.expr = instance.getVariable(alphaVarName.decStateNoInVariableName).variableExpression
                return newEqualsExpression(alphaBit, newBitstringExpression("0"))
            }
            else
            {
                val varValue = varmap.get(expression.name)
                switch (varValue)
                {
                    StateObject:{
                        val varBelongsTo = varValue.name
                        val alphaBit = instance.extractAlphaBit(varBelongsTo)
                        return newEqualsExpression(alphaBit, newBitstringExpression("0"))
                    }
                    // TODO this should be implemented
    //                PlaceholderExpression:{
    //                    // check if it is a parameter
    //                    if (varValue.attributeString.contains("::param::"))
    //                    {
    //                        val varBelongsTo = (varmap.get(expression.name) as StateObject).name
    //                        val alphaBit = instance.extractAlphaBit(varBelongsTo)
    //                        return newEqualsExpression(alphaBit, newBitstringExpression("0"))
    //                    }
    //                    // WARNING ?
    //                    return newConstBooleanExpression(true)
    //                }
                }
                throw new Exception("Doof")
            }
        }
        else
        {
            // WARNING ?
            return newConstBooleanExpression(true)
        }
    }

    static private def Expression operationOclIsUndefined__CallExpHelper
    (
        Instance instance,
        StateResource state,
        CallExp caller,
        Map<String, EObject> varmap
    )
    {
        val Map<String, EObject> nvarmap = chooseVarmap(
            caller,
            varmap,
            state
        )
        //TODO Patrick: may still handle @pre wrong
        val StateResource nstate = chooseState(
            caller,
            state
        )
        val sourceExpr = encodeExpression(
            instance,
            nstate,
            caller.source,
            nvarmap
        )
        val property =   ( (caller.eContainer as OperationCallExp<?, EOperation>)
                          .source as PropertyCallExp<?,?>)
                        .referredProperty
        if (property instanceof EAttribute)
        {
            throw new UnsupportedOperationException(
                "We do not support OclIsUndefined on EAttributes!"
            )
        }
        else if (property instanceof EReference)
        {
            val varExpr = varExpressionFromProperty(
                instance,
                property as EReference,
                switch (sourceExpr) {
                    PlaceholderExpression:
                        sourceExpr.object as StateObject
                    IteExpression:
                        try {
                            (sourceExpr.thenexpr as PlaceholderExpression).object as StateObject
                        } catch (Exception e) {
                            print("")
                            null
                        }
                    default:
                        throw new Exception("property error TODO check this switch")
                }
            )
            val bitwidth = refBitwidth(
                state,
                caller
            )
            newEqualsExpression(
                varExpr,
                newBitstringExpression(
                    constString("0",bitwidth)
                )
            )
        }
        else
        {
            throw new Exception ("Unknown and unsupported property for OclIsUndefined\n"
                + "property = " + property
            )
        }
    }

    static private def Expression operationOclIsUndefined
    (
        Instance instance,
        StateResource _state,
        OperationCallExp<?, EOperation> _expr,
        Map<String, EObject> _varmap
    )
    {
        // TODO handle expression.argument ?
        val state =
            if (_expr.markedPre)
                _state.preState as StateResource
            else
                _state
        val varmap = chooseVarmap(
            _expr,
            _varmap,
            state
        )
        val OCLExpression<?> tmp = _expr.source
        switch (tmp) {
            VariableExp:
                return operationOclIsUndefined__VariableExpHelper
                (
                    instance,
                    _state,
                    tmp,
                    _varmap
                )
            CallExp:
                return operationOclIsUndefined__CallExpHelper
                (
                    instance,
                    state,
                    tmp,
                    varmap
                )
            default:
                throw new IllegalClassFormatException("operationOclIsUndefined "
                    + "was called from a source which is an instance of \""+tmp.class+"\"."
                )
        }
        
    }

    static private def Expression operation__Is__Not__Empty__IteFieldExpHelper
    (
        Instance instance,
        EReference argumentProperty,
        Expression _expr
    )
    {
        switch (_expr) {
            PlaceholderExpression:
                varExpressionFromProperty(
                    instance,
                    argumentProperty,
                    _expr.object as StateObject
                )
            IteExpression:
                newIteExpression(
                    _expr.condition,
                    operation__Is__Not__Empty__IteFieldExpHelper
                    (
                        instance,
                        argumentProperty,
                        _expr.thenexpr
                    ),
                    operation__Is__Not__Empty__IteFieldExpHelper
                    (
                        instance,
                        argumentProperty,
                        _expr.elseexpr
                    )
                )
            default:
                throw new Exception("OperationCallExpressionsExtensions::operation__Is__Not__Empty__IteFieldExpHelper:"
                    + "The given expression is neither a PlaceholderExpression nor an IteExpression.")
        }
    }

    static private def Expression operation__Is__Not__Empty__PropertyCallExpHelper
    (
        Instance instance,
        StateResource state,
        PropertyCallExp<?,EStructuralFeature> _expr,
        Map<String, EObject> varmap,
        String operationName
    )
    {
        val source = _expr.source
//        if (!(_expr.type instanceof CollectionType))
//        {
//            throw new IllegalArgumentException("OperationCallExpressionsExtensions::operation__Is__Not__Empty__PropertyCallExpHelper:\n"
//                + "The argumentType is not SetType, which is the only supported type so far (instead argumentType is "+_expr.type.class+").")
//        }
        val argumentType = _expr.type
        val argumentProperty = _expr.referredProperty
        var EClass argumentEClass = null
        var Expression varExpr = null
        var int refBitwidth = -1;
        val lhs = encodeExpression(instance,state,source,varmap)
        switch (argumentProperty) {
            EAttribute:{
                val propertyName = argumentProperty.name
                val StateObject propertyVarBelongsTo =
                    chooseVarmap(
                        _expr,
                        varmap,
                        state
                    ).get(source.toString) as StateObject
                varExpr = instance.getVariableExpression(propertyVarBelongsTo.name+"::"+propertyName) as VariableExpression
                val noOfInstantiations =
                switch (argumentProperty.getEType.name) {
                    case "EBoolean":{
                        2
                    }
                    case "EInt":{
                        intSetBitwidth
                    }
                }
                switch (argumentType) {
                    SetType: {
                        refBitwidth = noOfInstantiations
                    }
                    OrderedSetType: {
                        refBitwidth = noOfInstantiations * noOfInstantiations
                    }
                    BagType: {
                        refBitwidth = noOfInstantiations * bagElementBitwidth
                    }
                    SequenceType: {
                        throw new IllegalArgumentException("OperationCallExpressionsExtensions::operation__Is__Not__Empty: CollectionType/PropertyCallExp case\n"
                        + "source is an instance of SequenceType which is currently not supported.")
                    }
                }
            }
            EReference:{
                argumentEClass = argumentProperty.getEReferenceType
                varExpr = switch (lhs) {
                    PlaceholderExpression:
                        varExpressionFromProperty(
                            instance,
                            argumentProperty,
                            lhs.object as StateObject
                        )
                    IteExpression:
                        operation__Is__Not__Empty__IteFieldExpHelper(
                            instance,
                            argumentProperty,
                            lhs
                        )
                    default:
                        throw new Exception("property error TODO check this switch")
                }
                val noOfInstantiations = state.allObjectsOfType(argumentEClass).length
                switch (argumentType) {
                    EClass: {
                        refBitwidth = noOfInstantiations
                    }
                    SetType: {
                        refBitwidth = noOfInstantiations
                    }
                    OrderedSetType: {
                        refBitwidth = noOfInstantiations * noOfInstantiations
                    }
                    BagType: {
                        refBitwidth = noOfInstantiations * bagElementBitwidth
                    }
                    SequenceType: {
                        throw new IllegalArgumentException("OperationCallExpressionsExtensions::operation__Is__Not__Empty: CollectionType/PropertyCallExp case\n"
                        + "source is an instance of SequenceType which is currently not supported.")
                    }
                }
            }
            default:{
                 throw new Exception("OperationCallExpressionsExtensions::operation__Is__Not__Empty:"
                    + "The argument calls a property on an EStructuralFeature,\n"
                    + "which is neither an object of EAttribute nor EReference.\n"
                    + "If this case makes sense, feel free to implement it!")
            }
        }
        var Expression rhs = newConstIntegerExpression(0,refBitwidth)
        if (operationName == "isEmpty")
        {
            return newEqualsExpression(varExpr, rhs)
        }
        else // if (operationName == "notEmpty")
        {
            return newNotExpression( newEqualsExpression(varExpr, rhs) )
        }
    }

    static private def Expression operation__Is__Not__Empty
    (
        Instance instance,
        StateResource state,
        OperationCallExp<?, EOperation> _expr,
        Map<String, EObject> varmap,
        String operationName
    )
    {
        val OCLExpression<?> source = _expr.source
        switch (source) {
            CollectionLiteralExp: {
                val part = source.part
                if (part.length != 1)
                {
                    throw new UnsupportedOperationException("CollectionLiteralExp::operation__Is__Not__Empty: case CollectionLiteralExp \n"
                        + "part.length = "+part.length+" != 1 is not supported so far.")
                }
                val item = (part.head as CollectionItem).item
                switch (item) {
                    PropertyCallExp<?,EStructuralFeature>:{
                        return operation__Is__Not__Empty__PropertyCallExpHelper(
                            instance,
                            state,
                            item,
                            varmap,
                            operationName
                        )
                    }
                    OperationCallExp<?,EOperation>:{
                        throw new UnsupportedOperationException("OperationCallExpressionsExtensions::operationIsEmpty: case CollectionLiteralExp/OperationCallExp \n"
                        + "Feel free to implement me!")
                    }
                    IntegerLiteralExp: throw new Exception("xxx")
                    default:
                        throw new UnsupportedOperationException("CollectionLiteralExp::operationSize: case CollectionLiteralExp/default \n"
                        + "sourceObject.part.head.item is an instance of "+item.class+" which is not supported so far")
                }
            }
            PropertyCallExp<?,EStructuralFeature>:{
                operation__Is__Not__Empty__PropertyCallExpHelper(
                    instance,
                    state,
                    source,
                    varmap,
                    operationName
                )
            }
        }
    }

    static private def Expression operationIncludesExcludes__One__or__AllHelperForSourceCollection
    (
        Instance instance,
        StateResource state,
        CollectionType sourceCollection,
        EClassifier sourceCollectionType,
        Expression sourceObjectExpr,
        Expression argumentObjectExpr,
        String opName
    )
    {
        val int bitwidth = 
            if (sourceCollectionType instanceof EClass)
            {
                state.allObjectsOfType(sourceCollectionType).length
            }
            else  if (sourceCollectionType instanceof EDataType)
            {
                /* TODO */
                switch (sourceCollectionType.name) {
                    case "Boolean":{
                        Math.pow(2,boolBitwidth) as int
                    }
                    case "Integer":{
                        intSetBitwidth
                    }
                    default:{
                        throw new Exception("TODO")
                    }
                }
            }
            else
            {
                throw new Exception("This should be impossible")
            }
        switch (sourceCollection) {
            SetType: {
                val tmp = newEqualsExpression
                (
                    newBvAndExpression
                    (
                        sourceObjectExpr,
                        argumentObjectExpr
                    ),
                    newConstIntegerExpression(0,bitwidth)
                )
                if ("includes" == opName)
                {
                    return newNotExpression(tmp)
                }
                else if ("includesAll" == opName) {
                    return newEqualsExpression
                    (
                        newBvOrExpression
                        (
                            sourceObjectExpr,
                            newBvNotExpression(argumentObjectExpr)
                        ),
                        constString("1",bitwidth).newBitstringExpression
                    )
                }
                else // (#["excludes","excludesAll"].contains(opName)) otherwise this method should not be called
                {
                    return tmp
                }
            }
            BagType: {
                println("we are working on a bag")
                throw new Exception("1")
            }
            OrderedSetType: {
                println("we are working on an ordered set")
                throw new Exception("2")
            }
            SequenceType: {
                println("we are working on a sequence")
                throw new Exception("3")
            }
        }
        throw new Exception("4")
    }

    /**
     * @return must return true or false!!!
     */
    static private def Expression operationIncludesExcludes__One__or__All
    (
        Instance instance,
        StateResource state,
        OperationCallExp<?, EOperation> _expr,
        Map<String, EObject> varmap
    )
    {
        val opName = _expr.referredOperation.name
        val EList _argument = _expr.argument
        if (_argument.length != 1)
        {
            throw new UnsupportedOperationException("OperationCallExpressionsExtensions::operationIncludesExcludes__One__or__All:\n"
                + "The operation \"includes\" must have exactly one argument!")
        }
        // Argument sanity check
        val OCLExpression argument = _argument.head
        val sourceObject = _expr.getSource
        // possible types are: SetType, OrderedSetType
        val CollectionType sourceCollection = switch (sourceObject.type) {
            SetType: sourceObject.type as SetType
            BagType: sourceObject.type as BagType
            OrderedSetType: sourceObject.type as OrderedSetType
            SequenceType: sourceObject.type as SequenceType
            default:
                throw new Exception("OperationCallExpressionsExtensions::operationIncludesExcludes__One__or__All:\n"
                    + "The operation \"includes\" is not called on CollectionType.\n"
                    + "source.type could not be casted to CollectionType: " + sourceObject.type.class.name)
        }
        val EClassifier sourceCollectionType =
            switch (sourceCollection.getElementType) {
                EClass: {
                    sourceCollection.getElementType as EClass
                }
                EDataType:{
                    sourceCollection.getElementType as EDataType
                }
                default: {
                    throw new Exception("OperationCallExpressionsExtensions::operationIncludesExcludes__One__or__All:\n"
                            + "The operation \"includes\" is not called on CollectionType of EClass.\n"
                            + "source.type.getElementType could not be casted to EClass.")
                }
            }
        val sourceObjectExpr = encodeExpression(instance, state, _expr.getSource, varmap)

        switch (argument){
            VariableExp:{
                val argumentObjectExpr = encodeExpression(instance,state,argument,varmap)
                return operationIncludesExcludes__One__or__AllHelperForSourceCollection(
                    instance,
                    state,
                    sourceCollection,
                    sourceCollectionType,
                    sourceObjectExpr,
                    argumentObjectExpr,
                    opName
                )
            }
            PropertyCallExp:{
//                switch(argument.eContainingFeature) {
                switch(argument.referredProperty) {
                    EAttribute: {
                        if (!(sourceCollectionType instanceof EDataType))
                        {
                            throw new Exception("OperationCallExpressionsExtensions::operationIncludesExcludes__One__or__All:\n"
                                    + "The sourceCollectionType for PropertyCallExp<?,EAttribute> was no instanceof an EDataType")
                        }
                        var Expression argumentObjectExpr = null
                        switch ((sourceCollectionType as EDataType).name) {
                            case "Boolean":{
                                argumentObjectExpr = newIteExpression
                                (
                                    encodeExpression(instance,state,argument,varmap),
                                    newBitstringExpression("10"), // first  bit equals 1 means that there is true  inside the Boolean set
                                    newBitstringExpression("01")  // second bit equals 1 means that there is false inside the Boolean set
                                )
                            }
                            case "Integer":{
                                val argumentExpr = encodeExpression(instance,state,argument,varmap)
                                val zerosStrings = constString("0",intSetBitwidth)
                                argumentObjectExpr = zerosStrings.newBitstringExpression // default value, should never occur if argumentExpr is valid
                                for( var index = 0; index < intSetBitwidth; index++)
                                {
                                    argumentObjectExpr = newIteExpression(
                                        newEqualsExpression(
                                            argumentExpr,
                                            newConstIntegerExpression(index,intBitwidth)
                                        ),
                                        zerosStrings.replaceCharAt('1',intSetBitwidth-1-index).newBitstringExpression,
                                        argumentObjectExpr
                                    )
                                }
                            }
                            default:{
                                throw new Exception("OperationCallExpressionsExtensions::operationIncludesExcludes__One__or__All:\n"
                                    + "The sourceCollectionType for PropertyCallExp<?,EAttribute> is neither a Boolean nor an Integer\n")
                            }
                        }
                        return operationIncludesExcludes__One__or__AllHelperForSourceCollection(
                            instance,
                            state,
                            sourceCollection,
                            sourceCollectionType,
                            sourceObjectExpr,
                            argumentObjectExpr,
                            opName
                        )
                    }
                    EReference: {
                        val argumentProperty = argument.referredProperty as EReference
                        if (#["includes","excludes"].contains(opName))
                        {
                            if (argumentProperty.lowerBound > 1)
                            {
                                throw new Exception("OperationCallExpressionsExtensions::operationIncludesExcludes__One__or__All:\n"
                                    + "The argument contains a CollectionType on reference with at least two ends!")
                            }
                            if (!(argumentProperty.lowerBound == 1 && argumentProperty.upperBound == 1))
                            {
                                System.err.println("WARNING:\nOperationCallExpressionsExtensions::operationIncludesExcludes__One__or__All\n"
                                    + "The argument contains a property which calls a reference, where it is\n"
                                    + "not ensured that the reference returns exactly one object as real argument!\n"
                                    + "So do not wonder about a possible strange behaviour!\n"
                                    + "Maybe (on ordededSet and Sequence) it is possible to fix this by using the ->at(int) operation.\n")
                            }
                        }
                        var EClass argumentEClass = argumentProperty.getEReferenceType
                        // type/EClass sanity check
                        if (sourceCollectionType instanceof EClass)
                        {
                            if (!sourceCollectionType.isSuperTypeOf(argumentEClass))
                            {
                                System.err.println("WARNING:\nOperationCallExpressionsExtensions::operationIncludesExcludes__One__or__All\n"
                                    + "The argument is \""+argumentEClass.name+"\" object while the collection contains\n"
                                    + "objects of \""+sourceCollectionType.name+"\", but this is no superclass of the argument type!\n"
                                    + "A \"false\" will be returned as constraint!")
                                return newConstBooleanExpression(false)
                            }
                            val argumentObjectExpr = encodeExpression(instance, state, argument, varmap)
                            return operationIncludesExcludes__One__or__AllHelperForSourceCollection(
                                instance,
                                state,
                                sourceCollection,
                                sourceCollectionType,
                                sourceObjectExpr,
                                argumentObjectExpr,
                                opName
                            )
                        }
                        else  // if (sourceCollectionType instanceof EDataType)
                        {
                            throw new Exception("OperationCallExpressionsExtensions::operationIncludesExcludes__One__or__All:\n"
                                    + "The sourceCollectionType for PropertyCallExp<?,EReference> was no instanceof an EClass\n")
                        }
                    }
                    //EStructuralFeature:{
                    default: {
                        //TODO check if description correct:
                        System.err.println("ERROR: OperationCallExpressionsExtensions::operationIncludesExcludes__One__or__All:\n"
                                    + "The argument calls a property on an EStructuralFeature,\n"
                                    + "which is neither an object of EAttribute nor EReference.")
                        throw new UnsupportedOperationException("OperationCallExpressionsExtensions::operationIncludesExcludes__One__or__All:\n"
                                    + "The argument calls a property on an EStructuralFeature,\n"
                                    + "which is neither an object of EAttribute nor EReference.\n"
                                    + "If his case makes sense, feel free to implement it!")
                    }
                }
            }
            CollectionLiteralExp: {
                val argumentObjectExpr = encodeExpression(instance, state, argument, varmap)
                return operationIncludesExcludes__One__or__AllHelperForSourceCollection(
                    instance,
                    state,
                    sourceCollection,
                    sourceCollectionType,
                    sourceObjectExpr,
                    argumentObjectExpr,
                    opName
                )
            }
            IntegerLiteralExp: {
                val zerosStrings = constString("0",intSetBitwidth).replaceCharAt('1', intSetBitwidth-1-argument.integerSymbol)
                val argumentObjectExpr = zerosStrings.newBitstringExpression
                
                return operationIncludesExcludes__One__or__AllHelperForSourceCollection(
                    instance,
                    state,
                    sourceCollection,
                    sourceCollectionType,
                    sourceObjectExpr,
                    argumentObjectExpr,
                    opName
                )
            }
            OperationCallExp: {
                //TODO taken from VariableExp-case. Check if correct
                val argumentObjectExpr = encodeExpression(instance,state,argument,varmap)
                return operationIncludesExcludes__One__or__AllHelperForSourceCollection(
                    instance,
                    state,
                    sourceCollection,
                    sourceCollectionType,
                    sourceObjectExpr,
                    argumentObjectExpr,
                    opName
                )
            }
            default:{
                throw new UnsupportedOperationException("CollectionLiteralExp::operationIncludesExcludes__One__or__All: case default\n"
                    + "The argument is an instance of \""+argument.class+"\".\n"
                    + "If this case makes sense, feel free to implement it!")
            }
        }
    }
    
    static private def Expression operationIncludingExcludingIntersectionUnionHelperForSourceCollection
    (
        Instance instance,
        StateResource state,
        CollectionType sourceCollection,
        EClassifier sourceCollectionType,
        Expression sourceObjectExpr,
        Expression argumentObjectExpr,
        String opName
    )
    {
        val int bitwidth =
            if (sourceCollectionType instanceof EClass)
            {
                state.allObjectsOfType(sourceCollectionType).length
            }
            else  if (sourceCollectionType instanceof EDataType)
            {
                /* TODO implement for other types of sets once they exist */
                switch (sourceCollectionType.name) {
                    case "Boolean":{
                        Math.pow(2,boolBitwidth) as int
                    }
                    case "Integer":{
                        intSetBitwidth
                    }
                    default:{
                        throw new Exception("TODO")
                    }
                }
            }
            else
            {
                throw new Exception("This should be impossible")
            }
        switch (sourceCollection) {
            SetType: {
                switch(opName) {
                    case "including": {
                        return newBvOrExpression
                        (
                            sourceObjectExpr,
                            argumentObjectExpr
                        )
                    }
                    case "excluding": {
                        return newBvAndExpression
                        (
                            sourceObjectExpr,
                            newBvNotExpression(argumentObjectExpr)
                        )
                    }
                    case "intersection": {
                        return newBvAndExpression
                        (
                            sourceObjectExpr,
                            argumentObjectExpr
                        )
                    }
                    case "union": {
                        return newBvOrExpression
                        (
                            sourceObjectExpr,
                            argumentObjectExpr
                        )
                    }
                }
            }
            BagType: {
                println("we are working on a bag")
                throw new Exception("1")
            }
            OrderedSetType: {
                println("we are working on an ordered set")
                throw new Exception("2")
            }
            SequenceType: {
                println("we are working on a sequence")
                throw new Exception("3")
            }
        }
        throw new Exception("4")
    }

    static private def Expression operationIncludingExcludingIntersectionUnion
    (
        Instance instance,
        StateResource state,
        OperationCallExp<?, EOperation> _expr,
        Map<String, EObject> varmap
    )
    {
        val opName = _expr.referredOperation.name
        val EList _argument = _expr.argument
        if (_argument.length != 1)
        {
            if (#["including","excluding"].contains(opName))
                throw new UnsupportedOperationException("OperationCallExpressionsExtensions::operationIncludingExcludingIntersectionUnion:\n"
                        + "The operation \""+opName+"\" must have exactly one argument!")
        }
        // Argument sanity check
        val OCLExpression argument = _argument.head
        val sourceObject = _expr.getSource
        // possible types are: SetType, BagType, OrderedSetType, SequenceType
        val CollectionType sourceCollection = switch (sourceObject.type) {
            SetType: sourceObject.type as SetType
            BagType: sourceObject.type as BagType
            OrderedSetType: sourceObject.type as OrderedSetType
            SequenceType: sourceObject.type as SequenceType
            default:
                throw new Exception("OperationCallExpressionsExtensions::operationIncludingExcludingIntersectionUnion:\n"
                    + "The operation \""+opName+"\" is not called on CollectionType.\n"
                    + "source.type could not be casted to CollectionType: " + sourceObject.type.class.name)
        }
        val EClassifier sourceCollectionType =
            switch (sourceCollection.getElementType) {
                EClass: {
                    sourceCollection.getElementType as EClass
                }
                EDataType:{
                    sourceCollection.getElementType as EDataType
                }
                default: {
                    throw new Exception("OperationCallExpressionsExtensions::operationIncludingExcludingIntersectionUnion:\n"
                            + "The operation \""+opName+"\" is not called on CollectionType of EClass.\n"
                            + "source.type.getElementType could not be casted to EClass.")
                }
            }
        val sourceObjectExpr = encodeExpression(instance, state, _expr.getSource, varmap)
        switch (argument){
            VariableExp:{
                val argumentObjectExpr = encodeExpression(instance,state,argument,varmap)
                return operationIncludingExcludingIntersectionUnionHelperForSourceCollection(
                    instance,
                    state,
                    sourceCollection,
                    sourceCollectionType,
                    sourceObjectExpr,
                    argumentObjectExpr,
                    opName
                )
            }
            PropertyCallExp<?,EAttribute>:{
                if (!(sourceCollectionType instanceof EDataType))
                {
                    throw new Exception("OperationCallExpressionsExtensions::operationIncludingExcludingIntersectionUnion:\n"
                            + "The sourceCollectionType for PropertyCallExp<?,EAttribute> was no instanceof an EDataType\n")
                }
                var Expression argumentObjectExpr = null
                switch ((sourceCollectionType as EDataType).name) {
                    case "Boolean":{
                        argumentObjectExpr = newIteExpression
                        (
                            encodeExpression(instance,state,argument,varmap),
                            newBitstringExpression("10"), // first  bit equals 1 means that there is true  inside the Boolean set
                            newBitstringExpression("01")  // second bit equals 1 means that there is false inside the Boolean set
                        )
                    }
                    case "Integer":{
                        val argumentExpr = encodeExpression(instance,state,argument,varmap)
                        if (#["including", "excluding"].contains(opName))
                        {
                            val zerosStrings = constString("0",intSetBitwidth)
                            argumentObjectExpr = zerosStrings.newBitstringExpression // default value, should never occur if argumentExpr is valid
                            for( var index = 0; index < intSetBitwidth; index++)
                            {
                                argumentObjectExpr = newIteExpression(
                                    newEqualsExpression(
                                        argumentExpr,
                                        newConstIntegerExpression(index,intBitwidth)
                                    ),
                                    zerosStrings.replaceCharAt('1',intSetBitwidth-1-index).newBitstringExpression,
                                    argumentObjectExpr
                                )
                            }
                        }
                        else if (#["union", "intersection"].contains(opName))
                        {
                            argumentObjectExpr = argumentExpr
                        }
                        else
                        {
                            // Exception? this should not happen/impossible?
                        }
                    }
                    default:{
                        throw new Exception("OperationCallExpressionsExtensions::operationIncludingExcludingIntersectionUnion:\n"
                            + "The sourceCollectionType for PropertyCallExp<?,EAttribute> is neither a Boolean nor an Integer\n")
                    }
                }
                return operationIncludingExcludingIntersectionUnionHelperForSourceCollection(
                    instance,
                    state,
                    sourceCollection,
                    sourceCollectionType,
                    sourceObjectExpr,
                    argumentObjectExpr,
                    opName
                )
            }
            PropertyCallExp<?,EReference>:{
                val argumentProperty = argument.referredProperty
                if (#["including","excluding"].contains(opName))
                {
                    if (argumentProperty.lowerBound > 1)
                    {
                        throw new Exception("OperationCallExpressionsExtensions::operationIncludingExcludingIntersectionUnion:\n"
                            + "The argument contains a CollectionType on reference with at least two ends!")
                    }
                    if (!(argumentProperty.lowerBound == 1 && argumentProperty.upperBound == 1))
                    {
                        System.err.println("WARNING:\nOperationCallExpressionsExtensions::operationIncludingExcludingIntersectionUnion\n"
                            + "The argument contains a property which calls a reference, where it is\n"
                            + "not ensured that the reference returns exactly one object as real argument!\n"
                            + "So do not wonder about a possible strange behaviour!\n"
                            + "Maybe (on ordededSet and Sequence) it is possible to fix this by using the ->at(int) operation.\n")
                    }
                }
                var EClass argumentEClass = argumentProperty.getEReferenceType
                // type/EClass sanity check
                if (sourceCollectionType instanceof EClass)
                {
                    if (!sourceCollectionType.isSuperTypeOf(argumentEClass))
                    {
                        System.err.println("WARNING:\nOperationCallExpressionsExtensions::operationIncludingExcludingIntersectionUnion\n"
                            + "The argument is \""+argumentEClass.name+"\" object while the collection contains\n"
                            + "objects of \""+sourceCollectionType.name+"\", but this is no superclass of the argument type!\n"
                            + "Because there is no fitting default value to return, an UnsupportedOperationException is thrown!")
                        throw new UnsupportedOperationException("OperationCallExpressionsExtensions::operationIncludingExcludingIntersectionUnion\n"
                            + "The argument is \""+argumentEClass.name+"\" object while the collection contains\n"
                            + "objects of \""+sourceCollectionType.name+"\", but this is no superclass of the argument type!\n")
                    }
                    val argumentObjectExpr = encodeExpression(instance, state, argument, varmap)
                    return operationIncludesExcludes__One__or__AllHelperForSourceCollection(
                        instance,
                        state,
                        sourceCollection,
                        sourceCollectionType,
                        sourceObjectExpr,
                        argumentObjectExpr,
                        opName
                    )
                }
                else  // if (sourceCollectionType instanceof EDataType)
                {
                    throw new Exception("OperationCallExpressionsExtensions::operationIncludingExcludingIntersectionUnion:\n"
                            + "The sourceCollectionType for PropertyCallExp<?,EReference> was no instanceof an EClass\n")
                }
            }
            PropertyCallExp<?,EStructuralFeature>:{
                //TODO check if description correct:
                System.err.println("ERROR: OperationCallExpressionsExtensions::operationIncludingExcludingIntersectionUnion:\n"
                            + "The argument calls a property on an EStructuralFeature,\n"
                            + "which is neither an object of EAttribute nor EReference.")
                throw new UnsupportedOperationException("OperationCallExpressionsExtensions::operationIncludingExcludingIntersectionUnion:\n"
                            + "The argument calls a property on an EStructuralFeature,\n"
                            + "which is neither an object of EAttribute nor EReference.\n"
                            + "If his case makes sense, feel free to implement it!")
            }
            CollectionLiteralExp: {
                val argumentObjectExpr = encodeExpression(instance, state, argument, varmap)
                return operationIncludingExcludingIntersectionUnionHelperForSourceCollection(
                    instance,
                    state,
                    sourceCollection,
                    sourceCollectionType,
                    sourceObjectExpr,
                    argumentObjectExpr,
                    opName
                )
            }
            IntegerLiteralExp: {
                val intValueString = constString("0",intSetBitwidth).replaceCharAt('1', intSetBitwidth-1-argument.integerSymbol)
                val argumentObjectExpr = intValueString.newBitstringExpression
                
                return operationIncludingExcludingIntersectionUnionHelperForSourceCollection(
                    instance,
                    state,
                    sourceCollection,
                    sourceCollectionType,
                    sourceObjectExpr,
                    argumentObjectExpr,
                    opName
                )
            }
            OperationCallExp:{
                //TODO taken from VariableExp-case. Check if correct
                val argumentObjectExpr = encodeExpression(instance,state,argument,varmap)
                return operationIncludingExcludingIntersectionUnionHelperForSourceCollection(
                    instance,
                    state,
                    sourceCollection,
                    sourceCollectionType,
                    sourceObjectExpr,
                    argumentObjectExpr,
                    opName
                )
            }

            default:{
                throw new UnsupportedOperationException("CollectionLiteralExp::operationIncludingExcludingIntersectionUnion: case default\n"
                    + "The argument is an instance of \""+argument.class+"\".\n"
                    + "If this case makes sense, feel free to implement it!")
            }
        }
    }

    static private def Expression operationAsSet
    (
        Instance instance,
        StateResource state,
        OperationCallExp<?, EOperation> expr,
        Map<String, EObject> varmap
    )
    {
        val _source = expr.source
        switch (_source)
        {
            PropertyCallExp:{
                val source = _source.source
                switch (source) {
                    VariableExp:{
                        val property = _source.referredProperty
                        switch (property) {
                            EAttribute:{
                                throw new IllegalArgumentException("OperationcallExpressionsExtensions::operationAsSet: case PropertyCallExp/VariableExp/EAttribute \n"
                                    + "Trying to build a set on an EAttribute: Illegal OCL code.")
                            }
                            EReference:{
                                val propertyName = property.name
                                val propertyVarBelongsTo = varmap.get(source.toString) as StateObject
                                val referenceVarName = propertyVarBelongsTo.name+"::"+propertyName
                                val referenceVarAlreadyExists = instance.variableIsKnown(referenceVarName)
                                if (!referenceVarAlreadyExists)
                                {
                                    System.err.println("The variable \""+referenceVarName+"\" is not known building a bag can cause problems")
                                }
                                val referenceVarExpr = instance.getVariableExpression(referenceVarName) as VariableExpression
                                val helpVarName = propertyVarBelongsTo.name+"::"+propertyName+"::asSet"
                                val helpVarAlreadyExists = instance.variableIsKnown(helpVarName)
                                val helpVarBitwidth = refBitwidth(state,_source)
                                val helpVar = instance.getAMaybeCreatedBitvector(helpVarName, helpVarBitwidth)
                                val helpVarExpr = helpVar.newVariableExpression
                                if (helpVarAlreadyExists)
                                {
                                    return helpVarExpr
                                }
                                instance.assertions += newEqualsExpression
                                (
                                    referenceVarExpr,
                                    helpVarExpr
                                )
                                return helpVarExpr
                            }
                            default:{
                                throw new Exception("OperationcallExpressionsExtensions::operationAsSet:case VariableExp/default \n"
                                    + "Property \""+property.class.name+"\" is not implemented! Please make sure that this makes sense in your example")
                            }
                        }
                    }
                    default:{
                        throw new UnsupportedOperationException ("OperationcallExpressionsExtensions::operationAsSet: case PropertyCallExp/default\n")
                    }
                }
            }
            OperationCallExp<?,EOperation>:{
                throw new UnsupportedOperationException ("OperationcallExpressionsExtensions::operationAsSet: case OperationCallExp\n"
                    + "The source of the OperationCallExp for \"asSet\"is an OperationCallExp\n"
                    + "This case is not implemented so far, feel free to do it!")
            }
            CollectionLiteralExp:{
                throw new UnsupportedOperationException ("OperationcallExpressionsExtensions::operationAsSet: case OperationCallExp\n"
                    + "The source of the OperationCallExp for \"asSet\"is an CollectionLiteralExp\n"
                    + "This case is not implemented so far, feel free to do it!")
            }
            default: {
                throw new UnsupportedOperationException ("OperationcallExpressionsExtensions::operationAsSet: case default\n"
                    + "The source of the OperationCallExp is not a PropertyCallExp\n"
                    + "\"source\" is an instance of \""+_source.class+"\"")
            }
        }
    }

    static private def Expression operationAsBag__PropertyCallExpHelper
    (
        Instance instance,
        StateResource state,
        PropertyCallExp<?,EStructuralFeature> _expr,
        Map<String, EObject> varmap
    )
    {
        val source = _expr.source
        switch (source) {
            VariableExp:{
                val property = _expr.referredProperty
                val propertyName = property.name
                val propertyVarBelongsTo = varmap.get(source.toString) as StateObject
                val propertyVarName = propertyVarBelongsTo.name+"::"+propertyName
                val propertyVarAlreadyExists = instance.variableIsKnown(propertyVarName)
                if (!propertyVarAlreadyExists)
                {
                    System.err.println("The variable \""+propertyVarName+"\" is not known building a bag can cause problems")
                }
                val propertyVarExpr = instance.getVariableExpression(propertyVarName)
                val helpVarName = propertyVarBelongsTo.name+"::"+propertyName+"::asBag"
                val helpVarAlreadyExists = instance.variableIsKnown(helpVarName)
                if (helpVarAlreadyExists)
                {
                    return instance.getVariableExpression(helpVarName)
                }
                switch (property) {
                    EAttribute:{
                        if (!(   property.getEType.name == "EBoolean"
                              || property.getEType.name == "EBooleanObject"))
                        {
                            throw new UnsupportedOperationException("OperationcallExpressionsExtensions::operationAsBag__PropertyCallExpHelper: case EAttribute \n"
                            + "Trying to build a bag on an EAttribute (type : "+property.getEType.name+") which is not an EBoolean: Unsupported type.")
                        }
                        if (property.getEType.name == "EBooleanObject")
                        {
                            System.err.println("Bag of EBooleanObjects will be build as a bag of EBoolean")
                        }
                        // initialisiere ein entsprechendes Bag
                        val helpVarBitwidth = 2 * bagElementBitwidth
                        val zeroBitStringExpr = newConstIntegerExpression(0,bagElementBitwidth)
                        val oneBitStringExpr = newConstIntegerExpression(1,bagElementBitwidth)
                        val helpVar = instance.getAMaybeCreatedBitvector(helpVarName, helpVarBitwidth)
                        val helpVarExpr = helpVar.newVariableExpression
                        val falseHalf = newExtractIndexExpression(helpVarExpr, 0, bagElementBitwidth-1)
                        val trueHalf = newExtractIndexExpression(helpVarExpr, bagElementBitwidth, 2*bagElementBitwidth-1)
                        // ensure useAlpha value!
                        val innerExpr = newIteExpression
                        (
                            propertyVarExpr,
                            newAndExpression(
                                #[  newEqualsExpression(trueHalf, oneBitStringExpr),
                                    newEqualsExpression(falseHalf, zeroBitStringExpr)
                                ]
                            ),
                            newAndExpression(
                                #[  newEqualsExpression(trueHalf, zeroBitStringExpr),
                                    newEqualsExpression(falseHalf, oneBitStringExpr)
                                ]
                            )
                        )
                        if (useAlpha)
                        {
                            instance.assertions += newIteExpression
                            (
                                createAlphaConstraint(instance,propertyVarName,'1'),
                                innerExpr,
                                newAndExpression
                                (
                                    #[  newEqualsExpression(trueHalf, zeroBitStringExpr),
                                        newEqualsExpression(falseHalf, zeroBitStringExpr)
                                    ]
                                )
                            )
                        }
                        else
                        {
                            instance.assertions += innerExpr
                        }
                        return helpVarExpr
                    }
                    EReference:{
                        val maxNoOfObjects = refBitwidth(state,_expr)
                        val helpVarBitwidth = maxNoOfObjects * bagElementBitwidth
                        val zeroBitStringExpr = newConstIntegerExpression(0,bagElementBitwidth)
                        val oneBitStringExpr = newConstIntegerExpression(1,bagElementBitwidth)
                        val helpVar = instance.getAMaybeCreatedBitvector(helpVarName, helpVarBitwidth)
                        val helpVarExpr = helpVar.newVariableExpression
                        // Assignment of the bag bitvector, possible values are only 0 and 1 because we are calling the operation on a reference
                        for (i : (0..<maxNoOfObjects))
                        {
                            val refBit = newExtractIndexExpression(propertyVarExpr,i)
                            val extractedBits = newExtractIndexExpression(
                                helpVarExpr,
                                i*bagElementBitwidth,
                                (i+1)*bagElementBitwidth-1
                            )
                            instance.assertions += newIteExpression
                            (
                                newEqualsExpression
                                (
                                    refBit,
                                    newBitstringExpression("0")
                                ),
                                newEqualsExpression
                                (
                                    extractedBits,
                                    zeroBitStringExpr
                                ),
                                newEqualsExpression
                                (
                                    extractedBits,
                                    oneBitStringExpr
                                )
                            )
                        }
                        return helpVarExpr
                    }
                    default:{
                        throw new Exception("OperationcallExpressionsExtensions::operationAsBag:case VariableExp/default \n"
                            + "Property \""+property.class.name+"\" is not implemented! Please make sure that this makes sense in your example")
                    }
                }
            }
            default:{
                throw new UnsupportedOperationException ("OperationcallExpressionsExtensions::operationAsBag: case PropertyCallExp/default\n")
            }
        }
    }

    static private def Expression operationAsBag
    (
        Instance instance,
        StateResource state,
        OperationCallExp<?, EOperation> _expr,
        Map<String, EObject> varmap
    )
    {
        val _source = _expr.source
        switch (_source)
        {
            PropertyCallExp<?,EStructuralFeature>:{
                return operationAsBag__PropertyCallExpHelper
                (
                    instance,
                    state,
                    _source,
                    varmap
                )
            }
            OperationCallExp<?,EOperation>:{
                throw new UnsupportedOperationException ("OperationcallExpressionsExtensions::operationAsBag: case OperationCallExp\n"
                    + "The source of the OperationCallExp for \"asBag\"is an OperationCallExp\n"
                    + "This case is not implemented so far, feel free to do it!")
            }
            CollectionLiteralExp:{
                val part = _source.part
                if (part.length != 1)
                {
                    throw new UnsupportedOperationException("OperationcallExpressionsExtensions::operationAsBag: case CollectionLiteralExp \n"
                        + "part.length = "+part.length+" != 1 is not supported so far.")
                }
                val internalCollection = _source.type
                switch(internalCollection) {
                    SetType:{
                        val elementType = internalCollection.elementType
                        var String elementTypeName = null
                        switch (elementType) {
                            PrimitiveType: {
                                elementTypeName = elementType.name
                            }
                            EClass:{
                                println("TODO")
                                throw new UnsupportedOperationException("TODO")
                            }
                            default:{
                                throw new UnsupportedOperationException("TODO")
                            }
                        }
                        val item = (part.head as CollectionItem).item
                        switch (item) {
                            PropertyCallExp<?,EStructuralFeature>:{
                                return operationAsBag__PropertyCallExpHelper(
                                    instance,
                                    state,
                                    item,
                                    varmap
                                )
                            }
                            default: {
                                println("TODO")
                                throw new UnsupportedOperationException("TODO")
                            }
                        }
                    }
                    default:
                        throw new Exception("xxx")
                }
            }
            default: {
                throw new UnsupportedOperationException ("OperationcallExpressionsExtensions::operationAsBag: case default\n"
                    + "The source of the OperationCallExp is not a PropertyCallExp\n"
                    + "\"source\" is an instance of \""+_source.class+"\"")
            }
        }
    }

    static private def Expression operationAsOrderedSet
    (
        Instance instance,
        StateResource state,
        OperationCallExp<?, EOperation> _expr,
        Map<String, EObject> varmap
    )
    {
        val _source = _expr.source
        switch (_source)
        {
            PropertyCallExp:{
                val source = _source.source
                switch (source) {
                    VariableExp:{
                        val property = _source.referredProperty
                        switch (property) {
                            EAttribute:{
                                throw new IllegalArgumentException("OperationcallExpressionsExtensions::operationAsOrderedSet: case PropertyCallExp/VariableExp/EAttribute \n"
                                    + "Trying to build an ordered set on an EAttribute: Illegal OCL code.")
                            }
                            EReference:{
                                val propertyName = property.name
                                val propertyVarBelongsTo = varmap.get(source.toString) as StateObject
                                val referenceVarName = propertyVarBelongsTo.name+"::"+propertyName
                                val referenceVarAlreadyExists = instance.variableIsKnown(referenceVarName)
                                if (!referenceVarAlreadyExists)
                                {
                                    System.err.println("The variable \""+referenceVarName+"\" is not known building an ordered set can cause problems")
                                }
                                val referenceVarExpr = instance.getVariableExpression(referenceVarName) as VariableExpression
                                val helpVarName = propertyVarBelongsTo.name+"::"+propertyName+"::asSet"
                                val helpVarAlreadyExists = instance.variableIsKnown(helpVarName)
                                val helpVarBitwidth = refBitwidth(state,_source)
                                /* we are using a one-hot-encoding such that we need n^2 bits (n=helpVarBitwidth)
                                 * The first n bits encoded the first object, at least one of this bits can be set,
                                 * if this is the j-th bit (0<=j<n), then the first object of the orderedSet is object@j.
                                 */
                                val helpVar = instance.getAMaybeCreatedBitvector(helpVarName, helpVarBitwidth * helpVarBitwidth)
                                val helpVarExpr = helpVar.newVariableExpression
                                if (helpVarAlreadyExists)
                                {
                                    return helpVarExpr
                                }
                                (0..<helpVarBitwidth).forEach[ i |
                                    val tmp = newExtractIndexExpression(helpVarExpr, i* helpVarBitwidth, (i+1) * helpVarBitwidth - 1)
                                    instance.assertions += newImpliesExpression
                                    (
                                        referenceVarExpr.newExtractIndexExpression(i),
                                        newEqualsExpression
                                        (
                                            tmp,
                                            newBitstringExpression(getOneHotBitstring(helpVarBitwidth,i))
                                        )
                                    )
                                ]
                                instance.assertions += newEqualsExpression
                                (
                                    referenceVarExpr,
                                    helpVarExpr
                                )
                                return helpVarExpr
                            }
                            default:{
                                throw new Exception("OperationcallExpressionsExtensions::operationAsSet:case VariableExp/default \n"
                                    + "Property \""+property.class.name+"\" is not implemented! Please make sure that this makes sense in your example")
                            }
                        }
                    }
                    default:{
                        throw new UnsupportedOperationException ("OperationcallExpressionsExtensions::operationAsSet: case PropertyCallExp/default\n")
                    }
                }
            }
            OperationCallExp<?,EOperation>:{
                throw new UnsupportedOperationException ("OperationcallExpressionsExtensions::operationAsSet: case OperationCallExp\n"
                    + "The source of the OperationCallExp for \"asSet\"is an OperationCallExp\n"
                    + "This case is not implemented so far, feel free to do it!")
            }
            CollectionLiteralExp:{
                throw new UnsupportedOperationException ("OperationcallExpressionsExtensions::operationAsSet: case OperationCallExp\n"
                    + "The source of the OperationCallExp for \"asSet\"is an CollectionLiteralExp\n"
                    + "This case is not implemented so far, feel free to do it!")
            }
            default: {
                throw new UnsupportedOperationException ("OperationcallExpressionsExtensions::operationAsSet: case default\n"
                    + "The source of the OperationCallExp is not a PropertyCallExp\n"
                    + "\"source\" is an instance of \""+_source.class+"\"")
            }
        }
    }

    static private def Expression operationAsSequence
    (
        Instance instance,
        StateResource resource,
        OperationCallExp<?, EOperation> expr,
        Map<String, EObject> map
    )
    {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    /**
     * Call this method to reduce the maximum size of the Collection
     * represented by <i>expressionToRestrict</i> by one.<br>
     * <br>
     * Do this to prevent an error when calling the <i>size()</i>-operation on
     * this Collection.<br>
     * <br>
     * <i>expressionToRestrict</i> has to be a Collection, to ensure correct
     * behavior of this method.
     */
    static private def void addCardinalityConstraintForSizeErrorPrevention
    (
        Instance instance,
        String fullVarName,
        Expression expressionToRestrict
    )
    {
        System.err.println("WARNING: The maximum size of "+ fullVarName +" was reduced by 1 to avoid an error with the size()-operation!")
        instance.assertions += #[expressionToRestrict].newCardLtExpression(intSetBitwidth)
    }
}
																																																												