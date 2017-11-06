package de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.examples

import de.agra.emf.metamodels.SMTlib2extended.Instance
import de.agra.emf.metamodels.SMTlib2extended.solver.SMT2Solver
import de.agra.emf.metamodels.SMTlib2extended.solver.Solver
import de.agra.emf.modelfinder.encoding.ModelFinderSolver
import de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.SMTLib2ConverterWithPlaceholder
import de.agra.emf.modelfinder.modelloader.ModelLoader
import de.agra.emf.modelfinder.statesequence.bounds.AllSameBounds
import de.agra.emf.modelfinder.statesequence.bounds.Bounds
import de.agra.emf.modelfinder.statesequence.determination.FixedOperationCallsDetermination
import java.util.HashSet
import java.util.Set
import junit.framework.TestCase

import static de.agra.emf.modelfinder.statesequence.StateSequenceGenerator.*

import static de.agra.emf.modelfinder.encoding.LoadParametersExtensions.*
import static extension de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.InstanceGeneratorImplTwoValuedOCL.*
import static extension de.agra.emf.modelfinder.statesequence.ResourceExtensions.*
import de.agra.emf.modelfinder.statesequence.determination.NoOperationCallsDetermination
import de.agra.emf.modelfinder.encoding.LoadParametersExtensions
import de.agra.emf.modelfinder.statesequence.bounds.StaticBounds
import de.agra.emf.modelfinder.statesequence.determination.OperationCallsDetermination
import de.agra.emf.modelfinder.encoding.LoadParametersExtensions.FcOptions
import de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.InstanceGeneratorImplTwoValuedOCL

class Tutorial extends TestCase
{
    def solveAndPrintSolution
    (
        Solver solver,
        Instance instance
    )
    {
        solver.init()
        if (solver instanceof SMT2Solver)
        {
            (solver as SMT2Solver).createVars(instance.variables)
        }
        solver.addAssertions(instance.assertions)
        if (solver.solve)
        {
            val solution = solver.getSolution(instance.variables)
            instance.variables.forEach[
                println('''Variable name: «it.name+"\t"»value: «solution.get(it)»''')
            ]
        }
        else
        {
            println("UNSAT --> could not print a solution")
        }
    }

/*

Content of wiki-Page "Use cases"
see https://gitlab.informatik.uni-bremen.de/fsl/model-finder/wikis/Use-Cases

***Consistency with different bound settings***
* `AllSameBounds(N)` (i.e., only system states with exactly N objects of every none-abstract class are accepted as solution)
* `StaticBounds(Map<Class,N_C>)` (i.e., only system states with exactly N_C objects for a certain class C (none-abstract) are accepted as solution)

Furthermore, the extension `LoadParametersExtensions` offer two configurable parameters, `useAlpha` and `oneObjectPerClass`, which 
can be used to encode the system state. The first one, `useAlpha`, is by default set to `true` which means that the created object for every class can be marked as alive or dead in the encoding. (The internally needed variables to encode this are automatically generated.)
If `useAlpha = true`, then also the parameter `LoadParametersExtensions.oneObjectPerClass = true` (default value) should be set to enforce either one object per class in the system state (true) or one object of any class in every state (false).
If `useAlpha = false`, the system state must have exactly the given N objects per class and `oneObjectPerClass` will not have any impact and, thus, can be ignored.

* not supported within the encoding steps: `IntervalBounds(Map<Class,Pair<N1,N2>>)`

Examples for the different combinations can be found in `testExample{01,...,07}`

***Debugging for an inconsistent system state***

***Dynamic/encode a sequence of system states***

***add a specific task to a sequence of system states***

 */

/**
 * The method <emph>testExample01</emph> shows how the general flow to 'check' a model given in the
 * Ecore format as JUnit test.
 * 
 * The structure is always:
 * 1. Instantiate a <emph>ModelLoader</emph> instance and load the given model with recently created ModelLoader 
 * instance. For loading a model, three different methods are available:
 * modelLoader.loadFromEcore(String ecoreFile) -- no OCL constraints are required
 * modelLoader.loadFromEcoreWithOCL(String ecoreFile) -- should be used, if the ecore files also
 *                                                       contains OCL constraints as annotation 
 * modelLoader.loadFromEcoreAndOCL(String ecoreFile, String oclFile) -- self-explaining...
 * The returned object is an instance of the class <emph>ModelWithConstraints</emph> which is a
 * simple container for the two attributes <emph>EPackage model</emph> and <emph>List[Constraint] constraints</emph>.
 * 
 * 2. The <emph>StateSequenceGenerator</emph> offers only static methods which will be used for
 * different purposes at different positions. Here, you only need to create a
 * <emph>StateSequence</emph> object with the <emph>generateStateSequence</emph> as arguments you
 * have to pass the model attribute from step 1.
 */
    def void testExample01()
    {
        /* Instantiate a ModelLoader */
        val modelLoader = new ModelLoader
        val input = modelLoader.loadFromEcoreAndOCL
        (
            "models/TrafficLights.ecore",
            "models/TrafficLights.ocl"
        )

        /* Instantiate a StateSequenceGenerator */
        val sequence = generateStateSequence
        (
            input.model,
            new AllSameBounds(2),
            new NoOperationCallsDetermination()
        )

        /* Encode the instance */
        val instance = encodeConsistency
        (
            sequence,
            input.constraints
        )

        /* Instantiate a Solver */
        val solver = new ModelFinderSolver()

        solver.solveAndPrintSolution(instance)
    }

