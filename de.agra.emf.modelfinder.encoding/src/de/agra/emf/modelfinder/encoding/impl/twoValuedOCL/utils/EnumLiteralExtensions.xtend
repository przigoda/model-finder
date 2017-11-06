package de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.utils

import de.agra.emf.metamodels.SMTlib2extended.Expression
import de.agra.emf.metamodels.SMTlib2extended.Instance
import de.agra.emf.modelfinder.statesequence.state.StateResource
import de.agra.emf.modelfinder.utils.MathUtilsExtensions
import org.eclipse.emf.ecore.EEnum
import org.eclipse.emf.ecore.EEnumLiteral
import org.eclipse.ocl.expressions.EnumLiteralExp

import static extension de.agra.emf.metamodels.SMTlib2extended.util.MetaModelExtensions.*

class EnumLiteralExtensions {

    def static Expression encodeEnumLiteral
    (
        Instance instance,
        StateResource state,
        EnumLiteralExp expression
    )
    {
        val enumLiteralValue = expression.referredEnumLiteral as EEnumLiteral
        val enumContainer = enumLiteralValue.eContainer as EEnum
        val literals = enumContainer.getELiterals
        val noOfLiterals = literals.size
        val bitwidth = MathUtilsExtensions.bitwidth(noOfLiterals)
        val literalsIt = literals.iterator
        var index = 0
        while (literalsIt.hasNext)
        {
            val literal = literalsIt.next
            if (literal.equals(enumLiteralValue))
            {
                val res = index.newConstIntegerExpression(bitwidth)
                res.name = "enum foo"
                return res
            }
            index++
        }
        throw new Exception("Could not find a value for the literals")
    }
}
