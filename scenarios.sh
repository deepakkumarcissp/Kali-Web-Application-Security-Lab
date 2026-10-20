#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
export DKCISSP_PORT="${DKCISSP_PORT:-1002}"
BASE_URL="http://127.0.0.1:${DKCISSP_PORT}"

BLUE='\033[0;34m'; GREEN='\033[0;32m'; YELLOW='\033[0;33m'; RESET='\033[0m'
info() { printf "${BLUE}[DKCISSP]${RESET} %s\n" "$*"; }
ok() { printf "${GREEN}[  OK  ]${RESET} %s\n" "$*"; }
note() { printf "${YELLOW}[NOTE ]${RESET} %s\n" "$*"; }
pause() { printf "\nPress Enter to continue..."; read -r _; }
header() {
  printf "\n============================================================\n"
  printf " DKCISSP | LOCAL WEB SECURITY TEST SCENARIOS\n"
  printf "============================================================\n"
  printf "Target: %s\n" "$BASE_URL"
  printf "Scope: local training lab only\n\n"
}
check_target() {
  if ! command -v curl >/dev/null 2>&1; then
    note "curl is not installed. Start the lab and install curl to run the target check."
    return 1
  fi
  if ! curl --silent --fail --max-time 2 "$BASE_URL/" >/dev/null; then
    note "The lab did not respond. Start it first with: ./lab.sh start"
    return 1
  fi
  ok "Local Juice Shop target responds over HTTP."
}
step() {
  printf "\n%s\n" "$1"
  printf "%s\n" "$2"
  pause
}
access_control() {
  header
  printf "SCENARIO: BROKEN ACCESS CONTROL\n"
  printf "Goal: determine whether the server enforces ownership and permissions.\n"
  printf "This guide does not automatically exploit the target. You perform the\n"
  printf "observations in the local browser and record what actually happens.\n"
  pause
  step "STEP 1 — Establish normal behavior" "1. Open $BASE_URL in your Kali browser.\n2. Create/use a dedicated training account; do not use real credentials.\n3. Sign in and navigate to an account-specific area such as your basket or order history.\n4. Record the page and the action you are testing."
  step "STEP 2 — Inspect the request" "1. Press F12 and open the Network tab.\n2. Perform the normal action again.\n3. Select the relevant request and note its URL, method, status code, and whether it includes a resource identifier.\n4. Do not copy cookies, tokens, passwords, or personal data into your report."
  step "STEP 3 — Check the authorization boundary" "Use only the local training app and test data. Follow the app's intended challenge or use a second test account if needed. Check whether a request for a resource not owned by the signed-in test user is denied by the server. Do not guess at real users' identifiers or access anyone else's data."
  step "STEP 4 — Interpret the result" "Expected secure behavior: the server denies access to another user's resource (typically 403, or 404 where existence is intentionally concealed) and does not return the protected data.\n\nA changed identifier or unusual status code alone is not proof. Confirm the response body and repeat with a known allowed resource and a known disallowed resource."
  step "STEP 5 — Record evidence" "Record: test date, target URL, feature, test account labels (not credentials), request method/path, status code, sanitized response summary, expected vs observed result, and confidence. Avoid recording session cookies or sensitive data."
  step "STEP 6 — Remediation and retest" "Recommended control: enforce authorization on the server for every request, derive the user identity from the authenticated session, verify ownership/permissions for the requested object, and deny by default. Retest both allowed access and denied cross-user access after the fix."
  printf "\n"
  ok "Guided access-control scenario completed. No vulnerability has been asserted automatically."
  printf "Next: save your observations in your test notes and decide whether the evidence supports a finding.\n"
}
injection_guide() {
  header
  printf "SCENARIO: INJECTION AND INPUT HANDLING\n\n"
  printf "1. Open the local target and search for an ordinary term such as apple.\n"
  printf "2. Open browser Developer Tools (F12) > Network and repeat the search.\n"
  printf "3. Try a harmless single quote as a separate search term.\n"
  printf "4. Compare request, response, errors, and results. A changed response alone is not proof of injection.\n"
  printf "5. Record sanitized evidence and recommend parameterized queries/safe APIs.\n\n"
  printf "Target: %s\n" "$BASE_URL"
  note "Use only this local lab. Do not run these tests against systems without authorization."
}
xss_guide() {
  header
  printf "SCENARIO: CROSS-SITE SCRIPTING (XSS)\n\n"
  printf "1. Find a feature in the local app that displays user-controlled text.\n"
  printf "2. Submit ordinary text first and observe where it appears.\n"
  printf "3. Follow a dedicated Juice Shop challenge or use a harmless, non-destructive marker.\n"
  printf "4. Inspect the rendered DOM and distinguish text from interpreted markup.\n"
  printf "5. Record evidence and recommend safe text APIs/context-aware output encoding.\n\n"
  printf "Target: %s\n" "$BASE_URL"
  note "Do not use payloads that steal data, access browser storage, or affect other users."
}
menu() {
  while true; do
    header
    printf "Choose a guided scenario:\n"
    printf "  1) Broken Access Control — full step-by-step guide\n"
    printf "  2) Injection — input-handling checklist\n"
    printf "  3) Cross-Site Scripting (XSS) — safe testing checklist\n"
    printf "  4) Check local target health\n"
    printf "  0) Exit\n\n"
    printf "Selection: "
    read -r choice
    case "$choice" in
      1) check_target || { pause; continue; }; access_control ;;
      2) check_target || { pause; continue; }; injection_guide; pause ;;
      3) check_target || { pause; continue; }; xss_guide; pause ;;
      4) check_target; pause ;;
      0) exit 0 ;;
      *) note "Please choose 0, 1, 2, 3, or 4."; pause ;;
    esac
  done
}
menu
