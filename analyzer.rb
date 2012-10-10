#!/usr/bin/env ruby
$lexeme = Array.new()
def nextToken()
	$lexeme.last
end

def popToken()
	$lexeme.pop
end	
def comp_operator()
	"COMPARE_OP|GREATERTHAN|LESSTHAN|GREATERTHAN_OREQUAL|LESSTHAN_OREQUAL"
end

def evaluateNextToken(condition)
		#nextToken =~ /#{condition}/ ? true : false
		if nextToken() =~ /#{condition}/
			temp = popToken()
			puts "#{temp} satisfies #{condition}"
			return true 
		else
			return false
		end
end

#	generated by the rule:   <expr> → <term> {( + | - ) <term>}
def expr()
	puts "Enter<expr>"
	term()
	while (evaluateNextToken("ADD|SUBTRACT")) do
		term()
	end
	puts "Exit<expr>"
end

# 	   generated by the rule: <term> → <factor> {( * | / ) <factor> }
def term() 
	puts "Enter<term>"
	factor()
	while (evaluateNextToken("MULTIPLY|DIVIDE")) do 
		factor()
	end
	puts "Exit<term>"
end

def error(error)
	puts "ERROR: #{error}"
end

# <factor> -> id  |  (<expr>)
def factor() 
	puts "Enter<factor>"
	if evaluateNextToken("IDENTIFIER")
		
	elsif evaluateNextToken("OPENPAREN")
		expr()
		if evaluateNextToken("CLOSEPAREN") 
			
		else
			error("Missing Close Parenthesis")	
		end
	else
		error("Right Hand Side Doesn't Match") #Right Hand Side Doesn't Match
	end
	puts "Exit<factor>"
end

# <boolean_expr> -> <expr> {(== | != | && | '||' | < | > | <= | >= ) <expr>}
def boolean_expr()
	puts "Enter<boolean_expr>"
	expr()
	if evaluateNextToken(comp_operator())
		expr()		
	else
		error("Expecting a boolean comparison!")
	end	
	puts "Exit<boolean_expr>"
end
#  <statement> -> <expr> {(=) <expr>}
def statement()
	puts "Enter<statement>"
	expr()
	if evaluateNextToken("ASSIGNOP")
		expr()
		if evaluateNextToken("END_STMNT")

		else
			error("expecting END_STMNT")
		end
	elsif evaluateNextToken("END_STMNT")

	else
		error("expecting an operator")
	end
	puts "Exit<statement>"
end

#/* Function ifstmt
#Parses strings in the language generated by the rule:
#<ifstmt> -> if (<boolexpr>) <statement>
#[else <statement>]
#*/

def if_statement()
	if (evaluateNextToken("IF_STMNT"))
		if evaluateNextToken("OPENPAREN")
			boolean_expr()
			if evaluateNextToken("CLOSEPAREN") 
				statement()

				if evaluateNextToken("ELSE")
					statement()
				end

				# Exit part!
				if evaluateNextToken("END_IF")

				else
					error("EXPECTING END_IF")
				end

			else
				error("Missing Close Parenthesis")	
			end
		else
			error("Missing Open Parenthesis") #Right Hand Side Doesn't Match
		end

	else
		error("The first token is not if")
	end
end

def forloop()
	if (evaluateNextToken("FORLOOP"))
		if evaluateNextToken("OPENPAREN")
				statement()
			
				if evaluateNextToken(comp_operator)
					statement()
				else

				puts "Missing comparison operator"
				end

				if evaluateNextToken("ADD|SUBTRACT|MULTIPLY|DIVIDE")
					statement()
				end


				if !(evaluateNextToken("CLOSEPAREN"))
					error("Missing Close Parenthesis")	
				end
				statement()
				if !(evaluateNextToken("ENDLOOP"))
					error("Missing End Loop")
				end
		else
			error("Missing Open Parenthesis") #Right Hand Side Doesn't Match
		end

	else
		error("The first token is not for")
	end

end

def parseFile()
		#local_filename = "" #lexeme file
		#lexeme = []
		#File.open(local_filename, 'w') {|f| f.write(doc) }
		#open('a.txt').each do |line|
	  	#results << line.split('\n')

	  	array_in_line = Array.new

	  	array_in_line = ["IDENTIFIER", "ASSIGNOP", "IDENTIFIER", "ADD", "IDENTIFIER", "END_STMNT"]
	  	evaluate_line(array_in_line)


	  	# this = this * (this / that)
	  	array_in_line_with_division = ["IDENTIFIER", "ASSIGNOP", "IDENTIFIER","MULTIPLY","OPENPAREN",
	  		"IDENTIFIER", "DIVIDE", "IDENTIFIER","CLOSEPAREN" ,"END_STMNT"]
	  		evaluate_line(array_in_line_with_division)
	  	array_in_line_with_if = ["IF_STMNT", "OPENPAREN","IDENTIFIER", "ADD" , "IDENTIFIER", "LESSTHAN", "IDENTIFIER","CLOSEPAREN","IDENTIFIER", "ASSIGNOP", "IDENTIFIER", "ADD", "IDENTIFIER", "END_STMNT", "END_IF" ]
	  	evaluate_line(array_in_line_with_if)
	  	array_in_line_with_for = ["FORLOOP", "OPENPAREN", "IDENTIFIER", "END_STMNT", "LESSTHAN", "IDENTIFIER", "ADD", "IDENTIFIER", "END_STMNT",
	  	 "ADD", "IDENTIFIER", "DIVIDE", "IDENTIFIER", "END_STMNT", "CLOSEPAREN", "IDENTIFIER", "ASSIGNOP", "IDENTIFIER", "SUBTRACT", "IDENTIFIER", "END_STMNT", "ENDLOOP"]
	 	evaluate_line(array_in_line_with_for)

	 	puts "Bad If Statement\n"
	 	array_in_line_bad_if = ["IF_STMNT", "OPENPAREN","IDENTIFIER", "ADD" , "IDENTIFIER", "LESSTHAN", "IDENTIFIER","CLOSEPAREN","ASSIGNOP", "IDENTIFIER", "ADD", "IDENTIFIER", "END_STMNT", "END_IF" ]
	 	evaluate_line(array_in_line_with_for)
end



def evaluate_line(array_in_line)
	$lexeme = Array.new
	puts "Evaluating The Line"
	$lexeme = array_in_line
	puts $lexeme.join(" ")

	$lexeme = array_in_line.reverse!
	first = $lexeme.last
	if first =~ /IF_STMNT/
		if_statement()
	elsif first =~ /FORLOOP/
		forloop()
	else
		statement()
	end

	puts "Finished Evaluating\n"
end
parseFile()