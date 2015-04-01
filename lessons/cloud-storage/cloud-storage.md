In this article we describe how to store user uploaded files in the cloud with **Amazon S3** and the **CarrierWave** gem.

### Learning Goals

* Sign up for an AWS account
* Configure a new S3 bucket to store files
* Configure CarrierWave to store files in an S3 bucket
* Load API keys from environment variables
* Manage API keys outside of the git repository

### Scaling File Storage

When we're in development mode trying to build our applications we can often get away with less-than-optimal performance. We can run our web and database servers directly on our laptops because that is what is quick and easy to setup. A quick and easy setup often leads to faster development times since we can focus on building new features rather than configuring our machines.

When we want to deploy our code to production, we care less about what is quick and easy and more about performance and reliability. We want our websites to be fast and we want them to be resilient when things start breaking down. We can deploy our code to heavily-optimized web servers dedicated to serving HTTP requests as fast as possible and massive database servers with terabytes of redundant storage.

When it comes to storing user uploaded files, our local file system is OK for development but we run into issues when moving to a production environment:

* How do we scale storage space on-the-fly without interrupting the site?
* How do we handle backups and data loss from failed disks?
* How do we ensure that files are available amongst multiple web servers?

In this case it makes more sense to utilize a cloud storage solution that is optimized for efficient, resilient storage of files that can easily scale as our web app grows.

### Amazon Web Services

