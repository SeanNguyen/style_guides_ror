# rubocop:disable Style/GuardClause, Metrics/AbcSize

#  .d8888b.   .d88888b.   .d88888b.  8888888b.
# d88P  Y88b d88P" "Y88b d88P" "Y88b 888  "Y88b
# 888    888 888     888 888     888 888    888
# 888        888     888 888     888 888    888
# 888  88888 888     888 888     888 888    888
# 888    888 888     888 888     888 888    888
# Y88b  d88P Y88b. .d88P Y88b. .d88P 888  .d88P
#  "Y8888P88  "Y88888P"   "Y88888P"  8888888P"

# Don’t include newlines between areas of different indentation
# Include one, but no more than one, new line between methods
class Example
  def first_method
    method_body
  end

  def second_method
    method_body
  end
end

class User
  def use_one_and_only_one_empty_line_to_section_logical_paragraps
    validate_data

    prepare_something

    really_do_something

    tear_down
  end

  def add_a_new_line_after_block
    if condition
      do_something
    end

    leave_one_line_after_block
  end

  def leave_empty_line_before_method_body(_when_params,
                                          _span,
                                          _multiple_lines)

    if or_when_if_condition &&
       span_multiple_lines

      also_leave_a_empty_line
    end
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

class Example

  def first_method
    method_body
  end


  def second_method
    method_body
  end
  def third_method
    method_body
  end

end


class User
  def no_logical_paragraps_is_hard_to_read
    validate_data
    prepare_something
    really_do_something
    tear_down
  end

  def no_new_line_after_block_is_hard_to_read
    if condition
      do_something
    end
    leave_one_line_after_block
  end

  def no_empty_line_before_method_body(_when_params,
                                       _span,
                                       _multiple_lines)
    if or_when_if_condition &&
       but_no_span_multiple_lines
      is_also_hard_to_read
    end
  end
end

# rubocop:enable Style/GuardClause, Metrics/AbcSize
