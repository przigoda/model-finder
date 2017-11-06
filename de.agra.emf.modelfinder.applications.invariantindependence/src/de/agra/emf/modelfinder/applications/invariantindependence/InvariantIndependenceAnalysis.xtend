package de.agra.emf.modelfinder.applications.invariantindependence

import de.agra.emf.metamodels.SMTlib2extended.Expression
import de.agra.emf.metamodels.SMTlib2extended.solver.Solver
import de.agra.emf.modelfinder.encoding.InstanceGenerator
import de.agra.emf.modelfinder.modelloader.ModelLoader
import de.agra.emf.modelfinder.statesequence.bounds.Bounds
import de.agra.emf.modelfinder.statesequence.bounds.StaticBounds
import de.agra.emf.modelfinder.statesequence.determination.NoOperationCallsDetermination
import java.util.ArrayList
import java.util.HashSet
import java.util.List
import java.util.Map
import java.util.Set
import org.eclipse.emf.common.util.BasicEList
import org.eclipse.emf.common.util.EList
import org.eclipse.ocl.ecore.Constraint
import org.eclipse.xtend.lib.annotations.Accessors

import static de.agra.emf.metamodels.SMTlib2extended.util.MetaModelExtensions.*
import static de.agra.emf.modelfinder.encoding.InstanceGenerator.*
import static de.agra.emf.modelfinder.statesequence.StateSequenceGenerator.*

import static extension de.agra.emf.modelfinder.utils.MathUtilsExtensions.*

class InvariantIndependenceAnalysis {

    @Accessors String ecoreFile = null
    @Accessors String oclFile = null
    @Accessors Solver solver = null
    @Accessors boolean sanityChecks = true

    new(String _ecoreFile, String _oclFile) {
        this.ecoreFile = _ecoreFile
        this.oclFile = _oclFile
    }

