package de.agra.emf.modelfinder.encoding

import de.agra.emf.metamodels.SMTlib2extended.VariableExpression
import org.eclipse.xtend.lib.annotations.Accessors

class VariableExpressionStateIncreaser extends ExpressionSwitch<Void>{
    @Accessors int increaseIndex

    private def createNewName
    (
        String seperator,
        String oldVarName,
        String name,
        int index
    )
    {
        val stateSep = oldVarName.split(seperator)
        val stateIndex = Integer::parseInt(stateSep.get(index).substring(5))
        stateSep.set(index, name + (stateIndex + increaseIndex))
        stateSep.join(seperator)
    }

    override caseVariableExpression(VariableExpression object)
    {
        val oldVarName = object.variable.name
        object.variable.name = if (oldVarName.startsWith("omega"))
                                   createNewName("@",oldVarName,"omega",0)
                               else
                                   createNewName("::",oldVarName,"state",1)
        super.caseVariableExpression(object)
    }

    override casePlaceholderExpression(PlaceholderExpression object)
    {
        object.varExpression?.doSwitch
    }
}