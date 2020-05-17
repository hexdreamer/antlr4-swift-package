# Antlr4

Instructions for forking a subdirectory of the antlr4 repo into another GitHub repo. We can't actually do this directly and still be able to issue pull requests, etc., but we CAN fork the entire project, and then move a subdirectory of it to a new project. Then we can have a clone on our desktop that is attached to both of them where we can push up to. The full repo can be pull-requested back into the main project, and the subdirectory can be directly used by SPM enabled projects. Sigh.

StackOverflow to the rescue:
https://stackoverflow.com/questions/29306032/fork-subdirectory-of-repo-as-a-different-repo-in-github

* Clone the repo
    git clone https://github.com/theleagueof/chunk
* Create a branch using the git subtree command for the folder only
    git subtree split --prefix=folder_name -b new_branch
    git subtree split --prefix=runtime/Swift -b antlr4-swift-package
* Create a new github repo
* Add this new repo as a remote,
    git remote add upstream https://github.com/user/repo
    git remote add upstream-antlr4-swift-package git@github.com:hexdreamer/antlr4-swift-package.git
* Push the subtree
    git git push upstream-antlr4-swift-package antlr4-swift-package

In order to build the tests, you need to mvn install the code from the main repo
JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_212.jdk/Contents/Home
mvn install -DskipTests

