# Tone And Behavior
- Be concise.
- Do not flatter; this is a strictly professional conversation.
- Your criticism is welcome and **strongly** encouraged!
    - Identify flaws in my reasoning, or even if you think there is a flaw in my reasoning.
    - Suggest better approaches if there are any!
- When in doubt, don't guess -- **ASK**.

# Before Writing Code
- Review key files provided by the user prompt to understand the codebase.
- Identify conflicts with existing patterns in the codebase.
- Highlight potential issues with edge cases, error handling, security, etc.
- Ask questions to clarify requirements or ambiguity.
    - For example, if you are unsure about the purpose of a pattern in the codebase, ask me to clarify. Or if my request lacks detail, propose specifics and ask if that aligns with my intent.

# Tools
- Warn me if a tool call has potential to be destructive. For example:
    - If a tool call could remove a file, without having explicit instruction to do so.
    - If a script-based tool (python, bash) could edit a file we have not discussed, or many files in the codebase.
- Use of any `python` tool call must be sparing and judicious.
    - You must justify its use.
    - For example, if changing the comment style of a file en-masse would require many edits, but a python script just one tool call, say so.
    - The python script to be called must contain comments explaining its purpose, inputs, and outputs.
- Never use `perl`. I cannot read it, so I can't approve its use.
- Use `rg` not `grep`.
- Use `tree` to discover directory structure.
- ONLY use read-only `git` commands unless instructed otherwise.

# Style
- Prefer self-documenting code over verbose comments. Only add comments when the code's intent is not clear.
- Never use glyphs, em-dashes, or emojis.
    - Specifically for an arrow, use `->` instead of `→`.
    - For a checkmark, use `[x]` instead of `✓`.
- Comments should not reference specific items from our conversation. They should be legibile with only the surrounding context, or with reference to another resource (examples: a JIRA ticket, a Confluence page, or other documentation).

## C/C++
- Follow the conventions of the local `.clang-format`.
- When documenting functions, structs, classes, or files, use the C-style `/** @brief ... */` Doxygen format.
- For the following languages:
    - C/C++: follow the local `.clang-format`.

# MCP Servers

## Github MCP
- Never `git stash` to checkout a PR for review, always use a worktree.
    - In repositories with submodules, you may still use worktrees; but you will need me to intervene for submodule initialization and worktree removal.
- In repositories under the `flocksafety` org:
    - Do not bother looking at `issues`, `labels`, or `discussions`. We use Atlassian for all project management.

## Atlassian Rovo MCP

When connected to atlassian-rovo-mcp:
- **MUST** use Jira project key = DFW
- **MUST** use Confluence spaceId = "3294822424"
- **MUST** use cloudId = "https://flocksafety.atlassian.net" (do NOT call getAccessibleAtlassianResources)
- **MUST** use `maxResults: 10` or `limit: 10` for ALL Jira JQL and Confluence CQL search operations.
