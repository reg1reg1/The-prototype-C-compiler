%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
//Struct is for storing the different values encountered and their type,size lineno etc
//The union is for storing the values occurred during the transition
#define  type_void 0
#define type_int 1
#define type_char 2
#define type_float 3
#define type_double 4
#define type_short 0x10
#define type_long 0x20
#define type_signed 0x100
#define type_unsigned 0x200
#define op_eq 1
#define op_pluseq 2
#define  op_subeq 3
#define op_muleq 4
#define op_diveq 5
extern int c;
int quad=0;
int TOP=-1;
char ind_string[1000];
char ind_arr[1000];
FILE *gen;
char stack[1000][1000];
void push(char x[])
{
    TOP++;
	strcpy(stack[TOP],x);
	
	
}
void pop()
{
    TOP--;
}
int g=0;
int g1=0;
FILE *fp;
FILE *op;
struct a
{
int line;
char name[1000];
int type;
int isarray;
int size;
char init[100000];
};
char buffer[1000];
char vart[1000];
char buffer2[1000];
char vart2[1000];
char buffer3[1000];
char vart3[1000];
int g2=0;
typedef struct a a;
a symtab[1000];

int numsym=0;
void ssize(int x, char arr[])
{   int h;
     h=strtol(arr,NULL,10);
     symtab[x].size=symtab[x].size*h;
}
void add_sym(char x[])
{

	 strcpy(symtab[numsym].name,x);
	 symtab[numsym].type=-1;
	 symtab[numsym].line=c;
	 strcpy(symtab[numsym].init,"_");
	 symtab[numsym].size=1;
	 symtab[numsym].isarray=0;
	 numsym++;
}
int lookup(char x[])
{
int i;
for(i=0;i<numsym;i++)
{
    if(strcmp(symtab[i].name,x)==0)
	return 1;
}
return 0;
}
int symtab_search(char x[])
{
   int i;
   for(i=0;i<numsym;i++)
    {
	if(strcmp(symtab[i].name,x)==0)
	return i;
	}
	return -1;
}
void update(int _type)
{
 int i;
 for(i=0;i<numsym;i++)
 {
    if(symtab[i].type==-1)
	{
	   symtab[i].type=_type;
	}
 }
}
void arrset(int _index)
{
      symtab[_index].isarray=1;
}
void addvalue(int _index,char value[])
{
    
    strcpy(symtab[_index].init, value);
}
void generate_temp()
{   
    g++;
	   memset(vart,0,1000);
	vart[0]='T';
	//vart[1]='_';
	itoa(g,buffer,10);//!!!!!!!!Change this later as it won't work in LINUX systems!!!!!!!<---------
	strcat(vart,buffer);
 }
void generate_temp1()
{
   g1++;
   memset(vart2,0,1000);
   vart2[0]='L';
   //vart2[1]='_';
   itoa(g1,buffer2,10);
   strcat(vart2,buffer2);
}
char s[1000][10];

void add_quad(char x[], char y[], char z[], char a[]);
void print_quad();
struct quadruple{
char R1[50];
char L1[50];
char op[10];
char R2[50];

};
typedef struct quadruple quad_table;
quad_table a_table[100];
void generate_code2();
void print_space();
void gcpy_ind(int a,char b[]);
int getindex(char x[]);
void init_s();
void print_ind_string(int z,char x[]);
void conv_symtab();
void write_loop_code(char name[], char value[]);
void generate_label();
void tag_temp();
void print_s_tab();
char *mod_label(char x[]);
%}

%token AUTO BREAK CASE CONST CHAR CONTINUE DEFAULT DO DOUBLE ELSE ENUM EXTERN FLOAT FOR GOTO IF INT LONG REGISTER RETURN SHORT
%token SIGNED SIZEOF STATIC STRUCT SWITCH TYPEDEF UNION UNSIGNED VOID VOLATILE WHILE
%token EQUAL ADD SUB DIV MOD MULT
%token INCREMENT DECREMENT EQ_OPERATOR NE_OPERATOR GREAT LESS
%token GE_OPERATOR LE_OPERATOR LOG_NOT AND_OPERATOR OR_OPERATOR
%token BIT_AND BIT_OR BIT_COMP EX_OR LEFT_OPERATOR RIGHT_OPERATOR
%token MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN SUB_ASSIGN
%token LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN XOR_ASSIGN OR_ASSIGN
%token COLON SEMICOLON COMMA LEFT_BRACE RIGHT_BRACE LEFT_PAREN RIGHT_PAREN LSQUARE RSQUARE DOT
%token IDENTIFIER INTEGER_CONSTANT FLOAT_CONSTANT ENUMERATION_CONSTANT CHAR_CONSTANT
%token ELLIPSIS HASH STRING
%token PTR_OPERATOR QUES
%union {int type; char name[100]; int index;}
%type <name> IDENTIFIER
%type <type> type_specifier declaration_specifiers assignment_Operator
%type <name> INTEGER_CONSTANT FLOAT_CONSTANT ENUMERATION_CONSTANT CHAR_CONSTANT initializer primary_expression constant postfix_expression cast_expression unary_expression multiplicative_expression additive_expression shift_expression relational_expression equality_expression and_expression exclusive_or_expression inclusive_or_expression logical_and_expression logical_or_expression conditional_expression assignment_expression constant_expression initializer_list unary_Operator expression
%type <index> direct_declarator declarator
%%
	translation_unit
	: external_declaration {printf("\t Transition: translation_unit -> external_declaration\n");}
	| translation_unit external_declaration {printf("\t Transition: translation_unit -> translation_unit external_declaration\n");}
	;

external_declaration
	: function_definition {printf("\t Transition: external_declaration -> function_definition\n");}
	| declaration {printf("\t Transition: external_declaration -> declaration\n");}
	;

function_definition
	: declaration_specifiers declarator declaration_list compound_statement {printf("\t Transition: function_definition ->  declaration_specifiers declarator declaration_list compound_statement\n");}
	| declaration_specifiers declarator compound_statement {printf("\t Transition: function_definition -> declaration_specifiers declarator compound_statement\n");}
	| declarator declaration_list compound_statement {printf("\t Transition: function_definition -> declarator declaration_list compound_statement\n");}
	| declarator compound_statement {printf("\t Transition: function_definition -> declarator compound_statement\n");}
	;

declaration
	: declaration_specifiers SEMICOLON {printf("\t Transition: declaration -> declaration_specifiers SEMICOLON\n");}
	| declaration_specifiers init_declarator_list SEMICOLON {update($1);printf("\t Transition: declaration -> declaration_specifiers init_declarator_list SEMICOLON\n");}
	;

declaration_list
	: declaration {printf("\t Transition: declaration_list -> declaration\n");}
	| declaration_list declaration {printf("\t Transition: declaration_list -> declaration_list declaration\n");}
	;

declaration_specifiers
	: storage_class_specifier declaration_specifiers {printf("\t Transition: declaration_specifiers -> storage_class_specifier declaration_specifiers\n");}
	| storage_class_specifier {printf("\t Transition: declaration_specifiers -> storage_class_specifier\n");}
	| type_specifier declaration_specifiers {$$=$1|$2;printf("\t Transition: declaration_specifiers -> type_specifier declaration_specifiers\n");}
	| type_specifier {$$=$1;printf("\t Transition: declaration_specifiers -> type_specifier\n");}
	| type_qualifier declaration_specifiers {printf("\t Transition: declaration_specifiers -> type_qualifier declaration_specifiers\n");}
	| type_qualifier {printf("\t Transition: declaration_specifiers -> type_qualifier\n");}
	;

storage_class_specifier
	: TYPEDEF	{printf("\t Transition: storage_class_specifier -> TYPEDEF\n");}
	| EXTERN {printf("\t Transition: storage_class_specifier -> EXTERN\n");}
	| STATIC {printf("\t Transition: storage_class_specifier -> STATIC\n");}
	| AUTO {printf("\t Transition: storage_class_specifier -> AUTO\n");}
	| REGISTER {printf("\t Transition: storage_class_specifier -> REGISTER\n");}
	;

