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

import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.misc.*;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class USELexer extends Lexer {
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
	public static String[] modeNames = {
		"DEFAULT_MODE"
	};

	public static final String[] tokenNames = {
		"'\\u0000'", "'\\u0001'", "'\\u0002'", "'\\u0003'", "'\\u0004'", "'\\u0005'", 
		"'\\u0006'", "'\\u0007'", "'\b'", "'\t'", "'\n'", "'\\u000B'", "'\f'", 
		"'\r'", "'\\u000E'", "'\\u000F'", "'\\u0010'", "'\\u0011'", "'\\u0012'", 
		"'\\u0013'", "'\\u0014'", "'\\u0015'", "'\\u0016'", "'\\u0017'", "'\\u0018'", 
		"'\\u0019'", "'\\u001A'", "'\\u001B'", "'\\u001C'", "'\\u001D'", "'\\u001E'", 
		"'\\u001F'", "' '", "'!'", "'\"'", "'#'", "'$'", "'%'", "'&'", "'''", 
		"'('", "')'", "'*'", "'+'", "','", "'-'", "'.'", "'/'", "'0'", "'1'", 
		"'2'"
	};
	public static final String[] ruleNames = {
		"T__0", "MODEL", "CLASS", "ENUM", "ABSTRACT", "INHERIT", "GT", "MINUS", 
		"DIV", "AT", "ATTR", "DOUBLE", "TICKS", "OPS", "ASSOCIATION", "COMPOSITION", 
		"AGGREGATION", "ORDERED", "BETWEEN", "ROLE", "CONSTR", "CONTEXT", "BEGIN", 
		"END", "INV", "PRE", "POST", "IF", "THEN", "ELSE", "ENDIF", "STAR", "NUMBERSIGN", 
		"PLUS", "ID", "NUMBER", "SEMICOLON", "COMMA", "POINT", "PIPE", "LPAR", 
		"RPAR", "LSBRAC", "RSBRAC", "LCBRAC", "RCBRAC", "EQUALS", "ASSIGN", "WS", 
		"COMMENT"
	};


	public USELexer(CharStream input) {
		super(input);
		_interp = new LexerATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	@Override
	public String getGrammarFileName() { return "USE.g4"; }

	@Override
	public String[] getTokenNames() { return tokenNames; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public String[] getModeNames() { return modeNames; }

	@Override
	public ATN getATN() { return _ATN; }

	public static final String _serializedATN =
		"\3\u0430\ud6d1\u8206\uad2d\u4417\uaef1\u8d80\uaadd\2\64\u0164\b\1\4\2"+
		"\t\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4"+
		"\13\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22"+
		"\t\22\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\4\30\t\30\4\31"+
		"\t\31\4\32\t\32\4\33\t\33\4\34\t\34\4\35\t\35\4\36\t\36\4\37\t\37\4 \t"+
		" \4!\t!\4\"\t\"\4#\t#\4$\t$\4%\t%\4&\t&\4\'\t\'\4(\t(\4)\t)\4*\t*\4+\t"+
		"+\4,\t,\4-\t-\4.\t.\4/\t/\4\60\t\60\4\61\t\61\4\62\t\62\4\63\t\63\3\2"+
		"\3\2\3\2\3\2\3\2\3\3\3\3\3\3\3\3\3\3\3\3\3\4\3\4\3\4\3\4\3\4\3\4\3\5\3"+
		"\5\3\5\3\5\3\5\3\6\3\6\3\6\3\6\3\6\3\6\3\6\3\6\3\6\3\7\3\7\3\b\3\b\3\t"+
		"\3\t\3\n\3\n\3\13\3\13\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\r"+
		"\3\r\3\16\3\16\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3\17"+
		"\3\20\3\20\3\20\3\20\3\20\3\20\3\20\3\20\3\20\3\20\3\20\3\20\3\21\3\21"+
		"\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\22\3\22\3\22\3\22"+
		"\3\22\3\22\3\22\3\22\3\22\3\22\3\22\3\22\3\23\3\23\3\23\3\23\3\23\3\23"+
		"\3\23\3\23\3\24\3\24\3\24\3\24\3\24\3\24\3\24\3\24\3\25\3\25\3\25\3\25"+
		"\3\25\3\26\3\26\3\26\3\26\3\26\3\26\3\26\3\26\3\26\3\26\3\26\3\26\3\27"+
		"\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\30\3\30\3\30\3\30\3\30\3\30\3\31"+
		"\3\31\3\31\3\31\3\32\3\32\3\32\3\32\3\33\3\33\3\33\3\33\3\34\3\34\3\34"+
		"\3\34\3\34\3\35\3\35\3\35\3\36\3\36\3\36\3\36\3\36\3\37\3\37\3\37\3\37"+
		"\3\37\3 \3 \3 \3 \3 \3 \3!\3!\3\"\3\"\3#\3#\3$\3$\3$\7$\u012b\n$\f$\16"+
		"$\u012e\13$\3%\6%\u0131\n%\r%\16%\u0132\3&\3&\3\'\3\'\3(\3(\3)\3)\3*\3"+
		"*\3+\3+\3,\3,\3-\3-\3.\3.\3/\3/\3\60\3\60\3\61\3\61\3\61\3\62\6\62\u014f"+
		"\n\62\r\62\16\62\u0150\3\62\3\62\3\63\3\63\3\63\3\63\7\63\u0159\n\63\f"+
		"\63\16\63\u015c\13\63\3\63\5\63\u015f\n\63\3\63\3\63\3\63\3\63\2\2\64"+
		"\3\3\5\4\7\5\t\6\13\7\r\b\17\t\21\n\23\13\25\f\27\r\31\16\33\17\35\20"+
		"\37\21!\22#\23%\24\'\25)\26+\27-\30/\31\61\32\63\33\65\34\67\359\36;\37"+
		"= ?!A\"C#E$G%I&K\'M(O)Q*S+U,W-Y.[/]\60_\61a\62c\63e\64\3\2\5\5\2C\\aa"+
		"c|\4\2\13\f\"\"\4\2\f\f\17\17\u0169\2\3\3\2\2\2\2\5\3\2\2\2\2\7\3\2\2"+
		"\2\2\t\3\2\2\2\2\13\3\2\2\2\2\r\3\2\2\2\2\17\3\2\2\2\2\21\3\2\2\2\2\23"+
		"\3\2\2\2\2\25\3\2\2\2\2\27\3\2\2\2\2\31\3\2\2\2\2\33\3\2\2\2\2\35\3\2"+
		"\2\2\2\37\3\2\2\2\2!\3\2\2\2\2#\3\2\2\2\2%\3\2\2\2\2\'\3\2\2\2\2)\3\2"+
		"\2\2\2+\3\2\2\2\2-\3\2\2\2\2/\3\2\2\2\2\61\3\2\2\2\2\63\3\2\2\2\2\65\3"+
		"\2\2\2\2\67\3\2\2\2\29\3\2\2\2\2;\3\2\2\2\2=\3\2\2\2\2?\3\2\2\2\2A\3\2"+
		"\2\2\2C\3\2\2\2\2E\3\2\2\2\2G\3\2\2\2\2I\3\2\2\2\2K\3\2\2\2\2M\3\2\2\2"+
		"\2O\3\2\2\2\2Q\3\2\2\2\2S\3\2\2\2\2U\3\2\2\2\2W\3\2\2\2\2Y\3\2\2\2\2["+
		"\3\2\2\2\2]\3\2\2\2\2_\3\2\2\2\2a\3\2\2\2\2c\3\2\2\2\2e\3\2\2\2\3g\3\2"+
		"\2\2\5l\3\2\2\2\7r\3\2\2\2\tx\3\2\2\2\13}\3\2\2\2\r\u0086\3\2\2\2\17\u0088"+
		"\3\2\2\2\21\u008a\3\2\2\2\23\u008c\3\2\2\2\25\u008e\3\2\2\2\27\u0090\3"+
		"\2\2\2\31\u009b\3\2\2\2\33\u009d\3\2\2\2\35\u009f\3\2\2\2\37\u00aa\3\2"+
		"\2\2!\u00b6\3\2\2\2#\u00c2\3\2\2\2%\u00ce\3\2\2\2\'\u00d6\3\2\2\2)\u00de"+
		"\3\2\2\2+\u00e3\3\2\2\2-\u00ef\3\2\2\2/\u00f7\3\2\2\2\61\u00fd\3\2\2\2"+
		"\63\u0101\3\2\2\2\65\u0105\3\2\2\2\67\u0109\3\2\2\29\u010e\3\2\2\2;\u0111"+
		"\3\2\2\2=\u0116\3\2\2\2?\u011b\3\2\2\2A\u0121\3\2\2\2C\u0123\3\2\2\2E"+
		"\u0125\3\2\2\2G\u0127\3\2\2\2I\u0130\3\2\2\2K\u0134\3\2\2\2M\u0136\3\2"+
		"\2\2O\u0138\3\2\2\2Q\u013a\3\2\2\2S\u013c\3\2\2\2U\u013e\3\2\2\2W\u0140"+
		"\3\2\2\2Y\u0142\3\2\2\2[\u0144\3\2\2\2]\u0146\3\2\2\2_\u0148\3\2\2\2a"+
		"\u014a\3\2\2\2c\u014e\3\2\2\2e\u0154\3\2\2\2gh\7B\2\2hi\7r\2\2ij\7t\2"+
		"\2jk\7g\2\2k\4\3\2\2\2lm\7o\2\2mn\7q\2\2no\7f\2\2op\7g\2\2pq\7n\2\2q\6"+
		"\3\2\2\2rs\7e\2\2st\7n\2\2tu\7c\2\2uv\7u\2\2vw\7u\2\2w\b\3\2\2\2xy\7g"+
		"\2\2yz\7p\2\2z{\7w\2\2{|\7o\2\2|\n\3\2\2\2}~\7c\2\2~\177\7d\2\2\177\u0080"+
		"\7u\2\2\u0080\u0081\7v\2\2\u0081\u0082\7t\2\2\u0082\u0083\7c\2\2\u0083"+
		"\u0084\7e\2\2\u0084\u0085\7v\2\2\u0085\f\3\2\2\2\u0086\u0087\7>\2\2\u0087"+
		"\16\3\2\2\2\u0088\u0089\7@\2\2\u0089\20\3\2\2\2\u008a\u008b\7/\2\2\u008b"+
		"\22\3\2\2\2\u008c\u008d\7\61\2\2\u008d\24\3\2\2\2\u008e\u008f\7B\2\2\u008f"+
		"\26\3\2\2\2\u0090\u0091\7c\2\2\u0091\u0092\7v\2\2\u0092\u0093\7v\2\2\u0093"+
		"\u0094\7t\2\2\u0094\u0095\7k\2\2\u0095\u0096\7d\2\2\u0096\u0097\7w\2\2"+
		"\u0097\u0098\7v\2\2\u0098\u0099\7g\2\2\u0099\u009a\7u\2\2\u009a\30\3\2"+
		"\2\2\u009b\u009c\7<\2\2\u009c\32\3\2\2\2\u009d\u009e\7)\2\2\u009e\34\3"+
		"\2\2\2\u009f\u00a0\7q\2\2\u00a0\u00a1\7r\2\2\u00a1\u00a2\7g\2\2\u00a2"+
		"\u00a3\7t\2\2\u00a3\u00a4\7c\2\2\u00a4\u00a5\7v\2\2\u00a5\u00a6\7k\2\2"+
		"\u00a6\u00a7\7q\2\2\u00a7\u00a8\7p\2\2\u00a8\u00a9\7u\2\2\u00a9\36\3\2"+
		"\2\2\u00aa\u00ab\7c\2\2\u00ab\u00ac\7u\2\2\u00ac\u00ad\7u\2\2\u00ad\u00ae"+
		"\7q\2\2\u00ae\u00af\7e\2\2\u00af\u00b0\7k\2\2\u00b0\u00b1\7c\2\2\u00b1"+
		"\u00b2\7v\2\2\u00b2\u00b3\7k\2\2\u00b3\u00b4\7q\2\2\u00b4\u00b5\7p\2\2"+
		"\u00b5 \3\2\2\2\u00b6\u00b7\7e\2\2\u00b7\u00b8\7q\2\2\u00b8\u00b9\7o\2"+
		"\2\u00b9\u00ba\7r\2\2\u00ba\u00bb\7q\2\2\u00bb\u00bc\7u\2\2\u00bc\u00bd"+
		"\7k\2\2\u00bd\u00be\7v\2\2\u00be\u00bf\7k\2\2\u00bf\u00c0\7q\2\2\u00c0"+
		"\u00c1\7p\2\2\u00c1\"\3\2\2\2\u00c2\u00c3\7c\2\2\u00c3\u00c4\7i\2\2\u00c4"+
		"\u00c5\7i\2\2\u00c5\u00c6\7t\2\2\u00c6\u00c7\7g\2\2\u00c7\u00c8\7i\2\2"+
		"\u00c8\u00c9\7c\2\2\u00c9\u00ca\7v\2\2\u00ca\u00cb\7k\2\2\u00cb\u00cc"+
		"\7q\2\2\u00cc\u00cd\7p\2\2\u00cd$\3\2\2\2\u00ce\u00cf\7q\2\2\u00cf\u00d0"+
		"\7t\2\2\u00d0\u00d1\7f\2\2\u00d1\u00d2\7g\2\2\u00d2\u00d3\7t\2\2\u00d3"+
		"\u00d4\7g\2\2\u00d4\u00d5\7f\2\2\u00d5&\3\2\2\2\u00d6\u00d7\7d\2\2\u00d7"+
		"\u00d8\7g\2\2\u00d8\u00d9\7v\2\2\u00d9\u00da\7y\2\2\u00da\u00db\7g\2\2"+
		"\u00db\u00dc\7g\2\2\u00dc\u00dd\7p\2\2\u00dd(\3\2\2\2\u00de\u00df\7t\2"+
		"\2\u00df\u00e0\7q\2\2\u00e0\u00e1\7n\2\2\u00e1\u00e2\7g\2\2\u00e2*\3\2"+
		"\2\2\u00e3\u00e4\7e\2\2\u00e4\u00e5\7q\2\2\u00e5\u00e6\7p\2\2\u00e6\u00e7"+
		"\7u\2\2\u00e7\u00e8\7v\2\2\u00e8\u00e9\7t\2\2\u00e9\u00ea\7c\2\2\u00ea"+
		"\u00eb\7k\2\2\u00eb\u00ec\7p\2\2\u00ec\u00ed\7v\2\2\u00ed\u00ee\7u\2\2"+
		"\u00ee,\3\2\2\2\u00ef\u00f0\7e\2\2\u00f0\u00f1\7q\2\2\u00f1\u00f2\7p\2"+
		"\2\u00f2\u00f3\7v\2\2\u00f3\u00f4\7g\2\2\u00f4\u00f5\7z\2\2\u00f5\u00f6"+
		"\7v\2\2\u00f6.\3\2\2\2\u00f7\u00f8\7d\2\2\u00f8\u00f9\7g\2\2\u00f9\u00fa"+
		"\7i\2\2\u00fa\u00fb\7k\2\2\u00fb\u00fc\7p\2\2\u00fc\60\3\2\2\2\u00fd\u00fe"+
		"\7g\2\2\u00fe\u00ff\7p\2\2\u00ff\u0100\7f\2\2\u0100\62\3\2\2\2\u0101\u0102"+
		"\7k\2\2\u0102\u0103\7p\2\2\u0103\u0104\7x\2\2\u0104\64\3\2\2\2\u0105\u0106"+
		"\7r\2\2\u0106\u0107\7t\2\2\u0107\u0108\7g\2\2\u0108\66\3\2\2\2\u0109\u010a"+
		"\7r\2\2\u010a\u010b\7q\2\2\u010b\u010c\7u\2\2\u010c\u010d\7v\2\2\u010d"+
		"8\3\2\2\2\u010e\u010f\7k\2\2\u010f\u0110\7h\2\2\u0110:\3\2\2\2\u0111\u0112"+
		"\7v\2\2\u0112\u0113\7j\2\2\u0113\u0114\7g\2\2\u0114\u0115\7p\2\2\u0115"+
		"<\3\2\2\2\u0116\u0117\7g\2\2\u0117\u0118\7n\2\2\u0118\u0119\7u\2\2\u0119"+
		"\u011a\7g\2\2\u011a>\3\2\2\2\u011b\u011c\7g\2\2\u011c\u011d\7p\2\2\u011d"+
		"\u011e\7f\2\2\u011e\u011f\7k\2\2\u011f\u0120\7h\2\2\u0120@\3\2\2\2\u0121"+
		"\u0122\7,\2\2\u0122B\3\2\2\2\u0123\u0124\7%\2\2\u0124D\3\2\2\2\u0125\u0126"+
		"\7-\2\2\u0126F\3\2\2\2\u0127\u012c\t\2\2\2\u0128\u012b\t\2\2\2\u0129\u012b"+
		"\5I%\2\u012a\u0128\3\2\2\2\u012a\u0129\3\2\2\2\u012b\u012e\3\2\2\2\u012c"+
		"\u012a\3\2\2\2\u012c\u012d\3\2\2\2\u012dH\3\2\2\2\u012e\u012c\3\2\2\2"+
		"\u012f\u0131\4\62;\2\u0130\u012f\3\2\2\2\u0131\u0132\3\2\2\2\u0132\u0130"+
		"\3\2\2\2\u0132\u0133\3\2\2\2\u0133J\3\2\2\2\u0134\u0135\7=\2\2\u0135L"+
		"\3\2\2\2\u0136\u0137\7.\2\2\u0137N\3\2\2\2\u0138\u0139\7\60\2\2\u0139"+
		"P\3\2\2\2\u013a\u013b\7~\2\2\u013bR\3\2\2\2\u013c\u013d\7*\2\2\u013dT"+
		"\3\2\2\2\u013e\u013f\7+\2\2\u013fV\3\2\2\2\u0140\u0141\7]\2\2\u0141X\3"+
		"\2\2\2\u0142\u0143\7_\2\2\u0143Z\3\2\2\2\u0144\u0145\7}\2\2\u0145\\\3"+
		"\2\2\2\u0146\u0147\7\177\2\2\u0147^\3\2\2\2\u0148\u0149\7?\2\2\u0149`"+
		"\3\2\2\2\u014a\u014b\7<\2\2\u014b\u014c\7?\2\2\u014cb\3\2\2\2\u014d\u014f"+
		"\t\3\2\2\u014e\u014d\3\2\2\2\u014f\u0150\3\2\2\2\u0150\u014e\3\2\2\2\u0150"+
		"\u0151\3\2\2\2\u0151\u0152\3\2\2\2\u0152\u0153\b\62\2\2\u0153d\3\2\2\2"+
		"\u0154\u0155\7/\2\2\u0155\u0156\7/\2\2\u0156\u015a\3\2\2\2\u0157\u0159"+
		"\n\4\2\2\u0158\u0157\3\2\2\2\u0159\u015c\3\2\2\2\u015a\u0158\3\2\2\2\u015a"+
		"\u015b\3\2\2\2\u015b\u015e\3\2\2\2\u015c\u015a\3\2\2\2\u015d\u015f\7\17"+
		"\2\2\u015e\u015d\3\2\2\2\u015e\u015f\3\2\2\2\u015f\u0160\3\2\2\2\u0160"+
		"\u0161\7\f\2\2\u0161\u0162\3\2\2\2\u0162\u0163\b\63\2\2\u0163f\3\2\2\2"+
		"\t\2\u012a\u012c\u0132\u0150\u015a\u015e\3\b\2\2";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}