package de.agra.emf.modelfinder.statesequence

import java.util.HashMap
import java.util.Map
import org.eclipse.xtext.xbase.lib.Pair

class OmegaToTransitionImpl implements OmegaToTransition {
    protected Map<Integer,Pair<String,String>> omegaValueInformations = new HashMap<Integer,Pair<String,String>>

    override getAllInformations() {
        omegaValueInformations 
    }

    override Pair<String,String> getCallee(Integer omegaValue) {
        if (omegaValueInformations.containsKey(omegaValue)) {
            return omegaValueInformations.get(omegaValue)
        }
        throw new Exception("There is more than information for omega="+omegaValue+" in the omegaValueInformation table!")
    }

    override addOmegaValueInformation(Pair<Integer, Pair<String, String>> omegaValueInformation) {
        omegaValueInformations.put(omegaValueInformation.key, omegaValueInformation.value)
    }
}