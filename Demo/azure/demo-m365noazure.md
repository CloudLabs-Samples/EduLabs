# Demo : M365 Labs

## Overview
This lab environment includes an M365 tenant with Global admin privileges, and a Microsoft 365 E5 license assigned to the lab user.

## Instructions

1. To get the lab environment details, you can select the **Environment** tab, you can locate the **Environment** tab in the upper right corner.
   
   ![](images/environment-tab.png)

2. You can view the **duration** for the lab evironment from the top right corner

   ![](images/duration.png)

## Accessing Microsoft 365 Admin Center

1. You can directly access the Microsoft 365 Admin Center by navigating to: https://admin.microsoft.com

2. Sign in with your Global admin credentials:

   * **Username/Email**:  <inject key="AzureAdUserEmail"></inject> 
   * **Password**:  <inject key="AzureAdUserPassword"></inject>

Follow these steps to secure your Microsoft Azure account using multi-factor authentication via phone. These steps are applicable **only if you are prompted** to set up additional security information during login.

1. You may be asked to set up the **Microsoft Authenticator**.

1. Click **"I want to set up a different method"** at the bottom of the screen.

   ![Step 2](images/2025-04-03_17-46-15.png)

1. In the popup, select **Phone** from the list.

   ![Step 3](images/2025-04-03_17-46-25.png)

1. Choose your country code (e.g., India +91), enter your mobile number, then select **Receive a code** and click **Next**.

   ![Step 4](images/2025-04-03_17-46-44.png)

1. A 6-digit verification code will be sent to your phone. Enter the code and click **Next**.

    ![Step 5](images/2025-04-03_18-35-37.png)

1. Once verification is complete and your phone number is registered, click **Next** to continue.

    ![Step 5-u](images/verificationcomplete.png)

1. You will see a **Success** message confirming that your MFA method is configured. Click **Done**.

    ![Step 6](images/2025-04-03_18-36-21.png)
   
3. Once logged in, you’ll have access to the M365 Admin Center, where you can manage users, licenses, and other M365 services.

   ![](images/m365.png)





