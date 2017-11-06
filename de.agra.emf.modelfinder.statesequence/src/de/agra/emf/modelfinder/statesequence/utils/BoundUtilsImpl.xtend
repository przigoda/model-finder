package de.agra.emf.modelfinder.statesequence.utils;

import de.agra.emf.modelfinder.statesequence.bounds.Bounds
import java.util.ArrayList
import java.util.List
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EPackage

class BoundUtilsImpl implements BoundUtils {

    private def reflexiveClosure(EClass cls)
    {
        val List<EClass> result = new ArrayList<EClass>
        result += cls
        result += cls.getEAllSuperTypes
        result
    }

    override getLowerBound
    (
        EPackage model,
        Bounds bounds,
        EClass cls
    )
    {
        val allBounds = cls.reflexiveClosure
           .filter[bounds.hasLowerBound(it)]
        if (allBounds.empty)
        {
            return 0
        }
        else
        {
            val start = bounds.getUpperBound(allBounds.head)
            return allBounds.fold(start, [a, c | Math.max(a,bounds.getLowerBound(c))] )
        }
    }

    override getUpperBound
    (
        EPackage model,
        Bounds bounds,
        EClass cls
    )
    {
        val allBounds = cls.reflexiveClosure
           .filter[bounds.hasUpperBound(it)]
        if (allBounds.empty)
        {
            return 0
        }
        else
        {
            val start = bounds.getUpperBound(allBounds.head)
            return allBounds.fold(start, [a, c | Math.min(a,bounds.getUpperBound(c))] )
        }
    }
}