package de.agra.emf.modelfinder.encoding.fourValuedOCL.utils

import de.agra.emf.metamodels.SMTlib2extended.Expression
import de.agra.emf.metamodels.SMTlib2extended.Instance
import de.agra.emf.modelfinder.statesequence.state.StateResource
import java.util.Map
import org.eclipse.emf.ecore.EObject
import org.eclipse.ocl.expressions.BooleanLiteralExp
import org.eclipse.ocl.expressions.OperationCallExp
import org.eclipse.ocl.expressions.util.ExpressionsSwitch
import org.eclipse.xtend.lib.annotations.Accessors

import static de.agra.emf.metamodels.SMTlib2extended.util.MetaModelExtensions.*
import org.eclipse.emf.ecore.EOperation
import org.eclipse.ocl.expressions.IfExp

import static de.agra.emf.modelfinder.encoding.LoadParametersExtensions.*
import org.eclipse.ocl.expressions.IntegerLiteralExp

class OCLExpression2SMTLIBExpressionSwitch extends ExpressionsSwitch<Expression>
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

    override caseBooleanLiteralExp(BooleanLiteralExp object)
    {
        newConstBooleanExpression(object.booleanSymbol)
    }

    override caseIntegerLiteralExp(IntegerLiteralExp object)
    {
        newConstIntegerExpression
        (
            object.integerSymbol,
            intBitwidth
        )
    }

    override caseIfExp(IfExp object)
    {
        return newIteExpression
        (
            doSwitch(object.condition),
            doSwitch(object.thenExpression),
            doSwitch(object.elseExpression)
        )
    }

    override Expression caseOperationCallExp(OperationCallExp object)
    {
        val switcherOCLOperationCall2SMTLIB = new OperationCallExpSwitchSMTLIB
        (
            instance,
            state,
            varmap
        )
        switcherOCLOperationCall2SMTLIB.doSwitch(object)
        
//        OperationCallExpressionsExtensions.encodeOperationCallExpression
//        (
//            instance,
//            state,
//            object,
//            varmap
//        )
    }
}
