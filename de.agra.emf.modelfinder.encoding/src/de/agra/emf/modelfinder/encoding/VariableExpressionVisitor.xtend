package de.agra.emf.modelfinder.encoding

import de.agra.emf.metamodels.SMTlib2extended.VariableExpression
import de.agra.emf.modelfinder.encoding.ExpressionSwitch
import java.util.LinkedHashSet
import java.util.Set
import org.eclipse.xtend.lib.annotations.Accessors

class VariableExpressionVisitor extends ExpressionSwitch<Void>
{
    @Accessors Set<String> visitedVariables = new LinkedHashSet<String>

    override caseVariableExpression(VariableExpression object)
    {
        visitedVariables += object.variable.name
        super.caseVariableExpression(object)
    }

    override casePlaceholderExpression(PlaceholderExpression object)
    {
        if (object.varExpression !== null )
        {
            doSwitch(object.varExpression)
        }
        else
        {
            System.err.println
            (
                  "The VariableExpressionVisitor should be only used on expressions in which "
                + "PlaceholderExpression have already replaced or contains a varExpression."
            );
            null; // TODO wtf does Xtend do above such that this null line is needed...
        }
    }
}