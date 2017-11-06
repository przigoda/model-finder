package de.agra.emf.modelfinder.statesequence

import java.util.ArrayList
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EOperation
import org.eclipse.xtext.xbase.lib.Pair
import org.eclipse.xtend.lib.annotations.Accessors

class TransitionObjectImpl implements TransitionObject {
//    protected ArrayList<Pair<EObject,EOperation>> objects;
    @Accessors String name
    public ArrayList<Pair<String,String>> objects = new ArrayList<Pair<String,String>> 

    override getObjects() {
                if (objects == null) {
            throw new Exception("objects is NULL")
        }
        return objects;
    }
}