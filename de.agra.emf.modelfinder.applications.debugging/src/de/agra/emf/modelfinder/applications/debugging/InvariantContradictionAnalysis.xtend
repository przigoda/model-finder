package de.agra.emf.modelfinder.applications.debugging

import de.agra.emf.metamodels.SMTlib2extended.Bitvector

import de.agra.emf.metamodels.SMTlib2extended.Expression
import de.agra.emf.metamodels.SMTlib2extended.IteExpression
import de.agra.emf.metamodels.SMTlib2extended.Predicate
import de.agra.emf.metamodels.SMTlib2extended.Variable
import de.agra.emf.metamodels.SMTlib2extended.solver.Solver
import de.agra.emf.modelfinder.encoding.InstanceGenerator
import de.agra.emf.modelfinder.encoding.ModelFinderSolver
import de.agra.emf.modelfinder.modelloader.ModelLoader
import de.agra.emf.modelfinder.statesequence.bounds.Bounds
import de.agra.emf.modelfinder.statesequence.bounds.StaticBounds
import de.agra.emf.modelfinder.statesequence.determination.FixedOperationCallsDetermination
import de.agra.emf.modelfinder.statesequence.state.StateGenerator
import java.util.ArrayList
import java.util.HashSet
import java.util.List
import java.util.Map
import java.util.Set
import org.eclipse.emf.common.util.BasicEList
import org.eclipse.emf.common.util.EList

import static de.agra.emf.modelfinder.utils.MathUtilsExtensions.*
import static de.agra.emf.modelfinder.utils.StringUtilsExtensions.*
import static de.agra.emf.modelfinder.statesequence.StateSequenceGenerator.*
import de.agra.emf.modelfinder.statesequence.determination.NoOperationCallsDetermination
import static extension de.agra.emf.metamodels.SMTlib2extended.util.MetaModelExtensions.*
import static extension de.agra.emf.modelfinder.encoding.InstanceGenerator.*
import de.agra.emf.modelfinder.encoding.ModelAssignment
import java.io.FileOutputStream
import java.util.Collections

class InvariantContradictionAnalysis {

    @Property String ecoreFile  = null
    @Property String oclFile    = null
    @Property Solver solver     = null
//    @Property Solver solver = new SMT2Solver()

    new() {
//        solver.converter = new SMTLib2ConverterWithPlaceholder();
//        solver.manyCalls = true
//        solver.showSendMessages = false
//        solver.showRvcdMessages = false
    }

    new(String _ecoreFile, String _oclFile) {
//        this.solver.converter = new SMTLib2ConverterWithPlaceholder()
//        this.solver.manyCalls = true
//        this.solver.showSendMessages = false
//        this.solver.showRvcdMessages = false
        this.ecoreFile = _ecoreFile
        this.oclFile   = _oclFile
    }

