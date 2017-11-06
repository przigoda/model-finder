package de.agra.emf.modelfinder.statesequence.utils;

import de.agra.emf.modelfinder.statesequence.state.StateObject
import de.agra.emf.modelfinder.statesequence.state.StateResource
import java.util.ArrayList
import java.util.HashSet
import java.util.List
import java.util.Set
import org.eclipse.emf.common.util.BasicEList
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EOperation
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.EStructuralFeature

/**
 * Some utility methods that turn out to be handy when implementing
 * the state generator and related classes.
 */
class EcoreExtensions {

    /**
     * Returns a classifier from a package given its name
     *
     * @param model Model
     * @param name  Name of the classifier
     * @return The classifier instance or null, if such a class does not exists
     */
    static def getClassifierByName
    (
        EPackage model,
        String name
    )
    {
        model.getEClassifiers.filter[ it.name.equals(name) ].head
    }

    static def variableName
    (
        StateObject object,
        EStructuralFeature attribute
    )
    {
        try {
            object.name+"::"+attribute.name
        } catch (Exception e) {
            println("wait")
            ""
        }
    }

    static def List<StateObject> allObjects (StateResource state)
    {
        state.contents.map[it as StateObject]
    }

    static def List<StateObject> allObjectsOfType
    (
        StateResource state,
        EClass eclass
    )
    {
        val List<StateObject> result = new ArrayList<StateObject>
        state.allObjects
             .forEach[
                 if (eclass.isSuperTypeOf( it.eClass ))
                 {
                     result += it as StateObject
                 }
        ]
        result
    }

    static def allStructuralFeatures(StateObject object)
    {
        object.eClass.getEAllStructuralFeatures
    }

    static def allAttributes(StateObject object)
    {
        object.eClass.getEAllAttributes
    }

    static def allOperations(StateObject object)
    {
        object.eClass.getEAllOperations
    }

    static def allReferences(StateObject object)
    {
        object.eClass.getEAllReferences
    }

    static def allAttributesFromAllObjects(StateResource state)
    {
        val EList<EStructuralFeature> result = new BasicEList<EStructuralFeature> ()
        state.contents.forEach[
            result += it.eClass.getEAllStructuralFeatures
        ]
        result
    }

    static def allAttributesOfTypeFromAllObjects
    (
        StateResource state,
        String typename
    )
    {
        state.allAttributesFromAllObjects
             .filter[it.getEType.name == typename]
    }

    static def allOperations(StateResource state)
    {
//        val Set<Pair<StateObject,EOperation>> result
//            = new HashSet<Pair<StateObject,EOperation>>();
        val Set<Pair<EClass,EOperation>> result
            = new HashSet<Pair<EClass,EOperation>>();
        state.contents.forEach[ _obj |
            val obj = _obj as StateObject
            obj.eClass.getEAllOperations.forEach[ op |
                result += Pair::of(obj.eClass, op)
            ]
        ]
        result
    }

    /**
     * Is true, if and only if the given EStructuralFeature is a collection
     * that qualifies as a Set.
     *
     * That is the case, when its lowerBound or upperBound are != 1 and its
     * elements are unique but not ordered.
     */
    static def boolean isSet(EStructuralFeature struc) {
        return (
            !(struc.lowerBound == 1 && struc.upperBound == 1)
            && struc.unique
            && !struc.ordered
        )
    }

    /**
     * Is true, if and only if the given EStructuralFeature is a collection
     * that qualifies as a Bag.
     *
     * That is the case, when its lowerBound or upperBound are != 1 and its
     * elements are neither unique nor ordered.
     */
    static def boolean isBag(EStructuralFeature struc) {
        return (
            !(struc.lowerBound == 1 && struc.upperBound == 1)
            && !struc.unique
            && !struc.ordered
        )
    }
}