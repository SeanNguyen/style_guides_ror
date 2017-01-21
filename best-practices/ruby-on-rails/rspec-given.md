# Objective

- To unify honestbee styles
- To provide a baseline guidelines for developers' reference

# Priority Tree

1. Readability & Maintainability
  - Prefer [DAMP] (Descriptive And Meaningful Phrases) over DRY (Don't Repeat Yourself)

2. Simplicity
  - Simple, dumb and deterministic assertions
  - Target only [high-value system components][pareto-principle] (Price is correct? (high-value) v.s. is a button red? (low-value))

3. Performance
  - Development speed > test execution time (if it comes to the point of making a compromise)
  - Most likely, if the top priorities are met, performance usually becomes better

[DAMP]:http://stackoverflow.com/questions/6453235/what-does-damp-not-dry-mean-when-talking-about-unit-tests/11837974#11837973
[pareto-principle]: https://en.wikipedia.org/wiki/Pareto_principle

# Structural Guidelines

## Avoid top-level Givens

Addressing the [Mystery Guest][lets-not] issue solves the largest concern: readability

```ruby
describe Order do
  # Good: Start Givens from level 2 onwards

  context "with only grocery products" do
    Given(:order) { ... }
    ...
  end
end
```

```ruby
describe Order do
  Given(:order) { ... } # Bad: Avoid top-level Givens
  ...
end
```

```ruby
describe UserController, type: :controller do
  Given { authenticate_admin! } # Good: Perform special cases such as authentication
end
```

[lets-not]: https://robots.thoughtbot.com/lets-not

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
describe User do
  context 'change name' do
    Given(:user) { build(:user) }

    context 'user is not readonly' do
      When { user.change_name('Taher') }
      Then { user.name == "Taher" }
    end

    context 'user is banned' do                                       # Good: Clear separation of context
      When(:result) { user.change_name('Taher') }
      Then { result == Failure(InvalidActionError, /banned/i) }
    end

    context 'user is readonly' do
      Given(:user) { build(:user, name: 'Ali', readonly: true) }      # Good: Clarify intent of modification

      When { user.change_name 'Taher' }
      Then { user.name != 'Taher' }
      Then { user.name == 'Ali' }
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

Documentation recommends [sticking to Then][prefer-then-over-and] by default

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

[prefer-then-over-and]: https://github.com/jimweirich/rspec-given#and

## Use descriptive method naming

Use meaningful, intention-revealing method names.
Reference: [Clean Code: Chapter 2 - Meaningful Names][clean-code]

```ruby
Given(:user) { build(:user) }
When { user.attack! }
Then { user.action == 'attack' }  # Good: Meaningful method names
```

```ruby
Given(:user) { build(:user) }
When { user.attack! }
Then { user.action == 'defend' }  # Bad: Assertion mismatch with executed method

# Code smell: Consider renaming your method
```

[clean-code]: http://ricardogeek.com/docs/clean_code.pdf

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

## Use Given / Given! with consideration for performance

[Avoiding database][avoid-factory-creation] makes you ~100% faster.

```ruby
# Preferred
Given(:user) { create(:user) }    # Executed only if called

# Be aware of usage
Given { create(:user) }           # Always executed
Given!(:user) { create(:user) }   # Always executed
```

## Prefer RSpec-expectation

```ruby
Then { expect(a).to eq(b) }       # Good: RSpec style
Then { a.should == b }            # Bad: Deprecated RSpec style
```

## Cases of expect().to receive(:method)

```ruby
# Good: Pre-expectation with readability
Given(:honestbee) { Honestbee.new }
Given!(:expect_elegant_code_from_dao_le) { expect(honestbee).to receive(:write_elegant_code) }

When { honestbee.inspect_quality }
Then { expect_elegant_code_from_dao_le }
```

## Keep factories thin

Avoid perma-passing tests by [setting up factories with the bare minimum][skinny-factories]

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
  image_url { 'http://localhost' }                # Bad: Non-required field included
end

Given(:product) { build(:product) }
When { product.do_something }
Then { product.image_url == 'http://localhost' }  # Bad: Always passing test
```

```
factory :user do
  email { ... }

  trait :confirmed do
    confirmed_at { ... }                          # Good: Setup useful traits with minimal values
  end
end

create(:user, :confirmed)                         # Good: Simple, concise usage
```

[skinny-factories]: https://robots.thoughtbot.com/factories-should-be-the-bare-minimum

## Prefer FactoryGirl.build over FactoryGirl.create

Gain 100% better performance by [avoiding database write in factory creation][avoid-factory-creation]

```
build(:user)                      # Preferred
create(:user)
```

[avoid-factory-creation]: https://robots.thoughtbot.com/speed-up-tests-by-selectively-avoiding-factory-girl

## Avoid writing 'FactoryGirl'

Why write more when you can write less? It's already [configured][avoid-writing-factorygirl]

```
build(:user)                      # Good

FactoryGirl.build(:user)          # Never
```

[avoid-writing-factorygirl]: https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md#rspec

# Change Management

- New specs: RSpec-Given
- Old specs / small fixes: No strict rule, prefer RSpec-Given
- Target gradual shift towards RSpec-Given by:
  1. Having newcomers migrate test codes for their early 1 - 2 weeks (Preferred as it helps them familiarize)
  2. Getting interns / part-timers to migrate (Not preferred unless expanding test coverage)
