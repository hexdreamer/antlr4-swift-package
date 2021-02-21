# Antlr4

This repository exists basically as a fork of the main repo: https://github.com/antlr/antlr4.git. Xcode can only use an entire repository as an included Swift Package Manager package, so the one that exists in the subdirectory runtime/Swift will not work "out of the box". I'm hoping to get any changes in this directory pulled back up to the main repo.

## Instructions for Making Your Own
We can't actually fork this repo off from the main repo directly and still be able to issue pull requests, etc., but we CAN fork the entire project, and then move a subdirectory of it to a new project. Then we can have a clone on our desktop that is attached to both the full fork and the subdirectory fork. The full fork can be pull-requested back into the main project, and the subdirectory fork can be directly used by SPM enabled projects. Sigh.

StackOverflow to the rescue:
https://stackoverflow.com/questions/29306032/fork-subdirectory-of-repo-as-a-different-repo-in-github

* Clone the repo


    git clone https://github.com/hexdreamer/antlr4.git
    
* Create a branch using the git subtree command for the folder only


    git subtree split --prefix=runtime/Swift -b antlr4-swift-package
    
* Create a new github repo at https://github.com/hexdreamer/antlr4-swift-package.git

* Add this new repo as a remote


    git remote add upstream-antlr4-swift-package https://github.com/hexdreamer/antlr4-swift-package.git
    
* Push the subtree


    git push upstream-antlr4-swift-package antlr4-swift-package

## Updating This Project From The Main Repository
### Sync our fork of Antlr4 from the upstream main repo
* check out fresh version of hexdreamer/antlr4


    git clone git@github.com:hexdreamer/antlr4.git
    
* sync with upstream:
    * https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/configuring-a-remote-for-a-fork
    * https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/syncing-a-fork


    cd antlr4
    git remote add upstream https://github.com/antlr/antlr4
    git fetch upstream
    git merge upstream/main

* perform a new split on the repo


    git subtree split --prefix=runtime/Swift -b antlr4-swift-package


## Sync this repo with the upstream we just created
* check out the existing anltr4-swift-package


    cd ..
    git clone git@github.com:hexdreamer/antlr4-swift-package.git

* do a similar upstream merge with antlr4-swift-package


    cd antlr4-swift-package
    git remote add upstream ../antlr4
    git fetch upstream
    git merge upstream/antlr4-swift-package

## Build Notes

In order to build the tests, you need to mvn install the code from the main repo. The full suite of tests aren't working for me, and end up filling my disk, so I skip them. You also need to have JAVA_HOME defined, which is now in a weird place on the latest macOS. Your location may vary.

    JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_212.jdk/Contents/Home
    export JAVA_HOME
    mvn install -DskipTests
