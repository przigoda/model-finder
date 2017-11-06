package de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.examples

import de.agra.emf.metamodels.SMTlib2extended.Bitvector
import de.agra.emf.metamodels.SMTlib2extended.Predicate
import de.agra.emf.metamodels.SMTlib2extended.solver.SMT2Solver
import de.agra.emf.modelfinder.encoding.InstanceGenerator
import de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.ModelAssignment
import de.agra.emf.modelfinder.encoding.ModelFinderSolver
import de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.SMTLib2ConverterWithPlaceholder
import de.agra.emf.modelfinder.modelloader.ModelLoader
import de.agra.emf.modelfinder.statesequence.StateSequenceGenerator
import de.agra.emf.modelfinder.statesequence.StateSequenceImpl
import de.agra.emf.modelfinder.statesequence.bounds.AllSameBounds
import de.agra.emf.modelfinder.statesequence.bounds.Bounds
import de.agra.emf.modelfinder.statesequence.bounds.StaticBounds
import de.agra.emf.modelfinder.statesequence.determination.FixedOperationCallsDetermination
import de.agra.emf.modelfinder.statesequence.determination.NoOperationCallsDetermination
import de.agra.emf.modelfinder.statesequence.state.StateGenerator
import de.agra.emf.modelfinder.statesequence.state.StateObject
import java.io.FileOutputStream
import java.util.Collections
import java.util.Date
import java.util.HashSet
import java.util.Set
import junit.framework.TestCase

import static de.agra.emf.metamodels.SMTlib2extended.util.MetaModelExtensions.*
import static de.agra.emf.modelfinder.applications.tikzexport.TikZExport.*

import static extension de.agra.emf.modelfinder.statesequence.ResourceExtensions.*
import static de.agra.emf.modelfinder.statesequence.StateSequenceGenerator.*
import static de.agra.emf.modelfinder.encoding.LoadParametersExtensions.*
import static extension de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.InstanceGeneratorImplTwoValuedOCL.*
import de.agra.emf.modelfinder.statesequence.determination.OperationCallsDetermination
import java.math.BigInteger
import de.agra.emf.metamodels.SMTlib2extended.solver.Solver
import com.microsoft.z3.Context

class EncodingTest extends TestCase
{

    def void testTrafficLightsModell() {
        val modelLoader = new ModelLoader
//        val input = modelLoader.loadFromEcoreAndOCL("models/TrafficLights.ecore", "models/TrafficLights.ocl")
        val input = modelLoader.loadFromEcoreAndOCL("models/counters/ParameterCounter.ecore", "models/counters/ParameterCounter.ocl")

        val sequence = generateStateSequence
        (
            input.model,
            new AllSameBounds(3),
            new FixedOperationCallsDetermination(0)
        )

        val instance = encodeConsistency
        (
            sequence,
            input.constraints
        )

        val solver = new SMT2Solver()
        solver.showRvcdMessages = false
        solver.showAddedExpressions = false
//        solver.backend = "SMT2"
        solver.converter = new SMTLib2ConverterWithPlaceholder()
        solver.init
        solver.createVars(instance.variables)
        solver.addAssertions(instance.assertions)
        val sat = solver.solve()
        assertEquals(true, sat)

        val assigner = new ModelAssignment(instance)
        val solution = solver.getSolution(instance.variables)

        sequence.states.forEach[state, id|
            assigner.assignSolution(state,solution)
            state.save(new FileOutputStream('''/tmp/test-«id».ecore'''), Collections::EMPTY_MAP)
        ]

//        sequence.omegaTransitionInformation.allInformations.forEach[k,v|
//            println("i="+k+" endcodes "+v.key+"::"+v.value)
//        ]

        if (sat) {
            instance.variables
                    .filter[it.name.startsWith("omega")]
                    .forEach [ v |
                        switch(v){
                            Bitvector:{
                                val omegaNo = Integer::parseInt( v.name.split("@").head.substring(5))
                                val omegaValue = solution.get(v) as Integer
                                val belongsToTransition = "state"+omegaNo+"->"+"state"+(omegaNo+1)
                                sequence.transitions
                                        .filter[it.name == belongsToTransition].head
                                        .objects += sequence.omegaTransitionInformation.allInformations.get(omegaValue)
                            }
                        }
                    ]

//            sequence.transitions.forEach[ t |
//                println("Für den Übergang "+t.name + " wurden folgende Operationen ausgeführt:\n\t"+t.objects)
//            ]

            generateTikZCode("/home/oktavian/Desktop/sequence-test/test.tex", sequence)
        }

    }

