# Guides

High level guidelines:

* Be consistent.
* Don't rewrite existing code just to follow this guide. But try to refine the code when you touch it.
* Don't violate a guideline without a good reason.
* A reason is good when you can convince a teammate.
* Don't write code that guesses at future functionality.
* [Keep the code simple](https://jml.io/2012/02/simple-made-easy.html).
* [Do not program "defensively"](http://www.erlang.se/doc/programming_rules.shtml#HDR11).
* Take ownership of the project. Meaning that server stability and code quality etc. **are** your business.
  * Do test your new changes.
  * Do think about side effects that your changes might have.
* Avoid selective ownership of code. ("mine", "not mine", "yours")

A note on the language:

* "Avoid" means don't do it unless you have good reason.
* "Don't" means there's never a good reason.
* "Prefer" indicates a better option and its alternative to watch out for.
* "Use" is a positive instruction.

Go to each folders for detailed guidelines.

* [best-practices](/best-practices)
* [protocol](/protocol)
* [security](/security)
* [style](/style)

## Contributing

Please read the [contribution guidelines] before submitting a pull request.

In particular: **if you have commit access, please don't merge changes without waiting a week for everybody to leave feedback**.

[contribution guidelines]: /CONTRIBUTING.md

## Attribution

* https://github.com/airbnb/ruby (Copyright)
* https://github.com/thoughtbot/guides (CC-BY)
* https://github.com/bbatsov/ruby-style-guide (CC-BY)
