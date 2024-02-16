# Code Style

TOC

* Source File
  * a

### Source File&#x20;

Source java file name should follow camelcase convention, starting with an uppercase letter. For example, MyClass.java, DateUtil.java, etc



### Source file structure

A source file consists of, in order:

1. License or copyright information, if present&#x20;
2. Package statement&#x20;
3. Import statements&#x20;
4. Exactly one top-level class

```
/*
* %W% %E% Firstname Lastname
*
* Copyright (c) 1993-1996 Sun Microsystems, Inc. All Rights Reserved.
*
* This software is the confidential and proprietary information of Sun
* Microsystems, Inc. ("Confidential Information"). You shall not
* disclose such Confidential Information and shall use it only in
* accordance with the terms of the license agreement you entered into
* with Sun.
*
* SUN MAKES NO REPRESENTATIONS OR WARRANTIES ABOUT THE SUITABILITY OF
* THE DERIVATIVES.
*/
package java.blah;

import java.blah.blahdy.BlahBlah;
/**
* Class description goes here.
*
* @version 1.10 04 Oct 1996
* @author Firstname Lastname
*/
public class Blah extends SomeClass {
/* A class implementation comment can go here. */
/** classVar1 documentation comment */
public static int classVar1;
/**
* classVar2 documentation comment that happens to be
* more than one line long
*/
private static Object classVar2;
/** instanceVar1 documentation comment */
public Object instanceVar1;
/** instanceVar2 documentation comment */
protected int instanceVar2;
/** instanceVar3 documentation comment */
private Object[] instanceVar3;
```
