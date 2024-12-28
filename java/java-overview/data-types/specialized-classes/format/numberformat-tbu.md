# NumberFormat - TBU

```
NumberFormat usFormat = NumberFormat.getCurrencyInstance(Locale.US);

        Locale indiaLocale = new Locale("en", "IN");
        NumberFormat indiaFormat = NumberFormat.getCurrencyInstance(indiaLocale);

        System.out.println("US: " + usFormat.format(payment));
        System.out.println("India: " + indiaFormat.format(payment));
        
 12324.134
 US: $12,324.13
 India: Rs.12,324.13
 
 
```

