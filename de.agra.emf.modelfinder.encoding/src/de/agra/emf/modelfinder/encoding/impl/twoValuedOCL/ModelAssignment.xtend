package de.agra.emf.modelfinder.encoding.impl.twoValuedOCL

import de.agra.emf.metamodels.SMTlib2extended.Bitvector
import de.agra.emf.metamodels.SMTlib2extended.Instance
import de.agra.emf.metamodels.SMTlib2extended.Predicate
import de.agra.emf.metamodels.SMTlib2extended.Variable
import de.agra.emf.modelfinder.statesequence.state.StateObject
import java.util.ArrayList
import java.util.HashMap
import java.util.List
import java.util.Map
import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EOperation
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtend.lib.annotations.Accessors
import de.agra.emf.modelfinder.encoding.LoadParametersExtensions
import de.agra.emf.modelfinder.utils.MathUtilsExtensions
import javax.naming.OperationNotSupportedException
import de.agra.emf.modelfinder.statesequence.utils.EcoreExtensions
import de.agra.emf.modelfinder.utils.StringUtilsExtensions

class ModelAssignment
{
    @Accessors Instance instance
    @Accessors boolean show = true;

    new(Instance instance)
    {
       this.instance = instance
    }

    def void assignSolution(List<Resource> states, Map<Variable, Object> solution) {
       states.forEach[it.assignSolution(solution)]
    }

    def void assignSolution(Resource state, Map<Variable, Object> solution) {
        for (obj : state.contents.map[it as StateObject]) {
            for (property : obj.eClass.EAllStructuralFeatures) {
                val variable = getVariable(obj, property)

                if (!solution.containsKey(variable)) {
                    throw new Exception('''«variable» does not exist in solution''')
                }

                switch(property) {
                    EAttribute: {
                        //single attribute
                        if(property.lowerBound == 1 && property.upperBound == 1) {
                            val value = switch(variable) {
                                Predicate: solution.get(variable) as Boolean
                                Bitvector: solution.get(variable) as Integer
                            }
                            obj.eSet(property, value)
                            if (show) println('''«obj.name».«property.name» <- «value»''')
                        }
                        //collection
                        else {
                            if(property.lowerBound == 0 && property.upperBound == 1) {
                                System.err.println('''WARNING: The variable «variable» with lowerBound=0 and "
                                    +"upperBound=1 was translated as a Collection of size 1 for internal implementation reasons!''')
                            }
                            val value = solution.get(variable) as Integer
                            var String collectionBitVector = MathUtilsExtensions.numberToBinaryString(value as Number)
                            var int bvWidth = collectionBitVector.length
                            switch(property.EType.name) {
                                case "EInt": {
                                    val List<Integer> value_ = new ArrayList<Integer>();
                                    if(EcoreExtensions.isSet(property)) {
                                        for(var elem = 0; elem < bvWidth; elem++) {
                                            val char c = collectionBitVector.charAt(bvWidth-1-elem)
                                            if(c == new Character('1')) {
                                                value_.add(elem)
                                            }
                                        }
                                    } else if(EcoreExtensions.isBag(property)) {
                                        val int elemWidth = LoadParametersExtensions.bagElementBitwidth
                                        val int numberBagBuckets = bvWidth / elemWidth
                                        for(var elem = 0; elem < numberBagBuckets; elem++) {
                                            val realIndex = (numberBagBuckets-1-elem)*elemWidth
                                            val String elemBitVector = collectionBitVector.substring(realIndex, realIndex+elemWidth)
                                            val int elemCount = Integer.parseInt(elemBitVector,2)
                                            for(var i = 0; i < elemCount; i++) {
                                                value_.add(elem)
                                            }
                                        }
                                    } else {
                                        throw new OperationNotSupportedException(
                                            "Other Collection-types than Set and Bag are currently not supported. "
                                            +"Current case: unique="+property.unique+", ordered="+property.ordered
                                            +"Feel free to implement it!"
                                        )
                                    }
                                    obj.eSet(property, value_)
                                    if (show) println('''«obj.name».«property.name» <- «value_»''')
                                }
                                case "EBoolean": {
                                    val int TRUE_INDEX = 1
                                    val int FALSE_INDEX = 0
                                    val List<Boolean> value_ = new ArrayList<Boolean>();
                                    if(EcoreExtensions.isSet(property)) {
                                        collectionBitVector = StringUtilsExtensions.fillString(collectionBitVector, 2, '0')
                                        if(collectionBitVector.charAt(TRUE_INDEX) == new Character('1')
                                        ) {
                                            value_.add(true);
                                        }
                                        if(collectionBitVector.charAt(FALSE_INDEX) == new Character('1')) {
                                            value_.add(false);
                                        }
                                    } else if(EcoreExtensions.isBag(property)) {
                                        var int realIndex
                                        var String elemBitVector
                                        var int elemCount
                                        val int elemWidth = LoadParametersExtensions.bagElementBitwidth
                                        val int numberBagBuckets = 2
                                        collectionBitVector = StringUtilsExtensions.fillString(collectionBitVector, numberBagBuckets*elemWidth, '0')
                                        //Count TRUEs
                                        realIndex = 1-TRUE_INDEX
                                        elemBitVector = collectionBitVector.substring(realIndex, realIndex+elemWidth)
                                        elemCount = Integer.parseInt(elemBitVector,2)
                                        for(var i = 0; i < elemCount; i++) {
                                            value_.add(true)
                                        }
                                        //Count FALSEs
                                        realIndex = 1-FALSE_INDEX
                                        elemBitVector = collectionBitVector.substring(realIndex, realIndex+elemWidth)
                                        elemCount = Integer.parseInt(elemBitVector,2)
                                        for(var i = 0; i < elemCount; i++) {
                                            value_.add(false)
                                        }
                                    } else {
                                        throw new OperationNotSupportedException(
                                            "Other Collection-types than Set and Bag are currently not supported. "
                                            +"Current case: unique="+property.unique+", ordered="+property.ordered
                                            +"Feel free to implement it!"
                                        )
                                    }
                                    obj.eSet(property, value_)
                                    if (show) println('''«obj.name».«property.name» <- «value_»''')
                                }
                                default: {
                                    throw new OperationNotSupportedException(
                                        "Collections of type "+property.EType.name+" are currently not supported. "
                                        +"Feel free to implement it!"
                                    )
                                }
                            }
                        }
                    }
                    EReference: {
                        val value = solution.get(variable) as Integer
                        val objList = new ArrayList<EObject>();

                        (0..<(variable as Bitvector).width).forEach[index |
                            if (value.bitwiseAnd(1 << index) != 0) {
                                val reference = state.contents.filter[it.eClass == property.EType].get(index)
                                objList += reference
                                if (show) println('''«obj.name».«property.name» <- «(reference as StateObject).name»''')
                            }
                        ]

                        obj.eDynamicSet(property, if (property.many) objList else objList.head)
                    }
                }
            }
        }
    }

