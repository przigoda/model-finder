package de.agra.emf.modelfinder.encoding;

import java.util.List;
import java.util.Map;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.ocl.ecore.Constraint;

import de.agra.emf.metamodels.SMTlib2extended.Expression;
import de.agra.emf.metamodels.SMTlib2extended.Instance;
import de.agra.emf.metamodels.SMTlib2extended.Variable;
import de.agra.emf.modelfinder.statesequence.StateSequence;
import de.agra.emf.modelfinder.statesequence.state.StateResource;

public interface EncodingUtils
{
    void encodeAttributes
    (
        Instance instance,
        StateResource state
    );

    List<Expression> encodeInvariant
    (
        Instance instance,
        StateResource state,
        Constraint invariant
    );

    Expression encodePreCondition
    (
        Instance instance,
        StateResource state,
        Constraint precondition,
        Map<String, EObject> varmap
    );

    Expression encodePostCondition
    (
        Instance instance,
        StateResource state,
        Constraint postcondition,
        Map<String, EObject> varmap
    );

    Expression encodeSingleModifyPropertiesStatement
    (
        StateSequence statesequence,
        Instance instance,
        StateResource state,
        List<Variable> variablesOfPostState,
        Constraint modifiescondition,
        Map<String, EObject> varmap,
        Integer modifyCounter,
        Integer omegaValue,
        Integer omegaIndex
    );

    Expression encodeFinalizingModifyProperties
    (
        StateSequence sequence,
        Instance instance,
        List<Variable> variablesOfPostState,
        Variable gModifiesBV
    );

    Expression encodeSingleModifyObjectsStatement
    (
        StateSequence statesequence,
        Instance instance,
        StateResource state,
        List<EClass> possibleEClasses,
        Constraint modifiescondition,
        Map<String, EObject> varmap,
        Integer modifyOnlyCounter,
        Integer omegaValue,
        Integer omegaIndex
    );

    Expression encodeFinalizingModifyObjects
    (
        StateSequence statesequence,
        Instance instance,
        List<EClass> possibleRealEClasses,
        Integer preStateNo,
        Variable gModifiesOnlyBV
    );
}