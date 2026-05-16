package br.maua.cic303;

import java_cup.runtime.Symbol;

%%

%class Lexer
%public
%unicode
%cup
%line
%column

%{
    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }

    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }
%}

/* ========================================================================= */
/* MACROS                                                                    */
/* ========================================================================= */

LineTerminator = \r|\n|\r\n
WhiteSpace     = {LineTerminator} | [ \t\f]

/* Número */
Number = [0-9]+(\.[0-9]+)?([Ee][+-]?[0-9]+)?

/* Identificadores */
Letter = [a-zA-Z]
Digit  = [0-9]

Identifier = {Letter}({Letter}|{Digit}|_){0,31}

/* Identificador maior que 32 caracteres */
OversizedIdentifier = {Letter}({Letter}|{Digit}|_){32}({Letter}|{Digit}|_)*

%%

/* ========================================================================= */
/* REGRAS LÉXICAS                                                            */
/* ========================================================================= */

<YYINITIAL> {

    /* Ignora espaços */
    {WhiteSpace}    { }

    /* ===================================================================== */
    /* PALAVRAS RESERVADAS                                                   */
    /* ===================================================================== */

    "if"            { return symbol(sym.IF); }
    "then"          { return symbol(sym.THEN); }
    "else"          { return symbol(sym.ELSE); }
    "while"         { return symbol(sym.WHILE); }

    /* ===================================================================== */
    /* PONTUAÇÃO                                                             */
    /* ===================================================================== */

    "("             { return symbol(sym.LPAREN); }
    ")"             { return symbol(sym.RPAREN); }

    "{"             { return symbol(sym.LBRACE); }
    "}"             { return symbol(sym.RBRACE); }

    ";"             { return symbol(sym.SEMI); }

    /* ===================================================================== */
    /* OPERADORES RELACIONAIS                                                */
    /* ===================================================================== */

    "=="            { return symbol(sym.EQ); }
    "!="            { return symbol(sym.NE); }

    "<="            { return symbol(sym.LE); }
    ">="            { return symbol(sym.GE); }

    "<"             { return symbol(sym.LT); }
    ">"             { return symbol(sym.GT); }

    "="             { return symbol(sym.ASSIGN); }

    /* ===================================================================== */
    /* OPERADORES MATEMÁTICOS                                                */
    /* ===================================================================== */

    "+"             { return symbol(sym.PLUS); }
    "-"             { return symbol(sym.MINUS); }

    "*"             { return symbol(sym.TIMES); }
    "/"             { return symbol(sym.DIVIDE); }
    "%"             { return symbol(sym.MOD); }

    /* ===================================================================== */
    /* IDENTIFICADORES E NÚMEROS                                             */
    /* ===================================================================== */

    {Identifier} {
        return symbol(sym.ID, yytext());
    }

    {Number} {
        return symbol(sym.NUMBER, yytext());
    }

    /* ===================================================================== */
    /* ERRO: IDENTIFICADOR GIGANTE                                           */
    /* ===================================================================== */

    {OversizedIdentifier} {
        throw new RuntimeException(
            "Erro Léxico: Identificador gigante -> " + yytext()
        );
    }

    /* ===================================================================== */
    /* ERRO GENÉRICO                                                         */
    /* ===================================================================== */

    . {
        throw new RuntimeException(
            "Erro Léxico: Caractere Ilegal -> " + yytext()
        );
    }
}

/* EOF */
<<EOF>> {
    return symbol(sym.EOF);
}