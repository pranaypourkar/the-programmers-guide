# Heap Dump Capture

## **jmap**

A command-line tool included in the JDK, used to capture heap dumps of a running Java process. It outputs a binary heap dump file for analysis.

## **VisualVM**

A GUI-based monitoring and diagnostic tool included with the JDK. Allows capturing heap dumps, monitoring memory usage, and analyzing memory leaks in real time.

## **jcmd**

A versatile command-line tool included in the JDK. Captures heap dumps and performs other diagnostic operations for JVM processes.

## **Eclipse MAT (Memory Analyzer Tool)**

A powerful GUI-based tool for analyzing heap dumps. Provides detailed insights into memory leaks, object retention, and usage patterns.

## **IntelliJ IDEA Profiler**

A built-in profiler in IntelliJ IDEA (Ultimate Edition) for capturing and analyzing heap dumps during development.

## **YourKit Java Profiler**

A commercial Java profiler that captures and analyzes heap dumps, providing advanced features like memory leak detection and object retention graphs.

## **AppDynamics**

An APM tool for enterprise systems that captures heap dumps as part of its diagnostics for memory usage and leak analysis.

## **Dynatrace**

An enterprise APM solution that captures heap dumps for applications under high memory pressure and integrates with overall system monitoring.

## **Kill -3 Command**

Sends the `SIGQUIT` signal to the JVM process on Unix-based systems to trigger heap dump generation, typically written to the application logs.

## &#x20;**jhat (Java Heap Analysis Tool)**

A deprecated but still usable command-line tool in the JDK to analyze heap dump files in combination with `jmap`.

## **JVM Options (`-XX:+HeapDumpOnOutOfMemoryError`)**

A JVM option to automatically generate a heap dump when an `OutOfMemoryError` occurs, typically for production debugging.
