# Rails

## Best practices

### [Always Add DB Index](http://rails-bestpractices.com/posts/2010/07/24/always-add-db-index/)

* For foreign key column or frequent query columns
* You can also do `rails generate migration AddUserRefToProducts user:references` to
  generate `add_reference :products, :user, index: true` in migration file

### [Simplify Render In Views](http://rails-bestpractices.com/posts/2010/12/04/simplify-render-in-views/)

* Use simplify render syntax when possible
* `<%= render 'comments/comment', parent: post %>`

### [Use Time.zone.now Instead Of Time.now](http://rails-bestpractices.com/posts/2014/10/22/use-time-zone-now-instead-of-time-now/)

* See [Timezone best practices](/best-practices/ruby-on-rails/timezone.md)

### [Remove Empty Helpers](http://rails-bestpractices.com/posts/2011/04/09/remove-empty-helpers/)

* Avoid empty classes and methods
* Also avoid unused method. Write the method only when you need it.

### [Fix N+1 Queries](http://rails-bestpractices.com/posts/2010/07/25/fix-n-1-queries/)

* See also <http://www.sitepoint.com/silver-bullet-n1-problem/>

### [Double Check Your Migrations](http://rails-bestpractices.com/posts/2010/07/26/double-check-your-migrations/)

* run `rake db:rollback` to make sure your migration `down` part is correct

### [Replace Instance Variable With Local Variable](http://rails-bestpractices.com/posts/2010/07/24/replace-instance-variable-with-local-variable/)

Don't use instance variables in partials. Pass local variables to partials from view templates.

### Other

* Avoid bypassing validations with methods like `save(validate: false)`,
  `update_attribute`, and `toggle`.
* Avoid instantiating more than one object in controllers.
* Avoid naming methods after database columns in the same class.
* Don't reference a model class directly from a view.
* Don't return false from `ActiveModel` callbacks, but instead raise an exception.
* Don't use SQL or SQL fragments (`where('inviter_id IS NOT NULL')`) outside of models.
* Generate necessary [Spring binstubs] for the project, such as `rake` and
  `rspec`, and add them to version control.
* Use the [`.ruby-version`] file convention to specify the Ruby version and
  patch level for a project.
* Use `_url` suffixes for named routes in mailer views and [redirects].  Use
  `_path` suffixes for named routes everywhere else.
* Use a [class constant rather than the stringified class name]
  for `class_name` options on ActiveRecord association macros.
* Validate the associated `belongs_to` object (`user`), not the database column (`user_id`).
* Use `db/seeds.rb` for data that is required in all environments.
* Prefer `cookies.signed` over `cookies` to [prevent tampering].
* Use `ENV.fetch` for environment variables instead of `ENV[]`so that unset
  environment variables are detected on deploy.
* [Use blocks][date-block] when declaring date and time attributes in FactoryGirl factories.
* Use `touch: true` when declaring `belongs_to` relationships.

[date-block]: /best-practices/samples/ruby.rb#L10
[`.ruby-version`]: https://gist.github.com/fnichol/1912050
[redirects]: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.30
[Spring binstubs]: https://github.com/sstephenson/rbenv/wiki/Understanding-binstubs
[prevent tampering]: http://blog.bigbinary.com/2013/03/19/cookies-on-rails.html
[class constant in association]: https://github.com/thoughtbot/guides/blob/master/style/rails/sample.rb
