.. _frameflow_secure_desktops:

---------------------------
Securing Desktops with Flow
---------------------------

Flow application security policies can prevent VMs from communicating with each other while still allowing inbound and outbound access. This is perfect for applications such as web servers, or even desktops, where preventing the spread of VM to VM traffic is critical to stop attacks.

**In this task we will place desktop VMs into an application policy as part of an application tier that restricts VM to VM communication within the tier. The desktops will have normal inbound and outbound access, but traffic between desktops will be blocked.**

Categorizing the Desktop VMs
++++++++++++++++++++++++++++

#. In **Prism Central**, select :fa:`bars` **> Virtual Infrastructure > Categories**.

#. Select the checkbox for **AppType** and click **Actions > Update**.

   .. figure:: images/1.png

#. Click the :fa:`plus-circle` icon beside the last value to add an additional Category value.

#. Specify *Initials*-**FrameDesktops**  as the value name.

   .. figure:: images/2.png

#. Click **Save**.

#. Select the checkbox for **AppTier** and click **Actions > Update**.

#. Click the :fa:`plus-circle` icon beside the last value to add an additional Category value.

#. Specify *Initials*-**Frame-W10NP** value name.

   .. figure:: images/3.png

#. Click **Save**.

   Next we need to ensure all of our Frame desktops are running for testing. We also need to determine which **frame-instance-prod...** VMs in **Prism Central** correspond to your environment.

#. Return to the Frame Admin Portal. Select **Capacity** from the sidebar and increase your **Minimum number of instances** to **3** and click **Save**. This will ensure all 3 VMs are booted once the new image is published.

   .. figure:: images/3g.png

   .. note::

      Depending on your prior configuration, you may need to decrease **Buffer instances** to **0**.

#. Select **Status** from the sidebar and copy the **Machine ID** for your **Sandbox** VM.

   .. figure:: images/3c.png

#. In **Prism Central > Virtual Infrastructure > VMs**, paste the **Machine ID** into the **Name** filter to identify your Sandbox VM.

   .. figure:: images/3d.png

#. Select the VM and click **Actions > Manage Categories**. Copy the **FrameAccountID** value that corresponds to your Frame account. Click **Cancel**

   .. figure:: images/3h.png

#. In **Prism Central > Virtual Infrastructure > VMs**, paste the **FrameAccountID** into the **Category** filter to identify your Frame VMs. Select all of your **frame-instance-prod...** VMs and click **Actions > Manage Categories**.

   .. figure:: images/3i.png

#. Specify **AppType:**\ *Initials*\ **-FrameDesktops** in the search bar.

#. Click the :fa:`plus-circle` icon beside the last value to add **AppTier:**\ *Initials*\ **-Frame-W10NP** and click the **Save**.

   .. figure:: images/3j.png

Creating a Desktop Security Policy
++++++++++++++++++++++++++++++++++

#. In **Prism Central**, select :fa:`bars` **> Policies > Security Policies**.

#. Click **Create Security Policy > Secure Applications (App Policy) > Create**.

#. Fill out the following fields:

   - **Name** - *Initials*-FrameDesktops
   - **Purpose** - Restrict unnecessary traffic between Frame desktops
   - **Secure this app** - AppType: *Initials*-FrameDesktops
   - Do **NOT** select **Filter the app type by category**.

   .. figure:: images/6.png

#. Click **Next**.

#. If prompted, click **OK, Got it!** on the tutorial diagram of the **Create App Security Policy** wizard.

#. To allow for more granular configuration of the security policy, click **Set rules on App Tiers, instead** rather than applying the same rules to all desktop groups.

   .. figure:: images/7.png

#. Click **+ Add Tier**.

#. Select **AppTier:**\ *Initials*-**Frame-W10NP** from the drop down.

#. Repeat Steps 7-8 for **AppTier:Default**.

   .. figure:: images/8.png

   Next you will define the **Inbound** rules, which control which sources you will allow to communicate with your application. In this case we want to allow all inbound traffic.

#. On the left side of the policy edit page, change **Inbound** from **Whitelist Only** to **Allow All**

   .. figure:: images/9.png

#. Repeat the previous step to also change **Outbound** to **Allow All**.

#. To define intra-desktop communication, click **Set Rules within App**.

   .. figure:: images/10.png

#. Click **AppTier:**\ *Initials*\ **-Frame-W10NP** and select **No** to prevent communication between VMs in this tier. This will block desktops from communicating with each other.

   .. figure:: images/11.png

#. While **AppTier:**\ *Initials*-**PD** is still selected, click the :fa:`plus-circle` icon to the right of **AppTier:Default** to create a tier to tier rule.

#. Fill out the following fields to allow communication on TCP port **7680** between the Frame desktops and VMs in the **Default** tiers to allow peer-to-peer Windows updates:

   - **Protocol** - TCP
   - **Ports** - 7680

   .. figure:: images/12.png

#. Click **Save**.

#. Click **Next** to review the security policy.

#. Click **Save and Monitor** to save the policy.

Verifying Desktop Security
++++++++++++++++++++++++++

#. Return to the Frame Admin Portal. Select **Status** from the sidebar and note the **Private IP** addresses of your desktop VMs.

   .. figure:: images/12a.png

#. Click **Launchpad** and log into your Frame **Desktop**.

#. Within the desktop, open a **Command Prompt** and run ``ping -t ANOTHER-FRAME-VM-IP`` to verify connectivity between the persistent desktops.

   .. figure:: images/13.png

   Can you ping between the desktops now? Why?

#. In **Prism Central > Policies > Security Policies**, select the *Initials*\ **-FrameDesktops** policy.

#. Click **Actions > Apply**.

   .. figure:: images/14.png

#. Type **APPLY** and click **OK** to apply the Desktop security policy.

   What happens to the continuous ping between the desktops?

Takeaways
+++++++++

- Application policies can be used to protect virtual infrastructure like desktops, as well as traditional applications.
- In this exercise you utilized Flow to block traffic between desktops, a simple policy that can be implemented to prevent unneeded access between desktop VMs and assist with preventing the spread of malware on a network.
- Monitor mode is used to visualize traffic to the defined application, but Apply mode enforces the policy.
