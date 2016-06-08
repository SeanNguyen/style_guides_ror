# rubocop:disable Style/GuardClause, Metrics/AbcSize

#  .d8888b.   .d88888b.   .d88888b.  8888888b.
# d88P  Y88b d88P" "Y88b d88P" "Y88b 888  "Y88b
# 888    888 888     888 888     888 888    888
# 888        888     888 888     888 888    888
# 888  88888 888     888 888     888 888    888
# 888    888 888     888 888     888 888    888
# Y88b  d88P Y88b. .d88P Y88b. .d88P 888  .d88P
#  "Y8888P88  "Y88888P"   "Y88888P"  8888888P"

class User
  def space_around_operators
    @value = something + 2
  end

  def more_operators
    # note that there is no space between ! and operands
    true & (false || true) & !true
  end

  def do_not_align_across_lines(value)
    @first_variable = value
    @second = value
    @third_one_has_a_long_name = value
  end

  def arguments(required, optional = 1)
    puts required
    puts optional
  end

  def keyword_arguments(required:, optional: 1)
    puts required
    puts optional
  end

  def hash
    { key1: 'value', key2: 'value' }
  end

  def array
    [:value, 123, 'abc']
  end

  def string_interpolation
    "age: #{@age}"
  end

  def comments
    something # Leave one space after comment sharp symbol
  end

  def range_and_block
    (1..10).map { |i| i * i }
  end
end

# 888888b.         d8888 8888888b.
# 888  "88b       d88888 888  "Y88b
# 888  .88P      d88P888 888    888
# 8888888K.     d88P 888 888    888
# 888  "Y88b   d88P  888 888    888
# 888    888  d88P   888 888    888
# 888   d88P d8888888888 888  .d88P
# 8888888P" d88P     888 8888888P"

class  User
  def  space_around_operators
    @value=something+2
  end

  def more_operators
    true  &( false||  true ) & ! true
  end

  def do_not_align_across_lines(value)
    # Rationale: This looks beautiful, but when you deleting the third line, you also need to
    # change all other lines, which gives you a messy git diff.
    @first_variable            = value
    @second                    = value
    @third_one_has_a_long_name = value
  end

  def arguments ( required ,optional=1)
    puts  required
    puts optional
  end

  def keyword_arguments(required: ,optional:1 )
    puts required
    puts optional
  end

  def hash
    {key1:'value',key2:'value'}
  end

  def array
    [ :value , 123 ,'abc' ]
  end

  def string_interpolation
    "age: #{ @age }"
  end

  def comments
    something #Leave one space after comment sharp symbol
  end

  def range_and_block
    ( 1 .. 10).map {| i |i * i}
  end
end

# rubocop:enable Style/GuardClause, Metrics/AbcSize
