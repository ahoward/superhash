require 'superhash'

# Example of using SuperHashes inside regular objects (not classes).
# This example was distilled from the SuperML project.

class AttributedNode

  attr_reader :attributes, :parents, :children

  # creates a node and gives it a first parent
  def initialize(parent = nil)
    @attributes = SuperHash.new(parent && parent.attributes)
    @parents = parent ? [parent] : []
    @children = []
  end

  # adds more parents, which will also contribute attributes
  def add_parent(parent)
    unless @parents.include? parent
      @parents << parent
      @attributes.parents << parent.attributes
    end
    self
  end
  protected :add_parent

  def add_child(child)
    @children << child
    child.add_parent(self)
    self
  end

end

# This might be the description of a window using some (imaginary)
# GUI construction library.

root = AttributedNode.new
  root.attributes[:type]        = :top_window
  root.attributes[:name]        = "Feature request window"
  root.attributes[:bg_color]    = "gray"
  root.attributes[:font_face]   = "Courier"
  root.attributes[:font_size]   = 10

user_field = AttributedNode.new
  root.add_child(user_field)
  user_field.attributes[:type]      = :text_box
  user_field.attributes[:name]      = "Username box"
  user_field.attributes[:label]     = "Name:"

feature_field = AttributedNode.new
  root.add_child(feature_field)
  feature_field.attributes[:type]      = :text_box
  feature_field.attributes[:name]      = "Feature description box"
  feature_field.attributes[:bg_color]  = "white"
  feature_field.attributes[:label]     = "Please enter your request below:"
  feature_field.attributes[:font_face] = "Times"
  feature_field.attributes[:font_size] = 12


# So then we have:

p user_field.attributes[:bg_color]      # ==> "gray"
p feature_field.attributes[:bg_color]   # ==> "white"

p user_field.attributes[:font_size]     # ==> 10
p feature_field.attributes[:font_size]  # ==> 12


# You could even manage another set of attributes of the same objects using
# multiple inheritance, such as attributes pertaining to form entry content:

form_entry = AttributedNode.new
  form_entry.attributes[:default_contents]    = "enter text here"
  form_entry.attributes[:reject_condition]    = /[^\w,.;:?!]/

  form_entry.add_child(user_field)
  user_field.attributes[:default_contents]    = "fred"

  form_entry.add_child(feature_field)
  feature_field.attributes[:reject_condition] = /more like Microsoft/

p feature_field.attributes[:default_contents] # ==> "enter text here"
