## Let's integrate some third party, frontend tools

Elon Musk and his team of product managers want to create a better user
experience. 

Oftentimes, you'll be asked to leverage open source, frontend tools and plugins.
In this challenge, we'll integrate the wonderful [Chosen][chosen-lib] library
and deploy our application. Chosen enhances browser `<select>` elements to make
them easier to use.

The lead developer from SpaceX has modified the application to account for the
Chosen library, and she has left incorporating the actual library up to us. In
this challenge, we'll learn how to integrate third party, frontend plugins like
chosen.

## Instructions

### Switch Launchtails to the `asset-pipeline` branch

Clone the [repository][launchtails-gh] if you haven't already. `cd` into the
directory and check out the `asset-pipeline` branch with the following command:

```no-highlight
git fetch origin && git checkout -b asset-pipeline --track origin/asset-pipeline
```

Run `bundle && rake db:create db:migrate db:test:prepare` to ensure your
application is set up properly.

### Download and extract the Chosen Library

From the [main website][chosen-lib], hit the Downloads link and download the
latest zip found on the subsequent page.

### Move Assets into your source code

Note how the chosen library contains stylesheets, javascripts, and images.
When we incorporate third party assets like the Chosen library, it's best to
store them in `vendor/assets`. This qualifies them as assets we did not create,
which signifies to other developers that these files should really not be modified.

We want to copy the `chosen.jquery.min.js` file to the
`vendor/assets/javascripts/chosen` directory of your launchtails application. 
Create the directory if necessary.

We also want to copy the `chosen.min.css` file to the
`vendor/assets/stylesheets/chosen` directory of your launchtails application. 
Create the directory if necessary

We will need to copy the images to a different directory. Copy both images to
`app/assets/images/vendor/chosen` directory. Create the directories as needed.

### Add the assets to the javascript and stylesheet manifests

We will have to modify the `app/assets/stylesheets/application.css` and the
`app/assets/javascripts/application.js` to account for these files. When dealing
with assets in the `vendor/assets` directory, it is a good idea to restart the
server each time you modify a manifest.

To ensure your `/app/assets` assets take precedence, be sure to add references to
these libraries at the top of your manifests, and not at the bottom. Because
chosen is dependent on jquery, you should include it below jquery related
requires in your `app/assets/javascripts/application.js` file.

If all is well, the new drink form's category select should look like the one on
the [example site][example-site] in development.

In order for our integration to look right in production, we still have some
work to do.

### Modify the `app/assets/stylesheets/chosen_overrides.scss` file and add it to the manifest

Due to the way in which Rails precompiles assets, we must modify some of the
stylesheet rules that chosen defines. A `app/assets/stylesheets/chosen_overrides.scss` file has been
created for you, but it is incomplete. 

Utilize the variables at the top of the file, along with the `image-url` scss
helper to ensure our images will properly display in production.

### Prepare the application for deployment

Make the modifications necessary to prepare the applciation for deployment. You
will likely have to modify your `Gemfile` to do so.

### Ensure all is well in production

Commit your work and deploy a version of your application to heroku. To deploy,
use the following commands:

```no-highlight
heroku create
git push heroku asset-pipeline:master
heroku run rake db:migrate && heroku restart
heroku open
```

It should look like [our example
site][example-site]. Note the arrow and magnifying glass images on the demo
site, and ensure the same ones appear on your production application.

## Tips and More Detail

* We have supplied a seed file for you. Running `rake db:seed` will supply featured and nonfeatured drinks in your development environment.
* Run `rails server` in your terminal to run the web server.
* We've created some files already for you.
* You should not have to change your view files to incorporate the Chosen
  library. That work has been done for you.

[launchtails-gh]: https://github.com/LaunchAcademy/launchtails
[chosen-lib]: http://harvesthq.github.io/chosen/
[example-site]: https://calm-caverns-5528.herokuapp.com/drinks/new