    def void testExample02()
    {
        /* Instantiate a ModelLoader */
        val modelLoader = new ModelLoader
        val input = modelLoader.loadFromEcoreAndOCL
        (
            "models/TrafficLights.ecore",
            "models/TrafficLights.ocl"
        )

        /* Instantiate a StateSequenceGenerator */
        val sequence = generateStateSequence
        (
            input.model,
            new AllSameBounds(2),
            new NoOperationCallsDetermination()
        )

        /* Encode the instance */
        LoadParametersExtensions.useAlpha = true
        LoadParametersExtensions.oneObjectPerClass = true
        val instance = encodeConsistency
        (
            sequence,
            input.constraints
        )

        /* Instantiate a Solver */
        val solver = new ModelFinderSolver()

        solver.solveAndPrintSolution(instance)
    }

    def void testExample03()
    {
        /* Instantiate a ModelLoader */
        val modelLoader = new ModelLoader
        val input = modelLoader.loadFromEcoreAndOCL
        (
            "models/TrafficLights.ecore",
            "models/TrafficLights.ocl"
        )

        /* Instantiate a StateSequenceGenerator */
        val sequence = generateStateSequence
        (
            input.model,
            new AllSameBounds(2),
            new NoOperationCallsDetermination()
        )

        /* Encode the instance */
        
        LoadParametersExtensions.useAlpha = true
        LoadParametersExtensions.oneObjectPerClass = false
        val instance = encodeConsistency
        (
            sequence,
            input.constraints
        )

        /* Instantiate a Solver */
        val solver = new ModelFinderSolver()

        solver.solveAndPrintSolution(instance)
    }

    def void testExample04()
    {
        /* Instantiate a ModelLoader */
        val modelLoader = new ModelLoader
        val input = modelLoader.loadFromEcoreAndOCL
        (
            "models/TrafficLights.ecore",
            "models/TrafficLights.ocl"
        )

        /* Instantiate a StateSequenceGenerator */
        val sequence = generateStateSequence
        (
            input.model,
            new AllSameBounds(2),
            new NoOperationCallsDetermination()
        )

        /* Encode the instance */
        LoadParametersExtensions.useAlpha = false
        LoadParametersExtensions.oneObjectPerClass = false // does not have any impact
        val instance = encodeConsistency
        (
            sequence,
            input.constraints
        )

        /* Instantiate a Solver */
        val solver = new ModelFinderSolver()

        solver.solveAndPrintSolution(instance)
    }

