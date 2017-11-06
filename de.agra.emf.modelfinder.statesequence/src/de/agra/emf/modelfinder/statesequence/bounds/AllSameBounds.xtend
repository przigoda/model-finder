package de.agra.emf.modelfinder.statesequence.bounds

import de.agra.emf.modelfinder.statesequence.bounds.Bounds
import org.eclipse.emf.ecore.EClass
import org.eclipse.xtend.lib.annotations.Accessors

class AllSameBounds implements Bounds
{
    @Accessors int bound

    new ()
    {
        bound = 1
    }

    new (int bound)
    {
        this.bound = bound
    }

    override getLowerBound(EClass cls)
    {
                bound
    }

    override getUpperBound(EClass cls)
    {
        bound
    }

    override hasLowerBound(EClass cls)
    {
        true
    }

    override hasUpperBound(EClass cls)
    {
        true
    }
}