    def void testTrafficLightsModelDeadlock() {
        val modelLoader = new ModelLoader
        val input = modelLoader.loadFromEcoreAndOCL("models/TrafficLights.ecore", "models/TrafficLights.ocl")
        val Bounds bounds = new AllSameBounds(1)

        val sequence = generateStateSequence(
            input.model,
            bounds,
            new FixedOperationCallsDetermination(3)
        )

        val initState = modelLoader.loadState("models/TrafficLights-init.xmi")
        sequence.states.get(0).assign(initState, input.model)

        val instance = encodeDynamic(sequence, input.constraints)

        instance.extendDynamicInstanceWithDeadlock
        (
            sequence,
            input.constraints,
            bounds
        )

        val solver = new ModelFinderSolver
        if (solver instanceof ModelFinderSolver) {
            (solver as ModelFinderSolver).setConverter
        }
        solver.init
        solver.addAssertions(instance.assertions)
        val sat = solver.solve

        if (sat) {
            println("SAT")
            val solution = solver.getSolution(instance.variables)
            new ModelAssignment(instance).assignSolution(sequence.states, solution)
            sequence.states.forEach[state, id|
                state.save(new FileOutputStream('''/tmp/test-«id».ecore'''), Collections::EMPTY_MAP)
            ]
        }
        else
        {
            println("UNSAT")
        }
    }

    def void testTrafficLightsModellExecutabilityAnwhere() {
        val modelLoader = new ModelLoader
        val input = modelLoader.loadFromEcoreAndOCL("models/TrafficLights.ecore", "models/TrafficLights.ocl")

        val Bounds bounds = new AllSameBounds(2)
        val sequence = generateStateSequence
        (
            input.model,
            bounds,
            new FixedOperationCallsDetermination(3)
        )

        sequence.states.get(0).assign(
            modelLoader.loadState("models/TrafficLights-init.xmi"),
            input.model
        )
//        sequence.states.get(0).assign(, input.model)

        val instance = encodeDynamic( sequence, input.constraints )

        val validOperationNames = new HashSet<Pair<String,String>>
        validOperationNames += "Button" -> "requesting" 
        validOperationNames += "TrafficLight" -> "switchPedLight"
        validOperationNames += "TrafficLight" -> "switchCarLight"
        instance.extendDynamicInstanceWithExecutabilityAnywhere(
            sequence,
            input.constraints,
            validOperationNames,
            new FixedOperationCallsDetermination(3)
        )

        val solver = new ModelFinderSolver
        solver.init
        solver.addAssertions(instance.assertions)
        val sat = solver.solve
        if (sat) {
            print ( "solve = SAT --> saving states now")
            val assigner = new ModelAssignment(instance)
            val solution = solver.getSolution(instance.variables)
            sequence.states.forEach[state, id|
                assigner.assignSolution(state, solution)
                state.save(new FileOutputStream('''/tmp/test-«id».ecore'''), Collections::EMPTY_MAP)
            ]
            print ( "--> DONE !\n")
        } else {
            println ( "solve = unSAT")
        }
    }

    def void testTrafficLightsModellExecutabilityLastState() {
        val modelLoader = new ModelLoader
        val input = modelLoader.loadFromEcoreAndOCL("models/TrafficLights.ecore", "models/TrafficLights.ocl")

        val Bounds bounds = new AllSameBounds(1)
        val ops = new FixedOperationCallsDetermination(0)
        val sequence = generateStateSequence
        (
            input.model,
            bounds,
            ops
        )

        val instance = encodeDynamic( sequence, input.constraints )

        // Add init state
//        val initState = modelLoader.loadState("models/TrafficLights-init.xmi")
//        generator.extendDynamicInstanceWithState(0, initState, states, instance)
        // Add Executability-clauses for the LastState
        val Set<Pair<String,String>> validOperationNames = new HashSet<Pair<String,String>>
        validOperationNames.add(Pair::of("Button","requesting"))
        validOperationNames.add(Pair::of("TrafficLight","switchCarLight"))
        validOperationNames.add(Pair::of("TrafficLight","switchPedLight"))

        instance.extendDynamicInstanceWithExecutabilityLastState(
            sequence,
            input.constraints,
            validOperationNames,
            bounds,
            ops
        )

        val solver = new SMT2Solver()
        solver.converter = new SMTLib2ConverterWithPlaceholder()
        solver.init

        solver.createVars(instance.variables)
        solver.addAssertions(instance.assertions)

//        assertEquals( true, solver.solve(instance) )

        val Boolean sat = solver.solve        if (sat) {
            print ( "solve = SAT --> saving states now")
            val assigner = new ModelAssignment(instance)
            val solution = solver.getSolution(instance.variables)
            sequence.states.forEach[state, id|
                assigner.assignSolution(state, solution)
                state.save(new FileOutputStream('''/tmp/test-«id».ecore'''), Collections::EMPTY_MAP)
            ]
            print ( "--> DONE !\n")
        } else {
            println ( "solve = unSAT")
        }
    }

