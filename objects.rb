class Binary
  attr_accessor :op, :left, :right
  
  def initialize(left, op, right)
    @left = left
    @right = right
    @op = op
  end
  
  def repr
    return "#{@left.repr} #{@op} #{@right.repr}"
  end
end

class Unary
  attr_accessor :op, :right
  
  def initialize(op, right)
    @op = op
    @right = right
  end
  
  def repr
    return "#{@op} #{@right.repr}"
  end
end
  
class Variable
  attr :type, :name
  
  def initialize(type, name)
    @type = type
    @name = name
  end
  
  def repr
    return @name
  end
end

class VariableLayer
  attr :vars

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
  attr :stack
  
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
    raise "Unkown Variable"
  end
  
  def newVariable(type, name)
    @stack[-1][name] = Variable.new(type, name)
  end
end


v = VariableManager.new
v.newVariable "int", "xyz"
v.scope
v.newVariable("int", "abc")
v["abc"]
v["xyz"]
v.endscope
v["abc"]