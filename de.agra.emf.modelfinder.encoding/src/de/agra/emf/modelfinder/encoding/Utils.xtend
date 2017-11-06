package de.agra.emf.modelfinder.encoding

import org.eclipse.emf.ecore.EPackage
import java.util.List
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.EClass

class Utils {
    
    def static int calculateNumberOfOperationCalls
    (
        EPackage model,
        List<Resource> states
    )
    {
        // TODO The number of objects of the class which belongs to the operation can also be calculated from the bounds
        model.getEClassifiers
             .map[ _c |
                 val EClass c = _c as EClass
                   c.EAllOperations.size// .filter[it. eClass.name == "EOperation"].size
                 * states.head.contents
                         .filter[c.isSuperTypeOf(it.eClass)]
                         .size
             ].fold(0, [a, b | a + b])
    }
}