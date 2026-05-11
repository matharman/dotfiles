#!/usr/bin/env bash
# Reads JSON from stdin and prints a status line approximating the /status view.

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "unknown"')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
cost=$(printf '$%.2f' "$cost")
ctx_input_tok=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
ctx_input_tok=$(printf '%d' $((ctx_input_tok / 1000)))
ctx_output_tok=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
ctx_output_tok=$(printf '%d' $((ctx_output_tok / 1000)))
ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
ctx_pct=$(printf '%.0f%%' "$ctx_pct")
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')

echo "$model | ctx in: ${ctx_input_tok}K out: ${ctx_output_tok}K ($ctx_pct) | $cost | $cwd"
