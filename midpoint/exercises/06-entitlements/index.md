---
layout: exercise
number: 6
title: "Basic Entitlement Management"
permalink: /midpoint/exercises/06-entitlements/
synopsis: "Entitlements (LDAP groups), intents, notifications, etc."
difficulty: Easy-Medium
bookref:
  - "Chapter 4: Resources and Mappings"
  - "Chapter 5: Synchronization"
  - "Chapter 6: Schema"
  - "Chapter 7: Role-Based Access Control"
  - "Chapter 8: Object Template"
  - "Unwritten chapters"
trainingref:
  - MID-101
files:
  - hr.csv
---

## Environment

* **HR System**: Employee data are stored in the HR system. There is an export task that exports the content of an HR system into a CSV file in regular interval.
* **Open source LDAP server** (OpenLDAP, 389ds or similar): Company-wide LDAP server that is used as central user directory and authentication server for several applications. Accounts should be provisioned into the LDAP server using the standard `inetOrgPerson` object class.
* **MidPoint**: Start the exercise with an empty midPoint server. Alternatively you may start with a configuration from previous exercises.

## Description

We have a small company. We have a simple HR system that exports the data to an CSV file that works the same way as in previous exercises. There is also an LDAP server that works as central directory server that also works in the same way as we have seen before. Optionally, you can use the whole setup from previous exercises as a baseline for this exercise.

The goal of this exercise is to set up LDAP group management by using midPoint concept of *entitlements*. The applications that connect to our LDAP server are using LDAP groups for access control. Therefore we need to manage group membership to manage access to those applications.

Create some LDAP groups in the LDAP server to set up an environment for this exercise. Use of the standard LDAP objectclases for the groups (e.g. `groupOfName` or `groupOfUniqueNames`). A good idea would be to create groups that correspond to the "job roles" used in previous exercises. Create one big 'employees' group.

Set up appropriate entitlement and association definitions for the LDAP groups in your LDAP resource. Modify role definitions in such a way that the roles are automatically granting membership in their corresponding LDAP groups. E.g. role `Employees` should automatically grant membership in `employees` LDAP group.

LDAP group membership should be displayed in midPoint user inteface in a user-friendly way. E.g. group membership should be displayed under `LDAP Groups` label in the account details page.

Set up some roles for system administration, such as `UNIX System Administrator` or `Business Systems Manager`. Those jobs will need privileged access to information systems. We do not want our users to use their ordinary employee LDAP account to do system administration tasks. We want to create one additional LDAP account for any user that participates in system administration tasks. Set up a reasonable naming convention for those accounts, such as prefixing usernames with `admin-`. Therefore if Peter Phillips will become system administrator he will have two accounts: `pphilips` as his ordinary non-privileges employee account and `admin-pphilips` as an privileged administration account. Create an `admins` LDAP group and make sure that all administration accounts are members of this group.

Our administrators are not used to those separated administration accounts yet. Set up e-mail notifications that notifies users whenever an account is created for them or whenever their account is deleted. Set up a custom text for the notification, explaining the concept of admin accounts. Writing the notifications to a text log file is sufficient for the purposes of this exercise.

You hate to repeat yourself. It is a trouble to copy and paste LDAP server DN suffix in so many places in the LDAP resource configuration, isn't it? Get rid of that. Set up a system constant that contains the DN suffix. Then use that constant in all relevant places of LDAP resource definition.

It is likely that you make some mistakes during the completion of this exercise. It would be nice to see actual LDAP operations that midPoint is executing on the LDAP server, wouldn't it? Make sure that the LDAP operations are recorded in system log files. But we do not want to log everything that the LDAP connector does. We want just LDAP operations and their results.

Now we have quite a nice and complete solution. It would be a tragedy if something happened to it. Make sure that your solution is properly backed up. E.g. use `ninja` tool to make a backup copy of the configuration. Preferably go through a complete backup-and-recovery drill.

## Notes

* You can implement this exercise by using standard LDAP attributes only, e.g. `member` and `uniqueMember` attributes. But most LDAP servers also support "shortcut" attributes that reflect group membership on an account, e.g. `memberOf` or `isMemberOf`. Those attributes are usually needed for any serious use of LDAP groups in practice. Make sure that you use those attributes in your solution if your LDAP server supports them.
* It would be nice to save some work with those "job roles" by setting up meta-roles, wouldn't it?
