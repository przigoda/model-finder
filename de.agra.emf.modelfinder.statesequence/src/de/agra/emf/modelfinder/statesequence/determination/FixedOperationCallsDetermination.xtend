package de.agra.emf.modelfinder.statesequence.determination;

class FixedOperationCallsDetermination implements OperationCallsDetermination {
    private val int calls

    new () {
        this(1)
    }

    new (int calls) {
        this.calls = calls
    }

    override getNumberOfOperationCalls() {
        calls
    }
}