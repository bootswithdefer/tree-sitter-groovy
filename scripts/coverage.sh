#!/usr/bin/env bash
# Verify every named node type in the grammar is exercised by at least one
# test case in test/corpus/. Exits non-zero if any node type is uncovered.
set -euo pipefail
cd "$(dirname "$0")/.."

python3 - <<'PY'
import json, re, sys, glob

# Named, non-hidden node types the grammar can produce
types = json.load(open("src/node-types.json"))
named = {t["type"] for t in types if t.get("named") and not t["type"].startswith("_")}

# Node types referenced in test corpus expected trees: (node_name ...)
tested = set()
for f in glob.glob("test/corpus/*.test"):
    for m in re.finditer(r"\(([a-z_][a-z0-9_]*)", open(f).read()):
        tested.add(m.group(1))

uncovered = sorted(named - tested)
if uncovered:
    print(f"UNCOVERED node types ({len(uncovered)}):")
    for u in uncovered:
        print(f"  - {u}")
    sys.exit(1)
print(f"100% node-type coverage: all {len(named)} named node types are tested.")
PY
