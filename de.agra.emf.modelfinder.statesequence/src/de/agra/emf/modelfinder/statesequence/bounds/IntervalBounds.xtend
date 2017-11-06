package de.agra.emf.modelfinder.statesequence.bounds

import java.util.Map
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EPackage
import org.eclipse.xtext.xbase.lib.Pair
import de.agra.emf.modelfinder.statesequence.bounds.AbstractStaticBounds

class IntervalBounds extends AbstractStaticBounds<Pair<Integer, Integer>>
{
    /**
     * Default constructor
     *
     * @param model Model
     * @param bounds A map of strings to pairs of integers, in which
     *               the string is the class name and the pair
     *               contains lower and upper bound in key and value,
     *               respectively.
     */
    new
    (
        EPackage model,
        Map<String, Pair<Integer, Integer>> bounds
    )
    {
        super(model, bounds)
    }

    override getLowerBound(EClass cls)
    {
        bounds.get(cls).key
    }

    override getUpperBound(EClass cls)
    {
        bounds.get(cls).value
    }
}