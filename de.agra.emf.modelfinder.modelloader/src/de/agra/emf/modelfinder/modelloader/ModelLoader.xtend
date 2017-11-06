package de.agra.emf.modelfinder.modelloader

import java.io.FileInputStream
import java.util.ArrayList
import java.util.List
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EClassifier
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
import org.eclipse.ocl.OCL
import org.eclipse.ocl.OCLInput
import org.eclipse.ocl.ecore.Constraint
import org.eclipse.ocl.ecore.EcoreEnvironmentFactory
import org.eclipse.xtend.lib.annotations.Accessors

class ModelLoader {
    val resourceSet = new ResourceSetImpl
    @Accessors val OCL<?, EClassifier, ?, ?, ?, ?, ?, ?, ?, Constraint, EClass, EObject> ocl

    /**
     * @brief Registers Ecore and XMI features in factory map
     */
    new() {
        resourceSet.resourceFactoryRegistry.extensionToFactoryMap.put("ecore", new XMIResourceFactoryImpl)
        resourceSet.resourceFactoryRegistry.extensionToFactoryMap.put("xmi", new XMIResourceFactoryImpl)
        ocl = OCL::newInstance(new EcoreEnvironmentFactory(resourceSet.packageRegistry))
    }

    /**
     * @brief Load a model from an Ecore and separate OCL file
     */
    def loadFromEcoreAndOCL(String ecoreFilename, String oclFilename) {
        val model = loadModel(ecoreFilename)
        val constraints = loadOCL(oclFilename)
        new ModelWithConstraints(model, constraints)
    }

    /**
     * @brief Load Ecore model without any OCL constraints
     */
    def loadFromEcore(String ecoreFilename) {
        val model = loadModel(ecoreFilename)
        new ModelWithConstraints(model, new ArrayList<Constraint>)
    }

    /**
     * @brief Load Ecore model that contains OCL constraints inside as
     *        annotations
     */
    def loadFromEcoreWithOCL(String ecoreFilename) {
        val model = loadModel(ecoreFilename)

        val constraints = new ArrayList<Constraint>
        val helper = ocl.createOCLHelper
        for (clazz : model.EClassifiers.filter[it instanceof EClass].map[it as EClass]) {
            val annotations = clazz.EAnnotations
            val ecoreAnnotation = annotations.findFirst[it.source == "http://www.eclipse.org/emf/2002/Ecore"]
            val pivotAnnotation = annotations.findFirst[it.source == "http://www.eclipse.org/emf/2002/Ecore/OCL/Pivot"]

            helper.setContext(clazz)
            val constraintNames = ecoreAnnotation.details.get("constraints").split(" ")
            for (name : constraintNames) {
                constraints += helper.createInvariant(pivotAnnotation.details.get(name))
            }
        }
        new ModelWithConstraints(model, constraints)
    }

    def loadState(String filename) {
        loadState(URI::createURI(filename))
    }

    def validate(Resource state, List<Constraint> constraints) {
        constraints.map[ocl.createQuery(it).check(state.contents)].reduce[p1, p2 | p1 || p2] ?: true
    }

    private def loadState(URI file) {
        resourceSet.getResource(file, true)
    }

    private def loadModel(String filename) {
        loadModel(URI::createURI(filename))
    }

    private def loadModel(URI file) {
        val resource = resourceSet.getResource(file, true)
        val pkg = resource.contents.get(0) as EPackage

        // register model for later OCL constraints
        resourceSet.packageRegistry.put(pkg.nsURI, pkg)
        pkg
    }

    private def loadOCL(String filename) {
        loadOCL(URI::createURI(filename))
    }

    private def loadOCL(URI file) {
        //val ocl = OCL::newInstance(new EcoreEnvironmentFactory(registry))
        // TODO check with OCL Test case
        val in = new FileInputStream(file.path)
        val document = new OCLInput(in)
        ocl.parse(document)
    }

    public def List<Constraint> loadExtraConstraintsFromOCLFile(String oclFilename) {
        val result = loadOCL(oclFilename)
        for(Constraint c : result) {
            if(!c.stereotype.equals("invariant")) {
                throw new Exception("The additional constraints loaded by "
                    +"\"loadExtraConstraintsFromOCLFile(...)\" are only allowed "
                    +"to be invariants, "+System.lineSeparator+"but a constraint of type "+c.stereotype+" "
                    +"has been found!")
            }
        }
        return result
    }
}