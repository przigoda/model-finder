package de.agra.emf.modelfinder.applications.tikzexport

import de.agra.emf.modelfinder.statesequence.StateSequence
import de.agra.emf.modelfinder.statesequence.state.StateObject
import java.io.File
import java.io.FileWriter
import java.util.ArrayList
import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EReference

class TikZExport {
    public static def void generateTikZCode(String file, StateSequence sequence) {
        val File texFile = new File(file);
        if (!texFile.exists) {
            texFile.createNewFile
        }
        val FileWriter texWriter = new FileWriter(texFile, false);
        texWriter.write("\\newcommand{\\stateDist}{0}")
        sequence.states.forEach[ state, i |
            val stateName = (state.contents.head as StateObject).name.split("::").get(1)
            val listOfNodes = new ArrayList<String>()
            var lastClass = ""
            var shiftText = ""
            // Erzeuge scope Anfang etc:
            texWriter.write(
                "  % BEGIN "+stateName+"\n"+
                "  \\begin{scope}[shift={(\\stateDist,0)}]\n"+
                "    \\begin{scope}[start chain=going right,every node/.style={on chain,class with attributes},node distance=1cm]")
            for (obj : state.contents.map[it as StateObject]) {
                val splitted = obj.name.split("::")
                val objName = splitted.get(2)
                val nodeName = stateName + "-" + objName
                listOfNodes += nodeName
                val currentClass = obj.eClass.name
                if (currentClass == lastClass) {
                    shiftText = ""
                } else {
                    if (lastClass == "" ) {
                        shiftText = ""
                    } else {
                        shiftText = "[below=of "+stateName+"-"+lastClass+"@0]"
                    }
                    lastClass = currentClass
                }
                texWriter.write(
                    "\n"+
                    "      \\node"+shiftText+" ("+nodeName+") {\n"+
                    "          \\textbf{"+objName+"}\n"+
                    "        \\nodepart{second}")
                for (property : obj.eClass.EAllStructuralFeatures) {
                    switch(property) {
                        EAttribute: {
                            val value = obj.eGet(property)
                            texWriter.write("\n          \\attrT{"+property.EAttributeType.name+"} \\attrN{"+property.name+"} = \\val{"+value+"} \\\\")
                        }
                        EReference: {
                            // References should be handled in the second step after all nodes are instantiated
                        }
                    }
                }
                texWriter.write("\n      };")
            }
            // Erzeuge scope Ende etc:
            texWriter.write("\n\n"+
                "    \\end{scope}\n"+
                "    \\begin{pgfonlayer}{background}\n"+
                "      \\node[surround] (background@"+stateName+") [fit = "+listOfNodes.map["("+it+")"].join("")+"] {};\n"+
                "      \\node at (background@"+stateName+".north west) [xshift=27mm,yshift=3mm,left,surround] (backgroundtext@"+stateName+") {\\state{"+stateName+"}};\n"+
                "    \\end{pgfonlayer}\n"+
                "  \\end{scope}\n"+
                "  % END "+stateName+"\n\n"+
                "  \\setxveclength{\\stateDist}{background@state0}{west}{background@"+stateName+"}{east}\n\n")
        ]

        texWriter.write(
            "  % BEGIN TRANSITIONS\n"+
            "  \\begin{scope}")
        sequence.transitions.forEach[ t, i |
            val tmp = t.name.split("->")
            texWriter.write("\n"+
                "    \\draw[very thick,-latex,bend left]\n"+
                "       (background@"+tmp.get(0)+".north east) to \n"+
                "                                   node[pos=.5] (transTmp"+tmp.get(0)+"){}\n"+
                "                                   node[surround,transition] (trans"+tmp.get(0)+"){\n"+
                "                                      \\texttt{\\bfseries applied operation(s):}\n"+
                "                                     \\nodepart{second}\n"+
                "                                        \\textbf{"+t.objects.head+"}\n"+
                "                                   }\n"+
                "                                   (background@"+tmp.get(1)+".north west);\n"+
                "    \\draw[gray,dashed] (transTmp"+tmp.get(0)+".center) -- (trans"+tmp.get(0)+");\n")
        ]
        texWriter.write("\n  \\end{scope} %% END TRANSITIONS")
        texWriter.close();
    }
}