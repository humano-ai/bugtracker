Title: Consider distrusting Entrust certificates after 2024-11-11
Author: rodarima
Created: Sun, 08 Dec 2024 21:01:21 +0000
State: open

Following Chrome and Firefox, we may want to distrust Entrust certificated issued after November 11, 2024, following the concern on Entrust:

https://security.googleblog.com/2024/06/sustaining-digital-certificate-security.html

There is also more details in the Mozilla bugzilla:

https://bugzilla.mozilla.org/buglist.cgi?o2=greaterthaneq&short_desc_type=casesubstring&o1=notequals&v1=Graveyard&classification=Client%20Software&classification=Developer%20Infrastructure&classification=Components&classification=Server%20Software&classification=Other&classification=Graveyard&v2=2015-11-01&f1=classification&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&bug_status=RESOLVED&bug_status=VERIFIED&bug_status=CLOSED&short_desc=Entrust&f2=creation_ts&component=CA%20Certificate%20Compliance&query_format=advanced&list_id=17064895

Reported-by: dogma