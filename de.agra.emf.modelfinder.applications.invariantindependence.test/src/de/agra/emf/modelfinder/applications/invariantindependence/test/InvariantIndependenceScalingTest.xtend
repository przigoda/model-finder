package de.agra.emf.modelfinder.applications.invariantindependence.test

import de.agra.emf.metamodels.SMTlib2extended.solver.SMT2Solver
import de.agra.emf.modelfinder.applications.invariantindependence.InvariantIndependenceAnalysis
import de.agra.emf.modelfinder.encoding.ModelFinderSolver
import de.agra.emf.modelfinder.encoding.SMTLib2ConverterWithPlaceholder
import java.util.Map
import junit.framework.TestCase

import static de.agra.emf.modelfinder.encoding.utils.LoadParametersExtensions.*

class InvariantIndependenceScalingTest extends TestCase {

    private var int dv = 5
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

        val InvariantIndependenceAnalysis analyzer = new InvariantIndependenceAnalysis
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

    def void testCivStatUMLModell4() {
        dv = 4
        val String modelName = "CivStat"
        val Map<String,Integer> boundsMap = #{"Person" -> dv}
        testIndependentofUMLModell( modelName, boundsMap)
    }

    def void testCivStatUMLModell5() {
        dv = 5
        val String modelName = "CivStat"
        val Map<String,Integer> boundsMap = #{"Person" -> dv}
        testIndependentofUMLModell( modelName, boundsMap)
    }

    def void testCivStatUMLModell6() {
        dv = 6
        val String modelName = "CivStat"
        val Map<String,Integer> boundsMap = #{"Person" -> dv}
        testIndependentofUMLModell( modelName, boundsMap)
    }

    def void testCivStatUMLModell7() {
        dv = 7
        val String modelName = "CivStat"
        val Map<String,Integer> boundsMap = #{"Person" -> dv}
        testIndependentofUMLModell( modelName, boundsMap)
    }

    def void testCivStatUMLModell8() {
        dv = 8
        val String modelName = "CivStat"
        val Map<String,Integer> boundsMap = #{"Person" -> dv}
        testIndependentofUMLModell( modelName, boundsMap)
    }

    def void testCivStatUMLModell9() {
        dv = 9
        val String modelName = "CivStat"
        val Map<String,Integer> boundsMap = #{"Person" -> dv}
        testIndependentofUMLModell( modelName, boundsMap)
    }

    def void testCivStatUMLModell10() {
        dv = 10
        val String modelName = "CivStat"
        val Map<String,Integer> boundsMap = #{"Person" -> dv}
        testIndependentofUMLModell( modelName, boundsMap)
    }

    def void testCarRentalUMLModell5() {
        dv = 5
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

    def void testCarRentalUMLModell6() {
        dv = 6
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

    def void testCarRentalUMLModell7() {
        dv = 7
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
    
    def void testCarRentalUMLModell8() {
        dv = 8
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

    def void testCarRentalUMLModell9() {
        dv = 9
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
    
    def void testCarRentalUMLModell10() {
        dv = 10
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
}