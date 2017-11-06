package de.agra.emf.modelfinder.statesequence.state

import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.impl.DynamicEObjectImpl
import org.eclipse.xtend.lib.annotations.Accessors

/**
 * A class that represents an instantiated object in
 * the state. This is basically an EObject but with
 * additional information that are useful for the later
 * encoding.
 */
class StateObject extends DynamicEObjectImpl {
    @Accessors String name

    /**
     * Default constructor
     *
     * @param cls Class from which the object is instantiated
     */
    new(EClass cls) {
        super(cls)
    }

    override toString() {
        name
    }
}