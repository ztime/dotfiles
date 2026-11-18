#!/usr/bin/env bash
# Tag the focused agent pane. Shown in the sidebar as "workspace (tag)",
# so agents sharing a workspace stay distinguishable. Bound to prefix+a.

set -u

bin=${HERDR_BIN_PATH:-herdr}
pane=${HERDR_ACTIVE_PANE_ID:-}
ws=${HERDR_ACTIVE_WORKSPACE_ID:-}

die() {
  printf '\n%s\n' "$1" >&2
  printf 'press enter to close...'
  read -r _ || true
  exit 1
}

[ -n "$pane" ] || die "no active pane"
[ -n "$ws" ] || die "no active workspace"

"$bin" agent get "$pane" >/dev/null 2>&1 || die "no agent in the active pane"

workspace=$("$bin" workspace get "$ws" 2>/dev/null) || die "workspace not found"
base=$(jq -r '.result.workspace.label // empty' <<<"$workspace" 2>/dev/null)
[ -n "$base" ] || die "workspace has no label"

pane_info=$("$bin" pane get "$pane" 2>/dev/null) || die "pane not found"
label=$(jq -r '.result.pane.label // empty' <<<"$pane_info" 2>/dev/null)

# Split an existing "workspace (tag)" label back into its tag.
tag=
prefix="$base ("
if [[ $label == "$prefix"*')' ]]; then
  tag=${label#"$prefix"}
  tag=${tag%')'}
fi

printf '\033[1mtag agent\033[0m — %s' "$base"
[ -n "$tag" ] && printf ' (current: %s)' "$tag"
printf '\n\n'
printf 'tag (empty clears): '

input=
IFS= read -r -e input || exit 0

input=$(printf '%s' "$input" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

case $input in
  *'('*|*')'*) die "tag cannot contain parentheses" ;;
esac

if [ -z "$input" ]; then
  new_label=$base
else
  new_label="$base ($input)"
fi

out=$("$bin" pane rename "$pane" "$new_label" 2>&1) || die "rename failed: $out"
