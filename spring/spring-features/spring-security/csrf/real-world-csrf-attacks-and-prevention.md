# Real-World CSRF Attacks & Prevention

## About

CSRF occurs when an attacker forces an authenticated user to perform unwanted actions on a web application without their consent. The attack is successful when the victim’s browser automatically sends session cookies (authentication credentials) along with the forged request.

## **The Samy Worm (2005) - MySpace CSRF Attack**

### **What Happened?**

* The attacker (Samy Kamkar) exploited a CSRF vulnerability in MySpace.
* He injected a self-replicating JavaScript payload that **automatically added him as a friend** when any logged-in user viewed his profile.
* The worm spread rapidly, **infecting over 1 million accounts within 24 hours**.

### **How It Worked**

```html
<img src="http://www.myspace.com/addfriend.php?friend_id=12345" />
```

* Any logged-in user who viewed Samy’s profile automatically **sent a request to add him as a friend** without their knowledge.

## **Gmail CSRF Attack (2007) – Stealing Emails**

### **What Happened?**

* A researcher demonstrated a **CSRF attack that stole Gmail emails**.
* Victims who were logged into Gmail could be tricked into visiting a malicious webpage.
* The webpage contained a CSRF attack that forwarded the victim’s emails to the attacker’s account.

### **How It Worked**

```html
<form action="https://mail.google.com/mail/h/12345678/?v=b&f=cs" method="POST">
    <input type="hidden" name="to" value="attacker@gmail.com">
    <input type="hidden" name="action" value="forward">
    <input type="submit">
</form>
<script>document.forms[0].submit();</script>
```

* As soon as the victim loaded the page, their emails were forwarded **without their consent**.

## **PayPal CSRF Attack (2010) – Unauthorized Fund Transfer**

### **What Happened?**

* An attacker demonstrated how **CSRF could be used to transfer money from a PayPal account**.
* The attacker hosted a malicious webpage that contained a **hidden form** that automatically submitted a money transfer request.

### **How It Worked**

```html
<form action="https://www.paypal.com/sendmoney" method="POST">
    <input type="hidden" name="amount" value="1000">
    <input type="hidden" name="recipient" value="attacker@gmail.com">
    <script>document.forms[0].submit();</script>
</form>
```

* If a logged-in PayPal user visited this page, **money was transferred to the attacker’s account automatically**.

## **Netflix CSRF Attack (2008) – Changing Account Details**

### **What Happened?**

* A vulnerability allowed attackers to **change email addresses and passwords of Netflix users**.
* If a user was logged in and visited a malicious site, their Netflix account was hijacked.

### **How It Worked**

```html
<img src="https://www.netflix.com/account/update_email?email=attacker@example.com">
```

* The victim’s Netflix account email was changed to an **attacker-controlled email**, effectively locking them out.

## **ING Bank CSRF Attack (2013) – Unauthorized Money Transfers**

### **What Happened?**

* Dutch bank **ING** suffered from a CSRF vulnerability that allowed attackers to **initiate unauthorized transactions**.

### **How It Worked**

1. Victim logs into their ING bank account.
2. Victim visits a malicious webpage with an **invisible form submission**.
3. The bank processes the forged request, transferring money to the attacker.
