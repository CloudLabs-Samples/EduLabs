# Challenge 4: Resolving Azure Portal Access Failure

## Objective

Diagnose and resolve a configuration issue preventing access to the Azure Portal (portal.azure.com) while other websites remain accessible, and validate successful Azure Portal access from the Client VM.

## Scenario

**HELPDESK TICKET #HD-2928 | Priority: CRITICAL | Status: ASSIGNED TO YOU**

---

**From:** cloudadmin@contoso.local  
**Subject:** CRITICAL - Cannot access Azure Portal for cloud management  
**Time Reported:** Wednesday, 3:45 PM

---

**Issue Description:**

*"I'm completely unable to access the Azure Portal at portal.azure.com! This is a critical issue because I need to manage our company's Azure resources, and I have several urgent tasks that need to be completed today.*

*When I try to open https://portal.azure.com in my browser, the page just times out and never loads. I've tried multiple browsers (Edge, Chrome, Firefox) and they all have the same problem. The browser just sits there loading forever and eventually shows a 'can't reach this page' error.*

*The strange thing is that I can access other websites perfectly fine - Google, Microsoft.com, our internal sites, everything else works. It's ONLY portal.azure.com that won't load. I can even access other Microsoft services like Office 365 and Teams without any issues.*

*I've tried:*
*- Clearing browser cache and cookies*
*- Restarting my browser*
*- Trying different browsers*
*- Restarting my computer*
*- Checking my internet connection (other sites work fine)*

*Nothing helps! My colleague can access the Azure Portal from their computer without any problems, so I know it's not a company-wide block or network issue.*

*This is extremely urgent - I need to deploy a critical application update to Azure, check on some VMs that might be having issues, and review our cloud spending. Every minute I can't access the portal is costing us money and potentially affecting our services!\"*

---

**Your Mission:**

As the IT support specialist at Contoso Corporation, you're dealing with a selective website access issue where only portal.azure.com is blocked. You must:

- Investigate why portal.azure.com is unreachable while other websites work
- Diagnose whether this is a DNS issue, firewall issue, proxy issue, or local configuration problem
- Identify the root cause preventing access to the Azure Portal
- Validate that the Azure Portal becomes fully accessible

**Important:** This is NOT a network-wide issue since other websites work fine. The problem is specific to portal.azure.com, suggesting a local configuration issue rather than a connectivity problem.

## Lab Environment

When the lab is launched, CloudLabs automatically provisions:

- **Client VM**

   - Domain-joined to CONTOSO
   
   - Cannot access portal.azure.com
   
   - Can access other websites normally
   
   - Used for problem verification and validation
   
   - **Note:** The Windows hosts file has been modified to block portal.azure.com

- **Technician VM**

   - Domain-joined to CONTOSO
   
   - Has normal internet access including Azure Portal
   
   - Used for investigation and comparison

- **DC01 (Domain Controller)**

   - IP Address: 192.168.100.11
   
   - Provides DNS services
   
   - DNS is working correctly

## Challenge Workflow

Learners must complete the following tasks using the CloudLabs environment.
No commands or step-by-step instructions are provided.

## Task 1: Verify and Diagnose the Problem

Using the Client VM:

- Confirm that portal.azure.com is unreachable in a web browser

- Verify that other websites (www.google.com, www.microsoft.com) are accessible

- Test DNS resolution for portal.azure.com

- Identify any discrepancies in DNS resolution

- Check for local DNS overrides or configuration issues

## Task 2: Investigate Local Configuration

Using the Client VM:

- Examine the Windows hosts file (C:\Windows\System32\drivers\etc\hosts)

- Check for any entries that might be blocking or redirecting portal.azure.com

- Review browser proxy settings

- Check for any local firewall rules blocking specific domains

- Compare DNS resolution results with the Technician VM

## Task 3: Remediate the Configuration Issue

On the Client VM:

- Remove or correct any malicious or incorrect entries in the hosts file

- Ensure portal.azure.com resolves to the correct IP address

- Clear DNS cache to remove any cached incorrect resolutions

- Clear browser cache if needed

## Task 4: Validate Azure Portal Access

From the Client VM:

- Test DNS resolution for portal.azure.com (should resolve to Microsoft's IPs)

- Verify no local overrides are affecting portal.azure.com

- Open a web browser and navigate to https://portal.azure.com

- Confirm the Azure Portal login page loads successfully

- Test access to related Azure domains (login.microsoftonline.com, management.azure.com)

## Validation 4: Resolving Azure Portal Access Failure

<validation step="bd58855c-b8b7-4d93-9296-bf537eb65ee3" />

## Congratulations! You have successfully completed all the challenges.
