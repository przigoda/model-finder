package de.agra.emf.metamodels.SMTlib2extended.conversion

import com.microsoft.z3.BitVecExpr
import com.microsoft.z3.BoolExpr
import com.microsoft.z3.Context
import com.microsoft.z3.Expr
import com.microsoft.z3.Solver
import de.agra.emf.metamodels.SMTlib2extended.AddExpression
import de.agra.emf.metamodels.SMTlib2extended.AndExpression
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
import de.agra.emf.metamodels.SMTlib2extended.ConcatExpression
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
import de.agra.emf.metamodels.SMTlib2extended.VariableExpression
import de.agra.emf.metamodels.SMTlib2extended.util.SMTlib2extendedSwitch
import java.util.ArrayList
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtend.lib.annotations.Accessors

class Z3Converter extends SMTlib2extendedSwitch<Expr> {
    private var noOfCardinaltyConstraints = 0;
    val Context context
    @Accessors Solver solver

    new(Context context) {
        this.context = context
    }

    def convert(Expression exp) {
        doSwitch(exp)
    }

    override caseAddExpression(AddExpression exp) {
        context.mkBVAdd(convert(exp.lhs) as BitVecExpr, convert(exp.rhs) as BitVecExpr)
    }

    override caseSubExpression(SubExpression exp) {
        context.mkBVSub(convert(exp.lhs) as BitVecExpr, convert(exp.rhs) as BitVecExpr)
    }

    override caseAndExpression(AndExpression exp) {
        context.mkAnd(exp.expressions.map[convertToBool])
    }

