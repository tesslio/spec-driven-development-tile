#!/usr/bin/env bash
#
# Validate .spec.md files have required structure:
# - YAML frontmatter with name, description, targets
# - At least one target entry
# - File extension is .spec.md
#
# Usage: validate-specs.sh [specs-directory]
# Default: ./specs

set -euo pipefail

SPECS_DIR="${1:-./specs}"
EXIT_CODE=0

if [ ! -d "$SPECS_DIR" ]; then
    echo "No specs directory found at: $SPECS_DIR"
    exit 0
fi

check_spec() {
    local file="$1"
    local errors=()
    local basename
    basename=$(basename "$file")

    # Check file extension
    if [[ "$basename" != *.spec.md ]]; then
        errors+=("File does not end with .spec.md")
    fi

    # Check for frontmatter delimiters
    local first_line
    first_line=$(head -1 "$file")
    if [[ "$first_line" != "---" ]]; then
        errors+=("Missing YAML frontmatter (no opening ---)")
        for err in "${errors[@]}"; do
            echo "FAIL  $file: $err"
        done
        return 1
    fi

    # Extract frontmatter (between first and second ---)
    local frontmatter
    frontmatter=$(awk 'NR==1{next} /^---$/{exit} {print}' "$file")

    if [ -z "$frontmatter" ]; then
        errors+=("Empty or missing YAML frontmatter")
    else
        # Check required fields
        if ! echo "$frontmatter" | grep -q '^name:'; then
            errors+=("Missing required field: name")
        fi
        if ! echo "$frontmatter" | grep -q '^[Dd]escription:'; then
            errors+=("Missing required field: description")
        fi
        if ! echo "$frontmatter" | grep -q '^targets:'; then
            errors+=("Missing required field: targets")
        else
            # Check that targets has at least one entry
            local target_count
            target_count=$(echo "$frontmatter" | awk '/^targets:/{found=1; next} found && /^  - /{count++} found && /^[^ ]/{exit} END{print count+0}')
            if [ "$target_count" -eq 0 ]; then
                errors+=("targets list is empty (at least one target required)")
            fi
        fi
    fi

    if [ ${#errors[@]} -gt 0 ]; then
        for err in "${errors[@]}"; do
            echo "FAIL  $file: $err"
        done
        return 1
    else
        echo "OK    $file"
        return 0
    fi
}

echo "Validating specs in: $SPECS_DIR"
echo "---"

SPEC_COUNT=0
FAIL_COUNT=0

while IFS= read -r -d '' spec_file; do
    SPEC_COUNT=$((SPEC_COUNT + 1))
    if ! check_spec "$spec_file"; then
        FAIL_COUNT=$((FAIL_COUNT + 1))
        EXIT_CODE=1
    fi
done < <(find "$SPECS_DIR" -name "*.spec.md" -print0 2>/dev/null)

# Also check for .md files that look like specs but don't have the right extension
while IFS= read -r -d '' md_file; do
    if head -5 "$md_file" | grep -q '^targets:'; then
        basename=$(basename "$md_file")
        if [[ "$basename" != *.spec.md ]]; then
            echo "WARN  $md_file: looks like a spec but doesn't use .spec.md extension"
        fi
    fi
done < <(find "$SPECS_DIR" -name "*.md" ! -name "*.spec.md" -print0 2>/dev/null)

echo "---"
echo "Checked: $SPEC_COUNT specs, $FAIL_COUNT failed"

exit $EXIT_CODE
