# Mission 01 — Injection and Input Handling

**Audience:** Beginner to intermediate  
**Time:** 20–30 minutes  
**Target:** The local DKCISSP Juice Shop instance only

## Scenario

A tester reports that a search feature behaves unexpectedly when given unusual input. Your task is to understand how user-controlled input reaches application logic and what evidence would justify an injection finding.

## Objectives

- Identify an input field and observe normal behaviour first.
- Compare normal input with harmless special-character variations.
- Record the exact request and response behaviour that changes.
- Explain the possible root cause without assuming that every error proves injection.
- Describe a remediation and a regression test.

## Exercise

1. Open the local lab URL and navigate to a search or other input feature.
2. Submit an ordinary search term and record the visible result.
3. Try a harmless input variation, such as a single quote, and compare the response. Do not target any system outside this lab.
4. Use browser developer tools to inspect the request and response. Record only the relevant, sanitized evidence.
5. Explain what additional validation would be needed before classifying the behaviour as a confirmed injection vulnerability.

## Remediation discussion

For database-backed features, prefer parameterized queries or prepared statements. Validate input according to business requirements, use least-privileged database accounts, and avoid exposing detailed internal errors to users. Output encoding is not a substitute for parameterized database access.

## Evidence to submit

- Feature and request location.
- Normal versus unusual input behaviour.
- Evidence supporting or contradicting the hypothesis.
- Root-cause hypothesis and confidence level.
- Proposed fix and regression test.

## Completion criteria

You can distinguish a suspicious response from a confirmed vulnerability and explain how the remediation prevents the underlying class of bug.
