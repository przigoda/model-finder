package de.agra.emf.modelfinder.utils

import java.util.List

interface MathUtils {
    def List<?> combinations (List<?> list, int n)
    def List<?> powerSet (List<?> list)
}
