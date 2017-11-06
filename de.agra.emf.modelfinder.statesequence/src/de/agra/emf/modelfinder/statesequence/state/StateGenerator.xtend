package de.agra.emf.modelfinder.statesequence.state

import java.util.ArrayList
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.resource.impl.ResourceFactoryImpl
import org.eclipse.xtend.lib.annotations.Accessors

/**
 * This class handles the creation of system states
 * for a given package and different configuration
 * objects.
 */
class StateGenerator {
    @Accessors EPackage model

    private ResourceSet resourceSet = new ResourceSetImpl

    /**
     * Creates a new state generator
     *
     * @param model The model for which states should be generated
     */
    new(EPackage model) {
        this.model = model

        resourceSet.resourceFactoryRegistry.extensionToFactoryMap.put("ecore", new ResourceFactoryImpl)
    }
}
