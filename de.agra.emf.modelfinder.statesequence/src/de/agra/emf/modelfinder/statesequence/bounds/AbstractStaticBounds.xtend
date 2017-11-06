package de.agra.emf.modelfinder.statesequence.bounds

import de.agra.emf.modelfinder.statesequence.bounds.Bounds
import org.eclipse.emf.ecore.EClass
import java.util.HashMap
import java.util.Map
import org.eclipse.emf.ecore.EPackage
import static extension de.agra.emf.modelfinder.statesequence.utils.EcoreExtensions.*
import org.eclipse.xtend.lib.annotations.Accessors

abstract class AbstractStaticBounds<T> implements Bounds
{
    @Accessors val Map<EClass, T> bounds = new HashMap

    /**
     * Default constructor
     *
     * @param model Model
     * @param bounds A map of strings to T and T represents
     *               how bounds are stored.
     */
    new
    (
        EPackage model,
        Map<String, T> bounds
    )
    {
        initialize(model, bounds)
    }

    /**
     * Initialization of the map that is used in the implementation.
     * It carries the real classes derived from the string, if they
     * exist.
     *
     * @param model Model
     * @param bounds Bounds map from user
     */
    def private initialize
    (
        EPackage model,
        Map<String, T> bounds
    )
    {
        for (entry : bounds.entrySet) {
            val cls = model.getClassifierByName(entry.key)
            if (cls === null)
            {
                System.err.println("Trying to build instances for a class named \""+entry.key
                    + "\", but the passed model does not have a class with this name. Thus, it "
                    + "will be ignored!"
                )
            }
            if (cls !== null && cls instanceof EClass) {
                this.bounds.put(cls as EClass, entry.value)
            }
        }
    }

    override hasLowerBound(EClass cls)
    {
        bounds.containsKey(cls)
    }

    override hasUpperBound(EClass cls)
    {
        bounds.containsKey(cls)
    }
}