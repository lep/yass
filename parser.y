class YassParser
rule

	literal		:	INT 
				|	FLOAT
				|	STRING

	expression	:	literal
				|	IDENTIFER
				|	braces
				|	binary
				|	unary
				|	array_get
				|	call

	braces		:	"(" expression ")"

	binary		:	expression "+" expression
				|	expression "-" expression
				|	expression "*" expression
				|	expression "/" expression
				|	expression "==" expression
				|	expression "!=" expression
				|	expression ">=" expression
				|	expression "<=" expression
				|	expression ">" expression
				|	expression "<" expression
				|	expression AND expression
				|	expression OR expression

	unary		:	"-" expression
				|	NOT expression

	array_get	:	expression "[" expression "]"

	call		:	expression "(" arg_list ")"

	arg_list	:	expression
				|	expression "," arg_list

	variable	:	IDENTIFER

	set			:	variable var_assignment

	var_assignment:	"=" expression

	scope		:	SCOPE IDENTIFER

	name_list	:	/*nothing*/
				|	"," NAME
				|	"," NAME name_list


	parameter_list:	/*nothing*/
				|	variable NAME name_list
				|	variable NAME name_list "," parameter_list


	function	:	FUN NAME "(" parameter_list ")"
				|	FUN NAME "(" parameter_list ")" ":" variable
				
	line_word	:	scope
				|	function
				|	call
				|	set
				|	var_definition
				|	EXITWHEN expression
				|	IF expression
				|	ELSEIF expression
				|	ELSE

	line		:	line_word EOL
				|	line_word end_scope


	var_declaration:	ARRAY NAME
				|		NAME

	var_assignment:	"=" expression

	var_decl_assign:	var_declaration
				|		var_declaration var_assignment

	var_decl_assign_list:	/*nothing*/
				|			"," var_decl_assign var_decl_assign_list

	var_definition:	variable var_decl_assign
				|	variable var_decl_assign var_decl_assign_list

	#TODO: fix this
	end_scope	:	END
				|	END end_scope
				|	END EOL

	main		:	/*nothing*/
				|	EOL
				|	line main

end

