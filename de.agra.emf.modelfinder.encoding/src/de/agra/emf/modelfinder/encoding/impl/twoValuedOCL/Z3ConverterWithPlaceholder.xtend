package de.agra.emf.modelfinder.encoding.impl.twoValuedOCL

import com.microsoft.z3.Context
import de.agra.emf.metamodels.SMTlib2extended.Expression
import de.agra.emf.metamodels.SMTlib2extended.conversion.Z3Converter

import static de.agra.emf.metamodels.SMTlib2extended.util.MetaModelExtensions.*
import de.agra.emf.modelfinder.encoding.PlaceholderExpression

class Z3ConverterWithPlaceholder extends Z3Converter {
    new(Context context) {
        super(context)
    }

    override convert(Expression exp) {
        super.convert(switch (exp) {
            PlaceholderExpression:{
                if (exp.varExpression != null) {
                    exp.varExpression
                } else if (exp.intExpression != null) {
                    exp.intExpression
                } else {
                    factory.createVariableExpression => [
                        variable = factory.createBitvector => [
                            name = exp.attributeString
                            width = exp.attributeWidth
                        ]
                    ]
                }
            }
            default:
                exp
        })
    }
}