# Mission 02 — Broken Access Control

**Audience:** Beginner to intermediate  
**Time:** 20–30 minutes  
**Target:** The local DKCISSP Juice Shop instance only

## Scenario

A web application has user-specific records. The security team wants evidence that the server enforces authorization rather than relying on the interface to hide data.

## Objectives

- Distinguish authentication (who you are) from authorization (what you may do).
- Identify a user-specific resource in the local training app.
- Explain why changing a client-side identifier is not itself proof of a vulnerability.
- Recommend a server-side authorization check and a retest.

## Exercise

1. Explore the application using its normal UI and note which resources are associated with your test account.
2. Inspect the relevant browser request and identify whether a resource identifier is sent.
3. In the local training app only, investigate whether the server independently verifies that the authenticated test user may access the requested resource. Do not use real accounts or data.
4. Record the observed response and whether it provides evidence of an authorization failure.
5. Describe a server-side authorization rule that would prevent access across users.

## Remediation discussion

Enforce authorization on every server-side request to a protected object. Derive identity from the authenticated session, verify ownership or explicit permissions, deny by default, and test both allowed and denied access paths.

## Evidence to submit

- Resource and action under test.
- Expected versus observed authorization decision.
- Sanitized request/response evidence.
- Proposed server-side rule.
- Positive and negative regression tests.

## Completion criteria

You can explain why UI restrictions are insufficient and how to validate object-level authorization safely.
