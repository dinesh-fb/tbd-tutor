# TBD Tutor

An agent skill that interviews you about trunk-based development — one question at a time, graded, with a gap report at the end.

It exists because most people who say "we do trunk-based development" can't state the three numbers that decide whether that's true. This gets you to the point where you can.

Everything in it is derived from <https://trunkbaseddevelopment.com/>. Each question cites its page.

---

## What it actually tests

Twelve questions, one rung each:

| # | Rung | What it's really checking |
|---|---|---|
| 1 | Core definition + "distance" | Can you state the model *and* the problem it solves? |
| 2 | The invariant, operationally | Never-break-the-build, and who proves it |
| 3 | Where releases happen | Release from trunk vs branch for release |
| 4 | Short-lived feature branches | The two-day / one-developer limits, and merge direction |
| 5 | Feature flags | Ship dark, flag kinds, CI permutations |
| 6 | Branch by abstraction | The five steps, and when it beats a flag |
| 7 | What "CI" means | CI-as-defined vs CI-the-daemon |
| 8 | "You're doing it wrong" | The anti-patterns that look like TBD |
| 9 | Apply it | Choosing the right technique per situation |
| 10 | What makes it hard | Story size, iterations, commit rate |
| 11 | Comparisons | GitHub Flow, Gitflow, monorepos |
| 12 | The capstone | Argue it from a skeptic's pain, in the right order |

Rung 12 is the real one. If you can do 12, you own the model. If you can only recite 1–11, you've memorized it.

---

## Install

The skill is this repo: `SKILL.md` + `answer-key.md` + (optional) `team-context.md`.

Clone it into your agent's skills directory, named `tbd-tutor`.

### Claude Code

```bash
git clone git@github.com:dinesh-fb/tbd-tutor.git ~/.claude/skills/tbd-tutor
```

### pi

```bash
git clone git@github.com:dinesh-fb/tbd-tutor.git ~/.pi/agent/skills/tbd-tutor
# or the cross-runtime location:
git clone git@github.com:dinesh-fb/tbd-tutor.git ~/.agents/skills/tbd-tutor
```

### Codex / Gemini CLI / Copilot CLI

Same idea, into `~/.agents/skills/tbd-tutor`.

### Keeping it updated

```bash
cd ~/.claude/skills/tbd-tutor && git pull
```

Don't want it in your skills directory? Clone anywhere and point your agent at the folder — the skill is just two Markdown files.

---

## Run it

Ask naturally:

```
quiz me on trunk-based development
```

Or force the skill:

```
/tbd-tutor                      # Claude Code / pi
/skill:tbd-tutor                # pi
```

Then pick a mode when it asks:

- **A — Full pass.** All 12 questions, ~20–30 minutes.
- **B — Targeted check.** Name a topic ("release branches", "flags vs branch by abstraction", "are we doing it wrong?") and it runs only that rung, ~5 minutes.

### How to get value out of it

- **Answer in your own words, out loud, before typing.** Recognition is not recall.
- **Don't look anything up mid-question.** The gap report is only useful if it's honest.
- **Say "hint" when stuck** (it narrows scope without giving the answer), and **"skip"** if you'd rather not guess — skipped rungs are logged as *unverified*, not passed.
- **Argue back** if you think a correction is wrong. It's instructed to cite the source page; make it.

### What you'll get

Grading per sub-question: ✅ correct, 🟡 partial, ❌ wrong. Then at the end:

1. What you're solid on.
2. Gaps in priority order.
3. Two ways to consolidate — re-derive the argument from first principles, or dry-run the migration on your own repo.

---

## Using it with your team

The interview is per-person and private. The *gaps* are useful collectively.

1. **Everyone runs the full pass once**, individually, in the week before a TBD discussion. No preparation, no reading the site first — you want the baseline.
2. **Collect the top gap from each person.** The tutor ends with a ranked list; ask people to paste just the first item.
3. **Hold one 30-minute session on the modal gap.** In practice it's usually rung 4 (branch lifetime) or rung 8 (the release-branch anti-patterns), because those are the ones teams get wrong while believing they're compliant.
4. **Then answer one question as a team, in writing:** *of the seven prerequisites in rung 12, which do we already satisfy, and which one breaks first if we switched next Monday?*

That last document is worth more than the quiz. The quiz just tells you who can be trusted to write it.

### Optional: grade against your real setup

```bash
cp team-context.example.md team-context.md
```

Fill in your repos, release cadence, and build times. The tutor then uses *your* numbers in rungs 9 and 12 instead of a hypothetical 12-person team. It never changes a model answer — only the examples.

---

## Contributing

Corrections welcome, especially ones where the answer key contradicts the site.

- **The site wins.** <https://trunkbaseddevelopment.com/> is the source of truth, not this repo.
- **One question per PR**, and say which rung it touches.
- **Numbers are load-bearing.** If you change a fact like "two days", cite the page.
- **Add traps, not prose.** The most useful contribution is another wrong answer people actually give, so it gets graded ❌ instead of sliding past.

`answer-key.md` is the only file most changes touch. `SKILL.md` is the tutor protocol — it changes rarely, and only to close a way the interview can go soft.

---

## Notes

- Content is a derivative summary of <https://trunkbaseddevelopment.com/> by Paul Hammant and contributors. Read the original — this is a study aid, not a replacement.
- The skill contains no code, runs no scripts, and needs no network access.
