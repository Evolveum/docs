---
layout: exercise
number: 5
title: "Synchronize organizational structure to LDAP"
permalink: /midpoint/exercises/04-orgstruct-ldap-sync/
synopsis: "Synchronize organization structure from CSV file to LDAP server."
difficulty: Easy-Medium
bookref:
  - "Chapter 4: Resources and Mappings"
  - "Chapter 5: Synchronization"
  - "Chapter 7: Role-Based Access Control"
  - "Chapter 8: Object Template"
  - "Unwritten"
files:
  - hr.csv
  - org.csv
---

## Environment

* **HR System**: Employee data are stored in the HR system. There is an export task that exports the content of an HR system into a CSV file in regular interval. Unlike other exercises, this HR system is smart and it maintains full information about organizational structure (which is something rarely seen in practice).
* **Open source LDAP server** (OpenLDAP, 389ds or similar): Company-wide LDAP server that is used as central user directory and authentication server for several applications. Accounts should be provisioned into the LDAP server using the standard `inetOrgPerson` object class. This LDAP server has a traditional structure based on company organizational strucure. E.g. `uid=aanderson,ou=Direct Sales Department,ou=Sales and Marketing Division,dc=example,dc=com`.
* **MidPoint**: Start the exercise with an empty midPoint server.

## Description

We have a small company. We have a simple HR system that exports the data to an CSV file. All the current employees are recorded in the HR system. The HR system also exports organizational structure in CSV files. Each organizational unit has an (immutable) identifier. It also has an identifier of a parent organizational unit.

There is also an LDAP server that works as central directory server. Many applications are configured to authenticate at this server using LDAP protocol. For some strange reasons (probably historic or nostalgic) organizational structure is reflected in LDAP server.

Set up an synchronization task to pull the data from HR CSV files automatically. Both organizational structure and employees should be synchronized to midPoint. Employees should be properly assigned to organizational units. Users and orgs in midPoint should be fully populated, including computed properties such as `fullName`.

Set up automatic provisioning to LDAP server. Automatically assign roles based on job code. Maintain nice role hierarchy (see Exercise 4). Provisioning should be driven by roles.

All processes should be completely automatic. No administrator intervention should be required.

Manually create some organizational units for contractors. Make sure that you can create contractors manually. Make sure that neither contractors nor their organizational units are deleted during synchronization.

## Notes

* For the purposes of this exercise you can assume that the records have correct ordering in the `org.csv` file. E.g. that the units that are on top of the hierarchy will be synchronized first. You may also assume that organizational unit will be present in `org.csv` file long before any user is assigned to it.
* You may choose to handle unassigned users in any reasonable way (users that do not belong to any organization). You may choose to ignore them and do not create LDAP accounts for them. You may choose to automatically assign them to some "default" organizational unit. But whatever you do, it has to be automatic. No administrator intervention should be needed.
* We are not trying to suggest that this way of managing organizational structure in LDAP server is a good thing. In fact it is quite a terrible thing. This is just an exercise. It is purely academic. Do not use in practice. Honestly. Do not do this.

## Bonus

For added difficulty try to modify the configuration in such a way that file ordering assumptions are not necessary. Make synchronization work reliably regardless of file ordering. E.g. "lower" organizations may be synchronized before "upper" organizations. Also, user may be added to non-existent organization in `hr.csv`, such organization will appear in `org.csv` few minutes later. At that time the organizational unit should be properly created, users assigned and LDAP provisioned. This increases the difficult of this exercise to medium.
