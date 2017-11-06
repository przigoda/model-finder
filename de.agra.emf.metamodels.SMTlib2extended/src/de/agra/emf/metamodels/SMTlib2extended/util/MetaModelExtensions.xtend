package de.agra.emf.metamodels.SMTlib2extended.util

import de.agra.emf.metamodels.SMTlib2extended.BinaryExpression
import de.agra.emf.metamodels.SMTlib2extended.BitstringExpression
import de.agra.emf.metamodels.SMTlib2extended.Bitvector
import de.agra.emf.metamodels.SMTlib2extended.ConstBooleanExpression
import de.agra.emf.metamodels.SMTlib2extended.ConstIntegerExpression
import de.agra.emf.metamodels.SMTlib2extended.Expression
import de.agra.emf.metamodels.SMTlib2extended.Instance
import de.agra.emf.metamodels.SMTlib2extended.IteExpression
import de.agra.emf.metamodels.SMTlib2extended.NAryExpression
import de.agra.emf.metamodels.SMTlib2extended.Predicate
import de.agra.emf.metamodels.SMTlib2extended.SMTlib2extendedFactory
import de.agra.emf.metamodels.SMTlib2extended.UnaryExpression
import de.agra.emf.metamodels.SMTlib2extended.Variable
import de.agra.emf.metamodels.SMTlib2extended.VariableExpression
import java.util.List
import org.eclipse.emf.common.util.BasicEList
import org.eclipse.emf.common.util.EList

import static extension de.agra.emf.modelfinder.utils.MathUtilsExtensions.*
import static extension de.agra.emf.modelfinder.utils.StringUtilsExtensions.*
import java.util.ArrayList

class MetaModelExtensions {
    private new(){}
    private static val MetaModelExtensions instance = new MetaModelExtensions()
    def public static MetaModelExtensions getInstance()
    {
        return instance
    }

    public static val factory = SMTlib2extendedFactory::eINSTANCE
    public static var boolean optimizeConstraints = true

    def public static Expression constIntegerExpression(int _value, int _width) {
        factory.createConstIntegerExpression => [
            value = _value
            width = _width
        ]
    }

    def public static Expression constBooleanExpression(boolean _value) {
        factory.createConstBooleanExpression => [
            value = _value
        ]
    }

    def public static VariableExpression variableExpression(Variable _variable) {
        factory.createVariableExpression => [
            variable = _variable
        ]
    }

    def public static boolean variableIsKnown
    (
        Instance instance,
        Variable variable
    )
    {
        instance.variables.contains(variable)
    }

    def public static boolean variableIsKnown
    (
        Instance instance,
        String varName
    )
    {
        instance.variables.findFirst[it.name == varName] != null
    }

    def public static Variable newVariable
    (
        String _name
    )
    {
        factory.createVariable => [
            name = _name
        ]
    }

    /**
     * @brief This function returns a new bitvector
     * 
     * @param name The name of the bitvector
     * @param width The bitwidth of the bitvector
     */
    def public static Bitvector newBitvector
    (
        String _name,
        int _width
    )
    {
        factory.createBitvector => [
            name = _name
            width = _width
        ]
    }

    /**
     * @brief This function returns a new bitvector
     * 
     * @param name The name of the bitvector
     * @param width The bitwidth of the bitvector
     */
    def public static Predicate newPredicate(String _name)
    {
        factory.createPredicate => [
            name = _name
        ]
    }


    def public static Expression newAddExpression
    (
        Expression lhsExpr,
        Expression rhsExpr
    )
    {
        if (    optimizeConstraints
             && lhsExpr instanceof ConstIntegerExpression
             && rhsExpr instanceof ConstIntegerExpression)
        {
            val lhsWidth = (lhsExpr as ConstIntegerExpression).width
            val rhsWidth = (rhsExpr as ConstIntegerExpression).width
            if (lhsWidth == rhsWidth)
            {
                val lhsValue = (lhsExpr as ConstIntegerExpression).value
                val rhsValue = (rhsExpr as ConstIntegerExpression).value
                return (lhsValue + rhsValue).newConstIntegerExpression(lhsWidth)
            }
            else
            {
                throw new IllegalArgumentException
            }
        }
        return factory.createAddExpression => [
            lhs = lhsExpr
            rhs = rhsExpr
        ]
    }

