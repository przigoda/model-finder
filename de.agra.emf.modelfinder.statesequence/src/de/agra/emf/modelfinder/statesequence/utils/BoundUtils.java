package de.agra.emf.modelfinder.statesequence.utils;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EPackage;

import de.agra.emf.modelfinder.statesequence.bounds.Bounds;

public interface BoundUtils {
    int getUpperBound(EPackage model, Bounds bounds, EClass cls);
    int getLowerBound(EPackage model, Bounds bounds, EClass cls);
}
