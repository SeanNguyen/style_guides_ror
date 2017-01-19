# Objective

- To provide a baseline guidelines which allows sufficient space for personal growth and development
- To unify honestbee styles
- To drive software quality

# Priority Tree

1. Readability & Maintainability
  - Prefer [DAMP] (Descriptive And Meaningful Phrases) over DRY (Don't Repeat Yourself)

2. Simplicity
  - Simple, dumb and deterministic assertions
  - Target only high-value system components (Price is correct? (high-value) v.s. is a button red? (low-value))
  - Generate 80% output with 20% effort (Pareto Principle)

3. Performance
  - Development speed > test execution time (if it comes to the point of making a compromise)
  - Most likely, if the top priorities are met, performance usually becomes better

[DAMP]:http://stackoverflow.com/questions/6453235/what-does-damp-not-dry-mean-when-talking-about-unit-tests/11837974#11837973

# Change Management

- New specs: RSpec-Given
- Old specs / small fixes: No strict rule, prefer RSpec-Given
- Target gradual shift towards RSpec-Given by:
  1. Having newcomers migrate test codes for their early 1 - 2 weeks
  2. Getting interns / part-timers to migrate

# Structural Guidelines

## Avoid top-level Givens

```ruby
describe Stack do
  # Good: Start Givens from level 2 onwards

  context "with no items" do
    Given(:stack) { ... }
    ...
  end
end
```

```ruby
describe Stack do
  Given(:stack) { ... } # Bad: Avoid top-level Givens
  ...
end
```

```ruby
describe UserController, type: :controller do
  Given { authenticate_admin! } # Good: Perform special cases such as authentication
end
```

## Keep contexts within 3-levels

```ruby
# Good: KISS (Keeps it simple stupid)
describe Bruce do                         # Level 1
  context '#characteristics' do           # Level 2
    context 'at work' do                  # Level 3
      Given { ... }
      Then { ... }
    end
  end
end
```

```ruby
# Bad: Mount everest codebase
describe CutiePie do                              # Level 1
  context '#characteristics' do                   # Level 2
    context 'at work' do                          # Level 3
      context 'goes high' do                      # Level 4: Ideally not...
        context 'like, really high' do            # Level 5: Bad
          context 'like mountain climbing' do     # Level 6: Very, very bad
            Given { ... }
            Then { ... }
          end
        end
      end
    end
  end
end
```

## Show important changes in setup

```ruby
describe Bruce do
  context 'change name' do
    Given(:user) { build(:user) }

    context 'user is not readonly' do
      When { user.change_name('Taher') }
      Then { user.name == "Taher" }
    end

    context 'user is readonly' do
      Given(:user) { create(:user, name: 'Ronald') } # Good: Clarify intent of modification
      When { user.change_name 'Taher' }
      Then { user.name != 'Taher' }
      Then { user.name == 'Ronald' }
    end
  end
end
```

# Usage Guidelines

## Prefer natural assertion

```ruby
# Preferred: Natural assertion
Then { stack.top == :second_item }
Then { stack.depth == original_depth - 1 }
Then { result == Failure(Stack::UnderflowError, /empty/) }
```

```ruby
# Ok: RSpec expectations
Then { expect(stack.top).to eq(:second_item) }
Then { expect(stack.depth).to eq(original_depth - 1) }
Then { expect(result).to have_failed(Stack::UnderflowError, /empty/) }
```

## Prefer Then unless setup is heavy
```ruby
# Good: Use Thens on simple cases
Given(:user) { create(:user) }
Then { user.name == 'Mingsheng' }
Then { user.description == 'Professional' }
```

```ruby
# Good: Use `And` only when setup is heavy
Given(:users) { create_list(:user, 1_000_000_000) }
Then { users.first.name == 'Manic' }
And { users.first.description == 'Loves performance' }
```

```ruby
# Bad: Using `Then` when setup is heavy
Given(:users) { create_list(:user, 1_000_000_000) }
Then { users.first.name == 'Developer X' }
Then { users.first.description == 'Slow as hell with 2 setup passes' }
```

## Use descriptive method naming

```ruby

Given(:user) { build(:user) }
When { user.attack! }
Then { user.action == 'attack' }  # Good: Meaningful method names
```

```ruby
# Code smell: Consider renaming your method

Given(:user) { build(:user) }
When { user.attack! }
Then { user.action == 'defend' }  # Bad: Assertion mismatch with executed method
```


## Strict preference for simple setups

```ruby
# Good: Concise setups
Given(:user) { build(:user) }
When { user.attack! }
Then { user.action == 'attack' }
```

```ruby
# Code smell: Unnecessary complexity (Massive setups)
# Strong indicators of bad design and / or architecture

# Suggestions for improvement:
#  1. Decoupling / Demodularization (Strongly preferred)
#  2. Reassess requirements (Secondary preference, solution may not be fixing root cause)
#  3. Enhance factories (Not so preferred, typically hiding logic)
#  4. Extraction of logic into service objects (Not so preferred as well, typically just hiding the mess)

Given { login_admin }
Given(:hierarchy) { create(:hierarchy) }
Given(:fair_price_brand) { create(:brand, name: 'Fair Price') }
Given(:boon_lay_catalog) { ... }
Given(:cbp_catalog) { ... }
Given(:core_product) { ... }
Given(:fair_price_brand_product) { ... }
Given(:create_catalog_product) { ... }
Given(:create_catalog_product) { ... }
```

## Prefer Given over Given!

```ruby
Given(:user) { create(:user) } # Good: Executed only if used
Given!(:user) { create(:user) } # Not so good: Always executed even if unused
```

## Prefer RSpec-expectation

```ruby
Then { expect(a).to eq(b) }   # Good: RSpec style
Then { a.should == b }        # Bad: Deprecated RSpec style
```

## Cases of expect().to receive(:method)

```ruby
# Good: Pre-expectation with readability
Given(:dao_le) { DaoLe.new }
Given!(:expect_elegant_code) { expect_any_instance_of(DaoLe).to receive(:elegant_code) }

When { dao_le.code }
Then { expect_elegant_code }
```

## Keep factories thin

Should only contain necessary information of setup

```ruby
# Good: Only initializes required fields by default
factory :product do
  external_id { ... }
  price { ... }
end
```

```ruby
factory :product do
  external_id { ... }
  price { ... }
  image_url { 'http://localhost' }  # Bad: Non-required field included
end

Given(:product) { build(:product) }
When { product.do_something }
Then { product.image_url == 'http://localhost' }  # Bad: Always passing test
```

```
# Good: Setup useful traits with minimal values
factory :user do
  email { ... }

  trait :confirmed do
    confirmed_at { ... }
  end
end

create(:user, :confirmed)
```

## Prefer FactoryGirl.build over FactoryGirl.create

```
build(:user)    # Preferred
create(:user)
```

## Avoid writing FactoryGirl

```
build(:user)              # Good

FactoryGirl.build(:user)  # Bad
```
