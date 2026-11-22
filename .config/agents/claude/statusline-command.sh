#!/usr/bin/env bash
# Reads JSON from stdin and prints a status line approximating the /status view.

IFS=$'\t' read -r model cost in_tok out_tok pct cwd < <(jq -r '[
  .model.display_name // "unknown",
  .cost.total_cost_usd // 0,
  .context_window.total_input_tokens // 0,
  .context_window.total_output_tokens // 0,
  .context_window.used_percentage // 0,
  .workspace.current_dir // .cwd // ""
] | @tsv')

printf '%s | ctx in: %dK out: %dK (%.0f%%) | $%.2f | %s\n' \
  "$model" $((in_tok / 1000)) $((out_tok / 1000)) "$pct" "$cost" "$cwd"
