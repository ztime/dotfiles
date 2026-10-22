#!/usr/bin/env bash
# Fuzzy-switch between herdr workspaces, named tabs and agents.
ws=$(herdr workspace list)
icon='def icon: {working:"●", blocked:"!", done:"✓", idle:"○"}[.] // "?";'
{
  jq -r "$icon"'.result.workspaces[] | "\(.workspace_id)\tws\t\(.agent_status | icon) \(.label)"' <<<"$ws"
  herdr tab list | jq -r --argjson ws "$ws" "$icon"'
    ($ws.result.workspaces | map({(.workspace_id): .label}) | add) as $l
    | .result.tabs[] | select(.label | test("^[0-9]+$") | not)
    | "\(.tab_id)\ttab\t\(.agent_status | icon) \($l[.workspace_id]) / \(.label)"'
  herdr agent list | jq -r --argjson ws "$ws" "$icon"'
    ($ws.result.workspaces | map({(.workspace_id): .label}) | add) as $l
    | .result.agents[]
    | "\(.pane_id)\tagent\t\(.agent_status | icon) \($l[.workspace_id]) / \(.agent): \(.terminal_title_stripped)"'
} | fzf --delimiter='\t' --with-nth=2.. --prompt='herdr> ' | {
  IFS=$'\t' read -r id kind _ || exit 0
  case $kind in
    ws) herdr workspace focus "$id" ;;
    tab) herdr tab focus "$id" ;;
    agent) herdr agent focus "$id" ;;
  esac
} >/dev/null
