package de.agra.emf.modelfinder.statesequence

import com.google.common.base.Optional
import de.agra.emf.modelfinder.statesequence.bounds.Bounds
import de.agra.emf.modelfinder.statesequence.determination.OperationCallsDetermination
import de.agra.emf.modelfinder.statesequence.state.StateObject
import de.agra.emf.modelfinder.statesequence.utils.BoundUtils
import de.agra.emf.modelfinder.statesequence.utils.BoundUtilsImpl
import java.util.ArrayList
import java.util.HashMap
import java.util.List
import java.util.Map
import org.eclipse.emf.common.util.BasicEList
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl

import static extension com.google.common.base.Preconditions.*
import static extension de.agra.emf.modelfinder.statesequence.utils.EcoreExtensions.*

/**
 * This class handles the creation of system states
 * for a given package and different configuration
 * objects.
 */
class StateSequenceGenerator {

    private static ResourceSet resourceSet = new ResourceSetImpl
    private static BoundUtils boundUtils = new BoundUtilsImpl

    def public static Optional<String> checkForMFflag
    (
        EStructuralFeature property,
        String keyName
    )
    {
        property.checkNotNull("property may not be null")
        keyName.checkNotNull("keyName may not be null")
        val mfAnnotations = property.EAnnotations.findFirst[it.source.equals("ModelFinder")]
        if (mfAnnotations == null)
        {
            return Optional.absent;
        }
        val mfFlag = mfAnnotations.details.findFirst[it.key.equals(keyName)]
        if (mfFlag == null)
        {
            return Optional.absent;
        }
        return Optional.of(mfFlag.value)
    }

    /**
     * Generates system states based on bounds
     *
     * @param bounds Bounds to consider
     * @return List of system states
     */
    static def StateSequence generateStateSequence
    (
        Resource groundSetting,
        EPackage model,
        Bounds bounds,
        OperationCallsDetermination operationCalls
    )
    {
        /*
         * Make a copy of the references of the objects in the GSP resource
         * which has the same order as the objects in the states in the sequence
         */
        val List<EObject> orderedGSrefs = new ArrayList<EObject>
        model.EClassifiers
             .filter[it instanceof EClass]
             .map[it as EClass]
             .filter[!it.isAbstract]
             .forEach[ eClass |
                orderedGSrefs += groundSetting.contents.filter[it.eClass.equals(eClass)]
        ]

        resourceSet.resourceFactoryRegistry.extensionToFactoryMap.put("ecore", new ResourceFactoryImpl)
        val StateSequence sequence = new StateSequenceImpl(model)

        val Map<EClass,Boolean> containGSPmap = new HashMap
        val Map<EStructuralFeature,Boolean> propertyGSPmap = new HashMap

        for (t : 0..operationCalls.numberOfOperationCalls)
        {
            val resource = resourceSet.createResource(URI::createURI("state.ecore"))

            model.EClassifiers
                 .filter[it instanceof EClass]
                 .map[it as EClass]
                 .filter[!it.isAbstract]
                 .forEach[ eClass |
                if (t == 0)
                {
                    eClass.EAllStructuralFeatures
                          .forEach[ eStruct |
                              if (!propertyGSPmap.containsKey(eStruct))
                              {
                                  val checkGSP = eStruct.checkForMFflag("groundSettingProperty")
                                  if (   checkGSP.present
                                      && checkGSP.get.toLowerCase.equals("true") )
                                  {
                                      propertyGSPmap.put(eStruct, true)
                                      containGSPmap.put(eClass, true)
                                  }
                                  else
                                  {
                                      propertyGSPmap.put(eStruct, false)
                                      if (!containGSPmap.containsKey(eClass))
                                      {
                                          containGSPmap.put(eClass, false)
                                      }
                                  }
                              }
                          ]
                }
                val upperBound = boundUtils.getUpperBound(model, bounds, eClass)
                if (upperBound > 0)
                {
                    for (i : 0 ..< upperBound)
                    {
                        val obj = new StateObject(eClass)
                        obj.name = model.name + "::" + "state" + t + "::" + eClass.name + "@" + i
                        resource.contents += obj
                    }
                }
            ]
            val Map<EClass,Integer> eObjectCountingMap = new HashMap
            resource.contents.forEach[ eObject |
                val eClass = eObject.eClass
                var tmp = 0
                if (eObjectCountingMap.containsKey(eClass))
                {
                    tmp = eObjectCountingMap.get(eClass)
                }
                val objectNo = tmp
                if (   containGSPmap.containsKey(eClass)
                    && containGSPmap.get(eClass)
                )
                {
                    // val possibleObjectsInGS = groundSetting.contents.filter[it.eClass.equals(eClass)]
                    val possibleObjectsInGS = orderedGSrefs.filter[it.eClass.equals(eClass)]
                    eClass.EAllStructuralFeatures
                          .forEach[ eStruct |
                              if (propertyGSPmap.get(eStruct))
                              {
                                  val gsEObject = possibleObjectsInGS.get(objectNo)
                                  val value = gsEObject.eGet(eStruct)
                                  if (eStruct instanceof EAttribute)
                                  {
                                      eObject.eSet(eStruct, value)
                                  }
                                  else if (eStruct instanceof EReference)
                                  {
                                      if (value == null)
                                      {
                                          eObject.eSet
                                          (
                                              eStruct,
                                              null
                                          )
                                      }
                                      else
                                      {
                                          val tValue = value.transform
                                          (
                                              eStruct,
//                                              groundSetting,
                                              orderedGSrefs,
                                              resource
                                          )
                                          eObject.eSet
                                          (
                                              eStruct,
                                              tValue
                                          )
                                      }
                                  }
                              }
                          ]
                }
                eObjectCountingMap.put(eClass, objectNo + 1)
            ]
            sequence.states += resource
        }
        if (groundSetting.contents.length != sequence.states.head.contents.length)
        {
            System.err.println
            (
                  "###\n"
                + "# The number of objects in the given system for the ground setting property\n"
                + "# values and the numbers of objects in the system state derived from the bounds\n"
                + "# are different, this can maybe cause problems.\n"
                + "###"
            )
        }
        sequence.states.head.contents.forEach[
            val obj = it as StateObject
            obj.allAttributes.forEach[
                sequence.modelElements += obj -> it as EStructuralFeature
            ]
            obj.allReferences.forEach[
                sequence.modelElements += obj -> it as EStructuralFeature
            ]
        ]
        sequence
    }

