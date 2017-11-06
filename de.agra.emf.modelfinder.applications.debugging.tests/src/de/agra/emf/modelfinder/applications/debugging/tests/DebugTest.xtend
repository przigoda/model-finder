package de.agra.emf.modelfinder.applications.debugging.tests

import de.agra.emf.modelfinder.applications.debugging.InvariantContradictionAnalysis
import de.agra.emf.modelfinder.encoding.ModelFinderSolver
import de.agra.emf.modelfinder.modelloader.ModelLoader
import java.util.Map
import junit.framework.TestCase

import static de.agra.emf.modelfinder.utils.USEUtilsExtensions.*
import de.agra.emf.modelfinder.encoding.SMTLib2ConverterWithPlaceholder
import de.agra.emf.metamodels.SMTlib2extended.solver.Z3Solver
import de.agra.emf.metamodels.SMTlib2extended.solver.SMT2Solver
import static extension de.agra.emf.modelfinder.encoding.utils.LoadParametersExtensions.*

class DebugTest extends TestCase {

    private val int dv = 9

/*
    def void testGenerate() {
//        val String path = "/home/oktavian/git/model-finder/de.agra.emf.modelfinder.applications.debugging.tests/models/use2ecore/"
//        val String path = "/home/oktavian/workspaces/mars/use-modelfinder/use/examples/Others/CarRental/"
        val String path = "/home/oktavian/workspaces/mars/use-modelfinder/use/examples/soil/civstat/"
        val String modelFileName = "civstat"
//        val String modelFileName = "CarRental2"
//        val String modelFileName = "ex"
//        val String modelFileName = "Project"
//        val String modelFileName = "Sudoku"
//        val String modelFileName = "zug"
        generateEcoreFileFromUSEFile(
              path+modelFileName+".use"
            , path+modelFileName+".ecore"
            , path+modelFileName+".ocl"
        )
    }
*/

    def void testFaultyUMLModell() {
//        val String modelName = "CarRental2"
//        val String modelName = "Company"
//        val String modelName = "Project"
//        val String modelName = "Sudoku"
//        val String ecoreFile = "models/use-models/"+modelName+".ecore"
//        val String oclFile = "models/use-models/"+modelName+".ocl"

        val String modelName = "FaultyUMLmodel4"
        val String ecoreFile = "models/debug/"+modelName+".ecore"
        val String oclFile = "models/debug/"+modelName+".ocl"

        val modelLoader = new ModelLoader
        val input = modelLoader.loadFromEcoreAndOCL(ecoreFile, oclFile)
//        val stateGenerator = new StateGenerator(input.model)

        input.constraints.forEach[ c |
//            println(" c = " + c.class.name )
//            val bodyExp = c.specification.bodyExpression as IteratorExpImpl
//            println(" bodyExp.source = " + (bodyExp.eContents.get(1) as OperationCallExpImpl).source.class.name )
//            val tmp = bodyExp.source as OperationCallExp
//            println(" bodyExp.source = " + tmp.source.toString )
//            val tmp1 =  tmp.source as PropertyCallExp
//            println(" tmp1 = " + tmp1.source.eContents ) // gibt den Context zurück
//            println(" tmp1 = " + tmp1.source.eClass.name )
//            println(" instanceOf " + bodyExp.class.name)
        ]
//        assertEquals(false, true)


//        val Bounds bounds = new AllSameBounds(1)
//        val Bounds bounds = new StaticBounds(input.model, #{"Board" -> 2, "Row" -> 9, "Column" -> 9, "Square" -> 9, "Field" -> 81})
        val Map<String,Integer> boundsMap = #{"A" -> 2, "B" -> 5, "C" -> 3, "D" -> 7}
//        val Bounds bounds = new StaticBounds(input.model, boundsMap)
//        val state = stateGenerator.generate(bounds, new NoOperationCallsDetermination).head

//        val generator = new InstanceGenerator(input.model)
//        val instance = generator.encodeConsistency(state, input.constraints)

//        val solver = new SMT2Solver
//        solver.converter = new SMTLib2ConverterWithPlaceholder()
//        solver.showSendMessages = true;
//        solver.formatAsserts = true;

//        val sat = solver.solve(instance)
//        assertEquals(false, sat)

        useAlpha = false;
        println("useAlpha = "+useAlpha)

        println("There is no consistent state for the model, trying to find contradictions")

        val analyzer = new InvariantContradictionAnalysis(ecoreFile, oclFile);
        analyzer.solver = new ModelFinderSolver
//        analyzer.solver = new SMT2Solver
        if (analyzer.solver instanceof ModelFinderSolver) {
            (analyzer.solver as ModelFinderSolver).setConverter(
                (analyzer.solver as ModelFinderSolver).ctx
            )
        }
        if (analyzer.solver instanceof SMT2Solver) {
            (analyzer.solver as SMT2Solver).setConverter = new SMTLib2ConverterWithPlaceholder()
        }
        analyzer.solver.init
        analyzer.solver.showAddedExpressions = true;
        analyzer.solver.showAddedExpressions = false;
        analyzer.findContradictorilyInvariants_counting(boundsMap);
//        analyzer.findContradictorilyInvariants(boundsMap);
        analyzer.solver.finish
    }

