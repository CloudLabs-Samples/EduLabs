# Challenge 3: Resolving a Network Printer Access Issue

## Objective

Diagnose and resolve a network printer connectivity issue caused by missing DNS records, and validate successful printer access from the Client VM.

## Scenario

**HELPDESK TICKET #HD-2863 | Priority: HIGH | Status: ASSIGNED TO YOU**

---

**From:** enduser1 (enduser1@contoso.local)  
**Subject:** URGENT - Cannot connect to office printer for report printing  
**Time Reported:** Tuesday, 11:15 AM

---

**Issue Description:**

*"I need to print an important client report for a meeting this afternoon, but I can't connect to our office printer at all. When I try to add the printer using its name 'printerhost', it doesn't show up in my Devices and Printers.*

*I've tried searching for it multiple times, but Windows can't find it. I even tried typing the printer path directly (\\printerhost\OfficePrinter) but I get an error saying the network path cannot be found.*

*Other people in the office were able to print yesterday, so I know the printer itself is working. This is really urgent - I need to print this 50-page report before my 2 PM client meeting. Can you please help me get connected to the printer?"*

---

**Your Mission:**

As the helpdesk technician at Contoso Corporation, you need to quickly resolve this printer connectivity issue. You must:

- Investigate why the printer at printerhost.contoso.local is unreachable from the Client VM
- Diagnose whether this is a network issue, DNS issue, or printer configuration problem
- Identify and resolve the root cause of the connectivity failure
- Validate that the user can successfully access and connect to the network printer

**Important:** The user has a client meeting at 2 PM and needs to print critical documents. Time is limited, but you must follow proper troubleshooting procedures to identify the real issue rather than applying quick fixes.

## Lab Environment

When the lab is launched, CloudLabs automatically provisions:

- **Client VM**

   - Domain-joined to CONTOSO
   
   - User workstation experiencing the printer connectivity issue
   
   - Used for problem verification and validation

- **DC01 (Domain Controller)**

   - Hosts Active Directory Domain Services
   
   - Runs DNS services for the contoso.local domain
   
   - Used for DNS configuration and remediation
   
   - **Note:** A DNS record for the printer host is missing

- **Network Printer**

   - Shared printer: \\printerhost\OfficePrinter
   
   - Hostname: printerhost.contoso.local
   
   - IP Address: 192.168.100.11

## Challenge Workflow

Learners must complete the following tasks using the CloudLabs environment.
No commands or step-by-step instructions are provided.

## Task 1: Verify and Diagnose the Problem

Using the Client VM:

- Confirm that the printer at printerhost.contoso.local is unreachable

- Test basic network connectivity to the printer hostname

- Perform DNS resolution tests to determine if the hostname can be resolved

- Identify whether this is a DNS issue, network issue, or printer configuration issue

## Task 2: Investigate DNS Configuration

Using the DC01 server:

- Access the DNS management console

- Examine the DNS zone for contoso.local

- Identify what DNS record is missing for the printer host

- Determine the correct DNS record type and configuration needed

## Task 3: Remediate the DNS Issue

On the DC01 server:

- Create the appropriate DNS record for the printer host

- Configure the record with the correct hostname and IP address

- Ensure the DNS record is properly registered in the contoso.local zone

## Task 4: Validate Printer Access

From the Client VM:

- Re-test DNS resolution to confirm the hostname now resolves correctly

- Verify network connectivity to the printer host

- Access the network printer using the UNC path (\\printerhost\OfficePrinter)

- Confirm the printer is now accessible and can be connected

## Printer Configuration Details

- **Printer Hostname:** printerhost.contoso.local
- **Printer IP Address:** 192.168.100.11
- **Printer Share Name:** OfficePrinter
- **UNC Path:** \\printerhost\OfficePrinter

## Success Criteria

The challenge is considered successfully completed when:

- DNS resolution for printerhost.contoso.local returns the correct IP address (192.168.100.11)

- Network connectivity to printerhost.contoso.local is successful (ping succeeds)

- The appropriate DNS A record has been created in the contoso.local zone

- The network printer is accessible via the UNC path \\printerhost\OfficePrinter from the Client VM

- No unnecessary DNS records or configurations were added

## Validation 3: Resolve a Network Printer Access Issue

<validation step="1fe8bbf2-464d-4423-9d85-6469433caa5e" />
