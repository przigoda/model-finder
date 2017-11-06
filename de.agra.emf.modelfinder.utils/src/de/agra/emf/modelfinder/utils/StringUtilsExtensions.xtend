package de.agra.emf.modelfinder.utils

class StringUtilsExtensions {
    static val utils = new StringUtilsImpl

    static def String reverse(String s)
    {
        val StringBuffer a = new StringBuffer(s);
        a.reverse().toString
    }

    static def String constString (String s, int length) {
        (0..<length).map[s].join("")
    }
    static def String replaceCharAt (String s, char c, int pos) {
        utils.replaceCharAt(s, c, pos)
    }
    static def String switch01 (String s, int pos) {
        if (s.charAt(pos).toString == "0") {
            utils.replaceCharAt(s,'1',pos)
        } else if (s.charAt(pos).toString == "1") {
            utils.replaceCharAt(s,'0',pos)
        } else {
            s
        }
    }

    def public static String fillWithZeroes
    (
        String string,
        Integer bitWidth
    )
    {
        val zeroes = "0".constString(bitWidth - string.length)
        return zeroes + string
    }

    static def String incStateNo(String s) {
        val stateNoAsInt = Integer.parseInt(s.substring(5)) + 1
        "state"+stateNoAsInt
    }
    static def String decStateNo(String s) {
        val stateNoAsInt = Integer.parseInt(s.substring(5)) - 1
        "state"+stateNoAsInt
    }
    static def String incStateNoInVariableName(String s) {
        val split = s.split("::")
        split.set(1, split.get(1).incStateNo)
        return split.join("::")
    }
    static def String decStateNoInVariableName(String s) {
        val split = s.split("::")
        split.set(1, split.get(1).decStateNo)
        return split.join("::")
    }

    /**
     * Returnes the given string filled from the front with the given fillChar
     * until it has reached the given length.<br>
     * If the given length is smaller or equal to the length of the original
     * string, nothing happens and the original string is returned.
     */
    static def String fillString(String string, int length, char fillChar) {
        var String result = string
        while(result.length < length) {
            result = fillChar+result
        }
        return result;
    }
}