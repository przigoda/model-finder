package de.agra.emf.modelfinder.encoding

import com.microsoft.z3.Context
import de.agra.emf.metamodels.SMTlib2extended.solver.Z3Solver

class ModelFinderSolver extends Z3Solver
{
    override void init()
    {
        setConverter( ctx )
        super.init()
    }

    def setConverter(Context ctx)
    {
        converter = new de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.Z3ConverterWithPlaceholder(ctx)
    }

    override void setConverter()
    {
        converter = new de.agra.emf.modelfinder.encoding.impl.twoValuedOCL.Z3ConverterWithPlaceholder(ctx)
    }
}