type_specifier
	: VOID {$$=type_void;printf("\t Transition: type_specifier -> VOID\n");}
	| CHAR {$$=type_char;printf("\t Transition: type_specifier -> CHAR\n");}
	| SHORT {$$=type_short;printf("\t Transition: type_specifier -> SHORT\n");}
	| INT {$$=type_int;printf("\t Transition: type_specifier -> INT\n");}
	| LONG {$$=type_long;printf("\t Transition: type_specifier -> LONG\n");}
	| FLOAT {$$=type_float;printf("\t Transition: type_specifier -> FLOAT\n");}
	| DOUBLE {$$=type_double;printf("\t Transition: type_specifier -> DOUBLE\n");}
	| SIGNED {$$=type_signed;printf("\t Transition: type_specifier -> SIGNED\n");}
	| UNSIGNED {$$=type_unsigned;printf("\t Transition: type_specifier -> UNSIGNED\n");}
	| struct_or_union_specifier {printf("\t Transition: type_specifier -> struct_or_union_specifier\n");}
	| enum_specifier {printf("\t Transition:type_specifier -> enum_specifier\n");}
	;

type_qualifier
	: CONST {printf("\t Transition: type_qualifier -> CONST\n");}
	| VOLATILE {printf("\t Transition: type_qualifier -> VOLATILE\n");}
	;

struct_or_union_specifier
	: struct_or_union LEFT_BRACE struct_declaration_list RIGHT_BRACE {printf("\t Transition: struct_or_union_specifier ->  struct_or_union LEFT_BRACE struct_declaration_list RIGHT_BRACE\n");}
	| struct_or_union IDENTIFIER LEFT_BRACE struct_declaration_list RIGHT_BRACE {printf("\t Transition: struct_or_union_specifier -> struct_or_union IDENTIFIER LEFT_BRACE struct_declaration_list RIGHT_BRACE\n");}
	| struct_or_union IDENTIFIER {printf("\t Transition: struct_or_union_specifier -> struct_or_union IDENTIFIER\n");}
	;

struct_or_union
	: STRUCT {printf("\t Transition: struct_or_union -> STRUCT\n");}
	| UNION {printf("\t Transition: struct_or_union -> UNION\n");}
	;

struct_declaration_list
	: struct_declaration {printf("\t Transition: struct_declaration_list -> struct_declaration\n");}
	| struct_declaration_list struct_declaration {printf("\t Transition: struct_declaration_list -> struct_declaration_list struct_declaration\n");}
	;

init_declarator_list
	: init_declarator {printf("\t Transition: init_declarator_list -> init_declarator\n");}
	| init_declarator_list COMMA init_declarator {printf("\t Transition: init_declartor_list -> init_declarator_list COMMA init_declarator\n");}
	;

init_declarator
	: declarator {printf("\t Transition: init_declarator -> declarator\n");}
	| declarator EQUAL initializer {addvalue($1,$3);printf("\t Transition: init_declarator -> declarator EQUAL initializer\n");}
	;

struct_declaration
	: specifier_qualifier_list struct_declarator_list SEMICOLON {printf("\t Transition: struct_declaration ->specifier_qualifier_list struct_declarator_list SEMICOLON\n");}
	;

specifier_qualifier_list
	: type_specifier specifier_qualifier_list {printf("\t Transition: specifier_qualifier_list -> type_specifier specifier_qualifier_list\n");}
	| type_specifier {fprintf(fp,"\t Transition: specifier_qualifier_list -> type_specifier\n");}
	| type_qualifier specifier_qualifier_list {printf("\t Transition: specifier_qualifier_list -> type_qualifier specifier_qualifier_list\n");}
	| type_qualifier {fprintf(fp,"\t Transition: specifier_qualifier_list -> type_qualifier\n");}
	;

struct_declarator_list
	: struct_declarator {fprintf(fp,"\t Transition: struct_declarator_list -> struct_declarator\n");}
	| struct_declarator_list COMMA struct_declarator {printf("\t Transition: struct_declarator_list -> struct_declarator_list COMMA struct_declarator\n");}
	;

struct_declarator
	: COLON constant_expression {printf("\t Transition: struct_declarator -> COLON constant_expression \n");}
	| declarator COLON constant_expression {printf("\t Transition: struct_declarator -> declarator COLON constant_expression\n");}
	| declarator {printf("\t Transition: struct_declarator -> declarator\n");}
	;

enum_specifier
	: ENUM LEFT_BRACE enumerator_list RIGHT_BRACE {printf("\t Transition: enum_specifier -> ENUM LEFT_BRACE enumerator_list RIGHT_BRACE\n");}
	| ENUM IDENTIFIER LEFT_BRACE enumerator_list RIGHT_BRACE {printf("\t Transition: enum_specifier -> ENUM IDENTIFIER LEFT_BRACE enumerator_list RIGHT_BRACE\n");}
	| ENUM IDENTIFIER {printf("\t Transition: enum_specifier -> ENUM IDENTIFIER\n");}
	;

enumerator_list
	: enumerator {printf("\t Transition: enumerator_list ->enumerator\n");}
	| enumerator_list COMMA enumerator {printf("\t Transition: enumerator_list -> enumerator_list COMMA enumerator\n");}
	;

enumerator
	: IDENTIFIER {printf("\t Transition: enumerator -> IDENTIFIER\n");}
	| IDENTIFIER EQUAL constant_expression {printf("\t Transition: enumerator -> IDENTIFIER EQUAL constant_expression\n");}
	;

declarator
	: pointer direct_declarator {printf("\t Transition: declarator -> pointer direct_declarator\n");}
	| direct_declarator {printf("\t Transition: declarator ->  direct_declarator\n");}
	;

direct_declarator
	: IDENTIFIER {if(lookup($1)==0){$$=numsym;add_sym($1);}else {fprintf(fp ,"Duplicate Symbol on line no %d\n Exiting....",c); exit(0);} printf("\t Transition: direct_declarator -> IDENTIFIER\n");}
	| LEFT_PAREN declarator RIGHT_PAREN {printf("\t Transition: direct_declarator -> LEFT PAREN declarator RIGHT_PAREN\n");}
	| direct_declarator LSQUARE RSQUARE {$$=$1;arrset($1);printf("\t Transition: direct_declarator -> direct_declarator LSQUARE RSQUARE\n");}
	| direct_declarator LSQUARE constant_expression RSQUARE {$$=$1;arrset($1); ssize($1,$3); printf("\t Transition: direct_declarator -> direct_declarator LSQUARE const_exprssn RSQUARE\n");}
	| direct_declarator LEFT_PAREN parameter_type_list RIGHT_PAREN {printf("\t Transition: direct_declarator ->direct_declarator LEFT_PAREN parameter_type_list RIGHT_PAREN\n");}
	| direct_declarator LEFT_PAREN RIGHT_PAREN {printf("\t Transition: direct_declarator -> direct_declarator LEFT_PAREN RIGHT_PAREN\n");}
	| direct_declarator LEFT_PAREN identifier_list RIGHT_PAREN {printf("\t Transition: direct_declarator -> direct_declarator LEFT_PAREN identifier_list RIGHT_PAREN\n");}
	;

pointer
	: MULT type_qualifier_list pointer {printf("\t Transition: pointer -> MULT type_qualifier_list pointer\n");}
	| MULT type_qualifier_list {printf("\t Transition: pointer -> MULT type_qualifier_list\n");}
	| MULT pointer {printf("\t Transition: pointer -> MULT pointer\n");}
	| MULT {printf("\t Transition: pointer -> MULT\n");}
	;

type_qualifier_list
	: type_qualifier {printf("\t Transition: type_qualifier_list -> type_qualifier\n");}
	| type_qualifier_list type_qualifier {printf("\t Transition: type_qualifier_list -> type_qualifier_list type_qualifier\n");}
	;

parameter_type_list
	: parameter_list COMMA ELLIPSIS {printf("\t Transition: parameter_type_list -> parameter_list COMMA ELLIPSIS\n");}
	| parameter_list {printf("\t Transition: parameter_type_list -> parameter_list\n");}
	;

parameter_list
	: parameter_declaration {printf("\t Transition: parameter_list -> parameter_declaration\n");}
	| parameter_list COMMA parameter_declaration {printf("\t reduced : parameter_list -> parameter_list COMMA parameter_declaration\n");}
	;

parameter_declaration
	: declaration_specifiers declarator {printf("\t Transition: parameter_declaration -> declaration_specifiers declarator\n");}
	| declaration_specifiers abstract_declarator {printf("\t Transition: parameter_declaration -> declaration_specifiers abstract_declarator\n");}
	| declaration_specifiers {printf("\t Transition: parameter_declaration -> declaration_specifiers\n");}
	;

identifier_list
	: IDENTIFIER {printf("\t Transition: identifier_list ->IDENTIFIER\n");}
	| identifier_list COMMA IDENTIFIER {printf("\t Transition: identifier_list -> identifier_list COMMA IDENTIFIER\n");}
	;

