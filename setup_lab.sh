#!/bin/bash

printf '%s\n' '========================================='
printf '%s\n' 'Lab 02 — Permission Breaker'
printf '%s\n' 'This script simulates a security incident'
printf '%s\n' 'by locking down files and directories.'
printf '%s\n' '========================================='
printf '\n'

chmod -x verify.sh 2>/dev/null
printf '%s\n' '[✓] verify.sh execution removed.'

chmod 000 locked_room 2>/dev/null
printf '%s\n' '[✓] locked_room locked down (000).'

chmod -x evidence/script.sh 2>/dev/null
printf '%s\n' '[✓] evidence/script.sh execution removed.'

chmod 000 evidence/log_1.txt 2>/dev/null
printf '%s\n' '[✓] evidence/log_1.txt locked from edits.'

printf '\n'
printf '%s\n' '========================================='
printf '%s\n' 'Setup complete!'
printf '%s\n' 'Your mission: repair all permissions and'
printf '%s\n' 'create the automation script.'
printf '%s\n' '========================================='