    override caseBitstringExpression(BitstringExpression exp) {
        // TODO Maybe a bit dirty :)
        val se = context.parseSMTLIB2String('''(assert (= #b«exp.value» #b«exp.value»))''', #[], #[], #[], #[])
        se.args.get(0)
    }

    override caseConcatExpression(ConcatExpression exp) {
        switch (exp.expressions.size) {
            case 0: context.mkBVConst("empty", 0)
            case 1: convert(exp.expressions.head) as BitVecExpr
            default: {
                var c = context.mkConcat(convertToBitVec(exp.expressions.get(0)), convertToBitVec(exp.expressions.get(1)))
                for (i : 2 ..< exp.expressions.size) {
                    c = context.mkConcat(c, convertToBitVec(exp.expressions.get(i)))
                }
                c
            }
        }
    }

    override caseBvAndExpression(BvAndExpression exp) {
        context.mkBVAND(convert(exp.lhs) as BitVecExpr, convert(exp.rhs) as BitVecExpr)
    }

    override caseBvOrExpression(BvOrExpression exp) {
        context.mkBVOR(convert(exp.lhs) as BitVecExpr, convert(exp.rhs) as BitVecExpr)
    }

    override caseBvXorExpression(BvXorExpression exp) {
        context.mkBVXOR(convert(exp.lhs) as BitVecExpr, convert(exp.rhs) as BitVecExpr)
    }

    override caseBvNotExpression(BvNotExpression exp) {
        context.mkBVNot(convert(exp.expr) as BitVecExpr)
    }

    override caseConstBooleanExpression(ConstBooleanExpression exp) {
        context.mkBool(exp.value)
    }

    override caseConstIntegerExpression(ConstIntegerExpression exp) {
        context.mkBV(exp.value, exp.width)
    }

    override caseEqualsExpression(EqualsExpression exp) {
        context.mkEq(convert(exp.lhs), convert(exp.rhs))
    }

    override caseExtractIndexExpression(ExtractIndexExpression exp) {
        context.mkExtract(exp.end, exp.start, convert(exp.expr) as BitVecExpr)
    }

    override caseGreaterEqualsExpression(GreaterEqualsExpression exp) {
        context.mkBVUGE(convert(exp.lhs) as BitVecExpr, convert(exp.rhs) as BitVecExpr)
    }

    override caseGreaterExpression(GreaterExpression exp) {
        context.mkBVUGT(convert(exp.lhs) as BitVecExpr, convert(exp.rhs) as BitVecExpr)
    }

    override caseImpliesExpression(ImpliesExpression exp) {
        context.mkImplies(convertToBool(exp.lhs), convertToBool(exp.rhs))
    }

    override caseIteExpression(IteExpression exp) {
        context.mkITE(convertToBool(exp.condition), convert(exp.thenexpr), convert(exp.elseexpr))
    }

    override caseLessEqualsExpression(LessEqualsExpression exp) {
        context.mkBVULE(convert(exp.lhs) as BitVecExpr, convert(exp.rhs) as BitVecExpr)
    }

    override caseLessExpression(LessExpression exp) {
        context.mkBVULT(convert(exp.lhs) as BitVecExpr, convert(exp.rhs) as BitVecExpr)
    }

    override caseNotExpression(NotExpression exp) {
        val e = convert(exp.expr)
        if (e instanceof BitVecExpr) {
            return context.mkBVNeg( e as BitVecExpr )
        }
        context.mkNot( e as BoolExpr)
    }

    override caseOneHotExpression(OneHotExpression exp) {
        val inner = convert(exp.expr)
        if (!inner.isBV) throw new Exception("inner must be a bit-vector")
        val innerbv = inner as BitVecExpr

        val count = innerbv.sortSize
        val retexpr = (0..<count)
                      .map['''«"0" * it»1«"0" * (count - it - 1)»''']
                      .map[context.MkBitString(it)]
                      .map[context.mkEq(innerbv, it)]
        context.mkOr(retexpr)
    }

    override caseOrExpression(OrExpression exp) {
        context.mkOr(exp.expressions.map[it.convert as BoolExpr])
    }

    override caseModExpression(ModExpression exp) {
        context.mkBVURem(convert(exp.lhs) as BitVecExpr, convert(exp.rhs) as BitVecExpr)
    }

    override caseDivExpression(DivExpression exp) {
        context.mkBVUDiv(convert(exp.lhs) as BitVecExpr, convert(exp.rhs) as BitVecExpr)
    }

    override caseMulExpression(MulExpression exp) {
        context.mkBVMul(convert(exp.lhs) as BitVecExpr, convert(exp.rhs) as BitVecExpr)
    }

    override caseVariableExpression(VariableExpression exp)
    {
        Z3ConverterUtils::convertVariable(context, exp.variable)
    }

    def private String createHelperNodeName
    (
        int bitIndex,
        int helpNodeIndex
    )
    {
        return "card_const_no_"+noOfCardinaltyConstraints+
               "_bit_"+bitIndex+"_node_"+helpNodeIndex
    }

    override caseCardEqExpression(CardEqExpression exp)
    {
        /*
         * A lot of case like =0,1,max-1,max can be done more efficient!
         */
        val extractedExpression = mapExpressions( exp.expressions )
        cardinalityExpressionHelper(
            exp.k,
            extractedExpression,
            true,
            true
        )
    }

    override caseCardGeExpression(CardGeExpression exp) {
        val extractedExpression = mapExpressions( exp.expressions )
        cardinalityExpressionHelper(
            exp.k,
            extractedExpression,
            false,
            true
        )
    }

    override caseCardGtExpression(CardGtExpression exp) {
        /*
         * A lot of case like =0,1,max-1,max can be done more efficient!
         */
        val extractedExpression = mapExpressions( exp.expressions )
        cardinalityExpressionHelper(
            exp.k+1,
            extractedExpression,
            false,
            true
        )
    }

    override caseCardLtExpression(CardLtExpression exp) {
        /*
         * A lot of case like =0,1,max-1,max can be done more efficient!
         */
        val extractedExpression = mapExpressions( exp.expressions )
        cardinalityExpressionHelper(
            exp.k,
            extractedExpression,
            false,
            false
        )
    }

    override caseCardLeExpression(CardLeExpression exp) {
        /*
         * A lot of case like sum=0,1,max-1,max can be done more efficient!
         */
        val extractedExpression = mapExpressions( exp.expressions )
        cardinalityExpressionHelper(
            exp.k + 1,
            extractedExpression,
            false,
            false
        )
    }

    def private Expr cardinalityExpressionHelper
    (
        int cardinality,
        List<Expression> extractedExpression,
        Boolean eq,
        Boolean eq_ge_gt
    )
    {
        if (extractedExpression.empty)
        {
            throw new Exception("Empty extractedExpression inside a cardinality")
        }
        noOfCardinaltyConstraints = noOfCardinaltyConstraints + 1;
        // Declaring constants to handle the terminal0 and -1 for the eq_ge_gt cases
        val terminal0 = if (eq_ge_gt) context.mkBool(false)
                        else          context.mkBool(true)
        val terminal1 = if (eq_ge_gt) context.mkBool(true)
                        else          context.mkBool(false)
        val count = extractedExpression.size
        val halfCount = Math.floor(count/2) as int
        if (cardinality == 0) {
        }
        val cardinality_ = Math.min(count - cardinality + 1, cardinality)
        var index = 0
        val List<BoolExpr> boolExpressions = new ArrayList<BoolExpr>()
        for( _expression : extractedExpression) {
            val tmp = switch (_expression) {
                VariableExpression: caseVariableExpression(_expression)
                ExtractIndexExpression:context.mkEq(
                      context.mkBV(1, 1)
                    , caseExtractIndexExpression(_expression)
                )
                default: convert(_expression)
            }
            if (!(tmp instanceof BoolExpr))
            {
                throw new Exception("An expression inside a cardinality expression could"
                    + " not be cast as BoolExpr after conversion")
            }
            val _boolExpr = tmp as BoolExpr
            index = index + 1
            val noOfHelpingNodes = Math.min( cardinality_, if (index <= halfCount) index else count - index + 1)
            val startIndexHelpingNodes =
            (
                if (index <= cardinality_) cardinality + 1 - noOfHelpingNodes
                else if (count - index < cardinality_) 1
                     else if (cardinality != cardinality_) count - index - cardinality_ + 2
                          else 1
            ) - 1
            val endIndexHelpingNodes = startIndexHelpingNodes + noOfHelpingNodes - 1

            for ( i : (startIndexHelpingNodes..endIndexHelpingNodes) )
            {
                if (i == cardinality-1)
                {
                    boolExpressions +=
                        context.mkEq(
                              context.mkConst(createHelperNodeName(index, i), context.mkBoolSort) as BoolExpr
                            , context.mkITE(
                                  _boolExpr
                                , if(index == 1) terminal1
                                  else if (eq) context.mkConst(createHelperNodeName(index-1, i+1), context.mkBoolSort)
                                       else    terminal1
                                , if(index == 1) terminal0
                                  else           context.mkConst(createHelperNodeName(index-1, i), context.mkBoolSort)
                              )
                        )
                }
                else if (index <= cardinality && i == startIndexHelpingNodes)
                {
                    boolExpressions +=
                        context.mkEq(
                              context.mkConst(createHelperNodeName(index, i), context.mkBoolSort) as BoolExpr
                            , context.mkITE(
                                  _boolExpr
                                , context.mkConst(createHelperNodeName(index-1, i+1), context.mkBoolSort) as BoolExpr
                                , terminal0
                              )
                        )
                }
                else
                {
                    boolExpressions +=
                        context.mkEq(
                              context.mkConst(createHelperNodeName(index, i), context.mkBoolSort) as BoolExpr
                            , context.mkITE(
                                  _boolExpr
                                , context.mkConst(createHelperNodeName(index-1, i+1), context.mkBoolSort) as BoolExpr
                                , context.mkConst(createHelperNodeName(index-1, i), context.mkBoolSort) as BoolExpr
                              )
                        )
                }
            }
            if (eq && index <= count - cardinality + 1)
            {
                boolExpressions +=
                    context.mkEq(
                          context.mkConst(createHelperNodeName(index, cardinality), context.mkBoolSort) as BoolExpr
                        , context.mkITE(
                              _boolExpr
                            , terminal0
                            , if(index == 1) terminal1
                              else           context.mkConst(createHelperNodeName(index-1, cardinality), context.mkBoolSort)
                          )
                    )
            }
        }
        if (boolExpressions.empty)
        {
            throw new Exception("Empty boolExpressions inside a cardinality")
        }
        else
        {
            solver.add( context.mkAnd(boolExpressions) )
        }
        context.mkConst(createHelperNodeName(index, 0), context.mkBoolSort)
    }

    def private List<Expression> mapExpressions (List<Expression> expressions)
    {
        val result = new ArrayList<Expression>()
        for( _expr : expressions)
        {
            if (_expr instanceof VariableExpression)
            {
                if (_expr.variable instanceof Predicate)
                {
                    result += _expr
                }
                else if (_expr.variable instanceof Bitvector)
                {
                    val bitvector = (_expr.variable as Bitvector)
                    (0..<bitvector.width).forEach[ i |
                        result += SMTlib2extendedFactory::eINSTANCE.createExtractIndexExpression => [
                            expr = _expr
                            start = i
                            end = i
                        ]
                    ]
                }
                else
                {
                    throw new Exception("invalid VariableExpression in a cardinality expression: " + _expr.variable.^class)
                }
            } else {
                result += _expr
            }
        }
        result
    }

    override defaultCase(EObject exp)
    {
        throw new UnsupportedOperationException("(Z3Converter) Not implemented: " + exp.^class.name)
    }

    def convertToBool(Expression exp)
    {
        val r = convert(exp)
        if (exp instanceof NotExpression)
        {
            switch (r) {
                BoolExpr: r
                BitVecExpr: context.mkEq(
                    convert( (exp as NotExpression).expr )
                    , context.mkBV(0, 1)
                )
            }
        }
        else
        {
            switch (r) {
                BoolExpr: r
                BitVecExpr: context.mkEq(r, context.mkBV(1, 1))
            }
        }
    }

    def convertToBitVec(Expression exp)
    {
        val r = convert(exp)
        switch (r) {
            BitVecExpr: r
            BoolExpr: context.mkITE(r, context.mkBV(1, 1), context.mkBV(0, 1)) as BitVecExpr
            default: r as BitVecExpr
        }
    }

    def MkBitString(Context ctx, String value)
    {
        // TODO Maybe a bit dirty :)
        val se = context.parseSMTLIB2String('''(assert (= #b«value» #b«value»))''', #[], #[], #[], #[])
        se.args.head
    }

    def operator_multiply(String s, int count)
    {
        (0..<count).map[s].reduce[a, b | a + b] ?: ""
    }
}