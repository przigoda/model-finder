package de.agra.emf.modelfinder.statesequence

import de.agra.emf.modelfinder.statesequence.state.StateResource
import org.eclipse.emf.common.util.URI

class ResourceFactoryImpl extends org.eclipse.emf.ecore.resource.impl.ResourceFactoryImpl {
    new() {
        super()
    }

    override createResource(URI uri) {
        new StateResource
    }
}