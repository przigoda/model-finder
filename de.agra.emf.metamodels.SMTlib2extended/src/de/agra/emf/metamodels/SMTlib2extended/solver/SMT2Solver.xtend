package de.agra.emf.metamodels.SMTlib2extended.solver

import de.agra.emf.metamodels.SMTlib2extended.Bitvector
import de.agra.emf.metamodels.SMTlib2extended.Expression
import de.agra.emf.metamodels.SMTlib2extended.Instance
import de.agra.emf.metamodels.SMTlib2extended.Predicate
import de.agra.emf.metamodels.SMTlib2extended.Variable
import de.agra.emf.metamodels.SMTlib2extended.conversion.SMTlib2Converter
import java.io.BufferedReader
import java.io.BufferedWriter
import java.io.DataOutputStream
import java.io.FileWriter
import java.io.InputStreamReader
import java.net.Socket
import java.util.ArrayList
import java.util.Arrays
import java.util.HashMap
import java.util.List
import org.eclipse.emf.common.util.BasicEList
import org.eclipse.emf.common.util.EList
import org.eclipse.xtend.lib.annotations.Accessors

class SMT2Solver implements Solver<SMTlib2Converter> {

    @Accessors String host = "localhost"
    @Accessors int port = 1313
    @Accessors String backend = "Boolector"
    @Accessors String XReplace = "0"
    @Accessors boolean showRvcdMessages = true;
    @Accessors boolean formatAsserts = true;

    override init() {
        solution.clear
        connect
        chooseSolver
    }

    override finish() {
        disconnect
    }

    @Accessors boolean showAddedExpressions = true;
    override getShowAddedExpressions() {
        showAddedExpressions
    }

    @Accessors SMTlib2Converter converter = new SMTlib2Converter

    @Accessors int timeout = 120;
    override getTimeout() {
        timeout
    }

    val solution = new HashMap<Variable, Object>
    var Socket socket
    var DataOutputStream out
    var BufferedReader in

    val FileWriter fstream = new FileWriter("/tmp/out.txt")
    val BufferedWriter fout = new BufferedWriter(fstream)

    private def formatMsg(String msg)
    {
        if (msg.charAt(0).toString() == "(" && (msg.charAt(msg.length-1).toString == ")")) {
            val assId = msg.indexOf("assert ")
            if (assId != -1 ) {
                return " ASSERT\n"
                       + formatAssert(msg.substring(8,msg.length-1), 0, "", true)
            }
            return " "+msg
        } else {
            throw new Exception("faulty formatted SMT2lib line or another strange error has occurred")
        }
    }

