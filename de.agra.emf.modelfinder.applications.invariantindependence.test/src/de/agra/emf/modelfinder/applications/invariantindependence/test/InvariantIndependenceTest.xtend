package de.agra.emf.modelfinder.applications.invariantindependence.test

import de.agra.emf.metamodels.SMTlib2extended.Variable
import de.agra.emf.metamodels.SMTlib2extended.solver.SMT2Solver
import de.agra.emf.modelfinder.applications.invariantindependence.InvariantIndependenceAnalysis
import de.agra.emf.modelfinder.encoding.InstanceGenerator
import de.agra.emf.modelfinder.encoding.ModelFinderSolver
import de.agra.emf.modelfinder.encoding.SMTLib2ConverterWithPlaceholder
import de.agra.emf.modelfinder.modelloader.ModelLoader
import de.agra.emf.modelfinder.statesequence.bounds.Bounds
import de.agra.emf.modelfinder.statesequence.bounds.StaticBounds
import de.agra.emf.modelfinder.statesequence.determination.NoOperationCallsDetermination
import de.agra.emf.modelfinder.statesequence.state.StateGenerator
import java.util.Map
import junit.framework.TestCase

import static de.agra.emf.modelfinder.encoding.utils.LoadParametersExtensions.*

import static extension de.agra.emf.modelfinder.encoding.InstanceGenerator.*
import static extension de.agra.emf.modelfinder.statesequence.StateSequenceGenerator.*
import java.util.ArrayList
import java.util.List

class InvariantIndependenceTest extends TestCase {

    private val int dv = 10
    def void testIndependentofUMLModell
    (
        String modelName,
        Map<String,Integer> boundsMap
    )
    {
        useAlpha = true
        val boolean sanityChecks = true
        val String ecoreFile = "models/"+modelName+".ecore"
        val String oclFile = "models/"+modelName+".ocl"

        println("Trying to find dependences between the invariants")

        val analyzer = new InvariantIndependenceAnalysis
        (
            ecoreFile,
            oclFile
        );
        analyzer.solver = new ModelFinderSolver
//        analyzer.solver = new SMT2Solver
        if (analyzer.solver instanceof ModelFinderSolver) {
            (analyzer.solver as ModelFinderSolver).setConverter
        }
        if (analyzer.solver instanceof SMT2Solver) {
            (analyzer.solver as SMT2Solver).converter = new SMTLib2ConverterWithPlaceholder()
        }
        analyzer.solver.init
        analyzer.solver.showAddedExpressions = false;
        analyzer.sanityChecks = sanityChecks;
        analyzer.analyzeInvariants(boundsMap);
        println('''The SMT-solver was called «analyzer.solver.solveCalls»''')
        analyzer.solver.finish
    }

    def void testBasicUMLModell() {
        val String modelName = "Basic"
        val Map<String,Integer> boundsMap = #{"C" -> 1}
        testIndependentofUMLModell( modelName, boundsMap)
    }

    def void testBasic2UMLModell() {
        val String modelName = "Basic2"
        val Map<String,Integer> boundsMap = #{"C" -> 1}
        testIndependentofUMLModell( modelName, boundsMap)
    }

    def void testBasic3UMLModell() {
        val String modelName = "Basic3"
        val Map<String,Integer> boundsMap = #{"C" -> 1}
        testIndependentofUMLModell( modelName, boundsMap)
    }

    def void testBasic4UMLModell() {
        val String modelName = "Basic4"
        val Map<String,Integer> boundsMap = #{"C" -> 1}
        testIndependentofUMLModell( modelName, boundsMap)
    }

    def void testCivStatUMLModell() {
        val String modelName = "CivStat"
        val Map<String,Integer> boundsMap = #{"Person" -> dv}
        testIndependentofUMLModell( modelName, boundsMap)
    }

    def void testDemoUMLModell() {
        val String modelName = "Demo"
        val Map<String,Integer> boundsMap =
        #{
            "Employee" -> dv,
            "Department" -> dv,
            "Project" -> dv
        }
        testIndependentofUMLModell( modelName, boundsMap)
    }

    def void testPersonCompanyUMLModell() {
        val String modelName = "PersonCompany"
        val Map<String,Integer> boundsMap =
        #{
            "Person" -> dv,
            "Company" -> dv,
            "Job" -> dv
        }
        testIndependentofUMLModell( modelName, boundsMap)
    }

    def void testCarRentalUMLModell() {
        val String modelName = "CarRental2"
        val Map<String,Integer> boundsMap =
        #{  "Customer" -> dv,
            "Employee" -> dv,
            "Branch" -> dv,
            "Rental" -> dv,
            "CarGroup" -> dv,
            "Car" -> dv,
            "ServiceDepot" -> dv,
            "Check" -> dv,
            "TernaryRelationMaintenance" -> dv
        }
        testIndependentofUMLModell( modelName, boundsMap)
    }

//    def void testTrainUMLModell() {
//        val String modelName = "Train"
//        val Map<String,Integer> boundsMap =
//        #{  "Train" -> dv,
//            "Waggon" -> dv,
//            "Journey" -> dv,
//            "Station" -> dv,
//            "Way" -> dv,
//            "Reservation" -> dv
//        }
//        testIndependentofUMLModell( modelName, boundsMap)
//    }

    def void testCPU_UMLModell() {
        val String modelName = "CPU"
        val Map<String,Integer> boundsMap =
        #{  "CPU" -> dv,
            "Memory" -> dv,
            "ProgramCounter" -> dv,
            "ALU" -> dv,
            "ControlUnit" -> dv,
            "Register" -> dv
        }
        testIndependentofUMLModell( modelName, boundsMap)
    }

    def void testDemoConsistency() {
        useAlpha = false
        val modelLoader = new ModelLoader
        val input = modelLoader.loadFromEcoreAndOCL("models/Demo.ecore", "models/Demo.ocl")
        val Map<String,Integer> boundsMap = #{"Employee" -> 1, "Department" -> 1, "Project" -> 3}
        val Bounds bounds = new StaticBounds(input.model, boundsMap)
        val sequence = generateStateSequence
        (
            input.model,
            bounds,
            new NoOperationCallsDetermination
        )
        val instance = encodeConsistency
        (
            sequence,
            input.constraints
        )

        val solver = new ModelFinderSolver
        solver.setConverter
        solver.init
        solver.addAssertions(instance.assertions)

        val sat = solver.solve
        if (sat)
        {
            println("SAT:")
            val solution = solver.getSolution(instance.variables)
            solution.forEach[k, v|
                println('''«(k as Variable).name» -> «v»''')
            ]
        }
        else
        {
            println("UNSAT")
        }
    }

    def void testCivStatConsistency() {
        useAlpha = false
        val modelLoader = new ModelLoader
        val String modelName = "CivStat"
        val input = modelLoader.loadFromEcoreAndOCL("models/"+modelName+".ecore", "models/"+modelName+".ocl")
        val Map<String,Integer> boundsMap = #{"Person" -> dv}
        val Bounds bounds = new StaticBounds(input.model, boundsMap)
        val sequence = generateStateSequence
        (
            input.model,
            bounds,
            new NoOperationCallsDetermination
        )
        val instance = encodeConsistency
        (
            sequence,
            input.constraints
        )

        val solver = new ModelFinderSolver
        solver.setConverter
        solver.init
        solver.addAssertions(instance.assertions)

        val sat = solver.solve
        if (sat)
        {
            println("SAT:")
            val solution = solver.getSolution(instance.variables)
            solution.forEach[k, v|
                println('''«(k as Variable).name» -> «v»''')
            ]
        }
        else
        {
            println("UNSAT")
        }
    }
}