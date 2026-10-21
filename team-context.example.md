# Team context for the TBD Tutor
#
# Copy this file to team-context.md and fill it in. The tutor reads it before
# Question 1 and uses it to ground rungs 9 and 12 in your real setup.
# It never overrides a model answer -- only the examples.

## Repos

<!-- One line each: name, language, what it is -->

- `aws-batch` -- AWS infrastructure for the batch pipeline
- `fb-solver` -- the solver
- `solver-api` -- backend API (Go)
- `fb-translator` -- input-file translation service

Monorepo or polyrepo? <answer>

## Release

- Production release cadence: <e.g. weekly, on demand, multiple times a day>
- Who cuts a release: <person/team/automation>
- Do you use a release branch, or release from trunk? <answer>
- Anything that blocks a release from being cut today: <answer>

## Build

- Full build time on a dev workstation (compile + unit tests): <e.g. 4 minutes>
- Is there a CI daemon guarding trunk? <what it is>
- Flaky test situation: <answer>

## Branching today

- How many open branches older than two days, roughly? <number>
- How many developers typically write on one branch? <number>
- Typical story/task size: <hours / days / weeks>
- Anything anyone is currently doing that the tutor would call an anti-pattern? <answer>

## Constraints we can't change

<!-- e.g. client-mandated release windows, compliance approvals, enterprise governance -->

- <answer>
