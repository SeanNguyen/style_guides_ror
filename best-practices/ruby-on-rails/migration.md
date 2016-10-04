# Rails Migrations practices

## The concept of database migration in Rails

There four parts:

1. the migration files
2. `schema.rb`
3. the real DB schema in Database management system
4. `schema_migrations` table

For more information: http://guides.rubyonrails.org/active_record_migrations.html

Keep in mind: We can version migration files and `schema.rb` (1 and 2). But not for the real DB
schema (3 and 4). So if there are any conflicts, you then need to change in DB manually,
which should be avoided.

To avoid inconsistency between `schema.rb` and real DB schema. You can:

* `rake db:rollback` before you switch branch. OR
* Reset your database entirely. OR
* Pick changes in `schema.rb` carefully to commit.

## Do

* Re-run `rake db:migrate` and double check the changes in `db/schema.rb` before you commit it.
* Run `rake db:rollback` before commit to make sure that it is reversible.
* Avoid plain SQL in migration file. Especially DDL (create table, drop table, alter....)
* Always add index for foreign key columns.
* [Add foreign key constraints][fkey] in migrations.
* If there are default values, set them in migrations.
* Keep `db/schema.rb` under version control.
* Use `say` in migration instead of `puts`
* Set an empty string as the default constraint for non-required string and text fields in migration.

```ruby
class CreateClearanceUsers < ActiveRecord::Migration
  def change
    create_table :users  do |t|
      t.references :group, index: true # use reference to create foreign key column and index
      t.string :email, null: false # add null constraint when possible
      t.string :name, null: false, default: '' # for optional string
      t.integer :gender, null: false, default: 1 # default value for enum attribute
      t.boolean :active, null: false, default: true # default for boolean column

      t.timestamps null: false

      say 'Use say instead of puts in migration'
    end

    add_index :users, :email # add index for frequent search column
  end
end
```

[fkey]: http://robots.thoughtbot.com/referential-integrity-with-foreign-keys

## Do Nots

* Do not change a migration after it has been merged or deployed the desired
  change can be solved with another migration.
* Do not change old migration files unless it won't affect behavior or you have a very good reason.
* Do not migrate "data" in a db migration file. Use `lib/tasks/data/migrate` rake tasks instead.
