package de.agra.emf.modelfinder.statesequence.state

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.xmi.impl.XMIResourceImpl
import org.eclipse.xtend.lib.annotations.Accessors

class StateResource extends XMIResourceImpl {
    @Accessors Resource preState
}