    def void testCounterExecutabilityAnywhereAndLastState() {
        val modelLoader = new ModelLoader
        val input = modelLoader.loadFromEcoreAndOCL("models/Counter.ecore", "models/Counter.ocl")

        val Bounds bounds = new AllSameBounds(5)
        val ops = new FixedOperationCallsDetermination(3)
        val sequence = generateStateSequence
        (
            input.model,
            bounds,
            new FixedOperationCallsDetermination(3)
        )
        sequence.states.get(0).assign(modelLoader.loadState("models/Counter-init.xmi"), input.model)

        val instance = encodeDynamic( sequence, input.constraints )

        val Set<Pair<String,String>> validOperationNames = new HashSet<Pair<String,String>>
        validOperationNames += "Counter" -> "count" 
        validOperationNames += "Counter" -> "count2"
        validOperationNames += "Counter" -> "count3"

        // Add Executability-clauses over all states
        instance.extendDynamicInstanceWithExecutabilityAnywhere(
            sequence,
            input.constraints,
            validOperationNames,
            new FixedOperationCallsDetermination(3)
        )

        // Add Executability-clauses for the LastState
        instance.extendDynamicInstanceWithExecutabilityLastState(
            sequence,
            input.constraints,
            validOperationNames,
            bounds,
            ops
        )

        val solver = new ModelFinderSolver
        solver.init

        solver.addAssertions(instance.assertions)
        val sat = solver.solve
        if (sat) {
            print ( "solve = SAT --> saving states now")
            val assigner = new ModelAssignment(instance)
            val solution = solver.getSolution(instance.variables)
            sequence.states.forEach[state, id|
                assigner.assignSolution(state, solution)
                state.save(new FileOutputStream('''/tmp/test-«id».ecore'''), Collections::EMPTY_MAP)
            ]
            print ( "--> DONE !\n")
        } else {
            println ( "solve = unSAT")
        }
    }

    def void testSimpleCounter() {
try {
        val Context context = new Context

//        context.mkl

        context.mkConst
        (
            "myBoolVar3",
            context.mkBoolSort
        )

        val se = context.parseSMTLIB2String(
//"(assert (let ((a!1 |myBoolVar1|) (a!2 |myBoolVar2|))
//              (and a!1 a!2 true)
//         )
			"(assert (and |myBoolVar11| |myBoolVar222| true)
)", #[], #[], #[], #[])
        val tmp = se.args
        println("wait")
        se.args.get(0)
    
} catch (Exception e)
{
    println("wait here")
    print(e)
}
        
        /*
         * 
        useAlpha = false
        val modelLoader = new ModelLoader
        val input = modelLoader.loadFromEcoreAndOCL
        (
            "models/Counter.ecore",
            "models/Counter.ocl"
        )

        val sequence = generateStateSequence
        (
            input.model,
            new AllSameBounds(2),
            new FixedOperationCallsDetermination
        )
        sequence.states.get(0).assign(modelLoader.loadState("models/Counter-init3.xmi"), input.model)

        val instance = encodeDynamic
        (
            sequence,
            input.constraints
        )

        val solver = new ModelFinderSolver
//        val solver = new SMT2Solver
//        solver.converter = new SMTLib2ConverterWithPlaceholder
        solver.showAddedExpressions = true
        solver.init()
//        solver.createVars(instance.variables)
        solver.addAssertions(instance.assertions)
        val sat = solver.solve

        if (sat) {
            println("SAT")
//            val assigner = new ModelAssignment(instance)
            val solution = solver.getSolution(instance.variables)
            solution.forEach[k, v|
                if (k instanceof Bitvector)
                {
                    val String vAsBitString = Integer.toBinaryString( v as Integer)
                    println(k.name + "\t" + v + "\t" + vAsBitString)
                }
                else
                {
                    println(k.name + "\t"+v)
                }
            ]
//            sequence.states.forEach[state, id|
//                assigner.assignSolution(state, solution)
//                state.save(new FileOutputStream('''/tmp/test-«id».ecore'''), Collections::EMPTY_MAP)
//            ]
        }
        * 
        */
    }

    def void testSimpleCounterParallel() {
        useAlpha = false
        useAlpha = true
        val modelLoader = new ModelLoader
        val input = modelLoader.loadFromEcoreAndOCL
        (
            "models/Counter.ecore",
            "models/Counter.ocl"
        )

        val Bounds bounds = new AllSameBounds(10)
        val OperationCallsDetermination calls = new FixedOperationCallsDetermination(5)
        val sequence = generateStateSequence
        (
            input.model,
            bounds,
            calls
        )

        val instance = encodeDynamicParallel
        (
            sequence,
            input.constraints,
            Pair::of(3,10)
        )

        val solver = new ModelFinderSolver
//        val solver = new SMT2Solver
//        solver.converter = new SMTLib2ConverterWithPlaceholder
        solver.showAddedExpressions = true
        solver.init()
//        solver.createVars(instance.variables)
        solver.addAssertions(instance.assertions)
        val sat = solver.solve

        if (sat)
        {
            println("SAT")
            val solution = solver.getSolution(instance.variables)
            solution.forEach[k, v|
                if (k instanceof Bitvector)
                {
                    val String vAsBitString = Integer.toBinaryString( v as Integer)
                    println(k.name + "\t" + v + "\t" + vAsBitString)
                }
                else
                {
                    println(k.name + "\t"+v)
                }
            ]
        }
        else
        {
            println("UNSAT")
        }
    }


