# Rails Timezone Best Practices

## The basic concept

1. Rails timezone vs system timezone
2. ActiveRecord always store datetime in UTC (unless you change it, but you should never do this!)

### TL;DR;

1. Convert datetime string with timezone info avoid ambiguous
2. Convert into a explict timeozne (eg. by using `Time.zone.xxx`)

Always use `Time.zone.xxx`, `Time.xxx.in_time_zone` or `n.days.ago` (and similar rails method calls) unless you know what you are doing.

### Try out the timezone support of a specific command

sometimes you may want to try out is this command support timezone? You can do:

> Given that your system time is Singapore UTC+8

in rails console:

    Time.zone = "Melbourne" # is UTC+10

Then type in commands you want to check

    Time.now      # 2015-07-05 14:46:00 +0800
    Time.zone.now # Sun, 05 Jul 2015 16:46:00 AEST +10:00

Pay attention to the timezone. Since you just set timezone to Melbourne time. You should use those commands that return UTC+10 time.

## Prepare

### Always use datetime for storing dates

> When storing dates in your database always try to use absolute time, e.g. datetime in rails. Don't use just dates (e.g. 2012-01-12 without the time part) unless you are certain that is what you need, i.e when the date is relative to the user.

https://www.reinteractive.net/posts/168-dealing-with-timezones-effectively-in-rails

### Add a timezone attribute to the users

you can add a method or a database column. depending on your need.

you can get full list of timezone names by running:

    rake time:zones:all

use `time_zone_select` helper to generate timezone select tag http://apidock.com/rails/v2.1.0/ActionView/Helpers/FormOptionsHelper/time_zone_select

### Set timezone for each request in application controller

Make sure that you have something like this in `app/controllers/application_controller.rb`:

``` ruby
class ApplicationController < ActionController::Base
  around_filter :set_time_zone

  def set_time_zone(&block)
    time_zone = current_user.try(:time_zone) || 'UTC'
    Time.use_zone(time_zone, &block)
  end
end
```

Some blog post use `before_filter`. This is not good because that it will leak timezone settings across request when you are using multi-thread server like puma.

* http://www.createdbypete.com/articles/working-with-locales-and-time-zones-in-rails/
* https://www.reinteractive.net/posts/168-dealing-with-timezones-effectively-in-rails
* http://ilikestuffblog.com/2011/02/03/how-to-set-a-time-zone-for-each-request-in-rails/
* http://brendankemp.com/essays/handling-time-zones-in-rails/

## DOs and DON'Ts

### Get date or time

Always use

``` ruby
Time.zone.now
Time.zone.today
Time.zone.now.last_month
Time.zone.now.beginning_of_day
Time.zone.local(2015, 7, 5, 16, 55, 0)
Time.zone.at(1436115300)
Time.zone.parse("2015-07-05T06:55:00Z")
Time.strptime("2015-07-05 06:55:00 Z", "%Y-%m-%d %H:%M:%S %Z").in_time_zone
1.month.ago # or similar rails method calls
date.beginning_of_day # instead of date.to_time
```

(all commands above are executeable, you can paste into rails console)

Acceptable, but avoid use it for style consistancy.

``` ruby
Time.current # is almost same to `Time.zone.now`
Date.current # is same to `Time.zone.today`
Time.now.in_time_zone # is same to Time.zone.now
```

TODO: add link to `Time.current` source code

Never use

    Time.now
    Time.new
    Time.parse
    Time.strptime
    Date.today
    DateTime.now
    DateTime.xxx
    date.to_time

Unless you have a good reason.

### Queries

DO

    User.where("created_at < ?", Time.zone.now)

DON'T

    User.where("created_at < '#{Time.zone.now}'")

Because:

* Rails stores datetime in UTC. It convert to UTC before saving into database. And convert to local time when you read it with rails methods.
* construct the queries string and user input are also vulnerable to SQL injection.

For advanced and complex queries, check <http://brendankemp.com/essays/dealing-with-time-zones-using-rails-and-postgres/>

### Save data

Use `Time.use_zone` block or `Time.zone=` to change to user-selected timezone if you want.

Use `#update`, `#update_attributes`, `#update_column` are all take timezone into account. Just don't use handcrafted SQL query string.

### API Supplying

