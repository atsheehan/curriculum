Git is a version control system that enables us to preserve the history of our source files for our projects. In this article we'll talk about some of the benefits of version control and how we can get started using Git by making our first commit.

### Learning Goals

* Understand the benefits of version control.
* Create a new Git repository.
* View the status of a Git repository.
* Commit changes to a repository.
* View the contents of a commit with `git show`.

### What is Version Control?

Version control systems let us take snapshots of our project at points in time. If we think of our project as a collection of files, these snapshots preserve the state of those files as a whole and let us revert back to them if necessary. These snapshots are often called **commits**.

Why do we care about preserving past states of our projects? As software developers, we spend an inordinate amount of time meticulously crafting our source files so that our code runs correctly and efficiently. These source files are often our most valuable output and we want to treat them like gold. Preserving the history of our application lets us backup our files and gives us the ability to revert back to known states in case something goes wrong.

In this article we'll be focusing on Git, a popular open-source version control system used by a large number of projects.

### Configuring Git

To check if Git is installed, run the following command in a terminal:

```no-highlight
$ git --version
git version 2.1.0
```

If you don't see the version information then Git is not installed or is not available on the path. Follow the [installation instructions](http://git-scm.com/book/en/v2/Getting-Started-Installing-Git) on the Git homepage to install it on your machine.

There are a few configuration options we'll want to set before we use Git for the first time. When creating a commit, Git assigns your name and e-mail to that commit to preserve a history of who did what. We can specify the name and e-mail we want to use via the `git config` interface. Run the following commands in your terminal, replacing the name and e-mail with your own:

```no-highlight
$ git config --global user.name "Bob Loblaw"
$ git config --global user.email bob.loblaws@lawblog.blah
```

Another important aspect of creating a commit involves writing a good commit message. Although it's possible to include the commit message on the command line, it is often preferable to open a text editor to craft a nicely formatted message with additional details when necessary. Git will automatically open an editor when creating a new commit and we can specify the editor with the following command:

```no-highlight
$ git config --global core.editor "atom --wait"
```

If you're using Sublime you can use `subl -w` instead of `atom --wait`.

Once we have our name, e-mail, and editor configured, we're ready to use Git.

### Initialize a Repository

Each project we work on should exist in its own directory. With Git, we can turn that directory into a **Git repository** that will then preserve the history of all files within that directory via commits. A directory (and all nested directories) is considered a Git repository if it contains the `.git` folder (note: you can use the `ls -a` command to check to see if the `.git` directory already exists).

To work with a repository you can either create a new one using the `git init` command or download an existing project using the `git clone` command. In this article we'll focus on creating a new repository with `git init`.

Let's start by creating a new directory to contain our files for this demo. Within your preferred working directory, run the following commands to create a new directory, change into it, and initialize a new Git repository:

```no-highlight
$ mkdir git-demo
$ cd git-demo
$ git init
Initialized empty Git repository in /home/asheehan/work/git-demo/.git/
```

Now the *git-demo* directory is a Git repository and we can start committing our files.

### Add A File

To view the status of our repository we can run the `git status` command:

```no-highlight
$ git status
On branch master

Initial commit

nothing to commit (create/copy files and use "git add" to track)
```

The status command is a way to quickly view the current state of our project files (i.e. has anything been added, modified, or removed since the last commit). At this point our status indicates that we don't have any files and we haven't made any commits yet.

Let's track our list of groceries we need to purchase for the week. Run the following commands to create a file named *grocery_list* that contains each item on a separate line:

```no-highlight
$ echo "tofu" >> grocery_list
$ echo "brussel sprouts" >> grocery_list
$ echo "cat food" >> grocery_list
```

The `echo` command will normally print some text to the screen but in this case we are redirecting the output to be appended to the *grocery_list* file (via the `>>` operator). We can verify that a new file exists and contains the correct contents with the following commands:

```no-highlight
$ ls
grocery_list

$ cat grocery_list
tofu
brussel sprouts
cat food
```

The `ls` command lists all of the files in the directory and the `cat` command will print out the contents of the file.

Let's see what the status of our Git repository is now:

```no-highlight
$ git status
On branch master

Initial commit

Untracked files:
  (use "git add <file>..." to include in what will be committed)

        grocery_list

nothing added to commit but untracked files present (use "git add" to track)
```

Notice there is a new section for **untracked files**. With Git we have to specify which files we want to include in our commits. Git sees that there is a new file that hasn't been added before, but since we haven't explicitly told Git to track it it won't be included if we tried to commit right now.

We can **stage** a file to be committed using `git add`:

```no-highlight
$ git add grocery_list
$ git status
On branch master

Initial commit

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)

        new file:   grocery_list
```

Checking the status again we'll see that our new *grocery_list* file is staged to be committed. This is what we want, but one last thing to do is review the contents of the file that are about to be committed. We can view the changes being saved by running `git diff --staged`:

```no-highlight
$ git diff --staged
diff --git a/grocery_list b/grocery_list
new file mode 100644
index 0000000..7950c57
--- /dev/null
+++ b/grocery_list
@@ -0,0 +1,3 @@
+tofu
+brussel sprouts
+cat food
```

