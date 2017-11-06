package de.agra.emf.modelfinder.encoding

import de.agra.emf.modelfinder.statesequence.state.StateResource
import org.eclipse.emf.ecore.EClass
import org.eclipse.ocl.expressions.CallExp
import org.eclipse.ocl.types.BagType
import org.eclipse.ocl.types.CollectionType
import org.eclipse.ocl.types.OrderedSetType
import org.eclipse.ocl.types.SequenceType
import org.eclipse.ocl.types.SetType
import static extension de.agra.emf.modelfinder.statesequence.utils.EcoreExtensions.*

class LoadParametersExtensions
{
    // width parameters 
    private static boolean widthFinalized = false
    private static int boolBitwidth = 1 // default value
    private static int intBitwidth  = 8 // default value
    private static int intSetBitwidth = Math.pow(2, intBitwidth) as int // default value

    static def void setBoolBitwidth(int width)
    {
        if (widthFinalized) {
            // Warning?
            System.err.print("The width is fixed after the first load")
        } else {
            boolBitwidth = width
        }
    }

    static def void setIntBitwidth(int width)
    {
        if (widthFinalized) {
            // Warning?
            System.err.print("The width is fixed after the first load")
        } else {
            if (width < 1)
            {
                System.err.print("The intBitwidth must be a positive integer")
            }
            else
            {
                intBitwidth = width
                intSetBitwidth = Math.pow(2, width) as int
            }
        }
    }

    static def int boolBitwidth()
    {
        widthFinalized = true
        boolBitwidth
    }

    static def int intBitwidth()
    {
        widthFinalized = true
        intBitwidth
    }

    static def int intSetBitwidth()
    {
        widthFinalized = true
        intSetBitwidth
    }

    static def int refBitwidth(
        StateResource state,
        CallExp<?> attribute
    )
    {
        val type = attribute.type
        switch (type) {
            EClass:
                state.allObjectsOfType(type).length
            CollectionType:{
                val tmp = type.elementType
                switch (tmp) {
                    EClass:{
                        val noOfInstantiations = state.allObjectsOfType(tmp).length
                        switch (type) {
                            SetType: {
                                return noOfInstantiations
                            }
                            OrderedSetType: {
                                return noOfInstantiations * noOfInstantiations
                            }
                            BagType: {
                                bagElementMaxFinalized = true
                                return noOfInstantiations * bagElementBitwidth
                            }
                            SequenceType: {
                                throw new IllegalArgumentException("LoadParametersExtensions::refBitwidth: CollectionType case\n"
                                + "attribute.type is an instance of SequenceType which is currently not supported.")
                            }
                        }
                    }
                    default:{
                        throw new IllegalArgumentException("LoadParametersExtensions::refBitwidth: case SetType\n"
                                + "type.elementType is not an instance of EClass:"+type.elementType.class)
                    }
                }
            }
            default: {
                throw new IllegalArgumentException("LoadParametersExtensions::refBitwidth: default case\n"
                        + "attribute.type is an instance of "+type.class)
            }
        }
    }
    private static boolean bagElementMaxFinalized = false
    private static int bagElementBitwidth = 4 // the value m makes 2^m 
    static def void setBagElementBitwidth(int width)
    {
        // todo bagElementBitwidth must be smaller than intBitwidth
        if (bagElementMaxFinalized) {
            // Warning?
            System.err.print("The bagElementBitwidth is fixed after the first load")
        } else {
            if (width < 2)
            {
                System.err.print("The bagElementBitwidth must be a positive integer bigger than 1\n"
                    + "For width=1 use a set instead of a bag.")
            }
            else
            {
                bagElementBitwidth = width
            }
        }
    }
    static def int bagElementBitwidth()
    {
        widthFinalized = true
        bagElementBitwidth
    }

    // alpha parameter
    private static boolean alphaFinalized = false
    private static boolean useAlpha = true
    static def void setUseAlpha (boolean _useAlpha)
    {
        if (alphaFinalized) {
            // Warning?
            System.err.println("The alpha parameter is fixed after the first load")
        } else {
            useAlpha = _useAlpha
        }
    }
    static def useAlpha()
    {
        alphaFinalized = true
        useAlpha
    }

    // one object per class in every state or one object of any class in every state
    private static boolean oneObjectPerClassFinalized = false
    private static boolean oneObjectPerClass = true
    /**
     * one object per class in every state or one object of any class in every state
     */
    static def void setOneObjectPerClass (boolean _oneObjectPerClass)
    {
        if (oneObjectPerClassFinalized) {
            // Warning?
            System.err.println("The oneObjectPerClass parameter is fixed after the first load")
        } else {
            oneObjectPerClass = _oneObjectPerClass
        }
    }
    /**
     * one object per class in every state or one object of any class in every state
     */
    static def oneObjectPerClass()
    {
        oneObjectPerClassFinalized = true
        oneObjectPerClass
    }

    /**
     * a parameter to configure if postconditions named modifies/Only should be used or the simple
     * visitor should be used
     */
    public enum FcOptions {
        explicitPostconditions,
        nothingElseChanges,
        modifyStatements
    }
    private static boolean fcOptionFinalized = false
    private static LoadParametersExtensions.FcOptions modifyOption = FcOptions::modifyStatements
    static def void setFcOption(LoadParametersExtensions.FcOptions _modifyOption)
    {
        if (fcOptionFinalized)
        {
            // Warning?
            System.err.println("The modifyOption parameter is fixed after the first load")
        }
        else
        {
            modifyOption = _modifyOption
        }
    }
    static def fcOption()
    {
        fcOptionFinalized = true
        modifyOption
    }

    // optimize constraints parameter
//    private static boolean optimizeFinalized = false
    private static boolean useOptimize = true 
    def public static void setUseOptimize (boolean _useOptimize)
    {
//        if (optimizeFinalized) {
//            // Warning?
//            System.err.println("The optimize parameter is fixed after the first load")
//        } else {
            useOptimize = _useOptimize
//        }
    }
    def public static useOptimize()
    {
//        optimizeFinalized = true
        useOptimize
    }
}