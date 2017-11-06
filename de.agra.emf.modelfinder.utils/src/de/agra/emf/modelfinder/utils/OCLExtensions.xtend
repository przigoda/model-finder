package de.agra.emf.modelfinder.utils

import org.eclipse.ocl.ecore.Constraint

class OCLExtensions {
    static def context(Constraint expression)
    {
        expression.specification.contextVariable.type
    } 

    static def bodyExpression(Constraint expression)
    {
        expression.specification.bodyExpression
    } 

    static def stereotypeExpression(Constraint expression)
    {
        expression.stereotype
    }
}