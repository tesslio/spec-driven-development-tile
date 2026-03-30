#!/usr/bin/env bash
#
# Check that [@test] links and targets in .spec.md files point to existing files.
# Glob patterns in targets are expanded; missing matches are flagged.
#
# Usage: check-spec-links.sh [specs-directory]
# Default: ./specs

set -euo pipefail

SPECS_DIR="${1:-./specs}"
EXIT_CODE=0

if [ ! -d "$SPECS_DIR" ]; then
    echo "No specs directory found at: $SPECS_DIR"
    exit 0
fi

check_links() {
    local file="$1"
    local file_dir
    file_dir=$(dirname "$file")
    local errors=()

    # Check targets from frontmatter
    local in_frontmatter=false
    local in_targets=false

    while IFS= read -r line; do
        if [[ "$line" == "---" ]]; then
            if $in_frontmatter; then
                break  # End of frontmatter
            fi
            in_frontmatter=true
            continue
        fi

        if $in_frontmatter; then
            if [[ "$line" =~ ^targets: ]]; then
                in_targets=true
                continue
            fi
            if $in_targets; then
                if [[ "$line" =~ ^[[:space:]]+-[[:space:]]+(.*) ]]; then
                    local target="${BASH_REMATCH[1]}"
                    local resolved="$file_dir/$target"

                    # Check if it's a glob pattern
                    if [[ "$target" == *"*"* ]]; then
                        local matches
                        matches=$(compgen -G "$resolved" 2>/dev/null | head -1 || true)
                        if [ -z "$matches" ]; then
                            errors+=("target glob matches no files: $target")
                        fi
                    else
                        if [ ! -e "$resolved" ]; then
                            errors+=("target not found: $target")
                        fi
                    fi
                elif [[ "$line" =~ ^[^[:space:]] ]]; then
                    in_targets=false
                fi
            fi
        fi
    done < "$file"

    # Check [@test] links in body
    while IFS= read -r line; do
        if [[ "$line" =~ \[@test\][[:space:]]*(.*) ]]; then
            local test_path="${BASH_REMATCH[1]}"
            # Strip trailing backtick if present
            test_path="${test_path%\`}"
            test_path="${test_path## }"
            local resolved="$file_dir/$test_path"

            if [ ! -e "$resolved" ]; then
                errors+=("[@test] link not found: $test_path")
            fi
        fi
    done < "$file"

    if [ ${#errors[@]} -gt 0 ]; then
        for err in "${errors[@]}"; do
            echo "BROKEN  $file: $err"
        done
        return 1
    else
        echo "OK      $file"
        return 0
    fi
}

echo "Checking spec links in: $SPECS_DIR"
echo "---"

SPEC_COUNT=0
FAIL_COUNT=0

while IFS= read -r -d '' spec_file; do
    SPEC_COUNT=$((SPEC_COUNT + 1))
    if ! check_links "$spec_file"; then
        FAIL_COUNT=$((FAIL_COUNT + 1))
        EXIT_CODE=1
    fi
done < <(find "$SPECS_DIR" -name "*.spec.md" -print0 2>/dev/null)

echo "---"
echo "Checked: $SPEC_COUNT specs, $FAIL_COUNT with broken links"

exit $EXIT_CODE
