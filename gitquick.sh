#!/bin/bash

PROJECT=$1
BARE=$2
if [ $# -lt 2 ]
  then
    echo "# need two args one for project name ond one for git --bare dir
          # example: gitquick project project.git
          "
          exit
fi

# $project is your working directory 
# $BARE is the --bare git dir

# create git bare dir and git repo
echo "Creating directories "
echo | mkdir "$BARE" || exit
echo | mkdir "$PROJECT" || exit

# create web dir
echo "creating web dir /var/www/html/"$PROJECT
echo | mkdir "/var/www/html/"$PROJECT || exit 

cd $BARE
git init --bare
#add hook to checkout into web dir
HOOK="hooks/post-receive"
touch "$HOOK" || exit
echo  "#!/bin/bash" > $HOOK
echo  "GIT_WORK_TREE=/var/www/html/$PROJECT git checkout -f" > $HOOK
chmod +x "$HOOK"

cd ../$PROJECT
git init
# add remote with project name
git remote add $PROJECT ../$BARE
#create the first commit creating the master and head to be pushed
echo  "Project:$PROJECT" > README
git add README
git commit -m "Beginning of $PROJECT"
git push $PROJECT +master:refs/heads/master







