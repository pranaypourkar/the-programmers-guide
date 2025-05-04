# Java ME

## About

Java ME (Java Platform, Micro Edition) is a subset of the Java platform tailored for embedded systems and resource-constrained devices such as feature phones, set-top boxes, industrial controllers, and IoT devices.

* **Target**: Small devices with limited memory, display, and power (e.g., 128 KB–1 MB RAM)
* **Origin**: Initially called J2ME (Java 2 Micro Edition)
* **Current**: Part of the overall Java Platform but less prominent due to rise of smartphones and IoT-specific platforms
* **Base**: Subset of Java SE APIs with additional libraries for device-specific capabilities

## Components

### Configurations

Define the basic runtime environment:

* **CLDC (Connected Limited Device Configuration)**: For devices with very limited resources
* **CDC (Connected Device Configuration)**: For more capable devices (e.g., set-top boxes)

### Profiles

Built on top of configurations to add more APIs:

* **MIDP (Mobile Information Device Profile)**: For mobile phones and PDAs
* **Foundation Profile**: For CDC-based devices

### Optional Packages

* **Bluetooth (JSR 82)**
* **Wireless Messaging API (JSR 205)**
* **Mobile Media API (JSR 135)**
* **Location API (JSR 179)**

## Development Tools

* **Java ME SDK**: Provided by Oracle
* **Eclipse ME**: Plugin for Eclipse
* **NetBeans**: Better out-of-box support for Java ME
* **Emulators**: Used to test applications on different device profiles

## Deployment Model

* **.jar/.jad files**: Java Application Descriptor (JAD) used alongside the JAR for deployment to mobile phones
* **OTA (Over-the-Air)** provisioning

## Java ME vs Java SE

<table data-header-hidden><thead><tr><th width="227.76953125"></th><th></th><th></th></tr></thead><tbody><tr><td>Feature</td><td>Java ME</td><td>Java SE</td></tr><tr><td>Target Devices</td><td>Mobile, embedded, IoT</td><td>Desktop, server</td></tr><tr><td>API Coverage</td><td>Subset + mobile extensions</td><td>Full standard APIs</td></tr><tr><td>GUI Support</td><td>Limited (LCDUI in MIDP)</td><td>Swing, JavaFX</td></tr><tr><td>Networking</td><td>Mobile-optimized</td><td>Full TCP/IP, RMI</td></tr><tr><td>Security</td><td>Sandbox, permissions</td><td>Full JVM security</td></tr></tbody></table>

## Real-World Use Cases

* Feature phones (e.g., Nokia Series 40, Motorola)
* Payment terminals
* RFID scanners
* Set-top boxes
* Industrial automation
* Early GPS/Location-based apps

## Decline and Transition

* **Smartphones** (Android, iOS) replaced the need for Java ME in consumer mobile devices
* **Android** uses a separate Java-based runtime (Dalvik/ART) not based on Java ME
* **Java ME Embedded** and **Java ME 8** attempted to modernize the platform for IoT
* IoT is now largely handled by other languages/frameworks: C, Python, Node.js, etc.

## Future and Current Status

* Java ME is not actively evolving
* Used in legacy systems and niche embedded devices
* Oracle focuses on Java SE for embedded solutions now
* Eclipse IoT and Jakarta EE are modern replacements in enterprise and IoT space