    def void testExample05()
    {
        /* Instantiate a ModelLoader */
        val modelLoader = new ModelLoader
        val input = modelLoader.loadFromEcoreAndOCL
        (
            "models/TrafficLights.ecore",
            "models/TrafficLights.ocl"
        )

        /* Instantiate a StateSequenceGenerator */
        val sequence = generateStateSequence
        (
            input.model,
            new AllSameBounds(2),
            new NoOperationCallsDetermination()
        )

        /* Encode the instance */
        LoadParametersExtensions.useAlpha = false
        LoadParametersExtensions.oneObjectPerClass = true // does not have any impact
        val instance = encodeConsistency
        (
            sequence,
            input.constraints
        )

        /* Instantiate a Solver */
        val solver = new ModelFinderSolver()

        solver.solveAndPrintSolution(instance)
    }

    def void testExample06()
    {
        /* Instantiate a ModelLoader */
        val modelLoader = new ModelLoader
        val input = modelLoader.loadFromEcoreAndOCL
        (
            "models/TrafficLights.ecore",
            "models/TrafficLights.ocl"
        )

        /* Instantiate a StateSequenceGenerator */
        val boundsMap =
        #{
            "TrafficLight" -> 2,
            "Button" -> 2
        }
        val sequence = generateStateSequence
        (
            input.model,
            new StaticBounds(input.model, boundsMap),
            new NoOperationCallsDetermination()
        )

        /* Encode the instance */
        LoadParametersExtensions.useAlpha = true
        val instance = encodeConsistency
        (
            sequence,
            input.constraints
        )

        /* Instantiate a Solver */
        val solver = new ModelFinderSolver()

        solver.solveAndPrintSolution(instance)
    }

    def void testExample07()
    {
        /* Instantiate a ModelLoader */
        val modelLoader = new ModelLoader
        val input = modelLoader.loadFromEcoreAndOCL
        (
            "models/TrafficLights.ecore",
            "models/TrafficLights.ocl"
        )

        /* Instantiate a StateSequenceGenerator */
        val boundsMap =
        #{
            "TrafficLight" -> 2,
            "Button" -> 2
        }
        val sequence = generateStateSequence
        (
            input.model,
            new StaticBounds(input.model, boundsMap),
            new NoOperationCallsDetermination()
        )

        /* Encode the instance */
        LoadParametersExtensions.useAlpha = false
        val instance = encodeConsistency
        (
            sequence,
            input.constraints
        )

        /* Instantiate a Solver */
        val solver = new ModelFinderSolver()

        solver.solveAndPrintSolution(instance)
    }

/*
 * examples how to enforce a specific value
 * - with and without GSP with an partial initial state
 * - using modelFinder methods
 */

