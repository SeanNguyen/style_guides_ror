# Pundit Best Practices

## Background

* As time of writing this. Pundit doesn't support namespace properly. So we only use it in admin panel (`app/controller/admin/`)
* This is not the only good practice of using pundit. But I try to make it easier to maintain, harder to make mistake.
* Basic assumptions are:
  * Minimum reuse of policies. So very easy to find the corresponding policy.
  * Minimum reuse of rules. So won't get surprised by policy inheritance.

## Write RSpec test cases

Every policies comes with its rspec now. And the style are quite consistent. Please keep update the RSpec. Especially when you adding new policies class or query methods.

## One policy file per controller

In other words: **DO NOT** reuse policies on different controllers:

``` ruby
             # v
class Admin::OrdersController < AdminController
  def create
    authorize User # <=
  end
end
```

## One policy query method per controller action

Every controller action has one pundit query method. So:

* **DO NOT** reuse query methods on different action.
* Delete policy query method when the controller action is deleted.
* Avoid abstracting query methods to super class (But there are some exception, see below)

### Bad

``` ruby
class Admin::OrdersController < AdminController
      # v
  def create
    authorize @order, :update? # <= bad
  end

  def update
    authorize @order
  end
end
```

``` ruby
class OrderPolicy < ApplicationPolicy
  def update?
    ...
  end
end
```


### Good

``` ruby
class Admin::OrdersController < AdminController
  def create
    authorize @order
  end

  def update
    authorize @order
  end
end
```

``` ruby
class OrderPolicy < ApplicationPolicy
  def create?
    ...
  end

  def update?
    ...
  end
end
```

### Exceptions for this rule:

`new` and `edit` are basically part of `create` and `update`. They always come together. It make sense to reuse them within policy files.

It has been definded in `application_policy.rb`. So there is no need to specify in policy file again.

``` ruby
class ApplicationPolicy
  def new?
    create?
  end

  def edit?
    update?
  end
end
```

## Define private method to reuse permission rule within a policy file

### Godd

``` ruby
class OrderPolicy < ApplicationPolicy
  def index?
    can_read?
  end

  def create?
    can_write?
  end

  def update?
    can_write?
  end

  private

  def can_read?
    user && user.has_any_role?(:admin, :coordinator)
  end

  def can_write?
    user && user.has_any_role?(:admin)
  end
end
```

### Bad

Too many duplication

``` ruby
class OrderPolicy < ApplicationPolicy
  def index?
    user && user.has_any_role?(:admin, :coordinator)
  end

  def create?
    user && user.has_any_role?(:admin)
  end

  def update?
    user && user.has_any_role?(:admin)
  end
end
```

Not consistent on which method is the source

``` ruby
class OrderPolicy < ApplicationPolicy
  def index?
    user && user.has_any_role?(:admin, :coordinator)
  end

  def create?
    user && user.has_any_role?(:admin)
  end

  def update?
    create? # <= Bad
  end
end
```

## Use `authorize @instance` when suitable

Suitable for `show`, `update` and other member actions.

It should be right after the load data. (Like `@user = User.find(params[:id])`)

When use with `before_action`, it does make sense to put in `before_action` method together with data load. However, using `before_action` to load data is not recommended. See [Don't use before_action to load data](http://craftingruby.com/posts/2015/05/31/dont-use-before-action-to-load-data.html)

## Use `authorize Class` when suitable

Suitable for RESTful controller `index` or other collection and without any scope.

`authorize` should be quite near the top of the action.

* For collection actions, it usually be within top 3 lines.

## Use `policy_scope` when suitable

Suitable for `index` and other collection actions like list or search. But with scope (especially when different users having different scopes)

`authorize` should be quite near the top of the action.

Use `policy_scope` will also pass the `verify_authorized` after_action. So no need to do `authorize :something` in the same action.

## Use headless policies when suitable

Suitable for non-RESTful or no model involoved controllers.

### Good

``` ruby
class Admin::CapacitiesController < AdminController
  def index
    authorize :capacity
    DeliveryTimeslot.where(...)
  end
end
```

``` ruby
class CapacityPolicy < ApplicationPolicy
  def index?
    ...
  end
end
```

### Bad

Controller name and policy object not match. This also break "One policy file per controller" rule because the reuse of policy file.

``` ruby
class Admin::CapacitiesController < AdminController
  def index
    authorize DeliveryTimeslot
    DeliveryTimeslot.where(...)
  end
end
```

## Use `user` instead of `@user`

`attr_reader` already defined in `ApplicationPolicy`. Use getter method instead of instance variable is preferred style.

``` ruby
class ApplicationPolicy
  attr_reader :user, :record
  ...
end
```
## Learning

### How scope works

``` ruby
class ApplicationPolicy
  def scope
    Pundit.policy_scope!(user, record.class)
  end
end
```

``` ruby
class CategoryPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user && user.has_any_role?(:admin)
        scope.all
      elsif user && user.has_any_role?(:coordinator, :customer_service)
        scope.where(country: user.country)
      else
        scope.none
      end
    end
  end

  def show?
    scope.where(id: record.id).exists?
    # for admin
    # => Category.all.where(id: record.id).exists?
    # for coordinator/customer_service
    # => Category.where(country: user.country).where(id: record.id).exists?
    # else
    # => Category.none.where(id: record.id).exists? => empty result
  end
end
```

``` ruby
class Admin::CategoriesController < AdminController
  def index
    policy_scope(Category).limit(20)
    # for admin
    # => Category.all.limit(20)
    # for coordinator/customer_service
    # => Category.where(country: user.country).limit(20)
    # else
    # => Category.none.limit(20) => empty result
  end
end
```
### Cheatsheet 

```
# policy scope
policy_scope(Post) # equals to
PostPolicy::Scope.new(current_user, Post).resolve

# is the user have permission to the index of the class?
ProductPolicy.new(user, Product).index?
```

### Links

* [GoRails - Pundit](https://gorails.com/episodes/authorization-with-pundit)
* [Official README](https://github.com/elabs/pundit/blob/master/README.md)