    def public static Expression newSubExpression
    (
        Expression lhsExpr,
        Expression rhsExpr
    )
    {
        if (    optimizeConstraints
             && lhsExpr instanceof ConstIntegerExpression
             && rhsExpr instanceof ConstIntegerExpression)
        {
            val lhsWidth = (lhsExpr as ConstIntegerExpression).width
            val rhsWidth = (rhsExpr as ConstIntegerExpression).width
            if (lhsWidth == rhsWidth)
            {
                val lhsValue = (lhsExpr as ConstIntegerExpression).value
                val rhsValue = (rhsExpr as ConstIntegerExpression).value
                return (lhsValue - rhsValue).newConstIntegerExpression(lhsWidth)
            }
            else
            {
                throw new IllegalArgumentException
            }
        }
        return factory.createSubExpression => [
            lhs = lhsExpr
            rhs = rhsExpr
        ]
    }

    def public static Expression newDivExpression
    (
        Expression lhsExpr,
        Expression rhsExpr
    )
    {
        if (    optimizeConstraints
             && lhsExpr instanceof ConstIntegerExpression
             && rhsExpr instanceof ConstIntegerExpression)
        {
            val lhsWidth = (lhsExpr as ConstIntegerExpression).width
            val rhsWidth = (rhsExpr as ConstIntegerExpression).width
            if (lhsWidth == rhsWidth)
            {
                val lhsValue = (lhsExpr as ConstIntegerExpression).value
                val rhsValue = (rhsExpr as ConstIntegerExpression).value
                return (lhsValue / rhsValue).newConstIntegerExpression(lhsWidth)
            }
            else
            {
                throw new IllegalArgumentException
            }
        }
        return factory.createDivExpression => [
            lhs = lhsExpr
            rhs = rhsExpr
        ]
    }

    def public static Expression newModExpression
    (
        Expression lhsExpr,
        Expression rhsExpr
    )
    {
        if (    optimizeConstraints
             && lhsExpr instanceof ConstIntegerExpression
             && rhsExpr instanceof ConstIntegerExpression)
        {
            val lhsWidth = (lhsExpr as ConstIntegerExpression).width
            val rhsWidth = (rhsExpr as ConstIntegerExpression).width
            if (lhsWidth == rhsWidth)
            {
                val lhsValue = (lhsExpr as ConstIntegerExpression).value
                val rhsValue = (rhsExpr as ConstIntegerExpression).value
                return (lhsValue % rhsValue).newConstIntegerExpression(lhsWidth)
            }
            else
            {
                throw new IllegalArgumentException
            }
        }
        return factory.createModExpression => [
            lhs = lhsExpr
            rhs = rhsExpr
        ]
    }

    def public static Expression newMulExpression
    (
        Expression lhsExpr,
        Expression rhsExpr
    )
    {
        if (    optimizeConstraints
             && lhsExpr instanceof ConstIntegerExpression
             && rhsExpr instanceof ConstIntegerExpression)
        {
            val lhsWidth = (lhsExpr as ConstIntegerExpression).width
            val rhsWidth = (rhsExpr as ConstIntegerExpression).width
            if (lhsWidth == rhsWidth)
            {
                val lhsValue = (lhsExpr as ConstIntegerExpression).value
                val rhsValue = (rhsExpr as ConstIntegerExpression).value
                return (lhsValue * rhsValue).newConstIntegerExpression(lhsWidth)
            }
            else
            {
                throw new IllegalArgumentException
            }
        }
        return factory.createMulExpression => [
            lhs = lhsExpr
            rhs = rhsExpr
        ]
    }

    def public static Expression newAndExpression(List<Expression> exprList)
    {
        if (optimizeConstraints)
        {
            val exprListIt = exprList.iterator
            var allConstTrue = true
            while (exprListIt.hasNext)
            {
                val expr = exprListIt.next
                if (expr instanceof ConstBooleanExpression)
                {
                   if (!expr.value)
                   {
                       return false.newConstBooleanExpression
                   }
                }
                else
                {
                    allConstTrue = false
                }
            }
            if (allConstTrue)
            {
                return true.newConstBooleanExpression
            }
        }
        return factory.createAndExpression => [
            expressions += exprList
        ]
    }

