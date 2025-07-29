---
hidden: true
---

# Anti Patterns

* **Hardcoding URLs with concatenation**:\
  `url = "https://.../users/" + userId + "/orders?page=" + page + "&sort=" + sort;`\
  This is error-prone and difficult to maintain.
* **Encoding values manually**:\
  Let Spring handle encoding via `UriComponentsBuilder.encode()`.
