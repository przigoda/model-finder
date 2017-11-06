package de.agra.emf.modelfinder.statesequence.bounds

import java.util.Map
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EPackage
import de.agra.emf.modelfinder.statesequence.bounds.AbstractStaticBounds

/**
 * Static bounds have always the same lower and upper
 * bound for classes which are given explicitly when
 * initializing an object.
 */
class StaticBounds extends AbstractStaticBounds<Integer>
{
    /**
     * Default constructor
     *
     * @param model Model
     * @param bounds A map of strings to integers, in which
     *               the string is the class name and the integer
     *               is both the lower and upper bound.
     */
    new
    (
        EPackage model,
        Map<String, Integer> bounds
    )
    {
        super(model, bounds)
    }

    override getLowerBound(EClass cls)
    {
        bounds.get(cls)
    }

    override getUpperBound(EClass cls)
    {
        bounds.get(cls)
    }
}