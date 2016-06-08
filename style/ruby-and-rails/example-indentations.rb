# rubocop:disable Style/GuardClause, Metrics/AbcSize

#  .d8888b.   .d88888b.   .d88888b.  8888888b.
# d88P  Y88b d88P" "Y88b d88P" "Y88b 888  "Y88b
# 888    888 888     888 888     888 888    888
# 888        888     888 888     888 888    888
# 888  88888 888     888 888     888 888    888
# 888    888 888     888 888     888 888    888
# Y88b  d88P Y88b. .d88P Y88b. .d88P 888  .d88P
#  "Y8888P88  "Y88888P"   "Y88888P"  8888888P"

def hash
  # good if line length < 100
  { a: 1, b: 2, c: 3, d: 4 }

  # good
  {
    a: 1,
    b: 2,
    c: 3,
    d: 4
  }
end

def flow_control
  # without assignment
  some_statement ||
    the_other_statement ||
    thrid_statement

  # with assignment
  _value = some_statement ||
           the_other_statement ||
           thrid_statement
end

def if_with_assignment
  # good
  _value =
    if something
      something
    else
      other_thing
    end

  # good when line length < 100
  _value = if something
             something
           else
             other_thing
           end
end

def if_conditions_span_multiple_lines
  if the_first_line_of_condition &&
     the_second_line_of_condition

    do_something
  end
end

def method_chain
  # without assignment (start with the most prefered one)
  Class.method(option).
    method(option).
    method

  Class.method(
    option_1,
    option_2
  ).method(
    option
  )

  Class.method(option_1,
               option_2)

  # with assignment
  _value = Class.method(option).
           method(option).
           method

  _value = Class.method(
    option_1,
    option_2
  ).method(
    option
  )
end

def case_when(value)
  # without assignment
  case value
  when 1
    puts 'one'
  when :apple
    puts 'apple'
  end

  # with assignment (start with the most prefered one)
  _result =
    case value
    when 1
      puts 'one'
    when :apple
      puts 'apple'
    end

  _result = case value
            when 1
              puts 'one'
            when :apple
              puts 'apple'
            end
end

def multi_line_params(param_1,
                      param_2,
                      param_3,
                      param_4)

  leave_one_line_before_method_body(param_1, param_2, param_3, param_4)
end

# 888888b.         d8888 8888888b.
# 888  "88b       d88888 888  "Y88b
# 888  .88P      d88P888 888    888
# 8888888K.     d88P 888 888    888
# 888  "Y88b   d88P  888 888    888
# 888    888  d88P   888 888    888
# 888   d88P d8888888888 888  .d88P
# 8888888P" d88P     888 8888888P"

def hash
  {
    a: 1, b: 2,
    c: 3, d: 4
  }

  { a: 1, b: 2,
    c: 3, d: 4 }

  { a: 1, b: 2, c: 3,
  d: 4 }

  { a: 1, b: 2, c: 3,
      d: 4 }
end

def flow_control
  # all bad
  some_statement ||
  the_other_statement ||
  thrid_statement

  _value = some_statement ||
    the_other_statement ||
    thrid_statement

  _value = some_statement ||
             the_other_statement ||
             thrid_statement
end

def if_with_assignment
  # all bad
  _value =
  if something
    something
  else
    other_thing
  end

  _value = if something
    something
  else
    other_thing
  end
end

def if_conditions_span_multiple_lines
  if the_first_line_of_condition &&
       the_second_line_of_condition

    do_something
  end
end

def method_chain
  # all bad
  Class.method(option)
    .method(option)
    .method

  Class.method(
               option_1,
               option_2
  ).method(
           option
  )

  Class.method(option_1,
    option_2)

  _value = Class.method(option).
             method(option).
             method

  _value = Class.method(option).
    method(option).
    method

  _value = Class.method(
             option_1,
             option_2
           ).method(
             option
           )
end

def case_when(value)
  # all bad
  case value
    when 1
      puts 'one'
    when :apple
      puts 'apple'
  end

  _result =
  case value
  when 1
    puts 'one'
  when :apple
    puts 'apple'
  end

  _result = case value
    when 1
      puts 'one'
    when :apple
      puts 'apple'
    end
end

def multi_line_params(param_1,
  param_2, param_3, # mix one-per-line with multi-lines
  param_4)
  leave_one_line_before_method_body(param_1, param_2, param_3, param_4) # didn't
end

# rubocop:enable Style/GuardClause, Metrics/AbcSize
