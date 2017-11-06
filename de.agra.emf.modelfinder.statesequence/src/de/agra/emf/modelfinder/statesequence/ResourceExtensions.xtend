package de.agra.emf.modelfinder.statesequence

import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.resource.Resource
import de.agra.emf.modelfinder.statesequence.state.StateObject

class ResourceExtensions {
    def static assign
    (
        Resource target,
        Resource source,
        EPackage model
    )
    {
        model.getEClassifiers.map[it as EClass].forEach[ c |
            val filteredSource = source.contents.filter[it.eClass == c]
            val filteredTarget = target.contents.filter[it.eClass == c]
            checkForAssignment(filteredSource.size <= filteredTarget.size,
                  "Number of objects is to big, class: \'" + c.name + "\' "
                + filteredSource.size + " vs. " + filteredTarget.size)

            filteredSource.forEach[srcObj, i |
                val trgObj = filteredTarget.get(i)
                srcObj.eClass.getEAllAttributes.forEach[attr |
                    trgObj.eSet(attr, srcObj.eGet(attr))
                ]
            ]
        ]
    }

    def static assignObject
    (
        Resource target,
        String clsName,
        int objectNo,
        String attribute,
        Object value
    ) {
        val obj = target.contents.filter[   it.eClass.name == clsName
                                         && Integer::parseInt( ((it as StateObject).name as String).split("::").get(2)
                                                                                                   .split("@").get(1))
                                            == objectNo]
        checkForAssignment(obj.size == 1, "The number of found objects (with name '"+clsName+"@"+objectNo+"') is wrong: " + obj.size)

        val attr = obj.head.eClass.getEAllAttributes.filter[it.name == attribute]

        checkForAssignment(
            attr.size == 1,
              "The number of found attributes '"+ attribute +"' for object (with name '"+clsName+"@"+objectNo+"')\n"
            + "is wrong: " + attr.size + ". Maybe, it is a reference? Please check your model.")

        if (attr.head.defaultValue == value) {
            println(
                  "########################################\n"
                + "###############  WARNING ###############\n"
                + "########################################\n"
                + "Trying to assign the attribute "+ attribute +" of object " + clsName+"@"+objectNo + "\n"
                + "with the default value. Please add this constraint by hand to the instance!\n"
                + "########################################")
        }
        obj.head.eSet(attr.head,value)
    }

    private static def checkForAssignment(boolean expected, String message) {
        if (!expected) {
            throw new Exception(message)
        }
    }
}