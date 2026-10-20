# Mission 03 — Cross-Site Scripting (XSS)

**Audience:** Beginner to intermediate  
**Time:** 20–30 minutes  
**Target:** The local DKCISSP Juice Shop instance only

## Scenario

A feature displays user-controlled content. The team needs to understand whether that content is treated as data or interpreted as executable browser markup.

## Objectives

- Identify where untrusted input is displayed.
- Understand the difference between HTML text and executable markup.
- Explain why context-aware output encoding matters.
- Recommend a fix and a regression test.

## Exercise

1. Find a feature in the local training app that displays user-controlled text.
2. Start with ordinary text and observe where it appears.
3. Use a harmless, non-destructive test string in the local app to investigate how the browser interprets the output. Do not use this exercise against any other site or collect browser data.
4. Inspect the relevant DOM and request/response behaviour.
5. Describe the correct output-handling approach for the relevant context.

## Remediation discussion

Prefer safe text APIs and framework defaults. Apply context-appropriate output encoding, avoid unsafe HTML insertion, and use a restrictive Content Security Policy as defense in depth rather than as the primary fix.

## Evidence to submit

- Input source and display context.
- Observed browser behaviour.
- Root-cause hypothesis.
- Proposed safe output handling.
- Regression test demonstrating that input is displayed as data.

## Completion criteria

You can explain the difference between input validation and output encoding, and identify a fix appropriate to the output context.
