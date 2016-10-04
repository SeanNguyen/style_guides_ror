# Rails

## General

### line length max: 100 characters

Please set your editor ruler (or margin, column in some editor) at 100.

> Rationale: Readablity, especially in GitHub interface, macbook built-in screen or vertical
> split screen.

### EditorConfig

Please install corrsponding plugin for EditorConfig.

The config file `.editorconfig` indicates the most basic coding style we are using. Following is the content as of 2016-10-04:

```
[*]
end_of_line = lf
indent_style = space
indent_size = 2
insert_final_newline = true
trim_trailing_whitespace = true

[*.md]
indent_size = 4
```

* If you are using Sublime Text, try `TrailingSpaces` package.
* Note for `insert_final_newline`: <https://robots.thoughtbot.com/no-newline-at-end-of-file>

### Whitespace / Indentations / Newlines

You can run `rubocop` against following files and inspect the result.

* [Whitespace](/style/ruby-and-rails/example-spaces.rb)
* [Indentations](/style/ruby-and-rails/example-indentations.rb)
* [Newlines](/style/ruby-and-rails/example-newlines.rb)

## Other

* Name date columns with `_on` suffixes.
* Name datetime columns with `_at` suffixes.
* Name time columns (referring to a time of day with no date) with `_time` suffixes.
* Order ActiveRecord associations alphabetically by association type, then
  attribute name.
* Order ActiveRecord validations alphabetically by attribute name.
* Order ActiveRecord associations above ActiveRecord validations.
* Order controller contents: filters, public methods, private methods.
* Order i18n translations alphabetically by key name.
* Order model contents: constants, macros, public methods, private methods.
* Put application-wide partials in the [`app/views/application`] directory.
* Use the default `render 'partial'` syntax over `render partial: 'partial'`.
* Use `link_to` for GET requests, and `button_to` for other HTTP verbs.
* Use new-style `validates :name, presence: true` validations, and put all
  validations for a given column together.
* Avoid conditional modifiers (lines that end with conditionals).
* Avoid multiple assignments per line (`one, two = 1, 2`).
* Avoid comments of any kind
* Avoid ternary operators (`boolean ? true : false`). Use multi-line `if`
  instead to emphasize code branches.
* Avoid using semicolons.
* Use bang (!) method name when the method may raise Exception (Rails convention)
* Don't use `self` explicitly anywhere except class methods (`def self.method`)
  and assignments (`self.attribute =`).
* Prefer nested class and module definitions over the shorthand version.
* Prefer `find` over `detect`.
* Prefer `select` over `find_all`.
* Prefer `map` over `collect`.
* Prefer `reduce` over `inject`.
* Prefer double quotes for strings.
* Prefer `&&` and `||` and `!` over `and` and `or` and `not`.
* Prefer `&:method_name` to `{ |item| item.method_name }` for simple method calls.
* Prefer `if` over `unless`.
* Use `_` for unused block parameters.
* Prefix unused variables or parameters with underscore (`_`).
* Use `%{}` for single-line strings needing interpolation and double-quotes.
* Use `{...}` for single-line blocks. Use `do..end` for multi-line blocks.
* Use `?` suffix for predicate methods. But the method must have no side effect.
* Use `CamelCase` for classes and modules, `snake_case` for variables and
  methods, `SCREAMING_SNAKE_CASE` for constants.
* Use `def self.method`, not `def Class.method` or `class << self`.
* Use `def` with parentheses when there are arguments.
* Use `each`, not `for`, for iteration.
* Prefer `private` over `protected` [guidelines](https://robots.thoughtbot.com/protect-your-privates)
* Order class methods above instance methods.

[`app/views/application`]: http://asciicasts.com/episodes/269-template-inheritance

## Routes

* Avoid `member` and `collection` routes when you can follow RESTful and resourceful design
* Use the `:only` option to explicitly state exposed routes.
* Avoid the `:except` option in routes.
* Order resourceful routes alphabetically by name.

## Email

* Use the user's name in the `From` header and email in the `Reply-To` when
  [delivering email on behalf of the app's users].

[delivering email on behalf of the app's users]: http://robots.thoughtbot.com/post/3215611590/recipe-delivering-email-on-behalf-of-users

## TBD

* Use `def self.method`, not the `scope :method` DSL.
* Avoid explicit return statements.
* Use a leading underscore when defining instance variables for memoization.
* Use a trailing comma after each item in a multi-line list, including the last item.
* Use heredocs for multi-line strings.
* Prefer method invocation over instance variables.
