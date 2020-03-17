#!/bin/bash

#$1 the master password
#$2 Encrypted data to decrypt
password="$1"
ciphertext="$2"

echo "$ciphertext" | \
    openssl aes-256-ctr -d -base64 -pass "pass:$password"
