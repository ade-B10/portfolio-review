#!/usr/bin/env bash
#
# Re-encrypt the source HTML and produce a fresh index.html for GitHub Pages.
#
# Usage:
#   1. Put the updated unencrypted file at source/Portfolio_Trajectory_Review.html
#      (or change SOURCE_FILE below to point wherever you keep it).
#   2. Run: ./update.sh
#   3. Commit + push: git add index.html && git commit -m "Refresh" && git push
#
# Requirements:
#   - Node.js installed
#   - First run will npx-install staticrypt (~10 sec, one-time)
#

set -euo pipefail

# ---- Config ----
PASSWORD='Base10Automation!'
SOURCE_FILE="source/Portfolio_Trajectory_Review.html"
OUTPUT_FILE="index.html"
LABEL="Base10 Portfolio Review"
INSTRUCTIONS="Enter the password to access the Base10 portfolio trajectory review."
REMEMBER_DAYS=14

# ---- Sanity checks ----
if [ ! -f "$SOURCE_FILE" ]; then
  echo "ERROR: $SOURCE_FILE not found."
  echo ""
  echo "Drop the unencrypted source HTML there first. For example:"
  echo "  mkdir -p source"
  echo "  cp /Users/ade/Desktop/Urizen/Portfolio_Trajectory_Review.html source/"
  echo ""
  exit 1
fi

if ! command -v node &> /dev/null; then
  echo "ERROR: Node.js not installed. Install from https://nodejs.org/"
  exit 1
fi

# ---- Encrypt ----
echo "Encrypting $SOURCE_FILE -> $OUTPUT_FILE ..."

# Use npx so we don't require a global install
npx -y -p staticrypt staticrypt \
  "$SOURCE_FILE" \
  -p "$PASSWORD" \
  --short \
  --remember "$REMEMBER_DAYS" \
  --label "$LABEL" \
  --instructions "$INSTRUCTIONS" \
  -d ./_tmp_encrypted

# Move the encrypted output to index.html and customize the title
SOURCE_BASENAME=$(basename "$SOURCE_FILE")
mv "./_tmp_encrypted/$SOURCE_BASENAME" "$OUTPUT_FILE"
sed -i.bak 's|<title>Protected Page</title>|<title>Base10 Portfolio Review</title>|' "$OUTPUT_FILE"
rm -f "${OUTPUT_FILE}.bak"
rm -rf ./_tmp_encrypted

echo ""
echo "Done. $OUTPUT_FILE updated."
echo ""
echo "Next steps:"
echo "  git add index.html"
echo "  git commit -m \"Refresh portfolio review ($(date +%Y-%m-%d))\""
echo "  git push"
echo ""
