package de.agra.emf.metamodels.SMTlib2extended.conversion

import de.agra.emf.metamodels.SMTlib2extended.AddExpression
import de.agra.emf.metamodels.SMTlib2extended.AndExpression
import de.agra.emf.metamodels.SMTlib2extended.BinaryExpression
import de.agra.emf.metamodels.SMTlib2extended.BitstringExpression
import de.agra.emf.metamodels.SMTlib2extended.Bitvector
import de.agra.emf.metamodels.SMTlib2extended.BvAndExpression
import de.agra.emf.metamodels.SMTlib2extended.BvNotExpression
import de.agra.emf.metamodels.SMTlib2extended.BvOrExpression
import de.agra.emf.metamodels.SMTlib2extended.BvXorExpression
import de.agra.emf.metamodels.SMTlib2extended.CardEqExpression
import de.agra.emf.metamodels.SMTlib2extended.CardGeExpression
import de.agra.emf.metamodels.SMTlib2extended.CardGtExpression
import de.agra.emf.metamodels.SMTlib2extended.CardLeExpression
import de.agra.emf.metamodels.SMTlib2extended.CardLtExpression
import de.agra.emf.metamodels.SMTlib2extended.ConstBooleanExpression
import de.agra.emf.metamodels.SMTlib2extended.ConstIntegerExpression
import de.agra.emf.metamodels.SMTlib2extended.DivExpression
import de.agra.emf.metamodels.SMTlib2extended.EqualsExpression
import de.agra.emf.metamodels.SMTlib2extended.Expression
import de.agra.emf.metamodels.SMTlib2extended.ExtractIndexExpression
import de.agra.emf.metamodels.SMTlib2extended.GreaterEqualsExpression
import de.agra.emf.metamodels.SMTlib2extended.GreaterExpression
import de.agra.emf.metamodels.SMTlib2extended.ImpliesExpression
import de.agra.emf.metamodels.SMTlib2extended.IteExpression
import de.agra.emf.metamodels.SMTlib2extended.LessEqualsExpression
import de.agra.emf.metamodels.SMTlib2extended.LessExpression
import de.agra.emf.metamodels.SMTlib2extended.ModExpression
import de.agra.emf.metamodels.SMTlib2extended.MulExpression
import de.agra.emf.metamodels.SMTlib2extended.NotExpression
import de.agra.emf.metamodels.SMTlib2extended.OneHotExpression
import de.agra.emf.metamodels.SMTlib2extended.OrExpression
import de.agra.emf.metamodels.SMTlib2extended.Predicate
import de.agra.emf.metamodels.SMTlib2extended.SMTlib2extendedFactory
import de.agra.emf.metamodels.SMTlib2extended.SubExpression
import de.agra.emf.metamodels.SMTlib2extended.UnaryExpression
import de.agra.emf.metamodels.SMTlib2extended.Variable
import de.agra.emf.metamodels.SMTlib2extended.VariableExpression
import de.agra.emf.metamodels.SMTlib2extended.util.SMTlib2extendedSwitch
import java.util.List
import org.eclipse.emf.ecore.EObject

class SMTlib2Converter extends SMTlib2extendedSwitch<String> {
    /**
     * @brief Converts and "flattens" an expression into a smtlib2 s-expression
     * 
     * 
     * @see convert
     * 
     * @param expression The expression that is parsed into a smtlib2 s-expression
     */
    def convertCompact(Expression exp) {
        convert(exp).replace('\n', ' ')
                    .replaceAll("[ ]+", " ")
                    .replaceAll(" ,", ",").trim
    }

    def private String addName(Expression expr, String s)
    {
//        if (expr.name != null && expr.name != "")
//            return '''(! «s» :named «expr.name»)'''
        return s
    }

    def convert(Expression exp) {
        exp.addName(doSwitch(exp))
    }

    override caseSubExpression(SubExpression exp) {
        simpleExp("bvsub", exp)
    }

    override caseUnaryExpression(UnaryExpression exp) {
        throw new UnsupportedOperationException("(SMTlib2Converter) Not implemented UnaryExpression: " + exp.^class.name)
    }

    override caseBinaryExpression(BinaryExpression exp) {
        throw new UnsupportedOperationException(
            "(SMTlib2Converter) Not implemented BinaryExpression: " + exp.^class.name)
    }

    override caseExtractIndexExpression(ExtractIndexExpression object) {
        '''((_ extract «object.end» «object.start») «convert(object.expr)»)'''
    }

    override caseBitstringExpression(BitstringExpression object) {
        '''#b«object.value»'''
    }

    override caseVariableExpression(VariableExpression exp) {
        if (exp.variable == null) {
            throw new Exception("VariableExpression does not contain a variable!")
        }
        '''«exp.variable.name.toString»'''
    }

    override caseConstIntegerExpression(ConstIntegerExpression exp) {
//        return exp.toString
        if (exp.eIsProxy()) return super.toString();
        val String result = "(_ bv"+exp.value+" "+exp.width+")";
        return result;
    }

    override caseDivExpression(DivExpression exp) {
        simpleExp("bvudiv", exp)
    }

    override caseModExpression(ModExpression exp) {
        simpleExp("bvurem", exp)
    }

    override caseOrExpression(OrExpression exp) {
        if (exp.expressions.size == 0) {
            throw new Exception("There is an Or-Expression with an empty expressions list")
        } else if (exp.expressions.size == 1) {
            convert(exp.expressions.head)
        } else {
            '''(or «exp.expressions.map[convert(it)].join(" ")»)'''
        }
    }

    override caseAndExpression(AndExpression exp) {
        if (exp.expressions.size == 0) {
            throw new Exception("There is an And-Expression with an empty expressions list")
        } else if (exp.expressions.size == 1) {
            convert(exp.expressions.head)
        } else {
            '''(and «exp.expressions.map[convert(it)].join(" ")»)'''
        }
    }

