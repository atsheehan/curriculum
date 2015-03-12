Branching in Git allows us to easily switch between multiple versions of a codebase. In this article we'll discuss why branching is useful and how we can branch and merge our changes from the command line.

### Learning Goals

* Commit changes to a separate branch
* View the differences between branches
* Merge changes between two branches
* Resolve a merge conflict

### What is Branching?

One of the benefits of a version control system is the ability to store snapshots of a codebase at various points in time. In Git we can store these snapshots by creating [commits](/lessons/git-commit) that package up our changes and assign them labels so we can revisit them later.

After the first commit is created, every subsequent commit builds off the previous one. This forms a linear chain of commits that document the history of our project. To work with the latest version of our codebase we can look at the end of the chain.

This linear progression is great for ordering the history of a project, but there are times when we want to break out of this single chain of commits and have multiple **branches**. Rather than having every commit build on top of the next one, we can have multiple commits that build off the same starting point and go their own way.

Why would we want to start creating branches? One of the most common use cases is when multiple developers are working on the same project but on separate features. A developer will start with the latest version of the main development branch (often known as **master**) and create a new branch specific to their feature. Now they are free to work on their branch without interrupting (or being interrupted by) other developers committing to the master branch. When their feature is complete, they can **merge** their separate branch back into master.

Branches are useful even on projects with a single developer. Sometimes it is helpful to create a separate branch to experiment with some new feature that we're uncertain will be useful or feasible. Any commits to that feature will be specific to that branch and won't affect the master development branch. With branches, we can have several features in development simultaneously with minimal cost to switch between them.

### Creating Branches

To demonstrate how we can use branches, let's start with a simple Git repository containing one commit:

```no-highlight
$ mkdir branching-demo
$ cd branching-demo
$ git init
Initialized empty Git repository in ~/branching-demo/.git/

$ echo "this is from the first commit" > README
$ git add -A
$ git commit -m "Initial commit"
[master (root-commit) 8b9c3d9] Initial commit
 1 file changed, 1 insertion(+)
 create mode 100644 README
```

At this point we have a README file with a single line in it:

```no-highlight
$ cat README
this is from the first commit
```

Our initial commit was saved on the **master** branch by default. To view the list of branches we have available we can run the `git branch` command:

```no-highlight
$ git branch
* master
```

At the moment we only have a single branch named *master*. The asterisk next to the name indicidates that this is the branch that we're currently working on.

Assuming we're about to start work on something we'll call feature A, let's create a new branch that will contain our changes:

```no-highlight
$ git branch feature-a

$ git branch
  feature-a
* master
```

`git branch feature-a` will create a new branch off of the current commit. When we run `git branch` we can see that there are two names now. Even though we've created a separate branch, we're still working off of *master* until we explicitly switch over.

### Switching Between Branches

To switch between branches we can use the `git checkout` command:

```no-highlight
$ git checkout feature-a
Switched to branch 'feature-a'

$ git branch
* feature-a
  master
```

Now we're currently on the *feature-a* branch. At this point both *feature-a* and *master* contain the same commits since we haven't made any changes since creating the branch. If there is a difference between two branches, Git will update any of the files after a checkout to reflect the state of the currently checked-out branch.

Let's make a change on our *feature-a* branch:

```no-highlight
$ echo "this is for feature A" >> README
$ git add -A
$ git commit -m "Test commit for feature A"
[feature-a 2da1894] Test commit for feature A
 1 file changed, 1 insertion(+)
```

We've updated the README file and sealed that in a commit. Now there is a difference between the *feature-a* branch and *master* which we can view using `git diff`:

```no-highlight
$ git diff master

diff --git a/README b/README
index 6bf2cdb..343ec2a 100644
--- a/README
+++ b/README
@@ -1 +1,2 @@
 this is from the first commit
+this is for feature A
```

This shows that the difference between our current branch and *master* is the one line added to the README. When we view the history of commits we'll see both of the commits we've made so far:

```no-highlight
$ git log --oneline
2da1894 Test commit for feature A
8b9c3d9 Initial commit
```

