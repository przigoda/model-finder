package de.agra.emf.modelfinder.encoding

import de.agra.emf.metamodels.SMTlib2extended.Instance
import de.agra.emf.metamodels.SMTlib2extended.Variable
import de.agra.emf.modelfinder.statesequence.StateSequence
import java.util.List
import java.util.Map
import org.eclipse.ocl.ecore.Constraint

interface InstanceGenerator
{
    def void setInvariantsAsList(Boolean object)
    def boolean getInvariantsAsList()

    def void addBlockingSiClauses
    (
        int invNo,
        Instance instance,
        Map<Variable, Object> solution
    )

    def void addBlockingSiClauses_fast
    (
        int invNo, 
        Instance instance,
        Map<Variable, Object> solution
    )

    def void addBlockingSiClauses_easy
    (
        int invNo,
        Instance instance,
        Map<Variable, Object> solution
    )

    def Instance debugContradictionAnalysis
    (
        StateSequence sequence,
        List<Constraint> prePostInv
    )


//    def Instance debugConsistency
//    (
//        StateSequence sequence,
//        List<Constraint> prePostInv,
//        int k
//    )

//
//    static def encodeConsistency
//    (
//        StateSequence statesequence,
//        List<Constraint> prePostInv
//    )
//    {
//        if (statesequence.states.length != 1)
//        {
//            throw new Exception("encodeConsistency is called with a sequence"
//                + "which does not contain exactly one system state.")
//        }
//        val instance = factory.createInstance;
//        encodeBasisForState
//        (
//            statesequence.states.head,
//            statesequence.model,
//            0,
//            prePostInv,
//            instance
//        )
//        instance
//    }
//
//    static def private createAndAddOmega
//    (
//        String omegaName,
//        int omegaWidth,
//        int numOpCalls,
//        Instance instance,
//        boolean parallel
//    )
//    {
//        val omega = factory.createBitvector => [
//            name = omegaName
//            width = omegaWidth
//        ]
//        instance.variables += omega
//        if (!parallel)
//        {
//            instance.assertions += newLessEqualsExpression
//            (
//                variableExpression(omega),
//                constIntegerExpression(numOpCalls - 1, omegaWidth)
//            )
//        }
//        omega
//    }
//
//    static def private void encodeBasisForState
//    (
//        Resource state,
//        EPackage model,
//        int index,
//        List<Constraint> prePostInv,
//        Instance instance
//    )
//    {
//        /* Add one Bitvector as ALPHA variables for each class, each bit represents the
//         *(none-)existence of an object of the corresponding class
//         */
//        val allEClasses = model.getEClassifiers.filter[it instanceof EClass].map[it as EClass]
//        val instantiableEClasses = allEClasses.filter[it.abstract == false]
//        if (useAlpha)
//        {
//            if (oneObjectPerClass)
//            {
//                for (c : instantiableEClasses) {
//                    val alphaVar = factory.createBitvector => [
//                        name =  model.name + "::" + "state"+index+"::" + c.name + "::alpha"
//                        width = state.contents.filter[it.eClass.name == c.name].length
//                    ]
//                    instance.variables += alphaVar
//                    instance.assertions += factory.createCardGeExpression=> [
//                        k = 1
//                        expressions += newVariableExpression(alphaVar)
//                    ]
//                    instance.assertions.last.name = "at-least-one-object-per-class"
//                }
//            }
//            else
//            {
//                val bigCard = factory.createCardGeExpression=> [
//                    k = 1
//                ]
//                for (c : instantiableEClasses) {
//                    val alphaVar = factory.createBitvector => [
//                        name =  model.name + "::" + "state"+index+"::" + c.name + "::alpha"
//                        width = state.contents.filter[it.eClass.name == c.name].length
//                    ]
//                    instance.variables += alphaVar
//                    bigCard.expressions += newVariableExpression(alphaVar)
//                }
//                bigCard.name = "at-least-one-object-of-any-class"
//                instance.assertions += bigCard
//            }
//        }
//        // Attributes
//        utils.encodeAttributes(instance, state as StateResource)
//        // Invariants
//        prePostInv.filter[it.stereotype == "invariant"]
//                  .forEach[ inv |
//                      if (invariantsAsList)
//                      {
//                          instance.assertions += utils.encodeInvariant(instance, state as StateResource, inv)
//                      }
//                      else
//                      {
//                          instance.assertions += factory.createAndExpression => [
//                              expressions += utils.encodeInvariant(instance, state as StateResource, inv)
//                              name = "invariantHead"
//                          ]
//                      }
//                  ]
//    }
//
//    static def private void encodeBasisForStates
//    (
//        StateSequence sequence,
//        List<Constraint> prePostInv,
//        Instance instance
//    )
//    {
//        // Attributes and Invariants for each state
//        var index = 0
//        for (state : sequence.states) {
//            encodeBasisForState(
//                state,
//                sequence.model,
//                index,
//                prePostInv,
//                instance
//            )
//            index = index + 1
//        }
//    }
//
//    static private def void encodeParameters
//    (
//        Instance instance,
//        EClass c,
//        EOperation op,
//        StateSequence statesequence,
//        HashMap<String, EObject> varmap,
//        Set<String> parameterVariables,
//        StateObject obj,
////        Integer objNo,
//        Integer stateNo
//    )
//    {
//        val objectName = obj.name.split("::").get(2)
//        for (param : op.getEParameters)
//        {
//            val paramType = param.getEType
//            val paramTypeName = paramType.name
//            var int paramWidth = -1
//            switch (paramType) {
//                EDataType:{
//                    if (    (    param.lowerBound == 0
//                              || param.lowerBound == 1)
//                         && param.upperBound == 1)
//                    {
//                        if (    param.lowerBound == 0
//                             && param.upperBound == 1)
//                        {
//                            System.err.println("A parameter with a lowerBound == 0 and uperBound == 1 has been detected, this can cause a strange behaviour!")
//                        }
//                        switch (paramTypeName) {
//                            case "EInt":{
//                                paramWidth = intBitwidth
//                            }
//                            case "EBoolean":{
//                                paramWidth = boolBitwidth
//                            }
//                        }
//                    }
//                    else // this is the parameter is a CollectionType
//                    {
//                        switch (paramTypeName) {
//                            case "EInt":{
//                                if (param.unique && !param.ordered) // Set
//                                {
//                                    paramWidth = intSetBitwidth
//                                }
//                                if (param.unique && param.ordered) // OrderedSet
//                                {
//                                    paramWidth = intSetBitwidth * (intSetBitwidth+1)
//                                }
//                                if (!param.unique && !param.ordered) // Bag
//                                {
//                                    paramWidth = intSetBitwidth * bagElementBitwidth
//                                }
//                                if (!param.unique && param.ordered) // Sequence: no support
//                                {
////                                    paramWidth = ???
//                                }
//                            }
//                            case "EBoolean":{
//                                if (param.unique && !param.ordered) // Set
//                                {
//                                    paramWidth = 2
//                                }
//                                if (param.unique && param.ordered) // OrderedSet
//                                {
//                                    paramWidth = 4
//                                }
//                                if (!param.unique && !param.ordered) // Bag
//                                {
//                                    paramWidth = 2 * bagElementBitwidth
//                                }
//                                if (!param.unique && param.ordered) // Sequence: no support
//                                {
////                                    paramWidth = ???
//                                }
//                            }
//                        }
//                    }
//                }
//                EClass:{
//                    val int noOfInstantiations = statesequence.states.get(stateNo).contents
//                                                              .filter[it.eClass.name == param.getEType.name].length
//                    if (    (    param.lowerBound == 0
//                              || param.lowerBound == 1)
//                         && param.upperBound == 1)
//                    {
//                        if (    param.lowerBound == 0
//                             && param.upperBound == 1)
//                        {
//                            System.err.println("A parameter with a lowerBound == 0 and uperBound == 1 has been detected, this can cause a strange behaviour!")
//                        }
//                        paramWidth = noOfInstantiations
//                    }
//                    else // this is the parameter is a CollectionType
//                    {
//                        if (param.unique && !param.ordered) // Set
//                        {
//                            paramWidth = noOfInstantiations
//                        }
//                        if (param.unique && param.ordered) // OrderedSet
//                        {
//                            // optimize with a better log-calculation
//                            paramWidth = noOfInstantiations * ((Math.ceil(Math.log(noOfInstantiations)/Math.log(2))+1) as int)
//                        }
//                        if (!param.unique && !param.ordered) // Bag
//                        {
//                            paramWidth = noOfInstantiations * bagElementBitwidth
//                        }
//                        if (!param.unique && param.ordered) // Sequence: no support
//                        {
////                            paramWidth = ???
//                        }
//                    }
//                }
//                default:{
//                    
//                }
//            }
//            val int copyParamWidth = paramWidth
//            val paramVarName = '''«c.getEPackage.name»::state«stateNo»::«objectName»::«op.name»::param::«param.name»'''
//            val paramVar =
//                if (paramTypeName == "EBoolean")
//                {
//                    paramVarName.newPredicate
//                }
//                else
//                {
//                    factory.createBitvector => [
//                        name = paramVarName
//                        width = copyParamWidth
//                    ]
//                }
//            instance.variables += paramVar
//            // For set parameter support
//            if (paramTypeName != "EInt" && paramTypeName != "EBoolean") {
//                if(param.lowerBound == 1 && param.upperBound == 1) {
//                    instance.assertions += factory.createOneHotExpression => [
//                        expr = paramVar.variableExpression
//                    ]
//                }
//            }
//            parameterVariables += paramVar.name
//            varmap.put(param.name, new de.agra.emf.modelfinder.encoding.PlaceholderExpression(param) => [
//                attributeString = paramVar.name
//                attributeWidth = copyParamWidth
//            ])
//        }
//    }
//
//    static def encodeDynamic
//    (
//        StateSequence sequence,
//        List<Constraint> prePostInv
//    )
//    {
//        val instance = factory.createInstance
//        val model = sequence.model
//        encodeBasisForStates(sequence,prePostInv,instance)
//
//        /* Pre- and post-conditions combined by omega variables */
//        // 1. Determine the number of operation calls from model and state 
//        //    Beware the number of objects for the operation must be calculated! 
//        val numOpCalls = model.calculateNumberOfOperationCalls(sequence.states)
//
//        // 2. Create k-1 omega variables of appropriate bit-size (k = states.size)
//        val List<EClass> possibleEClasses = sequence.model.getEClassifiers.map[it as EClass]
//        val List<EClass> possibleRealEClasses = possibleEClasses.filter[it.abstract == false].toList
//        val omegaWidth = numOpCalls.bitwidth
//        val modifiesBVWidth = sequence.modelElements.length
//        val modifiesOnlyBVWidth = possibleRealEClasses.length
//        val omegas = new ArrayList<Bitvector>
//        val omegaModifies = new ArrayList<Bitvector>
//        val omegaModifiesOnly = new ArrayList<Bitvector>
//        for (i : 0..<(sequence.states.size - 1)) {
//            omegas += createAndAddOmega("omega"+i,omegaWidth,numOpCalls,instance,false)
//            sequence.transitions.add( new TransitionObjectImpl => [
//                name="state"+i+"->"+"state"+(i+1)
//            ])
//            omegaModifies += newBitvector(
//                "omega"+i+"::overallModifies",
//                modifiesBVWidth
//            )
//            instance.variables += omegaModifies.last
//            omegaModifiesOnly += newBitvector(
//                "omega"+i+"::overallModifiesOnly",
//                modifiesOnlyBVWidth
//            )
//            instance.variables += omegaModifiesOnly.last
//        }
//
//        val Set<String> parameterVariables = new HashSet<String>
//
//        // 3. Combine with pre and post conditions (pseudo code)
//        for (i : 0..<(sequence.states.size - 1)) {
//            val omegaModifiesExpr = omegaModifies.get(i).newVariableExpression
//            val omegaModifiesOnlyExpr = omegaModifiesOnly.get(i).newVariableExpression
//            // TODO variable list must depend on the "real" model properties
//            val List<Variable> variablesOfPostState = new ArrayList<Variable>
//            sequence.modelElements.forEach[
//                val keyNameSplit = it.key.name.split("::")
//                keyNameSplit.set(1, "state"+(i+1))
//                variablesOfPostState += instance.getVariable(keyNameSplit.join("::")+"::"+it.value.name)
//            ]
//
//            var id = 0 // id for the operation call
//            // for each class in the model
//            for (c : possibleEClasses) {
//                // for each operation of the class
//                for (op : c.getEOperations) {
//                    var objNo = 0
//                    // for each object of class and also its subclass(!)
//                    val possibleObjects = (sequence.states.get(i) as StateResource)
//                                            .allObjectsOfType(c)
//                                            .map[it as StateObject]
//                    for (obj : possibleObjects)
//                    {
////                        if (!c.equals(obj.eClass))
////                        {
////                            System.err.println("\nThe object "+obj.name+" is a subclass of\n"
////                                + c.name + " which is the current class for the encoding of the\n"
////                                + "operation " + op.name + ". If there are any additional pre- or\n"
////                                + "postconditions is any subclass, they will be ignored!!!\n"
////                            )
////                        }
//                        val varmap = new HashMap<String, EObject>
//                        varmap.put("self", obj)
//                        // Parameter handling is sourced out to encodeParameters
//                        encodeParameters
//                        (
//                            instance,
//                            c,
//                            op,
//                            sequence,
//                            varmap,
//                            parameterVariables,
//                            obj as StateObject,
//                            i
//                        )
//
//                        val prePostAnd = factory.createAndExpression
//
//                        // Conjunction for pre-conditions
//                        for (pre : prePostInv.getOperationConstraints("precondition", op)) {
//                            val encodedPre = utils.encodePreCondition
//                            (
//                                instance,
//                                sequence.states.get(i) as StateResource,
//                                pre,
//                                varmap
//                            )
//                            if (encodedPre != null)
//                            {
//                                prePostAnd.expressions += encodedPre
//                            }
//                            else
//                            {
//                                System.err.println("The EOperation " + op.name + " (Class: "
//                                    + (op.eContainer as EClass).name
//                                    + ") has a postcondition where the encoding has returned a null!\n"
//                                    + "Thus, the postcondition (name: "+pre.name+") will be ignored!"
//
//                                )
//                            }
//                        }
//
//                        // Conjunction for post-conditions
//                        val nextState = sequence.states.get(i + 1) as StateResource
//                        nextState.preState = sequence.states.get(i)
//                        val objectNext = findObjectInNextState(nextState, obj)
//                        varmap.put("self", objectNext)
//
//                        val visitor = new de.agra.emf.modelfinder.encoding.VariableExpressionVisitor()
//
//                        val postOCL = new ArrayList<Constraint>
//                        val modifiesOCL = new ArrayList<Constraint>
//                        val modifiesOnlyOCL = new ArrayList<Constraint>
//                        prePostInv.getOperationConstraints("postcondition", op).forEach[
//                            if (it.name == "modifies")
//                            {
//                                modifiesOCL += it
//                            }
//                            else if (it.name == "modifiesOnly")
//                            {
//                                modifiesOnlyOCL += it
//                            }
//                            else
//                            {
//                                postOCL += it
//                            }
//                        ]
//                        for (post : postOCL)
//                        {
//                            val encodedPost = utils.encodePostCondition
//                            (
//                                instance,
//                                nextState,
//                                post,
//                                varmap
//                            )
//                            if (encodedPost != null)
//                            {
//                                prePostAnd.expressions += encodedPost
//                            }
//                            else
//                            {
//                                System.err.println("The EOperation " + op.name + " (Class: " + op.eContainer
//                                    + ") has a postcondition where the encoding has returned a null!\n"
//                                    + "Thus, the postcondition (name: "+post.name+") will be ignored!"
//                                )
//                            }
//                            if (!useModifies)
//                            {
//                                visitor.visit( encodedPost )
//                            }
//                        }
//                        if (useModifies)
//                        {
//                            var modifyCounter = 0
//                            val List<Expression> modifyBVs = new ArrayList<Expression>();
//                            for (modifies : modifiesOCL)
//                            {
//                                val tmp = utils.encodeSingleModifiesCondition
//                                (
//                                    sequence,
//                                    instance,
//                                    nextState,
//                                    variablesOfPostState,
//                                    modifies,
//                                    varmap,
//                                    modifyCounter,
//                                    id,
//                                    i // the index of the transition number
//                                )
//                                if (tmp == null)
//                                {
//                                    System.err.println("WARNING! encodeSingleModifiesCondition returned a null reference!")
//                                }
//                                else
//                                {
//                                    modifyBVs += tmp
//                                }
//                                modifyCounter++
//                            }
//                            // jetzt mit black magic irgendwie zusammenbauen
//                            val gModifiesBV = newBitvector(
//                                "omega"+i+"::modifies@"+id,
//                                modifiesBVWidth
//                            )
//                            instance.variables += gModifiesBV
//                            if (modifyCounter > 0)
//                            {
//                                var Expression modifiesBvANDExpr = modifyBVs.last
//                                for (var index = modifyCounter - 2 ; index >= 0; index--)
//                                {
//                                    modifiesBvANDExpr = newBvAndExpression
//                                    (
//                                        modifyBVs.get(index),
//                                        modifiesBvANDExpr
//                                    )
//                                }
//                                instance.assertions += newEqualsExpression
//                                (
//                                    gModifiesBV.newVariableExpression,
//                                    modifiesBvANDExpr
//                                )
//                            }
//                            else
//                            {
//                                instance.assertions += newEqualsExpression
//                                (
//                                    gModifiesBV.newVariableExpression,
//                                    "1".constString(variablesOfPostState.length).newBitstringExpression
//                                )
//                            }
//                            prePostAnd.expressions += newEqualsExpression
//                            (
//                                omegaModifiesExpr,
//                                gModifiesBV.newVariableExpression
//                            )
//
//                            val List<Expression> modifyOnlyBVs = new ArrayList<Expression>();
//                            var modifyOnlyCounter = 0
//                            for (modifiesOnly : modifiesOnlyOCL)
//                            {
//                                // add an handler for modifiesOnly constraints
//                                val tmp = utils.encodeSingleModifiesOnlyCondition
//                                (
//                                    sequence,
//                                    instance,
//                                    nextState,
//                                    possibleRealEClasses,
//                                    modifiesOnly,
//                                    varmap,
//                                    modifyOnlyCounter,
//                                    id,
//                                    i // the index of the transition number
//                                )
//                                if (tmp == null)
//                                {
//                                    System.err.println("WARNING! encodeSingleModifiesOnlyCondition returned a null reference!")
//                                }
//                                else
//                                {
//                                    modifyOnlyBVs += tmp
//                                }
//                                modifyOnlyCounter++
//                            }
//                            // jetzt mit black magic irgendwie zusammenbauen
//                            val gModifiesOnlyBV = newBitvector
//                            (
//                                "omega"+i+"::modifiesOnly@"+id,
//                                possibleRealEClasses.length
//                            )
//                            instance.variables += gModifiesOnlyBV
//                            if (modifyOnlyCounter > 0)
//                            {
//                                var Expression modifiesOnlyBvANDExpr = modifyOnlyBVs.last
//                                for (var index = modifyOnlyCounter - 2 ; index >= 0; index--)
//                                {
//                                    modifiesOnlyBvANDExpr = newBvAndExpression
//                                    (
//                                        modifyOnlyBVs.get(index),
//                                        modifiesOnlyBvANDExpr
//                                    )
//                                }
//                                instance.assertions += newEqualsExpression
//                                (
//                                    gModifiesOnlyBV.newVariableExpression,
//                                    modifiesOnlyBvANDExpr
//                                )
//                            }
//                            else
//                            {
//                                instance.assertions += newEqualsExpression
//                                (
//                                    gModifiesOnlyBV.newVariableExpression,
//                                    "1".constString(possibleRealEClasses.length).newBitstringExpression
//                                )
//                            }
//                            prePostAnd.expressions += newEqualsExpression
//                            (
//                                omegaModifiesOnlyExpr,
//                                gModifiesOnlyBV.newVariableExpression
//                            )
//                        }
//                        else // useModfies == false i.e. use the visitor
//                        {
//                            postProcessingForVisitor(sequence.states.get(i+1),visitor)
//                            visitor.visitedVariables += parameterVariables
//                            //TODO general assumption for "varSplit.length > 4": could cause problems but seems to be fine for most cases...
//                            var Set<String> additionalVariables = new HashSet<String>()
//                            for(String visVar : visitor.visitedVariables) {
//                                var varSplit = visVar.split("::")
//                                if(varSplit.length > 4) {
//                                    additionalVariables.add(varSplit.get(0)+"::"+varSplit.get(1)+"::"+varSplit.get(2)+"::"+varSplit.get(3))
//                                }
//                            }
//                            visitor.visitedVariables.addAll(additionalVariables)
//
//                            // prohibit changes in all non-touched variables
//                            val variablesOfLastState = getAllVariablesOfState("state", i, instance)
//                            for ( variable : getAllVariablesOfState("state", i+1, instance) ) {
//                                if ( ! visitor.visitedVariables.contains( variable.name ) ) {
//                                    val stateSep = variable.name.split("::")
//                                    if (stateSep.length <= 4)
//                                    {
//                                        stateSep.set(1, "state" + i)
//                                        val variableInLastState = variablesOfLastState.findFirst[it.name == stateSep.join("::")]
//                                        val innerEq = factory.createEqualsExpression => [
//                                            lhs = variableExpression( variable )
//                                            rhs = variableExpression( variableInLastState )
//                                        ]
//                                        if (useAlpha)
//                                        {
//                                            if (!variable.name.endsWith("alpha"))
//                                            {
//                                                prePostAnd.expressions += factory.createImpliesExpression => [
//                                                    lhs = factory.createEqualsExpression => [
//                                                        lhs = instance.extractAlphaBit(variable.name)
//                                                        try {
//                                                        rhs = instance.extractAlphaBit(variableInLastState.name)
//                                                        } catch (Exception e)
//                                                        {
//                                                            print("")
//                                                        }
//                                                    ]
//                                                    rhs = innerEq
//                                                ]
//                                            }
//                                        }
//                                        else
//                                        {
//                                            prePostAnd.expressions += innerEq
//                                        }
//                                    }
//                                }
//                            }
//                        }
//
//                        sequence.transitions.get(i).objects += Pair::of(id.toString, obj.name + "::" + op.name)
//
//                        // Equal expression for omega
//                        if (!prePostAnd.expressions.empty) {
//                            val copyId = id // @TODO can we do this nicer?
//                            instance.assertions += factory.createImpliesExpression => [
//                                lhs = factory.createEqualsExpression => [
//                                    lhs = variableExpression(omegas.get(i))
//                                    rhs = constIntegerExpression(copyId, omegaWidth)
//                                ]
//                                rhs = prePostAnd
//                            ]
//                        }
//
//                        if (i == 0) {
//                            var opName = op.name
//                            if (op.getEParameters.size > 0)
//                            {
//                                opName = opName +"( .. )"
//                            }
//                            else
//                            {
//                                opName = opName +"()"
//                            }
//                            sequence.omegaTransitionInformation
//                                    .addOmegaValueInformation(
//                                         new Pair(
//                                            id,
//                                            new Pair(c.name+"@"+objNo, opName)
//                                         )
//                                     )
//                        }
//                        id++
//                        objNo++
//                    }
//                }
//            }
//            // the following expression should be added instead of the visitor assertions
//            if (useModifies)
//            {
//                val finalizingModifiesExpression = utils.encodeFinalizingModifies
//                (
//                    sequence,
//                    instance,
//                    variablesOfPostState,
//                    omegaModifies.get(i)
//                )
//                instance.assertions += finalizingModifiesExpression
//                if (useAlpha)
//                {
//                    val finalizingModifiesOnlyExpression = utils.encodeFinalizingModifiesOnly
//                    (
//                        sequence,
//                        instance,
//                        possibleRealEClasses,
//                        i,
//                        omegaModifiesOnly.get(i)
//                    )
//                    instance.assertions += finalizingModifiesOnlyExpression
//                }
//            }
//        }
//        return instance
//    }
//
//    static def encodeDynamicParallel
//    (
//        StateSequence statesequence,
//        List<Constraint> prePostInv,
//        Pair<Integer, Integer> bounds
//    )
//    {
//        val lowerBound = bounds.key
//        val upperBound = bounds.value
//        if (lowerBound > upperBound)
//        {
//            throw new Exception("InstanceGenerator::encodeDynamicParallel was lowerBound which\n"
//                + "is greater than the upperBound."
//            )
//        }
//        if (upperBound == 1)
//        {
//            throw new Exception("InstanceGenerator::encodeDynamicParallel was called\n"
//                + "with at most 1-times parallelism, please use encodeDynamic for this case."
//            )
//        }
//        if (lowerBound < 1 || 10 < upperBound)
//        {
//            throw new Exception("InstanceGenerator::encodeDynamicParallel was called\n"
//                + "with a lowerBound of "+lowerBound+" and an upperBound of "+upperBound
//                + " for parallelism, but only we are only supporting bounds b of natural\n"
//                + "numbers with 1 < b < 11."
//            )
//        }
//        val model = statesequence.model
//        val instance = factory.createInstance
//        encodeBasisForStates
//        (
//            statesequence,
//            prePostInv,
//            instance
//        )
//
//        /* Pre- and post-conditions combined by omega variables */
//        // 1. Determine the number of operation calls from model and state
//        //    Beware the number of objects for the operation must be calculated!
//        val numOpCalls = model.calculateNumberOfOperationCalls(statesequence.states)
//
//        // 2. Create k-1 omega bitvector variables (k = states.size)
//        //    The bitwidth of the every omega bitvector must be numOpCalls
//        //    because a function call is encoded with a hot-encoding.
//        //    Furthermore, a bitvector for the frameconditions must be generated
//        //    for each bit in omega!
////        val numOfVarsPerState = getAllVariablesOfState
////        (
////            "state",
////            0,
////            instance
////        ).filter[!it.name.endsWith("::alpha")].length
//       
//        val List<EClass> possibleEClasses = statesequence.model.getEClassifiers.map[it as EClass]
//        val List<EClass> possibleRealEClasses = possibleEClasses.filter[it.abstract == false].toList
//        val omegaWidth = numOpCalls
//        val modifiesBVWidth = statesequence.modelElements.length
//        val modifiesOnlyBVWidth = possibleRealEClasses.length
//        val omegas = new ArrayList<Bitvector>
//        val omegaModifies = new ArrayList<Bitvector>
//        val omegaModifiesOnly = new ArrayList<Bitvector>
//        for (i : 0..<(statesequence.states.size - 1)) {
//            omegas += createAndAddOmega
//            (
//                "omega"+i,
//                omegaWidth,
//                numOpCalls,
//                instance,
//                true
//            )
//            statesequence.transitions.add( new TransitionObjectImpl => [
//                name="state"+i+"->"+"state"+(i+1)
//            ])
//            omegaModifies += newBitvector(
//                "omega"+i+"::overallModifies",
//                modifiesBVWidth
//            )
//            instance.variables += omegaModifies.last
//            omegaModifiesOnly += newBitvector(
//                "omega"+i+"::overallModifiesOnly",
//                modifiesOnlyBVWidth
//            )
//            instance.variables += omegaModifiesOnly.last
//
//            if (!useModifies)
//            {
////                var Expression result = newBitstringExpression(constString("1",numOfVarsPerState))
////                for(j : 0..<(omegaWidth))
////                {
////                    val fcBV = factory.createBitvector => [
////                        name = "omega"+i+"::fcForBit@"+j
////                        width = numOfVarsPerState
////                    ]
////                    instance.variables += fcBV
////                    result = newBvAndExpression
////                    (
////                        fcBV.variableExpression,
////                        result
////                    )
////                }
////                val allFcBV = factory.createBitvector => [
////                    name = "omega"+i+"::allFC"
////                    width = numOfVarsPerState
////                ]
////                instance.variables += allFcBV
////                instance.assertions += newEqualsExpression(
////                    allFcBV.variableExpression,
////                    result
////                )
//            }
//            instance.assertions += newCardGeExpression
//            (
//                lowerBound,
//                #[omegas.last as Variable]
//            )
//            instance.assertions += newCardLeExpression
//            (
//                upperBound,
//                #[omegas.last as Variable]
//            )
//        }
//
//        val Set<String> parameterVariables = new HashSet<String>
//
//        // 3. Combine with pre and post conditions (pseudo code)
//        // encode every system state
//        for (i : 0..<(statesequence.states.size - 1))
//        {
//            // TODO check if the following ~50 lines are really necessary
//
////            val variablesOfLastState = getAllVariablesOfState
////            (
////                "state",
////                i,
////                instance
////            ).filter[!it.name.endsWith("::alpha")]
////            val variablesOfState = getAllVariablesOfState
////            (
////                "state",
////                i+1,
////                instance
////            ).filter[!it.name.endsWith("::alpha")]
////
////            val omegaAllFcBvVarExpr = instance.getVariable("omega"+i+"::allFC")
////                                              .variableExpression
////            variablesOfState.forEach[variable, index |
////                val stateSep = variable.name.split("::")
////                stateSep.set(1, "state" + i)
////                val variableInLastState = variablesOfLastState.findFirst[it.name == stateSep.join("::")]
////                val innerEq = factory.createEqualsExpression => [
////                    lhs = variableExpression( variable )
////                    rhs = variableExpression( variableInLastState )
////                ]
////                val extractIndex = newExtractIndexExpression
////                (
////                    omegaAllFcBvVarExpr,
////                    index
////                )
////                instance.assertions += factory.createImpliesExpression => [
////                    lhs = factory.createAndExpression => [
////                            expressions += extractIndex
////                            if (useAlpha)
////                            {
////                                expressions += factory.createEqualsExpression => [
////                                    lhs = instance.extractAlphaBit(variable.name)
////                                    rhs = instance.extractAlphaBit(variableInLastState.name)
////                                ]
////                            }
////                    ]
////                    rhs = innerEq
////                ]
////            ]
//
//
//            /*
//             *  Get the pre and post state reference and also the the preState reference for the
//             * usage in encodePost
//             */
//            val preState = statesequence.states.get(i) as StateResource
//            val postState = statesequence.states.get(i + 1) as StateResource
//            postState.preState = preState
//
//            val List<Expression> modfiesResultBVs = new ArrayList<Expression> ()
//            val List<Expression> modfiesOnlyResultBVs = new ArrayList<Expression> ()
//
//            val List<Variable> variablesOfPostState = new ArrayList<Variable>
//            statesequence.modelElements.forEach[
//                val keyNameSplit = it.key.name.split("::")
//                keyNameSplit.set(1, "state"+(i+1))
//                variablesOfPostState += instance.getVariable(keyNameSplit.join("::")+"::"+it.value.name)
//            ]
//
//            var opId = 0 // id for the operation call
//            // for each class in the model
//            for (c : possibleEClasses) {
//                // for each operation of the class
//                val possibleObjects = preState.allObjectsOfType(c)
//                for (op : c.getEOperations) {
//                    var objNo = 0
////                    var objNo = -1
//                    // for each object of class and also its subclasses(!)
//                    for (obj : possibleObjects)
//                    {
////                        if (!c.equals(obj.eClass))
////                        {
////                            System.err.println("\nThe object "+obj.name+" is a subclass of\n"
////                                + c.name + " which is the current class for the encoding of the\n"
////                                + "operation " + op.name + ". If there are any additional pre- or\n"
////                                + "postconditions is any subclass, they will be ignored!!!\n"
////                            )
////                        }
//
//
//                        val varmap = new HashMap<String, EObject>
//                        varmap.put("self", obj)
//                        // Parameter handling is sourced out to encodeParameters
//                        encodeParameters
//                        (
//                            instance,
//                            c,
//                            op,
//                            statesequence,
//                            varmap,
//                            parameterVariables,
//                            obj as StateObject,
//                            i
//                        )
//
//                        val prePostAnd = factory.createAndExpression
//
//                        // Conjunction for pre-conditions
//                        for (pre : prePostInv.getOperationConstraints("precondition", op))
//                        {
//                            prePostAnd.expressions += utils.encodePreCondition
//                            (
//                                instance,
//                                preState,
//                                pre,
//                                varmap
//                            )
//                        }
//
//                        // Conjunction for post-conditions
//                        val objectNext = findObjectInNextState(postState, obj)
//                        // Update the self object because now self has the object in the post state
//                        varmap.put("self", objectNext)
//
//                        val visitor = new de.agra.emf.modelfinder.encoding.VariableExpressionVisitor()
//
//                        val postOCL = new ArrayList<Constraint>
//                        val modifiesOCL = new ArrayList<Constraint>
//                        val modifiesOnlyOCL = new ArrayList<Constraint>
//                        prePostInv.getOperationConstraints("postcondition", op).forEach[
//                            if (it.name == "modifies")
//                            {
//                                modifiesOCL += it
//                            }
//                            else if (it.name == "modifiesOnly")
//                            {
//                                modifiesOnlyOCL += it
//                            }
//                            else
//                            {
//                                postOCL += it
//                            }
//                        ]
//                        for (post : postOCL)
//                        {
//                            val encodedPost = utils.encodePostCondition
//                            (
//                                instance,
//                                postState,
//                                post,
//                                varmap
//                            )
//                            if (encodedPost != null)
//                            {
//                                prePostAnd.expressions += encodedPost
//                            }
//                            else
//                            {
//                                System.err.println("The EOperation " + op.name + " (Class: " + op.eContainer
//                                    + ") has a postcondition where the encoding has returned a null!\n"
//                                    + "Thus, the postcondition (name: "+post.name+") will be ignored!"
//                                )
//                            }
//                            if (!useModifies)
//                            {
//                                visitor.visit( encodedPost )
//                            }
//                        }
//
//                        // create BVs for the real result and a maybe result
//                        val currentOmegaModifiesResultBV = newBitvector(
//                            "omega"+i+"::modifies@"+opId+"::result",
//                            modifiesBVWidth
//                        )
//                        instance.variables += currentOmegaModifiesResultBV
//                        val currentOmegaModifiesResultBVExpr = currentOmegaModifiesResultBV.variableExpression
//                        modfiesResultBVs += currentOmegaModifiesResultBVExpr
//
//                        val currentOmegaModifiesOnlyResultBV = newBitvector
//                        (
//                            "omega"+i+"::modifiesOnly@"+opId+"::result",
//                            possibleRealEClasses.length
//                        )
//                        instance.variables += currentOmegaModifiesOnlyResultBV
//                        val currentOmegaModifiesOnlyResultBVExpr = currentOmegaModifiesOnlyResultBV.variableExpression
//                        modfiesOnlyResultBVs += currentOmegaModifiesOnlyResultBVExpr
//
//                        // and now the maybe results
//                        val currentOmegaModifiesMaybeResultBV = newBitvector(
//                            "omega"+i+"::modifies@"+opId+"::maybeResult",
//                            modifiesBVWidth
//                        )
//                        instance.variables += currentOmegaModifiesMaybeResultBV
//                        val currentOmegaModifiesMaybeResultBVExpr = currentOmegaModifiesMaybeResultBV.variableExpression
//
//                        val currentOmegaModifiesOnlyMaybeResultBV = newBitvector
//                        (
//                            "omega"+i+"::modifiesOnly@"+opId+"::maybeResult",
//                            possibleRealEClasses.length
//                        )
//                        instance.variables += currentOmegaModifiesOnlyMaybeResultBV
//                        val currentOmegaModifiesOnlyMaybeResultBVExpr = currentOmegaModifiesOnlyMaybeResultBV.variableExpression
//                        if (useModifies)
//                        {
//                            var modifyCounter = 0
//                            val List<Expression> modifyBVs = new ArrayList<Expression>();
//                            for (modifies : modifiesOCL)
//                            {
//                                modifyBVs += utils.encodeSingleModifiesCondition
//                                (
//                                    statesequence,
//                                    instance,
//                                    postState,
//                                    variablesOfPostState,
//                                    modifies,
//                                    varmap,
//                                    modifyCounter,
//                                    opId,
//                                    i // the index of the transition number
//                                )
//                                modifyCounter++
//                            }
//                            if (modifyCounter > 0)
//                            {
//                                var Expression modifiesBvANDExpr = modifyBVs.last
//                                for (var index = modifyCounter - 2 ; index >= 0; index--)
//                                {
//                                    modifiesBvANDExpr = newBvAndExpression
//                                    (
//                                        modifyBVs.get(index),
//                                        modifiesBvANDExpr
//                                    )
//                                }
//                                instance.assertions += newEqualsExpression
//                                (
//                                    currentOmegaModifiesMaybeResultBVExpr,
//                                    modifiesBvANDExpr
//                                )
//                            }
//                            else
//                            {
//                                instance.assertions += newEqualsExpression
//                                (
//                                    currentOmegaModifiesMaybeResultBVExpr,
//                                    "1".constString(variablesOfPostState.length).newBitstringExpression
//                                )
//                            }
//                            prePostAnd.expressions += newEqualsExpression
//                            (
//                                currentOmegaModifiesResultBVExpr,
//                                currentOmegaModifiesMaybeResultBVExpr
//                            )
//
//                            val List<Expression> modifyOnlyBVs = new ArrayList<Expression>();
//                            var modifyOnlyCounter = 0
//                            for (modifiesOnly : modifiesOnlyOCL)
//                            {
//                                // add an handler for modifiesOnly constraints
//                                modifyOnlyBVs += utils.encodeSingleModifiesOnlyCondition
//                                (
//                                    statesequence,
//                                    instance,
//                                    postState,
//                                    possibleRealEClasses,
//                                    modifiesOnly,
//                                    varmap,
//                                    modifyOnlyCounter,
//                                    opId,
//                                    i // the index of the transition number
//                                )
//                                modifyOnlyCounter++
//                            }
//                            if (modifyOnlyCounter > 0)
//                            {
//                                var Expression modifiesOnlyBvANDExpr = modifyOnlyBVs.last
//                                for (var index = modifyOnlyCounter - 2 ; index >= 0; index--)
//                                {
//                                    modifiesOnlyBvANDExpr = newBvAndExpression
//                                    (
//                                        modifyOnlyBVs.get(index),
//                                        modifiesOnlyBvANDExpr
//                                    )
//                                }
//                                instance.assertions += newEqualsExpression
//                                (
//                                    currentOmegaModifiesOnlyMaybeResultBVExpr,
//                                    modifiesOnlyBvANDExpr
//                                )
//                            }
//                            else
//                            {
//                                instance.assertions += newEqualsExpression
//                                (
//                                    currentOmegaModifiesOnlyMaybeResultBVExpr,
//                                    "1".constString(possibleRealEClasses.length).newBitstringExpression
//                                )
//                            }
//                            prePostAnd.expressions += newEqualsExpression
//                            (
//                                currentOmegaModifiesOnlyResultBVExpr,
//                                currentOmegaModifiesOnlyMaybeResultBVExpr
//                            )
//                        }
//                        else // useModfies == false i.e. use the visitor
//                        {
////                            postProcessingForVisitor
////                            (
////                                statesequence.states.get(i+1),
////                                visitor
////                            )
////                            visitor.visitedVariables += parameterVariables
////
////                            val omegaFcBvVarExpr = instance.getVariable("omega"+i+"::fcForBit@"+opId)
////                                                           .variableExpression
////                            variablesOfState.forEach[variable, index |
////                                val extractIndex = newExtractIndexExpression
////                                (
////                                    omegaFcBvVarExpr,
////                                    index
////                                )
////                                instance.assertions += factory.createIteExpression => [
////                                    condition = extractedOmegaExpr
////                                    thenexpr = factory.createEqualsExpression => [
////                                        lhs = extractIndex
////                                        rhs =
////                                            if (visitor.visitedVariables.contains(variable.name))
////                                            {
////                                                newBitstringExpression("0")
////                                            }
////                                            else
////                                            {
////                                                newBitstringExpression("1")
////                                            }
////                                    ]
////                                    elseexpr = factory.createEqualsExpression => [
////                                        lhs = extractIndex
////                                        rhs = newBitstringExpression("1")
////                                    ]
////                                ]
////                            ]
//                        }
//
//                        /* prohibit changes in all non-touched variables by implying
//                         * that the corresponding bits (in the fcBV) are equal to 1.
//                         */
//                        val omegaVarExpr = omegas.get(i).variableExpression
//                        val extractedOmegaExpr = newExtractIndexExpression
//                        (
//                            omegaVarExpr,
//                            opId
//                        )
//
//                        statesequence.transitions.get(i).objects += Pair::of(opId.toString, obj.name + "::" + op.name)
//
//                        // Equal expression for omega
//                        if (!prePostAnd.expressions.empty) {
//                            val constModifies = newEqualsExpression
//                            (
//                                currentOmegaModifiesResultBVExpr,
//                                "1".constString(variablesOfPostState.length).newBitstringExpression
//                            )
//                            val constModifiesOnly = newEqualsExpression
//                            (
//                                currentOmegaModifiesOnlyResultBVExpr,
//                                "1".constString(possibleRealEClasses.length).newBitstringExpression
//                            )
//                            val tmp = newIteExpression
//                            (
//                                newEqualsExpression
//                                (
//                                    extractedOmegaExpr,
//                                    newBitstringExpression("1")
//                                ),
//                                prePostAnd,
//                                #[constModifies, constModifiesOnly].newAndExpression
//                            )
//                            instance.assertions += tmp
//                        }
//
//                        if (i == 0) {
//                            var opName = op.name
//                            if (op.getEParameters.size > 0)
//                            {
//                                println("Operations with parameters are still experimental")
//                                opName = opName +"( .. )"
//                            } else
//                            {
//                                opName = opName +"()"
//                            }
//                            statesequence.omegaTransitionInformation
//                                         .addOmegaValueInformation(
//                                             new Pair(
//                                                 opId,
//                                                 new Pair(c.name+"@"+objNo, opName)
//                                             )
//                                         )
//                        }
//                        opId++
//                        print("")
//                    }
//                }
//            }
//            // the following expression should be added instead of the visitor assertions
//            if (useModifies)
//            {
//                val finalizingModifiesExpression = utils.encodeFinalizingModifies
//                (
//                    statesequence,
//                    instance,
//                    variablesOfPostState,
//                    omegaModifies.get(i)
//                )
//                instance.assertions += finalizingModifiesExpression
//                val finalizingModifiesOnlyExpression = utils.encodeFinalizingModifiesOnly
//                (
//                    statesequence,
//                    instance,
//                    possibleRealEClasses,
//                    i,
//                    omegaModifiesOnly.get(i)
//                )
//                instance.assertions += finalizingModifiesOnlyExpression
//            }
//            // bvAND over all results
//            var Expression modifiesTree = modfiesResultBVs.last
//            for (var index = modfiesResultBVs.length - 2 ; index >= 0; index--)
//            {
//                modifiesTree = newBvAndExpression
//                (
//                    modfiesResultBVs.get(index),
//                    modifiesTree
//                )
//            }
//            instance.assertions += newEqualsExpression
//            (
//                omegaModifies.get(i).newVariableExpression,
//                modifiesTree
//            )
//            var Expression modifiesOnlyTree = modfiesOnlyResultBVs.last
//            for (var index = modfiesOnlyResultBVs.length - 2 ; index >= 0; index--)
//            {
//                modifiesOnlyTree = newBvAndExpression
//                (
//                    modfiesOnlyResultBVs.get(index),
//                    modifiesOnlyTree
//                )
//            }
//            instance.assertions += newEqualsExpression
//            (
//                omegaModifiesOnly.get(i).newVariableExpression,
//                modifiesOnlyTree
//            )
//        }
//        instance
//    }
//
//    static def extendDynamicInstanceWithDeadlock
//    (
//        Instance instance,
//        StateSequence sequence,
//        List<Constraint> prePostInv,
//        Bounds bounds
//    )
//    {
//        /* Add constraints such that the last state is in a deadlock */
//        val model = sequence.model
//        val lastStateNumber = sequence.states.size - 1
//        val lastState = sequence.states.get(lastStateNumber)
//        val String pseudoStateName = "PSEUDO-state"
//
//        val Set<String> parameterVariables = new HashSet<String>
//        val List<Resource> states = new ArrayList<Resource>
//        states += sequence.states
//
//        var operationId = 0 // id for the operation call
//        for (c : model.getEClassifiers.map[it as EClass]) { // for each class in the model
//            for (op : c.eContents.filter[it.eClass.name == "EOperation"].map[it as EOperation]) { // for each operation of the class
//                var objNo = -1
//                for (obj : lastState.contents.filter[it.eClass.name == c.name])
//                { // for each object of class
//                    objNo++
//                    val varmap = new HashMap<String, EObject>
//                    varmap.put("self", obj)
//                    val pseudoState = generateAndAddPseudoState
//                    (
//                        model,
//                        bounds,
//                        pseudoStateName,
//                        operationId
//                    ) as StateResource
//                    states += pseudoState
//                    /* Add one Bitvector as ALPHA variables for each class, each bit represents the
//                     *(none-)existence of an object of the corresponding class
//                     */
//                    if (useAlpha)
//                    {
//                        if (oneObjectPerClass)
//                        {
//                            val opID = operationId
//                            for (c1 : model.getEClassifiers.map[it as EClass]) {
//                                if(!(c1.abstract))
//                                {
//                                    val alphaVar = factory.createBitvector => [
//                                        name =  model.name + "::" +pseudoStateName+opID+"::" + c1.name + "::alpha"
//                                        width = pseudoState.contents.filter[it.eClass.name == c1.name].length
//                                    ]
//                                    instance.variables += alphaVar
//                                    instance.assertions += factory.createCardGeExpression=> [
//                                        k = 1
//                                        expressions += newVariableExpression(alphaVar)
//                                    ]
//                                    instance.assertions.last.name = "at-least-one-object-per-class"
//                                }
//                            }
//                        }
//                        else
//                        {
//                            val bigCard = factory.createCardGeExpression=> [
//                                k = 1
//                            ]
//                            val opID = operationId
//                            for (c1 : model.getEClassifiers.map[it as EClass]) {
//                                if(!(c1.abstract))
//                                {
//                                    val alphaVar = factory.createBitvector => [
//                                        name =  model.name + "::" +pseudoStateName+opID+"::" + c1.name + "::alpha"
//                                        width = pseudoState.contents.filter[it.eClass.name == c1.name].length
//                                    ]
//                                    instance.variables += alphaVar
//                                    bigCard.expressions += newVariableExpression(alphaVar)
//                                }
//                            }
//                            bigCard.name = "at-least-one-object-of-any-class"
//                            instance.assertions += bigCard
//                        }
//                    }
//                    utils.encodeAttributes(instance, pseudoState)
//
//                    // Building invariant constraints for post-failure constraints
//                    // There are so many Expression because it makes much easier to read the
//                    //   sent smt-clauses while debugging or checking the OCL constraints
//                    val preOrPostFailConstraint = factory.createOrExpression
//                    val preFailConstraint       = factory.createOrExpression
//                    val postFailConstraint      = factory.createAndExpression
//                    val postFailConstraintPart1 = factory.createAndExpression // pre valid 
//                    val postFailConstraintPart2 = factory.createAndExpression // post 'valid'
//                    val postFailConstraintPart3 = factory.createOrExpression; // at least one invariant does not hold
//
//                    // Parameter handling
//                    if (op.getEParameters.size > 0)
//                    {
//                        encodeParameters
//                        (
//                            instance,
//                            c,
//                            op,
//                            sequence,
//                            varmap,
//                            parameterVariables,
//                            obj as StateObject,
//                            lastStateNumber
//                        )
//                    }
//
//                    // Conjunction for pre-conditions
//                    for (pre : prePostInv.getOperationConstraints("precondition", op)) {
//                        val tmp = utils.encodePreCondition(instance, lastState as StateResource, pre, varmap)
//                        preFailConstraint.expressions += factory.createNotExpression => [
//                            expr = tmp
//                        ]
//                        postFailConstraintPart1.expressions += tmp
//                    }
//
//                    // Conjunction for post-conditions
//                    val visitor = new de.agra.emf.modelfinder.encoding.VariableExpressionVisitor() 
//                    for (post : prePostInv.getOperationConstraints("postcondition", op)) {
////                        val nextState = pseudoState as StateResource
//                        pseudoState.preState = lastState as StateResource
//                        val objectNext = findObjectInPseudoState(pseudoState, obj, pseudoStateName, operationId)
//                        varmap.put("self", objectNext)
//                        val tmp = utils.encodePostCondition(instance, pseudoState, post, varmap)
//                        visitor.visit( tmp )
//                        postFailConstraintPart2.expressions += tmp
//                    }
//
//                    visitor.visitedVariables += parameterVariables
//
//                    postProcessingForVisitor(pseudoState,visitor)
//
//                    // prohibit changes in all non-touched variables
//                    val variablesOfLastState = getAllVariablesOfState("state", lastStateNumber, instance)
//                    for ( variable : getAllVariablesOfState(pseudoStateName, operationId, instance) ) {
//                        if ( ! visitor.visitedVariables.contains( variable.name ) ) {
//                            val stateSep = variable.name.split("::")
//                            stateSep.set(1, "state" + lastStateNumber)
//                            val variableInLastState = variablesOfLastState.findFirst[it.name == stateSep.join("::")]
//                            postFailConstraintPart2.expressions += factory.createEqualsExpression => [
//                                lhs = variableExpression( variable )
//                                rhs = variableExpression( variableInLastState )
//                            ]
//                        }
//                    }
//
//                    // Conjunction for invariant conflict with post-conditions
//                    for (inv : prePostInv.filter[it.stereotype == "invariant"] ) {
//                        for (clause : utils.encodeInvariant(instance, pseudoState, inv) ) {
//                             postFailConstraintPart3.expressions += factory.createNotExpression => [
//                                expr = clause as Expression
//                            ]
//                        }
//                    }
//
//                    if(!preFailConstraint.expressions.empty)
//                        preOrPostFailConstraint.expressions += preFailConstraint;
//
//                    if(!postFailConstraintPart1.expressions.empty)
//                        postFailConstraint.expressions += postFailConstraintPart1;
//
//                    if(!postFailConstraintPart2.expressions.empty)
//                        postFailConstraint.expressions += postFailConstraintPart2;
//
//                    if(!postFailConstraintPart3.expressions.empty)
//                        postFailConstraint.expressions += postFailConstraintPart3;
//
//                    if(!postFailConstraint.expressions.empty)
//                        preOrPostFailConstraint.expressions += postFailConstraint;
//
//
//                    if (!preOrPostFailConstraint.expressions.empty)
//                    {
//                        instance.assertions += preOrPostFailConstraint
//                    }
//
//                    operationId++
//                }
//            }
//        }
//        sequence.states = states
//    }
//
//    static def private void extendDynamicInstanceWithExecutabilityAnywhereHelper
//    (
//        Instance instance,
//        StateSequence statesequence,
////        List<Resource> states,
//        List<Constraint> prePostInv,
////        EOperation operation,
//        Pair<String,String> operationName
//    )
//    {
//        val model = statesequence.model
//        val List<EClass> possibleEClasses = model.getEClassifiers.map[it as EClass]
//        val stateHead = statesequence.states.head as StateResource
//        /* Add constraints such that at least one omega variable represents the given operation */
//        // 1. Step: Make a set of all valid operationIds
//        val Set<Integer> validOperationIds = new HashSet<Integer>
//
//        var operationId = 0 // id for the operation call
//        // for each class in the model
//        for (c : possibleEClasses)
//        {
//            val possibleObjects = stateHead.allObjectsOfType(c)
//            // for each operation of the class
//            for (op : c.getEOperations)
//            {
//                // for each object of class
//                for (obj : possibleObjects)
//                {
//                    if (    operationName.key == c.name
//                         && operationName.value == op.name)
//                    {
//                        validOperationIds.add(operationId)
//                    }
//                    operationId = operationId + 1
//                }
//            }
//        }
//
//        if ( validOperationIds.size == 0 ) {
//            println( "There are no valid operation ids for the operation \'"+operationName.key+"::"+operationName.value+"\' so that no clauses will be added!" )
//            return;
//        }
//
//        // 2. Step: Create OrExpressions over all omega variables for each valid operation which should be called at least once
//        val overAllOmegaConstraint = factory.createOrExpression
//        val omegaVars = instance.variables
//                                .filter[    it.name.startsWith("omega")
//                                         && (!it.name.contains("::"))]
//                                .map[it as Bitvector]
//        for (omega : omegaVars)
//        {
//            val omegaConstraint = factory.createOrExpression
//            for ( validOperationId :  validOperationIds ) {
//                omegaConstraint.expressions += factory.createEqualsExpression => [
//                        lhs = variableExpression( omega )
//                        rhs = constIntegerExpression(validOperationId, omega.width)
//                ]
//            }
//            overAllOmegaConstraint.expressions += omegaConstraint
//        }
//        instance.assertions += overAllOmegaConstraint
//    }
//
//    static def void extendDynamicInstanceWithExecutabilityAnywhere
//    (
//        Instance instance,
//        StateSequence statesequence,
//        List<Constraint> prePostInv,
////        EOperation operation,
//        Set<Pair<String,String>> operationName,
//        OperationCallsDetermination ops
//    )
//    {
//        if (ops.numberOfOperationCalls == 0) {
//            println(  "There is are operations which implies that applying\n"
//                    + "\'ExecutabilityAnywhere\' does not make any sense!")
//            return;
//        }
//        val states = statesequence.states
//        if (states == null) {
//            println(  "The given state reference is NULL!")
//            return;
//        }
//        if (operationName.size == 0) {
//            println(  "The set of executing operations is empty! Thus applying the\n"
//                    + " \'ExecutabilityAnywhere\' method does not make any sense!")
//            return;
//        }
//        /* Add constraints such that at least one omega variable represents the given operation */
//        for ( op : operationName ) {
//            instance.extendDynamicInstanceWithExecutabilityAnywhereHelper
//            (
//                statesequence,
//                prePostInv,
//                op
//            )
//        }
//    }
//
//
//    static def private void extendDynamicInstanceWithExecutabilityLastStateHelper(
//        Instance instance,
//        StateSequence sequence,
//        int helpingStateNo,
//        int lastStateNumber,
//        StateResource lastState,
//        List<Constraint> prePostInv,
////        EOperation operation,
//        Pair<String,String> operation,
//        Bounds bounds
//    )
//    {
//        val model = sequence.model
//        /* Add constraints such that the last state is in a deadlock */
//        val String helpStateName = "HELPING-state"
//
//        /* Pre- and post-conditions combined by omega variables */
//        // 1. Determine the number of operation calls from model and state 
//        //    Beware the number of objects for the operation must be calculated! 
//        val numOpCalls = model.calculateNumberOfOperationCalls(sequence.states)
//
//        // 2. Create k-1 omega variables of appropriate bit-size (k = states.size)
////        val omegaWidth = numOpCalls.bitwidth
////        val omega = createAndAddOmega("omega" + "For" + helpStateName + helpingStateNo,omegaWidth,numOpCalls,instance)
//
//        val helpingState = generateAndAddPseudoState
//        (
//            model,
//            bounds,
//            helpStateName,
//            helpingStateNo
//        ) as StateResource
//        sequence.states += helpingState
//
//        encodeBasisForState(
//            helpingState,
//            model,
//            helpingStateNo,
//            prePostInv,
//            instance
//        )
//
//        var operationId = 0
//        val op =  ((model.getEClassifiers.filter[it.name == operation.key].head) as EClass)
//                 .getEAllOperations.filter[it.name == operation.value].head
//
//        // 3. Combine with pre and post conditions (pseudo code)
//        for (obj : sequence.states.get(lastStateNumber).contents
//                           .filter[it.eClass.name == operation.key]) { // for each object of the class of the operation
//
//            val preAnd = factory.createAndExpression
//            // Conjunction for pre-conditions
//            for (pre : prePostInv.getOperationConstraints("precondition", op)) {
//                preAnd.expressions += utils.encodePreCondition(instance, lastState, pre, #{"self" -> obj})
//            }
//
//            val postAnd = factory.createAndExpression
//            // Conjunction for post-conditions
//            val visitor = new de.agra.emf.modelfinder.encoding.VariableExpressionVisitor()
//            for (post : prePostInv.getOperationConstraints("postcondition", op)) {
//                val nextState = helpingState as StateResource
//                nextState.preState = lastState as StateResource
//                val objectNext = findObjectInPseudoState(nextState, obj, helpStateName, helpingStateNo)
//                val tmp = utils.encodePostCondition(instance, nextState, post, #{"self" -> objectNext})
//                postAnd.expressions += tmp
//                try{
//                    visitor.visit( tmp )
//                } catch (Exception e) {
//                    println("")
//                }
//            }
//
//            val equalAnd = factory.createAndExpression
//            // prohibit changes in all non-touched variables
//            val variablesOfLastState = getAllVariablesOfState("state", lastStateNumber, instance)
//            for ( variable : getAllVariablesOfState(helpStateName, helpingStateNo, instance) ) {
//                if ( ! visitor.visitedVariables.contains( variable.name ) ) {
//                    val stateSep = variable.name.split("::")
//                    stateSep.set(1, "state" + lastStateNumber)
//                    val variableInLastState = variablesOfLastState.findFirst[it.name == stateSep.join("::")]
//                    if (variableInLastState == null) {
//                        println( stateSep.join("::") + " <=> variableInLastState is NULL")
//                    }
//                    equalAnd.expressions += factory.createEqualsExpression => [
//                        lhs = variableExpression( variable )
//                        rhs = variableExpression( variableInLastState )
//                    ]
//                }
//            }
//
//            // Equal expression for omega
//            // After added equals-clauses for all non-touched variables it could be no more possible
//            // that prePostAnd.expressions is empty
//            if (!(preAnd.expressions.empty && postAnd.expressions.empty && equalAnd.expressions.empty)) {
//                val result = factory.createAndExpression
//                if (preAnd.expressions.empty)
//                    result.expressions += newConstBooleanExpression(true)
//                else
//                    result.expressions += preAnd
//                result.expressions.last.name = "preconditions"
//
//                if (postAnd.expressions.empty)
//                    result.expressions += newConstBooleanExpression(true)
//                else
//                    result.expressions += postAnd
//                result.expressions.last.name = "postconditions"
//
//                if (equalAnd.expressions.empty)
//                    result.expressions += newConstBooleanExpression(true)
//                else
//                    result.expressions += equalAnd
//                result.expressions.last.name = "frameconditions"
//
//                instance.assertions += result
//            }
//            operationId = operationId + 1
//        }
//    }
//
//    static def void extendDynamicInstanceWithExecutabilityLastState
//    (
//        Instance instance,
//        StateSequence sequence,
//        List<Constraint> prePostInv,
////        EOperation operations,
//        Set<Pair<String,String>> operations,
//        Bounds bounds,
//        OperationCallsDetermination ops
//    )
//    {
//        if (sequence == null) {
//            println(  "The given sequence reference is NULL!")
//            return;
//        }
//        if (operations.size == 0) {
//            println(  "The set of executing operations is empty! Thus applying the\n"
//                    + " \'ExecutabilityLastState\' method does not make any sense!")
//            return;
//        }
//        /* Add constraints such that at least one omega variable represents the given operation */
//        var helpStateNo = 0
//        val lastStateNumber = ops.numberOfOperationCalls
//        val lastState = sequence.states.get(lastStateNumber) as StateResource
//        for ( operation : operations ) {
//            instance.extendDynamicInstanceWithExecutabilityLastStateHelper
//            (
//                sequence,
//                helpStateNo,
//                lastStateNumber,
//                lastState,
//                prePostInv,
//                operation,
//                bounds
//            )
//            helpStateNo = helpStateNo + 1
//        }
//    }
//
//    static def calculateNumberOfOperationCalls(EPackage model, List<Resource> states) {
//        // TODO The number of object of the class which belongs to the operation can also be calculated from the bounds
//        model.getEClassifiers.map[ c |   c.eContents.filter[it.eClass.name == "EOperation"].size
//                                    * states.head.contents
//                                            .filter[(c as EClass).isSuperTypeOf(it.eClass)]
//                                            //.filter[it.eClass.name == c.name]
//                                            .size ]
//                          .fold(0, [a, b | a + b])
//    }
//
//    static def getOperationConstraints
//    (
//        List<Constraint> constraints,
//        String stereotype,
//        EOperation op
//    )
//    {
//        val EClass classOfOperation = op.eContainer as EClass
//        constraints.filter[
//                       val contextVariable = it.specification.contextVariable as VariableImpl
//                       val classOfContextVariable = contextVariable.getEGenericType.getEClassifier as EClass
//                          classOfContextVariable.name == classOfOperation.name
//                       && it.stereotype == stereotype
//                       &&    ((it as ConstraintImpl).constrainedElements.head as EOperationImpl).name
//                          == op.name
//                   ]
//    }
//
//    static def findObjectInNextState
//    (
//        StateResource resource,
//        EObject object
//    )
//    {
//        val stateSep = object.toString.split("::")
//        val stateIndex = Integer::parseInt(stateSep.get(1).substring(5))
//        stateSep.set(1, "state" + (stateIndex + 1))
//        resource.allObjects.findFirst[it.name == stateSep.join("::")]
//    }
//
//    static def findObjectInPseudoState
//    (
//        StateResource resource,
//        EObject object,
//        String stateNameString,
//        int stateIndex
//    )
//    {
//        val stateSep = object.toString.split("::")
//        stateSep.set(1, stateNameString + stateIndex)
//        resource.contents.findFirst[it.toString == stateSep.join("::")]
//    }
//
//    static def extendDynamicInstanceWithStateTemp(Resource state, Instance instance) {
//        for (obj : state.contents) {
//            for (attr : obj.eClass.getEAllAttributes) {
//                
//            }
//        }
//    }
//
//    static def getAllVariablesOfState( String stateName, int stateNo, Instance instance) {
//        instance.variables.filter[    it.name.contains( "::")
//                                   && it.name.split("::").get(1) == stateName + stateNo]
//    }
//
//    static def private void postProcessingForVisitor(Resource state, de.agra.emf.modelfinder.encoding.VariableExpressionVisitor visitor){
//
//        val Set<String> moreVisitedVariables = new HashSet<String>
//
//        for (obj2 : state.contents.map[it as StateObject]) { // for each object of class
//            for (property : obj2.eClass.getEAllStructuralFeatures) {
//                val name = obj2.name + "::" + property.name
//
//                if (visitor.visitedVariables.contains( name )) {
//                    switch(property) {
//                        EAttribute: {
//                        }
//                        EReference: {
//                            val refe = property as EReference
//                            //println(" is reference, have to do post-processing. counterpart: "+refe.EOpposite.name
//                            //    +" of class "+refe.EType.name)
//                            for(obj3 : state.contents
//                                            .map[it as StateObject]
//                                            .filter[it.eClass.name == refe.getEType.name]) {
//                                //println("found object: "+obj3.name)
//                                if (refe.getEOpposite != null )
//                                {
//                                    moreVisitedVariables += obj3.name + "::" + refe.getEOpposite.name
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//
//        visitor.visitedVariables += moreVisitedVariables
//    }
//
//    static def void extendInstanceWithSpecificOCLConstraint
//    (
//        Instance instance,
//        StateSequence sequence,
//        List<Constraint> additionalConstraints,
//        Set<Integer> objectIndices,
//        Set<Integer> stateIndices
//    )
//    {
//        if (stateIndices == null)
//        {
//            System.err.println("stateIndices is NULL")
//            return;
//        }
//        if (objectIndices == null)
//        {
//            System.err.println("objectIndices is NULL")
//            return;
//        }
//        if (additionalConstraints == null)
//        {
//            System.err.println("additionalConstraints is NULL")
//            return;
//        }
//        if (stateIndices.empty)
//        {
//            System.err.println("stateIndices is empty")
//            return;
//        }
//        if (objectIndices.empty)
//        {
//            System.err.println("objectIndices is empty")
//            return;
//        }
//        if (additionalConstraints.empty)
//        {
//            System.err.println("additionalConstraints is empty")
//            return;
//        }
//        // check if all invariant are for the smae class
//        val eClass = (additionalConstraints.head).context as EClass
//        val invIt = additionalConstraints.iterator
//        while (invIt.hasNext)
//        {
//            val cInv = invIt.next
//            if (eClass.equals( (cInv.context) as EClass ) )
//            {
//                System.err.println("Not all invariant are for the same EClass! Stopping now!")
//                return;
//            }
//        }
//        val Set<String> objectNames = new HashSet<String>()
//        val String objectBaseName = eClass.name
//        for(idx : objectIndices)
//        {
//           objectNames.add(objectBaseName+"@"+idx)
//        }
//        // TODO merge with patrick changes for the StateResource instead of the contains index
//        val catchedStates = new ArrayList<StateResource>;
//        sequence.states.forEach[obj, index |
//            if (stateIndices.contains(index))
//                catchedStates += obj as StateResource
////            stateNames.contains((it as StateResource).name)
//        ]
//        if (catchedStates.empty)
//        {
//            System.err.println("WARNING: No state found!")
//            return;
//        }
//        var List<Expression> result = new ArrayList<Expression>();
//        for(state : catchedStates)
//        {
//            val objects = state.allObjectsOfType(eClass)
//            val chatchedObjects = objects.filter[objectNames.contains(it.name.split("::").get(2))]
//            for(invariant : additionalConstraints)
//            {
//                for(object : chatchedObjects)
//                {
//                    val sObject = object as StateObject
//                    val Map<String, EObject> varMap = new HashMap<String, EObject>
//                    varMap.put("self", sObject)
//                    result.add(
//                        encodeAlpha(
//                            instance,
//                            sObject.toString,
//                            encodeExpression(
//                                instance,
//                                state,
//                                invariant.bodyExpression,
//                                varMap
//                            ),
//                            '1'
//                        )
//                    )
//                }
//            }
//        }
//        instance.assertions += result.newAndExpression
//    }
}