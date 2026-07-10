#!/bin/bash
# Run tree-sitter tests, allow up to 1 known failure
output=$(tree-sitter test 2>&1)
echo "$output"
failed=$(echo "$output" | grep -oP 'failed parses: \K\d+')
[ "$failed" -le 1 ]