    def void analyzeInvariants(Map boundsMap) {
        if (ecoreFile == null) {
            throw new Exception('no ecore file specified')
        }
        if (oclFile == null) {
            throw new Exception('no ocl file specified')
        }
        if (solver == null) {
            throw new Exception('no solver set')
        }

        // _solver = new ModelFinderSolver
        val modelLoader = new ModelLoader
        val input = modelLoader.loadFromEcoreAndOCL(ecoreFile, oclFile)
        val Bounds bounds = new StaticBounds(input.model, boundsMap)
        /* Instantiate a StateSequenceGenerator */
        val sequence = generateStateSequence
        (
            input.model,
            bounds,
            new NoOperationCallsDetermination
        ) 

        InstanceGenerator.setInvariantsAsList(false)
        val List<Constraint> inv = new ArrayList<Constraint>()
        input.constraints.filter[it.stereotype == "invariant"].forEach[inv.add(it)]
        val instance = encodeConsistency
        (
            sequence,
            inv
        )

//        var noOfInvariants = inv.length
        val EList<Expression> allAssertions = new BasicEList<Expression>()
        val EList<Expression> noInvariants = new BasicEList<Expression>()
        val EList<Expression> onlyInvariants = new BasicEList<Expression>()

        instance.assertions.clone.forEach[allAssertions.add(it)]
        instance.assertions.clear;

        (0 ..< (allAssertions.length)).forEach [
            if (allAssertions.get(it).name == "invariantHead") {
                onlyInvariants += allAssertions.get(it)
            } else {
                noInvariants += allAssertions.get(it)
            }
        ]

        solver.addAssertions(noInvariants)
        solver.push

        if (sanityChecks) {
            println("##### starting sanity checks")
            if (solver.solve) {
                println("SAT : basic-assertions are OK")
            } else {
                System.err.println(
                    "UNSAT : basic-assertions are unsatisfiable!\n" +
                        "Please ensure that the model is free of inconsistencies\n" +
                        "and that the given bounds are making sense!")
                return;
            }

            val toRemove = new ArrayList();
            onlyInvariants.forEach [ invariant, i |
                solver.push
                solver.addAssertion(invariant)
                val sat1 = solver.solve
                if (sat1) {
                    println('''SAT : σ(invariant«i»)''')
                } else {
                    println('''UNSAT : σ(invariant«i»)''')
                }
                solver.pop
                solver.push
                solver.addAssertion(
                    factory.createNotExpression => [
                        expr = invariant
                    ]
                )
                val sat2 = solver.solve
                if (sat2) {
                    println('''SAT : ¬ ( σ(invariant«i») )''')
                } else {
                    println('''UNSAT : ¬ ( σ(invariant«i») )''')
                }
                solver.pop
                if ((!sat1) || (!sat2)) {
                    System.err.println(
                        "####################\n" + "Detected problem! Invariant " + i +
                            " or/and its 'negation' are unsatisfiable!\n" +
                            "Please rethink the given bounds for the model!\n" +
                            "For this call the invariant will be removed from the list of invariants!\n" +
                            "####################\n")
                    toRemove.add(invariant)
                }
            ]
            onlyInvariants.removeAll(toRemove)
            println("##### sanity checks are done")
        } else
            println("\n\n")

        // initialize the configuration which should be checked
        val Set<Pair<Set<Integer>, Integer>> maybeDependent = new HashSet<Pair<Set<Integer>, Integer>>();

        val noOfInvariants = onlyInvariants.length;

        (0 ..< noOfInvariants).forEach [ i |
            println()
            solver.push
            solver.addAssertion(
                factory.createNotExpression => [
                    expr = onlyInvariants.get(i)
                ]
            )
            solver.push
            onlyInvariants.forEach [ invariant, j |
                if (i != j) {
                    solver.addAssertion(invariant)
                }
            ]
            val sat = solver.solve
            solver.pop
            if (sat) {
                println('''SAT : Ʌ_{ j ∈ I \ {«i»} } |[σ(j)]| ∧ ¬ |[ σ(i_«i») ]|''')
                println('''I.e. i_«i» is independent of I \ {«i»} and all of its subsets''')
            } else {
                println('''UNSAT : Ʌ_{ j ∈ I \ {«i»} } |[σ(j)]| ∧ ¬ |[ σ(i_«i») ]|''')
                println('''I.e. i_«i» is maybe dependent of I \ {«i»} or/and subsets of it''')
                val List<Integer> toBeInvestigatingInvariantNumbers = new ArrayList<Integer>();
                (0 ..< noOfInvariants).forEach [ j |
                    if(i != j) toBeInvestigatingInvariantNumbers.add(j)
                ]
                var loop = true;
                var subsetSize = toBeInvestigatingInvariantNumbers.length - 1
                do {
                    print('''entering loop for i_«i» and «toBeInvestigatingInvariantNumbers.toString»''')
                    println
                    val List<List<Integer>> testSubsets = toBeInvestigatingInvariantNumbers.combinations(subsetSize)
                    val List<List<Integer>> satSubsets = new ArrayList()
                    val List<List<Integer>> unsatSubsets = new ArrayList()
                    for (subset : testSubsets) {
                        solver.push
                        print("[ ")
                        subset.forEach [ j |
                            print(j + " ")
                            solver.addAssertion(onlyInvariants.get(j))
                        ]
                        print("]")
                        val subSetIsSat = solver.solve
                        if (subSetIsSat) {
                            satSubsets.add(subset)
                            println("--> SAT")
                        } else {
                            unsatSubsets.add(subset)
                            println("--> UNSAT")
                        }
                        solver.pop
                    }
                    if (satSubsets.empty) {

                        // More detailed checks are needed, decreasing the subsetSize 
                        subsetSize = subsetSize - 1
                        loop = true
                    } else {
                        if (satSubsets.length == testSubsets.length) {

                            // toBeInvestigatingInvariantNumbers is the minimal independent subset
                            if (subsetSize == toBeInvestigatingInvariantNumbers.length - 1) {
                                println('''adding : «Pair::of(toBeInvestigatingInvariantNumbers, i).toString»''')
                                maybeDependent.add(Pair::of(toBeInvestigatingInvariantNumbers.toSet, i))
                            } else {
                                val List<List<Integer>> reasonSubsets = toBeInvestigatingInvariantNumbers.
                                    combinations(subsetSize + 1)
                                reasonSubsets.forEach [ subset |
                                    println('''adding : «Pair::of(subset, i).toString»''')
                                    maybeDependent.add(Pair::of(subset.toSet, i))
                                ]
                            }
                            loop = false
                        } else {
                            val dontCare = satSubsets.fold(
                                satSubsets.head,
                                [a, b|a.intersection(b)]
                            )
                            print("dontCare = [ ")
                            println(dontCare.join(" "))
                            println("]")
                            if (dontCare.length == 0) {
                                if (!satSubsets.empty) {
                                    print("")
                                }
                                
                                for (subset: unsatSubsets) {
                                    println('''adding : «Pair::of(subset, i).toString»''')
                                    maybeDependent.add(Pair::of(subset.toSet, i))
                                }
                                loop = false
                            } else {
                                val Integer[] newCandidates = ((toBeInvestigatingInvariantNumbers.
                                    setDifference(dontCare)) as List<Integer>).clone
                                solver.push
                                
                                for (j: newCandidates) {
                                    solver.addAssertion(onlyInvariants.get(j))
                                }
                                
                                if (solver.solve) {
                                    System.err.println("SHOULD NOT HAPPEN.")
                                    System.err.println("Please contact the developer.")
                                    return
                                } else {

                                    //                                println('''adding : «Pair::of(newCandidates.toSet,i).toString»''')
                                    //                                maybeDependent.add(Pair::of(newCandidates.toSet,i))
                                    solver.pop
                                    toBeInvestigatingInvariantNumbers.clear
                                    toBeInvestigatingInvariantNumbers.addAll(newCandidates)
                                    subsetSize = toBeInvestigatingInvariantNumbers.length - 1
                                    loop = !(newCandidates.length == 1)
                                    if (!loop) {
                                        println('''adding : «Pair::of(newCandidates, i).toString»''')
                                        maybeDependent.add(Pair::of(newCandidates.toSet, i))
                                    }

                                //                                println('''satSubsets = «satSubsets.toString»''')
                                //                                println('''newCandidates = «newCandidates.toString»''')
                                }
                            }
                        }
                    }

                } while (loop && subsetSize > 0)
            }
            solver.pop
        ]

        maybeDependent.forEach [ p |
            val k = p.key
            val v = p.value
            println("AND of invariants " + k.toString + " IMPLIES inv " + v)
        ]
        if (maybeDependent.empty) {
            println("There are no dependencies between the invariants.")
        }
    }
}