    def printOmegas(Map<Variable, Object> solution, EPackage model, List<Resource> states) {

    	var HashMap<Integer,String> opNames = new HashMap
    	var idOfOp = 0  	
    	
	    val omegaVars = instance.variables.filter[it.name.startsWith("omega")]
    	
    	if (!solution.containsKey(omegaVars.head))
    	   	println("No omega variables in solution!")
    	else {
    		
    		for (clazz : model.EClassifiers) {
				for (op : clazz.eContents.filter[it instanceof EOperation].map[it as EOperation]) {

					val numberOfObjects = states.get(0).contents.filter[it.eClass.name == clazz.name].size

					for (obj : 0 ..< (numberOfObjects)) {
						opNames.put(idOfOp, clazz.name + "@" + obj + "." + op.name + "()")
						idOfOp = idOfOp + 1
					}
				}
			} 
    		
    		println("\nThese are the decrypted omega variables:")
    		
    		val paramVars = instance.variables.filter[it.name.contains("_param_")]
    		
    		for (omegaVar : omegaVars) 
    			println('''operation call «String.format("%-7s", omegaVar.name)»: «opNames.get(solution.get(omegaVar))»''')
    			
    		for (paramVar : paramVars)
    			if (show) println('''«paramVar.name» <- «(solution.get(paramVar) as Integer)»''')	    			
    	}
    }

    def getVariable(StateObject object, EStructuralFeature attribute) {
        val name = object.name + "::" + attribute.name
        instance.variables.filter[it.name.equals(name)].head
    }
}