Amazon offers a suite of services known as [Amazon Web Services (AWS)](http://aws.amazon.com/) that provide production-grade performance and reliability that we can use when deploying our applications. The service that we're interested in is Amazon's [Simple Storage Service (S3)](http://aws.amazon.com/s3/). S3 acts as a very large file system which we can use to store uploaded files.

To get started you'll need to [sign in to or sign up for an AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html). Once you're registered you can access the [AWS Console](https://console.aws.amazon.com/) to view the suite of services available.

### Create a User Account

Before we begin, let's create a new user account so that we limit access to only S3:

1. From the AWS Console click on the [IAM (Identity and Access Management)](https://console.aws.amazon.com/iam) service.
2. In the left panel click on the link for **Users**.
3. Click on the **Create New Users** button.
4. Enter a username for the user and ensure the *Generate an access key for each User* is selected.
5. Click **Create**.
6. Once the user is created a dialog box will appear with their security credentials. Copy the *Access Key ID* and *Secret Access Key* to a safe place and don't share with anyone. These will be required to access the S3 bucket from our Rails application.
7. Select the newly created user and click on the *Permissions* tab.
8. Click on the **Attach User Policy** button to assign this user permissions.
9. In the *Select Policy Template* menu, select the **Amazon S3 Full Access** option and click **Apply Policy**.

Now we have a user configured that can only access the S3 service.

### Create an S3 Bucket

S3 organizes files in **buckets** which we can use to store our user uploaded files. Let's create a bucket for our production environment:

1. From the AWS Console click on the [S3](https://console.aws.amazon.com/s3/) service.
2. Click on the **Create Bucket** button.
3. Choose a name for the bucket. If your app is named **peanut_butter_jelly_time**, you might want to create a bucket called **peanut_butter_jelly_time_production** to store files uploaded in the production environment.
4. Select the **US Standard** Region and click **Create**.

At this point we have a blank bucket setup that we can use to dump files into. You might also want to create a bucket for the development environment as well to test out the S3 integration (e.g. create another bucket called **peanut_butter_jelly_time_development**).

### Integrating S3 with CarrierWave

When a user uploads a file we want to put the file in the bucket on S3 rather than in the `public/uploads` directory on our web server. To do this we can configure the storage options for CarrierWave to talk directly to S3.

The CarrierWave documentation has a section on [integrating Amazon S3](https://github.com/carrierwaveuploader/carrierwave#using-amazon-s3) that you should review. This integration requires three changes:

* Add the `fog` gem to our `Gemfile`.
* Specify the storage option in the Uploader class.
* Configure the AWS credentials.

For example, if we had created an uploader in `app/uploaders/profile_photo_uploader.rb`, we can modify it to choose a different storage option when in a production environment:

```ruby
class ProfilePhotoUploader < CarrierWave::Uploader::Base
  if Rails.env.production? || Rails.env.development?
    storage :fog
  else
    storage :file
  end
end
```

This will use S3 when deployed to a production environment and use the local filesystem for development and testing environments.

The last change we need to make is for configuring our security credentials with AWS. Add a file in `config/initializers/carrierwave.rb` that contains the following:

```ruby
CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: "AWS",
    aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
    aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
  }
  config.fog_directory  = ENV["S3_BUCKET"]
end
```

Now when we start our Rails application, it will read our security credentials from environment variables so that we can connect to our S3 bucket.

### Specifying Environment Variables

Notice how we didn't explicitly include our AWS credentials in our source code. Even if our code is open-source, there are still things that we wish to keep private. Rather than hard-coding in these secret values, we can assume that whoever is running this application has predefined certain **environment variables** that contain this information.

We could set the environment variables in the shell using the `export` command:

```no-highlight
$ export AWS_ACCESS_KEY_ID=...key_goes_here...
```

This would work but it can get rather tedious to have to run this command each time we restart our machine. An alternative is to store our environment variables in a file that is loaded whenever we start our Rails application.

We'll store our variables in the `.env` file and load them using the `dotenv-rails` gem. It's **very** important to ensure that the `.env` file is **not** included in our repository since it will contain sensitive information. To ensure it does not get added we should add an entry to our `.gitignore` file that excludes this path:

```no-highlight
# Ignore environment variables
.env
```

It's important that this is added **before** we create the `.env` file.

Now that we know our environment file won't be picked up in a commit, we can create the `.env` file in the root of our Rails application that looks something like:

```no-highlight
AWS_ACCESS_KEY_ID=AKIYOURKEYGOESHEREOA2VA
AWS_SECRET_ACCESS_KEY=0NtSREPLACEWITHYOURSECRETKEYjmYAHRGlVoyR
S3_BUCKET=peanut_butter_jelly_time_development
```

We just need to add the `dotenv-rails` gem to our `Gemfile`:

```ruby
group :development, :test do
  gem "dotenv-rails"
end
```

Once we run `bundle` and restart our Rails application, our environment variables will be loaded from the `.env` file.

### Setting Environment Variables on Heroku

Since we aren't committing our `.env` to our repository, we need some other way to pass our AWS security credentials to Heroku when we deploy. Heroku provides a way for us to set environment variables directly using the `heroku config` command.

To see which environment variables have already been configured, run the following command in your application directory (assuming you've already deployed to Heroku):

```no-highlight
$ heroku config

=== peanut-butter-jelly-time Config Vars
DATABASE_URL:                 ...snip
DB_NAME:                      ...snip
HEROKU_POSTGRESQL_COBALT_URL: ...snip
LANG:                         en_US.UTF-8
PGBACKUPS_URL:                ...snip
RACK_ENV:                     production
RAILS_ENV:                    production
SECRET_KEY_BASE:              ...snip
```

We can see that Heroku is reading our database credentials and secret key base (used for securing sessions) from environment variables. We also want to set our AWS credentials so we can add a few more environment variables with the `heroku config:set` command:

```no-highlight
$ heroku config:set AWS_ACCESS_KEY_ID=AKIYOURKEYGOESHEREOA2VA
$ heroku config:set AWS_SECRET_ACCESS_KEY=0NtSREPLACEWITHYOURSECRETKEYjmYAHRGlVoyR
$ heroku config:set S3_BUCKET=peanut_butter_jelly_time_production
```

Now when we deploy our application, our CarrierWave initializer will be able to read our AWS credentials from the environment.
