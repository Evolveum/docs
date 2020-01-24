---
layout: exercise
number: 2
title: "LDAP Provisioning"
permalink: /midpoint/exercises/02-ldap-provisioning/
synopsis: "Create a simple midPoint configuration that provisions account to LDAP server."
difficulty: Very easy
bookref:
  - "Chapter 4: Resources and Mappings"
trainingref:
  - MID-101
---

## Environment

* **Open source LDAP server** (OpenLDAP, 389ds or similar): Company-wide LDAP server that is used as central user directory and authentication server for several applications. Accounts should be provisioned into the LDAP server using the standard `inetOrgPerson` object class.
* **MidPoint**: Start the exercise with midPoint server populated with a couple of sample users. Otherwise the server is empty (only default initial objects are present).

## Description

Our company is using an LDAP server as central directory server. Many applications are configured to authenticate at this server using LDAP protocol. But managing LDAP server directly is a pain. So many confusing object classes and attributes. We want to make administrator's life easier. We want administrators to create and modify users in midPoint user interface. When an administrator assigns LDAP account to a midPoint user, we want to create a proper LDAP account. Make sure that basic account attributes such as `cn`, `sn` and `givenName` are automatically populated. Make sure that passwords are set in the LDAP server for the applications to properly authenticate. Make sure that the LDAP account is disabled when midPoint user is disabled - and vice versa.

## Notes

* LDAP accouts are good enough. Just a single LDAP entry for each user. You do not need to deal with groups or anything else.
* Simple assignment of default LDAP account should work. Administrator does that manually in midPoint administration GUI. There is no need to deal with roles or any other form of automation - except for provisioning and LDAP attribute mappings.
