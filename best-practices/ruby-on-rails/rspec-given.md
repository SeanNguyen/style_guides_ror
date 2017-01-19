# Objective

- To provide a baseline expectation on test expectation with sufficient space for growth and development
- To unify honestbee styles

# Priority Tree

1. Simple, dumb tests
2. Un-DRY is OK
  - Some repetition is fine, as long as test is well-understood
3. Maintainability & readability
  - Avoid coupling of test cases / setup
4. Target high value
  - Generate 80% output with 20% effort (Pareto Principle)
  - I.e. avoid low-value tests like view tests
5. Performance
  - Execution speed can be paid off by spending more on infrastructure
  - Development speed cannot be paid off cheaply by hiring more

# Change Management

- New specs: RSpec-Given
- Old specs / small fixes: No strict rule, prefer RSpec-Given
- Target gradual shift towards RSpec-Given by:
  1. Having newcomers migrate test codes for their early 1 - 2 weeks
  2. Getting interns / part-timers to migrate

# Style Guidelines & Usage

## Avoid top-level Givens

```
context "with no items" do
  Given(:initial_contents) { [] } # Good: Start Givens from level 2 onwards
  Then { stack.depth == 0 }

  context "when pushing" do
    When { stack.push(:an_item) }

    Then { stack.depth == 1 }
    Then { stack.top == :an_item }
  end
end
```

```
describe Stack do
  Given(:stack) { stack_with(initial_contents) } # Bad: Avoid top level Givens
  ...
end
```

```
describe UserController, type: :controller do
  Given { authenticate_admin! } # Good: Perform special cases which covers 100% of cases such as authentication
end
```

## Keep contexts within 3-levels

```
# Good: KISS (Keeps it simple stupid)
describe Bruce do # Level 1
  context 'characteristics' do # Level 2
    context 'at work' do # Level 3
      Given { ... }
      Then { ... }
    end
  end
end
```

```
# Bad: Mount everest codebase
describe CutiePie do # Level 1
  context 'characteristics' do # Still ok: Level 2
    context 'at work' do # Fine: Level 3
      context 'goes deep' do # Oh my god: Level 4
        context 'like, really deep' do # BAD: Level 5
          context 'like mountain climbing' do # KILL YOURSELF: Level 6
          end
        end
      end
    end
  end
end
```

## Show important changes in setup

```
context 'change name' do
  Given(:user) { build(:user) }

  context 'user is not readonly' do
    When { user.change_name('Taher') }
    Then { user.name == "Taher" }
  end

  context 'user is already readonly' do
    Given(:user) { create(:user, name: 'Ronald') } # Good: Clarify intent of modification
    When { user.change_name 'Taher' }
    Then { user.name != 'Taher' }
    Then { user.name == 'Ronald' }
  end
end
```

## Prefer natural assertion

```
# Preferred: Natural assertion
Then { stack.top == :second_item }
Then { stack.depth == original_depth - 1 }
Then { result == Failure(Stack::UnderflowError, /empty/) }
```

```
# Ok: RSpec expectations
Then { expect(stack.top).to eq(:second_item) }
Then { expect(stack.depth).to eq(original_depth - 1) }
Then { expect(result).to have_failed(Stack::UnderflowError, /empty/) }
```

## Prefer Then unless setup is heavy
```
# Good: Use Thens on simple cases
Given(:user) { create(:user) }
Then { user.name == 'Mingsheng' }
Then { user.description == 'Professional' }
```

```
# Good: Use `And` only when setup is heavy
Given(:users) { create_list(:user, 1_000_000_000) }
Then { users.first.name == 'Manic' }
And { users.first.description == 'Loves performance' }
```

```
# Bad: Using `Then` when setup is heavy
Given(:users) { create_list(:user, 1_000_000_000) }
Then { users.first.name == 'Developer X' }
Then { users.first.description == 'Slow as hell with 2 setup passes' }
```

## Use descriptive method naming

```
# Good: Meaningful method names
Given(:user) { create(:user) }
When { user.attack! }
Then { user.action == 'attack' }
```

```
# Bad: Nonsensical naming
Given(:alexis) { create(:user) }
When { alexis.do_something }
Then { alexis.whodunnit = 'what the hell does whodunnit mean?' }
```

## Strict preference for simple setups

```
# Good: Concise setups
Given(:user) { create(:user) }
When { user.attack! }
Then { user.action == 'attack' }
```

```
# Extremely bad: Massive setups
# Strong indicators of bad design and / or architecture
# Suggestions for improvement:
#  1. Decoupling / Demodularization (Strongly preferred)
#  2. Reassess requirements (Secondary preference, solution may not be fixing root cause)
#  3. Enhance factories (Not so preferred, typically hiding logic)
#  4. Extraction of logic into service objects (Not so preferred as well, typically just hiding the mess)
Given { login_admin }
Given(:hierarchy) { create(:hierarchy) }
Given(:fair_price_brand) { create(:brand, name: 'Fair Price') }
Given(:boon_lay_catalog) { create(:catalog, brand: fair_price_brand, 'Boon Lay') }
Given(:cbp_catalog) { create(:catalog, brand: fair_price_brand, 'CBP') }
Given(:core_product) { create_intermediate_product }
Given(:fair_price_brand_product) { create_apple_brand_product(core_product, fair_price_brand, category) }
Given(:create_catalog_product) { fair_price_brand_product, boon_lay_catalog) }
Given(:create_catalog_product) { fair_price_brand_product, cbp_catalog) }
```

## Avoid using Given!

```
Given(:user) { create(:user) } # Good: Executed only if used
Given!(:user) { create(:user) } # Not so good: Always executed even if unused
```

## Prefer RSpec-expectation

```
Then { expect(a).to eq(b) }   # Good: RSpec style
Then { a.should == b }        # Bad: Deprecated RSpec style
```

## Cases of expect().to receive(:method)

```
# To be added
```

## Keep factories thin

- Should only contain necessary information of setup
