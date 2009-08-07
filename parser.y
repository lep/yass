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
	arg_list	:	expression ("," arg_list)?
	variable	:	IDENTIFER
				|	NAME
	set			:	variable var_assignment
	var_assignment:	"=" expression
	scope		:	SCOPE NAME
	parameter_list:	variable NAME ("," NAME)* ("," parameter_list)?
	function	:	FUN NAME "(" parameter_list ")" (":", variable)?
	line		:	(	scope
					|	function
					|	call
					|	set
					|	var_definition
					|	EXITWHEN expression
					) (END | EOL)


end

