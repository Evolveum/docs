---
layout: exercise
number: 4
title: "Nicer Small Company"
permalink: /midpoint/exercises/04-nicer-small-company/
synopsis: "Small company with a nicer configuration: nicer usernames, some role hierarchy."
difficulty: Easy
bookref:
  - "Chapter 4: Resources and Mappings"
  - "Chapter 5: Synchronization"
  - "Chapter 7: Role-Based Access Control"
  - "Chapter 8: Object Template"
files:
  - hr.csv
---

## Environment

* **HR System**: Employee data are stored in the HR system. There is an export task that exports the content of an HR system into a CSV file in regular interval.
* **Open source LDAP server** (OpenLDAP, 389ds or similar): Company-wide LDAP server that is used as central user directory and authentication server for several applications. Accounts should be provisioned into the LDAP server using the standard `inetOrgPerson` object class.
* **MidPoint**: Start the exercise with an empty midPoint server.

## Description

We have a small company. We have a simple HR system that exports the data to an CSV file. All the current employees are recorded in the HR system. There is also an LDAP server that works as central directory server. Many applications are configured to authenticate at this server using LDAP protocol. Our resident administrator is tired of managing LDAP accounts manually. Therefore we want to set up midPoint to automate this process.

Set up an synchronization task to pull the data from HR CSV file and provision accounts to LDAP server automatically. This setup should be based on previous exercise (see Exercise 3). But there are few changes:

Nicer usernames
* Make sure that we have nice human-friendly usernames. Do not use employee numbers. Create some kind of algorithmic usernames based on user's real name. Usernames such as `aanderson`, `a.anderson` or even `anders` should be acceptable, but do not make it too trivial.
* Make sure that the username is unique. For example make sure that you can hire "Albert Anderson" and everything works.
* Make sure that people can be renamed. If Alice gets married to Mr. Smith, make sure her username changes to `asmith`.
* Make sure that renames are properly reflected in LDAP.

Improved roles:
* There are job codes in the HR file. Let's use them. Create roles for every job code that is present in the HR file. Make sure those "job roles" are automatically assigned.
* Do not repeat yourself. You could assign both the `Employee` role and the "job" role to the user. But that would be boring. We do not want to have two assignments when one is enough. Therefore make use of role hierarchy. We still want `Employee` role, we still want that role to contain LDAP account construction, but we do not want to assign that role to users directly.
* You will have to figure out what to do with users that do not have a job code. You can either assign some default role to them. Or you can simply choose not to provision LDAP account to those people. Figure out something meaningful (but not too trivial).

The process should be completely automatic. No administrator intervention should be needed. We still need initial passwords and all the other applicable things from previous exercises. We also want to be able to create contractors manually. Make sure it is still possible.
