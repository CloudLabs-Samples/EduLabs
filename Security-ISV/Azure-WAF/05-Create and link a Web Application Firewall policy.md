# 04: Create and link a Web Application Firewall policy

## Overview

In this task, you will be creating a Web Application Firewall policy with the associated Application Gateway. All of the WAF customizations and settings are in a separate object, called a WAF Policy.

1. On Azure Portal click on **Show menu** from the top left corner and select **Create a resource**.

     ![](../images/waf501.png)

1. Search for WAF, select **Web Application Firewall**, then select Create.

1. On the upper left side of the portal, select Create a resource. Search for WAF, select **Web Application Firewall**, then select Create.

     ![](../images/waf037.png)

1. On Create a WAF policy page, Basics tab, provide the following information :

    * Policy for : **Regional WAF**
    
    * Subscription : Select the default subscription

    * Resource Group : **Waf-<inject key="DeploymentID"></inject>**

    * Policy Name : **Policy<inject key="DeploymentID"></inject>**

1. Select **Next : Managed rules**.

     ![](../images/waf063.png)

1. Accept the defaults and then select **Next : Policy settings**.
    
     ![](../images/waf039.png)

1. Accept the defaults, and then select **Next : Custom rules**.

     ![](../images/waf040.png)

1. Now select **Next : Association**.

      ![](../images/waf041.png)

1. Under **Association**, click on **+Add Association** and select **application gateway**.

      ![](../images/waf043.png)

1. On the **Associate an application gateway** page, select the gateway with the **gatewayDID** and click on **Add**.

     ![](../images/waf061.png)

1. On the **Association** page, review the settings and select Review + create and then select Create.

     ![](../images/waf062.png)

# Summary

In this task you created and linked a Web Application Firewall policy

Click on **Next** to continue to the next section of the lab.
