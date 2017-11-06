grammar USE;

@header {
package de.agra.emf.modelfinder.use2ecore;

import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.impl.*;
import org.eclipse.emf.ecore.EAttribute;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EEnum;
import org.eclipse.emf.ecore.EEnumLiteral;
import org.eclipse.emf.ecore.EParameter;
import org.eclipse.emf.ecore.EcoreFactory;
import org.eclipse.emf.ecore.EcorePackage;
import org.eclipse.emf.ecore.EClassifier;
import org.eclipse.emf.ecore.EOperation;
import org.eclipse.emf.ecore.EReference;
}

// Parser  ------------------------------------------------------------------------------------------------------------

spec returns[EPackage pkg]
:
MODEL n=ID {
$pkg = EcoreFactory.eINSTANCE.createEPackage();
$pkg.setName($n.getText());
$pkg.setNsPrefix($n.getText());
$pkg.setNsURI($n.getText());
} (enum_[$pkg] | class_[$pkg] | association[$pkg] | constraints)*;

enum_ [EPackage pkg]
:
ENUM n=ID {
    int value = 0;
    EEnum eenum = EcoreFactory.eINSTANCE.createEEnum();
    eenum.setName($n.getText());
} LCBRAC (enumLiteral[eenum, value++] (COMMA enumLiteral[eenum, value++])* )? RCBRAC {
    pkg.getEClassifiers().add(eenum);
}
;

enumLiteral [EEnum eenum, int value]
:
lit=ID {
    EEnumLiteral literal = EcoreFactory.eINSTANCE.createEEnumLiteral();
    literal.setName($lit.getText());
    literal.setValue(value);
    eenum.getELiterals().add(literal);
}
;

class_ [EPackage pkg] returns [EClass cls]
:
{
    List<String> superClasses = new ArrayList<String>();
}
     a=ABSTRACT? CLASS i=ID (INHERIT superClass=ID {superClasses.add($superClass.getText());}(COMMA sClass=ID {superClasses.add($sClass.getText());})*)?
     {
EClass cls = EcoreFactory.eINSTANCE.createEClass();
cls.setName($i.getText());
pkg.getEClassifiers().add(cls);

if (!superClasses.isEmpty()) {
    EClass eSuperClass = (EClass) pkg.getEClassifier($superClass.getText());
    cls.getESuperTypes().add(eSuperClass);
}
if ($a != null) {
    cls.setAbstract(true);
}}
    (ATTR (attribute[pkg, cls])*)?
    (OPS (operation[pkg, cls])*)?
    // constraints can also be put in directly into a class
    (CONSTR (INV ID? DOUBLE plaintext1)*)?
    END;

attribute [EPackage pkg, EClass cls]
:
    (attrName=ID DOUBLE attrType=ID{
        EAttribute attr = EcoreFactory.eINSTANCE.createEAttribute();
        // always add to container first
        cls.getEStructuralFeatures().add(attr);
        attr.setName($attrName.getText());
        EClassifier type = null;
        Boolean _setType = true;
        switch ($attrType.getText())
        {
            case "Integer":
                type = EcorePackage.Literals.EINT;
                break;
            case "Real":
                System.out.println("WARNING: The class \'" + cls.getName() + "\' has a Real attribute "
                    + "called \'" + $attrName.getText() + "\' which will be added as EINT, please doublecheck the class!"
                );
                type = EcorePackage.Literals.EINT;
                break;
            case "String":
                type = EcorePackage.Literals.ESTRING;
                break;
            case "Boolean":
                type = EcorePackage.Literals.EBOOLEAN;
                break;
            default:
                type = $pkg.getEClassifier($attrType.getText());
                if (type == null)
                {
                    _setType = false;
                }
                break;
        }
        if (_setType) attr.setEType(type);
})
;

