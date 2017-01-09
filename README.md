# Guides

## Tutorial

### High level guidelines

* Be consistent.
* [Keep the code simple](https://jml.io/2012/02/simple-made-easy.html).
* Simple solutions survive and prosper because they work, and people can actually understand them. Don't presume that everyone's smart enough to handle the fancy complex solution - [Worse is better](https://blog.codinghorror.com/worse-is-better/).
* Don't writing code that guesses at future functionality.
* Should not add functionality until deemed necessary - [You Aren't Gonna Need It (YAGNI)](https://en.wikipedia.org/wiki/You_aren%27t_gonna_need_it)
* [Do not program "defensively"](http://www.erlang.se/doc/programming_rules.shtml#HDR11).
* Do manually test your new changes even if there are auto tests.
* Do think the side effects your change might have, for example, server stability, performance drop and code structure.
* Avoid selective ownership of code. ("mine", "not mine", "yours")
* Always check a module in cleaner than when you checked it out. - [The Boy Scout Rule](http://programmer.97things.oreilly.com/wiki/index.php/The_Boy_Scout_Rule)
* 15 min rule: When stuck, you have to try on your own for 15 min; after 15 min, you have to ask for help.

### Next Step

1. Read [protocol/git](/protocol/git) before you start committing code.
2. Read [style/ruby-and-rails/*](/style/ruby-and-rails) to know our style standard before submitting your first Ruby/Rails pull request.
3. Take a glance in [best-practices](/best-practices) to know what topics are there. Read detail when you are working on related parts.
4. Study the examples in [codelabs](/codelabs)
5. Read [protocol/code-review.md](/protocol/code-review.md) before your first code review as a reviewer.
6. Finish the rest when you have time or when you need it.

## How to use this guides

* Understand why the styles/practices you're following makes sense and learn from it. Not just blindly follow it.
* Don't violate a guideline without a good reason. A reason is good when you can convince a teammate.
* Don't rewrite existing code just to follow this guide. But try to refine the code when you touch it.

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

### Contributing

Please read the [contribution guidelines] before submitting a pull request.

In particular: **if you have commit access, please don't merge changes without waiting a week for everybody to leave feedback**.

[contribution guidelines]: /CONTRIBUTING.md

## Attribution

* https://github.com/airbnb/ruby (Copyright)
* https://github.com/thoughtbot/guides (CC-BY)
* https://github.com/bbatsov/ruby-style-guide (CC-BY)
