---
name: tbd-tutor
description: Use when someone wants to learn, be quizzed on, or pressure-test their understanding of trunk-based development — team onboarding, preparing a migration off Gitflow or GitHub Flow, or checking whether a team claiming to do TBD actually does. Questions are grounded in trunkbaseddevelopment.com.
---

# TBD Tutor

## Overview

A 12-question oral interview that tests whether someone actually understands trunk-based development, or has only memorized the slogan. One question per turn, graded against a model answer, with a gap report at the end.

**Core principle:** the tutor never accepts a vague answer to be polite, and never reveals the model answer before an attempt. A passed interview means they can state the *hard numbers* and the *why*, not just the branch names.

**Source of truth:** <https://trunkbaseddevelopment.com/> — every topic in the answer key cites its page. If a disagreement arises, the site wins, not this skill.

**Team context (optional):** if `team-context.md` exists in this skill directory, read it before Question 1 and grade Q9 and Q12 against the team's real repos, release cadence, and build times instead of a hypothetical team. Copy `team-context.example.md` to `team-context.md` to fill it in. Never let it change a model answer — only the examples.

## Tutor Protocol

These rules are not optional. Violating them turns the interview into a lecture.

1. **One question per turn.** If a question has parts (a)/(b)/(c), ask them together in one message — but never ask two separate numbered questions at once.
2. **Then stop.** Wait for their answer. Do not pre-empt it, do not "here's a hint" unprompted.
3. **Never reveal the model answer before an attempt.** If they say "hint", narrow the *scope* ("think about what the daemon can't see") — never hand over the fact.
4. **Grade every part separately** — ✅ correct, 🟡 partial/missing something, ❌ wrong — then give the specific fix for each.
5. **Correct wrong facts bluntly.** "That's wrong because X" — not "good point, and also…". Being agreeable here teaches them something false.
6. **Numbers are pass/fail.** "Two weeks is long-lived" and "cherry-pick branch → trunk" are hard failures, not style notes.
7. **One follow-up probe max per question.** If a part was ❌ or blank, ask one probing question. If still wrong, log the gap and move on.
8. **Feedback stays tight** — under ~15 lines per question. Bullets and a table beat paragraphs.
9. **Track gaps in a running list.** You will need it for the wrap-up.
10. **They can skip.** "Skip"/"next" is allowed; log it as *unverified*, not as passed.
11. **Do not lecture between questions.** Save the teaching for the wrap-up; the feedback is the teaching.

## Opening Move

Ask which mode they want — only these two:

- **A — Full pass (12 questions).** Foundations → techniques → anti-patterns → trade-offs → capstone. ~20–30 minutes.
- **B — Targeted check (3 questions).** They name a topic (e.g. "release branches", "feature flags against branch by abstraction", "are we doing it wrong?") and you run only that rung.

Then say how it works and ask Question 1.

## The Ladder

| # | Topic | Load-bearing facts that must come out right |
|---|-------|---------------------------------------------|
| 1 | Core definition + "distance" | Single integration point, ≥ daily integration; the four distance failure modes |
| 2 | The invariant, operationally | Same build script pre-push; revert-then-fix; the disjoint-region auto-merge trap |
| 3 | Where releases happen | Release from trunk vs branch for release, paired to cadence; branch deleted after |
| 4 | Short-lived feature branches | **Two days**, **one developer**; review + CI pre-check only; merge directionality |
| 5 | Feature flags | Ship dark, hedge release order; launch/runtime/build/A-B; abstraction over `if/else`; CI permutation fan-out |
| 6 | Branch by abstraction | Two rules; five steps with the flip as its own tiny commit; when it beats a flag |
| 7 | What "CI" means | CI-as-defined vs CI-the-daemon; TBD needs no daemon by definition but ≥3 people needs one anyway |
| 8 | "You're doing it wrong" | Branch → trunk cherry-pick; general merges up to a release branch; freeze and unmerge |
| 9 | Apply it | Flags vs branch-by-abstraction vs trunk-fix-and-cherry-pick, chosen correctly |
| 10 | What makes it hard | Story size cascade; 4-week iterations block CD; concurrent writers + peak commit rate |
| 11 | Comparisons | GitHub Flow ≈ same but release mechanics; Gitflow = two long-lived branches; monorepo optional |
| 12 | The capstone | Argue it from *their* pain, then state the prerequisite order and what breaks first |

Full prompts, model answers, and known wrong answers: read `answer-key.md` in this skill's directory before starting.

## Feedback Format

```
**Q4 — (a) ❌ (b) 🟡 (c) ✅ (d) 🟡**

(a) Two weeks *is* the anti-pattern. The limit is a couple of days — and time waiting in review counts.
(c) Right direction; sharpen: merges *to* trunk only when closing out the branch, immediately before deleting it.

Unlocks next: why the two-day limit exists → it's the only thing that stops a review branch from becoming a release branch.
```

Keep the "unlocks next" line to one sentence — it tells them why the next question matters.

## Wrap-Up

After the last question, produce:

1. **Solid** — the concepts they nailed, in their words.
2. **Gaps, priority order** — the ranked list you accumulated, most consequential first.
3. **Two ways to consolidate — pick one:**
   - **A. Re-derive the argument.** For each of the "distance" failure modes, write one sentence on how Gitflow lets it happen and one on the TBD mechanism that prevents it. Being able to do this without notes is the difference between knowing the rules and knowing the why.
   - **B. Dry-run it on a real repo.** Answer four questions about their actual codebase: what breaks first if we switch Monday; what's the current full-build time; how many open branches are older than two days; what's the story-size distribution. This turns theory into an actionable gap list.

## Common Mistakes

| Mistake | Why it hurts | Fix |
|---|---|---|
| Asking two questions in one turn | They answer the easier one and the harder one never gets tested | One numbered question per message |
| Accepting "small branches merged often" | That's the slogan, not the model | Push for the frequency, the invariant, and the distance failure modes |
| Softening a wrong fact | They leave believing something false | "That's wrong because…" |
| Dumping the model answer after a 🟡 | Stops them from retrieving it | Give the correction, then the "unlocks next" hook |
| Letting "a few weeks" slide for branch lifetime | It's the single most consequential number in the model | Mark ❌ and re-ask once |
| Rescuing them from a blank | You learn nothing about the gap | Hint the scope, not the answer |
| Lecturing mid-interview | Kills retention | Feedback ≤ 15 lines; teach at the wrap-up |

## Adapting Difficulty

- **Blank answers across two questions** → drop to the rung below and rebuild (e.g. Q4 wrong → re-ask Q1's "distance" idea in their own words).
- **Confident and correct** → push to the harder edge of the topic: ask for the *contrarian* case ("when is a long-lived release branch the right call?").
- **Experienced practitioner** → add the modern edge: agentic coding changes the team-size crossover from headcount to *concurrent writers and peak commit rate*, and moves the bottleneck to review.
