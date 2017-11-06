package de.agra.emf.metamodels.SMTlib2extended.util

import de.agra.emf.metamodels.SMTlib2extended.BinaryExpression
import de.agra.emf.metamodels.SMTlib2extended.Expression
import de.agra.emf.metamodels.SMTlib2extended.IteExpression
import de.agra.emf.metamodels.SMTlib2extended.NAryExpression
import de.agra.emf.metamodels.SMTlib2extended.UnaryExpression
import org.eclipse.emf.ecore.EObject

class SMTlib2extendedRewriter extends SMTlib2extendedSwitch<Expression> {
	override caseUnaryExpression(UnaryExpression expr) {
		expr.expr = doSwitch(expr.expr)
		expr
	}

	override caseBinaryExpression(BinaryExpression expr) {
		expr.lhs = doSwitch(expr.lhs)
		expr.rhs = doSwitch(expr.rhs)
		expr
	}

	override caseNAryExpression(NAryExpression expr) {
		val e = expr.expressions.map[doSwitch]
		expr.expressions.clear
		expr.expressions += e
		expr
	}

	override caseIteExpression(IteExpression expr) {
		expr.condition = doSwitch(expr.condition)
		expr.thenexpr = doSwitch(expr.thenexpr)
		expr.elseexpr = doSwitch(expr.elseexpr)
		expr
	}

	override caseExpression(Expression expr) {
		expr
	}

	override defaultCase(EObject expr) {
		if (!(expr instanceof Expression)) {
			throw new UnsupportedOperationException("Only works for Expression, not for " + expr.^class.name)
		}
	}
}