In this article we discuss how we can allow users to upload files in a Rails application using the **CarrierWave** library.

### Learning Goals

* Allow users to upload files via an HTML form
* Attach uploaded files to a model

### Uploading Files

In many applications users will need to upload some sort of file to the web application. This may include uploading images to a photo album, documents they want to share, assignments they need to submit, and so on. To allow this we need to provide a form where a user can select a file from their computer and upload it to our servers.

HTML forms support file uploading through the `<input type="file">` element. Browsers will display a dialog for the user to select a file from their local computer and then include the file contents as part of the HTTP request. The file is not part of the standard key-value parameters found in an HTTP POST body but is appended as a separate section of the body. To support this we also have to let our `<form>` tag know that we'll have multiple parts to our request using the `enctype` attribute:

```html
<form action="/upload" method="post" enctype="multipart/form-data">
  <div>
    <input name="some-file" type="file">
	<input value="Upload" type="submit">
  </div>
</form>
```

Rails supports creating forms that accept file uploads using `form_for`. When the user submits the form, the controller receives the raw data through the parameters and needs to write the contents of the file to disk. More information on handling file uploads in Rails can be found in the [Form Helpers Guide](http://guides.rubyonrails.org/form_helpers.html#uploading-files).

### Carrierwave

Often when a file is uploaded we want to store it in a certain location, associate it with some model, and optionally perform some sort of post-processing. For example, if a user uploaded a profile photo, we need to ensure it is stored in a publicly accessible place (so that it can be displayed on a web page), that the file is associated with the currently signed in user, and possibly resize the photo so that it fits correctly on the page.

To help manage this process we can use a RubyGem called [CarrierWave](https://github.com/carrierwaveuploader/carrierwave). Using CarrierWave has several benefits over rolling our own file upload code:

* Can configure where files are stored (locally or on another server).
* Integrates with ActiveRecord to easily associate files with models.
* Includes optional hooks for image post-processing with ImageMagick.

The [documentation](https://github.com/carrierwaveuploader/carrierwave#carrierwave) for CarrierWave walks us through the process of integrating it with our application, but the essential steps are listed here:

1. Add the gem as a dependency.
2. Create an uploader that defines where the files will be stored.
3. Add an attribute to our model to store the file location.
4. Integrate the uploader with the model.

Assuming we wanted to add a profile photo to an application with a `User` model, we can first install the gem by adding it to our `Gemfile`:

```ruby
gem "carrierwave"
```

Download and install the gem with the `bundle` command:

```no-highlight
$ bundle
Installing carrierwave 0.10.0
...
```

Now we need an uploader that will store the profile photos. We can create one using a generator that comes with CarrierWave:

```no-highlight
$ rails generate uploader ProfilePhoto
```

This will create a new file in `app/uploaders/profile_photo_uploader.rb`. If we take a look at the file we'll see lots of options for configuring the uploader but right now we're concerned with where the file is stored:

```ruby
class ProfilePhotoUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
```

The `storage :file` option specifies that the file is stored locally on the web server (i.e. our laptops). This is fine for development but we'll want to change this later when we deploy to our production servers.

The `store_dir` method specifies the directory that we can find our uploaded files in. By default the path will start in the `public` folder so that the uploaded files are accessible. If we mount this uploader on the `User` model, the full path would be `/public/uploads/user/profile_photo/#{user.id}/file_name`. Each user will have their own directory to prevent other users from overwriting files with the same name.

Now that we have the uploader, we need to add a column to our `users` table so that we can store the location of the file. Let's create a migration to add the `profile_photo` column:

```no-highlight
$ rails generate migration add_profile_photo_to_users
```

We can modify our migration file to include the following:

```ruby
class AddProfilePhotoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :profile_photo, :string
  end
end
```

Once we run this migration we'll now have a place to store the profile photo associated with each user.

The final step is to attach the `ProfilePhotoUploader` we created with the `User` model via the `profile_photo` column. We can add the following line to the `User` model:

```ruby
class User < ActiveRecord::Base
  mount_uploader :profile_photo, ProfilePhotoUploader
end
```

Now we can call the `profile_photo` method on a `User` model and it will return the details of the uploaded file.

To complete the profile photo upload feature we'll also need to add a place on our user registration form that allows the user to select an image on their computer. With `form_for` we can add something like:

```erb
<%= f.file_field :profile_photo %>
```

If we're using the `simple_form` gem, it might look something like:

```erb
<%= f.input :profile_photo, type: :file %>
```

These methods will add the `<input type="file">` element to our forms so that it will present a dialog to the user for selecting a file.

One final step is to ensure that the profile photo can pass through the strong parameters on the users controller. If we're using Devise we can inject new attributes for the sign up process using a before filter that we can define in `app/controllers/application_controller.rb`:

```ruby
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :profile_photo
  end
end
```

At this point a user should be able to select a profile photo when creating or updating their registration and the image will be associated with the user.

### Excluding Uploaded Files From Git

When we're testing our app in development mode we'll end up uploading files to the `public/uploads` folder in our Rails application. These files are mostly for testing and shouldn't be committed so we'll want to ensure that we ignore any files that up here.

To prevent certain files and folders from being included in commits we can take advantage of the `.gitignore` file. In the root of our Rails application we can edit `.gitignore` to include the following line at the end of the file:

```no-highlight
# Ignore uploaded files in test/development
/public/uploads
```

Now whenever we stage files to be committed, any files within the `public/uploads` directory will be ignored. One caveat is that if a file has already been committed in `public/uploads` it won't be deleted. To remove these files you'll need to run `git rm -rf public/uploads` and commit before adding the line to `.gitignore`.

Note that although `.gitignore` specifies which files to exclude from the repository, the actual `.gitignore` file itself should be included.