initializer
	: LEFT_BRACE initializer_list RIGHT_BRACE {strcpy($$,$2);printf("\t Transition: initializer -> LEFT_BRACE initializer_list RIGHT_BRACE\n");}
	| LEFT_BRACE initializer_list COMMA RIGHT_BRACE {strcpy($$,$2);printf("\t Transition: initializer -> LEFT_BRACE initializer_list COMMA RIGHT_BRACE\n");}
	| assignment_expression { strcpy($$,$1);printf("\t Transition: initializer -> assignment_expression\n");}
	;

initializer_list
	: initializer {printf("\t Transition: initializer_list -> initializer\n");}
	| initializer_list COMMA initializer {strcpy($$,$1); strcat($$,","); strcat($$,$3);printf("\t Transition: initializer_list -> initializer_list COMMA initializer\n");}
	;

type_name
	: specifier_qualifier_list abstract_declarator {printf("\t reduced : type_name -> specifier_qualifier_list abstract_declarator\n");}
	| specifier_qualifier_list {printf("\t Transition: type_name -> specifier_qualifier_list\n");}
	;

abstract_declarator
	: pointer direct_abstract_declarator {printf("\t Transition: abstract_declarator -> pointer direct_abstract_declarator\n");}
	| pointer {printf("\t Transition: abstract_declarator -> pointer\n");}
	| direct_abstract_declarator {printf("\t Transition: abstract_declarator -> direct_abstract_declarator\n");}
	;

direct_abstract_declarator
	: LEFT_PAREN abstract_declarator RIGHT_PAREN {printf("\t Transition: direct_abstract_declarator -> LEFT_PAREN abstract_declarator RIGHT_PAREN\n");}
	| LSQUARE RSQUARE {printf("\t Transition: direct_abstract_declarator -> LSQUARE RSQUARE\n");}
	| LSQUARE constant_expression RSQUARE {printf("\t Transition: direct_abstract_declarator -> LSQUARE contant_expression RSQUARE \n");}
	| direct_abstract_declarator LSQUARE RSQUARE {printf("\t reduced : direct_abstract_declarator -> direct_abstract_declarator lSQUARE RSQUARE\n");}
	| direct_abstract_declarator LSQUARE constant_expression RSQUARE {printf("\t Transition: direct_abstract_declarator -> direct_abstract_declarator LSQUARE contant_expression RSQUARE\n");}
	| LEFT_PAREN RIGHT_PAREN {printf("\t Transition: direct_abstract_declarator -> LEFT_PAREN RIGHT_PAREN\n");}
	| LEFT_PAREN parameter_type_list RIGHT_PAREN {printf("\t Transition: direct_abstract_declarator -> LEFT_PAREN parameter_type_list RIGHT_PAREN\n");}
	| direct_abstract_declarator LEFT_PAREN RIGHT_PAREN {printf("\t Transition: direct_abstract_declarator -> direct_abstract_declarator LEFT_PAREN RIGHT_PAREN\n");}
	| direct_abstract_declarator LEFT_PAREN parameter_type_list RIGHT_PAREN {printf("\t Transition: direct_abstract_declarator -> direct_abstract_declarator LEFT_PAREN parameter_type_list RIGHT_PAREN\n");}
	;

statement
	: labeled_statement {printf("\t Transition: statement -> labeled_statement\n");}
	| compound_statement {printf("\t Transition: statement -> compound_statement\n");}
	| expression_statement {printf("\t Transition:statement -> expression_statement\n");}
	| selection_statement {printf("\t Transition: statement -> selection_statement\n");}
	| iteration_statement {printf("\t Transition: statement -> iteration_statement\n");}
	| jump_statement {printf("\t Transition: statement -> jump_statement\n");}
	;

labeled_statement
	: IDENTIFIER COLON statement {printf("\t Transition: labeled_statement -> IDENTIFIER COLON statement\n");}
	| CASE constant_expression COLON statement {printf("\t Transition: labeled_statement -> CASE constant_expression COLON statement\n");}
	| DEFAULT COLON statement {printf("\t Transition: labeled_statement -> DEFAULT COLON statement\n");}
	;

expression_statement
	: SEMICOLON {printf("\t Transition: expression_statement -> SEMICOLON\n");}
	| expression SEMICOLON {printf("\t Transition: expression_statement -> expression SEMICOLON\n");}
	;

compound_statement
	: LEFT_BRACE RIGHT_BRACE {printf("\t Transition: compound_statement -> LEFT_BRACE RIGHT_BRACE\n");}
	| LEFT_BRACE declaration_list statement_list RIGHT_BRACE {printf("\t Transition: compound_statement -> LEFT_BRACE declaration_list statement_list RIGHT_BRACE\n");}
	| LEFT_BRACE declaration_list RIGHT_BRACE {printf("\t Transition: compound_statement -> LEFT_BRACE declaration_list RIGHT_BRACE\n");}
	| LEFT_BRACE statement_list RIGHT_BRACE {printf("\t Transition: compound_statement -> LEFT_BRACE statement_list RIGHT_BRACE\n");}
	;

statement_list
	: statement {printf("\t Transition: statement_list -> statement\n");}
	| statement_list statement {printf("\t Transition: statement_list -> statement_list statement\n");}
	;

selection_statement
	: IF LEFT_PAREN expression RIGHT_PAREN {generate_temp1(); fprintf(op,"IF false %s goto %s\n",$3,vart2);add_quad($3,vart2,"_","false/goto");push(vart2);} alpha 
	
	| SWITCH LEFT_PAREN expression RIGHT_PAREN statement {printf("\t Transition: selection_statement -> SWITCH LEFT_PAREN expression RIGHT_PAREN statement\n");}
	;

alpha
    : statement { generate_temp1(); 
	              fprintf(op,"goto %s:\n",vart2); 
				  add_quad(vart2,"_","_","JMP");
				  if(TOP!=-1)
				   { 
				     
				     fprintf(op,"%s :\n",stack[TOP]);
					 //add_quad(stack[TOP],"_","_","LAB");
					 strcpy(s[quad],mod_label(stack[TOP]));
					 fprintf(gen,"value of quad %d\n",quad);
					 pop();
				   }
				   push(vart2);
				   
				   } 
	  ELSE statement{ printf("\t Transition: selection_statement -> IF LEFT_PAREN expression RIGHT_PAREN statement ELSE statement\n");
	                  if(TOP!=-1)
					  { 
					    fprintf(op,"%s :\n",stack[TOP]);
						strcpy(s[quad],mod_label(stack[TOP]));
					    pop();
					  }
					 
					 }
	| statement{   printf("\t Transition: selection_statement -> IF LEFT_PAREN expression RIGHT_PAREN statement\n");
	               if(TOP!=-1)
				   {
				      fprintf(op,"%s :\n",stack[TOP]); 
					  strcpy(s[quad],mod_label(stack[TOP]));
					  fprintf(gen,"value of quad %d\n",quad);
					  pop();
				   }
	
	           }
    ;
	
