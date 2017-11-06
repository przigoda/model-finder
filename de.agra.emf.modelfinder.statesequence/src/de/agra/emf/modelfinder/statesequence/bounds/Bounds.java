package de.agra.emf.modelfinder.statesequence.bounds;

import org.eclipse.emf.ecore.EClass;

public interface Bounds {
    /**
     * Lower bound for a class
     *
     * @param cls Class
     * @return lower bound
     */
    public int getLowerBound(EClass cls);

    /**
     * Upper bound for a class
     *
     * @param cls Class
     * @return upper bound
     */
    public int getUpperBound(EClass cls);

    public boolean hasLowerBound(EClass cls);
    public boolean hasUpperBound(EClass cls);
}
