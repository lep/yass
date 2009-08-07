class String

	def bin
		ret=0
		self.each_char do |t|
			ret=ret*2+t.to_i
		end
		return ret
	end

	def rawcode
		ret=0
		self.each_char do |t|
			ret=(ret<<8)+t[0]
		end
		return ret
	end

end

def parse(str)
	@q=[]
	until str.empty?
		case str
		when /\A\d+\.\d+/
		when /\A\d+\./
		when /\A\.\d+/
			@q.push [:FLOAT, $&.to_f]
		when /\A\d+/
			@q.push [:INT, $&.to_i]
		when /0x[a-fA-F0-9]+/
			@q.push [:INT, $&.hex]
		when /0o([0-7])+/
			@q.push [:INT, $1.oct]
		when /0b([01])+/
			@q.push [:INT, $1.bin]
		when /\A[']([\x01-\x26\x29-\x5B\x5D-\x7F]
		(	[\x01-\x26\x29-\x5B\x5D-\x7F][\x01-\x26\x29-\x5B\x5D-\x7F]
			[\x01-\x26\x29-\x5B\x5D-\x7F])?)[']/x
			@q.push [:INT, $1.rawcode]
		when /\A("[^"]")/ #TODO: fix me
			@q.push [:STRING, $1]
		when /\Ascope/
			@q.push [:SCOPE, nil] #is nil needed?
		when /\Afun/
			@q.push [:FUN, nil]
		when /\Aarray/
			@q.push [:ARRAY, nil]
		when /\Aif/
			@q.push [:IF, nil]
		when /\Aelseif/
			@q.push [:ELSEIF, nil]
		when /\Aelse/
			@q.push [:ELSE, nil]
		when /\Aloop/
			@q.push [:LOOP, nil]
		when /\Aexitwhen/
			@q.push [:EXITWHEN, nil]
		when /\Abreak/
			@q.push [:BREAK, nil]
		when /\Areturn/
			@q.push [:RETURN, nil]
		when /\Aand/
			@q.push[:AND, nil]
		when /\Aor/
			@q.push [:OR, nil]
		when /\Anot/
			@q.push [:NOT, nil]
		when /\A[a-zA-Z_?!]([a-zA-Z0-9_?!])*/
			@q.push [:NAME, $&]
		when /\A(::)?[a-zA-Z_?!]([a-zA-Z0-9_?!])*
				(::[a-zA-Z_?!]([a-zA-Z0-9_?!])*)*/x
			@q.push [:IDENTIFER, $&]
		when /\A(!=)|(<=)|(>=)|(==)|[-+*\/()\[\],:=<>]/
			@q.push [$&, $&]
		when /\A;/
			@q.push [:END, nil]
		when /\A\n/
			@q.push [:EOL, nil]
		#ignored
		when /\A[ \t]/
		when /\A\\\n/
		when /\A#.*\n/
		else
			raise "Unknown character"
		end
		str=$'
	end
	return @q;
end


parse("asdf if else  if else ()").each do |t|
    puts t[0]
end
