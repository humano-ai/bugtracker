from github import Github
from github import Auth
import os

token = None
with open(os.path.expanduser('~') + "/.config/github/token", "r") as f:
    token = str(f.readline().strip())

auth = Auth.Token(token)

g = Github(auth=auth)

root = "."
datefmt = '%a, %d %b %Y %H:%M:%S %z'

repo = g.get_repo("dillo-browser/dillo")
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
        f.write("Created: " + issue.created_at.strftime(datefmt) + '\n')
        f.write("State: " + issue.state + '\n')
        f.write('\n')
        f.write(body)
        for comment in issue.get_comments():
            f.write('\n\n--%--\n')
            f.write('From: ' + comment.user.login + '\n')
            f.write('Date: ' + comment.created_at.strftime(datefmt) + '\n')
            f.write('\n')
            f.write(comment.body.replace('\r\n', '\n'))

g.close()
