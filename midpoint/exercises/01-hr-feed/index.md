---
layout: exercise
number: 1
title: "HR Feed"
permalink: /midpoint/exercises/01-hr-feed/
synopsis: "Configure a simple automatic data feed from an Human Resource system represented by a CSV file."
difficulty: Very easy
bookref: 
  - "Chapter 5: Synchronization"
files:
  - hr.csv
---

# Environment

* **HR System**: Employee data are stored in the HR system. There is an export task that exports the content of an HR system into a CSV file in regular interval.
* **MidPoint**: Start the exercise with an empty midPoint server (only default initial objects are present).

# Description

The goal is to set up automatic feed from the HR CSV file. MidPoint users should be created for all the records in the CSV files. User name, employee number and all the other data from the CSV file should be properly mapped to midPoint users. You can use employee number as user identifier (username).

Set up a synchronization task that atomatically pulls the data from HR CSV file. Both llive synchronization and reconciliation is fine. The system should be running automatically, all by itself, without any administrator intervention. When the HR data are changed the data in midPoint should change as well.


