package de.agra.emf.modelfinder.modelloader

import java.util.List
import org.eclipse.emf.ecore.EPackage
import org.eclipse.ocl.ecore.Constraint
import org.eclipse.xtend.lib.annotations.Data

@Data class ModelWithConstraints {
    EPackage model
    List<Constraint> constraints
}