/**
 * The standard flow to validate/verify a sequence of system states.
 * Different ways to add frame conditions
 */
    def void testExample10()
    {
        /* Instantiate a ModelLoader */
        val modelLoader = new ModelLoader
        val input = modelLoader.loadFromEcoreAndOCL
        (
            "models/Counter.ecore",
            "models/Counter.explicitPostconditions.ocl"
        )

        /* Instantiate a StateSequenceGenerator */
        val sequence = generateStateSequence
        (
            input.model,
            new AllSameBounds(2),
            new FixedOperationCallsDetermination(1)
            // i.e., a sequence with 3 system states and 2 operation calls will be generated
        )

        /* Encode the instance */
        useAlpha = false
        LoadParametersExtensions.fcOption = FcOptions::explicitPostconditions
        val instance = encodeDynamic
        (
            sequence,
            input.constraints
        )

        /* Instantiate a Solver */
        val solver = new ModelFinderSolver()
        solver.solveAndPrintSolution(instance)
    }

    def void testExample11()
    {
        /* Instantiate a ModelLoader */
        val modelLoader = new ModelLoader
        val input = modelLoader.loadFromEcoreAndOCL
        (
            "models/Counter.ecore",
            "models/Counter.nothingElseChanges.ocl"
        )

        /* Instantiate a StateSequenceGenerator */
        val sequence = generateStateSequence
        (
            input.model,
            new AllSameBounds(2),
            new FixedOperationCallsDetermination(1)
            // i.e., a sequence with 3 system states and 2 operation calls will be generated
        )

        /* Encode the instance */
        useAlpha = false
        LoadParametersExtensions.fcOption = FcOptions::nothingElseChanges
        val instance = encodeDynamic
        (
            sequence,
            input.constraints
        )

        /* Instantiate a Solver */
        val solver = new ModelFinderSolver()
        solver.solveAndPrintSolution(instance)
    }

    def void testExample12()
    {
        /* Instantiate a ModelLoader */
        val modelLoader = new ModelLoader
        val input = modelLoader.loadFromEcoreAndOCL
        (
            "models/Counter.ecore",
            "models/Counter.modifyStatements.ocl"
        )

        /* Instantiate a StateSequenceGenerator */
        val sequence = generateStateSequence
        (
            input.model,
            new AllSameBounds(3),
            new FixedOperationCallsDetermination(1)
            // i.e., a sequence with 3 system states and 2 operation calls will be generated
        )

        /* Encode the instance */
        LoadParametersExtensions.fcOption = FcOptions::modifyStatements
        useAlpha = false
        useAlpha = true
        InstanceGeneratorImplTwoValuedOCL.modifyPropertiesStatementNameInPostconditions = "modifyProperties"
        val instance = encodeDynamic
        (
            sequence,
            input.constraints
        )

        /* Instantiate a Solver */
        val solver = new ModelFinderSolver()
        solver.solveAndPrintSolution(instance)
    }

/*
 * The <emph>encodeDynamicParallel</emph> method can only be used with
 * FcOptions::explicitPostconditions and FcOptions::modifyStatements.
 */
    def void testExample20()
    {
        /* Instantiate a ModelLoader */
        val modelLoader = new ModelLoader
        val input = modelLoader.loadFromEcoreAndOCL
        (
            "models/Counter.ecore",
            "models/Counter.explicitPostconditions.ocl"
        )

        /* Instantiate a StateSequenceGenerator */
        val Bounds bounds = new AllSameBounds(3)
        val OperationCallsDetermination calls = new FixedOperationCallsDetermination(1)
        val sequence = generateStateSequence
        (
            input.model,
            bounds,
            calls
        )

        LoadParametersExtensions.fcOption = FcOptions::explicitPostconditions
        useAlpha = false
        useAlpha = true
        val instance = encodeDynamicParallel
        (
            sequence,
            input.constraints,
            Pair::of(2,3)
            // i.e., at least 3 but at most 10 operation calls between two succeeding system states
        )

        /* Instantiate a Solver */
        val solver = new ModelFinderSolver()
        solver.solveAndPrintSolution(instance)
    }

    def void testExample21()
    {
        /* Instantiate a ModelLoader */
        val modelLoader = new ModelLoader
        val input = modelLoader.loadFromEcoreAndOCL
        (
            "models/Counter.ecore",
            "models/Counter.modifyStatements.ocl"
        )

        /* Instantiate a StateSequenceGenerator */
        val Bounds bounds = new AllSameBounds(3)
        val OperationCallsDetermination calls = new FixedOperationCallsDetermination(1)
        val sequence = generateStateSequence
        (
            input.model,
            bounds,
            calls
        )

        LoadParametersExtensions.fcOption = FcOptions::modifyStatements
        useAlpha = false
        useAlpha = true
        InstanceGeneratorImplTwoValuedOCL.modifyPropertiesStatementNameInPostconditions = "modifyProperties"
        val instance = encodeDynamicParallel
        (
            sequence,
            input.constraints,
            Pair::of(2,3)
            // i.e., at least 3 but at most 10 operation calls between two succeeding system states
        )

        /* Instantiate a Solver */
        val solver = new ModelFinderSolver()
        solver.solveAndPrintSolution(instance)
    }
}