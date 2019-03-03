#!/bin/bash
awk -v INDEX="$1"  '{if ($1 == INDEX) {print "OTP " INDEX " = "  $2}}' /Users/emmabell/'OneDrive - UHN'/Resources/otp_table.txt

