# Step 3 - IPSec Tunnel Configuration - pfSense Firewall

Open the **pfSense** login page using Edge or Chrome `http://10.1.21.10`. Note the link is **HTTP!**

**Username:** admin
**Password:** nsappliance

Follow this procedure to set up redundant Netskope IPSec tunnels using the WAN1 interface.

**Modify the settings below to match your lab environment.**

## 3.1. IPSec Tunnels - Advanced Settings

1\. **VPN** > **IPSec** > **Advanced Settings**

### Advanced IPSec Settings
- **IPSec Filter Mode:** Filter IPSec VTI and Transport on assigned interfaces, block all tunnel mode traffic.

![IPSec-Advanced-Settings.png](https://docs-api.cloudlabs.ai/repos/raw.githubusercontent.com/CloudLabs-AI/Lab-Guide/main/15032oq7EMg8e/images/IPSec-Advanced-Settings.png)

2\. **Save**

## 3.2. IPSec Tunnels - Phase 1 - Data Plane 1

1\. **VPN** > **IPSec**
2\. **+Add P1**

### General Information
- **Description:** IPSec tunnel from WAN1 to SYD1 Netskope

### IKE Endpoint Configuration
- **Key Exchange Version:** IKEv2
- **Internet Protocol:** IPv4
- **Interface:** WAN1
- **Remote Gateway:** `Primary Netskope POP` e.g. SYD1 (163.116.192.38)

**Note**: Make sure you use the **IPSec Gateway** IP address for the **Primary Netskope POP** you selected in **Step 1.2**. It should be in the **POPS Info** you copied.

![IKE-20260831.png](https://docs-api.cloudlabs.ai/repos/raw.githubusercontent.com/CloudLabs-AI/Lab-Guide/main/15032oq7EMg8e/images/IKE-20260831.png)

### Phase 1 Proposal (Authentication)
- **Authentication Method:** Mutual PSK
- **My identifier:** User fully qualified domain name / Email
    - `pfsense@<`tenant`>.goskope.com` (use your tenant name)
- **Peer identifier:** Peer IP address
- **Pre-Shared Key:** `MaKe_Y0Ur_PaSsW0Rd_Un!qUe`

![P1-Auth-20260831.png](https://docs-api.cloudlabs.ai/repos/raw.githubusercontent.com/CloudLabs-AI/Lab-Guide/main/15032oq7EMg8e/images/P1-Auth-20260831.png)

### Phase 1 Proposal (Encryption Algorithm)

- **Encryption Algorithm:** 

    - Algorithm: AES

    - Key Length: 256

    - Hash: SHA256

    - DH Group: 14 (2048 bit)

  ![P1-Encryption.png](https://docs-api.cloudlabs.ai/repos/raw.githubusercontent.com/CloudLabs-AI/Lab-Guide/main/15032oq7EMg8e/images/P1-Encryption.png)

### Expiration and Replacement

- **Life Time:** 86400

- **Rekey Time:** 85800 (10 minutes less than the Life Time is recommended)
 
![Lifetime-Rekey.png](https://docs-api.cloudlabs.ai/repos/raw.githubusercontent.com/CloudLabs-AI/Lab-Guide/main/15032oq7EMg8e/images/Lifetime-Rekey.png)
 
3\. **Save**

## 3.3. IPSec Tunnels - Phase 2 - Data Plane 1

1\. **+Show Phase 2 Entries (0)**

2\. **+Add P2**

![P2-DP1-20260831.png](https://docs-api.cloudlabs.ai/repos/raw.githubusercontent.com/CloudLabs-AI/Lab-Guide/main/15032oq7EMg8e/images/P2-DP1-20260831.png)

### General Information

- **Mode:** Routed (VTI)

![P2-General-Info-20260831.png](https://docs-api.cloudlabs.ai/repos/raw.githubusercontent.com/CloudLabs-AI/Lab-Guide/main/15032oq7EMg8e/images/P2-General-Info-20260831.png)

### Networks

- **Local Network:**

    - Type: Address

    - Address: 10.255.3.1

- **Remote Network:**

    - Type: Address

    - Address: 10.255.3.2

![P2-Networks.png](https://docs-api.cloudlabs.ai/repos/raw.githubusercontent.com/CloudLabs-AI/Lab-Guide/main/15032oq7EMg8e/images/P2-Networks.png)

### Phase 2 Proposal (SA/Key Exchange)

- **Protocol:** ESP

- **Encryption Algorithms:**

    - AES128-GCM / Auto

    - AES192-GCM / Auto

    - AES256-GCM / Auto

- **PFS key group:** 14

![P2-Proposal.png](https://docs-api.cloudlabs.ai/repos/raw.githubusercontent.com/CloudLabs-AI/Lab-Guide/main/15032oq7EMg8e/images/P2-Proposal.png)

### Expiration and Replacement

- **Life Time:** 7200

- **Rekey Time:** 6600 (10 minutes less than the Life Time is recommended)

![P2-Expiry-20260831.png](https://docs-api.cloudlabs.ai/repos/raw.githubusercontent.com/CloudLabs-AI/Lab-Guide/main/15032oq7EMg8e/images/P2-Expiry-20260831.png)

### Keep Alive

- **Keep Alive:** Enabled

![P2-KeepAlive.png](https://docs-api.cloudlabs.ai/repos/raw.githubusercontent.com/CloudLabs-AI/Lab-Guide/main/15032oq7EMg8e/images/P2-KeepAlive.png)

3\. **Save**

4\. **Apply Changes**

**Repeat for the 2nd IPSec Tunnel**

## 3.4. IPSec Tunnels - Phase 1 - Data Plane 2

1\. **VPN** > **IPSec**

2\. **+Add P1**

### General Information

- **Description:** IPSec tunnel from WAN1 to MEL1 Netskope

### IKE Endpoint Configuration

- **Key Exchange Version:** IKEv2

- **Internet Protocol:** IPv4

- **Interface:** WAN1

- **Remote Gateway:** `Failover Netskope POP` e.g. MEL1 (163.116.198.38)

**Note**: Make sure you use the **IPSec Gateway** IP address for the **Failover Netskope POP** you selected in **Step 1.2**. It should be in the **POPS Info** you copied.

### Phase 1 Proposal (Authentication)

- **Authentication Method:** Mutual PSK

- **My identifier:** User fully qualified domain name / Email

    - `pfsense@<`tenant`>.goskope.com` (use your tenant name)

- **Peer identifier:** Peer IP address

- **Pre-Shared Key:** `MaKe_Y0Ur_PaSsW0Rd_Un!qUe`

### Phase 1 Proposal (Encryption Algorithm)

- **Encryption Algorithm:** 

    - Algorithm: AES

    - Key Length: 256

    - Hash: SHA256

    - DH Group: 14 (2048 bit)

### Expiration and Replacement

- **Life Time:** 86400

- **Rekey Time:** 85800 (10 minutes less than the Life Time is recommended)

3\. **Save**

## 3.5. IPSec Tunnels - Phase 2 - Data Plane 2

1\. **+Show Phase 2 Entries (0)** for the 2nd tunnel

2\. **+Add P2**

### General Information
- **Mode:** Routed (VTI)

### Networks

- **Local Network:**

    - Type: Address

    - Address: 10.255.3.5

- **Remote Network:**

    - Type: Address

    - Address: 10.255.3.6

### Phase 2 Proposal (SA/Key Exchange)

- **Protocol:** ESP

- **Encryption Algorithms:**

    - AES128-GCM / Auto

    - AES192-GCM / Auto

    - AES256-GCM / Auto

- **PFS key group:** 14

### Expiration and Replacement

- **Life Time:** 7200

- **Rekey Time:** 6600 (10 minutes less than the Life Time is recommended)

### Keep Alive

- **Keep Alive:** Enabled

3\. **Save**

4\. **Apply Changes**

You should now have two (2) IPSec Tunnels that will initiate from WAN1 to each DP.

![IPSec-Tunnels-20260831.png](https://docs-api.cloudlabs.ai/repos/raw.githubusercontent.com/CloudLabs-AI/Lab-Guide/main/15032oq7EMg8e/images/IPSec-Tunnels-20260831.png)

## 3.6. IPSec Interface Assignment

1\. **Interfaces** > **Assignments**

2\. Press **+Add** two (2) times.

3\. **Save**

You should now have two (2) new Interfaces: OPT4 & OPT5.

![IPSec-Interface-Assignments-20260831.png](https://docs-api.cloudlabs.ai/repos/raw.githubusercontent.com/CloudLabs-AI/Lab-Guide/main/15032oq7EMg8e/images/IPSec-Interface-Assignments-20260831.png)

## 3.7. Rename and Enable each IPSec Interface

### OPT4
1\. **Interfaces** > OPT4

2\. Check **Enable Interface**

3\. **Description:** WAN1SYD1 (change to align with your configuration)

4\. **MTU:** 1400

5\. **Save**

6\. **Apply Changes**

Your configuration should look similar to the image below.

![WAN1SYD1-20261013.png](https://docs-api.cloudlabs.ai/repos/raw.githubusercontent.com/CloudLabs-AI/Lab-Guide/main/15032oq7EMg8e/images/WAN1SYD1-20261013.png)

### OPT5
1\. **Interfaces** > OPT5

2\. Check **Enable Interface**

3\. **Description:** WAN1MEL1 (change to align with your configuration)

4\. **MTU:** 1400

5\. **Save**

6\. **Apply Changes**
 