Let's switch back to *master* and see what it looks like there:

```no-highlight
$ git checkout master
Switched to branch 'master'

$ git log --oneline
8b9c3d9 Initial commit

$ cat README
this is from the first commit
```

Notice how when we run `git log` again we only get back our first commit. Our other commit still exists but it is currently on the *feature-a* branch. Also, the *README* file was updated to reflect our first commit.

Let's create another branch off of master to start work on another feature B:

```no-highlight
$ git branch feature-b
$ git checkout feature-b
Switched to branch 'feature-b'

$ echo "this is for feature B" >> README
$ git add -A
$ git commit -m "Test commit for feature B"
[feature-b f287f09] Test commit for feature B
 1 file changed, 1 insertion(+)

$ git checkout master
Switched to branch 'master'
```

Here we've created and checked out a new branch, committed a change, and then switched back to *master*.

### Merging

At this point we should have three branches:

* *master* with only a single commit.
* *feature-a* with an additional commit on top of master.
* *feature-b* with an additional commit on top of master that is distinct from *feature-a*.

One way we can view this in Git is via the `git log` command which provides a wealth of options for displaying the history of a repository:

```no-highlight
$git log --all --graph --abbrev-commit --decorate

* commit f287f09 (feature-b)
| Author: Adam Sheehan <a.t.sheehan@gmail.com>
| Date:   Thu Mar 12 14:48:02 2015 -0400
|
|     Test commit for feature B
|
| * commit 2da1894 (feature-a)
|/  Author: Adam Sheehan <a.t.sheehan@gmail.com>
|   Date:   Thu Mar 12 14:33:21 2015 -0400
|
|       Test commit for feature A
|
* commit 8b9c3d9 (HEAD, master)
  Author: Adam Sheehan <a.t.sheehan@gmail.com>
  Date:   Thu Mar 12 14:16:27 2015 -0400

      Initial commit
```

The output is a bit dense, but we have all three commits and how they're linked from the dashes along the side, as well as what each branch currently points to.

Branching wouldn't be very useful if we didn't have a way to bring these commits back to our main development branch (i.e. the *master* branch in this case). What we want to do now is to **merge** the feature branches back into the *master* branch.

Whenever merging branches, we're taking a separate branch and *merging it into the current branch*. Since we want to merge *feature-a* and *feature-b* into *master*, let's make sure we have the *master* branch checked out:

```no-highlight
$ git checkout master
```

Now we have to choose which branch we want to merge in. To merge in the *feature-a* branch, we can run the following command:

```no-highlight
$ git merge feature-a

Updating 8b9c3d9..2da1894
Fast-forward
 README | 1 +
 1 file changed, 1 insertion(+)
```

The `git merge feature-a` command brought any commits from the *feature-a* branch into *master*. If we check our *README* file we should see that it has been updated:

```no-highlight
$ cat README
this is from the first commit
this is for feature A
```

Checking our commit log we notice that the master branch contains the same commits as the *feature-a* branch:

```no-highlight
$ git log --all --graph --abbrev-commit --decorate

* commit f287f09 (feature-b)
| Author: Adam Sheehan <a.t.sheehan@gmail.com>
| Date:   Thu Mar 12 14:48:02 2015 -0400
|
|     Test commit for feature B
|
| * commit 2da1894 (HEAD, master, feature-a)
|/  Author: Adam Sheehan <a.t.sheehan@gmail.com>
|   Date:   Thu Mar 12 14:33:21 2015 -0400
|
|       Test commit for feature A
|
* commit 8b9c3d9
  Author: Adam Sheehan <a.t.sheehan@gmail.com>
  Date:   Thu Mar 12 14:16:27 2015 -0400

      Initial commit
```

Since we've merged in the changes from *feature-a*, both *master* and *feature-a* are identical. We no longer really have a use for the *feature-a* branch so we can go ahead and delete it at this point:

```no-highlight
$ git branch -d feature-a
Deleted branch feature-a (was 2da1894).
```

