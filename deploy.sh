#!/bin/bash

set -e # exit with nonzero exit code if anything fails

if [[ $TRAVIS_BRANCH == ${GH_SRC} && $TRAVIS_PULL_REQUEST == "false" ]]; then

echo "Starting to update master\n"

#copy data we're interested in to other place
cp -R public $HOME/public

#go to home and setup git
cd $HOME
git config --global user.email "bjnhur@gmail.com"
git config --global user.name "bjnhur"

#using token clone gh-pages branch
git clone --quiet --branch=${GH_DST} https://${GH_TOKEN}@github.com/${GH_USER}/${GH_REPO}.git ${GH_DST} > /dev/null

#go into directory and copy data we're interested in to that directory
cd ${GH_DST}
cp -Rf $HOME/public/* .

echo "Allow files with underscore https://help.github.com/articles/files-that-start-with-an-underscore-are-missing/" > .nojekyll
echo "[View live](https://${GH_USER}.github.io/${GH_REPO}/)" > README.md

#add, commit and push files
git add -f .
git commit -m "Travis build $TRAVIS_BUILD_NUMBER"
git push -fq origin ${GH_DST} > /dev/null

echo "Done updating master\n"

else
 echo "Skipped updating master, because build is not triggered from the master branch."
fi;