    def void testFaultyRelations() {
        val String modelName = "FaultyRelations"
        val String ecoreFile = "models/debug/"+modelName+".ecore"
        val String oclFile = "models/debug/"+modelName+".ocl"

        val modelLoader = new ModelLoader
        val input = modelLoader.loadFromEcoreAndOCL(ecoreFile, oclFile)

        val Map<String,Integer> boundsMap =
        #{
            "A" -> dv,
            "B" -> dv,
            "C" -> dv,
            "D" -> dv
        }

        useAlpha = true;
        println("useAlpha = "+useAlpha)

//        println("There is no consistent state for the model, trying to find contradictions")

        val analyzer = new InvariantContradictionAnalysis(ecoreFile, oclFile);
        analyzer.solver = new ModelFinderSolver
//        analyzer.solver = new SMT2Solver
        if (analyzer.solver instanceof ModelFinderSolver) {
            (analyzer.solver as ModelFinderSolver).setConverter(
                (analyzer.solver as ModelFinderSolver).ctx
            )
        }
        if (analyzer.solver instanceof SMT2Solver) {
            (analyzer.solver as SMT2Solver).setConverter = new SMTLib2ConverterWithPlaceholder()
        }
        analyzer.solver.init
        analyzer.solver.showAddedExpressions = true;
        analyzer.solver.showAddedExpressions = false;
        analyzer.findContradictorilyInvariants_counting(boundsMap);
        analyzer.solver.finish
    }

    def void testEmergencyCar() {
        val String modelName = "FaultyRelations"
        val String ecoreFile = "/home/oktavian/git/model-finder/de.agra.emf.modelfinder.encoding.tests/models/ProjectWithJonas/EmergencyCar.v1.0.ecore"
        val String oclFile = "/home/oktavian/git/model-finder/de.agra.emf.modelfinder.encoding.tests/models/ProjectWithJonas/EmergencyCar.v1.0.ocl"

        val modelLoader = new ModelLoader
        val input = modelLoader.loadFromEcoreAndOCL(ecoreFile, oclFile)

        val Map<String,Integer> boundsMap =
        #{
            "Street" -> 4,
            "NormalCar" -> 4,
            "EmergencyCar" -> 1,
            "NormalConjunction" -> 1,
            "TrafficLight" -> 4,
            "EndConjunction" -> 4
        }

        useAlpha = true
        useAlpha = false;
        println("useAlpha = "+useAlpha)