iteration_statement
	: WHILE {generate_temp1(); fprintf(op,"%s :",vart2);push(vart2);strcpy(s[quad],mod_label(vart2));} LEFT_PAREN expression RIGHT_PAREN {generate_temp1(); fprintf(op,"IF false %s goto %s\n",$4,vart2);add_quad($4,vart2,"_","false/goto"); push(vart2);} statement {fprintf(op,"goto %s:\n",stack[TOP-1]); add_quad(stack[TOP-1],"_","_","JMP");fprintf(op,"%s :\n",stack[TOP]); strcpy(s[quad],mod_label(stack[TOP]));pop();pop(); } {printf("\t Transition: iteration_statement -> WHILE LEFT_PAREN expression RIGHT_PAREN statement\n");}
	| DO statement WHILE LEFT_PAREN expression RIGHT_PAREN SEMICOLON {printf("\t Transition: iteration_statement -> DO statement WHILE LEFT_PAREN expression RIGHT_PAREN SEMICOLON\n");}
	| FOR LEFT_PAREN expression SEMICOLON expression SEMICOLON expression SEMICOLON RIGHT_PAREN statement {printf("\t Transition: iteration_statement -> FOR LEFT_PAREN expression SEMICOLON expression SEMICOLON expression SEMICOLON RIGHT_PAREN statement\n");}
	| FOR LEFT_PAREN SEMICOLON expression SEMICOLON expression SEMICOLON RIGHT_PAREN statement  {printf("\t Transition: iteration_statement -> FOR LEFT_PAREN SEMICOLON expression SEMICOLON expression SEMICOLON RIGHT_PAREN statement\n");}
	| FOR LEFT_PAREN expression SEMICOLON SEMICOLON expression SEMICOLON RIGHT_PAREN statement  {printf("\t Transition: iteration_statement -> FOR LEFT_PAREN expression SEMICOLON SEMICOLON expression SEMICOLON RIGHT_PAREN statement\n");}
	| FOR LEFT_PAREN expression SEMICOLON expression SEMICOLON SEMICOLON RIGHT_PAREN statement  {printf("\t Transition: iteration_statement -> FOR LEFT_PAREN expression SEMICOLON expression SEMICOLON SEMICOLON RIGHT_PAREN statement\n");}
	| FOR LEFT_PAREN SEMICOLON SEMICOLON expression SEMICOLON RIGHT_PAREN statement  {printf("\t Transition: iteration_statement -> FOR LEFT_PAREN SEMICOLON SEMICOLON expression SEMICOLON RIGHT_PAREN statement\n");}
	| FOR LEFT_PAREN SEMICOLON expression SEMICOLON SEMICOLON RIGHT_PAREN statement  {printf("\t Transition: iteration_statement -> FOR LEFT_PAREN SEMICOLON expression SEMICOLON SEMICOLON RIGHT_PAREN statement\n");}
	| FOR LEFT_PAREN expression SEMICOLON SEMICOLON SEMICOLON RIGHT_PAREN statement  {printf("\t Transition: iteration_statement -> FOR LEFT_PAREN expression SEMICOLON SEMICOLON SEMICOLON RIGHT_PAREN statement\n");}
	| FOR LEFT_PAREN SEMICOLON SEMICOLON SEMICOLON RIGHT_PAREN statement  {printf("\t Transition: iteration_statement -> FOR LEFT_PAREN SEMICOLON SEMICOLON SEMICOLON RIGHT_PAREN statement\n");}
	;

jump_statement
	: GOTO IDENTIFIER SEMICOLON {printf("\t Transition: jump_statement -> GOTO IDENTIFIER SEMICOLON\n");}
	| CONTINUE SEMICOLON {printf("\t Transition: jump_statement -> CONTINUE SEMICOLON\n");}
	| BREAK SEMICOLON {printf("\t Transition: jump_statement -> BREAK SEMICOLON\n");}
	| RETURN SEMICOLON {printf("\t Transition: jump_statement -> RETURN SEMICOLON\n");}
	| RETURN expression SEMICOLON {printf("\t Transition: jump_statement -> RETURN expression SEMICOLON\n");}
	;

expression
	: assignment_expression {printf("\t Transition: expression -> assignment_expression\n");}
	| expression COMMA assignment_expression {printf("\t Transition: expression -> expression COMMA assignment_expression\n");}
	;

assignment_expression
	: conditional_expression {strcpy($$,$1);printf("\t Transition: assignment_expression -> conditional_expression\n");}
	| unary_expression assignment_Operator assignment_expression { 
	       printf("\t Transition: assignment_expression -> unary_expression assignment_Operator assignment_expression\n");
	       int temp;
		   temp=$2;
		   generate_temp();
		   
		   if(strstr($1,"[")!=NULL)
		   {  
		      
		      switch(temp)
		   {
		      case op_eq:fprintf(op,"%s=%s\n",$1,$3);add_quad($1,$3,"_","=");
			  break;
			  
			  case op_pluseq:fprintf(op,"%s=%s+%s\n%s=%s\n",vart,$1,$3,$1,vart);add_quad(vart,$1,$3,"+");add_quad($1,vart,"_","=");
			  break;
			  
			  case op_subeq:fprintf(op, "%s=%s-%s\n%s=%s\n",vart,$1,$3,$1,vart);add_quad(vart,$1,$3,"-");add_quad($1,vart,"_","=");
			  break;
			  
			  case op_diveq:fprintf(op, "%s=%s/%s\n%s=%s\n",vart,$1,$3,$1,vart);add_quad(vart,$1,$3,"*");add_quad($1,vart,"_","=");
			  break;
			  
			  case op_muleq:fprintf(op , "%s=%s*%s\n%s=%s\n",vart,$1,$3,$1,vart);add_quad(vart,$1,$3,"/");add_quad($1,vart,"_","=");
			  break;
			  
			  default : fprintf(op,"Invalid Operand assignment\n");
		   }
		   strcpy($$,vart);
		   }
		   else
		   {
		   switch(temp)
		   {
		      case op_eq:fprintf(op,"%s=%s\n",$1,$3); add_quad($1,$3,"_","=");
			  break;
			  
			  case op_pluseq:fprintf(op,"%s=%s+%s\n",$1,$1,$3);add_quad($1,$1,$3,"+");
			  break;
			  
			  case op_subeq:fprintf(op, "%s=%s-%s\n",$1,$1,$3);add_quad($1,$1,$3,"-");
			  break;
			  
			  case op_diveq:fprintf(op, "%s=%s/%s\n",$1,$1,$3);add_quad($1,$1,$3,"/");
			  break;
			  
			  case op_muleq:fprintf(op , "%s=%s*%s\n",$1,$1,$3);add_quad($1,$1,$3,"*");
			  break;
			  
			  default : fprintf(op,"Invalid Operand assignment\n");
		   }
		   
		   }
	
	    }
	;

assignment_Operator
	: EQUAL {$$=op_eq;printf("\t Transition: assignment_Operator -> EQUAL\n");}
	| MUL_ASSIGN {$$=op_muleq;printf("\t Transition: assignment_Operator ->  MUL_ASSIGN\n");}
	| DIV_ASSIGN {$$=op_diveq;printf("\t Transition: assignment_Operator -> DIV_ASSIGN\n");}
	| MOD_ASSIGN {printf("\t Transition: assignment_Operator  ->MOD_ASSIGN \n");}
	| ADD_ASSIGN {$$=op_pluseq;printf("\t Transition: assignment_Operator -> ADD_ASSIGN\n");}
	| SUB_ASSIGN {$$=op_subeq;printf("\t Transition: assignment_Operator -> SUB_ASSIGN\n");}
	| LEFT_ASSIGN {printf("\t Transition: assignment_Operator -> LEFT_ASSIGN\n");}
	| RIGHT_ASSIGN {printf("\t Transition: assignment_Operator -> RIGHT_ASSIGN\n");}
	| AND_ASSIGN {printf("\t Transition: assignment_Operator -> AND_ASSIGN\n");}
	| XOR_ASSIGN {printf("\t Transition: assignment_Operator -> XOR_ASSIGN\n");}
	| OR_ASSIGN {printf("\t Transition: assignment_Operator -> OR_ASSIGN\n");}
	;

conditional_expression
	: logical_or_expression {strcpy($$,$1);printf("\t Transition: conditional_expression -> logical_or_expression\n");}
	| logical_or_expression QUES expression COLON conditional_expression {printf("\t Transition: conditional_expression -> logical_or_expression QUES expression COLON conditional_expression\n");}
	;

constant_expression
	: conditional_expression {strcpy($$,$1);printf("\t Transition: constant_expression -> conditional_expression\n");}
	;

logical_or_expression
	: logical_and_expression {strcpy($$,$1);printf("\t Transition: logical_or_expression -> logical_and_expression\n");}
	| logical_or_expression OR_OPERATOR logical_and_expression {generate_temp();strcpy($$,vart);fprintf(op,"%s=%s || %s\n",vart,$1,$3);printf("\t Transition: logical_or_expression ->logical_or_expression OR_OPERATOR logical_and_expression\n");}
	;

logical_and_expression
	: inclusive_or_expression {strcpy($$,$1);printf("\t Transition: logical_and_expression -> inclusive_or_expression\n");}
	| logical_and_expression AND_OPERATOR inclusive_or_expression {generate_temp();strcpy($$,vart);fprintf(op,"%s=%s && %s\n",vart,$1,$3);printf("\t Transition:logical_and_expression  -> logical_and_expression AND_OPERATOR inclusive_or_expression\n");}
	;

inclusive_or_expression
	: exclusive_or_expression {strcpy($$,$1);printf("\t Transition: inclusive_or_expression -> exclusive_or_expression\n");}
	| inclusive_or_expression BIT_OR exclusive_or_expression {printf("\t Transition: inclusive_or_expression -> inclusive_or_expression BIT_OR exclusive_or_expression\n");}
	;

