package de.agra.emf.metamodels.SMTlib2extended.solver

import com.microsoft.z3.BoolExpr
import com.microsoft.z3.Context
import com.microsoft.z3.Status
import de.agra.emf.metamodels.SMTlib2extended.Bitvector
import de.agra.emf.metamodels.SMTlib2extended.Expression
import de.agra.emf.metamodels.SMTlib2extended.Predicate
import de.agra.emf.metamodels.SMTlib2extended.Variable
import de.agra.emf.metamodels.SMTlib2extended.conversion.Z3Converter
import java.io.OutputStreamWriter
import java.math.BigInteger
import java.util.HashMap
import org.eclipse.emf.common.util.EList
import org.eclipse.xtend.lib.annotations.Accessors

import static extension de.agra.emf.metamodels.SMTlib2extended.conversion.Z3ConverterUtils.*
import de.agra.emf.metamodels.SMTlib2extended.EqualsExpression
import de.agra.emf.metamodels.SMTlib2extended.AndExpression
import de.agra.emf.metamodels.SMTlib2extended.ImpliesExpression
import de.agra.emf.metamodels.SMTlib2extended.IteExpression

class Z3Solver implements Solver<Z3Converter> {

    @Accessors boolean debugOutput = false
    @Accessors boolean showAddedExpressions = true
    @Accessors int timeout = 120;
    @Accessors int solveCall = 0
    @Accessors OutputStreamWriter osw = null

    @Accessors Context ctx = new Context(#{"model" -> "true"})
    @Accessors Z3Converter converter

    private var solver = ctx.mkSolver("QF_BV")
    private val solution = new HashMap<Variable, Object>

    private var boolean SAT = false;


    override init()
    {
        /* This is done by default, no connection must be established
         */
        converter.solver = solver
        if (debugOutput)
        {
            ctx.parseSMTLIB2String('''(set-option :pp.min_alias_size 1000000)''', #[], #[], #[], #[])
            ctx.parseSMTLIB2String('''(set-option :pp.max_depth      1000000)''', #[], #[], #[], #[])
        }
    }

    override finish()
    {
        /* This is done by default, no connection must be closed
         */
    }

    override getShowAddedExpressions()
    {
        showAddedExpressions
    }

    override getTimeout()
    {
        timeout
    }

    def void setConverter()
    {
        println("setting converter")
        converter = new Z3Converter(ctx)
    }
    override setConverter(Z3Converter c)
    {
        converter = c
    }

    override getSolution(EList<Variable> variables)
    {
        solution.clear
        if (SAT == false)
        {
            println("There is currently no solution available, please call _solve_ before AND\n" +
                    "make sure that that _solve_ returns true/SAT.")
            return solution
        }
        extractSolution(variables)
        solution
    }

    override solveCalls()
    {
        solveCall
    }

    override solve()
    {
        solveCall = solveCall + 1

        if (converter == null)
        {
            println("No converter set")
            return false;
        }
        if (converter.solver == null)
        {
            println("The converter does not have a set solver")
            return false;
        }

        val res = solver.check
        if (res == Status::SATISFIABLE)
        {
            SAT = true
        }
        else
        {
            SAT = false
        }

        SAT
    }

    private def extractSolution(EList<Variable> variables)
    {
        solution.clear

        val model = solver.model

        for (variable : variables)
        {
            val solverVar = ctx.convertVariable(variable)
            // TODO This seems to be called before sometimes
            model.evaluate(solverVar, true)
            val interp = model.getConstInterp(ctx.convertVariable(variable))
            solution.put
            (
                variable,
                switch variable
                {
                    Predicate:
                        Boolean.parseBoolean(interp.toString)
                    Bitvector:
                    {
                         try {
                             Integer.parseInt(interp.toString)
                         }
                         catch (NumberFormatException e ) {
                             new BigInteger(interp.toString)
                         }
                     }
                    default:
                        throw new Error('''Unhandled type of variable: «variable.^class.name»''')
                }
            )
        }
    }

    override void addAssertion(Expression assertion)
    {
        var BoolExpr exp = null
        try {
            exp = converter.convert(assertion) as BoolExpr
        } catch (com.microsoft.z3.Z3Exception e) {
            print("")
            val tmp = ((assertion as IteExpression).thenexpr as AndExpression).expressions.get(1);
            print("")
            addAssertion(tmp)
            print("")
        }
        if (osw != null)
        {
            osw.write("[ADDED]\n")
            exp.toString.split("\n").forEach[
                osw.write(it + "\n")
                osw.flush
            ]
        }
        if (showAddedExpressions)
        {
            println("[ADDED]\n" + exp)
        }
        solver.add(exp) // TODO: check if assert and add are the same 
    }

    override void addAssertions(EList<Expression> assertions)
    {
        createAndAddAssertions(assertions)
    }

    private def createAndAddAssertions(EList<Expression> assertions)
    {
        for (assertion : assertions)
        {
            addAssertion(assertion)
        }
    }

    override push()
    {
        solver.push
    }

    override pop()
    {
        solver.pop
    }
}