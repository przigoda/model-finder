package de.agra.emf.modelfinder.ui.utils


import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
import org.eclipse.emf.common.util.URI

class ResourceLoader {
    
    def static loadResource(String filename){
        val uri = URI::createURI(filename)
        val resourceSet = new ResourceSetImpl
        resourceSet.resourceFactoryRegistry.extensionToFactoryMap.put("ecore", new XMIResourceFactoryImpl)
        val resource = resourceSet.getResource(uri, true)
        resource.contents.get(0) as EPackage        
    }
}