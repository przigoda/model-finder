package de.agra.emf.modelfinder.statesequence

import java.util.Map
import org.eclipse.xtext.xbase.lib.Pair

interface OmegaToTransition {
    def Map<Integer,Pair<String,String>> getAllInformations()
    def Pair<String,String> getCallee (Integer omegaValue)
    def void addOmegaValueInformation (Pair<Integer,Pair<String,String>> omegaValueInformation)
}