There's a lot going on here, but `git diff --staged` lets us view the contents of the commit before we actually save it. The contents are shown to us as a **diff** meaning that it will only highlight the changes we made from the previously committed file. In this case, since it is a new file all of the contents are new:

```no-highlight
+++ b/grocery_list
@@ -0,0 +1,3 @@
+tofu
+brussel sprouts
+cat food
```

The `+line` format indicates that we're adding a line to the *grocery_list* file. Diffs are an invaluable tool to quickly highlight the changes to a file without having to review the entire contents.

### Initial Commit

Now that we have our changes staged, let's go ahead and commit them:

```no-highlight
$ git commit
```

This will open up the previously configured editor where we can enter a commit message describing the changes being made. The commit message is very useful in documenting a project. There is a reason we're making changes to our app and the commit message is a way to succinctly express those reasons and include any additional information if necessary.

The format of a commit message should adhere to the following convention (taken from [here](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html):

```no-highlight
Capitalized, short (50 chars or less) summary

More detailed explanatory text, if necessary.  Wrap it to about 72
characters or so.  In some contexts, the first line is treated as the
subject of an email and the rest of the text as the body.  The blank
line separating the summary from the body is critical (unless you omit
the body entirely); tools like rebase can get confused if you run the
two together.

Write your commit message in the imperative: "Fix bug" and not "Fixed bug"
or "Fixes bug."  This convention matches up with commit messages generated
by commands like git merge and git revert.
```

The first line should summarize the changes being made in 50 characters or less. In many cases that is all that is required for a commit, but if there was any discussion about why certain changes were made it is useful to include them in the body of the commit message.

For our *grocery_list* file, we might write the following commit message:

```no-highlight
Add grocery list for the week

Brussel sprouts and cat food go really well together.
```

The first line briefly summarizes the changes in this commit (adding the grocery list) and then the body explains why certain items were included.

To complete the commit we need to shut down the editor window. For Atom, pressing `Ctrl` + `Shift` + `W` (`Cmd` + `Shift` + `W` for Mac) will close the open window and return control back to Git. For Sublime the shortcut is `Ctrl` + `W` (`Cmd` + `W` for Mac). At this point we should see a message indicating that our commit was completed:

```no-highlight
".git/COMMIT_EDITMSG" 12L, 316C written
[master (root-commit) de97cc3] Add grocery list for the week
 1 file changed, 3 insertions(+)
 create mode 100644 grocery_list
```

### Viewing the History

Congratulations, we've committed our code! Now if we check that status of our repository we should have a clean working directory:

```no-highlight
$ git status
On branch master
nothing to commit, working directory clean
```

If we want to see past commits, the `git log` command will show a history of the changes we've made:

```no-highlight
$ git log
commit de97cc3e5a657a9b8df19e9ad519bea669b42972
Author: Adam Sheehan <a.t.sheehan@gmail.com>
Date:   Tue Feb 17 15:25:34 2015 -0500

    Add grocery list for the week

    Brussel sprouts and cat food go really well together.
```

This will show all of our commits in a list. Notice how each commit includes a long string of gibberish after it. This is known as the **SHA-1 hash** and can be used to uniquely identify this commit if we ever want to view the contents or revert back to it. The `git show` command will let us view the changes that were included in a commit based on the identifier:

```no-highlight
$ git show de97cc3e5a657a9b8df19e9ad519bea669b42972

commit de97cc3e5a657a9b8df19e9ad519bea669b42972
Author: Adam Sheehan <a.t.sheehan@gmail.com>
Date:   Tue Feb 17 15:25:34 2015 -0500

    Add grocery list for the week

    Brussel sprouts and cat food go really well together.

diff --git a/grocery_list b/grocery_list
new file mode 100644
index 0000000..7950c57
--- /dev/null
+++ b/grocery_list
@@ -0,0 +1,3 @@
+tofu
+brussel sprouts
+cat food
```

The *show* command includes the commit message as well as the diff that we saw earlier. If you want to view the details of the latest commit in the current branch you can also use the `HEAD` alias instead of looking for the SHA-1 hash:

```no-highlight
$ git show HEAD

commit de97cc3e5a657a9b8df19e9ad519bea669b42972
Author: Adam Sheehan <a.t.sheehan@gmail.com>
Date:   Tue Feb 17 15:25:34 2015 -0500

    Add grocery list for the week

    Brussel sprouts and cat food go really well together.

diff --git a/grocery_list b/grocery_list
new file mode 100644
index 0000000..7950c57
--- /dev/null
+++ b/grocery_list
@@ -0,0 +1,3 @@
+tofu
+brussel sprouts
+cat food
```

### In Summary

Git is a powerful tool for managing and documenting the history of our projects.

Each project should have its own **Git repository** that stores the revision history of the files specific to that project. The `git init` command is a way to create a new repository in the current directory.

Any modifications to the files in the repository are stored as a series of **commits**. A commit contains the changes to a file as well as when the changes were made and who made them. A file must be **staged** before it will be included in a commit using the `git add` command.

A **commit message** describes the changes that a commit is making to the project. Commit messages act as an integral part of a projects documentation and can be used to identify why certain changes were made and any justification that went along with it.

We can view the history of a repository using the `git log` command. Each commit has a unique SHA-1 hash that allows us to reference those changes and view them using the `git show` command (among others).
