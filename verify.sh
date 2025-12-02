#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

printf '%s\n' '--- VERIFICATION PROTOCOL ---'
FAIL=0

if [ -r "locked_room/secret.txt" ]; then
  printf "%b[PASS]%b Locked room is readable.\n" "$GREEN" "$NC"
else
  printf "%b[FAIL]%b locked_room/secret.txt is not readable.\n" "$RED" "$NC"
  FAIL=1
fi

if [ -x "evidence/script.sh" ]; then
  printf "%b[PASS]%b Evidence script is executable.\n" "$GREEN" "$NC"
else
  printf "%b[FAIL]%b evidence/script.sh still lacks execute permission.\n" "$RED" "$NC"
  FAIL=1
fi

if [ -w "evidence/log_1.txt" ]; then
  printf "%b[PASS]%b log_1.txt is writable.\n" "$GREEN" "$NC"
else
  printf "%b[FAIL]%b log_1.txt cannot be written by you.\n" "$RED" "$NC"
  FAIL=1
fi

if grep -q 'Case Closed' evidence/log_1.txt 2>/dev/null; then
  printf "%b[PASS]%b Closure note detected in log_1.txt.\n" "$GREEN" "$NC"
else
  printf "%b[FAIL]%b Add a closure note to log_1.txt.\n" "$RED" "$NC"
  FAIL=1
fi

if [ ! -f "fix_system.sh" ]; then
  printf "%b[FAIL]%b fix_system.sh is missing.\n" "$RED" "$NC"
  FAIL=1
elif [ ! -x "fix_system.sh" ]; then
  printf "%b[FAIL]%b fix_system.sh exists but is not executable.\n" "$RED" "$NC"
  FAIL=1
else
  printf "%b[PASS]%b fix_system.sh found and executable.\n" "$GREEN" "$NC"
fi

if [ -x "fix_system.sh" ]; then
  rm -rf test_env
  mkdir -p test_env/nested
  touch test_env/nested/sample.txt
  touch test_env/nested/sample.sh
  chmod 777 test_env/nested/sample.txt
  chmod 644 test_env/nested/sample.sh

  ./fix_system.sh test_env >/dev/null 2>&1

  PERM_TXT=$(stat -f "%Lp" test_env/nested/sample.txt 2>/dev/null || stat -c "%a" test_env/nested/sample.txt)
  PERM_SH=$(stat -f "%Lp" test_env/nested/sample.sh 2>/dev/null || stat -c "%a" test_env/nested/sample.sh)

  if [ "$PERM_TXT" = "644" ]; then
    printf "%b[PASS]%b Text files hardened to 644.\n" "$GREEN" "$NC"
  else
    printf "%b[FAIL]%b sample.txt permissions are %s (expected 644).\n" "$RED" "$NC" "$PERM_TXT"
    FAIL=1
  fi

  if [ "$PERM_SH" = "700" ]; then
    printf "%b[PASS]%b Shell scripts hardened to 700.\n" "$GREEN" "$NC"
  else
    printf "%b[FAIL]%b sample.sh permissions are %s (expected 700).\n" "$RED" "$NC" "$PERM_SH"
    FAIL=1
  fi

  if [ -f "audit.log" ]; then
    printf "%b[PASS]%b audit.log exists.\n" "$GREEN" "$NC"
  else
    printf "%b[FAIL]%b audit.log was not created.\n" "$RED" "$NC"
    FAIL=1
  fi

  rm -rf test_env
fi

if [ "$FAIL" -eq 0 ]; then
  printf '%s\n' '---------------------------------'
  printf "%bSYSTEM SECURE - PASS%b\n" "$GREEN" "$NC"
  exit 0
else
  printf '%s\n' '---------------------------------'
  printf "%bSYSTEM INSECURE - CHECK INSTRUCTOR NOTES%b\n" "$RED" "$NC"
  exit 1
fi
