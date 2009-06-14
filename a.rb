
class A
  class_superhash :attributes

  attributes[:key] = :val
end

class B < A
end

p A.attributes.to_hash
p B.attributes.to_hash
B.attributes[:a]=:b
p A.attributes.to_hash
p B.attributes.to_hash
A.attributes[:b]=:a
p A.attributes.to_hash
p B.attributes.to_hash
