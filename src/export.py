from github import Github
from github import Auth
import os

token = None
with open(os.path.expanduser('~') + "/.config/github/token", "r") as f:
    token = str(f.readline().strip())

auth = Auth.Token(token)

g = Github(auth=auth)

root = os.environ.get("ISSUE_ROOT", ".")
datefmt = '%a, %d %b %Y %H:%M:%S %z'

# Default to HumanoAI's Livetwin issues. Override with GITHUB_REPO=owner/name.
repo_name = os.environ.get("GITHUB_REPO", "bumi/livetwin")
project = os.environ.get("PROJECT", repo_name.rsplit("/", 1)[-1])

repo = g.get_repo(repo_name)
open_issues = repo.get_issues(state="all")
for issue in open_issues:
    print(issue)
    n = issue.number
    title = issue.title
    body = issue.body
    os.makedirs("%s/%d" % (root, n), exist_ok=True)
    issue_file = "%s/%d/index.md" % (root, n)
    if body is None:
        body = ''

    body = body.replace('\r\n', '\n')

    with open(issue_file, "w") as f:
        f.write("Title: " + issue.title + '\n')
        f.write("Author: " + issue.user.login + '\n')
        assignee = issue.assignee.login if issue.assignee else issue.user.login
        f.write("Assignee: " + assignee + '\n')
        f.write("Created: " + issue.created_at.strftime(datefmt) + '\n')
        f.write("State: " + issue.state + '\n')
        f.write("Project: " + project + '\n')
        f.write('\n')
        f.write(body)
        for comment in issue.get_comments():
            f.write('\n\n--%--\n')
            f.write('From: ' + comment.user.login + '\n')
            f.write('Date: ' + comment.created_at.strftime(datefmt) + '\n')
            f.write('\n')
            f.write(comment.body.replace('\r\n', '\n'))

g.close()
