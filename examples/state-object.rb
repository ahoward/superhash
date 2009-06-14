require 'superhash'

# Example of using SuperHashes in class instance variables to extend Ruby's
# inheritance mechanism. This can be expressed automatically using the
# Class#class_superhash methods defined in superhash.rb.
#
# This example is vaguely derived from the RedShift project. Subclasses
# of StateObject have a set of states that their instances may be in. Each
# state is mapped to a state action. Subclasses inherit the mapping, and may
# add to it and override it.

class StateObject

  # class vars and class methods

  @state_actions = {}
    # root hash for child class's superhash that maps state => action

  class << self
    def state_actions
      @state_actions ||= SuperHash.new(superclass.state_actions)
    end

    def define_state_action(state, &action)
      state_actions[state] = action
    end
    alias in_state define_state_action
  end

  define_state_action :no_op    # all subclasses inherit this state

  # instance methods

  def state_actions
    self.class.state_actions
  end

  def states
    state_actions.keys
  end

  attr_reader :cur_state

  def cur_state=(target_state)
    unless states.include? target_state
      raise "No way, dude. That's not a cool state for " +
            "me to be in right now."
    end
    @cur_state = target_state
    @cur_action = state_actions[target_state]
  end

  def run
    @cur_action.call if @cur_action
  end

  def initialize(start_state = :no_op)
    self.cur_state = start_state
  end
end

class Computer < StateObject
  in_state :off do
    puts "Power off."
  end

  in_state :on do
    puts "Power on."
  end
  
  in_state :boot do
    puts "Can't boot -- no OS."
  end
end

class WindowsNTBox < Computer
  # Add a new state, and its action.
  in_state :crashed do
    puts "Blue screen!"
  end
  
  # Override an inherited state.
  in_state :boot do
    puts "Booting Windows NT."
  end
end

pc = WindowsNTBox.new

seq = [:off, :on, :boot, :crashed, :off]

for state in seq
  pc.cur_state = state
  pc.run
end
