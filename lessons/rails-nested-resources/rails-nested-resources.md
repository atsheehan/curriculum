Many resources in web applications exhibit a parent-child relationship where the child's existence depends on the parent. In this article we'll discuss **nested resources** as a way of organizing our application's routes to simplify the management of these resources.

### Learning Goals

* Identify parent-child relationships between resources
* Nest resources to limit child resources to a specific parent
* Use shallow nesting to avoid long and ambiguous URLs

### Rails Resources

In Rails applications we tend to think of the information we store in terms of **resources**. A resource can be any entity that we may want to view or modify in some way. We organize our URLs around these resources in an intuitive way that keeps our application consistent and easy to use.

For example, an e-commerce application may have *products* and *purchases* as resources. To visit a particular product we can request `GET /products/42` which will find and display the details for a product with an identifier of 42. To purchase a product we can submit a request to `POST /purchases` with our order details in the body. To view the list of purchases we made in the past we can visit `GET /purchases`.

### Parent-Child Relationships

This organization of our URLs around resources works when each resource can exist independently. Let's consider adding reviews to our e-commerce application. If we wanted to view a list of reviews for a product, which URL should we visit?

Reviews themselves are just another resource that we're managing so it might make sense to use `GET /reviews`, but this does not specify which product we're reviewing. Another option is to visit `GET /products/42` to view the product details, but maybe this will only contain a the most recent or top-voted reviews for the product.

If we think about the relationship between products and reviews, a product can exist without any reviews but a review needs the product before it can be created. Another way of thinking about this relationship is that the product is the **parent** and the review is the **child**. The parent comes first which can then have zero or more children. This often mirrors a **one-to-many** relationship between tables in a database.

Keeping this relationship in mind, we can reorganize our URLs to *nest* one resource within another. If we want to view all reviews for a given product, we can visit `GET /products/42/reviews`. Submitting a new review to `POST /products/42/reviews` would associate the review to product 42. We refer to these as **nested resources** within a Rails application and are used to capture the parent-child relationship between resources.

### Defining Routes

Consider a simplified version of our e-commerce application with both products and reviews as our resources. If we allow viewing products and submitting reviews, a first pass at our routes might look something like:

```ruby
Rails.application.routes.draw do
  resources :products, only: [:index, :show]
  resources :reviews, only: [:index, :new, :create]
end
```

This will define five routes between these two resources:

```no-highlight
    Prefix Verb URI Pattern             Controller#Action
  products GET  /products(.:format)     products#index
   product GET  /products/:id(.:format) products#show
   reviews GET  /reviews(.:format)      reviews#index
           POST /reviews(.:format)      reviews#create
new_review GET  /reviews/new(.:format)  reviews#new
```

Both `GET /products` and `GET /products/:id` can exist as top-level resources because we can view a list of products or a single product independently. But consider the new review form at `GET /reviews/new`. Which product are we reviewing? Maybe there is a drop-down menu where we can choose the product to review but that can quickly become tedious as the number of products grows.

If we choose to nest our reviews under products we can reorganize our routes as such:

```ruby
Rails.application.routes.draw do
  resources :products, only: [:index, :show] do
    resources :reviews, only: [:index, :new, :create]
  end
end
```

Our routes will now take on a slightly different format:

```no-highlight
            Prefix Verb URI Pattern                                 Controller#Action
   product_reviews GET  /products/:product_id/reviews(.:format)     reviews#index
                   POST /products/:product_id/reviews(.:format)     reviews#create
new_product_review GET  /products/:product_id/reviews/new(.:format) reviews#new
          products GET  /products(.:format)                         products#index
           product GET  /products/:id(.:format)                     products#show
```

The `GET /products` and `GET /products/:id` routes are unchanged, but notice how the routes for reviews are prefixed with `/product/:product_id`. This enables us to submit to `POST /products/42/reviews` to create a review for product 42. Likewise, visiting `GET /products/42/reviews` will display reviews that are specific to that one product.

### Accessing Nested Resources