    private def String formatAssert(String msg, int indent, String result, Boolean firstParameter) {
        if (msg.charAt(0).toString() == "(" && (msg.charAt(msg.length-1).toString == ")")) {
            var tmpCommand = ""
            var tmpFirstSpace = 0
            if (msg.charAt(1).toString() == "(") {
                // leave tmp var as they are
            } else {
                tmpFirstSpace = msg.indexOf(" ")
                tmpCommand = msg.substring(1,tmpFirstSpace)
            }
            var newResult = result
            val firstSpace = tmpFirstSpace
            val command = tmpCommand
            val newIndent = indent + 1 + command.length + 1
            var parameterString = msg.substring(firstSpace+1,msg.length-1)
            val List<String> parameterList = new ArrayList<String>()

            do {
                if (!parameterString.startsWith("(")) {
                    // this means a variable is passed as parameter (without any parenthesis!)
                    val firstSpaceInParameterString = parameterString.indexOf(" ")
                    if (firstSpaceInParameterString == -1) {
                        parameterList += parameterString
                        parameterString = ""
                    } else {
                        parameterList += parameterString.substring(0,firstSpaceInParameterString)
                        parameterString = parameterString.substring(firstSpaceInParameterString+1)
                    }
                } else {
                    // this means that the parameter is in parenthesis
                    var parenthesis = 0
                    var index = 0
                    var Boolean once = true
                    var foundIndex = 0
                    for ( c : parameterString.toCharArray.map[it.toString]) {
                        if(c == "("){
                            parenthesis = parenthesis + 1
                        } else if(c == ")"){
                            parenthesis = parenthesis - 1
                            if (parenthesis == 0){
                                if (once) {
                                    foundIndex = index
                                    once = false
                                }
                            }
                        }
                        index = index + 1
                    }
                    parameterList += parameterString.substring(0,foundIndex+1)
                    if ( foundIndex+2 < parameterString.length){
                        parameterString = parameterString.substring(foundIndex+2)
                    } else {
                        parameterString = parameterString.substring(foundIndex+1)
                    }
                }
            } while (parameterString != "")

            if (command == "and" || command == "or" || command == "ite") {
                // or any other n-ary-like command
                if (!firstParameter) {
                    newResult = newResult
                                + (0..indent-1).map[" "].fold("", [a, b | a + b])
                }
                newResult = newResult
                            + "(" + command + " " + formatAssert(parameterList.get(0),newIndent,result,true) + "\n"
                parameterList.remove(0)
                newResult = parameterList.map[formatAssert(it,newIndent,result,false) + "\n"]
                                         .fold(newResult, [a,b  | a + b])
                newResult = newResult.substring(0,newResult.length-1)+")"
            } else if (command == "not" || command == "bvnot") {
                // or any other unary command
                if (!firstParameter) {
                    newResult = newResult
                                + (0..newIndent-1).map[" "].fold("", [a, b | a + b])
                }
                newResult = newResult
                            + "(" + command + " " + formatAssert(parameterList.get(0),newIndent,result,true) + ")"
            } else if (command == "_") {
                // only for the _ command
                if (!firstParameter) {
                    newResult = newResult
                                + (0..indent-1).map[" "].fold("", [a, b | a + b])
                }
                newResult = newResult
                            + "(" + command
                            + parameterList.map[" " + formatAssert(it,newIndent,result,true)]
                                           .fold(newResult, [a,b  | a + b])
                            + ")"
            } else if (command == "") {
                // only for the _ command
                val tmp = parameterList.map[" " + formatAssert(it,newIndent,result,true)]
                                       .fold(newResult, [a,b  | a + b])
                                       .substring(1)
                if (!firstParameter) {
                    newResult = newResult
                                + (0..indent-1).map[" "].fold("", [a, b | a + b])
                }
                newResult = newResult
                            + "(" + tmp + ")"
            } else {
                // all binary commands TODO not necessary binary! ite
                if (!firstParameter) {
                    newResult = newResult
                                + (0..indent-1).map[" "].fold("", [a, b | a + b])
                }
                newResult = newResult
                            + "(" + command + " " + formatAssert(parameterList.get(0),newIndent,result,true) + "\n"
                            + if(parameterList.length > 1)
                            {formatAssert(parameterList.get(1),newIndent,result,false) + ")"} else ")"
            }
            return newResult
        } else {
            if (msg.indexOf(" ") == -1){
                if (firstParameter) {
                    return msg
                } else {
                    return (0..indent-1).map[" "].fold("", [a, b | a + b]) + msg
                }
            } else {
                throw new Exception("faulty formatted SMT2lib line or invalid variable name")
            }
        }
    }

    private def sendToServer(String msg) {
        val sendmsg = if (formatAsserts) '''[Send]«formatMsg(msg)»''' else '''[Send]«msg»''' 
        fout.write(sendmsg+"\n")
        fout.flush
        if (showAddedExpressions)
            println(sendmsg)
        out.writeBytes(msg+"\n")
        out.flush
    }

    override getSolution(EList<Variable> variables) {
        solution.clear
        if (SAT == false) {
            println("There is currently no solution available, please call _solve_ before AND\n" +
                    "make sure that that _solve_ returns true/SAT.")
            return solution
        }
        extractVariables(variables)
        solution
    }

    /**
     * @brief Connects to a metaSMT server
     *
     * Already established connections are closed
     *
     */
    private def void connect() {
        out?.flush
        out?.close
        in?.close

        socket = new Socket(host, port)
        out = new DataOutputStream(socket.outputStream)
        in = new BufferedReader(new InputStreamReader(socket.inputStream))
        println('''Connected to "«host»:«port»"''')
    }