   def void findContradictorilyInvariants_generell(int modus, Map boundsMap) {
        if (ecoreFile == null) {
            throw new Exception('no ecore file specified')
        }
        if (oclFile == null) {
            throw new Exception('no ocl file specified')
        }
        if (_solver == null) {
            throw new Exception('no solver set')
        }
        _solver = new ModelFinderSolver

        val modelLoader = new ModelLoader
        val input = modelLoader.loadFromEcoreAndOCL(ecoreFile, oclFile)

        val Bounds bounds = new StaticBounds(input.model, boundsMap)
        val calls = new NoOperationCallsDetermination
        val sequence = generateStateSequence(
            input.model,
            bounds,
            calls
        )

        val instance = debugContradictionAnalysis
        (
            sequence,
            input.constraints
        )

        val ArrayList<String> solutionSet = new ArrayList<String>();

        {
            val noOfAs = sequence.states.head.contents
                               .filter[it.toString.split("::").get(2).split("@").get(0) == "A"]
                               .length
            val noOfBs = sequence.states.head.contents
                               .filter[it.toString.split("::").get(2).split("@").get(0) == "B"]
                               .length;
            val noOfCs = sequence.states.head.contents
                               .filter[it.toString.split("::").get(2).split("@").get(0) == "C"]
                               .length
            val noOfDs = sequence.states.head.contents
                               .filter[it.toString.split("::").get(2).split("@").get(0) == "D"]
                               .length;

            {// manual encoding for i2:
                val selectVarNo = instance.variables.filter[it.name.startsWith("s") && (!it.name.contains("::"))].length

                println( "i2 belongsTo s" + selectVarNo )
                val s_i = factory.createPredicate => [name = "s"+selectVarNo]
                instance.variables += s_i
                val s_i_expr = newVariableExpression(s_i)

                val B_alpha_expr = newVariableExpression(
                    instance.variables.findFirst[ it.name == "FaultyUMLmodel4::state0::B::alpha"]
                )

                instance.assertions += factory.createOrExpression => [
                    expressions += s_i_expr
                    expressions += factory.createAndExpression => [
                        expressions += (0..<noOfBs).map[ i |
                            factory.createImpliesExpression => [
                                lhs = factory.createExtractIndexExpression => [
                                    start = i
                                    end =i
                                    expr = B_alpha_expr
                                ]
                                val variableSet = 
                                        (0..<noOfAs).map[ j |
                                            factory.createIteExpression => [
                                                condition = factory.createExtractIndexExpression => [
                                                    start = j
                                                    end = j
                                                    expr = newVariableExpression(
                                                        instance.variables.findFirst[ it.name == "FaultyUMLmodel4::state0::B@"+i+"::BA"]
                                                    )
                                                ]
                                                thenexpr = factory.createIteExpression => [
                                                    condition = newVariableExpression(
                                                        instance.variables.findFirst[ it.name == "FaultyUMLmodel4::state0::A@"+j+"::w"]
                                                    )
                                                    thenexpr = factory.createBitstringExpression => [
                                                        value = "00000000"
                                                    ]
                                                    elseexpr = factory.createBitstringExpression => [
                                                    value = "00000001"
                                                ]
                                                ]
                                                elseexpr = factory.createBitstringExpression => [
                                                    value = "00000000"
                                                ]
                                            ]
                                        ]
                                rhs = factory.createEqualsExpression => [
                                    lhs = addExpressions( variableSet )
                                    rhs = factory.createConstIntegerExpression => [
                                        value = 1
                                        width = 8
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            }

            {// manual encoding for i6:
                val selectVarNo = instance.variables.filter[it.name.startsWith("s") && (!it.name.contains("::"))].length

                println( "i6 belongsTo s" + selectVarNo )
                val s_i = factory.createPredicate => [name = "s"+selectVarNo]
                instance.variables += s_i
                val s_i_expr = newVariableExpression(s_i)

                val D_alpha_expr = newVariableExpression(
                    instance.variables.findFirst[ it.name == "FaultyUMLmodel4::state0::D::alpha"]
                )

                instance.assertions += factory.createOrExpression => [
                    expressions += s_i_expr
                    expressions += factory.createAndExpression => [
                        expressions += (0..<noOfDs).map[ i |
                            factory.createImpliesExpression => [
                                lhs = factory.createExtractIndexExpression => [
                                    start = i
                                    end = i
                                    expr = D_alpha_expr
                                ]
                                rhs = factory.createAndExpression => [
                                    expressions +=
                                        (0..<noOfCs).map[ j |
                                            factory.createImpliesExpression => [
                                                lhs = factory.createExtractIndexExpression => [
                                                    start = j
                                                    end = j 
                                                    expr = newVariableExpression(
                                                        instance.variables.findFirst[ it.name == "FaultyUMLmodel4::state0::D@"+i+"::DC"]
                                                    )
                                                ]
                                                rhs = factory.createLessExpression => [
                                                    lhs = newVariableExpression(
                                                        instance.variables.findFirst[ it.name == "FaultyUMLmodel4::state0::C@"+j+"::u"]
                                                    )
                                                    rhs = factory.createConstIntegerExpression => [
                                                        value = 10
                                                        width = 8
                                                        ]
                                                ]
                                            ]
                                        ]
                                ]
                            ]
                        ]
                    ]
                ]
            }

            {// manual encoding for i7:
                val selectVarNo = instance.variables.filter[it.name.startsWith("s") && (!it.name.contains("::"))].length

                println( "i7 belongsTo s" + selectVarNo )
                val s_i = factory.createPredicate => [name = "s"+selectVarNo]
                instance.variables += s_i
                val s_i_expr = newVariableExpression(s_i)

                (0..<noOfCs).forEach[ i |
                    val Ci_CD_size = factory.createBitvector => [
                        name = "FaultyUMLmodel4::state0::C@"+i+"::CD::size"
                        width = 8
                    ]
                    instance.variables += Ci_CD_size
                    val Ci_CD_size_expr = newVariableExpression(
                        instance.variables.findFirst[ it.name == "FaultyUMLmodel4::state0::C@"+i+"::CD::size"]
                    )
                    (0..noOfDs).forEach[ j|
                        instance.assertions += factory.createImpliesExpression => [
                            lhs = factory.createCardEqExpression => [
                                k = j
                                expressions += newVariableExpression(
                                    instance.variables.findFirst[ it.name == "FaultyUMLmodel4::state0::C@"+i+"::CD" ]
                                )
                            ]
                            rhs = factory.createEqualsExpression => [
                                lhs = Ci_CD_size_expr
                                rhs = factory.createConstIntegerExpression => [
                                    value = j
                                    width = 8
                                ]
                            ]
                        ]
                    ]
                ];

                val D_alpha_expr = newVariableExpression(
                    instance.variables.findFirst[ it.name == "FaultyUMLmodel4::state0::D::alpha"]
                )

                val listOfImplies = (0..<noOfDs).map[ i |
                    factory.createImpliesExpression => [
                        lhs = factory.createExtractIndexExpression => [
                            start = i
                            end = i
                            expr = D_alpha_expr
                        ]
                        rhs = factory.createAndExpression => [
                            expressions +=
                                (0..<noOfCs).map[ j |
                                    factory.createImpliesExpression => [
                                        lhs = factory.createExtractIndexExpression => [
                                            start= j
                                            end = j
                                            expr = newVariableExpression(
                                                instance.variables.findFirst[ it.name == "FaultyUMLmodel4::state0::D@"+i+"::DC"]
                                            )
                                        ]
                                        rhs = factory.createEqualsExpression => [
                                            lhs = newVariableExpression(
                                                instance.variables.findFirst[ it.name == "FaultyUMLmodel4::state0::C@"+j+"::CD::size"]
                                            )

                                                // a little bit helping code
                                                val tmp = (0..<noOfCs).map[ k |
                                                    factory.createIteExpression => [
                                                        condition  = factory.createExtractIndexExpression => [
                                                                start = k
                                                                end = k
                                                                expr = newVariableExpression(
                                                                    instance.variables.findFirst[ it.name == "FaultyUMLmodel4::state0::D@"+i+"::DC"]
                                                                )
                                                            ]
                                                        thenexpr = newVariableExpression(
                                                                instance.variables.findFirst[ it.name == "FaultyUMLmodel4::state0::C@"+k+"::u"]
                                                            )
                                                        elseexpr = factory.createConstIntegerExpression => [
                                                                width = 8
                                                                value = 0
                                                            ]
                                                    ]
                                                ]

                                            rhs = addExpressions( tmp ) 
                                        ]
                                    ]
                                ]
                        ]
                    ]
                ]

                instance.assertions += factory.createOrExpression => [
                    expressions += s_i_expr
                    expressions += factory.createAndExpression => [
                        expressions += listOfImplies
                    ]
                ]
                println("")

                instance.assertions += factory.createCardGeExpression=> [
                    k = 1
                    expressions += newVariableExpression(
                        instance.variables.findFirst[ it.name == "FaultyUMLmodel4::state0::A::alpha" ]
                    )
                    expressions += newVariableExpression(
                        instance.variables.findFirst[ it.name == "FaultyUMLmodel4::state0::B::alpha" ]
                    )
                    expressions += newVariableExpression(
                        instance.variables.findFirst[ it.name == "FaultyUMLmodel4::state0::C::alpha" ]
                    )
                    expressions += newVariableExpression(
                        instance.variables.findFirst[ it.name == "FaultyUMLmodel4::state0::D::alpha" ]
                    )
                ]

                instance.assertions += factory.createCardGeExpression=> [
                    k = noOfAs
                    expressions += newVariableExpression(
                        instance.variables.findFirst[ it.name == "FaultyUMLmodel4::state0::A::alpha" ]
                    )
                ]
                instance.assertions += factory.createCardGeExpression=> [
                    k = noOfBs
                    expressions += newVariableExpression(
                        instance.variables.findFirst[ it.name == "FaultyUMLmodel4::state0::B::alpha" ]
                    )
                ]
                instance.assertions += factory.createCardGeExpression=> [
                    k = noOfCs
                    expressions += newVariableExpression(
                        instance.variables.findFirst[ it.name == "FaultyUMLmodel4::state0::C::alpha" ]
                    )
                ]
                instance.assertions += factory.createCardGeExpression=> [
                    k = noOfDs
                    expressions += newVariableExpression(
                        instance.variables.findFirst[ it.name == "FaultyUMLmodel4::state0::D::alpha" ]
                    )
                ]
            }
        }

        var sat = solver.solve
        val EList<Variable> selectVar = new BasicEList<Variable>()
        instance.variables.filter[it.name.startsWith("s") && (!it.name.contains("::"))]
                .forEach[selectVar.add(it)]
        val selectVarNo = selectVar.length
        var numberOfSolutions = 0;

        while (sat) {
            numberOfSolutions = numberOfSolutions +1
            val Map<Variable, Object> solution = solver.getSolution(selectVar)

//            println("######")
//            instance.variables.filter[it.name.contains("alpha") || it.name.startsWith("s")].forEach [ v |
//                switch(v){
//                Predicate: {
//                    println(v.name+" "+(solution.get(v) as Boolean))
//                }
//                Bitvector:{
//                    println(v.name+" "+Integer.toBinaryString(solution.get(v) as Integer))
//                }}
//            ]
//            println("######\n")

            solutionSet += (0..<selectVarNo).map[ i |
                    if (solution.get(instance.variables.findFirst[it.name == "s"+i]) as Boolean) {
                        "1"
                    } else {
                        "0"
                    }
                ].join("")
            if (modus == 1) {
                addBlockingSiClauses_fast(selectVarNo, instance, solution)
            } else {
                addBlockingSiClauses(selectVarNo, instance, solution)
            }
            sat = solver.solve
        }

        println("Found "+solutionSet.length+" solutions\n")

        var i = 0
        while (i < solutionSet.length) {
            var pos = 0
            do {
                val currentSolution = solutionSet.get(i)
                val lookFor = switch01(currentSolution, pos)
                if (lookFor != currentSolution) {
                    val care = lookFor.toCharArray.map[it.toString].filter[it.toString=="-"].length
                    val tmpFilter = solutionSet.filter[dontCareEqual(it, lookFor)]
                    if (tmpFilter.length == Math.pow(2,care)) {
                        val shortenedSolution = replaceCharAt(currentSolution, '-', pos)
                        solutionSet.set(i, shortenedSolution)
                        solutionSet.removeAll(extendDontCares(lookFor))
                    }
                }
                pos = pos + 1
            } while(pos < selectVarNo)
            i = i + 1
        } 

        println("Found the following shortened solutions table (with don't cares)")
        solutionSet.forEach[println(it)]

        val Set<Set<String>> R = new HashSet()
        val Set<String> S = new HashSet()

        (0..<selectVarNo).forEach[ j |
            if (solutionSet.forall[(it as String).charAt(j).toString == "1"]) {
                val Set<String> tmp = new HashSet
                tmp += "s"+j
                R += tmp
            } else if (solutionSet.forall[(it as String).charAt(j).toString == "-"]) {
                // The invariant connected with s_i is not responsible for any contradiction
            } else {
                S += "s"+j
            }
        ]

        print("Set of select variables which are responsible for at least one contradiction  S = [ ")
        S.forEach[print(it+" ")]
        print("]\n")

        var k = 2 // index variable for the k-element set
        do {
            val kElementSets = combinations(S.toList, k).map[it as List<String>]
            for ( tmp : kElementSets ) {
                val set = tmp.toSet
                if (R.containsAnySubsetOf(set)) {
                    // continue to ensure minimality
                } else if (pseudo_SAT_call(solutionSet, set)) {
                    R += set
                }
            }
            k = k + 1 
        } while (k <= S.length && true)

        println("The following list of select sets of variables are responsible for a contradiction")
        R.forEach[
            (it as Set<String>).forEach[print(it+" ")]
            println()
        ]

    }

    def void findContradictorilyInvariants(Map boundsMap) {
        findContradictorilyInvariants_generell(0, boundsMap)
    }


    def void findContradictorilyInvariants_fast(Map boundsMap) {
        findContradictorilyInvariants_generell(1, boundsMap)
    }


    def private extendDontCares(String s) {
        val dontCares = s.toCharArray.filter[it.toString=="-"].length
        if (dontCares == 0) {
            val List<String> result = new ArrayList
            result += s
            return result
        }
        var i = 0
        val List<String> buffer1 = new ArrayList
        buffer1 += s
        val List<String> buffer2 = new ArrayList
        while (i < s.length) {
            val copyI = i
            buffer1.forEach[
                if (it.charAt(copyI).toString == "-") {
                    buffer2 += replaceCharAt(it, '1', copyI)
                    buffer2 += replaceCharAt(it, '0', copyI)
                } else {
                    buffer2 += it
                }
            ]
            buffer1.clear
            buffer1.addAll(buffer2)
            buffer2.clear
            i = i + 1
        }
        buffer1
    }

    def private Boolean dontCareEqual (String s1, String s2) {
        if (s1.length == s2.length) {
            (0..<s1.length).forall[
                val c1 = s1.charAt(it).toString 
                val c2 = s2.charAt(it).toString 
                if (c1 == "-" || c2 == "-" || c1 == c2) {
                    true
                } else {
                    false
                }
            ]
        } else {
            throw new Exception("solutions must have the same lenght")
        }
    }

    def private containsAnySubsetOf(Set<Set<String>> R, Set<String> X) {
        for (_X: R) {
            val isSubset = _X.forall[ elem |
                X.contains(elem)
            ]
            if (isSubset) {
                return true
            }
        }
        return false
    }

    def private pseudo_SAT_call(ArrayList<String> solutions, Set<String> s) {
        for (sol : solutions) {
            val tmp = s.map[
                val index = Integer::parseInt(it.substring(1))
                if (   sol.charAt(index).toString == "0"
                    || sol.charAt(index).toString == "-"
                ) {
                    true
                } else {
                    false
                }
            ].fold(true, [a,b | a && b ])
            if (tmp) {
                return false
            }
        }
        return true
    }
/////////

    def addExpressions(Iterable<IteExpression> expressions) {
        var Expression result = factory.createConstIntegerExpression => [
                width = 8
                value = 0
            ]
        for ( expr : expressions) {
            result = addExpr(result, expr)
        }
        return result
    }

    def Expression addExpr (Expression a, Expression b) {
        return factory.createAddExpression => [
            lhs = a 
            rhs = b
        ]
    }

//////////////////////////////////////////////////
// A NEW WAY WITH A LOWER NUMBER OF ASSIGNMENTS //
//////////////////////////////////////////////////

    def void findContradictorilyInvariants_counting(Map boundsMap) {
        if (_ecoreFile == null) {
            throw new Exception('no ecore file specified')
        }
        if (_oclFile == null) {
            throw new Exception('no ocl file specified')
        }
        if (_solver == null) {
            throw new Exception('no solver set')
        }

        val modelLoader = new ModelLoader
        val input = modelLoader.loadFromEcoreAndOCL(ecoreFile, oclFile)

        val Bounds bounds = new StaticBounds(input.model, boundsMap)
        val calls = new NoOperationCallsDetermination
        val sequence = generateStateSequence
        (
            input.model,
            bounds,
            calls
        )

        val instance = debugContradictionAnalysis
        (
            sequence,
            input.constraints
        )

        val ArrayList<String> solutionSet = new ArrayList<String>();

        val EList<Variable> selectVariables = new BasicEList<Variable>()
        instance.variables
                .filter[it.name.startsWith("s") && (!it.name.contains("::"))]
                .forEach[selectVariables.add(it)]
        val selectVarNo = selectVariables.length
        var numberOfSolutions = 0;

        solver.addAssertions(instance.assertions)
        var sat = solver.solve

        // send all initial constraints to the solver and check if there is at least one solution
//        val SAT = solver.solve(instance)
//        if (SAT) println("there is at least one solution!")
//        else     println("there is NO solution!")

        for (currentMax : 0 ..< selectVarNo) {

            solver.push

            println
            (
                "###\n"+
                "trying to find solutions with only " + currentMax + " deactivated select variables\n" +
                "found " + numberOfSolutions + " till here\n"+
                "###"
            )

            instance.assertions += factory.createCardEqExpression => [
                k = currentMax
                expressions += selectVariables.map[newVariableExpression(it)]
            ]
            val limit_assertion_no = instance.assertions.length - 1
            solver.addAssertion(instance.assertions.get(limit_assertion_no))

            sat = solver.solve

            if (currentMax == 0 && sat)
            {
                System.err.println(
                    "###\n"+
                    "For \"currentMax == 0\" a valid system state has been found, i.e. the model\n" +
                    "is not inconsistent and you don't have to wonder about a strange behaviour!\n"+
                    "###")
                val solution = solver.getSolution(instance.variables)
                // save this specific system state:
//                new ModelAssignment(instance).assignSolution(sequence.states, solution)
//                sequence.states.forEach[state, id|
//                    state.save(new FileOutputStream('''/tmp/emergency-car-state«id».ecore'''), Collections::EMPTY_MAP)
//                ]
                instance.variables.forEach [
                    println("name: "+it.name+
                            " \t value: "+solution.get(it)
//                            + " = "+Integer.toBinaryString(solution.get(it) as Integer)
                            )
                ]
            }

            while (sat) {
                numberOfSolutions = numberOfSolutions +1
                val solution = solver.getSolution(selectVariables)

//                println("######")
    //            instance.variables.filter[
    ////                it.name.contains("alpha")
    ////                ||
    //                it.name.startsWith("s")
    //            ]
//                selectVariables
    //            instance.variables
//                .forEach [ v |
//                    switch(v){
//                    Predicate: {
//                        println(v.name+" "+(solution.get(v) as Boolean))
//                    }
//                    Bitvector:{
//                        println(v.name+" = "+(solution.get(v) as Integer)+" = "+Integer.toBinaryString(solution.get(v) as Integer))
//                    }}
//                ]
//                println("######\n")
    
                solutionSet += (0..<selectVarNo).map[ i |
                        if (solution.get(instance.variables.findFirst[it.name == "s"+i]) as Boolean) {
                            "1"
                        } else {
                            "0"
                        }
                    ].join("")
                solver.pop
//                generator.addBlockingSiClauses(selectVarNo, instance, solution)
                addBlockingSiClauses_easy(selectVarNo, instance, solution)
                solver.addAssertion(instance.assertions.get(instance.assertions.length - 1))
                solver.push
                solver.addAssertion(instance.assertions.get(limit_assertion_no))
//                println("blocking card ? " + instance.assertions.get( limit_assertion_no ) )

                sat = solver.solve
//                println("SAT = " + sat)
            }
            solver.pop
        }

        println('''Found «solutionSet.length» solutions with «solver.solveCalls» solver calls''')

        var i = 0
        while (i < solutionSet.length) {
            var pos = 0
            do {
                val currentSolution = solutionSet.get(i)
                val lookFor = switch01(currentSolution, pos)
                if (lookFor != currentSolution) {
                    val care = lookFor.toCharArray.map[it.toString].filter[it.toString=="-"].length
                    val tmpFilter = solutionSet.filter[dontCareEqual(it, lookFor)]
                    if (tmpFilter.length == Math.pow(2,care)) {
                        val shortenedSolution = replaceCharAt(currentSolution, '-', pos)
                        solutionSet.set(i, shortenedSolution)
                        solutionSet.removeAll(extendDontCares(lookFor))
                    }
                }
                pos = pos + 1
            } while(pos < selectVarNo)
            i = i + 1
        }

        println("Found the following shortened solutions table (with don't cares)")
        solutionSet.forEach[println(it)]

        val Set<Set<String>> R = new HashSet()
        val Set<String> S = new HashSet()

        (0..<selectVarNo).forEach[ j |
            if (solutionSet.forall[(it as String).charAt(j).toString == "1"])
            {
                val Set<String> tmp = new HashSet
                tmp += "s"+j
                R += tmp
            }
            else if (solutionSet.forall[(it as String).charAt(j).toString == "0"])
            {
                // The invariant connected with s_i is not responsible for any contradiction
            }
            else if (solutionSet.forall[(it as String).charAt(j).toString == "-"])
            {
                // The invariant connected with s_i is not responsible for any contradiction
            }
            else
            {
                S += "s"+j
            }
        ]

        print("Set of select variables which are responsible for at least one contradiction  S = [ ")
        S.forEach[print(it+" ")]
        print("]\n")

        var k = 2 // index variable for the k-element set
        do {
            val kElementSets = combinations(S.toList, k).map[it as List<String>]
            for ( tmp : kElementSets ) {
                val set = tmp.toSet
                if (R.containsAnySubsetOf(set)) {
                    // continue to ensure minimality
                } else if (pseudo_SAT_call(solutionSet, set)) {
                    R += set
                }
            }
            k = k + 1 
        } while (k <= S.length && true)

        println("The following list of select sets of variables are responsible for a contradiction")
        R.forEach[
            (it as Set<String>).sort.forEach[print(it+" ")]
            println()
        ]

    }

}