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

import org.antlr.v4.runtime.misc.NotNull;
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link USEParser}.
 */
public interface USEListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link USEParser#operationParameter}.
	 * @param ctx the parse tree
	 */
	void enterOperationParameter(@NotNull USEParser.OperationParameterContext ctx);
	/**
	 * Exit a parse tree produced by {@link USEParser#operationParameter}.
	 * @param ctx the parse tree
	 */
	void exitOperationParameter(@NotNull USEParser.OperationParameterContext ctx);
	/**
	 * Enter a parse tree produced by {@link USEParser#identifier}.
	 * @param ctx the parse tree
	 */
	void enterIdentifier(@NotNull USEParser.IdentifierContext ctx);
	/**
	 * Exit a parse tree produced by {@link USEParser#identifier}.
	 * @param ctx the parse tree
	 */
	void exitIdentifier(@NotNull USEParser.IdentifierContext ctx);
	/**
	 * Enter a parse tree produced by {@link USEParser#enumLiteral}.
	 * @param ctx the parse tree
	 */
	void enterEnumLiteral(@NotNull USEParser.EnumLiteralContext ctx);
	/**
	 * Exit a parse tree produced by {@link USEParser#enumLiteral}.
	 * @param ctx the parse tree
	 */
	void exitEnumLiteral(@NotNull USEParser.EnumLiteralContext ctx);
	/**
	 * Enter a parse tree produced by {@link USEParser#associationAttendee}.
	 * @param ctx the parse tree
	 */
	void enterAssociationAttendee(@NotNull USEParser.AssociationAttendeeContext ctx);
	/**
	 * Exit a parse tree produced by {@link USEParser#associationAttendee}.
	 * @param ctx the parse tree
	 */
	void exitAssociationAttendee(@NotNull USEParser.AssociationAttendeeContext ctx);
	/**
	 * Enter a parse tree produced by {@link USEParser#class_}.
	 * @param ctx the parse tree
	 */
	void enterClass_(@NotNull USEParser.Class_Context ctx);
	/**
	 * Exit a parse tree produced by {@link USEParser#class_}.
	 * @param ctx the parse tree
	 */
	void exitClass_(@NotNull USEParser.Class_Context ctx);
	/**
	 * Enter a parse tree produced by {@link USEParser#association}.
	 * @param ctx the parse tree
	 */
	void enterAssociation(@NotNull USEParser.AssociationContext ctx);
	/**
	 * Exit a parse tree produced by {@link USEParser#association}.
	 * @param ctx the parse tree
	 */
	void exitAssociation(@NotNull USEParser.AssociationContext ctx);
	/**
	 * Enter a parse tree produced by {@link USEParser#plaintext}.
	 * @param ctx the parse tree
	 */
	void enterPlaintext(@NotNull USEParser.PlaintextContext ctx);
	/**
	 * Exit a parse tree produced by {@link USEParser#plaintext}.
	 * @param ctx the parse tree
	 */
	void exitPlaintext(@NotNull USEParser.PlaintextContext ctx);
	/**
	 * Enter a parse tree produced by {@link USEParser#precondition}.
	 * @param ctx the parse tree
	 */
	void enterPrecondition(@NotNull USEParser.PreconditionContext ctx);
	/**
	 * Exit a parse tree produced by {@link USEParser#precondition}.
	 * @param ctx the parse tree
	 */
	void exitPrecondition(@NotNull USEParser.PreconditionContext ctx);
	/**
	 * Enter a parse tree produced by {@link USEParser#constraints}.
	 * @param ctx the parse tree
	 */
	void enterConstraints(@NotNull USEParser.ConstraintsContext ctx);
	/**
	 * Exit a parse tree produced by {@link USEParser#constraints}.
	 * @param ctx the parse tree
	 */
	void exitConstraints(@NotNull USEParser.ConstraintsContext ctx);
	/**
	 * Enter a parse tree produced by {@link USEParser#spec}.
	 * @param ctx the parse tree
	 */
	void enterSpec(@NotNull USEParser.SpecContext ctx);
	/**
	 * Exit a parse tree produced by {@link USEParser#spec}.
	 * @param ctx the parse tree
	 */
	void exitSpec(@NotNull USEParser.SpecContext ctx);
	/**
	 * Enter a parse tree produced by {@link USEParser#associationDef}.
	 * @param ctx the parse tree
	 */
	void enterAssociationDef(@NotNull USEParser.AssociationDefContext ctx);
	/**
	 * Exit a parse tree produced by {@link USEParser#associationDef}.
	 * @param ctx the parse tree
	 */
	void exitAssociationDef(@NotNull USEParser.AssociationDefContext ctx);
	/**
	 * Enter a parse tree produced by {@link USEParser#plaintext1}.
	 * @param ctx the parse tree
	 */
	void enterPlaintext1(@NotNull USEParser.Plaintext1Context ctx);
	/**
	 * Exit a parse tree produced by {@link USEParser#plaintext1}.
	 * @param ctx the parse tree
	 */
	void exitPlaintext1(@NotNull USEParser.Plaintext1Context ctx);
	/**
	 * Enter a parse tree produced by {@link USEParser#context}.
	 * @param ctx the parse tree
	 */
	void enterContext(@NotNull USEParser.ContextContext ctx);
	/**
	 * Exit a parse tree produced by {@link USEParser#context}.
	 * @param ctx the parse tree
	 */
	void exitContext(@NotNull USEParser.ContextContext ctx);
	/**
	 * Enter a parse tree produced by {@link USEParser#attribute}.
	 * @param ctx the parse tree
	 */
	void enterAttribute(@NotNull USEParser.AttributeContext ctx);
	/**
	 * Exit a parse tree produced by {@link USEParser#attribute}.
	 * @param ctx the parse tree
	 */
	void exitAttribute(@NotNull USEParser.AttributeContext ctx);
	/**
	 * Enter a parse tree produced by {@link USEParser#enum_}.
	 * @param ctx the parse tree
	 */
	void enterEnum_(@NotNull USEParser.Enum_Context ctx);
	/**
	 * Exit a parse tree produced by {@link USEParser#enum_}.
	 * @param ctx the parse tree
	 */
	void exitEnum_(@NotNull USEParser.Enum_Context ctx);
	/**
	 * Enter a parse tree produced by {@link USEParser#operation}.
	 * @param ctx the parse tree
	 */
	void enterOperation(@NotNull USEParser.OperationContext ctx);
	/**
	 * Exit a parse tree produced by {@link USEParser#operation}.
	 * @param ctx the parse tree
	 */
	void exitOperation(@NotNull USEParser.OperationContext ctx);
	/**
	 * Enter a parse tree produced by {@link USEParser#postcondition}.
	 * @param ctx the parse tree
	 */
	void enterPostcondition(@NotNull USEParser.PostconditionContext ctx);
	/**
	 * Exit a parse tree produced by {@link USEParser#postcondition}.
	 * @param ctx the parse tree
	 */
	void exitPostcondition(@NotNull USEParser.PostconditionContext ctx);
}