    def public static Expression newBitstringExpression(String _value)
    {
        factory.createBitstringExpression => [
            value = _value
        ]
    }

    def public static Expression newBvOrExpression
    (
        Expression _lhs,
        Expression _rhs
    )
    {
        factory.createBvOrExpression => [
            lhs = _lhs
            rhs = _rhs
        ]
    }

    def public static Expression newBvAndExpression
    (
        Expression _lhs,
        Expression _rhs
    )
    {
        factory.createBvAndExpression => [
            lhs = _lhs
            rhs = _rhs
        ]
    }

    def public static Expression newBvNotExpression(Expression _expr)
    {
        factory.createBvNotExpression => [
            expr = _expr
        ]
    }

    def public static Expression newConcatExpression(List<Expression> _expressions)
    {
        if (optimizeConstraints)
        {
            val exprIt = _expressions.iterator
            var allClear = true
            var resultBitString = ""
            while (allClear && exprIt.hasNext)
            {
                val expr = exprIt.next
                if (expr instanceof ConstBooleanExpression)
                {
                    if (expr.value)
                    {
                        resultBitString += "1"
                    }
                    else
                    {
                        resultBitString += "0"
                    }
                }
                else if (expr instanceof BitstringExpression)
                {
                    resultBitString += expr.value
                }
                else if (expr instanceof ConstIntegerExpression)
                {
                    if (0<= expr.value && expr.value <= 255)
                    {
                        val exprBitString = numberToBinaryString(expr.value, expr.width)
                        resultBitString += exprBitString
                    }
                    else
                    {
                        allClear = false
                    }
                }
                else
                {
                    allClear = false
                }
            }
            if (allClear)
            {
                return resultBitString.newBitstringExpression
            }
        }
        return factory.createConcatExpression => [
            expressions += _expressions
        ]
    }

    def public static Expression newConstIntegerExpression
    (
        int _value,
        int _width
    )
    {
        //TODO value width problem
        factory.createConstIntegerExpression => [
            value = _value
            width = _width
        ]
    }

    def public static Expression newConstBooleanExpression(boolean _value)
    {
        factory.createConstBooleanExpression => [
            value = _value
        ]
    }

    def public static Expression newEqualsExpression
    (
        Expression lhsExpr,
        Expression rhsExpr
    )
    {
        if (optimizeConstraints)
        {
            if (    lhsExpr instanceof ConstBooleanExpression
                 && rhsExpr instanceof ConstBooleanExpression)
            {
                val lhsValue = (lhsExpr as ConstBooleanExpression).value
                val rhsValue = (rhsExpr as ConstBooleanExpression).value
                return newConstBooleanExpression(lhsValue == rhsValue)
            }
            else if (lhsExpr instanceof ConstIntegerExpression)
            {
                if (rhsExpr instanceof ConstIntegerExpression)
                {
                    if (lhsExpr.width == rhsExpr.width)
                    {
                        return newConstBooleanExpression(lhsExpr.value == rhsExpr.value)
                    }
                    else
                    {
                        throw new IllegalArgumentException
                    }
                }
                else if (rhsExpr instanceof BitstringExpression)
                {
                    if (lhsExpr.width == rhsExpr.value.length)
                    {
                        val lhsBitString = numberToBinaryString(lhsExpr.value, lhsExpr.width)
                        return newConstBooleanExpression(lhsBitString.equals(rhsExpr.value))
                    }
                    else
                    {
                        throw new IllegalArgumentException
                    }
                }
            }
            else if (lhsExpr instanceof BitstringExpression)
            {
                if (rhsExpr instanceof ConstIntegerExpression)
                {
                    if (lhsExpr.value.length == rhsExpr.width)
                    {
                        val rhsBitString = numberToBinaryString(rhsExpr.value, rhsExpr.width)
                        return newConstBooleanExpression(lhsExpr.value.equals(rhsBitString))
                    }
                    else
                    {
                        throw new IllegalArgumentException
                    }
                }
                else if (rhsExpr instanceof BitstringExpression)
                {
                    if (lhsExpr.value.length == rhsExpr.value.length)
                    {
                        return newConstBooleanExpression(lhsExpr.value.equals(rhsExpr.value))
                    }
                    else
                    {
                        throw new IllegalArgumentException
                    }
                }
            }
        }
        return factory.createEqualsExpression => [
            lhs = lhsExpr
            rhs = rhsExpr
        ]
    }

