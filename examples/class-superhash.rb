require 'superhash'

class A
  class_superhash :options
  
  options[:foo] = "A foo"
  options[:bar] = "A bar"
  
  def options; self.class.options; end
end

class B < A
  options[:foo] = "B foo"
end

p A.options
p B.options.to_hash
p B.new.options.to_hash

__END__

output:

{:foo=>"A foo", :bar=>"A bar"}
{:foo=>"B foo", :bar=>"A bar"}
{:foo=>"B foo", :bar=>"A bar"}
