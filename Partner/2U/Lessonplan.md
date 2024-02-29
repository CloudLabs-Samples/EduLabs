### 17.3 Lesson Plan: Windows Persistence, Lateral Movement, Credential Access, and Review

## Overview
In today's class, students will finish the second penetration testing module by establishing persistence on a Windows
machine, laterally moving to the domain controller, and accessing the database where Active Directory credentials are
stored. The day will finish with a review of the pen testing modules using a service called Kahoot!.

## Class Objectives
By the end of class, students will be able to
- Understand how Windows credentials and Mimikatz work
- Perform lateral movement to other machines in a network
- Explain what DC replication is and how to use the DCSync attack

## Instructor Notes
It's important for students to strictly follow directions and use the given paths, payload names, etc. for activities. This
will prevent confusion when things do not work properly.

## Lab Environment
For this module, you will use the **Pen testing 2** lab environment located in Windows Azure Lab Services. RDP into the
Windows RDP Host machine using the following credentials:

- RDP login credentials for labs provisioned prior to 9/12/23
Username: azadmin
Password: p4ssw0rd*

- RDP login credentials for labs provisioned after 9/12/23
Username: azadmin
Password: p@ssw0rdp@ssw0rd

The credentials to the Hyper-V VMs are as follows:

Virtual Machine Username Password
Kali             root      kali
Metasploitable2 msfadmin cybersecurity
Windows 10 .\Administrator Topsecret!
WINDC01 Administrator Topsecret!

**NOTE:** To prevent the WINDC01 machine from rebooting due to expired license run the following from CMD as
Administrator: slmgr.vbs /rearm

## Slideshow
The lesson slides are available on Google Drive here: 17.3 Slides.
**Note**: Editing access is not available for this document. If you or your students wish to modify the slides, please
create a copy by navigating to **File > Make a copy**.

## Student Guide
Share the student-facing version of this lesson plan after class: 17.3 Student Guide.



