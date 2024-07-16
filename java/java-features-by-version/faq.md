# FAQ

## 1. Why are some Java versions for example 8 also called 1.8? <a href="#why_are_some_java_versions_like_8_also_called_1_8" id="why_are_some_java_versions_like_8_also_called_1_8"></a>

Java versions before 9 had a different naming scheme. So, Java 8 can also be called _1.8_, Java 5 can be called _1.5_ etc. With the switch to time-based releases with Java 9 the naming scheme also changed, and Java versions aren’t prefixed with 1.x anymore.

<figure><img src="../../.gitbook/assets/image (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt="" width="563"><figcaption></figcaption></figure>

<figure><img src="../../.gitbook/assets/image (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt="" width="563"><figcaption></figcaption></figure>

## 2. How Java versions differs? Do we learn a specific one? <a href="#what_is_the_difference_between_the_java_versions_should_i_learn_a_specific_one" id="what_is_the_difference_between_the_java_versions_should_i_learn_a_specific_one"></a>

Considering a example of Python where there are breakages between releases, like say Python 2 to 3, Java is special here. Java in this regard is backwards compatible. This means that our Java 5 or 8 program is guaranteed to run with a Java 8-20 virtual machine with a few exceptions which can be ignored for now.

However, it does not work the other way around, say our program relies on Java 20 features, that are not available under a Java 8 JVM.

## 3. Does Oracle website offers both JREs and JDKs ?

Up until Java 8, the Oracle's website offered JREs and JDKs as separate downloads - even though the JDK also always included a JRE in a separate folder. With Java 9 that distinction was gone, and we are _always_ downloading a JDK. The directory structure of JDKs also changed, with not having an explicit JRE folder anymore.

{% hint style="info" %}
_JRE_ is needed for running Java programs. A JRE includes, among other things, the Java Virtual Machine (JVM) and the "java" command line tool.

To develop new Java programs, we need a JDK. A JDK includes _everything_ the JRE has, as well as the compiler _javac_ and a couple of other tools like _javadoc_ (Java documentation generator) and _jdb_ (Java Debugger).
{% endhint %}