    def public static Expression newExtractIndexExpression
    (
        Expression _expr,
        int _index
    )
    {
        if (optimizeConstraints)
        {
            if (_expr instanceof ConstIntegerExpression)
            {
                 val exprBitString = numberToBinaryString(_expr.value, _expr.width)
                 if (exprBitString.length > _index)
                 {
                     return exprBitString.reverse.substring(_index, _index+1).newBitstringExpression
                 }
                 else
                 {
                     throw new IllegalArgumentException
                 }
            }
            else if (_expr instanceof BitstringExpression)
            {
                val exprBitString = _expr.value
                if (exprBitString.length > _index)
                {
                    return exprBitString.reverse.substring(_index, _index+1).newBitstringExpression
                }
                else
                {
                    throw new IllegalArgumentException
                }
            }
        }
        return factory.createExtractIndexExpression=> [
            expr = _expr
            start = _index
            end = _index
        ]
    }

    def public static Expression newExtractIndexExpression
    (
        Expression _expr,
        int _start,
        int _end
    )
    {
        if (optimizeConstraints)
        {
            if (_expr instanceof ConstIntegerExpression)
            {
                 val exprBitString = numberToBinaryString(_expr.value, _expr.width)
                 if (exprBitString.length > _end)
                 {
                     return exprBitString.reverse.substring(_start, _end+1).newBitstringExpression
                 }
                 else
                 {
                     throw new IllegalArgumentException
                 }
            }
            else if (_expr instanceof BitstringExpression)
            {
                val exprBitString = _expr.value
                 if (exprBitString.length > _end)
                 {
                     return exprBitString.reverse.substring(_start, _end+1).newBitstringExpression
                 }
                 else
                 {
                     throw new IllegalArgumentException
                 }
            }
        }
        return factory.createExtractIndexExpression=> [
            expr = _expr
            start = _start
            end = _end
        ]
    }

    def public static Expression newImpliesExpression
    (
        Expression lhsExpr,
        Expression rhsExpr
    )
    {
        if (optimizeConstraints)
        {
            if (lhsExpr instanceof ConstBooleanExpression)
            {
                val lhsValue = (lhsExpr as ConstBooleanExpression).value
                if (lhsValue)
                {
                    return rhsExpr
                }
                if (rhsExpr instanceof ConstBooleanExpression)
                {
                    val rhsValue = (rhsExpr as ConstBooleanExpression).value
                    return (lhsValue <= rhsValue).newConstBooleanExpression
                }
            }
            if (rhsExpr instanceof ConstBooleanExpression)
            {
                val rhsValue = (rhsExpr as ConstBooleanExpression).value
                if (rhsValue)
                {
                    return true.newConstBooleanExpression
                }
            }
        }
        return factory.createImpliesExpression => [
            lhs = lhsExpr
            rhs = rhsExpr
        ]
    }

    def public static Expression newLessExpression
    (
        Expression lhsExpr,
        Expression rhsExpr
    )
    {
        if (    optimizeConstraints
             && lhsExpr instanceof ConstIntegerExpression
             && rhsExpr instanceof ConstIntegerExpression)
        {
            val lhsWidth = (lhsExpr as ConstIntegerExpression).width
            val rhsWidth = (rhsExpr as ConstIntegerExpression).width
            if (lhsWidth == rhsWidth)
            {
                val lhsValue = (lhsExpr as ConstIntegerExpression).value
                val rhsValue = (rhsExpr as ConstIntegerExpression).value
                return (lhsValue < rhsValue).newConstBooleanExpression
            }
            else
            {
                throw new IllegalArgumentException
            }
        }
        return factory.createLessExpression => [
            lhs = lhsExpr
            rhs = rhsExpr
        ]
    }

