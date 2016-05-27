# Git Protocol

A guide for programming within version control.

* Avoid including files in source control that are specific to your development machine or process.
* Perform work in a feature branch. If someone commit directly into `develop` branch. Revert and ask for a pull request.
* Use a pull request for code reviews.
* Use a pull request and label as `work in progress` to get early feedbacks.
- **Send coherent history**. Make sure each individual commit in your pull request is meaningful.
  If you had to make multiple intermediate commits while developing, please squash them before
  sending them.
- **One pull request per feature**. If you want to do more than one thing, send multiple pull requests.
- **Divided into two pull requests if needed**. For example, code change with a long running db
  migration might break production (because the DB is not ready for the new code yet). Solution
  is to divide deployment. Run only migration first than update the code to read the new column.
  Do the opposite for deleting column.
* Ask for a code review in the project's chat room.
* A team member other than the author reviews the pull request.
* Follow [Code Review guidelines](/protocol/code-review.md) to avoid miscommunication.
* Make comments and ask questions directly on lines of code in the GitHub web interface.
* Delete remote feature branches after merging.

## Commit message format

- **Subject line should be capitalized and no period at the end**.
- **Second line should always be empty line**.
- **Use the imperative mood in the subject line**. See [How to Write a Git Commit Message] for detail.
  - ✔ Add this to that
  - ✘ Added this to that
  - ✘ Adding this to that

[How to Write a Git Commit Message]: http://chris.beams.io/posts/git-commit/#imperative

## Pull Request template

Given that `BE-000` is the jira ticket number.

Title:

```
BE-000 Title goes here
```

Description:

```
https://honestbee.atlassian.net/browse/BE-000

## Why is this change necessary?

-

## How does it address the issue?

-

## What side effects does this change have?

-

## How it was tested?

-

## Deploy note

-
```

Notes:

* Deploy note is to memo things to do around deployment. For example, Run `rake data:migrate:be_999:do_something` after deploy.
* Delete sections not applicable. (But why and How are requried)
* You can also do this for commit message. Especially when it is the only commit in pull request. GitHub will automatically fill the form for you.

Examples:

* https://github.com/honestbee/HB-Backend/pull/1193
* https://github.com/honestbee/HB-Backend/pull/982
