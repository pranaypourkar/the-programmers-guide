# Artifact and BOM Versioning

### **Artifact Versioning**

<mark style="background-color:green;">**Pattern**</mark>**:** `MAJOR.MINOR.PATCH-QUALIFIER`

* **MAJOR.MINOR.PATCH**: This is a semantic versioning scheme, where:
  * **MAJOR**: Represents backward-incompatible changes. Incrementing this signifies significant changes that may require substantial migration efforts.
  * **MINOR**: Indicates backward-compatible changes, often including new features or enhancements. Migration efforts here might be moderate.
  * **PATCH**: Reserved for backward-compatible bug fixes or minor updates that do not introduce new features. These typically require minimal migration efforts.
* **QUALIFIER**: This adds extra information to the version, such as milestones, release candidates, or snapshots. Omitting this in General Availability (GA) releases keeps the version number cleaner. GA (General Availability) usually indicates that this version is a stable release. GA qualifier can also be omitted and still considered as stable releases (for e.g. **1.2.3**).

{% hint style="info" %}
**Qualifiers**: Using qualifiers like milestones (-M1..-M9), release candidates (-RC1..-RC9), and snapshots (-SNAPSHOT) provides valuable context about the stability and nature of the release.

Here's a breakdown of the qualifiers mentioned:

* **Milestone (-M1 to -M9):** These are used for significant milestones within a development cycle leading to a final release (<mark style="background-color:yellow;">PROD environment tags</mark>). They might contain new features or bug fixes but are not considered generally available (GA) releases.
* **Release Candidate (-RC1 to -RC9):** These are pre-release versions (<mark style="background-color:yellow;">SIT or UAT environment image tags</mark>) that are functionally near-complete and intended for testing before a final GA release. They can help identify critical issues before wider distribution.
* **SNAPSHOT:** This qualifier indicates a development build (<mark style="background-color:yellow;">DEV environment image tags</mark>) that is not intended for production use. Snapshots are typically used for internal testing or integration purposes and might be frequently updated.
{% endhint %}

#### Example

* **WidgetManager Artifact Version 1.2.3-GA**:
  * MAJOR: 1 - No fundamental changes, backward compatible with previous versions.
  * MINOR: 2 - Introduces new features like multi-widget support and customizable themes.
  * PATCH: 3 - Bug fixes and minor enhancements.
  * QUALIFIER: GA (General Availability) - Indicates this version is a stable release.
* **WidgetManager Artifact Version 2.0.0-M1**:
  * MAJOR: 2 - Significant changes, potentially requiring migration efforts.
  * MINOR: 0 - First release in the new major version.
  * PATCH: 0 - No patches yet.
  * QUALIFIER: M1 (Milestone 1) - Indicates an early preview release for testing.



### **BOM Versioning**

<mark style="background-color:green;">**Pattern**</mark>**:** `YYYY.MINOR.PATCH-QUALIFIER`

* **YYYY.MINOR.PATCH**: This is a calendar versioning (**CalVer**) scheme, where:
  * **YYYY**: Represents the year of the first General Availability (GA) release in a given release cycle. This allows for clear differentiation between release cycles.
  * **MINOR**: Indicates incremental changes within the same release cycle. It helps discern different releases within the same year.
  * **PATCH**: Represents service releases or bug fixes within a release cycle.
* **QUALIFIER**: Similar to artifact versioning, this provides additional information about milestones, release candidates, or snapshots.

#### Example

* **WidgetManager BOM Version 2022.1.0-GA**:
  * YYYY: 2022 - Year of the first GA release in the release cycle.
  * MINOR: 1 - Indicates the first minor release in the 2022 cycle.
  * PATCH: 0 - No patches yet.
  * QUALIFIER: GA (General Availability) - Indicates a stable release.
* **WidgetManager BOM Version 2023.0.1-RC1**:
  * YYYY: 2023 - Year of the first GA release in the release cycle.
  * MINOR: 0 - Indicates the first minor release in the 2023 cycle.
  * PATCH: 1 - First release candidate addressing critical issues identified during testing.
  * QUALIFIER: RC1 (Release Candidate 1) - Indicates a release candidate for final testing before GA.
* **WidgetManager BOM Version 2024.1.2-SNAPSHOT**:
  * YYYY: 2024 - Year of the first GA release in the release cycle.
  * MINOR: 1 - Indicates the first minor release in the 2024 cycle.
  * PATCH: 2 - Second snapshot including experimental features and ongoing development.
  * QUALIFIER: SNAPSHOT - Indicates an unstable, in-development version.