    def void testSimpleBankParallel() {
        useAlpha = false
        useAlpha = true
        intBitwidth = 6
        val modelLoader = new ModelLoader
        val input = modelLoader.loadFromEcoreAndOCL
        (
            "models/bank/SimpleBank.ecore",
            "models/bank/SimpleBank.ocl"
        )

        val Bounds bounds = new AllSameBounds(3)
        val OperationCallsDetermination calls = new FixedOperationCallsDetermination(1)
        val sequence = generateStateSequence
        (
            input.model,
            bounds,
            calls
        )

        val instance = encodeDynamicParallel
        (
            sequence,
            input.constraints,
            Pair::of(3,5)
        )

        val solver = new ModelFinderSolver
//        val solver = new SMT2Solver
//        solver.converter = new SMTLib2ConverterWithPlaceholder
        solver.showAddedExpressions = true
        solver.init()
//        solver.createVars(instance.variables)
        solver.addAssertions(instance.assertions)
        val sat = solver.solve

        println(sequence.omegaTransitionInformation.allInformations)

        if (sat)
        {
            println("SAT")
            val solution = solver.getSolution(instance.variables)
            solution.forEach[k, v|
                if (k instanceof Bitvector)
                {
                    val String vAsBitString = Integer.toBinaryString( v as Integer)
                    println(k.name + "\t" + v + "\t" + vAsBitString)
                }
                else
                {
                    println(k.name + "\t"+v)
                }
            ]
        }
        else
        {
            println("UNSAT")
        }
    }

    def void testSimpleBankParallel2() {
        useAlpha = true
        useAlpha = false
        intBitwidth = 8
        val modelLoader = new ModelLoader
        val input = modelLoader.loadFromEcoreAndOCL
        (
            "models/bank/SimpleBankWithAccountClasses.ecore",
            "models/bank/SimpleBankWithAccountClasses.ocl"
        )

        val boundsMap =
        #{
            "Person" -> 5,
            "Bank" -> 1,
            "Account1" -> 1,
            "Account2" -> 1,
            "Account3" -> 1,
            "Account4" -> 1,
            "Account5" -> 1
        }
        val Bounds bounds = new StaticBounds(input.model, boundsMap)
        val OperationCallsDetermination calls = new FixedOperationCallsDetermination(2)
        val sequence = generateStateSequence
        (
            input.model,
            bounds,
            calls
        )

        val instance = encodeDynamicParallel
        (
            sequence,
            input.constraints,
            Pair::of(2,5)
        )

        val solver = new ModelFinderSolver
//        val solver = new SMT2Solver
//        solver.converter = new SMTLib2ConverterWithPlaceholder
        solver.showAddedExpressions = true
        solver.init()
//        solver.createVars(instance.variables)
        solver.addAssertions(instance.assertions)
        val sat = solver.solve

        println(sequence.omegaTransitionInformation.allInformations)

