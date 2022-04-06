# Task 3 : Create and link a Web Application Firewall policy

## Overview

In this task, you will be creating a Web Application Firewall policy with the associated  Application Gateway

1. On the upper left side of the portal, select Create a resource. Search for WAF, select **Web Application Firewall**, then select Create.

     ![](../images/waf037.png)

1. On Create a WAF policy page, Basics tab, provide the following information :

    * Policy for : **Regional WAF**
    
    * Subscription : Select the default subscription

    * Resource Group : **Waf-DID**

    * Policy Name : **PolicyDID**

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

# Proceeed to Task 4 : Test the application gateway
