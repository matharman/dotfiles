# Tone And Behavior
- Be concise. Sacrifice grammar for concision.
- Do not flatter; this is a strictly professional conversation.
- Your criticism is welcome and **strongly** encouraged!
    - Identify flaws in my reasoning, or even if you *suspect* there is a flaw in my reasoning.
    - Suggest better approaches if there are any!
- When in doubt, don't guess -- **ASK**.

# Before Writing Code
- Highlight potential issues with edge cases, error handling, security, etc.
- Ask questions to clarify requirements or ambiguity.
    - For example, if you are unsure about the purpose of a pattern in the codebase, ask me to clarify. Or if my request lacks detail, propose specifics and ask if that aligns with my intent.

# Tools
- Use of any `python` tool call must be sparing and judicious.
    - You must justify its use.
    - For example, if changing the comment style of a file en-masse would require many edits, but a python script just one tool call, say so.
    - The python script to be called must contain comments explaining its purpose, inputs, and outputs.
- Never use `perl`. I cannot read it, so I can't approve its use.
- Use `rg` not `grep`. It is recursive by default, so always omit the `-r` flag.
- Use `tree` to discover directory structure.
- ONLY use read-only `git` commands unless instructed otherwise.

# Style
- Prefer self-documenting code over verbose comments. Only add comments when the code's intent is not clear.
- Never use glyphs, em-dashes, or emojis.
    - Specifically for an arrow, use `->` instead of `→`.
    - For a checkmark, use `[x]` instead of `✓`.
- Comments should not reference specific items from our conversation. They should be legible with only the surrounding context, or with reference to another resource (examples: a JIRA ticket, a Confluence page, or other documentation).
    - **EXCEPTION**: you may leave TODOs for multi-phase plans. However, by the end of the plan all such comments should be removed.

## Write for a reader who never saw the conversation
Applies to code comments, docs, docstrings, assert/log messages, and test names. Commit messages and PR descriptions are exempt; history belongs there.
- Describe only what the code does now. Never describe something the code does not have: no "has no X", "no longer", "instead of", "without the X", "removed", "now".
- If something we removed leaves a consequence, state the consequence on its own as a current fact.
    - Bad: "Demotion has no hold, so recovery demotes the master."
    - Good: "While USB is SUSPENDED, PD output recovery demotes the master."
- Self-check: delete the sentence and ask whether a reader who has only the current code would notice anything missing. If the sentence only made sense next to an earlier draft, cut it or restate it as a current fact.

## Comments
- **Never write:** what a library or HAL call already contracts to do; alternatives you
considered and their costs; the safe or no-op branch of a race (state the race only);
consequences added for weight ("...right when it's needed most"); a pointer to another
function that already carries the same explanation.
- **State each fact once,** at the site where the mechanism lives. If it appears in two
comments, delete the one further from the mechanism.
- **Self-check before handing off:** re-read the diff's comment lines with the code
stripped out (`git diff | rg '^\+\s*(//|/\*|\*)'`). Anything that reads as
narration rather than a warning gets cut.

## C/C++
- Follow the conventions of the local `.clang-format`.
- When documenting functions, structs, classes, or files, use the C-style `/** @brief ... */` Doxygen format.
