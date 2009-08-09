$inLine = false
$inFunction = false

#checkVariable
def cV(token)
	if token.class == Literal and token.type == :NAME
		$varManager[token.value]
	end
	return token
end

class Binary
  attr_accessor :op, :left, :right
  
  def initialize(left, op, right)
    @left = cV left
    @right = cV right
    @op = op
  end
  
  def repr
    return "#{@left.repr} #{@op} #{@right.repr}"
  end
end

class Braces
	attr_accessor :content

	def initialize(content)
		@content = cV content
	end

	def repr
		return "( #{@content.repr})"
	end
end

class ArrayGet
	attr_accessor :variable, :index

	def initialize(variable, index)
		@variable = cV variable
		@index = cV index
	end

	def repr
		return "#{@variable.repr}[#{@index.repr}]"
	end
end

class Call
	attr_accessor :name, :arglist

	def initialize(name, arglist)
		@name = name
		@arglist = arglist.each do |t|
			cV t #good code
		end
		
	end

	def repr
		i = $inLine
		$inLine = true
		#for testing
		args = @arglist.map{|t| t.repr}.join ","
		#arg = @arglist.join ","
		if not i
			#TODO: fixme
			return "call #{@name.repr}(#{args})"
			$inLine = false
		else
			return "#{@name.repr}(#{args})"
		end
	end
end

class VariableAssignment
	attr_accessor :name, :content

	def initialize(name, content)
		@name = cV name
		@content = cV content
	end

	def repr
		return "set #{@name.repr} = #{@content.repr}"
	end
end

class Literal
	attr_accessor :type, :value
	def initialize(type, value)
		@type = type
		@value = value
	end

	def repr
		return "#{@value}"
	end
end

class Unary
  attr_accessor :op, :right
  
  def initialize(op, right)
    @op = op
    @right = cV right
  end
  
  def repr
    return "#{@op} #{@right.repr}"
  end
end
  
class Variable
  attr_accessor :type, :name
  
  def initialize(type, name)
    @type = type
    @name = name
	$varManager.newVariable(self)
  end
  
  def repr
    return @name
  end
end


class VariableLayer
  attr_accessor :vars

  def initialize
    @vars = {}
  end
  
  def [](index)
    return @vars[index]
  end
  
  def []=(index, value)
    @vars[index] = value
  end
end

class VariableManager
  attr_accessor :stack
  
  def initialize
    @stack = [VariableLayer.new]
  end
  
  def scope
    @stack.push VariableLayer.new
  end
  
  def endscope
    @stack.pop
  end
  
  def[](index)
    stack.reverse.each do |t|
      if t[index] != nil
        return t[index]
      end
    end
    raise "Unkown Variable #{@index}"
  end
  
  def newVariable(var)
    @stack[-1][var.name] = var
  end
end

$varManager = VariableManager.new

Variable.new("int", "abc").repr
puts Call.new(Literal.new(:NAME, "BJDebugMsg"), [Literal.new(:NAME, "abc"), Call.new(Literal.new(:NAME, "I2S"), [Literal.new(:INT, 5)])]).repr


#v = VariableManager.new
#v.newVariable "int", "xyz"
#v.scope
#v.newVariable("int", "abc")
#v["abc"]
#v["xyz"]
#v.endscope
#v["abc"]
