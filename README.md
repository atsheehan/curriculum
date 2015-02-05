# Curriculum

Contains articles, challenges, and exercises for use with the [Event Horizon][event-horizon] application.

## Directory Structure

Right now the file organization is in flux: the **exercises** directory contains the material used by [comet][comet] and the **lessons** directory contains the material used by Event Horizon. Eventually comet exercises will be incorporated into Horizon.

All **lessons** need to adhere to the following format to be imported by [Horizon][horizon-importer]:

* Each lesson has its own directory in the **lessons** directory. The name of this directory becomes the lesson **slug** which uniquely identifies that lesson (as well as appearing in the URL, e.g. */lessons/data-types*).

* In each lesson directory there is a **.lesson.yml** file containing [metadata](#user-content-lesson-metadata) about the lesson.

* The [readable content](#user-content-markdown-format) of the lesson should be in a markdown file named after the directory (e.g. for the **data-types** lesson there should be a **data-types.md** file containing the content).

## Lesson Metadata

TODO

## Lesson Types

TODO

## Markdown Format

TODO

[event-horizon]: https://github.com/LaunchAcademy/event_horizon
[comet]: https://github.com/LaunchAcademy/comet
[horizon-importer]: https://github.com/LaunchAcademy/event_horizon/blob/master/lib/tasks/import_lessons.rake