    def public static Expression newLessEqualsExpression
    (
        Expression lhsExpr,
        Expression rhsExpr
    )
    {
        if (    optimizeConstraints
             && lhsExpr instanceof ConstIntegerExpression
             && rhsExpr instanceof ConstIntegerExpression)
        {
            val lhsWidth = (lhsExpr as ConstIntegerExpression).width
            val rhsWidth = (rhsExpr as ConstIntegerExpression).width
            if (lhsWidth == rhsWidth)
            {
                val lhsValue = (lhsExpr as ConstIntegerExpression).value
                val rhsValue = (rhsExpr as ConstIntegerExpression).value
                return (lhsValue <= rhsValue).newConstBooleanExpression
            }
            else
            {
                throw new IllegalArgumentException
            }
        }
        return factory.createLessEqualsExpression => [
            lhs = lhsExpr
            rhs = rhsExpr
        ]
    }


    def public static Expression newGreaterEqualsExpression
    (
        Expression lhsExpr,
        Expression rhsExpr
    )
    {
        if (    optimizeConstraints
             && lhsExpr instanceof ConstIntegerExpression
             && rhsExpr instanceof ConstIntegerExpression)
        {
            val lhsWidth = (lhsExpr as ConstIntegerExpression).width
            val rhsWidth = (rhsExpr as ConstIntegerExpression).width
            if (lhsWidth == rhsWidth)
            {
                val lhsValue = (lhsExpr as ConstIntegerExpression).value
                val rhsValue = (rhsExpr as ConstIntegerExpression).value
                return (lhsValue >= rhsValue).newConstBooleanExpression
            }
            else
            {
                throw new IllegalArgumentException
            }
        }
        return factory.createGreaterEqualsExpression => [
            lhs = lhsExpr
            rhs = rhsExpr
        ]
    }

    def public static Expression newGreaterExpression
    (
        Expression lhsExpr,
        Expression rhsExpr
    )
    {
        if (    optimizeConstraints
             && lhsExpr instanceof ConstIntegerExpression
             && rhsExpr instanceof ConstIntegerExpression)
        {
            val lhsWidth = (lhsExpr as ConstIntegerExpression).width
            val rhsWidth = (rhsExpr as ConstIntegerExpression).width
            if (lhsWidth == rhsWidth)
            {
                var lhsValue = (lhsExpr as ConstIntegerExpression).value
                var rhsValue = (rhsExpr as ConstIntegerExpression).value
                if (lhsValue < 0)
                {
                    lhsValue = lhsValue + 256
                }
                if (rhsValue < 0)
                {
                    rhsValue = rhsValue + 256
                }
                val result = lhsValue > rhsValue
                return (result).newConstBooleanExpression
            }
            else
            {
                throw new IllegalArgumentException
            }
        }
        return factory.createGreaterExpression => [
            lhs = lhsExpr
            rhs = rhsExpr
        ]
    }

    def public static Expression newIteExpression
    (
        Expression conditionExpr,
        Expression thenExpr,
        Expression elseExpr
    )
    {
        if (optimizeConstraints)
        {
            if (conditionExpr instanceof ConstBooleanExpression)
            {
                if (conditionExpr.value)
                {
                    return thenExpr
                }
                else
                {
                    return elseExpr
                }
            }
            else if (    thenExpr instanceof ConstBooleanExpression
                      && elseExpr instanceof ConstBooleanExpression)
            {
                val thenExprValue = (thenExpr as ConstBooleanExpression).value
                val elseExprValue = (thenExpr as ConstBooleanExpression).value
                if (thenExprValue && elseExprValue)
                {
                    return true.newConstBooleanExpression
                }
                else if ((!thenExprValue) && (!elseExprValue))
                {
                    return false.newConstBooleanExpression
                }
            }
        }
        return factory.createIteExpression => [
            condition = conditionExpr
            thenexpr  = thenExpr
            elseexpr  = elseExpr
        ]
    }

    def public static List<Expression> getVariableExpressions(List<Variable> variables)
    {
        variables.map[variableExpression(it)]
    }