In addition to the route changes, we also need to update our views and controllers correspondingly. When using the `form_for` helper we need to specify both resources involved bound together in an array:

```erb
<h1>New Review for <%= @product.name %></h1>

<%= form_for [@product, @review] do |f| %>
  <%= f.label :body %>
  <%= f.text_field :body %>

  <%= f.submit %>
<% end %>
```

The call to `form_for [@product, @review]` will generate a form that will submit the review for the given product. Notice that we don't have to specify the product ID anywhere in the form body. This information is passed through the URL rather than through some input field.

We also need to update our reviews controller to extract this product ID from the URL:

```ruby
class ReviewsController < ApplicationController
  def index
    @product = Product.find(params[:product_id])
    @reviews = @product.reviews
  end

  def new
    @product = Product.find(params[:product_id])
    @review = Review.new
  end

  def create
    @product = Product.find(params[:product_id])
    @review = Review.new(review_params)
    @review.product = @product

    if @review.save
      flash[:notice] = "Review saved successfully."
      redirect_to product_path(@product)
    else
      flash[:alert] = "Failed to save review."
      render :new
    end
  end
end
```

Notice how we're using `params[:product_id]` in our actions rather than `params[:id]`. This is to identify the ID that belongs to the parent resource (products in this case) rather than the child. When we are saving the review we can explicitly assign the product that was identified in the URL:

```ruby
# POST /products/42/reviews
def create
  @product = Product.find(params[:product_id])
  @review = Review.new(review_params)
  @review.product = @product

  if @review.save
    # ...
```

The first line of this method will find the product with ID = 42 and subsequently assign it to the newly created review before it is saved.

### Shallow Nesting

Once a review has been persisted to the database it is auto-assigned a unique ID. If we wanted to view this review on its own page we might visit a URL like `GET /products/42/reviews/314`. This would display the review with ID = 314 that is associated to the product with ID = 42.

What would happen if the user modified the URL to visit `GET /products/42/reviews/271`? Maybe it would load the review with ID = 271, but what if that doesn't correspond to the product with ID = 42? Which ID do we trust if there is a mismatch? Since the URL is clearly visible to the user and we don't have control over what they submit, we run into issues where supplying too much information in the URL can lead to ambiguity.

What if we simplified the URL to `GET /reviews/314`? Do we have enough information from this URL to display the review and the associated product it belongs to? We can easily find the review based on the ID given to us. A review will most likely contain the `product_id`, so if we have the review we can find the product:

```ruby
# GET /reviews/314
def show
  @review = Review.find(params[:id])
  @product = @review.product
end
```

Once a review has been persisted to the database, it contains enough information to exist as a top-level resource. It is only when we are creating a new review or listing reviews for a particular product that we need to nest it. We can reorganize our resources to allow some actions to be nested while others are top-level:

```ruby
Rails.application.routes.draw do
  resources :products, only: [:index, :show] do
    resources :reviews, only: [:index, :new, :create]
  end

  resources :reviews, only: [:show]
end
```

This is referred to as **shallow nesting** and helps us avoid defining unnecessarily long and ambiguous URLs.

Shallow nesting is especially beneficial when we have resources that are grandchildren of the parent resource. Consider adding support for commenting on a review. To create a new comment on a review with ID = 314 that is associated to product with ID = 42 we might start with:

```no-highlight
POST /products/42/reviews/314/comments
```

We saw earlier how this could lead to ambiguity so let's reduce it to just containing the review ID:

```no-highlight
POST /reviews/314/comments
```

Because we have the review ID we can find the corresponding product if we need it. We can modify our routes to support this new configuration:

```ruby
Rails.application.routes.draw do
  resources :products, only: [:index, :show] do
    resources :reviews, only: [:index, :new, :create]
  end

  resources :reviews, only: [:show] do
    resources :comments, only: [:new, :create]
  end
end
```

Using this pattern of shallow nesting, we can define arbitrary parent-child relationships without ever having to nest more than one level deep.

### Resources

* [Rails Guide to Nested Resources](http://guides.rubyonrails.org/routing.html#nested-resources)