There is a standard. If you are returning a absloute time. Just use ISO8601 format.

    Time.zone.now.utc.iso8601
    # => "2015-07-05T16:55:00Z"

http://devblog.avdi.org/2009/10/25/iso8601-dates-in-ruby/

### API Consuming

If the response is in ISO8601 format, use:

    Time.zone.parse(time_string)

For non-standard format, use strptime:

    Time.strptime(time_string, "%Y-%m-%d %H:%M:%S %Z").in_time_zone

Note that, if the original `time_string` doesn't come with timezone info. You need to add it. for example, given that:

* system time is Singapore UTC+8
* Time.zone is Melbourne UTC+10
* The `time_string` we get from external API is implicitly UTC+6 (for example, their document say so)

``` ruby
# ambiguous
time_string = "2015-07-05 11:00:00"

# wrong result because rails treat time_string as system time (pay attention to hour)
Time.strptime(time_string, "%Y-%m-%d %H:%M:%S").in_time_zone
# => Sun, 05 Jul 2015 13:00:00 AEST +10:00

# explicit and correct
Time.strptime("#{time_string} +0600", "%Y-%m-%d %H:%M:%S %Z").in_time_zone
# => Sun, 05 Jul 2015 15:00:00 AEST +10:00
```

## Display date and time

It is a localization topic. See:

* http://www.createdbypete.com/articles/working-with-locales-and-time-zones-in-rails/
* http://guides.rubyonrails.org/v4.1.8/i18n.html

http://guides.rubyonrails.org/i18n.html#adding-date-time-formats
https://github.com/svenfuchs/rails-i18n/tree/master/rails/locale

> Beware: I18n.localize does not handle nil values

to display in backend with minimum effort you can:

    Time.zone.now.to_s

## Querying timezone from the front-end

https://www.reinteractive.net/posts/168-dealing-with-timezones-effectively-in-rails

## Conventions


1. `datetime` columns should end in `_at`
2. `date` columns should end in `_on`
3. `xxx_at` and `xxx?`, for example, `confirmed_at` and `confirmed?` in devise

## Testing

* Follow `Time.zone.xxx` conventions described above
* `Zonebie` and `Timecop` are two common used time testing gems

## notes: day light saving

``` ruby
Time.zone.to_s
# => "(GMT+10:00) Melbourne"
Time.zone.local(2015, 02, 05)
# => Thu, 05 Feb 2015 00:00:00 AEDT +11:00
Time.zone.local(2015, 07, 05)
# => Sun, 05 Jul 2015 00:00:00 AEST +10:00
```

## notes

if you only have 1 timezone to deal with. You don't need the use_timezone in application contorller.

a good practice is run your production servers in UTC. But if you already have production up and runnng. as long as it keep consistance. It should be ok.

TODO: source code of ActiveSupport::TimeZone#now

## Useful date and time built-in methods

``` ruby
Time.zone.now.formatted_offset
Time.zone.today.prev_day
Time.zone.today.next_day
Time.zone.today.yesterday
Time.zone.today.tomorrow
1.day.ago
1.day.from_now
1.day.since(Time.zone.now)
```

## References

* http://brendankemp.com/essays/handling-time-zones-in-rails/
* http://brendankemp.com/essays/dealing-with-time-zones-using-rails-and-postgres/
* http://www.createdbypete.com/articles/working-with-locales-and-time-zones-in-rails/
* http://www.elabs.se/blog/36-working-with-time-zones-in-ruby-on-rails
* http://ilikestuffblog.com/2011/02/03/how-to-set-a-time-zone-for-each-request-in-rails/
* http://product.reverb.com/2015/03/27/how-not-to-fail-at-timezones-in-rails/
* https://www.reinteractive.net/posts/168-dealing-with-timezones-effectively-in-rails
* http://jessehouse.com/blog/2013/11/15/working-with-timezones-and-ruby-on-rails/
* http://www.databasically.com/2010/10/22/what-time-is-it-or-handling-timezones-in-rails/
* http://rails-bestpractices.com/posts/2014/10/22/use-time-zone-now-instead-of-time-now/
* http://danilenko.org/2012/7/6/rails_timezones/
* http://railscasts.com/episodes/106-time-zones-revised?view=asciicast