    /**
     * @brief prints messages received from the server uniformly formatted with the messages sent by the client
     */
    private def printReceived(String msg) {
        val rcvd='''[Rcvd] «msg»'''
        fout.write(rcvd)
        fout.flush
        if (showRvcdMessages) {
            println(rcvd)
        }
    }

    /**
     * @brief Disconnects from the metaSMT server
     */
    private  def disconnect() {
        sendToServer("(exit)")
        printReceived(in.readLine)
        out.flush
        out.close
        in.close
        socket.close
    }

    /**
     * @brief Chooses the solver used by the metaSMT server
     * 
     * This function performs some basic error checking
     */
    private def chooseSolver() {
        val available_solvers = in.readLine.split(";")

        printReceived("Available solvers:")
        for (s : available_solvers) {
            printReceived(s)
        }

        if (Arrays::asList(available_solvers).contains(backend)) {
            sendToServer("(set-option :solver " + backend +")")
            var response=in.readLine
            if (!response.equals("success")) {
                throw new Exception('''Could not chose solver «backend»: «response»''')
            }
            sendToServer("(set-option :timeout " + timeout +")")
            response= in.readLine

            // The following case should never happen!
            if (!response.equals("success")) {
                throw new Exception('''Could not finish selection of solver and set timeout: «response»''')
            }
        } else {
            throw new Exception("Solver " + backend + " does not exist")
        }
    }

    private var boolean SAT = false;
    @Accessors int solveCall = 0
    override solveCalls() {
        solveCall
    }
    override solve() {
        solveCall = solveCall + 1
        solution.clear

        SAT = checkSAT
        if (SAT) {
            printReceived("SAT")
        } else {
            printReceived("unSAT")
        }

        return SAT
    }

    private def interpret(Variable variable, String response) {
        switch (variable) {
            Predicate: response.equals("true")
            Bitvector: {
                val base = if (response.charAt(1).equals("x")) 16 else 2
                val _response = if (getXReplace.matches("0|1"))
                                  response.replace("X", getXReplace)
                                else
                                  response
                Integer::parseInt(_response.subSequence(2, _response.length).toString, base)
            }
        }
    }

    private def extractVariables(EList<Variable> vars) {
        solution.clear
        for (v : vars) {

//            sendToServer('''(get-value («v.name»))''')

            val msg = '''(get-value («v.name»))'''
            val sendmsg = '''[Send]«msg»'''
            fout.write(sendmsg+"\n")
            fout.flush
//            if (showSendMessages)
//                println(sendmsg)
            out.writeBytes(msg+"\n")
            out.flush

            var response = in.readLine.split(" ").get(1).replaceAll("\\)", "")
            solution.put(v, v.interpret(response))
        }
    }

    private def checkSAT() {
        sendToServer("(check-sat)")
        val response = in.readLine
        
        printReceived(response)

        return (response.startsWith("sat"))
    }

    @Accessors boolean varsOnce = false
    override addAssertion(Expression assertion) {
        sendToServer('''(assert «converter.convertCompact(assertion)»)''')
        // ignore the "success" response
        in.readLine
    }
    override addAssertions(EList<Expression> assertions) {
        createAssertions(assertions)
    }

    private def createAssertions(EList<Expression> assertions) {
        for (a : assertions) {
            sendToServer('''(assert «converter.convertCompact(a)»)''')
            //ignore the "success" response
            in.readLine
        }
    }

    def createVars(EList<Variable> vars) {
        for (v : vars) {
            if (v instanceof Predicate) {
                sendToServer('''(declare-fun «v.name» () Bool)''')
            } else if (v instanceof Bitvector) {
                sendToServer('''(declare-fun «v.name» () (_ BitVec «(v as Bitvector).width»))''')
            } else {
                throw new Exception("Unsupported variable sort: " + v.^class.name)
            }
            //ignore the "success" response
            in.readLine
        }
    }

    override push() {
        sendToServer("(push 1)")
    }

    override pop() {
        sendToServer("(pop 1)")
    }
}