exclusive_or_expression
	: and_expression {strcpy($$,$1);printf("\t Transition: exclusive_or_expression -> and_expression\n");}
	| exclusive_or_expression EX_OR and_expression {printf("\t Transition: exclusive_or_expression -> exclusive_or_expression EX_OR and_expression\n");}
	;

and_expression
	: equality_expression {strcpy($$,$1);printf("\t Transition: and_expression -> equality_expression\n");}
	| and_expression BIT_AND equality_expression {printf("\t Transition: and_expression -> and_expression BIT_AND equality_expression\n");}
	;

equality_expression
	: relational_expression {strcpy($$,$1);printf("\t Transition: equality_expression -> relational_expression\n");}
	| equality_expression EQ_OPERATOR relational_expression {generate_temp();strcpy($$,vart);fprintf(op,"%s=%s==%s\n",vart,$1,$3);add_quad(vart,$1,$3,"==");printf("\t Transition: equality_expression -> equality_expression EQ_OPERATOR relational_expression\n");}
	| equality_expression NE_OPERATOR relational_expression {generate_temp();strcpy($$,vart);fprintf(op,"%s=%s!=%s\n",vart,$1,$3);add_quad(vart,$1,$3,"!=");printf("\t Transition:  equality_expression -> equality_expression NE_OPERATOR relational_expression\n");}
	;

relational_expression
	: shift_expression {strcpy($$,$1);printf("\t Transition:  relational_expression -> shift_expression\n");}
	| relational_expression LESS shift_expression {generate_temp();strcpy($$,vart);fprintf(op,"%s=%s<%s\n",vart,$1,$3);add_quad(vart,$1,$3,"<");printf("\t Transition: relational_expression-> relational_expression LESS shift_expression\n");}
	| relational_expression GREAT shift_expression {generate_temp();strcpy($$,vart);fprintf(op,"%s=%s>%s\n",vart,$1,$3);add_quad(vart,$1,$3,">");printf("\t Transition: relational_expression -> relational_expression GREAT shift_expression\n");}
	| relational_expression LE_OPERATOR shift_expression {generate_temp();strcpy($$,vart);fprintf(op,"%s=%s<=%s\n",vart,$1,$3);add_quad(vart,$1,$3,"<=");printf("\t Transition: relational_expression -> relational_expression LE_OPERATOR shift_expression\n");}
	| relational_expression GE_OPERATOR shift_expression {generate_temp();strcpy($$,vart);fprintf(op,"%s=%s>=%s\n",vart,$1,$3);add_quad(vart,$1,$3,">=");printf("\t Transition: relational_expression -> relational_expression GE_OPERATOR shift_expression\n");}
	;

shift_expression
	: additive_expression {strcpy($$,$1);printf("\t Transition: shift_expression -> additive_expression\n");}
	| shift_expression LEFT_OPERATOR additive_expression {printf("\t Transition: shift_expression -> shift_expression LEFT_OPERATOR additive_expression\n");}
	| shift_expression RIGHT_OPERATOR additive_expression {printf("\t Transition: shift_expression -> shift_expression RIGHT_OPERATOR additive_expression\n");}
	;

additive_expression
	: multiplicative_expression {strcpy($$,$1);printf("\t Transition: additive_expression -> multiplicative_expression\n");}
	| additive_expression ADD multiplicative_expression {generate_temp(); strcpy($$,vart);fprintf(op,"%s=%s + %s \n",$$,$1,$3);add_quad($$,$1,$3,"+");printf("\t Transition: additive_expression -> additive_expression ADD multiplicative_expression\n");}
	| additive_expression SUB multiplicative_expression {generate_temp();strcpy($$,vart);fprintf(op,"%s=%s - %s \n",$$,$1,$3);add_quad($$,$1,$3,"-");printf("\t Transition: additive_expression -> additive_expression SUB multiplicative_expression\n");}
	;

multiplicative_expression
	: cast_expression {strcpy($$,$1);printf("\t Transition: multiplicative_expression -> cast_expression\n");}
	| multiplicative_expression MULT cast_expression {generate_temp(); strcpy($$,vart);fprintf(op,"%s=%s * %s \n",$$,$1,$3);add_quad($$,$1,$3,"*");printf("\t Transition: multiplicative_expression -> multiplicative_expression MULT cast_expression\n");}
	| multiplicative_expression DIV cast_expression {generate_temp(); strcpy($$,vart);fprintf(op,"%s=%s / %s \n",$$,$1,$3);add_quad($$,$1,$3,"/");printf("\t Transition: multiplicative_expression -> multiplicative_expression DIV cast_expression\n");}
	| multiplicative_expression MOD cast_expression {generate_temp(); strcpy($$,vart);fprintf(op,"%s=%s %% %s \n",$$,$1,$3);printf("\t Transition: multiplicative_expression -> multiplicative_expression MOD cast_expression\n");}
	;

cast_expression
	: unary_expression {if(strstr($1,"[")!=NULL){generate_temp();fprintf(op,"%s=%s\n",vart,$1);add_quad(vart,$1,"_","=");strcpy($$,vart);}else{strcpy($$,$1);}printf("\t Transition: cast_expression  -> unary_expression\n");}
	| LEFT_PAREN type_name RIGHT_PAREN cast_expression {printf("\t Transition: cast_expression ->  LEFT_PAREN type_name RIGHT_PAREN cast_expression\n");}
	;

unary_expression
	: postfix_expression {strcpy($$,$1);printf("\t Transition: unary_expression -> postfix_expression\n");}
	| INCREMENT unary_expression {generate_temp();fprintf(op,"%s=%s+1\n",$2,$2);add_quad($2,$2,"1","+");fprintf(op,"%s=%s\n",vart,$2);add_quad(vart,$2,"_","=");strcpy($$,vart);printf("\t Transition: unary_expression -> INCREMENT unary_expression\n");}
	| DECREMENT unary_expression {generate_temp();fprintf(op,"%s=%s-1\n",$2,$2);add_quad($2,$2,"1","-");fprintf(op,"%s=%s\n",vart,$2);add_quad(vart,$2,"_","=");strcpy($$,vart);printf("\t Transition: unary_expression -> DECREMENT unary_expression\n");}
	| unary_Operator cast_expression {generate_temp();strcpy($$,vart);fprintf(op,"%s=%s%s\n",vart,$1,$2); printf("\t Transition: unary_expression -> unary_OPERANDerator cast_expression\n");}
	| SIZEOF unary_expression {printf("\t Transition: unary_expression -> SIZEOF unary_expression \n");}
	| SIZEOF LEFT_PAREN type_name RIGHT_PAREN {printf("\t Transition: unary_expression ->  SIZEOF LEFT_PAREN type_name RIGHT_PAREN\n");}
	;

unary_Operator
	: BIT_AND {printf("\t Transition: unary_Operator -> BIT_AND\n");}
	| MULT {printf("\t Transition: unary_Operator -> MULT\n");}
	| ADD {printf("\t Transition: unary_Operator -> ADD\n");}
	| SUB {strcpy($$,"-");printf("\t Transition: unary_Operator -> SUB\n");}
	| BIT_COMP {printf("\t Transition: unary_Operator -> BIT_COMP\n");}
	| LOG_NOT {printf("\t Transition: unary_Operator -> LOG_NOT\n");}
	;

postfix_expression
	: primary_expression {strcpy($$,$1);printf("\t Transition: postfix_expression -> primary_expression\n");}
	| postfix_expression LSQUARE expression RSQUARE {
	  generate_temp();
	  //char hazard[1000];
	  //strcpy(hazard,vart);
	  //strcpy($$,vart);
	  int trunks;
	  int vegeta;
	  int bulma;
	  char krillin[100];
	  trunks=symtab_search($1);
	  vegeta=symtab[trunks].type;
	  switch(vegeta)
	  {
	    case type_int:bulma=4;
	    break;
	    case type_double:bulma=16;
	    break;
	    case type_float:bulma=8;
	    break;
	    case type_char:bulma=1;
	    break;
		
		default:fprintf(fp,"Invalid data type at line no %d\n",c);
		break;
	  }
	     
	   fprintf(op,"%s=%d*%s\n",vart,bulma,$3);
	   
       
	   add_quad(vart,"three",$3,"*");
	   //itoa(bulma,krillin,10);
	 
	   strcpy($$,$1);
	   strcat($$,"[");
	   strcat($$,vart);
	   strcat($$,"]");
	  printf("\t Transition: postfix_expression -> postfix_expression LSQUARE expression RSQUARE\n");
	  }
	| postfix_expression LEFT_PAREN RIGHT_PAREN {printf("\t Transition: postfix_expression -> postfix_expression LEFT_PAREN RIGHT_PAREN\n");}
	| postfix_expression LEFT_PAREN argument_expression_list RIGHT_PAREN {printf("\t Transition: postfix_expression -> postfix_expression LEFT_PAREN argument_expression_list RIGHT_PAREN\n");}
	| postfix_expression DOT IDENTIFIER {printf("\t Transition: postfix_expression -> postfix_expression DOT IDENTIFIER\n");}
	| postfix_expression PTR_OPERATOR IDENTIFIER {printf("\t Transition: postfix_expression -> postfix_expression PTR_OPERATOR IDENTIFIER\n");}
	| postfix_expression INCREMENT {generate_temp();fprintf(op,"%s=%s\n",vart,$1);add_quad(vart,$1,"_","=");fprintf(op,"%s=%s+1\n",$1,$1);add_quad(vart,$1,"1","+");strcpy($$,vart);printf("\t Transition: postfix_expression ->  postfix_expression INCREMENT\n");}
	| postfix_expression DECREMENT {generate_temp();fprintf(op,"%s=%s\n",vart,$1);add_quad(vart,$1,"_","=");fprintf(op,"%s=%s-1\n",$1,$1);add_quad(vart,$1,"1","-");strcpy($$,vart);printf("\t Transition: postfix_expression -> postfix_expression DECREMENT\n");}
	;