    def private static Object transform
    (
        Object object,
        EReference eStruct,
//        Resource groundSetting,
        List<EObject> orderedGSrefs,
        Resource resource
    )
    {
        val eClassOfRef = eStruct.EType as EClass
        /*
        isSuperTypeOf
          Parameters:
            someClass some other class.
          Returns:
            whether this class is the same as, or a super type of, some other class.
         */
//        val pOiGS = groundSetting.contents.filter[eClassOfRef.isSuperTypeOf(it.eClass)]
        val pOiGS = orderedGSrefs.filter[eClassOfRef.isSuperTypeOf(it.eClass)]
        val pOiSR = resource.contents.filter[eClassOfRef.isSuperTypeOf(it.eClass)]
        if (pOiGS.length != pOiSR.length)
        {
            System.err.println
            (
                "The possible number of object in the ground setting system state to be created\n"
                + "system states differs, this can cause problem for the reference " + eStruct.name
            )
        }
        if (object instanceof EObject)
        {
            val indexInGS = pOiGS.indexOf(object)
            try{
                return pOiSR.get(indexInGS)
            } catch (Exception e) {
                return null
            }
        }
        else if (object instanceof EList)
        {
            val EList tObject = new BasicEList
            object.forEach[
                var indexInGS = pOiGS.indexOf(it)
                tObject += pOiSR.get(indexInGS)
            ]
            return tObject
        }
        throw new UnsupportedOperationException
    }

    def public static int indexOf
    (
        Iterable objects,
        Object object
    )
    {
        val objectsIt = objects.iterator
        var counter = 0
        while (objectsIt.hasNext)
        {
            val refObj = objectsIt.next
            if (refObj.equals(object))
            {
                return counter
            }
            counter++
        }
        return -1
    }

    /**
     * Generates system states based on bounds
     *
     * @param bounds Bounds to consider
     * @return List of system states
     */
    static def StateSequence generateStateSequence
    (
        EPackage model,
        Bounds bounds,
        OperationCallsDetermination operationCalls
    )
    {
        resourceSet.resourceFactoryRegistry.extensionToFactoryMap.put("ecore", new ResourceFactoryImpl)
        val StateSequence sequence = new StateSequenceImpl(model)

        for (t : 0..operationCalls.numberOfOperationCalls)
        {

            val resource = resourceSet.createResource(URI::createURI("state.ecore"))

            model.EClassifiers
                 .filter[it instanceof EClass]
                 .map[it as EClass]
                 .filter[!it.isAbstract]
                 .forEach[cls |
                val upperBound = boundUtils.getUpperBound(model, bounds, cls)
                if (upperBound > 0)
                {
                    for (i : 0 ..< upperBound) {
                        val obj = new StateObject(cls)
                        obj.name = model.name + "::" + "state" + t + "::" + cls.name + "@" + i
                        resource.contents += obj
                    }
                }
            ]
            sequence.states += resource
        }
        sequence.states.head.contents.forEach[
            val obj = it as StateObject
            obj.allAttributes.forEach[
                sequence.modelElements += obj -> it as EStructuralFeature
            ]
            obj.allReferences.forEach[
                sequence.modelElements += obj -> it as EStructuralFeature
            ]
        ]

        sequence
    }

    static def Resource generateAndAddPseudoState
    (
        EPackage model,
        Bounds bounds,
        String stateName,
        int StateNumber
    )
    {
        val resource = resourceSet.createResource(URI::createURI("state.ecore"))

        model.EClassifiers
             .filter[it instanceof EClass]
             .map[it as EClass]
             .filter[!it.isAbstract]
             .forEach[cls |
            val upperBound = boundUtils.getUpperBound(model, bounds, cls)
            if (upperBound > 0)
            {
                for (i : 0 ..< upperBound) {
                    val obj = new StateObject(cls)
                    obj.name = model.name + "::" + stateName + StateNumber + "::" + cls.name + "@" + i
                    resource.contents += obj
                }
            }
        ]
        resource
    }
}