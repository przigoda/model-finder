package de.agra.emf.metamodels.SMTlib2extended.conversion

import com.microsoft.z3.Context
import de.agra.emf.metamodels.SMTlib2extended.Bitvector
import de.agra.emf.metamodels.SMTlib2extended.Predicate
import de.agra.emf.metamodels.SMTlib2extended.Variable

class Z3ConverterUtils {
    def static convertVariable
    (
        Context context,
        Variable v
    )
    {
        if (context == null)
        {
            throw new NullPointerException("Z3ConverterUtils::convertVariable\n"
                + "needs a valid Context reference, not a null reference.")
        }
        if (v == null)
        {
            throw new NullPointerException("Z3ConverterUtils::convertVariable\n"
                + "needs a valid Variable reference, not a null reference.")
        }
        if (v.name == null)
        {
            throw new NullPointerException("Z3ConverterUtils::convertVariable\n"
                + "needs a valid Variable reference, but the name is a null reference!")
        }
        if (v.name.empty)
        {
            throw new NullPointerException("Z3ConverterUtils::convertVariable\n"
                + "needs a valid Variable reference, but the variable name is empty!")
        }
        context.mkConst
        (
            v.name,
            switch (v) {
                Predicate: context.mkBoolSort
                Bitvector: {
                    if (v.width <= 0)
                    {
                        throw new NullPointerException("Z3ConverterUtils::convertVariable\n"
                            + "needs a valid Variable reference, but passed Bitvector has a width <= 0!")
                    }
                    context.mkBitVecSort(v.width)
                }
            }
        )
    }
}