primary_expression
	: IDENTIFIER {if(lookup($1)==0){fprintf(fp ,"Undefined variable Usage at lineno %d\nExiting.....",c);exit(0);}printf("\t Transition:  primary_expression -> IDENTIFIER\n");}
	| constant {strcpy($$,$1);printf("\t Transition:  primary_expression->constant \n");}
	| STRING {printf("\t Transition: primary_expression -> STRING\n");}
	| LEFT_PAREN expression RIGHT_PAREN {strcpy($$,$2);printf("\t Transition: primary_expression -> LEFT_PAREN expression RIGHT_PAREN\n");}
	;

argument_expression_list
	: assignment_expression {printf("\t Transition: argument_expression_list -> assignment_expression\n");}
	| argument_expression_list COMMA assignment_expression {printf("\t Transition: arg_exp_list-> arg_exp_list , asg_expression\n");}
	;
constant
	: INTEGER_CONSTANT {strcpy($$,$1);printf("\t Transition: constant -> INTEGER_CONSTANT\n");}
	| CHAR_CONSTANT {strcpy($$,$1);printf("\t Transition:  constant-> CHAR_CONSTANT\n");}
	| FLOAT_CONSTANT {strcpy($$,$1);printf("\t Transition:  constant-> FLOAT_CONSTANT \n");}
	| ENUMERATION_CONSTANT	{printf("\t Transition: constant -> ENUMERTION_CONSTANT\n");}
	;

%%

