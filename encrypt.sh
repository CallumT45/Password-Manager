#!/bin/bash
#Master password
password="$1"
plaintext="$2"
#Plain data to encrypt


echo "$plaintext" | \
        openssl aes-256-ctr -e -base64 -pass "pass:$password"

