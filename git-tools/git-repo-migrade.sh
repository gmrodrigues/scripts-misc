#!/bin/bash
# script to migrate git repo to other as a mirror
FROM_REPO=$1
TO_REPO=$2

BRANCH=master
TO_REPO_BASE_SITE='https://bitbucket.org/smengineering/'
FOLLOWUP_INSTRUNCTIONS='Projeto migrado para o bitbucket'


if [ "$FROM_REPO" = "" ]; then
    echo "Usage:"
    echo "$0 <git@from-repo> <git@to-repo>"
    exit
fi

echo "Danger!!!"
echo "Are you shure do you want to force push $FROMForce"
echo "Into $TO_REPO?"
echo "If you continue you will destroy data on"
echo "  << $FROM_REPO"
echo "  and replace it with a mirror copy of"
echo "  >> $TO_REPO"
echo "Be carefull: "
read -p "Continue (y/n)?" CONT
if [ "$CONT" = "y" ]; then
  FROM_BASEDIR=$(basename "$FROM_REPO")
  set -xe
  git clone --bare --mirror "$FROM_REPO" "$FROM_BASEDIR"
  cd "$FROM_BASEDIR"
  git push --mirror "$TO_REPO"
  cd ..
  rm -rf "$FROM_BASEDIR"
  set +xe
  echo ""
  echo "# now go to host and past the following:"
  echo cd  "$FROM_BASEDIR"
  echo git log -n 1
  echo 'CURRBRANCH=$(git rev-parse --abbrev-ref HEAD)'
  echo git remote rename origin gitlab
  echo git remote add origin "$TO_REPO"
  echo '--------------'
  echo 'cat ~/.ssh/*.pub'
  echo '--------------'
  echo git fetch --all
  echo git branch -r
  echo git branch --set-upstream-to=origin/$BRANCH
  echo 'git branch --set-upstream-to=origin/$CURRBRANCH'
  echo "########################################################################################"
  echo "# travar a master de $FROM_REPO e mudar descrição do projeto:"
  echo "# ${FOLLOWUP_INSTRUNCTIONS}: ${TO_REPO_BASE_SITE}$(basename $TO_REPO | sed -s 's/.git//')"

else
    echo "Quit"
fi

# no servidor