    def private static checkingK(int k)
    {
        if (   k < 0
            || k == Integer.MAX_VALUE
            || k == Integer.MIN_VALUE
        )
        {
            throw new IllegalArgumentException("Trying to create a new cardinality"
                + "constraint with k = "+k)
        }
    }

    def public static Expression newCardEqExpression
    (
        List<Expression> _expressions,
        int _k
    )
    {
        checkingK(_k)
        factory.createCardEqExpression => [
            k = _k
            expressions += _expressions
        ]
    }

    def public static Expression newCardEqExpression
    (
        int _k,
        List<Variable> _variables
    )
    {
        checkingK(_k)
        factory.createCardEqExpression => [
            k = _k
            expressions +=
                _variables.getVariableExpressions
                          .map[it as VariableExpression]
        ]
    }

    def public static Expression newCardGeExpression
    (
        List<Expression> _expressions,
        int _k
    )
    {
        checkingK(_k)
        factory.createCardGeExpression => [
            k = _k
            expressions += _expressions
        ]
    }

    def public static Expression newCardGeExpression
    (
        int _k,
        List<Variable> _variables
    )
    {
        checkingK(_k)
        factory.createCardGeExpression => [
            k = _k
            expressions +=
                _variables.getVariableExpressions
                          .map[it as VariableExpression]
        ]
    }

    def public static Expression newCardGtExpression
    (
        List<Expression> _expressions,
        int _k
    )
    {
        checkingK(_k)
        factory.createCardGtExpression => [
            k = _k
            expressions += _expressions
        ]
    }

    def public static Expression newCardGtExpression
    (
        int _k,
        List<Variable> _variables
    )
    {
        checkingK(_k)
        factory.createCardGtExpression => [
            k = _k
            expressions +=
                _variables.getVariableExpressions
                          .map[it as VariableExpression]
        ]
    }

    def public static Expression newCardLeExpression
    (
        List<Expression> _expressions,
        int _k
    )
    {
        checkingK(_k)
        factory.createCardLeExpression => [
            k = _k
            expressions += _expressions
        ]
    }

    def public static Expression newCardLeExpression
    (
        int _k,
        List<Variable> _variables
    )
    {
        checkingK(_k)
        factory.createCardLeExpression => [
            k = _k
            expressions +=
                _variables.getVariableExpressions
                          .map[it as VariableExpression]
        ]
    }

    def public static Expression newCardLtExpression
    (
        List<Expression> _expressions,
        int _k
    )
    {
        checkingK(_k)
        factory.createCardLtExpression => [
            k = _k
            expressions += _expressions
        ]
    }

    def public static Expression newCardLtExpression
    (
        int _k,
        List<Variable> _variables
    )
    {
        checkingK(_k)
        factory.createCardLeExpression => [
            k = _k
            expressions +=
                _variables.getVariableExpressions
                          .map[it as VariableExpression]
        ]
    }

    def public static Expression newNotExpression(Expression _expr)
    {
        if (    optimizeConstraints
             && _expr instanceof ConstBooleanExpression)
        {
            val lhsValue = (_expr as ConstBooleanExpression).value
            return (!lhsValue).newConstBooleanExpression
        }
        return factory.createNotExpression => [
            expr = _expr
        ]
    }

    def public static String getOneHotBitstring
    (
        int bitWidth,
        int index
    )
    {
        if (    index <  0
            ||  index >= bitWidth)
        {
            throw new IllegalArgumentException("Trying to create a OneHotBitstring "
                + "with bitWidth of "+bitWidth+" with the index "+index)
        }
        (0..<bitWidth).map[if (it == index) "1" else "0"]
                      .fold("", [a, b | b + a ]) // for the 0th bit at the end!
    }

    def public static Expression newOneHotExpression(Expression _expr)
    {
        factory.createOneHotExpression => [
            expr = _expr
        ]
    }

    def public static Expression newOrExpression(List<Expression> exprList)
    {
        if (optimizeConstraints)
        {
            val exprListIt = exprList.iterator
            var allConstFalse = true
            val List<Expression> shortenedExprList = new ArrayList
            while (exprListIt.hasNext)
            {
                val expr = exprListIt.next
                if (expr instanceof ConstBooleanExpression)
                {
                   if (expr.value)
                   {
                       return true.newConstBooleanExpression
                   }
                }
                else
                {
                    shortenedExprList += expr
                    allConstFalse = false
                }
            }
            if (allConstFalse)
            {
                return false.newConstBooleanExpression
            }
            return factory.createOrExpression => [
                expressions += shortenedExprList
            ]
        }
        return factory.createOrExpression => [
            expressions += exprList
        ]
    }