//        println("There is no consistent state for the model, trying to find contradictions")

        val analyzer = new InvariantContradictionAnalysis(ecoreFile, oclFile);
        analyzer.solver = new SMT2Solver
        analyzer.solver = new ModelFinderSolver
        if (analyzer.solver instanceof ModelFinderSolver) {
            (analyzer.solver as ModelFinderSolver).setConverter(
                (analyzer.solver as ModelFinderSolver).ctx
            )
        }
        if (analyzer.solver instanceof SMT2Solver) {
            (analyzer.solver as SMT2Solver).setConverter = new SMTLib2ConverterWithPlaceholder()
        }
        analyzer.solver.init
        analyzer.solver.showAddedExpressions = false;
        analyzer.solver.showAddedExpressions = true;
        analyzer.findContradictorilyInvariants_counting(boundsMap);
        analyzer.solver.finish
    }

    def void civStatCall(String modelParam) {
        val String ecoreFile = "models/CivStat.ecore"
        val String oclFile = "models/CivStat"+modelParam+".ocl"

        val modelLoader = new ModelLoader
        val input = modelLoader.loadFromEcoreAndOCL(ecoreFile, oclFile)

        val Map<String,Integer> boundsMap = #{"Person" -> dv}

        useAlpha = true;
        println("useAlpha = "+useAlpha)

        val analyzer = new InvariantContradictionAnalysis(ecoreFile, oclFile);
        analyzer.solver = new SMT2Solver
        analyzer.solver = new ModelFinderSolver
        if (analyzer.solver instanceof ModelFinderSolver) {
            (analyzer.solver as ModelFinderSolver).setConverter(
                (analyzer.solver as ModelFinderSolver).ctx
            )
        }
        if (analyzer.solver instanceof SMT2Solver) {
            (analyzer.solver as SMT2Solver).setConverter = new SMTLib2ConverterWithPlaceholder()
        }
        analyzer.solver.init
        analyzer.solver.showAddedExpressions = false;
        analyzer.solver.showAddedExpressions = true;
        analyzer.findContradictorilyInvariants_counting(boundsMap);
        analyzer.solver.finish
    }

    def void testCivStat_not_i3_sDG_hw() {
        civStatCall("_not_i3_sDG-hw")
    }

    def void testCivStat_not_i3_sDG_wh() {
        civStatCall("_not_i3_sDG-wh")
    }

    def void testCivStat_not_i3_sDG_wh_hw() {
        civStatCall("_not_i3_sDG-wh+hw")
    }

    def void testCivStat_not_i4_sDG_hw() {
        civStatCall("_not_i4_sDG-hw")
    }

    def void testCivStat_not_i4_sDG_wh() {
        civStatCall("_not_i4_sDG-wh")
    }

    def void testCivStat_not_i4_sDG_wh_hw() {
        civStatCall("_not_i4_sDG-wh+hw")
    }

    def void testCivStat_not_i6hw_wh() {
        civStatCall("_not_i6hw+wh")
    }

    def void testCivStat_not_i6wh_hw() {
        civStatCall("_not_i6wh+hw")
    }

    def void testCivStat_not_i6wh_not_hw() {
        civStatCall("_not_i6wh+not-hw")
    }

    def void testCarRental() {
        val String ecoreFile = "models/debug/CarRental2.ecore"
        val String oclFile = "models/debug/CarRental2.ocl"

        val modelLoader = new ModelLoader
        val input = modelLoader.loadFromEcoreAndOCL(ecoreFile, oclFile)

        val Map<String,Integer> boundsMap = #{
            "Customer" -> dv,
            "Employee" -> dv,
            "Branch" -> dv,
            "Rental" -> dv,
            "CarGroup" -> dv,
            "Car" -> dv,
            "ServiceDepot" -> dv,
            "Check" -> dv,
            "TernaryRelationMaintenance" -> dv
        }

        useAlpha = true;
        println("useAlpha = "+useAlpha)

        val analyzer = new InvariantContradictionAnalysis(ecoreFile, oclFile);
        analyzer.solver = new ModelFinderSolver
//        analyzer.solver = new SMT2Solver
        if (analyzer.solver instanceof ModelFinderSolver) {
            (analyzer.solver as ModelFinderSolver).setConverter(
                (analyzer.solver as ModelFinderSolver).ctx
            )
        }
        if (analyzer.solver instanceof SMT2Solver) {
            (analyzer.solver as SMT2Solver).setConverter = new SMTLib2ConverterWithPlaceholder()
        }
        analyzer.solver.init
        analyzer.solver.showAddedExpressions = true;
        analyzer.solver.showAddedExpressions = false;
        analyzer.findContradictorilyInvariants_counting(boundsMap);
        analyzer.solver.finish
    }
}