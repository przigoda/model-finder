package de.agra.emf.modelfinder.utils

class StringUtilsImpl implements StringUtils {
    override replaceCharAt (String s, char c, int pos) {
        if (pos >= s.length)
        {
            throw new IllegalArgumentException("StringUtils::replaceCharAt: pos >= s.length")
        }
        if (pos < 0)
        {
            throw new IllegalArgumentException("StringUtils::replaceCharAt: pos < 0")
        }
        s.subSequence(0, Math.max(0,pos)) + c.toString + s.subSequence(pos+1, s.length)
    }
}