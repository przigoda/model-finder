package de.agra.emf.modelfinder.utils

import java.util.ArrayList
import java.util.Collection
import java.util.List
import java.util.Set
import java.math.BigInteger
import javax.naming.OperationNotSupportedException

import static extension de.agra.emf.modelfinder.utils.StringUtilsExtensions.*

class MathUtilsExtensions {

    def static <T> List<List<T>> combinations
    (
        List<T> list,
        int n
    )
    {
        val List<List<T>> result = new ArrayList<List<T>>();
        powerSet(list).forEach [ subset |
            if (subset.length == n) {
                result += subset
            }
        ]
        return result
    }

    def static <T> List<List<T>> powerSet(List<T> list)
    {
        if (list.empty) {
            return #[ (#[]) as List<T> ] as List<List<T>>
        } else {
            val powerSet = powerSet(list.tail.toList)
            return union(
                powerSet,
                powerSet.map[subset|#[list.head].union(subset)]
            )
        }
    }

    static def int bitwidth(int i)
    {
        if (i <= 0) {
            throw new IllegalArgumentException("\"i <= 0\" passed to MathUtilsExtensions::bitwidthForList.")
        }
        if(i == 1) return 1
        Math.ceil(Math.log(i) / Math.log(2)) as int
    }

    static def int bitwidthForList(List<?> sequence)
    {
        if (sequence.length == 0) {
            throw new IllegalArgumentException("empty list passed to MathUtilsExtensions::bitwidthForList.")
        }
        bitwidth(sequence.length)
    }

    def public static String numberToBinaryString
    (
        Number n,
        Integer bitWidth
    )
    {
        return n.numberToBinaryString.fillWithZeroes(bitWidth)
    }

    static def String numberToBinaryString(Number n) {
        if(n instanceof BigInteger) {
            return (n as BigInteger).toString(2)
        } else if(n instanceof Integer) {
            return Integer.toBinaryString(n as Integer)
        } else {
            throw new OperationNotSupportedException(
                "The function numberToBinaryString(Number n) currently doesn't "
                +"support the type "+n.class+". Feel free to implement it!"
            )
        }
    }

    static def Collection u
    (
        Collection A,
        Collection B
    )
    {
        val C = A.clone
        C.addAll(B)
        switch A {
            Set: return C.toSet
            List: return C.toList
        }
    }

    static def List union
    (
        List<?> A,
        List<?> B
    )
    {
        // this would be much cooler with Collections
        val result = new ArrayList();
        result.addAll(A)
        result.addAll(B)
        return result
    }

    static def List intersection
    (
        List A,
        List B
    )
    {
        /* The following code snippet can cause problems because of
         * an thrown UnsupportedOperationException
        val Anew = A.clone
        Anew.retainAll(B)
         */
        val result = new ArrayList();
        result.addAll(A)
        result.retainAll(B)
        return result.toList
    }

    static def List setDifference
    (
        List A,
        List B
    )
    {
        /* The following code snippet can cause problems because of
         * an thrown UnsupportedOperationException
        A.clone.toArray
        Anew.removeAll(B.clone)
         */
        val result = new ArrayList();
        result.addAll(A)
        result.removeAll(B)
        return result.toList
    }
}