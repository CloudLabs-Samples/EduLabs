# Module 2: Install Terraform

In this module, you will download and install Terraform manually on a Windows virtual machine( lab vm) provided to you

1. Within the virtual machine, open a new tab in a browser and navigate to the below URL to download the **Terraform** zip file

```
   https://www.terraform.io/downloads.html
```

2. On the **Download Terraform** page, under **Windows** tab, click on **Amd64** to download the file.

     ![IMG1](https://github.com/CloudLabs-Samples/EduLabs/blob/main/Hashicorp/Azure/Images/Img1.png?raw=true)

3. After downloading the **Terraform** zip-file, minimize the browser window and open **File Explorer**.

4. Navigate to `C:\ Drive` and create a new folder called **Terraform** and make sure to extract the zip-file to this folder.

     ![IMG2](https://github.com/CloudLabs-Samples/EduLabs/blob/main/Hashicorp/Azure/Images/Img2.png?raw=true)

     >**Info:** In the next step, you will ensure the Terraform binary is on your path.

5. Search for **Environment variables** from the Windows search bar and select it.

     ![IMG3](https://github.com/CloudLabs-Samples/EduLabs/blob/main/Hashicorp/Azure/Images/Img3.png?raw=true)

6. On **System Properties**, click on **Environment Variables**.

     ![IMG4](https://github.com/CloudLabs-Samples/EduLabs/blob/main/Hashicorp/Azure/Images/Img4.png?raw=true)

7. Now under **System Variables**, select **Path(1)** and click on **Edit(2)**.

     ![IMG5](https://github.com/CloudLabs-Samples/EduLabs/blob/main/Hashicorp/Azure/Images/Img5.png?raw=true)

8. Select **New(1)**, then add path **C:\Terraform(2)** and click on **Ok(3)** to save it.

     ![IMG6](https://github.com/CloudLabs-Samples/EduLabs/blob/main/Hashicorp/Azure/Images/Img6.png?raw=true)

9. Once you have done that, close the **System Properties** tab, and navigate back to the zip-file which you downloaded earlier, right click on the zip-file and select **Extract All**.

     ![IMG7](https://github.com/CloudLabs-Samples/EduLabs/blob/main/Hashicorp/Azure/Images/Img7.png?raw=true)

10. You would need to browse the location to where the files will be extracted to, click on **Browse**, navigate to `C:\Terraform` the folder you created earlier, and click on **Extract** to proceed.

     ![IMG8](https://github.com/CloudLabs-Samples/EduLabs/blob/main/Hashicorp/Azure/Images/Img8.png?raw=true)

## Verify the installation

1. After successfully extracting the zip-files, you will be redirected to the `PATH` where Terraform files have been extracted. Close the window, search for **Windows PowerShell** from the search bar and select it.

     ![IMG9](https://github.com/CloudLabs-Samples/EduLabs/blob/main/Hashicorp/Azure/Images/Img9.png?raw=true)

2. We verify the installation worked by listing Terraform's available subcommands.

   ```
      terraform -help
   ```

     ![IMG10](https://github.com/CloudLabs-Samples/EduLabs/blob/main/Hashicorp/Azure/Images/Img10.png?raw=true)

     > Add any subcommand to `terraform -help` to learn more about what it does and available options.

   ```
      terraform -help plan
   ```
   
## Troubleshoot

If you get an error that `terraform` could not be found, your `PATH` environment variable was not set up properly. Please go back and ensure that your `PATH` variable contains the directory where Terraform was installed.

## Summary

In this module, you learnt how to:

   - Install Terraform.
   - Verify if Terraform is installed correctly.
