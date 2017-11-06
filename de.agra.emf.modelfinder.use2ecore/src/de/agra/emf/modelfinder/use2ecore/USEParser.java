// Generated from USE.g4 by ANTLR 4.4

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

import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.misc.*;
import org.antlr.v4.runtime.tree.*;
import java.util.List;
import java.util.Iterator;
import java.util.ArrayList;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class USEParser extends Parser {
	static { RuntimeMetaData.checkVersion("4.4", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		T__0=1, MODEL=2, CLASS=3, ENUM=4, ABSTRACT=5, INHERIT=6, GT=7, MINUS=8, 
		DIV=9, AT=10, ATTR=11, DOUBLE=12, TICKS=13, OPS=14, ASSOCIATION=15, COMPOSITION=16, 
		AGGREGATION=17, ORDERED=18, BETWEEN=19, ROLE=20, CONSTR=21, CONTEXT=22, 
		BEGIN=23, END=24, INV=25, PRE=26, POST=27, IF=28, THEN=29, ELSE=30, ENDIF=31, 
		STAR=32, NUMBERSIGN=33, PLUS=34, ID=35, NUMBER=36, SEMICOLON=37, COMMA=38, 
		POINT=39, PIPE=40, LPAR=41, RPAR=42, LSBRAC=43, RSBRAC=44, LCBRAC=45, 
		RCBRAC=46, EQUALS=47, ASSIGN=48, WS=49, COMMENT=50;
	public static final String[] tokenNames = {
		"<INVALID>", "'@pre'", "'model'", "'class'", "'enum'", "'abstract'", "'<'", 
		"'>'", "'-'", "'/'", "'@'", "'attributes'", "':'", "'''", "'operations'", 
		"'association'", "'composition'", "'aggregation'", "'ordered'", "'between'", 
		"'role'", "'constraints'", "'context'", "'begin'", "'end'", "'inv'", "'pre'", 
		"'post'", "'if'", "'then'", "'else'", "'endif'", "'*'", "'#'", "'+'", 
		"ID", "NUMBER", "';'", "','", "'.'", "'|'", "'('", "')'", "'['", "']'", 
		"'{'", "'}'", "'='", "':='", "WS", "COMMENT"
	};
	public static final int
		RULE_spec = 0, RULE_enum_ = 1, RULE_enumLiteral = 2, RULE_class_ = 3, 
		RULE_attribute = 4, RULE_operation = 5, RULE_precondition = 6, RULE_postcondition = 7, 
		RULE_operationParameter = 8, RULE_association = 9, RULE_associationAttendee = 10, 
		RULE_associationDef = 11, RULE_constraints = 12, RULE_context = 13, RULE_plaintext = 14, 
		RULE_plaintext1 = 15, RULE_identifier = 16;
	public static final String[] ruleNames = {
		"spec", "enum_", "enumLiteral", "class_", "attribute", "operation", "precondition", 
		"postcondition", "operationParameter", "association", "associationAttendee", 
		"associationDef", "constraints", "context", "plaintext", "plaintext1", 
		"identifier"
	};

	@Override
	public String getGrammarFileName() { return "USE.g4"; }

	@Override
	public String[] getTokenNames() { return tokenNames; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public ATN getATN() { return _ATN; }

	public USEParser(TokenStream input) {
		super(input);
		_interp = new ParserATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}
	public static class SpecContext extends ParserRuleContext {
		public EPackage pkg;
		public Token n;
		public List<Class_Context> class_() {
			return getRuleContexts(Class_Context.class);
		}
		public TerminalNode ID() { return getToken(USEParser.ID, 0); }
		public List<Enum_Context> enum_() {
			return getRuleContexts(Enum_Context.class);
		}
		public ConstraintsContext constraints(int i) {
			return getRuleContext(ConstraintsContext.class,i);
		}
		public Class_Context class_(int i) {
			return getRuleContext(Class_Context.class,i);
		}
		public Enum_Context enum_(int i) {
			return getRuleContext(Enum_Context.class,i);
		}
		public List<AssociationContext> association() {
			return getRuleContexts(AssociationContext.class);
		}
		public AssociationContext association(int i) {
			return getRuleContext(AssociationContext.class,i);
		}
		public List<ConstraintsContext> constraints() {
			return getRuleContexts(ConstraintsContext.class);
		}
		public TerminalNode MODEL() { return getToken(USEParser.MODEL, 0); }
		public SpecContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_spec; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof USEListener ) ((USEListener)listener).enterSpec(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof USEListener ) ((USEListener)listener).exitSpec(this);
		}
	}

	public final SpecContext spec() throws RecognitionException {
		SpecContext _localctx = new SpecContext(_ctx, getState());
		enterRule(_localctx, 0, RULE_spec);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(34); match(MODEL);
			setState(35); ((SpecContext)_localctx).n = match(ID);

			((SpecContext)_localctx).pkg =  EcoreFactory.eINSTANCE.createEPackage();
			_localctx.pkg.setName(((SpecContext)_localctx).n.getText());
			_localctx.pkg.setNsPrefix(((SpecContext)_localctx).n.getText());
			_localctx.pkg.setNsURI(((SpecContext)_localctx).n.getText());

			setState(43);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CLASS) | (1L << ENUM) | (1L << ABSTRACT) | (1L << ASSOCIATION) | (1L << COMPOSITION) | (1L << AGGREGATION) | (1L << CONSTR))) != 0)) {
				{
				setState(41);
				switch (_input.LA(1)) {
				case ENUM:
					{
					setState(37); enum_(_localctx.pkg);
					}
					break;
				case CLASS:
				case ABSTRACT:
					{
					setState(38); class_(_localctx.pkg);
					}
					break;
				case ASSOCIATION:
				case COMPOSITION:
				case AGGREGATION:
					{
					setState(39); association(_localctx.pkg);
					}
					break;
				case CONSTR:
					{
					setState(40); constraints();
					}
					break;
				default:
					throw new NoViableAltException(this);
				}
				}
				setState(45);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class Enum_Context extends ParserRuleContext {
		public EPackage pkg;
		public Token n;
		public TerminalNode LCBRAC() { return getToken(USEParser.LCBRAC, 0); }
		public TerminalNode ID() { return getToken(USEParser.ID, 0); }
		public EnumLiteralContext enumLiteral(int i) {
			return getRuleContext(EnumLiteralContext.class,i);
		}
		public TerminalNode RCBRAC() { return getToken(USEParser.RCBRAC, 0); }
		public List<EnumLiteralContext> enumLiteral() {
			return getRuleContexts(EnumLiteralContext.class);
		}
		public TerminalNode ENUM() { return getToken(USEParser.ENUM, 0); }
		public List<TerminalNode> COMMA() { return getTokens(USEParser.COMMA); }
		public TerminalNode COMMA(int i) {
			return getToken(USEParser.COMMA, i);
		}
		public Enum_Context(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public Enum_Context(ParserRuleContext parent, int invokingState, EPackage pkg) {
			super(parent, invokingState);
			this.pkg = pkg;
		}
		@Override public int getRuleIndex() { return RULE_enum_; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof USEListener ) ((USEListener)listener).enterEnum_(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof USEListener ) ((USEListener)listener).exitEnum_(this);
		}
	}

	public final Enum_Context enum_(EPackage pkg) throws RecognitionException {
		Enum_Context _localctx = new Enum_Context(_ctx, getState(), pkg);
		enterRule(_localctx, 2, RULE_enum_);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(46); match(ENUM);
			setState(47); ((Enum_Context)_localctx).n = match(ID);

			    int value = 0;
			    EEnum eenum = EcoreFactory.eINSTANCE.createEEnum();
			    eenum.setName(((Enum_Context)_localctx).n.getText());

			setState(49); match(LCBRAC);
			setState(58);
			_la = _input.LA(1);
			if (_la==ID) {
				{
				setState(50); enumLiteral(eenum, value++);
				setState(55);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==COMMA) {
					{
					{
					setState(51); match(COMMA);
					setState(52); enumLiteral(eenum, value++);
					}
					}
					setState(57);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				}
			}

			setState(60); match(RCBRAC);

			    pkg.getEClassifiers().add(eenum);

			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class EnumLiteralContext extends ParserRuleContext {
		public EEnum eenum;
		public int value;
		public Token lit;
		public TerminalNode ID() { return getToken(USEParser.ID, 0); }
		public EnumLiteralContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public EnumLiteralContext(ParserRuleContext parent, int invokingState, EEnum eenum, int value) {
			super(parent, invokingState);
			this.eenum = eenum;
			this.value = value;
		}
		@Override public int getRuleIndex() { return RULE_enumLiteral; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof USEListener ) ((USEListener)listener).enterEnumLiteral(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof USEListener ) ((USEListener)listener).exitEnumLiteral(this);
		}
	}

	public final EnumLiteralContext enumLiteral(EEnum eenum,int value) throws RecognitionException {
		EnumLiteralContext _localctx = new EnumLiteralContext(_ctx, getState(), eenum, value);
		enterRule(_localctx, 4, RULE_enumLiteral);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(63); ((EnumLiteralContext)_localctx).lit = match(ID);

			    EEnumLiteral literal = EcoreFactory.eINSTANCE.createEEnumLiteral();
			    literal.setName(((EnumLiteralContext)_localctx).lit.getText());
			    literal.setValue(value);
			    eenum.getELiterals().add(literal);

			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class Class_Context extends ParserRuleContext {
		public EPackage pkg;
		public EClass cls;
		public Token a;
		public Token i;
		public Token superClass;
		public Token sClass;
		public TerminalNode INV(int i) {
			return getToken(USEParser.INV, i);
		}
		public List<Plaintext1Context> plaintext1() {
			return getRuleContexts(Plaintext1Context.class);
		}
		public TerminalNode ATTR() { return getToken(USEParser.ATTR, 0); }
		public AttributeContext attribute(int i) {
			return getRuleContext(AttributeContext.class,i);
		}
		public OperationContext operation(int i) {
			return getRuleContext(OperationContext.class,i);
		}
		public TerminalNode ID(int i) {
			return getToken(USEParser.ID, i);
		}
		public List<OperationContext> operation() {
			return getRuleContexts(OperationContext.class);
		}
		public List<TerminalNode> DOUBLE() { return getTokens(USEParser.DOUBLE); }
		public TerminalNode COMMA(int i) {
			return getToken(USEParser.COMMA, i);
		}
		public List<AttributeContext> attribute() {
			return getRuleContexts(AttributeContext.class);
		}
		public List<TerminalNode> ID() { return getTokens(USEParser.ID); }
		public TerminalNode ABSTRACT() { return getToken(USEParser.ABSTRACT, 0); }
		public TerminalNode INHERIT() { return getToken(USEParser.INHERIT, 0); }
		public List<TerminalNode> COMMA() { return getTokens(USEParser.COMMA); }
		public TerminalNode DOUBLE(int i) {
			return getToken(USEParser.DOUBLE, i);
		}
		public TerminalNode END() { return getToken(USEParser.END, 0); }
		public TerminalNode CLASS() { return getToken(USEParser.CLASS, 0); }
		public TerminalNode OPS() { return getToken(USEParser.OPS, 0); }
		public TerminalNode CONSTR() { return getToken(USEParser.CONSTR, 0); }
		public List<TerminalNode> INV() { return getTokens(USEParser.INV); }
		public Plaintext1Context plaintext1(int i) {
			return getRuleContext(Plaintext1Context.class,i);
		}
		public Class_Context(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public Class_Context(ParserRuleContext parent, int invokingState, EPackage pkg) {
			super(parent, invokingState);
			this.pkg = pkg;
		}
		@Override public int getRuleIndex() { return RULE_class_; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof USEListener ) ((USEListener)listener).enterClass_(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof USEListener ) ((USEListener)listener).exitClass_(this);
		}
	}

	public final Class_Context class_(EPackage pkg) throws RecognitionException {
		Class_Context _localctx = new Class_Context(_ctx, getState(), pkg);
		enterRule(_localctx, 6, RULE_class_);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{

			    List<String> superClasses = new ArrayList<String>();

			setState(68);
			_la = _input.LA(1);
			if (_la==ABSTRACT) {
				{
				setState(67); ((Class_Context)_localctx).a = match(ABSTRACT);
				}
			}

			setState(70); match(CLASS);
			setState(71); ((Class_Context)_localctx).i = match(ID);
			setState(83);
			_la = _input.LA(1);
			if (_la==INHERIT) {
				{
				setState(72); match(INHERIT);
				setState(73); ((Class_Context)_localctx).superClass = match(ID);
				superClasses.add(((Class_Context)_localctx).superClass.getText());
				setState(80);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==COMMA) {
					{
					{
					setState(75); match(COMMA);
					setState(76); ((Class_Context)_localctx).sClass = match(ID);
					superClasses.add(((Class_Context)_localctx).sClass.getText());
					}
					}
					setState(82);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				}
			}


			EClass cls = EcoreFactory.eINSTANCE.createEClass();
			cls.setName(((Class_Context)_localctx).i.getText());
			pkg.getEClassifiers().add(cls);

			if (!superClasses.isEmpty()) {
			    EClass eSuperClass = (EClass) pkg.getEClassifier(((Class_Context)_localctx).superClass.getText());
			    cls.getESuperTypes().add(eSuperClass);
			}
			if (((Class_Context)_localctx).a != null) {
			    cls.setAbstract(true);
			}
			setState(93);
			_la = _input.LA(1);
			if (_la==ATTR) {
				{
				setState(86); match(ATTR);
				setState(90);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==ID) {
					{
					{
					setState(87); attribute(pkg, cls);
					}
					}
					setState(92);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				}
			}

			setState(102);
			_la = _input.LA(1);
			if (_la==OPS) {
				{
				setState(95); match(OPS);
				setState(99);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==ID) {
					{
					{
					setState(96); operation(pkg, cls);
					}
					}
					setState(101);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				}
			}

			setState(116);
			_la = _input.LA(1);
			if (_la==CONSTR) {
				{
				setState(104); match(CONSTR);
				setState(113);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==INV) {
					{
					{
					setState(105); match(INV);
					setState(107);
					_la = _input.LA(1);
					if (_la==ID) {
						{
						setState(106); match(ID);
						}
					}

					setState(109); match(DOUBLE);
					setState(110); plaintext1();
					}
					}
					setState(115);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				}
			}

			setState(118); match(END);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class AttributeContext extends ParserRuleContext {
		public EPackage pkg;
		public EClass cls;
		public Token attrName;
		public Token attrType;
		public List<TerminalNode> ID() { return getTokens(USEParser.ID); }
		public TerminalNode ID(int i) {
			return getToken(USEParser.ID, i);
		}
		public TerminalNode DOUBLE() { return getToken(USEParser.DOUBLE, 0); }
		public AttributeContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public AttributeContext(ParserRuleContext parent, int invokingState, EPackage pkg, EClass cls) {
			super(parent, invokingState);
			this.pkg = pkg;
			this.cls = cls;
		}
		@Override public int getRuleIndex() { return RULE_attribute; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof USEListener ) ((USEListener)listener).enterAttribute(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof USEListener ) ((USEListener)listener).exitAttribute(this);
		}
	}

	public final AttributeContext attribute(EPackage pkg,EClass cls) throws RecognitionException {
		AttributeContext _localctx = new AttributeContext(_ctx, getState(), pkg, cls);
		enterRule(_localctx, 8, RULE_attribute);
		try {
			enterOuterAlt(_localctx, 1);
			{
			{
			setState(120); ((AttributeContext)_localctx).attrName = match(ID);
			setState(121); match(DOUBLE);
			setState(122); ((AttributeContext)_localctx).attrType = match(ID);

			        EAttribute attr = EcoreFactory.eINSTANCE.createEAttribute();
			        // always add to container first
			        cls.getEStructuralFeatures().add(attr);
			        attr.setName(((AttributeContext)_localctx).attrName.getText());
			        EClassifier type = null;
			        Boolean _setType = true;
			        switch (((AttributeContext)_localctx).attrType.getText())
			        {
			            case "Integer":
			                type = EcorePackage.Literals.EINT;
			                break;
			            case "Real":
			                System.out.println("WARNING: The class \'" + cls.getName() + "\' has a Real attribute "
			                    + "called \'" + ((AttributeContext)_localctx).attrName.getText() + "\' which will be added as EINT, please doublecheck the class!"
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
			                type = _localctx.pkg.getEClassifier(((AttributeContext)_localctx).attrType.getText());
			                if (type == null)
			                {
			                    _setType = false;
			                }
			                break;
			        }
			        if (_setType) attr.setEType(type);

			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class OperationContext extends ParserRuleContext {
		public EPackage pkg;
		public EClass cls;
		public Token opName;
		public Token opType;
		public List<TerminalNode> SEMICOLON() { return getTokens(USEParser.SEMICOLON); }
		public List<PlaintextContext> plaintext() {
			return getRuleContexts(PlaintextContext.class);
		}
		public List<PreconditionContext> precondition() {
			return getRuleContexts(PreconditionContext.class);
		}
		public OperationParameterContext operationParameter(int i) {
			return getRuleContext(OperationParameterContext.class,i);
		}
		public TerminalNode ID(int i) {
			return getToken(USEParser.ID, i);
		}
		public TerminalNode LPAR() { return getToken(USEParser.LPAR, 0); }
		public PreconditionContext precondition(int i) {
			return getRuleContext(PreconditionContext.class,i);
		}
		public TerminalNode DOUBLE() { return getToken(USEParser.DOUBLE, 0); }
		public TerminalNode COMMA(int i) {
			return getToken(USEParser.COMMA, i);
		}
		public List<TerminalNode> ID() { return getTokens(USEParser.ID); }
		public TerminalNode EQUALS() { return getToken(USEParser.EQUALS, 0); }
		public List<OperationParameterContext> operationParameter() {
			return getRuleContexts(OperationParameterContext.class);
		}
		public List<TerminalNode> COMMA() { return getTokens(USEParser.COMMA); }
		public TerminalNode BEGIN() { return getToken(USEParser.BEGIN, 0); }
		public TerminalNode END() { return getToken(USEParser.END, 0); }
		public TerminalNode SEMICOLON(int i) {
			return getToken(USEParser.SEMICOLON, i);
		}
		public TerminalNode RPAR() { return getToken(USEParser.RPAR, 0); }
		public PostconditionContext postcondition(int i) {
			return getRuleContext(PostconditionContext.class,i);
		}
		public PlaintextContext plaintext(int i) {
			return getRuleContext(PlaintextContext.class,i);
		}
		public List<PostconditionContext> postcondition() {
			return getRuleContexts(PostconditionContext.class);
		}
		public OperationContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public OperationContext(ParserRuleContext parent, int invokingState, EPackage pkg, EClass cls) {
			super(parent, invokingState);
			this.pkg = pkg;
			this.cls = cls;
		}
		@Override public int getRuleIndex() { return RULE_operation; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof USEListener ) ((USEListener)listener).enterOperation(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof USEListener ) ((USEListener)listener).exitOperation(this);
		}
	}

	public final OperationContext operation(EPackage pkg,EClass cls) throws RecognitionException {
		OperationContext _localctx = new OperationContext(_ctx, getState(), pkg, cls);
		enterRule(_localctx, 10, RULE_operation);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(125); ((OperationContext)_localctx).opName = match(ID);

			        EOperation op = EcoreFactory.eINSTANCE.createEOperation();
			        cls.getEOperations().add(op);
			        op.setName(((OperationContext)_localctx).opName.getText());
			    
			setState(127); match(LPAR);
			setState(136);
			_la = _input.LA(1);
			if (_la==ID) {
				{
				setState(128); operationParameter(_localctx.pkg, cls, op);
				setState(133);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==COMMA) {
					{
					{
					setState(129); match(COMMA);
					setState(130); operationParameter(_localctx.pkg, cls, op);
					}
					}
					setState(135);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				}
			}

			setState(138); match(RPAR);
			setState(143);
			switch ( getInterpreter().adaptivePredict(_input,16,_ctx) ) {
			case 1:
				{
				setState(139); match(DOUBLE);
				setState(140); ((OperationContext)_localctx).opType = match(ID);
				}
				break;
			case 2:
				{
				{
				setState(141); match(DOUBLE);
				setState(142); ((OperationContext)_localctx).opType = match(ID);
				}
				}
				break;
			}

			if (((OperationContext)_localctx).opType != null) {
			    EClassifier type = null;
			    Boolean _setType = true;
			    switch (((OperationContext)_localctx).opType.getText()) {
			    case "Integer":
			        type = EcorePackage.Literals.EINT;
			        break;
			    case "Real":
			        System.out.println("WARNING: The class \'" + cls.getName() + "\' has an operation "
			            + "called \'" + ((OperationContext)_localctx).opName.getText() + "\' with a Real as return type. The return type "
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
			        type = _localctx.pkg.getEClassifier(((OperationContext)_localctx).opType.getText());
			        if (type == null)
			        {
			            _setType = false;
			        }
			        break;
			    }
			    if (_setType) op.setEType(type);
			}
			setState(162);
			switch (_input.LA(1)) {
			case BEGIN:
				{
				{
				setState(146); match(BEGIN);
				setState(153);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__0) | (1L << INHERIT) | (1L << GT) | (1L << MINUS) | (1L << DIV) | (1L << AT) | (1L << DOUBLE) | (1L << TICKS) | (1L << IF) | (1L << STAR) | (1L << NUMBERSIGN) | (1L << PLUS) | (1L << ID) | (1L << NUMBER) | (1L << SEMICOLON) | (1L << COMMA) | (1L << POINT) | (1L << PIPE) | (1L << LPAR) | (1L << RPAR) | (1L << LCBRAC) | (1L << RCBRAC) | (1L << EQUALS) | (1L << ASSIGN))) != 0)) {
					{
					{
					setState(147); plaintext();
					setState(149);
					switch ( getInterpreter().adaptivePredict(_input,17,_ctx) ) {
					case 1:
						{
						setState(148); match(SEMICOLON);
						}
						break;
					}
					}
					}
					setState(155);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(156); match(END);
				}
				}
				break;
			case EQUALS:
				{
				{
				setState(157); match(EQUALS);
				setState(158); plaintext();
				setState(160);
				_la = _input.LA(1);
				if (_la==SEMICOLON) {
					{
					setState(159); match(SEMICOLON);
					}
				}

				}
				}
				break;
			case CONSTR:
			case END:
			case PRE:
			case POST:
			case ID:
				break;
			default:
				throw new NoViableAltException(this);
			}
			setState(171);
			switch ( getInterpreter().adaptivePredict(_input,23,_ctx) ) {
			case 1:
				{
				setState(168);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==PRE || _la==POST) {
					{
					setState(166);
					switch (_input.LA(1)) {
					case PRE:
						{
						setState(164); precondition();
						}
						break;
					case POST:
						{
						setState(165); postcondition();
						}
						break;
					default:
						throw new NoViableAltException(this);
					}
					}
					setState(170);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				}
				break;
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class PreconditionContext extends ParserRuleContext {
		public TerminalNode ID() { return getToken(USEParser.ID, 0); }
		public PlaintextContext plaintext() {
			return getRuleContext(PlaintextContext.class,0);
		}
		public TerminalNode PRE() { return getToken(USEParser.PRE, 0); }
		public TerminalNode DOUBLE() { return getToken(USEParser.DOUBLE, 0); }
		public PreconditionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_precondition; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof USEListener ) ((USEListener)listener).enterPrecondition(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof USEListener ) ((USEListener)listener).exitPrecondition(this);
		}
	}

	public final PreconditionContext precondition() throws RecognitionException {
		PreconditionContext _localctx = new PreconditionContext(_ctx, getState());
		enterRule(_localctx, 12, RULE_precondition);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(173); match(PRE);
			setState(175);
			_la = _input.LA(1);
			if (_la==ID) {
				{
				setState(174); match(ID);
				}
			}

			setState(177); match(DOUBLE);
			setState(178); plaintext();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class PostconditionContext extends ParserRuleContext {
		public TerminalNode ID() { return getToken(USEParser.ID, 0); }
		public PlaintextContext plaintext() {
			return getRuleContext(PlaintextContext.class,0);
		}
		public TerminalNode DOUBLE() { return getToken(USEParser.DOUBLE, 0); }
		public TerminalNode POST() { return getToken(USEParser.POST, 0); }
		public PostconditionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_postcondition; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof USEListener ) ((USEListener)listener).enterPostcondition(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof USEListener ) ((USEListener)listener).exitPostcondition(this);
		}
	}

	public final PostconditionContext postcondition() throws RecognitionException {
		PostconditionContext _localctx = new PostconditionContext(_ctx, getState());
		enterRule(_localctx, 14, RULE_postcondition);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(180); match(POST);
			setState(182);
			_la = _input.LA(1);
			if (_la==ID) {
				{
				setState(181); match(ID);
				}
			}

			setState(184); match(DOUBLE);
			setState(185); plaintext();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class OperationParameterContext extends ParserRuleContext {
		public EPackage pkg;
		public EClass cls;
		public EOperation op;
		public Token pName;
		public Token pType;
		public List<TerminalNode> ID() { return getTokens(USEParser.ID); }
		public TerminalNode ID(int i) {
			return getToken(USEParser.ID, i);
		}
		public TerminalNode DOUBLE() { return getToken(USEParser.DOUBLE, 0); }
		public OperationParameterContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public OperationParameterContext(ParserRuleContext parent, int invokingState, EPackage pkg, EClass cls, EOperation op) {
			super(parent, invokingState);
			this.pkg = pkg;
			this.cls = cls;
			this.op = op;
		}
		@Override public int getRuleIndex() { return RULE_operationParameter; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof USEListener ) ((USEListener)listener).enterOperationParameter(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof USEListener ) ((USEListener)listener).exitOperationParameter(this);
		}
	}

	public final OperationParameterContext operationParameter(EPackage pkg,EClass cls,EOperation op) throws RecognitionException {
		OperationParameterContext _localctx = new OperationParameterContext(_ctx, getState(), pkg, cls, op);
		enterRule(_localctx, 16, RULE_operationParameter);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(187); ((OperationParameterContext)_localctx).pName = match(ID);
			setState(188); match(DOUBLE);
			setState(189); ((OperationParameterContext)_localctx).pType = match(ID);

			    EParameter parameter = EcoreFactory.eINSTANCE.createEParameter();
			    parameter.setName(((OperationParameterContext)_localctx).pName.getText());
			    if (((OperationParameterContext)_localctx).pType != null)
			    {
			        EClassifier type = null;
			        Boolean _setType = true;
			        switch (((OperationParameterContext)_localctx).pType.getText())
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
			                type = _localctx.pkg.getEClassifier(((OperationParameterContext)_localctx).pType.getText());
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
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class AssociationContext extends ParserRuleContext {
		public EPackage pkg;
		public Token n;
		public AssociationAttendeeContext r1;
		public AssociationAttendeeContext r2;
		public TerminalNode ID() { return getToken(USEParser.ID, 0); }
		public AssociationAttendeeContext associationAttendee(int i) {
			return getRuleContext(AssociationAttendeeContext.class,i);
		}
		public TerminalNode BETWEEN() { return getToken(USEParser.BETWEEN, 0); }
		public TerminalNode END() { return getToken(USEParser.END, 0); }
		public AssociationDefContext associationDef() {
			return getRuleContext(AssociationDefContext.class,0);
		}
		public List<AssociationAttendeeContext> associationAttendee() {
			return getRuleContexts(AssociationAttendeeContext.class);
		}
		public AssociationContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public AssociationContext(ParserRuleContext parent, int invokingState, EPackage pkg) {
			super(parent, invokingState);
			this.pkg = pkg;
		}
		@Override public int getRuleIndex() { return RULE_association; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof USEListener ) ((USEListener)listener).enterAssociation(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof USEListener ) ((USEListener)listener).exitAssociation(this);
		}
	}

	public final AssociationContext association(EPackage pkg) throws RecognitionException {
		AssociationContext _localctx = new AssociationContext(_ctx, getState(), pkg);
		enterRule(_localctx, 18, RULE_association);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{

			EReference reference = null;
			List<EReference> references = new ArrayList<EReference>();

			setState(193); associationDef();
			setState(194); ((AssociationContext)_localctx).n = match(ID);
			setState(195); match(BETWEEN);
			setState(196); ((AssociationContext)_localctx).r1 = associationAttendee(((AssociationContext)_localctx).n.getText(), _localctx.pkg);
			reference = ((AssociationContext)_localctx).r1.reference;
			setState(199); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				{
				setState(198); ((AssociationContext)_localctx).r2 = associationAttendee(((AssociationContext)_localctx).n.getText(), _localctx.pkg);
				}
				}
				setState(201); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( _la==ID );
			references.add(((AssociationContext)_localctx).r2.reference);

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
			}
			setState(205); match(END);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class AssociationAttendeeContext extends ParserRuleContext {
		public String name;
		public EPackage pkg;
		public EReference reference;
		public Token n;
		public Token s1;
		public Token n1;
		public Token n2;
		public Token s2;
		public Token r;
		public Token roleName;
		public TerminalNode ORDERED() { return getToken(USEParser.ORDERED, 0); }
		public List<TerminalNode> ID() { return getTokens(USEParser.ID); }
		public TerminalNode NUMBER(int i) {
			return getToken(USEParser.NUMBER, i);
		}
		public TerminalNode RSBRAC() { return getToken(USEParser.RSBRAC, 0); }
		public List<TerminalNode> POINT() { return getTokens(USEParser.POINT); }
		public TerminalNode LSBRAC() { return getToken(USEParser.LSBRAC, 0); }
		public TerminalNode ID(int i) {
			return getToken(USEParser.ID, i);
		}
		public TerminalNode POINT(int i) {
			return getToken(USEParser.POINT, i);
		}
		public TerminalNode STAR() { return getToken(USEParser.STAR, 0); }
		public List<TerminalNode> NUMBER() { return getTokens(USEParser.NUMBER); }
		public TerminalNode ROLE() { return getToken(USEParser.ROLE, 0); }
		public AssociationAttendeeContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public AssociationAttendeeContext(ParserRuleContext parent, int invokingState, String name, EPackage pkg) {
			super(parent, invokingState);
			this.name = name;
			this.pkg = pkg;
		}
		@Override public int getRuleIndex() { return RULE_associationAttendee; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof USEListener ) ((USEListener)listener).enterAssociationAttendee(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof USEListener ) ((USEListener)listener).exitAssociationAttendee(this);
		}
	}

	public final AssociationAttendeeContext associationAttendee(String name,EPackage pkg) throws RecognitionException {
		AssociationAttendeeContext _localctx = new AssociationAttendeeContext(_ctx, getState(), name, pkg);
		enterRule(_localctx, 20, RULE_associationAttendee);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			((AssociationAttendeeContext)_localctx).reference =  EcoreFactory.eINSTANCE.createEReference();
			setState(208); ((AssociationAttendeeContext)_localctx).n = match(ID);
			setState(209); match(LSBRAC);
			setState(220);
			switch (_input.LA(1)) {
			case STAR:
				{
				setState(210); ((AssociationAttendeeContext)_localctx).s1 = match(STAR);
				}
				break;
			case NUMBER:
				{
				{
				setState(211); ((AssociationAttendeeContext)_localctx).n1 = match(NUMBER);
				setState(218);
				_la = _input.LA(1);
				if (_la==POINT) {
					{
					setState(212); match(POINT);
					setState(213); match(POINT);
					setState(216);
					switch (_input.LA(1)) {
					case NUMBER:
						{
						setState(214); ((AssociationAttendeeContext)_localctx).n2 = match(NUMBER);
						}
						break;
					case STAR:
						{
						setState(215); ((AssociationAttendeeContext)_localctx).s2 = match(STAR);
						}
						break;
					default:
						throw new NoViableAltException(this);
					}
					}
				}

				}
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
			setState(222); match(RSBRAC);
			setState(225);
			_la = _input.LA(1);
			if (_la==ROLE) {
				{
				setState(223); ((AssociationAttendeeContext)_localctx).r = match(ROLE);
				setState(224); ((AssociationAttendeeContext)_localctx).roleName = match(ID);
				}
			}

			setState(228);
			_la = _input.LA(1);
			if (_la==ORDERED) {
				{
				setState(227); match(ORDERED);
				}
			}


			String assName = "";
			if (((AssociationAttendeeContext)_localctx).r != null) {
			//    System.out.println("Role is set but it will not be considered");
			    assName = _localctx.name+"_"+((AssociationAttendeeContext)_localctx).n.getText()+"_role_"+((AssociationAttendeeContext)_localctx).roleName.getText();
			} else {
			    assName = _localctx.name+"_"+((AssociationAttendeeContext)_localctx).n.getText();
			}
			_localctx.reference.setName(assName);
			((EClass) _localctx.pkg.getEClassifier(((AssociationAttendeeContext)_localctx).n.getText())).getEStructuralFeatures().add(_localctx.reference);
			// Setting bounds
			if (((AssociationAttendeeContext)_localctx).s1 != null) {
			    _localctx.reference.setLowerBound(0);
			    _localctx.reference.setUpperBound(-1);
			} else {
			    if (((AssociationAttendeeContext)_localctx).n2 !=  null ) {
			        _localctx.reference.setLowerBound( Integer.parseInt( ((AssociationAttendeeContext)_localctx).n1.getText() ) );
			        _localctx.reference.setUpperBound( Integer.parseInt( ((AssociationAttendeeContext)_localctx).n2.getText() ) );
			    } else if (((AssociationAttendeeContext)_localctx).s2 !=  null ) {
			        _localctx.reference.setLowerBound( Integer.parseInt( ((AssociationAttendeeContext)_localctx).n1.getText() ) );
			        _localctx.reference.setUpperBound(-1);
			    } else {
			        _localctx.reference.setLowerBound( Integer.parseInt( ((AssociationAttendeeContext)_localctx).n1.getText() ) );
			        _localctx.reference.setUpperBound( Integer.parseInt( ((AssociationAttendeeContext)_localctx).n1.getText() ) );
			    }
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class AssociationDefContext extends ParserRuleContext {
		public TerminalNode COMPOSITION() { return getToken(USEParser.COMPOSITION, 0); }
		public TerminalNode AGGREGATION() { return getToken(USEParser.AGGREGATION, 0); }
		public TerminalNode ASSOCIATION() { return getToken(USEParser.ASSOCIATION, 0); }
		public AssociationDefContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_associationDef; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof USEListener ) ((USEListener)listener).enterAssociationDef(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof USEListener ) ((USEListener)listener).exitAssociationDef(this);
		}
	}

	public final AssociationDefContext associationDef() throws RecognitionException {
		AssociationDefContext _localctx = new AssociationDefContext(_ctx, getState());
		enterRule(_localctx, 22, RULE_associationDef);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(232);
			_la = _input.LA(1);
			if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << ASSOCIATION) | (1L << COMPOSITION) | (1L << AGGREGATION))) != 0)) ) {
			_errHandler.recoverInline(this);
			}
			consume();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ConstraintsContext extends ParserRuleContext {
		public ContextContext context(int i) {
			return getRuleContext(ContextContext.class,i);
		}
		public List<ContextContext> context() {
			return getRuleContexts(ContextContext.class);
		}
		public TerminalNode CONSTR() { return getToken(USEParser.CONSTR, 0); }
		public ConstraintsContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_constraints; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof USEListener ) ((USEListener)listener).enterConstraints(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof USEListener ) ((USEListener)listener).exitConstraints(this);
		}
	}

	public final ConstraintsContext constraints() throws RecognitionException {
		ConstraintsContext _localctx = new ConstraintsContext(_ctx, getState());
		enterRule(_localctx, 24, RULE_constraints);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(234); match(CONSTR);
			setState(236); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				{
				setState(235); context();
				}
				}
				setState(238); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( _la==CONTEXT );
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ContextContext extends ParserRuleContext {
		public TerminalNode ID() { return getToken(USEParser.ID, 0); }
		public PlaintextContext plaintext() {
			return getRuleContext(PlaintextContext.class,0);
		}
		public TerminalNode CONTEXT() { return getToken(USEParser.CONTEXT, 0); }
		public ContextContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_context; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof USEListener ) ((USEListener)listener).enterContext(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof USEListener ) ((USEListener)listener).exitContext(this);
		}
	}

	public final ContextContext context() throws RecognitionException {
		ContextContext _localctx = new ContextContext(_ctx, getState());
		enterRule(_localctx, 26, RULE_context);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(240); match(CONTEXT);
			setState(241); match(ID);
			setState(242); plaintext();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class PlaintextContext extends ParserRuleContext {
		public List<Plaintext1Context> plaintext1() {
			return getRuleContexts(Plaintext1Context.class);
		}
		public List<TerminalNode> ELSE() { return getTokens(USEParser.ELSE); }
		public List<TerminalNode> SEMICOLON() { return getTokens(USEParser.SEMICOLON); }
		public List<TerminalNode> IF() { return getTokens(USEParser.IF); }
		public TerminalNode END(int i) {
			return getToken(USEParser.END, i);
		}
		public List<PlaintextContext> plaintext() {
			return getRuleContexts(PlaintextContext.class);
		}
		public List<TerminalNode> THEN() { return getTokens(USEParser.THEN); }
		public TerminalNode ELSE(int i) {
			return getToken(USEParser.ELSE, i);
		}
		public TerminalNode IF(int i) {
			return getToken(USEParser.IF, i);
		}
		public List<TerminalNode> ENDIF() { return getTokens(USEParser.ENDIF); }
		public List<TerminalNode> END() { return getTokens(USEParser.END); }
		public TerminalNode SEMICOLON(int i) {
			return getToken(USEParser.SEMICOLON, i);
		}
		public Plaintext1Context plaintext1(int i) {
			return getRuleContext(Plaintext1Context.class,i);
		}
		public TerminalNode ENDIF(int i) {
			return getToken(USEParser.ENDIF, i);
		}
		public PlaintextContext plaintext(int i) {
			return getRuleContext(PlaintextContext.class,i);
		}
		public TerminalNode THEN(int i) {
			return getToken(USEParser.THEN, i);
		}
		public PlaintextContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_plaintext; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof USEListener ) ((USEListener)listener).enterPlaintext(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof USEListener ) ((USEListener)listener).exitPlaintext(this);
		}
	}

	public final PlaintextContext plaintext() throws RecognitionException {
		PlaintextContext _localctx = new PlaintextContext(_ctx, getState());
		enterRule(_localctx, 28, RULE_plaintext);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(266); 
			_errHandler.sync(this);
			_alt = 1;
			do {
				switch (_alt) {
				case 1:
					{
					setState(266);
					switch (_input.LA(1)) {
					case IF:
						{
						{
						setState(244); match(IF);
						setState(247);
						switch ( getInterpreter().adaptivePredict(_input,33,_ctx) ) {
						case 1:
							{
							setState(245); plaintext();
							}
							break;
						case 2:
							{
							setState(246); plaintext1();
							}
							break;
						}
						setState(249); match(THEN);
						setState(252);
						switch ( getInterpreter().adaptivePredict(_input,34,_ctx) ) {
						case 1:
							{
							setState(250); plaintext();
							}
							break;
						case 2:
							{
							setState(251); plaintext1();
							}
							break;
						}
						setState(259);
						_la = _input.LA(1);
						if (_la==ELSE) {
							{
							setState(254); match(ELSE);
							setState(257);
							switch ( getInterpreter().adaptivePredict(_input,35,_ctx) ) {
							case 1:
								{
								setState(255); plaintext();
								}
								break;
							case 2:
								{
								setState(256); plaintext1();
								}
								break;
							}
							}
						}

						setState(261);
						_la = _input.LA(1);
						if ( !(_la==END || _la==ENDIF) ) {
						_errHandler.recoverInline(this);
						}
						consume();
						setState(263);
						switch ( getInterpreter().adaptivePredict(_input,37,_ctx) ) {
						case 1:
							{
							setState(262); match(SEMICOLON);
							}
							break;
						}
						}
						}
						break;
					case T__0:
					case INHERIT:
					case GT:
					case MINUS:
					case DIV:
					case AT:
					case DOUBLE:
					case TICKS:
					case STAR:
					case NUMBERSIGN:
					case PLUS:
					case ID:
					case NUMBER:
					case SEMICOLON:
					case COMMA:
					case POINT:
					case PIPE:
					case LPAR:
					case RPAR:
					case LCBRAC:
					case RCBRAC:
					case EQUALS:
					case ASSIGN:
						{
						setState(265); plaintext1();
						}
						break;
					default:
						throw new NoViableAltException(this);
					}
					}
					break;
				default:
					throw new NoViableAltException(this);
				}
				setState(268); 
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,39,_ctx);
			} while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER );
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class Plaintext1Context extends ParserRuleContext {
		public List<TerminalNode> AT() { return getTokens(USEParser.AT); }
		public List<TerminalNode> SEMICOLON() { return getTokens(USEParser.SEMICOLON); }
		public TerminalNode MINUS(int i) {
			return getToken(USEParser.MINUS, i);
		}
		public TerminalNode AT(int i) {
			return getToken(USEParser.AT, i);
		}
		public List<TerminalNode> RCBRAC() { return getTokens(USEParser.RCBRAC); }
		public TerminalNode PIPE(int i) {
			return getToken(USEParser.PIPE, i);
		}
		public TerminalNode POINT(int i) {
			return getToken(USEParser.POINT, i);
		}
		public TerminalNode LCBRAC(int i) {
			return getToken(USEParser.LCBRAC, i);
		}
		public List<TerminalNode> STAR() { return getTokens(USEParser.STAR); }
		public TerminalNode PLUS(int i) {
			return getToken(USEParser.PLUS, i);
		}
		public TerminalNode COMMA(int i) {
			return getToken(USEParser.COMMA, i);
		}
		public TerminalNode STAR(int i) {
			return getToken(USEParser.STAR, i);
		}
		public TerminalNode RPAR(int i) {
			return getToken(USEParser.RPAR, i);
		}
		public List<TerminalNode> EQUALS() { return getTokens(USEParser.EQUALS); }
		public List<TerminalNode> NUMBERSIGN() { return getTokens(USEParser.NUMBERSIGN); }
		public TerminalNode INHERIT(int i) {
			return getToken(USEParser.INHERIT, i);
		}
		public TerminalNode ASSIGN(int i) {
			return getToken(USEParser.ASSIGN, i);
		}
		public TerminalNode LPAR(int i) {
			return getToken(USEParser.LPAR, i);
		}
		public List<TerminalNode> TICKS() { return getTokens(USEParser.TICKS); }
		public List<TerminalNode> INHERIT() { return getTokens(USEParser.INHERIT); }
		public List<TerminalNode> COMMA() { return getTokens(USEParser.COMMA); }
		public TerminalNode EQUALS(int i) {
			return getToken(USEParser.EQUALS, i);
		}
		public TerminalNode SEMICOLON(int i) {
			return getToken(USEParser.SEMICOLON, i);
		}
		public TerminalNode RCBRAC(int i) {
			return getToken(USEParser.RCBRAC, i);
		}
		public List<TerminalNode> DIV() { return getTokens(USEParser.DIV); }
		public TerminalNode DIV(int i) {
			return getToken(USEParser.DIV, i);
		}
		public List<TerminalNode> LCBRAC() { return getTokens(USEParser.LCBRAC); }
		public TerminalNode NUMBER(int i) {
			return getToken(USEParser.NUMBER, i);
		}
		public IdentifierContext identifier(int i) {
			return getRuleContext(IdentifierContext.class,i);
		}
		public TerminalNode TICKS(int i) {
			return getToken(USEParser.TICKS, i);
		}
		public List<TerminalNode> PIPE() { return getTokens(USEParser.PIPE); }
		public List<TerminalNode> GT() { return getTokens(USEParser.GT); }
		public List<IdentifierContext> identifier() {
			return getRuleContexts(IdentifierContext.class);
		}
		public List<TerminalNode> LPAR() { return getTokens(USEParser.LPAR); }
		public List<TerminalNode> DOUBLE() { return getTokens(USEParser.DOUBLE); }
		public List<TerminalNode> ASSIGN() { return getTokens(USEParser.ASSIGN); }
		public List<TerminalNode> POINT() { return getTokens(USEParser.POINT); }
		public TerminalNode DOUBLE(int i) {
			return getToken(USEParser.DOUBLE, i);
		}
		public List<TerminalNode> PLUS() { return getTokens(USEParser.PLUS); }
		public List<TerminalNode> MINUS() { return getTokens(USEParser.MINUS); }
		public List<TerminalNode> NUMBER() { return getTokens(USEParser.NUMBER); }
		public List<TerminalNode> RPAR() { return getTokens(USEParser.RPAR); }
		public TerminalNode GT(int i) {
			return getToken(USEParser.GT, i);
		}
		public TerminalNode NUMBERSIGN(int i) {
			return getToken(USEParser.NUMBERSIGN, i);
		}
		public Plaintext1Context(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_plaintext1; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof USEListener ) ((USEListener)listener).enterPlaintext1(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof USEListener ) ((USEListener)listener).exitPlaintext1(this);
		}
	}

	public final Plaintext1Context plaintext1() throws RecognitionException {
		Plaintext1Context _localctx = new Plaintext1Context(_ctx, getState());
		enterRule(_localctx, 30, RULE_plaintext1);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(293); 
			_errHandler.sync(this);
			_alt = 1;
			do {
				switch (_alt) {
				case 1:
					{
					setState(293);
					switch (_input.LA(1)) {
					case ID:
						{
						setState(270); identifier();
						}
						break;
					case T__0:
						{
						setState(271); match(T__0);
						}
						break;
					case NUMBER:
						{
						setState(272); match(NUMBER);
						}
						break;
					case LPAR:
						{
						setState(273); match(LPAR);
						}
						break;
					case RPAR:
						{
						setState(274); match(RPAR);
						}
						break;
					case LCBRAC:
						{
						setState(275); match(LCBRAC);
						}
						break;
					case RCBRAC:
						{
						setState(276); match(RCBRAC);
						}
						break;
					case INHERIT:
						{
						setState(277); match(INHERIT);
						}
						break;
					case GT:
						{
						setState(278); match(GT);
						}
						break;
					case PLUS:
						{
						setState(279); match(PLUS);
						}
						break;
					case MINUS:
						{
						setState(280); match(MINUS);
						}
						break;
					case PIPE:
						{
						setState(281); match(PIPE);
						}
						break;
					case COMMA:
						{
						setState(282); match(COMMA);
						}
						break;
					case EQUALS:
						{
						setState(283); match(EQUALS);
						}
						break;
					case ASSIGN:
						{
						setState(284); match(ASSIGN);
						}
						break;
					case SEMICOLON:
						{
						setState(285); match(SEMICOLON);
						}
						break;
					case NUMBERSIGN:
						{
						setState(286); match(NUMBERSIGN);
						}
						break;
					case DOUBLE:
						{
						setState(287); match(DOUBLE);
						}
						break;
					case AT:
						{
						setState(288); match(AT);
						}
						break;
					case STAR:
						{
						setState(289); match(STAR);
						}
						break;
					case DIV:
						{
						setState(290); match(DIV);
						}
						break;
					case POINT:
						{
						setState(291); match(POINT);
						}
						break;
					case TICKS:
						{
						setState(292); match(TICKS);
						}
						break;
					default:
						throw new NoViableAltException(this);
					}
					}
					break;
				default:
					throw new NoViableAltException(this);
				}
				setState(295); 
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,41,_ctx);
			} while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER );
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class IdentifierContext extends ParserRuleContext {
		public List<TerminalNode> ID() { return getTokens(USEParser.ID); }
		public List<TerminalNode> POINT() { return getTokens(USEParser.POINT); }
		public TerminalNode ID(int i) {
			return getToken(USEParser.ID, i);
		}
		public TerminalNode POINT(int i) {
			return getToken(USEParser.POINT, i);
		}
		public IdentifierContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_identifier; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof USEListener ) ((USEListener)listener).enterIdentifier(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof USEListener ) ((USEListener)listener).exitIdentifier(this);
		}
	}

	public final IdentifierContext identifier() throws RecognitionException {
		IdentifierContext _localctx = new IdentifierContext(_ctx, getState());
		enterRule(_localctx, 32, RULE_identifier);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(297); match(ID);
			setState(302);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,42,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					{
					{
					setState(298); match(POINT);
					setState(299); match(ID);
					}
					} 
				}
				setState(304);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,42,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static final String _serializedATN =
		"\3\u0430\ud6d1\u8206\uad2d\u4417\uaef1\u8d80\uaadd\3\64\u0134\4\2\t\2"+
		"\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13"+
		"\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22\t\22"+
		"\3\2\3\2\3\2\3\2\3\2\3\2\3\2\7\2,\n\2\f\2\16\2/\13\2\3\3\3\3\3\3\3\3\3"+
		"\3\3\3\3\3\7\38\n\3\f\3\16\3;\13\3\5\3=\n\3\3\3\3\3\3\3\3\4\3\4\3\4\3"+
		"\5\3\5\5\5G\n\5\3\5\3\5\3\5\3\5\3\5\3\5\3\5\3\5\7\5Q\n\5\f\5\16\5T\13"+
		"\5\5\5V\n\5\3\5\3\5\3\5\7\5[\n\5\f\5\16\5^\13\5\5\5`\n\5\3\5\3\5\7\5d"+
		"\n\5\f\5\16\5g\13\5\5\5i\n\5\3\5\3\5\3\5\5\5n\n\5\3\5\3\5\7\5r\n\5\f\5"+
		"\16\5u\13\5\5\5w\n\5\3\5\3\5\3\6\3\6\3\6\3\6\3\6\3\7\3\7\3\7\3\7\3\7\3"+
		"\7\7\7\u0086\n\7\f\7\16\7\u0089\13\7\5\7\u008b\n\7\3\7\3\7\3\7\3\7\3\7"+
		"\5\7\u0092\n\7\3\7\3\7\3\7\3\7\5\7\u0098\n\7\7\7\u009a\n\7\f\7\16\7\u009d"+
		"\13\7\3\7\3\7\3\7\3\7\5\7\u00a3\n\7\5\7\u00a5\n\7\3\7\3\7\7\7\u00a9\n"+
		"\7\f\7\16\7\u00ac\13\7\5\7\u00ae\n\7\3\b\3\b\5\b\u00b2\n\b\3\b\3\b\3\b"+
		"\3\t\3\t\5\t\u00b9\n\t\3\t\3\t\3\t\3\n\3\n\3\n\3\n\3\n\3\13\3\13\3\13"+
		"\3\13\3\13\3\13\3\13\6\13\u00ca\n\13\r\13\16\13\u00cb\3\13\3\13\3\13\3"+
		"\13\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\5\f\u00db\n\f\5\f\u00dd\n\f\5"+
		"\f\u00df\n\f\3\f\3\f\3\f\5\f\u00e4\n\f\3\f\5\f\u00e7\n\f\3\f\3\f\3\r\3"+
		"\r\3\16\3\16\6\16\u00ef\n\16\r\16\16\16\u00f0\3\17\3\17\3\17\3\17\3\20"+
		"\3\20\3\20\5\20\u00fa\n\20\3\20\3\20\3\20\5\20\u00ff\n\20\3\20\3\20\3"+
		"\20\5\20\u0104\n\20\5\20\u0106\n\20\3\20\3\20\5\20\u010a\n\20\3\20\6\20"+
		"\u010d\n\20\r\20\16\20\u010e\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3"+
		"\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3"+
		"\21\6\21\u0128\n\21\r\21\16\21\u0129\3\22\3\22\3\22\7\22\u012f\n\22\f"+
		"\22\16\22\u0132\13\22\3\22\2\2\23\2\4\6\b\n\f\16\20\22\24\26\30\32\34"+
		"\36 \"\2\4\3\2\21\23\4\2\32\32!!\u0166\2$\3\2\2\2\4\60\3\2\2\2\6A\3\2"+
		"\2\2\bD\3\2\2\2\nz\3\2\2\2\f\177\3\2\2\2\16\u00af\3\2\2\2\20\u00b6\3\2"+
		"\2\2\22\u00bd\3\2\2\2\24\u00c2\3\2\2\2\26\u00d1\3\2\2\2\30\u00ea\3\2\2"+
		"\2\32\u00ec\3\2\2\2\34\u00f2\3\2\2\2\36\u010c\3\2\2\2 \u0127\3\2\2\2\""+
		"\u012b\3\2\2\2$%\7\4\2\2%&\7%\2\2&-\b\2\1\2\',\5\4\3\2(,\5\b\5\2),\5\24"+
		"\13\2*,\5\32\16\2+\'\3\2\2\2+(\3\2\2\2+)\3\2\2\2+*\3\2\2\2,/\3\2\2\2-"+
		"+\3\2\2\2-.\3\2\2\2.\3\3\2\2\2/-\3\2\2\2\60\61\7\6\2\2\61\62\7%\2\2\62"+
		"\63\b\3\1\2\63<\7/\2\2\649\5\6\4\2\65\66\7(\2\2\668\5\6\4\2\67\65\3\2"+
		"\2\28;\3\2\2\29\67\3\2\2\29:\3\2\2\2:=\3\2\2\2;9\3\2\2\2<\64\3\2\2\2<"+
		"=\3\2\2\2=>\3\2\2\2>?\7\60\2\2?@\b\3\1\2@\5\3\2\2\2AB\7%\2\2BC\b\4\1\2"+
		"C\7\3\2\2\2DF\b\5\1\2EG\7\7\2\2FE\3\2\2\2FG\3\2\2\2GH\3\2\2\2HI\7\5\2"+
		"\2IU\7%\2\2JK\7\b\2\2KL\7%\2\2LR\b\5\1\2MN\7(\2\2NO\7%\2\2OQ\b\5\1\2P"+
		"M\3\2\2\2QT\3\2\2\2RP\3\2\2\2RS\3\2\2\2SV\3\2\2\2TR\3\2\2\2UJ\3\2\2\2"+
		"UV\3\2\2\2VW\3\2\2\2W_\b\5\1\2X\\\7\r\2\2Y[\5\n\6\2ZY\3\2\2\2[^\3\2\2"+
		"\2\\Z\3\2\2\2\\]\3\2\2\2]`\3\2\2\2^\\\3\2\2\2_X\3\2\2\2_`\3\2\2\2`h\3"+
		"\2\2\2ae\7\20\2\2bd\5\f\7\2cb\3\2\2\2dg\3\2\2\2ec\3\2\2\2ef\3\2\2\2fi"+
		"\3\2\2\2ge\3\2\2\2ha\3\2\2\2hi\3\2\2\2iv\3\2\2\2js\7\27\2\2km\7\33\2\2"+
		"ln\7%\2\2ml\3\2\2\2mn\3\2\2\2no\3\2\2\2op\7\16\2\2pr\5 \21\2qk\3\2\2\2"+
		"ru\3\2\2\2sq\3\2\2\2st\3\2\2\2tw\3\2\2\2us\3\2\2\2vj\3\2\2\2vw\3\2\2\2"+
		"wx\3\2\2\2xy\7\32\2\2y\t\3\2\2\2z{\7%\2\2{|\7\16\2\2|}\7%\2\2}~\b\6\1"+
		"\2~\13\3\2\2\2\177\u0080\7%\2\2\u0080\u0081\b\7\1\2\u0081\u008a\7+\2\2"+
		"\u0082\u0087\5\22\n\2\u0083\u0084\7(\2\2\u0084\u0086\5\22\n\2\u0085\u0083"+
		"\3\2\2\2\u0086\u0089\3\2\2\2\u0087\u0085\3\2\2\2\u0087\u0088\3\2\2\2\u0088"+
		"\u008b\3\2\2\2\u0089\u0087\3\2\2\2\u008a\u0082\3\2\2\2\u008a\u008b\3\2"+
		"\2\2\u008b\u008c\3\2\2\2\u008c\u0091\7,\2\2\u008d\u008e\7\16\2\2\u008e"+
		"\u0092\7%\2\2\u008f\u0090\7\16\2\2\u0090\u0092\7%\2\2\u0091\u008d\3\2"+
		"\2\2\u0091\u008f\3\2\2\2\u0091\u0092\3\2\2\2\u0092\u0093\3\2\2\2\u0093"+
		"\u00a4\b\7\1\2\u0094\u009b\7\31\2\2\u0095\u0097\5\36\20\2\u0096\u0098"+
		"\7\'\2\2\u0097\u0096\3\2\2\2\u0097\u0098\3\2\2\2\u0098\u009a\3\2\2\2\u0099"+
		"\u0095\3\2\2\2\u009a\u009d\3\2\2\2\u009b\u0099\3\2\2\2\u009b\u009c\3\2"+
		"\2\2\u009c\u009e\3\2\2\2\u009d\u009b\3\2\2\2\u009e\u00a5\7\32\2\2\u009f"+
		"\u00a0\7\61\2\2\u00a0\u00a2\5\36\20\2\u00a1\u00a3\7\'\2\2\u00a2\u00a1"+
		"\3\2\2\2\u00a2\u00a3\3\2\2\2\u00a3\u00a5\3\2\2\2\u00a4\u0094\3\2\2\2\u00a4"+
		"\u009f\3\2\2\2\u00a4\u00a5\3\2\2\2\u00a5\u00ad\3\2\2\2\u00a6\u00a9\5\16"+
		"\b\2\u00a7\u00a9\5\20\t\2\u00a8\u00a6\3\2\2\2\u00a8\u00a7\3\2\2\2\u00a9"+
		"\u00ac\3\2\2\2\u00aa\u00a8\3\2\2\2\u00aa\u00ab\3\2\2\2\u00ab\u00ae\3\2"+
		"\2\2\u00ac\u00aa\3\2\2\2\u00ad\u00aa\3\2\2\2\u00ad\u00ae\3\2\2\2\u00ae"+
		"\r\3\2\2\2\u00af\u00b1\7\34\2\2\u00b0\u00b2\7%\2\2\u00b1\u00b0\3\2\2\2"+
		"\u00b1\u00b2\3\2\2\2\u00b2\u00b3\3\2\2\2\u00b3\u00b4\7\16\2\2\u00b4\u00b5"+
		"\5\36\20\2\u00b5\17\3\2\2\2\u00b6\u00b8\7\35\2\2\u00b7\u00b9\7%\2\2\u00b8"+
		"\u00b7\3\2\2\2\u00b8\u00b9\3\2\2\2\u00b9\u00ba\3\2\2\2\u00ba\u00bb\7\16"+
		"\2\2\u00bb\u00bc\5\36\20\2\u00bc\21\3\2\2\2\u00bd\u00be\7%\2\2\u00be\u00bf"+
		"\7\16\2\2\u00bf\u00c0\7%\2\2\u00c0\u00c1\b\n\1\2\u00c1\23\3\2\2\2\u00c2"+
		"\u00c3\b\13\1\2\u00c3\u00c4\5\30\r\2\u00c4\u00c5\7%\2\2\u00c5\u00c6\7"+
		"\25\2\2\u00c6\u00c7\5\26\f\2\u00c7\u00c9\b\13\1\2\u00c8\u00ca\5\26\f\2"+
		"\u00c9\u00c8\3\2\2\2\u00ca\u00cb\3\2\2\2\u00cb\u00c9\3\2\2\2\u00cb\u00cc"+
		"\3\2\2\2\u00cc\u00cd\3\2\2\2\u00cd\u00ce\b\13\1\2\u00ce\u00cf\b\13\1\2"+
		"\u00cf\u00d0\7\32\2\2\u00d0\25\3\2\2\2\u00d1\u00d2\b\f\1\2\u00d2\u00d3"+
		"\7%\2\2\u00d3\u00de\7-\2\2\u00d4\u00df\7\"\2\2\u00d5\u00dc\7&\2\2\u00d6"+
		"\u00d7\7)\2\2\u00d7\u00da\7)\2\2\u00d8\u00db\7&\2\2\u00d9\u00db\7\"\2"+
		"\2\u00da\u00d8\3\2\2\2\u00da\u00d9\3\2\2\2\u00db\u00dd\3\2\2\2\u00dc\u00d6"+
		"\3\2\2\2\u00dc\u00dd\3\2\2\2\u00dd\u00df\3\2\2\2\u00de\u00d4\3\2\2\2\u00de"+
		"\u00d5\3\2\2\2\u00df\u00e0\3\2\2\2\u00e0\u00e3\7.\2\2\u00e1\u00e2\7\26"+
		"\2\2\u00e2\u00e4\7%\2\2\u00e3\u00e1\3\2\2\2\u00e3\u00e4\3\2\2\2\u00e4"+
		"\u00e6\3\2\2\2\u00e5\u00e7\7\24\2\2\u00e6\u00e5\3\2\2\2\u00e6\u00e7\3"+
		"\2\2\2\u00e7\u00e8\3\2\2\2\u00e8\u00e9\b\f\1\2\u00e9\27\3\2\2\2\u00ea"+
		"\u00eb\t\2\2\2\u00eb\31\3\2\2\2\u00ec\u00ee\7\27\2\2\u00ed\u00ef\5\34"+
		"\17\2\u00ee\u00ed\3\2\2\2\u00ef\u00f0\3\2\2\2\u00f0\u00ee\3\2\2\2\u00f0"+
		"\u00f1\3\2\2\2\u00f1\33\3\2\2\2\u00f2\u00f3\7\30\2\2\u00f3\u00f4\7%\2"+
		"\2\u00f4\u00f5\5\36\20\2\u00f5\35\3\2\2\2\u00f6\u00f9\7\36\2\2\u00f7\u00fa"+
		"\5\36\20\2\u00f8\u00fa\5 \21\2\u00f9\u00f7\3\2\2\2\u00f9\u00f8\3\2\2\2"+
		"\u00fa\u00fb\3\2\2\2\u00fb\u00fe\7\37\2\2\u00fc\u00ff\5\36\20\2\u00fd"+
		"\u00ff\5 \21\2\u00fe\u00fc\3\2\2\2\u00fe\u00fd\3\2\2\2\u00ff\u0105\3\2"+
		"\2\2\u0100\u0103\7 \2\2\u0101\u0104\5\36\20\2\u0102\u0104\5 \21\2\u0103"+
		"\u0101\3\2\2\2\u0103\u0102\3\2\2\2\u0104\u0106\3\2\2\2\u0105\u0100\3\2"+
		"\2\2\u0105\u0106\3\2\2\2\u0106\u0107\3\2\2\2\u0107\u0109\t\3\2\2\u0108"+
		"\u010a\7\'\2\2\u0109\u0108\3\2\2\2\u0109\u010a\3\2\2\2\u010a\u010d\3\2"+
		"\2\2\u010b\u010d\5 \21\2\u010c\u00f6\3\2\2\2\u010c\u010b\3\2\2\2\u010d"+
		"\u010e\3\2\2\2\u010e\u010c\3\2\2\2\u010e\u010f\3\2\2\2\u010f\37\3\2\2"+
		"\2\u0110\u0128\5\"\22\2\u0111\u0128\7\3\2\2\u0112\u0128\7&\2\2\u0113\u0128"+
		"\7+\2\2\u0114\u0128\7,\2\2\u0115\u0128\7/\2\2\u0116\u0128\7\60\2\2\u0117"+
		"\u0128\7\b\2\2\u0118\u0128\7\t\2\2\u0119\u0128\7$\2\2\u011a\u0128\7\n"+
		"\2\2\u011b\u0128\7*\2\2\u011c\u0128\7(\2\2\u011d\u0128\7\61\2\2\u011e"+
		"\u0128\7\62\2\2\u011f\u0128\7\'\2\2\u0120\u0128\7#\2\2\u0121\u0128\7\16"+
		"\2\2\u0122\u0128\7\f\2\2\u0123\u0128\7\"\2\2\u0124\u0128\7\13\2\2\u0125"+
		"\u0128\7)\2\2\u0126\u0128\7\17\2\2\u0127\u0110\3\2\2\2\u0127\u0111\3\2"+
		"\2\2\u0127\u0112\3\2\2\2\u0127\u0113\3\2\2\2\u0127\u0114\3\2\2\2\u0127"+
		"\u0115\3\2\2\2\u0127\u0116\3\2\2\2\u0127\u0117\3\2\2\2\u0127\u0118\3\2"+
		"\2\2\u0127\u0119\3\2\2\2\u0127\u011a\3\2\2\2\u0127\u011b\3\2\2\2\u0127"+
		"\u011c\3\2\2\2\u0127\u011d\3\2\2\2\u0127\u011e\3\2\2\2\u0127\u011f\3\2"+
		"\2\2\u0127\u0120\3\2\2\2\u0127\u0121\3\2\2\2\u0127\u0122\3\2\2\2\u0127"+
		"\u0123\3\2\2\2\u0127\u0124\3\2\2\2\u0127\u0125\3\2\2\2\u0127\u0126\3\2"+
		"\2\2\u0128\u0129\3\2\2\2\u0129\u0127\3\2\2\2\u0129\u012a\3\2\2\2\u012a"+
		"!\3\2\2\2\u012b\u0130\7%\2\2\u012c\u012d\7)\2\2\u012d\u012f\7%\2\2\u012e"+
		"\u012c\3\2\2\2\u012f\u0132\3\2\2\2\u0130\u012e\3\2\2\2\u0130\u0131\3\2"+
		"\2\2\u0131#\3\2\2\2\u0132\u0130\3\2\2\2-+-9<FRU\\_ehmsv\u0087\u008a\u0091"+
		"\u0097\u009b\u00a2\u00a4\u00a8\u00aa\u00ad\u00b1\u00b8\u00cb\u00da\u00dc"+
		"\u00de\u00e3\u00e6\u00f0\u00f9\u00fe\u0103\u0105\u0109\u010c\u010e\u0127"+
		"\u0129\u0130";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}