#include "lex.yy.c"
int yyerror() {fprintf(fp ,"Invalid grammar on lineno %d \n",c);
fprintf(op ,"Invalid grammar on lineno %d \n",c);
}
int main(int argc, char *argv[])
{
int i;
char input[1000];

yyin=fopen(argv[1],"r");
fp=fopen("10386.out","w");
op=fopen(argv[2],"w");
init_s();
yyparse();
fprintf(fp,"No of entries in symbol table =%d\n",numsym);
fprintf(fp ,"*****************************************************Symbol Table*********************************************************************\n");
for(i=0;i<numsym;i++)
{
    fprintf(fp ,"Line no %d | Variable name %s | Variable value %s | Variable size %d | Variable datatype ",symtab[i].line,symtab[i].name,symtab[i].init, symtab[i].size);
    switch(symtab[i].type)
	{
	   case type_int: fprintf(fp ,"integer ");
	   break;

	   case type_float: fprintf(fp ,"float ");
	   break;

	   case type_short:fprintf(fp ,"short ");
	   break;

	   case type_char:fprintf(fp ,"char ");
	   break;

	   case type_double:fprintf(fp ,"double ");
	   break;

	   case type_signed:fprintf(fp ,"signed ");
	   break;

	   case type_long:fprintf(fp ,"long ");
	   break;

	   case type_unsigned:fprintf(fp ,"unsigned ");
	   break;

	   default : fprintf(fp ,"Function/Void %d<-",symtab[i].type);
	   break;

	}
	if(symtab[i].isarray==1)
	fprintf(fp,"array |\n");
	
	else
	fprintf(fp,"|\n");



}
fclose(yyin);
fclose(fp);
fclose(op);
/* Assignment 4: Code Generation*/

gen=fopen(argv[3],"w");
//print_quad();
//print_s_tab();
generate_code2();

}
void generate_code2()
{
   int i;
   //generate header
   fprintf(gen,"test     start   1000\n");
   
   // for statements
   for(i=0;i<quad;i++)
   {  if(strstr(a_table[i].L1,"[")!=NULL||strstr(a_table[i].R1,"[")!=NULL)
      {  
	    //The loop check for checking arrays within the equation
		int index;
		//fprintf(gen,"L1---->%c%c%c\n",ind_string[0],ind_string[1],ind_string[2]);
		//array occurs on RHS
		if(strstr(a_table[i].R1,"[")==NULL)
		{ 
		  index=getindex(a_table[i].L1);
		//  fprintf(gen,"Index returned is %d string passed is %s\n",index,a_table[i].L1);
		  gcpy_ind(index+1,a_table[i].L1);
		  fprintf(gen,"%s",s[i]);
	      fprintf(gen,"LDX");
		  print_space(5);
		  print_ind_string(index+1,a_table[i].L1);
		  fprintf(gen,"\n");
		  print_space(9);
	      fprintf(gen,"LDA");
		  print_space(5);
		  fprintf(gen,"%s\n",a_table[i].R1);
		  print_space(9);
	      fprintf(gen,"STA");
		  print_space(5);
		  fprintf(gen,"%s,X\n",ind_arr);
		  
		}
		else if(strstr(a_table[i].L1,"[")==NULL)
		{ 
		   if(strcmp(a_table[i].op,"+")==0)
		   {
		     index=getindex(a_table[i].R1);
		     
		     gcpy_ind(index+1,a_table[i].R1);
		     fprintf(gen,"%s",s[i]);
		     fprintf(gen,"LDX");
		     print_space(5);
		     print_ind_string(index+1,a_table[i].R1);
		     fprintf(gen,"\n");
		     print_space(9);
	         fprintf(gen,"LDA");
		     print_space(5);
		     fprintf(gen,"%s,X\n",ind_arr);
			 print_space(9);
		     fprintf(gen,"ADD");
			 print_space(5);
			 fprintf(gen,"%s\n",a_table[i].R2);
			 print_space(9);
			 fprintf(gen,"STA");
			 print_space(5);
			 fprintf(gen,"%s\n",a_table[i].L1);
		   }
		   if(strcmp(a_table[i].op,"=")==0)
		   {
		    index=getindex(a_table[i].R1);
		     
		     gcpy_ind(index+1,a_table[i].R1);
		     fprintf(gen,"%s",s[i]);
		     fprintf(gen,"LDX");
		     print_space(5);
		     print_ind_string(index+1,a_table[i].R1);
		     fprintf(gen,"\n");
		     print_space(9);
	         fprintf(gen,"LDA");
		     print_space(5);
		     fprintf(gen,"%s,X\n",ind_arr);
			 print_space(9);
			 fprintf(gen,"STA");
			 print_space(5);
			 fprintf(gen,"%s\n",a_table[i].L1);
		   
		   }
		   if(strcmp(a_table[i].op,"-")==0)
		   {
		     index=getindex(a_table[i].R1);
		     
		     gcpy_ind(index+1,a_table[i].R1);
		     fprintf(gen,"%s",s[i]);
		     fprintf(gen,"LDX");
		     print_space(5);
		     print_ind_string(index+1,a_table[i].R1);
		     fprintf(gen,"\n");
		     print_space(9);
	         fprintf(gen,"LDA");
		     print_space(5);
		     fprintf(gen,"%s,X\n",ind_arr);
			 print_space(9);
		     fprintf(gen,"SUB");
			 print_space(5);
			 fprintf(gen,"%s\n",a_table[i].R2);
			 print_space(9);
			 fprintf(gen,"STA");
			 print_space(5);
			 fprintf(gen,"%s\n",a_table[i].L1);
		   }
		   if(strcmp(a_table[i].op,"*")==0)
		   {
		     index=getindex(a_table[i].R1);
		     
		     gcpy_ind(index+1,a_table[i].R1);
		     fprintf(gen,"%s",s[i]);
		     fprintf(gen,"LDX");
		     print_space(5);
		     print_ind_string(index+1,a_table[i].R1);
		     fprintf(gen,"\n");
		     print_space(9);
	         fprintf(gen,"LDA");
		     print_space(5);
		     fprintf(gen,"%s,X\n",ind_arr);
			 print_space(9);
		     fprintf(gen,"MUL");
			 print_space(5);
			 fprintf(gen,"%s\n",a_table[i].R2);
			 print_space(9);
			 fprintf(gen,"STA");
			 print_space(5);
			 fprintf(gen,"%s\n",a_table[i].L1);
		   }
		   if(strcmp(a_table[i].op,"/")==0)
		   {
		     index=getindex(a_table[i].R1);
		     
		     gcpy_ind(index+1,a_table[i].R1);
		     fprintf(gen,"%s",s[i]);
		     fprintf(gen,"LDX");
		     print_space(5);
		     print_ind_string(index+1,a_table[i].R1);
		     fprintf(gen,"\n");
		     print_space(9);
	         fprintf(gen,"LDA");
		     print_space(5);
		     fprintf(gen,"%s,X\n",ind_arr);
			 print_space(9);
		     fprintf(gen,"DIV");
			 print_space(5);
			 fprintf(gen,"%s\n",a_table[i].R2);
			 print_space(9);
			 fprintf(gen,"STA");
			 print_space(5);
			 fprintf(gen,"%s\n",a_table[i].L1);
		   }
		
		}
	  }
	  else {
	    if(strcmp(a_table[i].op,"JMP")==0)
		{
		   fprintf(gen,"%s",s[i]);
		   fprintf(gen,"J");
		   print_space(7);
		   fprintf(gen,"%s\n",a_table[i].L1);
		   
		}
	    if(strcmp(a_table[i].op,"false/goto")==0)
		{   /*
		      Remember to put print_space(9) except for the first statement*/ 
		    fprintf(gen,"%s",s[i]);
		    fprintf(gen,"LDA");
			print_space(5);
			fprintf(gen,"%s\n",a_table[i].L1);
			print_space(9);
			fprintf(gen,"COMP");
			print_space(4);
			fprintf(gen,"zero\n");
			print_space(9);
			fprintf(gen,"JEQ");
			print_space(5);
			fprintf(gen,"%s\n",a_table[i].R1);
		
		}
	    if(strcmp(a_table[i].op,"<")==0)
		{
		  fprintf(gen,"%s",s[i]);
		  fprintf(gen,"LDA");
		  print_space(5);
		  fprintf(gen,"one\n");
		  print_space(9);
		  fprintf(gen,"STA");
		  print_space(5);
		  fprintf(gen,"%s\n",a_table[i].L1);
		  print_space(9);
		  fprintf(gen,"LDA");
		  print_space(5);
		  fprintf(gen,"%s\n",a_table[i].R1);
		  print_space(9);
		  fprintf(gen,"COMP");
		  print_space(4);
		  fprintf(gen,"%s\n",a_table[i].R2);
		  print_space(9);
		  fprintf(gen,"JLT");
		  generate_label();
		  print_space(5);
		  fprintf(gen,"%s\n",vart3);
		  print_space(9);
		  fprintf(gen,"LDA");
		  print_space(5);
		  fprintf(gen,"zero\n");
		  print_space(9);
		  fprintf(gen,"STA");
		  print_space(5);
		  fprintf(gen,"%s\n",a_table[i].L1);
		  strcpy(s[i+1],vart3);
		  
		}
		if(strcmp(a_table[i].op,">")==0)
		{
		  fprintf(gen,"%s",s[i]);
		  fprintf(gen,"LDA");
		  print_space(5);
		  fprintf(gen,"one\n");
		  print_space(9);
		  fprintf(gen,"STA");
		  print_space(5);
		  fprintf(gen,"%s\n",a_table[i].L1);
		  print_space(9);
		  fprintf(gen,"LDA");
		  print_space(5);
		  fprintf(gen,"%s\n",a_table[i].R1);
		  print_space(9);
		  fprintf(gen,"COMP");
		  print_space(4);
		  fprintf(gen,"%s\n",a_table[i].R2);
		  print_space(9);
		  fprintf(gen,"JGT");
		  generate_label();
		  print_space(5);
		  fprintf(gen,"%s\n",vart3);
		  print_space(9);
		  fprintf(gen,"LDA");
		  print_space(5);
		  fprintf(gen,"zero\n");
		  print_space(9);
		  fprintf(gen,"STA");
		  print_space(5);
		  fprintf(gen,"%s\n",a_table[i].L1);
		  strcpy(s[i+1],vart3);
		   
		
		}
		if(strcmp(a_table[i].op,"==")==0)
		{
		  fprintf(gen,"%s",s[i]);
		  fprintf(gen,"LDA");
		  print_space(5);
		  fprintf(gen,"one\n");
		  print_space(9);
		  fprintf(gen,"STA");
		  print_space(5);
		  fprintf(gen,"%s\n",a_table[i].L1);
		  print_space(9);
		  fprintf(gen,"LDA");
		  print_space(5);
		  fprintf(gen,"%s\n",a_table[i].R1);
		  print_space(9);
		  fprintf(gen,"COMP");
		  print_space(4);
		  fprintf(gen,"%s\n",a_table[i].R2);
		  print_space(9);
		  fprintf(gen,"JEQ");
		  generate_label();
		  print_space(5);
		  fprintf(gen,"%s\n",vart3);
		  print_space(9);
		  fprintf(gen,"LDA");
		  print_space(5);
		  fprintf(gen,"zero\n");
		  print_space(9);
		  fprintf(gen,"STA");
		  print_space(5);
		  fprintf(gen,"%s\n",a_table[i].L1);
		  strcpy(s[i+1],vart3);
		   
		
		}
      if(strcmp(a_table[i].op,"+")==0)
	  { 
	    int j;
		fprintf(gen,"%s",s[i]);
	    fprintf(gen,"LDA");
		print_space(5);
		fprintf(gen,"%s\n",a_table[i].R1);
		print_space(9);
	    fprintf(gen,"ADD");
		print_space(5);
		fprintf(gen,"%s\n",a_table[i].R2);
		print_space(9);
	    fprintf(gen,"STA");
		print_space(5);
		fprintf(gen,"%s\n",a_table[i].L1);
	  }
	  if(strcmp(a_table[i].op,"-")==0)
	  { 
	    int j;
		fprintf(gen,"%s",s[i]);
	    fprintf(gen,"LDA");
		print_space(5);
		fprintf(gen,"%s\n",a_table[i].R1);
		print_space(9);
	    fprintf(gen,"SUB");
		print_space(5);
		fprintf(gen,"%s\n",a_table[i].R2);
		print_space(9);
	    fprintf(gen,"STA");
		print_space(5);
		fprintf(gen,"%s\n",a_table[i].L1);
	  }
	  if(strcmp(a_table[i].op,"*")==0)
	  { 
	    int j;
		fprintf(gen,"%s",s[i]);
	    fprintf(gen,"LDA");
		print_space(5);
		fprintf(gen,"%s\n",a_table[i].R1);
		print_space(9);
	    fprintf(gen,"MUL");
		print_space(5);
		fprintf(gen,"%s\n",a_table[i].R2);
		print_space(9);
	    fprintf(gen,"STA");
		print_space(5);
		fprintf(gen,"%s\n",a_table[i].L1);
	  }
	  if(strcmp(a_table[i].op,"/")==0)
	  { 
	    int j;
		fprintf(gen,"%s",s[i]);
	    fprintf(gen,"LDA");
		print_space(5);
		fprintf(gen,"%s\n",a_table[i].R1);
		print_space(9);
	    fprintf(gen,"DIV");
		print_space(5);
		fprintf(gen,"%s\n",a_table[i].R2);
		print_space(9);
	    fprintf(gen,"STA");
		print_space(5);
		fprintf(gen,"%s\n",a_table[i].L1);
	  }
	  if(strcmp(a_table[i].op,"=")==0)
	  { 
	    int j;
		fprintf(gen,"%s",s[i]);
	    fprintf(gen,"LDA");
		print_space(5);
		fprintf(gen,"%s\n",a_table[i].R1);
		print_space(9);
	    fprintf(gen,"STA");
		print_space(5);
		fprintf(gen,"%s\n",a_table[i].L1);
	  }
	  if(strcmp(a_table[i].op,">=")==0)
	  {
	      fprintf(gen,"%s",s[i]);
		  fprintf(gen,"LDA");
		  print_space(5);
		  fprintf(gen,"zero\n");
		  print_space(9);
		  fprintf(gen,"STA");
		  print_space(5);
		  fprintf(gen,"%s\n",a_table[i].L1);
		  print_space(9);
		  fprintf(gen,"LDA");
		  print_space(5);
		  fprintf(gen,"%s\n",a_table[i].R1);
		  print_space(9);
		  fprintf(gen,"COMP");
		  print_space(4);
		  fprintf(gen,"%s\n",a_table[i].R2);
		  print_space(9);
		  fprintf(gen,"JLT");
		  generate_label();
		  print_space(5);
		  fprintf(gen,"%s\n",vart3);
		  print_space(9);
		  fprintf(gen,"LDA");
		  print_space(5);
		  fprintf(gen,"one\n");
		  print_space(9);
		  fprintf(gen,"STA");
		  print_space(5);
		  fprintf(gen,"%s\n",a_table[i].L1);
		  strcpy(s[i+1],vart3);
	  
	  }
	  if(strcmp(a_table[i].op,"<=")==0)
	  {
	      fprintf(gen,"%s",s[i]);
		  fprintf(gen,"LDA");
		  print_space(5);
		  fprintf(gen,"zero\n");
		  print_space(9);
		  fprintf(gen,"STA");
		  print_space(5);
		  fprintf(gen,"%s\n",a_table[i].L1);
		  print_space(9);
		  fprintf(gen,"LDA");
		  print_space(5);
		  fprintf(gen,"%s\n",a_table[i].R1);
		  print_space(9);
		  fprintf(gen,"COMP");
		  print_space(4);
		  fprintf(gen,"%s\n",a_table[i].R2);
		  print_space(9);
		  fprintf(gen,"JGT");
		  generate_label();
		  print_space(5);
		  fprintf(gen,"%s\n",vart3);
		  print_space(9);
		  fprintf(gen,"LDA");
		  print_space(5);
		  fprintf(gen,"one\n");
		  print_space(9);
		  fprintf(gen,"STA");
		  print_space(5);
		  fprintf(gen,"%s\n",a_table[i].L1);
		  strcpy(s[i+1],vart3);
	  
	  }
	  
	  
	  }
   
   }
   //end of writing code from quadruple table
   //end line down rsub
   fprintf(gen,".\n");
   // begin variable declaration and initialisation code
   
   fprintf(gen,"three");
   print_space(4);
   fprintf(gen,"word");
   print_space(4);
   fprintf(gen,"3\n");
   fprintf(gen,"one");
   print_space(6);
   fprintf(gen,"word");
   print_space(4);
   fprintf(gen,"1\n");
   fprintf(gen,"zero");
   print_space(5);
   fprintf(gen,"word");
   print_space(4);
   fprintf(gen,"0\n.\n");
   conv_symtab();
   tag_temp();
   fprintf(gen,"%s",s[i]);
   fprintf(gen,"end");
   print_space(5);
   fprintf(gen,"test");
   
   
   
}
void print_space(int a)
{
int i;
for(i=0;i<a;i++)
fprintf(gen," ");
}
void print_quad()
{
   int i;
   printf("No of ENTRIES %d \n",quad);
   printf("Result | OP1 | OPERAND | OP2 |\n");
   for(i=0;i<quad;i++)
   {
     printf("%s   | %s |    %s  |  %s  |\n",a_table[i].L1,a_table[i].R1,a_table[i].R2,a_table[i].op);
   }
}

