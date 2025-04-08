#  Module 1: Introduction to the AWS Console and Global Infrastructure

---

## 🎯 Objective

In this lab, you'll get familiar with the **AWS Management Console** and understand how AWS is distributed across the globe. You'll explore **Regions**, **Availability Zones (AZs)**, and **Edge Locations**, and learn how AWS delivers fast, reliable services to users worldwide.

---

## 🧠 What You Will Learn

By the end of this module, you will be able to:
- Log into the AWS Management Console
- Navigate and change between different AWS Regions
- Find Availability Zones (AZs) in your region
- Understand the role of Edge Locations in content delivery
- Use the AWS Global Infrastructure map to visualize AWS's reach

---

## ⏱️ Estimated Duration

30–40 minutes

---

## 🧪 Lab Steps

---

### ✅ Step 1: Sign in to the AWS Management Console

1. Open your web browser and go to:  
   👉 **https://console.aws.amazon.com/**
2. You'll see a sign-in screen with two options:
   - **Root user** (for the main account owner)
   - **IAM user** (for users under an AWS organization)
3. Enter the correct email or account alias based on your access.
4. Enter your **IAM username** and **password** to log in.

> 💡 **Tip:** If you're unsure whether you're a root or IAM user, check with your instructor or lab administrator.

---

### ✅ Step 2: Locate and Change the AWS Region

1. After logging in, you will land on the AWS **Console Home**.
2. On the **top-right corner**, you’ll see the current **Region name** (e.g., `N. Virginia`, `Mumbai`, `Frankfurt`).
3. Click the Region dropdown to see the list of available **AWS Regions**.
4. Choose **Asia Pacific (Mumbai)** or any region close to you.

> 🌍 Each Region is a separate geographic area with multiple isolated locations called Availability Zones.

---

### ✅ Step 3: Open the EC2 Dashboard and View Availability Zones

1. In the search bar at the top of the Console, type **"EC2"**.
2. Click on **EC2** under **Services**.
3. On the EC2 Dashboard, in the left sidebar, click **Limits** (or "Account attributes" in some versions).
4. Scroll down until you find the **Availability Zones** table.  
   - It will list AZs like `ap-south-1a`, `ap-south-1b`, etc.

> 🧠 These are your **Availability Zones** – isolated data centers within the selected Region.

---

### ✅ Step 4: Understand Edge Locations Using CloudFront

1. In the AWS Console search bar, type **"CloudFront"** and click the result.
2. If you don't have a distribution created, that’s okay — we’re only here to **observe**.
3. On the **left sidebar**, click **Distributions**.
4. Look at the list (or sample data) — CloudFront distributions use **Edge Locations** to cache content close to users.

> 📦 **Edge Locations** are used by services like CloudFront and Route 53 to deliver content with **low latency**.

---

### ✅ Step 5: Explore the AWS Global Infrastructure Map

1. Open a new browser tab and go to:  
   👉 **https://infrastructure.aws**
2. Hover over different parts of the world.
3. Notice the **Regions**, **Availability Zones**, **Local Zones**, and **Wavelength Zones**.
4. Explore:
   - How many AZs exist in your region?
   - Where are most edge locations concentrated?
   - Which regions are upcoming (in gray)?

> 🌐 This site is helpful for understanding how AWS distributes its services for performance, redundancy, and compliance.

---

### ✅ Step 6: Recap What You Learned

Take a few minutes to reflect:
- What’s the difference between a Region and an AZ?
- What’s the purpose of an Edge Location?
- Why is AWS’s global footprint important for your app or users?

📝 **(Optional)**: Write down your thoughts or discuss with your lab partner.

---

## 🧼 Cleanup Instructions

This lab does **not create any resources**, so no cleanup is needed.

---

## 📸 Recommended Screenshots

If your instructor or assignment requires a screenshot:
- Region dropdown in Console
- EC2 AZs list
- CloudFront Distributions page
- AWS Global Infrastructure map

---

## 🎉 Congratulations!

You’ve now completed your first AWS hands-on module. You explored the Console and learned how AWS connects the world with its global infrastructure.

👉 Ready for the next lab? Jump to **Module 2: Deploy a Simple Web Server Using EC2**.
