---
layout: exercise
number: 3
title: "Small LDAP-based Company"
permalink: /midpoint/exercises/03-small-ldap-based-company/
synopsis: "Combine HR Feed, LDAP provisioning and RBAC to set up a configuration for a small company."
difficulty: Easy
bookref:
  - "Chapter 4: Resources and Mappings"
  - "Chapter 5: Synchronization"
  - "Chapter 7: Role-Based Access Control"
  - "Chapter 8: Object Template"
trainingref:
  - MID-101
files:
  - hr.csv
---

## Environment

* **HR System**: Employee data are stored in the HR system. There is an export task that exports the content of an HR system into a CSV file in regular interval.
* **Open source LDAP server** (OpenLDAP, 389ds or similar): Company-wide LDAP server that is used as central user directory and authentication server for several applications. Accounts should be provisioned into the LDAP server using the standard `inetOrgPerson` object class.
* **MidPoint**: Start the exercise with an empty midPoint server.

## Description

We have a small company. We have a simple HR system that exports the data to an CSV file. All the current employees are recorded in the HR system. There is also an LDAP server that works as central directory server. Many applications are configured to authenticate at this server using LDAP protocol. Our resident administrator is tired of managing LDAP accounts manually. Therefore we want to set up midPoint to automate this process.

Set up an synchronization task to pull the data from HR CSV file automatically (see Exercise 1). Set up automatic provisioning to LDAP server (Exercise 2). You may need to set up a simple object template to compute some user properties (such as full name). Then combine all of that with roles. Make sure than `Employee` role is automatically assigned to all employees. That role should contain a configuration that creates LDAP account.

The process should be completely automatic. New LDAP account should be automatically created when a new record is added to the CSV file. And the process should be quick, it should take just a few seconds. Also make sure that deprovisioning work: LDAP account should be deleted when a record from CSV file is removed.

Make sure that initial passwords are generated, either randomly or in some other algorithmic way. There is no need to deliver the initial password to users. We abstract from that in the exercise. LDAP group management or any other functionality is not needed. Make sure that `cn` and similar LDAP attributes are managed as single-value attributes. Make sure that those attributes have a human-friendly display names. Make sure that the attributes that are automatically computed are not marked as *mandatory* in the GUI. Make sure that enable/disable works - that LDAP accounts are properly disabled when needed. Make sure that the system is stable. e.g. recompute of a user should not try to delete HR account, unassign employee role and so on. Make sure that administrator accounts in LDAP are never changed or deleted by midPoint.

Also make sure that you can create new users in midPoint manually. We have contractors that do not have records in the HR systems. Create a `Contractor` role that also creates an LDAP account. But use one of the LDAP account attributes to distingush between contractors and employees. Employees should have value of `E` in that LDAP attribute and contractors should have `C`.