    def public static Expression newVariableExpression(Variable variable)
    {
        variableExpression(variable)
    }

    /**
     * @brief Appends the specified variable to the instance.
     * 
     * @param instance The instance which should enriched with a new variable
     * @param variable The variable which should be added
     */
    def public static boolean addVariable
    (
        Instance instance,
        Variable variable
    )
    {
        instance.variables.add(variable)
    }

    /**
     * @brief Appends the specified assertion to the instance.
     * 
     * @param instance The instance which should enriched with a new assertion
     * @param assertion The assertion which should be added
     */
    def public static boolean addAssertion
    (
        Instance instance,
        Expression assertion
    )
    {
        instance.assertions.add(assertion)
    }

    /**
     * @brief Finds the first variable in the given instance that has varname as name.
     *        If none is found or the list of variables is empty, null is returned.
     *
     * @param instance The instance which should be scanned
     * @param varname The name of the desired variable
     *
     * @return The first variable in the list of variables of the given instance
     *         which has the varname as name, null if no element matches the predicate
     *         or the iterable is empty.getVariable returns the first
     */
    def public static Variable getVariable
    (
        Instance instance,
        String varname
    )
    {
        instance.variables.findFirst[it.name == varname]
    }

    /**
     * Return a Variable with the given name.
     *
     * @param instance The instance which should be scanned
     * @param varname The name of the desired variable
     *
     * @return The first variable in the list of variables of the given instance
     *         which has the varname as name.
     *         If no such variable exists so far, a new precidate will be created
     *         which has varname as name. Furthermore the variable will be automatically
     *         added to the given instance, before it will be returned as Variable
     */
    def public static  Variable getAMaybeCreatedPredicate
    (
        Instance instance,
        String varname
    )
    {
        val firstFound = instance.variables.findFirst[it.name == varname]
        if (firstFound == null)
        {
            val tmp = factory.createPredicate => [
                name = varname
            ]
            instance.variables.add(tmp)
            return tmp
        }
        firstFound
    }

    /**
     * Return a Variable with the given name.
     *
     * @param instance The instance which should be scanned
     * @param varname The name of the desired variable
     * @param bitWidth The bitwidth for the probably new bitvector
     *
     * @return The first variable in the list of variables of the given instance
     *         which has the varname as name.
     *         If no such variable exists so far, a new bitvector will be created
     *         which has varname as name and the given bitWidth as width. Furthermore
     *         the variable will be automatically added to the given instance, before
     *         it will be returned as Variable.
     */
    def public static Variable getAMaybeCreatedBitvector
    (
        Instance instance,
        String varname,
        int bitWidth
    )
    {
        val firstFound = instance.variables.findFirst[it.name == varname]
        if (firstFound == null)
        {
            val tmp = factory.createBitvector => [
                name = varname
                width = bitWidth
            ]
            instance.variables.add(tmp)
            return tmp
        }
        firstFound
    }

    def public static Expression getVariableExpression
    (
        Instance instance,
        String varname
    )
    {
        factory.createVariableExpression => [
            variable = instance.getVariable(varname)
        ]
    }

    def public static EList<Expression> expressionEList(Expression expression)
    {
        val result = new BasicEList<Expression>
        switch(expression) {
            IteExpression: {
                result += expressionEList( expression.condition )
                result += expressionEList( expression.getThenexpr )
                result += expressionEList( expression.getElseexpr )
                return result
            }
            UnaryExpression: {
                result += expression.expr
                return result
            }
            BinaryExpression: {
                result += expression.lhs
                result += expression.rhs
                return result
            }
            NAryExpression: {
                expression.expressions.forEach[
                    result += expressionEList( it )
                ]
                return result
            }
            default: {
                result += expression
                return result
//                throw new Exception("Implement me for " + expression.class.name)
            }
        }
    }
}