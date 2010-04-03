require File.dirname(__FILE__) + '/../lib/trie'

describe Trie do
  context '#add' do
    it 'should return the trie' do
      trie = Trie.new
      trie.add('abc123').should == trie
    end
    
    it 'should add the specified string to the trie' do
      trie = Trie.new
      trie.add('abc123')
      trie.should include('abc123')
    end
  end

  context '#<<' do
    it 'should add the specified string to the trie' do
      trie = Trie.new
      trie << 'abc123'
      trie.should include('abc123')
    end
  end

  context '#delete(key)' do
    it 'should return nil if the specified key is not in the trie' do
      trie = Trie.new
      trie.delete('abc').should be_nil
    end
    
    it 'should return the specified key if it\'s in the trie' do
      trie = Trie.new
      trie.add('abc')
      trie.delete('abc').should == 'abc'
    end
    
    it 'should remove the specified key from the trie' do
      trie = Trie.new
      trie.add('abc')
      trie.add('def')
      trie.delete('abc')
      trie.should_not include('abc')
    end
    
    it 'should reduce the size of the trie appropriately' do
      trie = Trie.new
      trie.add('abc')
      trie.add('def')
      trie.delete('abc')
      trie.size.should == 1
    end
    
    it 'should remove the specified key from the trie, even if it\'s a sub-key' do
      trie = Trie.new
      trie.add('abc')
      trie.add('abcdef')
      trie.delete('abc')
      trie.should_not include('abc')
      trie.should include('abcdef')
      trie.size.should == 1
    end
  end

  context '#include?' do
    it 'should return true if the specified string has been added to the trie' do
      trie = Trie.new
      strings = ['abc', 'def', 'ghi', 'jkl', 'mno']
      strings.each{|string| trie.add(string)}
      trie.include?('abc').should be_true
    end
    
    it 'should return false if the specified string has not been added to the trie' do
      trie = Trie.new
      strings = ['abc', 'def', 'ghi', 'jkl', 'mno']
      strings.each{|string| trie.add(string)}
      trie.include?('notthere').should be_false
    end
    
    it 'should not return true for substrings that were not explicitly added' do
      trie = Trie.new
      trie.add('abcdef')
      trie.include?('abc').should be_false
    end
    
    it 'should return true for substrings that were explicitly added' do
      trie = Trie.new
      trie.add('abcdef')
      trie.add('abc')
      trie.include?('abc').should be_true
    end
  end

  context '#each' do
    it 'should yield each element that was added to the trie' do
      trie = Trie.new
      strings = ['abc', 'def', 'ghi', 'jkl', 'mno', 'abcdef']
      strings.each{|string| trie.add(string)}
      trie.each{|string| strings.delete(string).should_not be_nil}
      strings.should be_empty
    end
  end
  
  context '#size' do
    it 'should return the number of added strings' do
      trie = Trie.new
      trie.add('abcdef')
      trie.add('abcdef')
      trie.add('abc')
      trie.add('def')
      trie.size.should == 3
    end
  end
  
  context '#prefixed_by(prefix)' do
    it 'should return an array' do
      Trie.new.prefixed_by('abc').should be_a_kind_of(Array)
    end

    it 'should return a trie that includes all keys that have the specified prefix' do
      trie = Trie.new
      trie.add('abc1')
      trie.add('abc2')
      trie.add('def456')
      strings = trie.prefixed_by('abc')
      strings.should include('abc1')
      strings.should include('abc2')
    end

    it 'should include the prefix if it is itself a key' do
      trie = Trie.new
      trie.add('abc')
      trie.add('abc1')
      trie.prefixed_by('abc').should include('abc')
    end

    it 'should return an empty array if no key has the specified prefix' do
      trie = Trie.new
      trie.add 'abc'
      trie.prefixed_by('def').should be_empty
    end
  end
  
  context '#to_array' do
    it 'should return an array' do
      Trie.new.to_array.should be_a_kind_of(Array)
    end
    
    it 'should return a sorted array containing each of the added keys' do
      trie = Trie.new
      trie.add('ghi')
      trie.add('abc')
      trie.add('def')
      trie.to_array.should == ['abc', 'def', 'ghi']
    end
  end
end