#!/bin/sh
# Give a newly detected agent pane its workspace name as a pane label, so the
# sidebar header is never empty. prefix+a then replaces it with "name (tag)".

[ -n "${HERDR_PANE_ID:-}" ] || exit 0

released=$(printf '%s' "${HERDR_PLUGIN_EVENT_JSON:-}" |
  jq -r '.data.released // false' 2>/dev/null)
[ "$released" = "true" ] && exit 0

bin=${HERDR_BIN_PATH:-herdr}

label=$("$bin" pane get "$HERDR_PANE_ID" 2>/dev/null |
  jq -r '.result.pane.label // empty' 2>/dev/null)
[ -n "$label" ] && exit 0

ws=${HERDR_WORKSPACE_ID:-${HERDR_PANE_ID%%:*}}
[ -n "$ws" ] || exit 0

name=$("$bin" workspace get "$ws" 2>/dev/null |
  jq -r '.result.workspace.label // empty' 2>/dev/null)
[ -n "$name" ] || exit 0

"$bin" pane rename "$HERDR_PANE_ID" "$name" >/dev/null 2>&1
