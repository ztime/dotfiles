---
name: review-loop
description: Build a task, then run review → fix cycles (MUST/SHOULD/CONSIDER) until clean or 4 cycles. Use after a plan is approved, or when the user says "review loop", "build and review", or invokes /review-loop.
---

# Review loop

Input: a task or an approved plan. That text is the **intention** every review checks against.

1. Implement the task.
2. Review the diff since you started:
   - Invoke the `code-review` skill (`medium` unless the user said otherwise).
   - Run the repo's own checks on the changed files: lint, format, type-check, tests. Find them in CLAUDE.md, Makefile, package.json, pyproject.toml, .pre-commit-config.yaml, sqlfluff/dbt config, etc. Don't invent checks the repo doesn't have.
   - Compare the diff with the intention: anything missed? Anything added that wasn't asked for?
3. Sort every finding into:
   - **MUST**: bug, failing check, or the intention isn't met
   - **SHOULD**: real quality issue
   - **CONSIDER**: optional nit
4. Fix all MUST. Fix SHOULD unless you disagree, and note why. Fix CONSIDER only if trivial.
5. Repeat 2–4 until there are no MUST or SHOULD items, or 4 cycles have run.
6. Report: what was built, the findings fixed per cycle, and the open CONSIDER items or disputed SHOULD items.