### Merge Conflicts

Now we have two branches left: *master* and *feature-b*. Let's go ahead and merge *feature-b* into *master*:

```no-highlight
$ git merge feature-b
Auto-merging README
CONFLICT (content): Merge conflict in README
Automatic merge failed; fix conflicts and then commit the result.
```

Now we've run into an issue. Both branches *feature-a* and *feature-b* included a commit that modified the same file in the same location (i.e. both added a second line to the README file). Which commit should be used to update the README? Should both lines be included or only one of them? If both, which order should they be added?

These are questions that Git cannot answer because Git doesn't assume anything about what the developers intended. Rather, Git notifies the user that there is a **merge conflict** and will pause the merge until it has been resolved.

We can check the status to view what files are in conflict:

```no-highlight
$ git status
On branch master
You have unmerged paths.
  (fix conflicts and run "git commit")

Unmerged paths:
  (use "git add <file>..." to mark resolution)

        both modified:   README
```

Here it indicates that both branches have modified the *README* file and that it cannot be merged as-is. What Git will do though is highlight the conflicting parts of a file and show what each side of the merge has changed:

```no-highlight
$ cat README
this is from the first commit
<<<<<<< HEAD
this is for feature A
=======
this is for feature B
>>>>>>> feature-b
```

Any parts of the file that have been modified by both branches will be marked using this format:

```no-highlight
<<<<<<< HEAD
any conflicting changes made by the current branch
=======
any conflicting changes made by the branch being merged
>>>>>>> branch-to-merge
```

At this point it is up to the developer to edit the file and clear up these conflicts. Open up the *README* file in any editor, delete the `<<<`, `===`, and `>>>` characters, and then choose which portions you want to keep from both branches. Assuming we want to keep the lines from both branches we can edit the file to resemble the following:

```no-highlight
this is from the first commit
this is for feature A
this is for feature B
```

We're still in a merge conflict though so we need to let Git know we're finished resolving the changes. Save this file and then add and commit:

```no-highlight
$ git add README
$ git commit -m "Merge feature-b"
```

Now we've successfully merged both feature branches back into *master*. We no longer need *feature-b* anymore so we can go ahead and delete that branch:

```no-highlight
$ git branch -d feature-b
Deleted branch feature-b (was f287f09).
```

If we look at the commit log we'll see that *master* now contains all of the commits we've made so far:

```no-highlight
$ git log --all --graph --abbrev-commit --decorate
*   commit 2162c57 (HEAD, master)
|\  Merge: 2da1894 f287f09
| | Author: Adam Sheehan <a.t.sheehan@gmail.com>
| | Date:   Thu Mar 12 15:24:43 2015 -0400
| |
| |     Merge feature-b
| |
| * commit f287f09
| | Author: Adam Sheehan <a.t.sheehan@gmail.com>
| | Date:   Thu Mar 12 14:48:02 2015 -0400
| |
| |     Test commit for feature B
| |
* | commit 2da1894
|/  Author: Adam Sheehan <a.t.sheehan@gmail.com>
|   Date:   Thu Mar 12 14:33:21 2015 -0400
|
|       Test commit for feature A
|
* commit 8b9c3d9
  Author: Adam Sheehan <a.t.sheehan@gmail.com>
  Date:   Thu Mar 12 14:16:27 2015 -0400

      Initial commit
```

### In Summary

Git **branches** allow us to work on separate features simultaneously and easily switch between them. They are an essential tool for collaboration between multiple developers and for experimenting with features before commiting them to the main development branch.

The `git branch` command will list the available branches on a repository. `git branch <branch_name>` will create a new branch with the given name starting from the current commit. To switch between branches, use the `git checkout <branch_name>` command.

Branches can be combined by **merging** them together. To merge another branch into the currently checked out branch, run the `git merge <branch_name>` command. This will merge the other branch into the current one.

If two branches have overlapping modifications, Git will issue a **merge conflict**. A merge conflict requires a developer to inspect the conflicting files and determine which changes to keep or discard.
