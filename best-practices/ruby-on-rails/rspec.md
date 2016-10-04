# RSpec

* Use factory_girl `build` or `build_stubbed` over `create` when possible,
  [Use Factory Girl's build_stubbed for a Faster Test Suite][faster-test].
* Avoid `its`, `specify`, and `before` in RSpec.
* Avoid `let` (or `let!`) in RSpec. Prefer extracting helper methods, [Let's Not]
* Use [Four phase test][four-phase-test] testing pattern for unit test. And 
  separate setup, exercise, verification, and teardown phases with newlines.
* Avoid `any_instance` in rspec-mocks and mocha. Prefer [dependency injection].
  but do not re-implement the functionality of `let`. [Example][avoid-let].
* Avoid using `subject` explicitly *inside of an* RSpec `it` block.
  [Example][subject-example].
* Avoid using instance variables in tests.
* Avoid `before(:all)`
* Use `not_to` instead of `to_not` in RSpec expectations.
* Disable real HTTP requests to external services with
  `WebMock.disable_net_connect!`.
* Don't test private methods.
* Test background jobs with a [`Delayed::Job` matcher].
* Use [stubs and spies] \(not mocks\) in isolated tests.
* Use a single level of abstraction within scenarios.
* Use [assertions about state] for incoming messages.
* Use stubs and spies to assert you sent outgoing messages.
* Use a [Fake] to stub requests to external services.
* Use integration tests to execute the entire app.
* Use non-[SUT] methods in expectations when possible.

[faster-test]: https://robots.thoughtbot.com/use-factory-girls-build-stubbed-for-a-faster-test
[four-phase-test]: https://robots.thoughtbot.com/four-phase-test
[dependency injection]: http://en.wikipedia.org/wiki/Dependency_injection
[subject-example]: ../style/testing/unit_test_spec.rb
[avoid-let]: ../style/testing/avoid_let_spec.rb
[`Delayed::Job` matcher]: https://gist.github.com/3186463
[stubs and spies]: http://robots.thoughtbot.com/post/159805295/spy-vs-spy
[assertions about state]: https://speakerdeck.com/skmetz/magic-tricks-of-testing-railsconf?slide=51
[Fake]: http://robots.thoughtbot.com/post/219216005/fake-it
[SUT]: http://xunitpatterns.com/SUT.html
[Let's Not]: https://robots.thoughtbot.com/lets-not
