---
description: WIP
hidden: true
---

# Example

I have

@Entity @Getter @Setter @Table(name = "error\_category") public class ErrorCategoryEntity {

```
@Id
private String code;

@Column(name = "english_name")
private String englishName;

@Column(name = "arabic_name")
private String arabicName;

@ManyToMany(fetch = FetchType.EAGER, cascade = {CascadeType.ALL})
@OrderBy("code ASC")
@JoinTable(
    name = "error_category_purpose",
    joinColumns = {@JoinColumn(name = "error_category_code")},
    inverseJoinColumns = {@JoinColumn(name = "error_code")}
)
private List<ErrorEntity> errors;
```

}

And

@Entity @Getter @Setter @Table(name = "error") public class ErrorEntity {

```
@Id
private String code;

@Column(name = "english_name")
private String englishName;

@Column(name = "arabic_name")
private String arabicName;

@Transient
private String categoryCode;
```

}

