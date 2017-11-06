package de.agra.emf.modelfinder.statesequence

import de.agra.emf.modelfinder.statesequence.state.StateObject
import java.util.List
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.emf.ecore.resource.Resource

interface StateSequence {
    def EPackage getModel()
    def void setModel(EPackage _model)

    def List<Pair<StateObject,EStructuralFeature>> getModelElements()
    def void setModelElements(List<Pair<StateObject,EStructuralFeature>> _modelElements)

    def List<Resource> getStates()
    def void setStates(List<Resource> _states)

    def List<TransitionObject> getTransitions()
    def void setTransitions(List<TransitionObject> _objects)

    def OmegaToTransition getOmegaTransitionInformation()
    def void setOmegaTransitionInformation(OmegaToTransition omegaTransitionInformation)
}