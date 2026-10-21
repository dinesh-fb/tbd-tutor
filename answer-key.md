# TBD Interview — Answer Key

Model answers for the 12-question ladder in `SKILL.md`. Each entry: the exact prompt to send, the model answer, and the wrong answers people actually give (so you can grade fast).

Source for everything: <https://trunkbaseddevelopment.com/>. Page paths are given per question.

---

## Q1 — The core idea (and the problem it solves)

**Prompt**

> **(a)** In your own words, what *actually* makes a branching model "trunk-based"? Not the slogan — what are the non-negotiable rules?
> **(b)** The site frames the whole argument around one word: **"distance"** (Frank Compagner). What specifically is *bad* about that distance? Name the concrete failure modes.

**Model answer**

*(a)*
- One shared branch — the trunk (may be called `main`) — as the **single integration point** for the team.
- **Frequency**: every developer's work lands there **at least once every 24 hours**, ideally multiple times a day. This is what makes it trunk-based rather than merely "we use main."
- **Never break the build / always release-ready.** The invariant.
- Everyone clones and pulls from trunk many times a day, **knowing** the build passes.
- Resistance to long-lived branches, achieved with **documented techniques** (feature flags, branch by abstraction), not willpower.
- Plus (these are *styles*, not the definition): short-lived feature branches with review **or** direct-to-trunk commits.

*(b)* Distance = distance to **integration** — the gap between code not yet on the shared branch and the code everyone depends on. Un-integrated code can:
1. **Break something unexpected once merged.**
2. **Be difficult to merge in** (merge hell).
3. **Hide duplicated work** until merge.
4. **Hide incompatibility or undesirability that never breaks the build** — semantically at war despite auto-merging cleanly.

**Traps to mark ❌**
- "TBD = everyone uses short-lived branches." Direct-to-trunk is a valid style; small teams use no branch at all.
- Defining it by the branch name (`main`, `trunk`) or by "we merge often."
- Omitting the 24-hour / multiple-times-a-day frequency.
- Omitting the never-break-the-build invariant.
- Explaining "distance" as confusion *between release branches* — that's configuration management, not distance. Release branches are allowed; a **long-lived branch under active development** is the sin.

---

## Q2 — The invariant, operationally

**Prompt**

> **(a)** Before a commit lands on trunk, what must be true and who/what proves it?
> **(b)** A bad commit lands and CI goes red after the fact. What happens?
> **(c)** Why does this matter more in TBD? There's a specific scary merge scenario.

**Model answer**

*(a)*
- Developer runs the **full pre-integrate build** — compile, test-compile, unit tests, service tests, functional tests — **on their own workstation, before pushing**.
- It must be **the same build script the CI daemon runs**, so local green predicts server green.
- The checkout must be **up to date with HEAD of trunk**; if someone landed in the meantime, update and rebuild (race condition).
- Then the **CI daemon verifies post-landing** as a backstop — because there's no guarantee a developer ran it.
- Consequence: the build must be **fast** (~1 min good; 10+ unacceptable), since everyone runs it before every push.

*(b)*
- **Lock trunk briefly → revert the bad commit → re-run CI → unlock when green.**
- Fix-forward is a **small-team exception** (3–4 people, fix minutes away), not a peer option.
- Distinction: reverting a **build-breaking** commit is prescribed and good. Backing out a commit because it's **"not ready"** is *unmerge* — an anti-pattern.

*(c)* **Disjoint-region auto-merge.** Two changes touch the same file in different regions — one renames a function, another adds a caller. Git sees zero conflict, merges silently, result is semantically broken. No VCS flags it. **Only the build catches it** — hence pre-push full build plus fast CI on HEAD, and it works best while the change is small and fresh in the author's mind.

**Traps to mark ❌**
- "CI runs the tests before merge, so it's fine" — that inverts the roles; the developer's local build is the primary gate.
- "We fix forward at our leisure" as the default.
- Revert described as returning to "the non-good state."
- Missing the auto-merge scenario; answering only "because we must always be releasable."

---

## Q3 — Where releases happen

**Prompt**

> 40 devs, committing to trunk multiple times a day, nothing broken. **(a)** TBD teams do exactly one of two things here — name both. **(b)** Which goes with which release cadence, and why? **(c)** For the lower-cadence option: what may *not* happen on that branch, and what must happen to it afterward?

**Model answer**

