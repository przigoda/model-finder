  package de.agra.emf.modelfinder.statesequence

import java.util.ArrayList
import java.util.List
import java.util.Objects
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.EStructuralFeature
import de.agra.emf.modelfinder.statesequence.state.StateObject

class StateSequenceImpl implements StateSequence
{
    private var EPackage model
    private var ResourceSet resourceSet = new ResourceSetImpl
    private var List<Pair<StateObject,EStructuralFeature>> modelElements

    protected List<Resource> states = new ArrayList<Resource>();
    protected List<TransitionObject> transitions = new ArrayList<TransitionObject>;
    public OmegaToTransition omegaTransitionInformation = new OmegaToTransitionImpl

    override EPackage getModel()
    {
        if (model == null)
        {
            throw new Exception("model is NULL")
        }
        return model
    }

    override void setModel(EPackage _model)
    {
        this.model = _model
    }

    override List<Pair<StateObject,EStructuralFeature>> getModelElements()
    {
        return this.modelElements
    }

    override void setModelElements(List<Pair<StateObject,EStructuralFeature>> _modelElements)
    {
        this.modelElements = _modelElements
    }

    new(EPackage _model) {
        this.model = _model

        resourceSet.resourceFactoryRegistry.extensionToFactoryMap.put("ecore", new ResourceFactoryImpl)
        this.modelElements = new ArrayList<Pair<StateObject,EStructuralFeature>>()
    }

    override getStates() {
        if (states == null) {
            throw new Exception("state is NULL")
        }
        return states;
    }

    override setStates(List<Resource> _states) {
        this.states = _states
    }

    override getTransitions() {
        if (transitions == null) {
            throw new Exception("transitions is NULL")
        }
        return transitions;
    }

    override setTransitions(List<TransitionObject> _transitions) {
        this.transitions = _transitions
    }

    override getOmegaTransitionInformation() {
        if (omegaTransitionInformation == null) {
            throw new Exception("omegaTransitionInformation is NULL")
        }
        omegaTransitionInformation
    }

    override setOmegaTransitionInformation(OmegaToTransition _omegaTransitionInformation) {
        omegaTransitionInformation = _omegaTransitionInformation
    }
}