        if (sat)
        {
            println("SAT")
            val solution = solver.getSolution(instance.variables)
            solution.forEach[k, v|
                if (k instanceof Bitvector)
                {
                     val String vAsBitString =
                        if (v instanceof Integer)
                        {
                            Integer.toBinaryString(v)
                        }
                        else if (v instanceof BigInteger)
                        {
                            v.toString(2)
                        }
                        else
                            throw new Exception("EInt is neither an Integer nor a BigInteger")
                    println(k.name + "\t" + v + "\t" + vAsBitString)
                }
                else
                {
                    println(k.name + "\t"+v)
                }
            ]
        }
        else
        {
            println("UNSAT")
        }
    }

    def void testParameterCounter() {
        val modelLoader = new ModelLoader
        val input = modelLoader.loadFromEcoreAndOCL("models/counters/ParameterCounter.ecore", "models/counters/ParameterCounter.ocl")
        val sequence = generateStateSequence
        (
            input.model,
            new AllSameBounds,
            new FixedOperationCallsDetermination
        )
        sequence.states.head.assign(modelLoader.loadState("models/counters/ParameterCounter.xmi"), input.model)

        val instance = encodeDynamic(sequence, input.constraints)

        /*val solver = new ModelFinderSolver
        solver.showAddedExpressions = true
        
        if (solver.solve(instance)) {
            new ModelAssignment(instance).assignSolution(sequence.states, solver.solution)
            sequence.states.forEach[state, id |
                state.save(new FileOutputStream('''/tmp/test-«id».ecore'''), Collections::EMPTY_MAP)
            ]
        }*/
         
        val solver = new SMT2Solver
        solver.init
        solver.converter = new SMTLib2ConverterWithPlaceholder()
        solver.showAddedExpressions = true;
        solver.formatAsserts = true;

        /*
        val sat = solver.solve
        assertEquals(true, sat)


        val assigner = new ModelAssignment(instance)
        assigner.show = true
//        assigner.assignSolution(state, solver.solution)
        val solution = solver.getSolution(instance.variables)

        states.forEach[state, id|
            assigner.assignSolution(state, solution)
            state.save(new FileOutputStream('''/tmp/test-«id».ecore'''), Collections::EMPTY_MAP)
        ]
        
        assigner.printOmegas(solution, input.model, states)
         * */
    }

    def void testConsistency() {
        val modelLoader = new ModelLoader
        val input = modelLoader.loadFromEcoreAndOCL("models/AllInstancesOperations.ecore", "models/AllInstancesOperations.ocl")

        val sequence = generateStateSequence
        (
            input.model,
            new StaticBounds(input.model, #{"Configuration" -> 1, "A" -> 3, "B" -> 3, "C" -> 1}),
            new NoOperationCallsDetermination
        )
        val state = sequence.states.head

        val instance = encodeConsistency
        (
            sequence,
            input.constraints
        )

        val before = new Date
        val solver = new ModelFinderSolver
        solver.init
        solver.addAssertions(instance.assertions)
        assertEquals(true, solver.solve)
        val diff = (new Date().time - before.time) / 1000.0
        println('''Test took «diff» seconds.''')

        val assigner = new ModelAssignment(instance)
        val solution = solver.getSolution(instance.variables)
        assigner.assignSolution(state, solution)
        assertTrue(modelLoader.validate(state, input.constraints))

        state.save(new FileOutputStream("/tmp/test.xmi"), Collections::EMPTY_MAP)
    }

    def void testAssignment() {
        val modelLoader = new ModelLoader
        val input = modelLoader.loadFromEcoreAndOCL("models/Simple.ecore", "models/Simple.ocl")

        val sequence = generateStateSequence
        (
            input.model,
            new AllSameBounds,
            new NoOperationCallsDetermination
        )
        val state = sequence.states.head

        // Assign
        val obj = state.contents.head as StateObject
        val attribute = obj.eClass.getEAttributes.head
        obj.eSet(attribute, 13)

        val instance = encodeConsistency
        (
            sequence,
            input.constraints
        )

        val solver = new ModelFinderSolver
        solver.init
        solver.addAssertions(instance.assertions)
        assertEquals(true, solver.solve)

        val assigner = new ModelAssignment(instance)
        val solution = solver.getSolution(instance.variables)
        assigner.assignSolution(state, solution)
        assertTrue(modelLoader.validate(state, input.constraints))

        state.save(new FileOutputStream("/tmp/test.xmi"), Collections::EMPTY_MAP)
    }

    def void testSingleReferences() {
        val modelLoader = new ModelLoader
        val input = modelLoader.loadFromEcoreAndOCL("models/people/YoungerWives.ecore", "models/people/YoungerWives.ocl")

        val sequence = generateStateSequence
        (
            input.model,
            new AllSameBounds(3),
            new NoOperationCallsDetermination
        )
        val state = sequence.states.head

        val instance = encodeConsistency(sequence, input.constraints)

        val solver = new ModelFinderSolver
        solver.showAddedExpressions = true

//        val solver = new SMT2Solver
//        solver.converter = new SMTLib2ConverterWithPlaceholder()
        solver.init
        solver.showAddedExpressions = true
//        solver.formatAsserts = false;
//        solver.createVars(instance.variables)
        solver.addAssertions(instance.assertions)

        val sat = solver.solve
        assertEquals(true, sat)

        val assigner = new ModelAssignment(instance)
        assigner.show = true
        val solution = solver.getSolution(instance.variables)
        assigner.assignSolution(state, solution)

        //assertTrue(modelLoader.validate(state, input.constraints))
        state.save(new FileOutputStream("/tmp/test.xmi"), Collections::EMPTY_MAP)
    }

    def void testManyReferences() {
        // the word "many" refers to the many-kind of tested references
        val modelLoader = new ModelLoader
        val input = modelLoader.loadFromEcoreAndOCL("models/people/MomWithKids.ecore", "models/people/MomWithKids.ocl")

        val bounds = new StaticBounds(input.model, #{"Mother" -> 1, "Child" -> 3})

        val sequence = generateStateSequence
        (
            input.model,
            bounds,
            new NoOperationCallsDetermination
        )
        val state = sequence.states.head

        val instance = encodeConsistency(
            sequence,
            input.constraints
        )

        val solver = new ModelFinderSolver
        solver.init
        solver.addAssertions(instance.assertions)
        solver.showAddedExpressions = true
        assertEquals(true, solver.solve)

        val assigner = new ModelAssignment(instance)
        val solution = solver.getSolution(instance.variables)
        assigner.assignSolution(state, solution)

        //assertTrue(modelLoader.validate(state, input.constraints))
        state.save(new FileOutputStream("/tmp/test.xmi"), Collections::EMPTY_MAP)
    }

    def void generateTest(String name) {
        generateTest(name + ".ecore", name + ".ocl")
    }

    def void generateTest(String ecoreFile, String oclFile)
    {
        val modelLoader = new ModelLoader

        // Loads the model in the input that is used for the generators
        val input = modelLoader.loadFromEcoreAndOCL("models/operators/OpModel.ecore", oclFile)

        val sequence = generateStateSequence
        (
            input.model,
            new AllSameBounds,
            new NoOperationCallsDetermination
        )
        val state = sequence.states.head

        val instance = encodeConsistency
        (
            sequence,
            input.constraints
        )

        val solver = new ModelFinderSolver
//        val solver = new SMT2Solver()
//        solver.converter = new SMTLib2ConverterWithPlaceholder()
        solver.init
        solver.addAssertions(instance.assertions)
        assertTrue(solver.solve) 

        val assigner = new ModelAssignment(instance)
        val solution = solver.getSolution(instance.variables)
        assigner.assignSolution(state, solution)

        println("\n\nVariable assignment")
        solution.forEach[p1, p2|println(p1.name + "\t=\t" + p2)]
    }

    def void testOperators() {
        testNotOperator
        testAndOperator
        testOrOperator
//        testLessOperator
        testMulOperator
        testAddOperator
        testImpliesOperator
    }

    def void testImpliesOperator() {
        generateTest("models/operators/ImpliesTest")
    }

    def void testAddOperator() {
        generateTest("models/operators/AddTest")
    }

    def void testMulOperator() {
        generateTest("models/operators/MulTest")
    }

    def void testNotOperator() {
        generateTest("models/operators/NotTest")
    }

    def void testAndOperator() {
        generateTest("models/operators/AndTest")
    }

    def void testEqualsOperator() {
        generateTest("models/operators/EqualsTest")
    }

    def void testOrOperator() {
        generateTest("models/operators/OrTest")
    }

    def void testLessOperator() {
//        generateTest("models/operators/LessTest")
    }

    def void testConsistencyCompact() {
        // Read input from ECore model and OCL constraints
        val input = (new ModelLoader).loadFromEcoreAndOCL("models/Simple.ecore", "models/Simple.ocl")

        // Generate a sequence of system states for transformation
        val sequence = generateStateSequence
        (
            input.model,
            new AllSameBounds,
            new NoOperationCallsDetermination
        )
        val state = sequence.states.head

        // Generate an SMT instance
        val instance = encodeConsistency(sequence, input.constraints)

        // Solve the SMT instance
        val solver = new SMT2Solver
        solver.init
        solver.converter = new SMTLib2ConverterWithPlaceholder()
        solver.createVars(instance.variables)
        solver.addAssertions(instance.assertions)
        solver.solve

        // Assign the solution to the state
        val solution = solver.getSolution(instance.variables)
        new ModelAssignment(instance).assignSolution(state, solution)

        // Write state into a file
        state.save(new FileOutputStream("/tmp/test.ecore"), Collections::EMPTY_MAP)
    }

    def void testConsistencyCompact2() {
        // Read input from ECore model and OCL constraints
        val input = (new ModelLoader).loadFromEcoreAndOCL("models/Triangle.ecore", "models/Triangle.ocl")

        // Generate a sequence containing exactly one system state for transformation
        val sequence = generateStateSequence
        (
            input.model,
            new AllSameBounds,
            new NoOperationCallsDetermination
        )
        val state = sequence.states.head

        // Generate an SMT instance
        val instance = encodeConsistency(sequence, input.constraints)

        // Solve the SMT instance
        val solver = new SMT2Solver
        solver.converter = new SMTLib2ConverterWithPlaceholder()
        solver.init
        solver.createVars(instance.variables)
        solver.addAssertions(instance.assertions)
        solver.solve

        // Assign the solution to the state
        val solution = solver.getSolution(instance.variables)
        new ModelAssignment(instance).assignSolution(state, solution)

        // Write state into a file
        state.save(new FileOutputStream("/tmp/test.ecore"), Collections::EMPTY_MAP)
    }

    def void testAllInstancesOperations() {
        val input = (new ModelLoader).loadFromEcoreAndOCL("models/AllInstancesOperations.ecore", "models/AllInstancesOperations.ocl")

        val bounds = new StaticBounds(input.model, #{'Configuration' -> 1, 'A' -> 3, 'B' -> 3, 'C' -> 3})

        val sequence = generateStateSequence
        (
            input.model,
            bounds,
            new NoOperationCallsDetermination
        )

        encodeConsistency(sequence, input.constraints)
    }

    def void testBooleans() {
        val input = (new ModelLoader).loadFromEcoreAndOCL("models/Booleans.ecore", "models/Booleans.ocl")
        val sequence = generateStateSequence
        (
            input.model,
            new AllSameBounds,
            new NoOperationCallsDetermination
        )
        val state = sequence.states.head
        val instance = encodeConsistency(sequence, input.constraints)
        val solver = new SMT2Solver
        solver.converter = new SMTLib2ConverterWithPlaceholder()
        solver.init
        solver.createVars(instance.variables)
        solver.addAssertions(instance.assertions)
        solver.solve
        val solution = solver.getSolution(instance.variables)
        new ModelAssignment(instance).assignSolution(state, solution)
        state.save(new FileOutputStream("/tmp/Booleans.ecore"), Collections::EMPTY_MAP)
    }

    // TODO this test still fails. Some multimethod is missing
    def void testEMFtoCSPBenchmarks() {
        val input = (new ModelLoader).loadFromEcoreAndOCL("models/emftocsp/Papers-Researchers.ecore", "models/emftocsp/Papers-Researchers.ocl")
        println("1")
        val bounds = new StaticBounds(input.model, #{'Paper' -> 2, 'Researcher' -> 4})
        println("2")
        val sequence = generateStateSequence
        (
            input.model,
            bounds,
            new NoOperationCallsDetermination
        )
        println("3")
        encodeConsistency(sequence, input.constraints)
        println("4")
    }

    def void testMetaSMT() {
        val instance = factory.createInstance

        val x = factory.createBitvector
        x.name = "x"
        x.width = 3
        instance.variables += x

        val y = factory.createBitvector
        y.name = "y"
        y.width = 3
        instance.variables += y

        val expr_x = factory.createVariableExpression
        expr_x.variable = x

        val expr_y = factory.createVariableExpression
        expr_y.variable = y

        val eq_expr = factory.createEqualsExpression
        eq_expr.lhs = expr_x
        eq_expr.rhs = expr_y

        instance.assertions += eq_expr

        val card_eq = factory.createCardLeExpression
        card_eq.k = 1
        val card_eq_b0 = factory.createPredicate
        card_eq_b0.name = "card_eq_b0";  instance.variables += card_eq_b0;
        card_eq.expressions += factory.createVariableExpression => [
                                    variable = card_eq_b0
                                ]
        val card_eq_b1 = factory.createPredicate
        card_eq_b1.name = "card_eq_b1";  instance.variables += card_eq_b1;
        card_eq.expressions += factory.createVariableExpression => [
                                    variable = card_eq_b1
                                ]
        val card_eq_b2 = factory.createPredicate
        card_eq_b2.name = "card_eq_b2";  instance.variables += card_eq_b2;
        card_eq.expressions += factory.createVariableExpression => [
                                    variable = card_eq_b2
                                ]
        val card_eq_b3 = factory.createPredicate
        card_eq_b3.name = "card_eq_b3";  instance.variables += card_eq_b3;
        card_eq.expressions += factory.createVariableExpression => [
                                    variable = card_eq_b3
                                ]

        instance.assertions += card_eq

        val cardinalty_x = factory.createCardGeExpression
        cardinalty_x.k = 1
        cardinalty_x.expressions += expr_x
        instance.assertions += cardinalty_x

        val cardinalty_y = factory.createCardLeExpression
        cardinalty_y.k = 2
        cardinalty_y.expressions += expr_y
        instance.assertions += cardinalty_y

        val cardinalty_xy = factory.createCardEqExpression
        cardinalty_xy.k = 4
        cardinalty_xy.expressions += expr_x
        cardinalty_xy.expressions += expr_y
        instance.assertions += cardinalty_xy

        val solver = new SMT2Solver
        solver.init
        solver.createVars(instance.variables)
        solver.addAssertions(instance.assertions)
        val sat = solver.solve

        if (sat) {
            val solution = solver.getSolution(instance.variables)
            instance.variables.forEach [ v |
                switch(v){
                Predicate: {
                    println(v.name+" "+(solution.get(v) as Boolean))
                }
                Bitvector:{
                    println(v.name+" "+(solution.get(v) as Integer))
                }}
            ]
        }
    }

def void testPhiloPlate() {
	
		val time1 = new Date
	
        val modelLoader = new ModelLoader
        val input = modelLoader.loadFromEcoreAndOCL("models/people/PhilosophersPlate.ecore", "models/people/PhilosophersPlate.ocl")

		val time2 = new Date

        println('''ModelLoading took «((time2.time - time1.time) / 1000.0)» seconds.''')

        //val state = stateGenerator.generate(new AllSameBounds(3), new NoOperationCallsDetermination).head

        val sequence = generateStateSequence
        (
            input.model,
            new AllSameBounds(3),
            new FixedOperationCallsDetermination(0)
        )

        //val initState = modelLoader.loadState("models/people/PhilosPlateInit3.xmi")
        // states.get(0).assign(initState, input.model)

        val time3 = new Date
        println('''StateGeneration took «((time3.time - time2.time) / 1000.0)» seconds.''')        

        val instance = encodeDynamic( sequence, input.constraints )

        instance.extendDynamicInstanceWithDeadlock
        (
            sequence,
            input.constraints,
            new AllSameBounds(3)
        )

        val time4 = new Date
        println('''InstanceGeneration took «((time4.time - time3.time) / 1000.0)» seconds.''')
       /* val solver = new ModelFinderSolver
        solver.showAddedExpressions = true  /* */

        val solver = new ModelFinderSolver
        if (solver instanceof ModelFinderSolver) {
            (solver as ModelFinderSolver).setConverter
        }
        solver.init()
        solver.addAssertions(instance.assertions)
        val sat = solver.solve
        assertEquals(true, sat)
        
        val diff = (new Date().time - time4.time) / 1000.0
        println('''Solving took «diff» seconds.''')

        val assigner = new ModelAssignment(instance)
        assigner.show = false
//        assigner.assignSolution(state, solver.solution)

        val solution = solver.getSolution(instance.variables)
        sequence.states.forEach[state, id|
            assigner.assignSolution(state, solution)
            state.save(new FileOutputStream('''/tmp/test-«id».ecore'''), Collections::EMPTY_MAP)
        ]
        
        assigner.printOmegas(solution, input.model, sequence.states)
    }

def void testScheduler() {
        val modelLoader = new ModelLoader
        val input = modelLoader.loadFromEcoreAndOCL("models/structures/Scheduler.ecore", "models/structures/Scheduler.ocl")
        val bounds = new StaticBounds(input.model, #{"Scheduler" -> 1, "Process" -> 3})
        //val state = stateGenerator.generate(new AllSameBounds(3), new NoOperationCallsDetermination).head
        val sequence = generateStateSequence
        (
            input.model,
            bounds,
            new FixedOperationCallsDetermination(3)
        )

        //val initState = modelLoader.loadState("models/people/PhilosPlateInit3.xmi")
       // states.get(0).assign(initState, input.model)

        val instance = encodeDynamic
        (
            sequence,
            input.constraints
        )

        //generator.extendDynamicInstanceWithDeadlock( states, input.constraints, new AllSameBounds(3), stateGenerator, instance)

        //val om0 = factory.createPredicate
        //om0.name = "omega0"; 

        //constrain omega0

        val eq_expr = factory.createEqualsExpression
        eq_expr.lhs = factory.createVariableExpression => [
                                    variable = instance.variables.filter[ it.name == "omega0" ].head
                                ]
        eq_expr.rhs = factory.createConstIntegerExpression => [
            width = 2
            value = 0
        ]

        //instance.assertions += eq_expr   

        // constraint omega1
        val eq_expr1 = factory.createEqualsExpression
        eq_expr1.lhs = factory.createVariableExpression => [
                                    variable = instance.variables.filter[ it.name == "omega1" ].head
                                ]
        eq_expr1.rhs = factory.createConstIntegerExpression => [
            width = 2
            value = 3
        ]
        //instance.assertions += eq_expr1

        val eq_expr2 = factory.createEqualsExpression
        eq_expr2.lhs = factory.createVariableExpression => [
            variable = instance.variables.filter[ it.name == "Scheduler::state2::Process@0::schedWaiting" ].head
        ]
        eq_expr2.rhs = factory.createConstIntegerExpression => [
            width = 1
            value = 1
        ]

        //instance.assertions += eq_expr2
        /*val solver = new ModelFinderSolver
        solver.showAddedExpressions = true /* */

        val solver = new SMT2Solver
        solver.converter = new SMTLib2ConverterWithPlaceholder()
        solver.showAddedExpressions = true;
        solver.formatAsserts = false;
        solver.init
        solver.createVars(instance.variables)
        solver.addAssertions(instance.assertions)

        val sat = solver.solve
        assertEquals(true, sat)

        val assigner = new ModelAssignment(instance)
        val solution = solver.getSolution(instance.variables)
        assigner.show = true
//        assigner.assignSolution(state, solver.solution)

        sequence.states.forEach[state, id|
            assigner.assignSolution(state, solution)
            state.save(new FileOutputStream('''/tmp/test-«id».ecore'''), Collections::EMPTY_MAP)
        ]
        assigner.printOmegas(solution, input.model, sequence.states)
    }
}