*(a)*
- **Release from trunk** — ship a tag/commit off trunk. No branch.
- **Branch for release** — cut a branch from trunk and ship from it.

*(b)*
- **High cadence / CD → release from trunk.** At many releases a day a branch is stale before it's cut, and you'd cherry-pick constantly. Bugs are handled by **rolling forward**: fix in trunk, next release from trunk.
- **Lower cadence (weekly/monthly) → branch for release**, cut **just-in-time** (days before), hardened by a **small subset** while everyone else keeps streaming into trunk at full speed. No team-wide freeze.

*(c)*
- **Forbidden:** continued **development** work on the branch (Wingerd & Seiwald's "incompatible policy"), and **general merges from trunk up into the release branch** during hardening — that means you cut on the wrong day. (Cherry-picking every commit since the cut is the same sin.)
- **Required afterward:** the branch is **deleted** some time after release.
- Bonus facts: branch may be cut **retroactively** from an older commit (to exclude work that landed after the cutoff) or created **after** the fact from a release tag; cherry-pick direction is **trunk → branch only**.

**Traps to mark ❌**
- Cherry-pick described without stating the direction.
- Forgetting the branch gets deleted.
- Treating the branch as a home for development.
- Missing that hardening is a subset activity, not a team-wide slowdown.

---

## Q4 — Short-lived feature branches

**Prompt**

> **(a)** Hard limits: how long may the branch live, how many developers may write on it, and what does that imply about why it exists? **(b)** What is it *for*? **(c)** Merge directionality — both rules. **(d)** What's wrong with pulling from a teammate's short-lived branch?

**Model answer**

*(a)*
- **A couple of days, two at most.** Two weeks *is* a long-lived feature branch. **Time waiting for review counts toward the branch's life.**
- **One developer** (or two if pairing). With agents: one developer and *their own* agents = still one unit; two developers' agents = two units.
- Implication: it is **not a shared workspace**. Grouping developers on it turns it into a release branch under active development.

*(b)*
- **Prioritized code review**, and **build checking / CI verification** *before* the commits land in trunk.
- Explicitly **not** for artifact creation or publication — artifacts build from trunk.
- After review: **keep the review history, delete the branch.** Deletion is proof of convergence.

*(c)*
- **Trunk → branch**: allowed freely, any time, to bring the branch up to date. May make the branch *look* younger — that merge is real integration either way.
- **Branch → trunk**: allowed **only as part of closing out the branch, immediately before deleting it**.

*(d)*
- Portals **cannot prevent** it — no technical guard exists; it's a discipline failure, usually rationalized as "review is taking too long."
- You make **unreviewed, possibly-rejected** work a dependency; if the branch is rejected, rewritten, or never lands, you built on something that may die. Trunk stops being the single source of truth.

**Traps to mark ❌**
- **"Two weeks"** — hard ❌.
- "For feature development" — writing code isn't the branch's purpose.
- "Branch → trunk allowed any time."
- Missing deletion as part of the rule.

---

## Q5 — Feature flags

**Prompt**

> **(a)** What does a flag buy a TBD team? **(b)** What kinds of flag are there? **(c)** Two gotchas — one about implementation, one about CI. **(d)** What's the long-term debt trap?

**Model answer**

*(a)*
- **Ship dark**: the change lands in trunk normally and stays **inert** in production.
- **Hedge on the order of releases** — deploy B's code before A ships; commit order no longer dictates release order.
- Avoids racing to finish before a branch cut, or scrambling to keep work out of the branch point.
- Enables **A/B tests and betas** for subsets of users.

*(b)*
| Kind | Decided when | Notes |
|---|---|---|
| Launch-time | app boot (args, config, DI) | simplest; resolved once at startup |
| Runtime switchable | while running, no relaunch | state must **persist** across restart and reach **every node** in a cluster (Consul/Etcd or equivalent); 24/7 support can flip per runbook |
| Build flag | compile time | capability impossible at runtime if built without it |
| A/B / beta | per user or group | marketing-driven |

Also: flags need not be binary — they can be **additive**; granularity ranges from a whole component to one formatting choice.

*(c)*
- **Implementation:** **avoid `if/else`** where a path choice is made. Introduce an **abstraction** and pick the implementation at the primordial boot point via DI/config.
- **CI:** **fan-out after unit tests** — one build per **meaningful flag permutation**, in parallel on elastic infra. One commit, several builds. Otherwise untested combos ship.

*(d)* Flags accumulate and get **forgotten** as the team pivots; nobody remembers which permutations matter, CI cost grows, and removing them is unowned work.

**Traps to mark ❌**
- "Ship dark" only, with no hedging / release-order benefit.
- Blank on flag kinds.
- Missing the abstraction-over-`if/else` rule and the CI permutation fan-out.
- Debt described as "the feature goes stale" rather than "the flag rots."

---

## Q6 — Branch by abstraction

**Prompt**

> **(a)** The two rules that make this legitimate. **(b)** The five steps, being precise about step 3. **(c)** When is this the right tool instead of a feature flag? **(d)** The last step, and why not leave the abstraction in?

**Model answer**

*(a)*
1. Other developers **already depend** on the code being changed, and must **not be slowed down**.
2. **No commit may jeopardize the ability to go live.**

*(b)*
1. **Introduce an abstraction** around the code to be replaced and **reroute every caller** through it. May take multiple commits; none may break the build.
2. **Write a second implementation** of the abstraction and commit it **turned off** — nobody depends on it yet. May take multiple commits.
3. **Flip the switch on** for the team — a **tiny, trivially revertable commit**. (The switch is *allocated* in step 2; step 3 is only the flip.)
4. **Remove the to-be-replaced implementation.**
5. **Remove the abstraction** (and the switch).

*(c)* It's for **structural / technical migrations**, not behavioral capability: swapping a library or ORM (iBatis → Hibernate), re-platforming a datastore, replacing a subsystem — where both old and new must coexist *inside* the codebase and there's no per-user "turn it off." Bonus: cheap **pause and resume** of a migration.

*(d)* With one implementation left the abstraction is **indirection with no choice to make**, and the switch is a flag that will rot. Legit exception: **keep it if unit tests benefit from the seam for mocking** — but that's a reason, not a default.

**Traps to mark ❌**
- Merging the flip into step 2 (losing the "landed turned off" property).
- Forgetting that callers must be **rerouted**, not just that an interface must exist.
- Choosing it purely by duration ("it takes long") — the distinction is *kind* of change.
- Leaving abstraction + switch in place by default.

---

## Q7 — What "CI" actually means

**Prompt**

> **(a)** Popular meaning vs original intention. **(b)** Does CI require TBD? Does TBD require a CI server? **(c)** Why lean on the local build instead of trusting the daemon?

**Model answer**

*(a)*
- **Popular today:** a daemon that verifies changes are correct — **regardless of branching model**. Says nothing about where or how often people integrate.
- **Original (Kent Beck, XP, C3, ~1996):** verification of a **single integration point**, daily or more — developers build the habit; the server merely **confirms** quality.
- Punchline: CI-as-defined and TBD are **nearly the same intention**. TBD never mandated a daemon; the daemon is a **safety net** around the model. "Individuals practice TBD, teams practice CI."

*(b)*
- **CI requires TBD** (essentially): CI's core requirement is that all members commit to trunk **at least once every 24 hours**. TBD is a key **enabler**.
- **TBD does not require a CI server** by definition — historically done with human ceremony ("I'm checking in now, nobody else should be") plus lock/revert discipline. But **more than a couple of developers → you need one**; "every team larger than three people needs a CI daemon."

*(c)*
- The daemon verifies **after** landing — by then teammates may have pulled a broken trunk and built on it. The local build keeps the bad commit from being **visible** at all.
- **Disjoint-region auto-merge** — only a build finds semantic breakage, and it's cheapest to fix while small and fresh.
- The local build is **the same script**, so green local predicts green server.
- **Since 90s XP practice, valuable for ALL branching models** — TBD just has no branch to hide behind.
- (Cost/fail-fast is a minor factor, not the argument.)

**Traps to mark ❌**
- "CI is the build server."
- "TBD needs a CI server to be correct" — the developer's build is what makes integration correct.
- Omitting the post-landing detection latency and the auto-merge trap.
- Answering (c) with "local is cheaper."

---

## Q8 — "You're doing it wrong"

**Prompt**

> Name the tell and the consequence for each:
> **(a)** a branch called `trunk`, "we merge back to trunk often"; **(b)** fixing bugs on the release branch and merging down to trunk; **(c)** merging trunk up into the release branch before a release; **(d)** two devs sharing one branch for a week, a third pulling from it; **(e)** code freeze, and unmerge.

**Model answer**

*(a)* The branch name proves nothing (Subversion's default layout). Tells: **multiple developers grouped on branches**, and branches **not deleted within a couple of days**. "We merge back to trunk often" is a claim, not a practice.

*(b)* Headline anti-pattern. Consequence: you will **forget one**, and the next release (cut fresh from trunk) **silently regresses** it. Correct flow: reproduce on trunk → fix on trunk with a test → CI green → **cherry-pick trunk → branch** → branch CI verifies → ship.

*(c)* You **cut the branch on the wrong day**, usually under date pressure. A release branch is a **snapshot of a chosen point**, not a moving target. (Cherry-picking every commit since the cut is the same thing.)

*(d)* Two problems: the branch is long-lived **by definition of the sharing** (it's a release branch under active development now), and the third developer is building on **unreviewed, possibly-rejected** work with no technical guard.

*(e)* **No code freeze** — proximity to a release must not slow the commit rate. **No unmerge** — backing a commit out because it's "not ready" or because someone else's release is imminent is equally a sign of doing it wrong. (Distinct from reverting a *broken* commit, which is prescribed.)

**Traps to mark ❌**
- (b) judged "fine" — the single worst error on this rung.
- (a) answered with generic "branches should be short-lived" while missing *who* is on them and *deletion*.
- (c) answered with "no new development on the branch" — that's the rule, not the diagnosis.
- (e) defining unmerge as "trunk unavailable" instead of "ejecting a landed commit."

---

## Q9 — Apply it

**Prompt**

> 12 developers, weekly cadence. **(1)** New one-click checkout UI, 6 weeks, invisible until Q3. **(2)** Swap the payment SDK v2 → v3 across ~40 call sites, 2 weeks, everyone depends on that code. **(3)** P1 production bug found Tuesday; release Thursday. Which technique, what branches, where does the release happen, and how does CI change for #1?

**Model answer**

1. **Feature flag.** The flag is the smallest part: 6 weeks means **many small commits to trunk**, all behind a flag defaulting **off**. Ship dark; prefer a **runtime** flag if launch should be a config flip. CI must cover **both permutations**; the flag is **removed** after launch.
2. **Branch by abstraction.** No branch exists. Five steps in trunk over two weeks; v3 landed **turned off**, then a tiny flip commit; v2 and the abstraction removed.
3. **Fix on trunk**, with a test, CI green, then **cherry-pick trunk → release branch**, where that branch's **duplicated CI** verifies it. Weekly cadence ⇒ branch for release is the correct model (CD would roll forward instead). Branch cut **just-in-time**, deleted after.
4. **CI change for #1:** **fan-out after unit tests** into one build per meaningful flag permutation, in parallel on elastic infra.

**Traps to mark ❌**
- Landing the 6-week feature as one big push at the end.
- "Use a long-lived feature branch for #2."
- Cherry-picking the bug fix in the wrong direction.
- Skipping the CI fan-out answer.

---

## Q10 — What makes TBD hard

**Prompt**

> **(a)** What does TBD demand about story size, and what's the failure cascade? **(b)** What does iteration length have to do with it — can a 4-week iteration still reach CD? **(c)** What forces the team-size crossover, and how do AI coding agents change it?

**Model answer**

*(a)* Finish in **hours**, not days. Past a couple of days the pressure cascades:
1. Group developers on a **non-trunk branch** and merge back later.
2. Or worse: developers **branch/fork from your in-progress branch**.
3. Or worse still: they **take intermediate merges from your incomplete branch**.
Team-wide job to split stories (INVEST). Story size was never limited by typing effort but by **how much can be reviewed, integrated, and released safely in one go** — an agent's hour of work should still land as several small commits.

*(b)* Iteration length governs **team steering**; story size governs commit size — different axes. A 4-week+ iteration where weeks vary with release proximity can still follow TBD tenets and use CI — but **will not reach Continuous Delivery or Deployment**. Iterations remain how humans plan, demo, and re-prioritize; releases should be **decoupled from the iteration**, with flags controlling what users see.

*(c)* Forces: **concurrent writers** (humans + agents) and **peak commit frequency** — not headcount. Historically people were a fair proxy for commit rate (≤ ~15 → direct to trunk; 16+ → short-lived branches + CI daemons; before Git's cheap branching, up to ~100). Agents break the proxy: one developer with several agents can generate a large team's commit load, so the crossover arrives with **far fewer people** — and the bottleneck moves to **human review** unless review is AI-led. Alternative: direct-to-trunk behind a **commit queue**; governance may keep a named human approver.

**Traps to mark ❌**
- (a) Stating "small stories" with no cascade.
- (b) Conflating iteration length with commit size; answering "yes" to CD on 4-week iterations.
- (c) Answering with headcount only.

---

## Q11 — Comparisons and misconceptions

**Prompt**

> **(a)** Is TBD basically GitHub Flow? **(b)** How does it differ from Gitflow? **(c)** Does TBD need a monorepo — and what does "expand or contract" mean? **(d)** "Our repo has a branch called `main`, so we're trunk-based." Your reply?

**Model answer**

*(a)* **Nearly the same** — one long-lived `main` plus short-lived PR branches. The site's "one small difference **around where to release from**": GitHub Flow doesn't prescribe release mechanics; TBD does (release from trunk, **or** a JIT release branch that is deleted).

*(b)* **Two long-lived branches** — `main` and `develop`, plus feature/release/hotfix branches. Consequence: no single integration point, so **distance returns** — merge hell, duplicated work found late, semantically incompatible changes invisible until integration, and releases dragging half-integrated work through hardening (freezes, unmerges, branch → trunk cherry-picks).

*(c)* Monorepo **optional**. "Expand or contract" is Google's **client-side view scoping**: 35,000 developers in **one trunk**, each checking out an **expanded** view (real directories, pulling dependencies) or a **contracted** view (skeleton/interface stubs) — monorepo benefits without checking out the world. Nothing to do with splitting repos.

*(d)* Model reply: "A branch name proves nothing. Are branches short-lived (≤2 days, one developer)? Is there no long-lived branch under active development? Do you release from trunk or a JIT branch that gets deleted? No freezes, no unmerges, no branch → trunk cherry-picks? Is trunk always release-ready, proven by CI?"

**Traps to mark ❌**
- Claiming TBD requires a monorepo.
- Describing Gitflow's two branches as if it were GitHub Flow.
- Accepting the branch-name test.

---

## Q12 — The capstone

**Prompt**

> A colleague is happy on Gitflow and calls TBD a process fad. **(a)** Make the case in three arguments, from *their* pain. **(b)** What must be true *before* they switch, in what order — and what breaks first?

**Model answer**

*(a)* Three arguments, framed as their problems:
1. **Distance → integration surprises.** Long-lived branches mean merge hell, duplicated work found at merge time, and changes that merge **textually cleanly but are semantically incompatible** — invisible until integration.
2. **Releasability is an event for them, an invariant for you.** Gitflow *establishes* shippability during hardening on a release branch — hence freezes, development on release branches, and branch → trunk cherry-picks that cause silent regressions. TBD proves releasability **continuously on trunk**, so hardening disappears rather than moves.
3. **Their release branch is a moving target.** Merging fixes *up* into it during hardening means they ship a branch midway between two states. TBD ships a **snapshot of a chosen point**, with fixes flowing one way: trunk → branch.

*(b)* **Breaks first: build speed and test trustworthiness.** If the full build takes 30–40 min or is flaky, nobody runs it before pushing, bad commits land, trunk goes red, confidence collapses — and they conclude TBD doesn't work. Prerequisite zero: **fast, green, non-flaky build, the same script devs and CI run**. Then, in order:
1. CI daemon on trunk + a **revert policy** (bot or build-cop).
2. **Small stories** — hours-to-a-day. Usually the hardest, most cultural step.
3. **Flags + branch by abstraction** fluency — the escape valves.
4. **Review that doesn't stall** (AI-led with humans second at scale).
5. **Coverage deep enough that green means something**; duplicate CI for any active release branch.
6. **Decide the release model up front**; stop branch → trunk cherry-picks on day one.
7. **Artifacts build from trunk**, never from review branches.

Closing line: this is a **practice migration, not a branch rename**. A repo with a branch called `main` and three-week-old feature branches is Gitflow wearing a TBD costume.

**Traps to mark ❌**
- Restating TBD's rules instead of naming the colleague's pain.
- "First, make sure merges don't break the build" — circular.
- No ordering, or putting culture (small stories) after tooling.
