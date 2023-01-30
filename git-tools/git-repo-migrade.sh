#!/bin/bash
# script to migrate git repo to other as a mirror
# Veja exemplo de uso no final do script
FROM_REPO=$1
TO_REPO=$2

TO_REPO_BASE_SITE='https://bitbucket.org/smengineering/'
FOLLOWUP_INSTRUNCTIONS='Projeto migrado para o bitbucket'


if [ "$FROM_REPO" = "" ]; then
    echo "Usage:"
    echo "$0 <git@from-repo> <git@to-repo>"
    exit
fi

echo "Danger!!!"
echo "Are you shure do you want to destroy $TO_REPO"
echo "Force and replace it with a copy of $FROM_REPO?"
echo "If you continue you will clone a bare mirror of"
echo "  << $FROM_REPO"
echo "  and force push this mirror copy into"
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
  echo "# now go to project host and paste the following commands on terminal:"
  echo cd  "$FROM_BASEDIR"
  echo git log -n 1
  echo 'CURRBRANCH=$(git rev-parse --abbrev-ref HEAD)'
  echo git remote rename origin gitlab
  echo git remote add origin "$TO_REPO"
  echo 'less ~/.ssh/*.pub'
  echo git fetch --all
  echo git branch -r
  echo 'git branch --set-upstream-to=origin/$CURRBRANCH || echo there wasnt current branch, but its ok'
  echo "########################################################################################"
  echo "# travar a master de $FROM_REPO e mudar descrição do projeto:"
  echo "# ${FOLLOWUP_INSTRUNCTIONS}: ${TO_REPO_BASE_SITE}$(basename $TO_REPO | sed -s 's/.git//')"

else
    echo "Quit"
fi

##################
# Exemplo de uso:
# git-tools [glauberrodrigues]> ./git-repo-migrade.sh git@code.allin.com.br:remarketing/BTG-Panel-Multi-Channel.git git@bitbucket.org:smengineering/btg-panel-multi-channel.git
# Danger!!!
# Are you shure do you want to destroy git@bitbucket.org:smengineering/btg-panel-multi-channel.git
# Force and replace it with a copy of git@code.allin.com.br:remarketing/BTG-Panel-Multi-Channel.git?
# If you continue you will clone a bare mirror of
#   << git@code.allin.com.br:remarketing/BTG-Panel-Multi-Channel.git
#   and force push this mirror copy into
#   >> git@bitbucket.org:smengineering/btg-panel-multi-channel.git
# Be carefull: 
# Continue (y/n)?y
# + git clone --bare --mirror git@code.allin.com.br:remarketing/BTG-Panel-Multi-Channel.git BTG-Panel-Multi-Channel.git
# Cloning into bare repository 'BTG-Panel-Multi-Channel.git'...
# remote: Enumerating objects: 2360, done.
# remote: Counting objects: 100% (23/23), done.
# remote: Compressing objects: 100% (17/17), done.
# remote: Total 2360 (delta 8), reused 19 (delta 5), pack-reused 2337
# Receiving objects: 100% (2360/2360), 11.59 MiB | 267.00 KiB/s, done.
# Resolving deltas: 100% (1348/1348), done.
# + cd BTG-Panel-Multi-Channel.git
# + git push --mirror git@bitbucket.org:smengineering/btg-panel-multi-channel.git
# Enumerating objects: 2360, done.
# Counting objects: 100% (2360/2360), done.
# Delta compression using up to 8 threads
# Compressing objects: 100% (817/817), done.
# Writing objects: 100% (2360/2360), 11.59 MiB | 3.12 MiB/s, done.
# Total 2360 (delta 1348), reused 2360 (delta 1348)
# remote: Resolving deltas: 100% (1348/1348), done.
# To bitbucket.org:smengineering/btg-panel-multi-channel.git
#  + 8518ba7...3a5d2f1 master -> master (forced update)
#  * [new branch]      homol -> homol
#  * [new branch]      task-aops-301 -> task-aops-301
#  * [new branch]      refs/merge-requests/1/head -> refs/merge-requests/1/head
#  * [new branch]      refs/merge-requests/1/merge -> refs/merge-requests/1/merge
#  * [new branch]      refs/merge-requests/2/head -> refs/merge-requests/2/head
#  * [new branch]      refs/merge-requests/2/merge -> refs/merge-requests/2/merge
#  * [new branch]      refs/merge-requests/3/head -> refs/merge-requests/3/head
#  * [new branch]      refs/merge-requests/4/head -> refs/merge-requests/4/head
#  * [new branch]      refs/merge-requests/4/merge -> refs/merge-requests/4/merge
#  * [new branch]      refs/merge-requests/5/head -> refs/merge-requests/5/head
#  * [new branch]      refs/merge-requests/5/merge -> refs/merge-requests/5/merge
#  * [new branch]      refs/merge-requests/6/head -> refs/merge-requests/6/head
#  * [new branch]      refs/merge-requests/6/merge -> refs/merge-requests/6/merge
#  * [new branch]      refs/merge-requests/7/head -> refs/merge-requests/7/head
#  * [new branch]      refs/merge-requests/8/head -> refs/merge-requests/8/head
#  * [new branch]      refs/merge-requests/8/merge -> refs/merge-requests/8/merge
#  * [new branch]      refs/merge-requests/9/head -> refs/merge-requests/9/head
#  * [new branch]      refs/merge-requests/9/merge -> refs/merge-requests/9/merge
# + cd ..
# + rm -rf BTG-Panel-Multi-Channel.git
# + set +xe

# # now go to project host and paste the following commands on terminal:
# cd BTG-Panel-Multi-Channel.git
# git log -n 1
# CURRBRANCH=$(git rev-parse --abbrev-ref HEAD)
# git remote rename origin gitlab
# git remote add origin git@bitbucket.org:smengineering/btg-panel-multi-channel.git
# less ~/.ssh/*.pub
# git fetch --all
# git branch -r
# git branch --set-upstream-to=origin/$CURRBRANCH
# ########################################################################################
# # travar a master de git@code.allin.com.br:remarketing/BTG-Panel-Multi-Channel.git e mudar descrição do projeto:
# # Projeto migrado para o bitbucket: https://bitbucket.org/smengineering/btg-panel-multi-channel
