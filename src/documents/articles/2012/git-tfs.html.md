--- yaml
layout: 'article'
title: 'Git-Tfs'
author: 'Youngjae Choi'
date: '2012-04-27'
tags: ['Git', 'Tfs', 'Team Foundation Server']
---

Git-Tfs– Where Have You Been All My Life

My very first encounter with a version control system was CVS. I’ve used this tool for many years (late 90’s, early 2000’s), learning a lot of best practices about source control usage in the process. But there was a lot of friction as well. That is why I switched to Subversion many years ago and I’ve been pretty happy with it ever since. Sure, it has its quirks but at the very least it is a lot better than Visual SourceSafe which was an established alternative back in the days, especially in the Microsoft space.    

Fast forward a couple of years. With a few exceptions, Visual SourceSafe has been replaced with TFS Version Control in those run-of-the-mill enterprise corporations. This was quite an improvement but also a lot of the friction remained, at least in my humble opinion. Just as with Visual SourceSafe, TFS is being forced upon entire flocks of developers, mostly by management and/or non-coding architects. I still find this to be quite odd as managers never tend to use TFS themselves as this is generally considered a developer tool.

Anyway, this is usually the part where one starts writing down a five page rant against TFS. But I’m not going to. Why? Because I decided to  look for a good solution instead and holy sweet batman, I found one. A while back I decided to learn more about Git. It’s definitely not a silver bullet either but I was so impressed with all its capabilities that I moved all the code for my home projects from Subversion to Git. But the largest friction remained. I was still forced to use TFS day in and day out. But a couple of weeks ago I ran into this post from Richard Banks where he discussed a plugin for Git named git-tfs. This extension is basically a two-way bridge between TFS and Git that lets you treat TFS source control as a remote repository. The way Git works is that the entire repository is contained in a local .git folder. This way it’s able to play nicely with a TFS repository as they don’t collide.      

Setting up git-tfs is quite easy. Just download the latest version, put it in a directory and add the location to the PATH environment variable. Now you’re good to go.

To get the source from a TFS repository you have to execute the ‘git tfs clone’ command.

	git tfs clone http://some_tfs_server:8080 $/some_team_project/trunk

Note that by using this command, it will fetch the entire history by retrieving all change sets. If you’re anxious to get started (as I first was  ), then there’s also the ‘git tfs quick-clone’ command that will skip the history and just get the latest version.  

	git tfs quick-clone http://some_tfs_server:8080 $/some_team_project/trunk

All source files that are fetched from a TFS repository are also no longer read-only, which is quite nice compared to how TFS source control does things. Now that you have all the source files, you can start by adding a .gitignore file and follow the development workflow that you would normally use with Git.

Suppose that you completed a new feature and you want to push those changes back into TFS. This can be done using the ‘git tfs shelve’ command.

git tfs shelve user_story_x

This will create a shelve set that contains the changes which you can then unshelve and check in as you would normally do with TFS source control. The latest release of git-tfs even lets you check in your source files directly without needing to shelve. This can be achieved by using the ‘git tfs ct’ command. Note that this only works for TFS 2010.  

Suppose that another developer on your team checked in some code in TFS that you want to pull into your local working copy. For this you can use the ‘git tfs pull’ command that first fetches the latest change sets and merges them with your version of the code.    

One thing that you also need to take into account are the TFS source control bindings. These are stored directly in the solution file (horrible, just horrible). When opening the solution in Visual Studio, I just choose to work offline and reestablish the bindings when I’m back in TFS.

If you’re forced to use TFS source control and you’re fed up with it, then I strongly advice you to learn more about Git, install git-tfs and be merry. Kudos to all the contributors of this wonderful open-source project. You guys are truly amazing!  

I hope this helps.
