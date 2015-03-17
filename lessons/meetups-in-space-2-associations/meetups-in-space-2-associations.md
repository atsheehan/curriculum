### Learning Objectives

* Use ActiveRecord to associate tables
* Retrieve information from a database using ActiveRecord

### Instructions

* Create ActiveRecord models for each table in your database. They should be saved under `app/models`.
* Set up your models to use ActiveRecord associations. (This may involve making changes to your original plan for your schema - if that is the case, change your schema by adding new migrations, and be sure to update your ER diagram accordingly!)
* Once both of these steps are done, continue to fulfill the [user stories](meetups-in-space-1) specified yesterday by using ActiveRecord to query your database and displaying that information on your erb pages.

### Tips

1. **Before you start writing any code**, take some time to think about how your database structure should be reflected in ActiveRecord associations.
2. Work on completing one user story at a time.
3. You will need to use a [has_many :through association][has-many-through].

### Resources

* [Active Record Query Interface][active-record-query-interface]
* [Active Record Associations][active-record-associations]

[github-app-settings]: https://github.com/settings/applications
[meetup]: http://www.meetup.com/
[active-record-query-interface]: http://guides.rubyonrails.org/active_record_querying.html
[active-record-associations]: http://guides.rubyonrails.org/association_basics.html
[has-many-through]: http://guides.rubyonrails.org/association_basics.html#the-has-many-through-association
[localhost]: http://localhost:4567

### Optional Additional Challenges

If you are interested, here are some optional additional user stories to implement:

```no-highlight
As a user
I want to see who has already joined a meetup
So that I can see if any of my friends have joined
```

Acceptance Criteria:

* On the details page for a meetup, I should see a list of the members that have already joined.
* I should see each member's avatar.
* I should see each member's username.

```no-highlight
As a user
I want to leave a meetup
So that I'm no longer listed as a member of the meetup
```

Acceptance Criteria:

* I must be authenticated.
* I must have already joined the meetup.
* I see a message that lets me know I left the meetup successfully.

```no-highlight
As a user
I want to leave comments on a meetup
So that I can communicate with other members of the group
```

Acceptance Criteria:

* I must be authenticated.
* I must have already joined the meetup.
* I can optionally provide a title for my comment.
* I must provide the body of my comment.
* I should see my comment listed on the meetup show page.
* Comments should be listed most recent first.
