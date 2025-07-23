# JavaFX

## About

JavaFX is a rich client application platform for Java that enables modern, visually appealing, and high-performance desktop applications.

* **Purpose**: To build desktop applications and internet apps with rich graphical user interfaces.
* **Replacement for**: Swing (legacy UI toolkit)
* **Ownership**: Originally developed by Sun Microsystems, later by Oracle; now maintained by the OpenJFX community.
* **Cross-platform**: Runs on Windows, macOS, Linux.
* **Separation of UI and Logic**: Supports FXML (an XML-based language) and CSS for UI design.

## History & Timeline

<table data-header-hidden><thead><tr><th width="158.65234375"></th><th width="181.5078125"></th><th></th></tr></thead><tbody><tr><td>Version</td><td>Release Year</td><td>Notes</td></tr><tr><td>1.x</td><td>2008-2010</td><td>Early scripting-based version</td></tr><tr><td>2.x</td><td>2011-2012</td><td>Java API-based (no more scripting)</td></tr><tr><td>Java 7u6</td><td>2012</td><td>JavaFX bundled with JDK</td></tr><tr><td>Java 11</td><td>2018</td><td>JavaFX decoupled from JDK; OpenJFX launched</td></tr><tr><td>JavaFX 20+</td><td>2023+</td><td>Maintained via OpenJFX, supports latest JDK</td></tr></tbody></table>

## Some of the Features

* **Modern UI Controls**: Buttons, sliders, tables, trees, charts, web views, etc.
* **CSS Styling**: Use CSS to style UI components
* **FXML**: Declarative UI definition using XML
* **Scene Graph**: Hierarchical structure to manage all elements in a scene
* **Media Support**: Audio and video playback
* **WebView**: Embedded web browser based on WebKit
* **Hardware-accelerated Graphics**: Utilizes GPU rendering via Prism engine
* **Property Bindings**: Reactive programming with observable properties
* **3D Graphics Support**: Basic 3D shapes, camera control, lighting
* **Internationalization**: Built-in support for i18n and localization

## Architecture

* **Prism**: Rendering engine (hardware accelerated)
* **Quantum Toolkit**: Connects Prism with UI components
* **Glass Windowing Toolkit**: Handles window management, events
* **Media Engine**: For audio and video
* **Web Engine**: Based on WebKit for rendering HTML content

## UI Development

Declarative (FXML)

```java
<Button fx:id="myButton" text="Click Me" onAction="#handleClick" />
```

Controller (Java)

```java
@FXML
private void handleClick(ActionEvent event) {
    System.out.println("Button clicked!");
}
```

## Development Tools

* **Scene Builder**: Visual tool to design FXML UIs
* **IntelliJ IDEA**: Excellent support with JavaFX plugin
* **Eclipse**: Supports JavaFX with e(fx)clipse plugin
* **NetBeans**: Built-in JavaFX integration (especially earlier versions)

## Deployment Options

* **JAR file**
* **Self-contained application**: Bundles JVM + app for native launch
* **JLink**: Creates minimal runtime image (Java 9+)
* **JPackage**: Creates native installers (.exe, .dmg, .deb, etc.)

## Differences: JavaFX vs Swing

| Feature        | JavaFX                        | Swing                    |
| -------------- | ----------------------------- | ------------------------ |
| Styling        | CSS-based                     | Java-based (LookAndFeel) |
| UI Design      | FXML + SceneBuilder           | Manual Java code         |
| Performance    | Hardware-accelerated          | Software rendering       |
| Web content    | WebView (WebKit-based)        | Basic HTML rendering     |
| Animation      | Built-in support              | Manual coding required   |
| Future support | OpenJFX (actively maintained) | Legacy                   |