void add_quad(char l1[],char r1[], char r2[],char oper[])
{
strcpy(a_table[quad].L1,l1);
strcpy(a_table[quad].R1,r1);
strcpy(a_table[quad].R2,r2);
strcpy(a_table[quad].op,oper);
quad++;
}
int getindex(char arr[])
{
int i;
for(i=0;i<strlen(arr);i++)
{
   if(arr[i]=='[')
   return i;
}
return -1;
}
void gcpy_ind(int z,char x[])
{
int i;
//fprintf(gen,"Z value when called ---->%d\n",z);
//fprintf(gen,"Strlen(x) value when called ---->%d\n",strlen(x));
memset(ind_string,0,1000);
memset(ind_arr,0,1000);
for(i=0;i<z-1;i++)
{
  ind_arr[i]=x[i];
}
for(i=z;i<strlen(x)-1;i++)
{   
    ind_string[i]=x[i];
	
}

}
void init_s()
{
int y;
for(y=0;y<1000;y++)
{
  strcpy(s[y],"         ");
}


}
void print_ind_string(int z,char x[])
{
 int i;
 for(i=z;i<strlen(x)-1;i++)
 {
   fprintf(gen,"%c",x[i]);
 }
}
void conv_symtab()
{
  int i;
  
  for(i=1;i<numsym;i++)
  {
     
	 
	 if(strcmp(symtab[i].init,"_")==0)
     {   
	     fprintf(gen,"%s",symtab[i].name);
	     print_space(9-strlen(symtab[i].name));
	     fprintf(gen,"resw");
		 print_space(4);
		 fprintf(gen,"%d\n",symtab[i].size);
	 }
     else 
     {
	    if(symtab[i].isarray==1)
		{  
		   ////printf("ERR_->%!!->%s ^^^^^ %s \n",symtab[i].name,symtab[i].init);
		   write_loop_code(symtab[i].name,symtab[i].init);
		   //printf("MIRACLE\n",symtab[i].name,symtab[i].init);
		
		}
		else
		{ 
		   fprintf(gen,"%s",symtab[i].name);
	      print_space(9-strlen(symtab[i].name));
		  
		  fprintf(gen,"word");
		  print_space(4);
		  fprintf(gen,"%s\n",symtab[i].init);
		
		}
	 
	 }	 
    
  }
  
 // printf("LOOP EXITED\n");
  
}
void tag_temp()
{
  int temp_g=g;
  int i;
  char chz_g[1000],chz_g1[1000];
  for(i=1;i<g;i++)
  {
     //write code for declaring variables
	
    memset(chz_g,0,1000);
    chz_g[0]='T';
    itoa(i,chz_g1,10);
    strcat(chz_g,chz_g1);
    fprintf(gen,"%s",chz_g);	 
    print_space(9-strlen(chz_g));
    fprintf(gen,"resw");
    print_space(4);
    fprintf(gen,"1\n");
  }


}
void generate_label()
{
g2++;
   memset(vart3,0,1000);
   vart3[0]='L';
   vart3[1]='P';
   itoa(g2,buffer3,10);
   strcat(vart3,buffer3);
   printf("Length %d \n",strlen(vart3));
   while(strlen(vart3)!=9)
   {
      strcat(vart3," ");
   }
   printf("Length after %d \n",strlen(vart3));

}
char *mod_label(char x[])
{
   char *g;
   while(strlen(x)!=9)
   {
       strcat(x," ");
   }
   g=x;
   return g;

}
void print_s_tab()
{
 int i;
 //fprintf(gen,"This is the label table(wow that rhymes..)\n");
 for(i=0;i<quad;i++)
 {
     fprintf(gen,"label %s at %d\n",s[i],i);
 }

}
void write_loop_code(char name[], char value[])
{
   char data[100][10];
   int i=0,j=0,k=0;
   char buf_name[100];
   char buf_value[100];
   int v=0;
   int l=0;
   //printf("%s The value string \n",value);
   while(i<strlen(value))
   {
        
		
		while(value[j]!=','&&j<strlen(value))
		{ 
          data[l][v]=value[j];
		  v++;
		  j++;
		  //printf("incr %d \n",v);
		}
		if(j>strlen(value))
		break;
		j++;
		v=0;
		i++;
		l++;
        //printf("VALUE OF I %d J %d and %d\n",i,j,v);
		
   }
   //printf("THe data table and no of entries %d\n",l);
   int n;
  /* for(n=0;n<l;n++)
   {
     printf("gg-->%s \n",data[n]);
   }
 */
  for(i=0;i<l;i++)
  {
     strcpy(buf_name,name);
	 
	 if(i!=0)
	 {
	     itoa(i,buf_value,10);
         strcat(buf_name,buf_value);		 
	 }
    fprintf(gen,"%s",buf_name);
	print_space(9-strlen(buf_name));
	fprintf(gen,"word");
	print_space(4);
	int h;
	for(h=0;h<strlen(data[i]);h++)
	fprintf(gen,"%c",data[i][h]);
	
	fprintf(gen,"\n");
	
  }
}