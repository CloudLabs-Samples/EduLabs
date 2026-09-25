## MetaData
Question Type : Single Choice

## Question
7. After you enabled the managed identity in Lab 2, the upload failed with HTTP 403 and the error code `AuthorizationFailure`. What does that error code indicate?

## Options

Option 1 : The token was issued for the wrong resource audience, so storage could not work out who the caller was

Option 2 : The identity was authenticated, but it lacked a data-plane role that allows it to write blobs to the container

Option 3 : The storage firewall rejected the request because of the network it came from, before any role was checked

Option 4 : Shared key access is disabled on the account, so a request not signed with an account key is refused

## Answers
Option 3 : 1

## Number of Retries
1