operation [EPackage pkg, EClass cls]
:
    opName=ID {
        EOperation op = EcoreFactory.eINSTANCE.createEOperation();
        cls.getEOperations().add(op);
        op.setName($opName.getText());
    }
        LPAR (operationParameter[$pkg, cls, op] (COMMA operationParameter[$pkg, cls, op])*)? RPAR
        (DOUBLE opType=ID | (DOUBLE opType=ID))? {
if ($opType != null) {
    EClassifier type = null;
    Boolean _setType = true;
    switch ($opType.getText()) {
    case "Integer":
        type = EcorePackage.Literals.EINT;
        break;
    case "Real":
        System.out.println("WARNING: The class \'" + cls.getName() + "\' has an operation "
            + "called \'" + $opName.getText() + "\' with a Real as return type. The return type "
            + "will be changed to EINT, please doublecheck the class!"
        );
        type = EcorePackage.Literals.EINT;
        break;
    case "String":
        type = EcorePackage.Literals.ESTRING;
        break;
    case "Boolean":
        type = EcorePackage.Literals.EBOOLEAN;
        break;
    default:
        type = $pkg.getEClassifier($opType.getText());
        if (type == null)
        {
            _setType = false;
        }
        break;
    }
    if (_setType) op.setEType(type);
}}
(   (BEGIN (plaintext (SEMICOLON)?)* END)
    | (EQUALS plaintext SEMICOLON?)
)?
(
    (precondition | postcondition)*
)?
;
precondition
:
    PRE ID? DOUBLE plaintext
;

postcondition
:
    POST ID? DOUBLE plaintext
;


operationParameter [EPackage pkg, EClass cls, EOperation op]
:
pName=ID DOUBLE pType=ID {
    EParameter parameter = EcoreFactory.eINSTANCE.createEParameter();
    parameter.setName($pName.getText());
    if ($pType != null)
    {
        EClassifier type = null;
        Boolean _setType = true;
        switch ($pType.getText())
        {
            case "Integer":
                type = EcorePackage.Literals.EINT;
                break;
            case "Real":
                System.out.println("WARNING: The class \'" + cls.getName() + "\' has an operation "
                    + "called \'" + op.getName() + "\' with a Real as return type. The return type "
                    + "will be changed to EINT, please doublecheck the class!"
                );
                type = EcorePackage.Literals.EINT;
                break;
            case "String":
                type = EcorePackage.Literals.ESTRING;
                break;
            case "Boolean":
                type = EcorePackage.Literals.EBOOLEAN;
                break;
            default:
                type = $pkg.getEClassifier($pType.getText());
                if (type == null)
                {
                    _setType = false;
                }
                break;
        }
        if (_setType) parameter.setEType(type);
        op.getEParameters().add(parameter);
    }
}
;

association [EPackage pkg]
:
{
EReference reference = null;
List<EReference> references = new ArrayList<EReference>();
}
    associationDef n=ID BETWEEN
    r1=associationAttendee[$n.getText(), $pkg]{reference = $r1.reference;}
    r2=associationAttendee[$n.getText(), $pkg]+{references.add($r2.reference);}
{
/* References handling */
if (references.size() > 1) {
    System.out.println("Only 2-way references are supported in ecore");
} else {
    // swapping names 
    String tmp = reference.getName();
    reference.setName(references.get(0).getName());
    references.get(0).setName(tmp);
    reference.setEOpposite(references.get(0));
    references.get(0).setEOpposite(reference);
    // setting correct EClassifiers / class
    reference.setEType( pkg.getEClassifier(reference.getName().split("_")[1]) );
    references.get(0).setEType( pkg.getEClassifier(references.get(0).getName().split("_")[1]) );
    // swapping multiplicities
    // 1. step lower bounds
    int old = reference.getLowerBound();
    reference.setLowerBound(references.get(0).getLowerBound());
    references.get(0).setLowerBound(old);
    // 2. step upper bounds
    old = reference.getUpperBound();
    reference.setUpperBound(references.get(0).getUpperBound());
    references.get(0).setUpperBound(old);
}}
    END;

