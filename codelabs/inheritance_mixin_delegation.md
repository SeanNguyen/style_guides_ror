# Inheritance vs. Mixin vs. Delegation

This example gives you a generic view of three common ways of sharing code among classes/methods.

## Inheritance

### Example

```ruby
class Parent
  def method_to_share
    'From class Parent'
  end
end

class Child < Parent
end

Child.new.method_to_share # => From class Parent
```

### Pros

* Useful when you have a hierarchical inheritance in your design.
* Every children can use the shared methods. Easy to use.

### Cons

* Every children can use the shared methods. Can lead to spaghetti code.
* Ruby does not allow multiple inheritance.
* Even if it did, it can cause [the diamond problem].

[the diamond problem]: https://en.wikipedia.org/wiki/Multiple_inheritance#The_diamond_problem

## Mixin

### Example

```ruby
require 'active_support'

module Speakable
  extend ActiveSupport::Concern

  included do
    def say(something)
      "#{something} from Speakable"
    end
  end
end

class Person
  include Speakable
end

Person.new.say('Hello') # => Hello from Speakable"
```

### Pros

* You can just apply to the classes that need it.

### Cons

* Even if you can divid you lines into small files. It doesn't change the fact that the class/instance has a lot of methods.
* Hard to find method source without a code navigation tool.
* Hard to test (you need to fulfill a lot of dependancies before you can trigger the method)

### Notes

* Avoid depending on class status in a module
* Ruby naming convention for mixin is `-able`, For example, `Speakable`.
* See also [separation of concerns]

[separation of concerns]: https://en.wikipedia.org/wiki/Separation_of_concerns

## Delegation

### Example

```ruby
class Mouth
  def initialize(person)
    @person = person
  end

  def make_sound(something)
    "#{something} by #{@person} from Mouth class"
  end
end

class Person
  def say(something)
    Mouth.new(self).make_sound(something)
  end

  def to_s
    "someone"
  end
end

Person.new.say('Hello') # => Hello by someone from Mouth class
```

### Pros

* Small classes.
* Easy to test.
* Easy to orgnized code.
* Easy to trace to method source.

### Cons

* Slightly more code.
* More small files need to be managed.

### Notes

* [Service object] is an application of delegation. Which we use a lot.

[Service object]: https://blog.engineyard.com/2014/keeping-your-rails-controllers-dry-with-services

## Conclusion

None of above is always best option. Find out what fits your requirement the best case by case.

When you cannot decide. Prefer Delegation > Mixin > Inheritance.
