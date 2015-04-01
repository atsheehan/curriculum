In this article we'll describe how to limit access to parts of your website with **authorization** and user roles.

### Learning Goals

* Understand the difference between **authentication** and **authorization**
* Add an attribute to users defining their role
* Limit access to portions of your site via authorization

### Implementation Details

When we add [Devise](https://github.com/plataformatec/devise) to our application we are addressing the problem of **authentication**. Authentication is the process of verifying that a user is who they say they are. When someone attempts to log in to our site with a given username or email address, we want to know that we're granting access to the actual owner of that login. If we assume that only the actual user knows the password that corresponds with their login, we can be reasonably sure that the user is authentic (i.e. it is the actual user and not an impostor).

Now that a user is logged in, what are they allowed to access on our site? This is the domain of **authorization**. For a movie review site, does a user have permission to edit a review of a movie they just created? How about if they try to edit a review _someone else_ created? For most users, this would not be allowed, but maybe an admin or moderator would be able to perform this function.

Different applications have different levels of authorization complexity. For example, a social networking site might have a complex set of rules to determine which users are allowed to see or interact with other users. Other sites might have basic authorization that allows users to only interact with their own data. For this unit, we're going to add an **admin** user to an application that can be used to grant access to all parts of the site.

### User Roles

We're going to build our authorization logic on top of the authentication logic provided by [Devise](https://github.com/plataformatec/devise). When integrating Devise, we create a `users` table that looks something like this:

```ruby
create_table "users", force: true do |t|
  t.string   "email",                  default: "", null: false
  t.string   "encrypted_password",     default: "", null: false
  t.string   "reset_password_token"
  t.datetime "reset_password_sent_at"
  t.datetime "remember_created_at"
  t.integer  "sign_in_count",          default: 0,  null: false
  t.datetime "current_sign_in_at"
  t.datetime "last_sign_in_at"
  t.string   "current_sign_in_ip"
  t.string   "last_sign_in_ip"
  t.datetime "created_at"
  t.datetime "updated_at"
end
```

When a user registers, we store their e-mail address and encrypted password in this table and several other attributes for managing and monitoring their account. What we do not store is a way of distinguishing the different _types_ of users or the permissions they have. For this we'll want to include an additional field that will define their **role** in our application.

For our app, we only want two roles: admin and member. A user can only be assigned to one of the roles. We could store this as a boolean flag (e.g. `admin = true`), but a more flexible solution would be to use a string (e.g. `role = "admin"`). This would allow us to easily define additional roles in the future if the need ever arose (e.g. `role = "moderator"`).

To add this column to our `users` table we can generate a migration:

```no-highlight
$ rails generate migration add_role_to_users role:string
```

Let's modify this migration to include a default value and `NOT NULL` constraint:

```ruby
class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :string, null: false, default: "member"
  end
end
```

Running `rake db:migrate` will add the `role` column to the `users` table. Since we defined a default value of `member`, any existing users will automatically be assigned to this role. It is a good security practice to default to the most restrictive permissions and escalate them for individual users as needed. In our case, we could always go into `rails console` or connect directly to the database to promote any user from a member to an admin.

### Limiting Access

Our users now have roles associated with them. That's great, but how do we use that information? In the MVC paradigm, the controller is usually responsible for determining who has access to certain resources. When a request comes in, the controller can determine what it is trying to access and then check to see if a user is logged in and if they have the necessary permissions.

Consider an online store where we have a `Product` model that represents products for sale. On our site we want all users to be able to view these products but not necessarily create products. In this case we'll assume that only an admin user can add new products.

Let's assume we have a `ProductsController` with actions for showing a product and creating a new product. Our controller might resemble what's shown below.

```ruby
class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to @product, notice: "Successfully added product."
    else
      render :new
    end
  end

  protected
  def product_params
    params.require(:product).permit(:name, :price)
  end
end
```

We have four actions in our controller: `index`, `show`, `new`, and `create`. The `index` and `show` actions are used for displaying the product and should be available to everyone, so there is no need to check for authorization. The `new` and `create` actions are responsible for creating new products which we want to restrict to admin users only. We'll have to add an authorization check in our controller for these two actions.

With Devise, if we wanted to require a user to log in before accessing an action we used `before_action :authenticate_user!` in our controllers. This will run the `authenticate_user!` method before any of the actions in our controller. If a user is not already logged in they will be redirected to the login page.

We can do the same thing for authorization using `before_action` filters. In this case we'll check that the user is logged in **and** that they are an admin before granting access to the resource. If they do not meet that criteria, rather than redirecting them to the login page we can just return a `404 Not Found` response. Our `before_action` filters might look something like:

```ruby
class ProductsController < ApplicationController
  before_action :authorize_user, except: [:index, :show]

  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to @product, notice: 'Successfully added product.'
    else
      render :new
    end
  end

  protected
  def product_params
    params.require(:product).permit(:name, :price)
  end

  def authorize_user
    if !user_signed_in? || !current_user.admin?
      raise ActionController::RoutingError.new("Not Found")
    end
  end
end
```

The line `before_action :authorize_user, except: [:index, :show]` will run the `authorize_user` method on all actions **except** the index and show page (it is better to whitelist actions that don't require authorization than to try and blacklist everything else). The `authorize_user` method checks if the user is signed in and if they are an admin.

```ruby
def authorize_user
  if !user_signed_in? || !current_user.admin?
    raise ActionController::RoutingError.new("Not Found")
  end
end
```

The `user_signed_in?` and `current_user` methods are provided for us through [Devise](https://github.com/plataformatec/devise#controller-filters-and-helpers). Once we know the user is signed in, we then call the `admin?` method on the current user which we haven't defined yet.

What we want this method to do is return `true` if the user belongs to the _admin_ role. Let's first write behaviors in our `spec/models/user_spec.rb` file.

```ruby
describe "#admin?" do
  it "is not an admin if the role is not admin" do
    user = FactoryGirl.create(:user, role: "member")
    expect(user.admin?).to eq(false)
  end

  it "is an admin if the role is admin" do
    user = FactoryGirl.create(:user, role: "admin")
    expect(user.admin?).to eq(true)
  end
end
```

Now that we have failing behaviors, we can write implementation to get our tests to pass.

```ruby
class User < ActiveRecord::Base
  # devise method...

  def admin?
    role == "admin"
  end
end
```

The line `role == "admin"` will return true only if the user role is _admin_ and false any other time. So when we call `current_user.admin?`, we're first retrieving the user that is logged in and then asking if they are an admin or not. If they are not, then we want to return a `404 Not Found` HTTP response with the following line:

```ruby
raise ActionController::RoutingError.new("Not Found")
```

We're raising an `ActionController::RoutingError` that Rails will handle and translate to a `404 Not Found` response to the user. This means that whenever an unauthorized user attempts to access the `/products/new` path it will appear as if the page does not exist. This is intentional as we don't want to let anyone know that this page exists unless they are authorized.

### Protect Both Views and Controllers

If a user does not have access to a certain portion of a site then it doesn't make sense to show them a link to it. We can use our authorization checks in our views to conditionally show links based on a user's privileges:

```erb
<ul>
  <% if user_signed_in? %>
    <li><%= link_to "Sign Out", destroy_user_session_path, method: :delete %></li>
    <% if current_user.admin? %>
      <li><%= link_to "Admin Section", admin_path %></li>
    <% end %>
  <% else %>
    <li><%= link_to "Sign In", new_user_session_path %></li>
  <% end %>
</ul>
```

In this snippet the `Admin Section` link is only shown if a user is signed in **and** has admin privileges. It's important to remember though that even if we don't show the user a link they can still attempt to access that portion of the site directly by typing in the URL. Checking authorization in both the view **and** controller ensures that our resources remain protected.

### Resources

* [Devise Wiki: Adding an Admin Role](https://github.com/plataformatec/devise/wiki/How-To:-Add-an-Admin-role#option-2---adding-an-admin-attribute)
