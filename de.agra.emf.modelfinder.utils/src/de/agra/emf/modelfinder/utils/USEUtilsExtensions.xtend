package de.agra.emf.modelfinder.utils

import de.agra.emf.modelfinder.use2ecore.USELexer
import de.agra.emf.modelfinder.use2ecore.USEParser
import java.io.File
import java.io.FileOutputStream
import java.io.FileReader
import java.io.FileWriter
import java.util.Collections
import org.antlr.v4.runtime.ANTLRInputStream
import org.antlr.v4.runtime.CommonTokenStream
import org.antlr.v4.runtime.TokenStream
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl

class USEUtilsExtensions {
    public static def void generateEcoreFileFromUSEFile
    (
        String useFile,
        String ecoreFile,
        String oclFile
    )
    {

        val FileReader useReader = new FileReader(useFile)
        val ANTLRInputStream input = new ANTLRInputStream(useReader)
        val USELexer lexer = new USELexer( input )
        // Get a list of matched tokens
        val TokenStream tokens = new CommonTokenStream( lexer );
        // Pass the tokens to the parser
        val USEParser parser = new USEParser(tokens);
        val EPackage pkg = parser.spec().pkg;

        if (pkg == null) {
            println( "Readed pkg == NULL" );
        } else {
            val ResourceSet resourceSet = new ResourceSetImpl()
            resourceSet.resourceFactoryRegistry.extensionToFactoryMap.put("ecore", new XMIResourceFactoryImpl)
            resourceSet.resourceFactoryRegistry.extensionToFactoryMap.put("xmi", new XMIResourceFactoryImpl)
            val URI fileUri = URI.createFileURI(ecoreFile)
            val Resource resource = resourceSet.createResource(fileUri)
            if (resource != null) {
                if (resource.getContents() != null) {
                    resource.getContents().add(pkg)
                    resource.save(new FileOutputStream(ecoreFile), Collections::EMPTY_MAP)
                    println("Saved the generated EPackage (derived from the use file \'"
                        +useFile+"\') in the ecore file: \'"+ecoreFile+"\'")
                }
            }
        }
        // TODO files exists...
//        val File file = new File(oclFile);
//        val FileWriter fw = new FileWriter(file, false);
//        fw.write(
//              "import "+pkg.name+" : '"+pkg.name+".ecore#/'\n\n"
//            + "package "+pkg.name+"\n\n"
//            + "...\n\n"
//            + "endpackage")
//        fw.close();
    }
}