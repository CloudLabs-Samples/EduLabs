# Task 7: Verify the static content on web server

## Overview

In this task, you will see that link state for the interfaces will be **OFF** and the static content of the webserver page will be showing an error at this moment. You will resolve that error and can able to view the static content of the web server and also verify the status of the link state for the interfaces will be **UP**

1. On the **PaloAlto VMseries Firewall** dashboard page, select the **Network** tab and select **Interfaces** and verify the **Link State** is **OFF** for the interface type **Layer 3**.

    ![](../images/Palo016.png)

1. Navigate to the **Environment Details** tab, copy the URL of **WebServer URL** and open it in the browser. You can verify the page showing error that is attached below.

    ![](../images/image023.png)

1. In the Firewall dashboard, on the top right corner, click on **Commit**.

    ![](../images/Palo017.png)

1. If a pop-up appears, click on **Commit** and wait till the process completes. On the commit status page, verify the status as **Completed** and result should be **Successful**.

    ![](../images/Palo018.png)

    ![](../images/Palo019.png)

1. Now on the **PaloAlto VMseries Firewall** dashboard, navigate to the **Network** tab and select the **Interfaces** and verify the **Link Status** is **UP**. The Interfaces should turn into the **Green** color.

    ![](../images/Palo020.png)

1. To verify the static content of the webserver. Navigate to the **Environment Details** tab and copy the URL of **WebServerURL**: <inject key="WebServerURL"></inject> and open it in the new browser.

   ![](../images/image017.png)

1. To verify the traffic, click on the **Monitor** tab and then select **Traffic**. You can view the related **Traffic**

   ![](../images/Palo021.png)

1. Navigate to the **Dashbord** and you can see the data for **Config Logs** and **System Logs**.

    ![](../images/Palo022.png)

1. On the **PaloAlto VMseries Firewall** dashboard Page, Click on the ACC tab to view the data.

    ![](../images/Palo023.png)

1. By clicking on the arrow towards the right of the filter, which will force all other widgets to be updated based on the context.

    ![](../images/Palo024.png)
    
# Summary
In this task you have verified the static content of the web server and the status of the link state for the interfaces will be UP

# Congratulations, you have successfully completed the lab