associationAttendee [String name, EPackage pkg] returns [EReference reference]
:
{$reference = EcoreFactory.eINSTANCE.createEReference();}
    n=ID LSBRAC (s1=STAR | ( n1=NUMBER (POINT POINT (n2=NUMBER | s2=STAR))?) ) RSBRAC (r=ROLE roleName=ID)? ORDERED?
{
String assName = "";
if ($r != null) {
//    System.out.println("Role is set but it will not be considered");
    assName = $name+"_"+$n.getText()+"_role_"+$roleName.getText();
} else {
    assName = $name+"_"+$n.getText();
}
$reference.setName(assName);
((EClass) $pkg.getEClassifier($n.getText())).getEStructuralFeatures().add($reference);
// Setting bounds
if ($s1 != null) {
    $reference.setLowerBound(0);
    $reference.setUpperBound(-1);
} else {
    if ($n2 !=  null ) {
        $reference.setLowerBound( Integer.parseInt( $n1.getText() ) );
        $reference.setUpperBound( Integer.parseInt( $n2.getText() ) );
    } else if ($s2 !=  null ) {
        $reference.setLowerBound( Integer.parseInt( $n1.getText() ) );
        $reference.setUpperBound(-1);
    } else {
        $reference.setLowerBound( Integer.parseInt( $n1.getText() ) );
        $reference.setUpperBound( Integer.parseInt( $n1.getText() ) );
    }
}}
    ;

associationDef:
    ASSOCIATION | AGGREGATION | COMPOSITION
;
    
constraints:
    CONSTR context+;

context:
    CONTEXT ID plaintext;

plaintext:
    ( (IF (plaintext | plaintext1)
        THEN (plaintext | plaintext1)
        (ELSE (plaintext | plaintext1))?
        (END | ENDIF) SEMICOLON? )
    | plaintext1 )+
    ;

plaintext1: (identifier | '@pre' | NUMBER | LPAR | RPAR | LCBRAC | RCBRAC | INHERIT | GT | PLUS | MINUS | PIPE | COMMA | EQUALS | ASSIGN | SEMICOLON | NUMBERSIGN | DOUBLE | AT | STAR | DIV | POINT | TICKS)+
    ;
    
identifier:
    ID (POINT ID)*
;



// Lexer ------------------------------------------------------------------------------------------------------------

MODEL: 'model';

CLASS : 'class';

ENUM : 'enum';

ABSTRACT : 'abstract';

INHERIT : '<';

GT: '>';

MINUS: '-';

DIV: '/';

AT: '@';

ATTR: 'attributes';

DOUBLE: ':';

TICKS: '\'';

OPS: 'operations';

ASSOCIATION : 'association';

COMPOSITION: 'composition';

AGGREGATION: 'aggregation';

ORDERED: 'ordered';

BETWEEN: 'between';

ROLE: 'role';

CONSTR: 'constraints';

CONTEXT: 'context';

BEGIN: 'begin';

END: 'end';

INV: 'inv';

PRE: 'pre';

POST: 'post';

IF: 'if';

THEN: 'then';

ELSE: 'else';

ENDIF: 'endif';

STAR: '*';

NUMBERSIGN: '#';

PLUS: '+';

ID: ('a'..'z' | 'A'..'Z' | '_') ('a'..'z' | 'A'..'Z' | '_' | NUMBER)*;

NUMBER: ('0'..'9')+;

SEMICOLON: ';';

COMMA: ',';

POINT: '.';

PIPE: '|';

LPAR: '(';

RPAR: ')';

LSBRAC: '[';

RSBRAC: ']';

LCBRAC: '{';

RCBRAC: '}';

EQUALS: '=';

ASSIGN: ':=';

// ignore whitespace & comments
WS : (' ' | '\t' | '\n')+
     -> skip
   ;
   
COMMENT
    :   ( '--' ~[\r\n]* '\r'? '\n'
        ) -> skip
    ;