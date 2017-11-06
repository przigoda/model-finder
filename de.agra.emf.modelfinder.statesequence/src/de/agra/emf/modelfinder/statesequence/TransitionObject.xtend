package de.agra.emf.modelfinder.statesequence

import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EOperation

interface TransitionObject {
    def String getName()
//    def List<Pair<EObject,EOperation>> getObjects()
    def List<Pair<String,String>> getObjects()
    
}