    override caseConstBooleanExpression(ConstBooleanExpression exp) {
        if (exp.eIsProxy()) return super.toString();
        if (exp.value) return "true";
        return "false";
    }

    def private mapExpressions (List<Expression> expressions) {
        expressions.map[ v |
            if (v instanceof VariableExpression) {
                if (v.variable instanceof Predicate) {
                    v.variable.name
                } else if (v.variable instanceof Bitvector){
                    val bitvector = (v.variable as Bitvector)
                    (0..<bitvector.width).map[ i |
                        SMTlib2extendedFactory::eINSTANCE.createExtractIndexExpression => [
                            expr = v
                            start = i
                            end = i
                        ]
                    ].map[convert(it)].join(" ")
                } else {
                    throw new Exception("invalid VariableExpression in a cardinality expression: " + v.variable.^class)
                }
            } else {
                convert(v)
            }
        ].join(" ")
    }

    override caseCardEqExpression(CardEqExpression exp) {
        if (exp.expressions.size == 0) {
            throw new Exception("There is a Cardinality-Expression (type: eq) with an empty expressions list")
        } else {
            '''((_ card_eq «exp.k») «mapExpressions(exp.expressions)»)'''
        }
    }

    override caseCardGeExpression(CardGeExpression exp) {
        if (exp.expressions.size == 0) {
            throw new Exception("There is a Cardinality-Expression (type: ge) with an empty expressions list")
        } else {
            '''((_ card_ge «exp.k») «mapExpressions(exp.expressions)»)'''
        }
    }

    override caseCardGtExpression(CardGtExpression exp) {
        if (exp.expressions.size == 0) {
            throw new Exception("There is a Cardinality-Expression (type: gt) with an empty expressions list")
        } else {
            '''((_ card_gt «exp.k») «mapExpressions(exp.expressions)»)'''
        }
    }

    override caseCardLeExpression(CardLeExpression exp) {
        if (exp.expressions.size == 0) {
            throw new Exception("There is a Cardinality-Expression (type: le) with an empty expressions list")
        } else {
            '''((_ card_le «exp.k») «mapExpressions(exp.expressions)»)'''
        }
    }

    override caseCardLtExpression(CardLtExpression exp) {
        if (exp.expressions.size == 0) {
            throw new Exception("There is a Cardinality-Expression (type: lt) with an empty expressions list")
        } else {
            '''((_ card_lt «exp.k») «mapExpressions(exp.expressions)»)'''
        }
    }

    override defaultCase(EObject object) {
        throw new UnsupportedOperationException("(SMTlib2Converter) Not implemented: " + object.^class.name)
    }

    override caseImpliesExpression(ImpliesExpression exp) {
        simpleExp("=>", exp)
    }

    override caseIteExpression(IteExpression exp) {
        '''(ite «convert(exp.condition)» «convert(exp.thenexpr)» «convert(exp.elseexpr)»)'''
    }

    override caseEqualsExpression(EqualsExpression exp) {
        simpleExp("=", exp)
    }

    override caseLessEqualsExpression(LessEqualsExpression exp) {
        simpleExp("bvule", exp)
    }

    override caseLessExpression(LessExpression exp) {
        simpleExp("bvult", exp)
    }

    override caseGreaterEqualsExpression(GreaterEqualsExpression exp) {
        simpleExp("bvuge", exp)
    }

    override caseGreaterExpression(GreaterExpression exp) {
        simpleExp("bvugt", exp)
    }

    override caseBvNotExpression(BvNotExpression exp) {
        '''(bvnot «convert(exp.expr)»)'''
    }

    override caseBvAndExpression(BvAndExpression exp) {
        simpleExp("bvand", exp) 
    }

     override caseBvOrExpression(BvOrExpression exp) {
        simpleExp("bvor", exp) 
    }

     override caseBvXorExpression(BvXorExpression exp) {
        simpleExp("bvxor", exp) 
    }

    override caseAddExpression(AddExpression exp) {
        simpleExp("bvadd", exp)
    }

    override caseMulExpression(MulExpression exp) {
        simpleExp("bvmul", exp)
    }

    override caseNotExpression(NotExpression exp) {
        '''(not «convert(exp.expr)»)'''
    }

  override caseOneHotExpression(OneHotExpression exp) {
    if (exp.expr instanceof VariableExpression) {
      val inner = ((exp.expr) as VariableExpression).variable 
      if (! (inner instanceof Bitvector)) throw new Exception("inner of one-hot-expression must be a bit-vector")
      val innerbv = inner as Bitvector
      val count = innerbv.width
      val retexpr = (0..<count)
                  .map['''#b«"0" * it»1«"0" * (count - it - 1)»''']
                  .map[''' (= «convert(exp.expr)» «it»)''']
                  .reduce[a, b | a + b]
        return ("(or " + retexpr + ")")
    }
    else
      throw new UnsupportedOperationException("(SMTlib2Converter) Not implemented OneHotExpression: " + exp.^class.name)
  }

    def variableExpression(SMTlib2extendedFactory factory, Variable _variable) {
        factory.createVariableExpression => [
            variable = _variable
        ]
    }
    def constIntegerExpression(SMTlib2extendedFactory factory, int _value, int _width) {
        factory.createConstIntegerExpression => [
            value = _value
            width = _width
        ]
    }

    def simpleExp(String name, BinaryExpression exp) {
        '''(«name» «convert(exp.lhs)» «convert(exp.rhs)»)'''.toString
    }
    
    def operator_multiply(String s, int count) {
		(0..<count).map[s].reduce[a, b | a + b] ?: ""
	}
}
