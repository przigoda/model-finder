package de.agra.emf.modelfinder.encoding.fourValuedOCL.utils

import de.agra.emf.modelfinder.encoding.fourValuedOCL.utils.OperationCallExpSwitch
import org.eclipse.ocl.expressions.OperationCallExp
import de.agra.emf.metamodels.SMTlib2extended.Expression
import org.eclipse.emf.ecore.EOperation
import de.agra.emf.metamodels.SMTlib2extended.Instance
import de.agra.emf.modelfinder.statesequence.state.StateResource
import java.util.Map
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtend.lib.annotations.Accessors

class OperationCallExpSwitchSMTLIB implements OperationCallExpSwitch<Expression>
{
    /**
     * null references are not allowed as arguments
     */
    new
    (
        Instance instance,
        StateResource state,
        Map<String, EObject> varmap
    )
    {
        this.instance = instance
        this.state = state
        this.varmap = varmap
    }

    @Accessors Instance instance
    @Accessors StateResource state
    @Accessors Map<String, EObject> varmap

    override caseAllInstances(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseNot(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseAnd(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseOr(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseImplies(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseXor(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseEquals(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseGreater(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseGreaterOrEquals(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseLessOrEquals(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseLess(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseUnequals(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseAdd(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseSubtract(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseMultiply(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseDivide(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseModulo(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseMax(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseMin(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseSize(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseIsEmpty(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseNotEmpty(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseAsSet(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseAsBag(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseAsOrderedSet(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseAsSequence(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseUnion(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseIntersection(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseExcluding(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseExcludesAll(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseExcludes(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseIncluding(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseIncludesAll(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseIncludes(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseOclIsUndefined(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseOclIsNew(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseOclAsType(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
    override caseOclIsTypeOf(OperationCallExp<?, EOperation> exp) {
        throw new UnsupportedOperationException("TODO: auto-generated method stub")
    }
    
//    override doSwitch(OperationCallExp object) {
//        throw new UnsupportedOperationException("TODO: auto-generated method stub")
//    }
}
