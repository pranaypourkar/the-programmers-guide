# Best Practices for Rule Configuration

## About

Rule configuration determines **whether SonarQube becomes a trusted quality system or an ignored noise generator**. Most failures with SonarQube are not caused by bad rules, but by **poor configuration and unrealistic expectations**.

The goal of rule configuration is **risk control**, not zero issues.

## Start with Default Profiles, Not Custom Ones

The default SonarQube profiles exist for a reason:

* They encode industry consensus
* They are conservative
* They minimize false positives

Disabling rules blindly or starting from an empty profile is a common mistake. Early customization should be **subtractive and minimal**, not additive and aggressive.

Rule configuration maturity should evolve over time.

## Separate Detection from Enforcement

A critical mental model:

* Rules detect issues
* Quality Gates enforce acceptance

Do not disable rules just because they should not block delivery.

Instead:

* Keep detection broad
* Keep enforcement narrow

This allows visibility without disruption.

## Always Configure for “New Code First”

New Code is the cornerstone of sustainable adoption.

Best practice:

* Apply strict rules to New Code
* Be lenient on legacy code
* Gradually raise standards over time

This avoids:

* Immediate gate failures
* Developer resistance
* Massive technical debt paralysis

New Code focus turns SonarQube into a **forward-looking quality system**.

## Be Conservative with Severity Changes

Severity changes influence developer behavior more than almost anything else.

Best practices:

* Avoid promoting many rules to High or Blocker
* Reserve high severities for correctness and security
* Keep maintainability issues mostly Medium or Low

Overusing high severity causes:

* Alert fatigue
* Ignored dashboards
* Blind “Won’t Fix” marking

Severity inflation reduces trust.

### Understand False Positives Before Disabling Rules

False positives are inevitable, but disabling rules globally is rarely the right response.

Better approaches:

* Mark individual issues as False Positive
* Use rule parameters instead of disabling rules
* Suppress locally when justified

Disabling rules removes signal for everyone, including cases where the rule would have been valid.

## Treat Security Hotspots Differently

Security Hotspots are not vulnerabilities and should never be treated as such.

Best practices:

* Never block builds on hotspots alone
* Establish a review workflow
* Document decisions explicitly

Hotspots are about **intent verification**, not mechanical fixes.

## Avoid Rule Configuration Drift

Over time, rule changes accumulate and create inconsistency.

To prevent drift:

* Centralize profile ownership
* Document why rules are enabled/disabled
* Review profiles periodically
* Avoid per-project divergence unless justified

Uncontrolled drift leads to:

* Incomparable projects
* Confusing metrics
* Broken quality governance

## Align Rules with Coding Standards and Architecture

Rules should reinforce how your team builds software.

Examples:

* Enable rules that match architectural decisions
* Disable rules that conflict with intentional patterns
* Tune thresholds based on real code structure

SonarQube should reflect **how you design systems**, not fight against them.

## Measure Trends, Not Raw Counts

Rule configuration success should be evaluated using:

* Trend improvement
* Reduction in new issues
* Stable or improving ratings

Raw issue counts are misleading and often demoralizing.

A stable codebase with 500 smells may be healthier than one oscillating between 50 and 100.

## Do Not Encode Personal Preferences as Rules

A common failure mode:

* Treating stylistic preferences as mandatory rules

This leads to:

* Unnecessary debates
* Reduced adoption
* Loss of focus on real risk

Rules should enforce:

* Correctness
* Security
* Maintainability at scale

Formatting and personal taste belong elsewhere.

## Use Rule Configuration as a Teaching Tool

Well-configured rules:

* Explain why something matters
* Encourage better design
* Reduce review friction

Poorly configured rules:

* Create resentment
* Encourage bypassing
* Teach developers to ignore tooling

Documentation and rule descriptions matter more than enforcement.

## Revisit Configuration After Major Changes

Rule profiles should be reviewed after:

* Major refactoring
* Architecture shifts
* Language upgrades
* Dependency changes

Static rule configuration in a dynamic system is a silent failure mode.

## Maturity Model for Rule Configuration

A realistic progression:

1. Observe only (no blocking)
2. Block critical reliability and security on New Code
3. Gradually enforce maintainability
4. Optimize and tune based on feedback
5. Periodic governance reviews

Trying to jump directly to step 4 usually fails.

## Common Anti-Patterns

* Blocking builds on all issues
* Disabling rules because “they’re annoying”
* Treating SonarQube as a linter
* Using raw counts as KPIs
* Letting profiles diverge uncontrolled

Avoiding these matters more than adding new rules.
