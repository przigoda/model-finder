package de.agra.emf.modelfinder.encoding.fourValuedOCL.utils

import org.eclipse.ocl.expressions.OperationCallExp
import org.eclipse.emf.ecore.EOperation

interface OperationCallExpSwitch<T>
{
    def T doSwitch(OperationCallExp<?, EOperation> object)
    {
        switch (object.referredOperation.name)
        {
            case "allInstances":
                caseAllInstances(object)
            case "not":
                caseNot(object)
            case "and":
                caseAnd(object)
            case "or":
                caseOr(object)
            case "xor":
                caseXor(object)
            case "implies":
                caseImplies(object)
            case "=":
                caseEquals(object)
            case "<>":
                caseUnequals(object)
            case "<":
                caseLess(object)
            case "<=":
                caseLessOrEquals(object)
            case ">=":
                caseGreaterOrEquals(object)
            case ">":
                caseGreater(object)
            case "+":
                caseAdd(object)
            case "-":
                caseSubtract(object)
            case "*":
                caseMultiply(object)
            case "/":
                caseDivide(object)
            case "mod":
                caseModulo(object)
            case "min":
                caseMin(object)
            case "max":
                caseMax(object)
            case "size":
                caseSize(object)
            case "oclIsUndefined":
                caseOclIsUndefined(object)
            case "isEmpty":
                caseIsEmpty(object)
            case "notEmpty":
                caseNotEmpty(object)
            case "includes":
                caseIncludes(object)
            case "includesAll":
                caseIncludesAll(object)
            case "including":
                caseIncluding(object)
            case "excludes":
                caseExcludes(object)
            case "excludesAll":
                caseExcludesAll(object)
            case "excluding":
                caseExcluding(object)
            case "intersection":
                caseIntersection(object)
            case "union":
                caseUnion(object)
            case "asSet":
                caseAsSet(object)
            case "asBag":
                caseAsBag(object)
            case "asOrderedSet":
                caseAsOrderedSet(object)
            case "asSequence":
                caseAsSequence(object)
            case "oclIsTypeOf":
                caseOclIsTypeOf(object)
            case "oclAsType":
                caseOclAsType(object)
            case "oclIsNew":
                caseOclIsNew(object)
            default: {
                // TODO throw?
//                throw new UnsupportedOperationException
            }
        }
    }

    def T caseAllInstances(OperationCallExp<?, EOperation> exp)

    def T caseNot(OperationCallExp<?, EOperation> exp)
    def T caseAnd(OperationCallExp<?, EOperation> exp)
    def T caseOr(OperationCallExp<?, EOperation> exp)
    def T caseImplies(OperationCallExp<?, EOperation> exp)
    def T caseXor(OperationCallExp<?, EOperation> exp)

    def T caseEquals(OperationCallExp<?, EOperation> exp)

    def T caseGreater(OperationCallExp<?, EOperation> exp)
    def T caseGreaterOrEquals(OperationCallExp<?, EOperation> exp)
    def T caseLessOrEquals(OperationCallExp<?, EOperation> exp)
    def T caseLess(OperationCallExp<?, EOperation> exp)
    def T caseUnequals(OperationCallExp<?, EOperation> exp)

    def T caseAdd(OperationCallExp<?, EOperation> exp)
    def T caseSubtract(OperationCallExp<?, EOperation> exp)
    def T caseMultiply(OperationCallExp<?, EOperation> exp)
    def T caseDivide(OperationCallExp<?, EOperation> exp)
    def T caseModulo(OperationCallExp<?, EOperation> exp)

    def T caseMax(OperationCallExp<?, EOperation> exp)
    def T caseMin(OperationCallExp<?, EOperation> exp)

    def T caseSize(OperationCallExp<?, EOperation> exp)
    
    def T caseIsEmpty(OperationCallExp<?, EOperation> exp)
    def T caseNotEmpty(OperationCallExp<?, EOperation> exp)

    def T caseAsSet(OperationCallExp<?, EOperation> exp)
    def T caseAsBag(OperationCallExp<?, EOperation> exp)
    def T caseAsOrderedSet(OperationCallExp<?, EOperation> exp)
    def T caseAsSequence(OperationCallExp<?, EOperation> exp)

    def T caseUnion(OperationCallExp<?, EOperation> exp)
    def T caseIntersection(OperationCallExp<?, EOperation> exp)

    def T caseExcluding(OperationCallExp<?, EOperation> exp)
    def T caseExcludesAll(OperationCallExp<?, EOperation> exp)
    def T caseExcludes(OperationCallExp<?, EOperation> exp)

    def T caseIncluding(OperationCallExp<?, EOperation> exp)
    def T caseIncludesAll(OperationCallExp<?, EOperation> exp)
    def T caseIncludes(OperationCallExp<?, EOperation> exp)

    def T caseOclIsUndefined(OperationCallExp<?, EOperation> exp)

    def T caseOclIsNew(OperationCallExp<?, EOperation> exp)
    def T caseOclAsType(OperationCallExp<?, EOperation> exp)
    def T caseOclIsTypeOf(OperationCallExp<?, EOperation> exp)
}
