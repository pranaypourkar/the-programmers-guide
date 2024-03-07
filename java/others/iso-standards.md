# ISO Standards

### ISO-8601 calendar system

The ISO-8601 calendar system, also known as the International Standard Organization (ISO) 8601 Data and time - Representation and exchange, is an international standard for the representation of dates and times. It defines a well-defined, unambiguous way to exchange date and time information across different countries and cultures, avoiding confusion and misinterpretation.

Key characteristics of the ISO-8601 calendar system:

* **Basic format:** The basic format for representing a date is **YYYY-MM-DD**, where:
  * **YYYY** represents the **four-digit year** (e.g., 2024 for the current year)
  * **MM** represents the **two-digit month** (01 for January, 02 for February, etc.)
  * **DD** represents the **two-digit day of the month** (01 for the first day, 31 for the last day, etc.)
* **Time representation:** Time is typically represented in **24-hour format** using **hours-minutes-seconds** notation, separated by colons (e.g., 15:08:23).
* **Optional components:** The standard allows for optional components like:
  * **Milliseconds:** Can be added after seconds with a decimal point (e.g., 15:08:23.123).
  * **Timezone offset:** Can be specified using the `Z` character for UTC or the plus/minus symbol followed by the offset in hours and minutes (e.g., 2024-03-05T15:08:23+05:30 for a time 5 hours and 30 minutes ahead of UTC).
* **Week dates:** The standard also defines a format for representing dates based on the week number and day of the week (e.g., 2024-W10-5 for the fifth day of the tenth week in 2024).
* **Ordinal dates:** Dates can be represented based on the day of the year (e.g., 2024-064 for the 64th day of 2024).

**Benefits of using ISO-8601:**

* **Universality:** It's an internationally recognized standard, avoiding confusion and ensuring accurate data exchange across borders.
* **Machine-readable:** The structured format makes it easy for computers to parse and interpret dates and times.
* **Sorting:** Dates in ISO-8601 format can be easily sorted chronologically due to their numerical representation.

**Examples:**

* **Date only:** 2024-03-05 (today's date)
* **Date and time:** 2024-03-05T15:08:23 (today's date and time at 3:08 PM)
* **Date and time with timezone:** 2024-03-05T15:08:23Z (today's date and time in UTC)
* **Date and time with offset:** 2024-03-05T15:08:23+05:30 (today's date and time 5 hours and 30 minutes ahead of UTC)
