class Trie
  include Enumerable
  
  attr_accessor :size
  
  def initialize
    @children = {}
    @terminal = false
    @size = 0
  end
  
  def add(key)
    visit_node(key) do |node, remainder|
      if remainder.empty?
        if !node.terminal?
          node.terminal!
          @size += 1
        end
      else
        node.append(remainder)
        @size += 1
      end

      self
    end
  end
  alias_method :<<, :add

  def delete(key)
    visit_node(key[0..-2]) do |node, remainder|
      if remainder.empty? and node.prune(key[-1])
        @size -= 1
        key
      end
    end
  end  
  
  def include?(key)
    visit_node(key) do |node, remainder|
      remainder.empty? and node.terminal?
    end
  end

  def prefixed_by(prefix)
    visit_node(prefix) do |node, remainder|
      remainder.empty? ? node.to_array(prefix) : []
    end
  end

  def each
    yield '' if terminal?

    @children.keys.sort.each do |value|
      @children[value].each{|key| yield Trie.join(value, key)}
    end
  end

  def to_array(prefix = '')
    array = []
    each{|key| array << prefix + key}
    array
  end

  def inspect
    "#<Trie: {#{to_array.join(', ')}}>"
  end

  protected
    def self.shift(key)
      [key[0], key[1..-1]]
    end

    def self.join(value, key)
      key.is_a?(String) and value.respond_to?(:chr) ?
        value.chr + key : key.unshift(value)
    end

    def visit_node(key, &block)
      car, cdr = Trie.shift(key) unless key.empty?
      if child = @children[car]
        child.visit_node(cdr, &block)
      else
        block.call(self, key)
      end
    end
    
    def append(key)
      car, cdr = Trie.shift(key)
      if car
        @children[car] = Trie.new
        cdr.empty? ? @children[car].terminal! : @children[car].append(cdr)
      end
    end
    
    def prune(value)
      child = @children[value]
      if child.terminal?
        child.leaf? ? @children.delete(value) : child.internal!
        child
      end
    end

    def terminal!
      @terminal = true
    end
    
    def internal!
      @terminal = false
    end
    
    def terminal?
      @terminal
    end
    
    def leaf?
      !@children.any?
    end
end
