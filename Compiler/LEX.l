%{
#include<stdio.h>
int c=1;
%}
%option noyywrap
dbl \"
sin \'
id [_a-zA-Z][_a-zA-Z0-9]*
number [0-9]+
real ({number}"."|"."{number}|{number}"."{number})
exp ({number}|{real})([Ee][+-]?({number}|{real}))
%%
"\n" {c++;}
auto {return AUTO;}
break {return BREAK;}
case {return CASE;}
double {return DOUBLE;}
else {return ELSE;}
enum {return ENUM;}
extern {return EXTERN;}
float {return FLOAT;}
const {return CONST;}
char {return CHAR;}
continue {return CONTINUE;}
default {return DEFAULT;}
do {return DO;}
for {return FOR;}
goto {return GOTO;}
if {return IF;}
int {return INT;}
long {return LONG;}
register {return REGISTER;}
return {return RETURN;}
short {return SHORT;}
signed {return SIGNED;}
sizeof {return SIZEOF;}
static {return STATIC;}
struct {return STRUCT;}
switch {return SWITCH;}
typedef {return TYPEDEF;}
union {return UNION;}
unsigned {return UNSIGNED;}
void {return VOID;}
volatile {return VOLATILE;}
while {return WHILE;}
"=" {return EQUAL;}
"+" {return ADD;}
"-" {return SUB;}
"*" {return MULT;}
"/" {return DIV;}
"%" {return MOD;}
"++" {return INCREMENT;} 
"--" {return DECREMENT;}
"==" {return EQ_OPERATOR;}
"!=" {return NE_OPERATOR;}
">" {return GREAT;}
"<" {return LESS;}
">=" {return GE_OPERATOR;}
"<=" {return LE_OPERATOR;}
"!" {return LOG_NOT;}
"&&" {return AND_OPERATOR;}
"||" {return OR_OPERATOR;}
"~" {return BIT_COMP;}
"&" {return BIT_AND;}
"|" {return BIT_OR;}
"^" {return EX_OR;}
"<<" {return LEFT_OPERATOR;}
">>" {return RIGHT_OPERATOR;}
"+=" {return ADD_ASSIGN;}
"-=" {return SUB_ASSIGN;}
"*=" {return MUL_ASSIGN;}
"/=" {return DIV_ASSIGN;}
"%=" {return MOD_ASSIGN;}
"&=" {return AND_ASSIGN;}
"|=" {return OR_ASSIGN;}
"^=" {return XOR_ASSIGN;}
"<<=" {return LEFT_ASSIGN;}
">>=" {return RIGHT_ASSIGN;}
"," {return COMMA;}
":" {return COLON;}
";" {return SEMICOLON;}
"#" {return HASH;}
"(" {return LEFT_PAREN;}
")" {return RIGHT_PAREN;}
"[" {return LSQUARE;}
"]" {return RSQUARE;}
"{" {return LEFT_BRACE;}
"}" {return RIGHT_BRACE;}
"." {return DOT;}
{id} {strcpy(yylval.name,yytext); return IDENTIFIER;}
{number} {strcpy(yylval.name,yytext);return INTEGER_CONSTANT;}
{real}  {strcpy(yylval.name,yytext);return FLOAT_CONSTANT;}
{exp} {strcpy(yylval.name,yytext);return FLOAT_CONSTANT;}
({dbl}(.|" ")*{dbl}) {return STRING;}
({sin}(.|" "){sin}) {strcpy(yylval.name,yytext);return CHAR_CONSTANT;}
"?"  {return QUES;}
"->" {return PTR_OPERATOR;}
"..." {return ELLIPSIS;}
" " {}
"\t" {}
. {printf("ERROR\n");}
%%


