# Credential handling

## Remaining payment credential cleanup

- Removed test-login examples and the checked-in SDK administrator-password fallback. Configure fresh test credentials through `SecuXAccountManager.setAdminAccount(name:password:)`; missing configuration returns the existing missing-token result before HTTP. HTTP request/response logs that could expose credentials have also been removed.
- This repository vendors SDK sources. Reinstalling older Pods can reintroduce the original behavior. Consume an updated upstream SDK before reinstalling dependencies.
- The example no longer automatically runs account/payment actions on launch. Call `configureDemo(account:adminName:adminPassword:)` and explicitly invoke the intended test action.

This cleanup removes the identified values/artifacts from the current branch. It does not revoke server accounts, rotate deployed device keys, rewrite Git history, remove old tags/releases, or automatically resolve scanner alerts. Treat previously published usable credentials as exposed and have their owners revoke or rotate them. Use new, narrowly scoped test credentials if development resumes.
