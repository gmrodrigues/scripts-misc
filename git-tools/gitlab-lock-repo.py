#!/usr/bin/env python
# https://python-gitlab.readthedocs.io/en/stable/api-usage.html
# https://python-gitlab.readthedocs.io/en/stable/api-objects.html

import gitlab
import sys
import os
import re
from dotenv import load_dotenv
load_dotenv()

gitlabRepo = sys.argv[1] # git@...
gitlabUrl=os.getenv('GITLAB_URL')
private_token=os.getenv('GITLAB_PRIVATE_TOKEN')
new_description_template = os.getenv('GITLAB_DESC_TEMPLATE') # %s == project name, lowercase

# private token or personal token authentication (self-hosted GitLab instance)
gl = gitlab.Gitlab(url=gitlabUrl, private_token=private_token)

# Get a project by name with namespace
project_name_with_namespace = re.split(r'[\:\.]', gitlabRepo)[-2]
print(project_name_with_namespace)

project = gl.projects.get(project_name_with_namespace)
if (new_description_template):
    project.description = new_description_template % project.name.lower()
    project.save()
    print(project)

branches = project.branches.list()
for branch in branches:
    # list branches
    print(branch.name)

p_branches = project.protectedbranches.list()
for p_branch in p_branches:
    # remove protected branches access and create a new access with no rigths
    print('deleting protection on '+p_branch.name)
    p_branch.delete()

new_p_branch = project.protectedbranches.create({
    'name': '*',
    'merge_access_level': 0,
    'push_access_level': 0
})
p_branches = project.protectedbranches.list()
print(p_branches)

# Change description


