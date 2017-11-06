package de.agra.emf.modelfinder.encoding

import de.agra.emf.metamodels.SMTlib2extended.BitstringExpression
import de.agra.emf.metamodels.SMTlib2extended.VariableExpression
import de.agra.emf.metamodels.SMTlib2extended.impl.ExpressionImpl
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtend.lib.annotations.Accessors

class PlaceholderExpression extends ExpressionImpl {
    @Accessors EObject object
    @Accessors VariableExpression varExpression = null
    @Accessors BitstringExpression intExpression = null
    @Accessors String  attributeString = null
    @Accessors Integer attributeWidth = null

    new(EObject object) {
        this.object = object
    }

//    override toString ()
//    {
//        "EObject = " + object.toString + "\n" +
//        "VariableExpression = " + varExpression?.variable?.toString + "\n" +
//        "BitstringExpression = " + intExpression?.value + "\n" +
//        "String = " + attributeString?.toString + "\n" +
//        "Integer = " + attributeWidth?.toString + "\n"
//    }
}