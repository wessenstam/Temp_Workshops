.. _framegettingstarted:

----------------------
Getting Started
----------------------

Welcome to the End User Computing lab track featuring Xi Frame. This track is meant to provide you with first hand experience in why Nutanix is an ideal platform for VDI workloads, and can deliver a fully integrated experience with our cloud-hosted broker, Xi Frame. In addition to the benefits than Nutanix HCI brings to any virtual desktop deployment, such as linear scalability and consistent performance, Nutanix brings additional benefits that you'll explore through labs:

- Native tools for migrating existing desktop images from ESXi
- Integration with AHV to provide a no-cost, easy to manage platform for running on-premises virtual desktops
- Fast desktop provisioning, including rolling out image updates to large pools of desktops
- Native file services with Nutanix Files to deliver user data, profiles, and User Personalization Layers
- Native microsegmentation with Nutanix Flow to secure a virtual desktop environment
- Rich monitoring and automation capabilities with Prism Pro

If you have not previously completed the **Private Cloud** lab track, follow the quick instructions below to provision your user VLAN and Windows Tools VM that will be used throughout this lab track.

Configuring your User VLAN
++++++++++++++++++++++++++

Typically, Hosted POC clusters provide 2x /25 VLANs. In order to provide adequate IP space and support lab requirements for Global Tech Summit, each cluster has been assigned an additional 8x /27 VLANs. The following instructions will walk you through configuring the VLAN you have been individually assigned, and should be used for the remaining labs in this track.

   .. note:: A /27 VLAN provides 32 IP addresses, 5 of which are reserved. You will therefore need to be conscious of cleaning up unneeded VMs to avoid running out of IP space.

#. Log into **Prism Central** using the following credentials:

   - **User Name** - admin
   - **Password** - emeaX2020!

#. Select :fa:`bars` **> Virtual Infrastructure > Subnets**.

#. Click **Network Config**, select *Your Assigned Cluster*, and click **OK**.

#. Click **+ Create Network** and fill out the following fields, using the **User** specific network details in :ref:`clusterassignments`:

   - **Name** - *Refer to*  :ref:`clusterassignments`
   - **VLAN ID** - *Refer to*  :ref:`clusterassignments`
   - Select **Enable IP Address Management**
   - **Network IP Address / Prefix Length** - *Refer to*  :ref:`clusterassignments`
   - **Gateway IP Address** - *Refer to*  :ref:`clusterassignments`
   - **Domain Name Servers** - *Refer to*  :ref:`clusterassignments`
   - **Domain Search** - ntnxlab.local
   - **Domain Name** - ntnxlab
   - Select **+ Create Pool**
   - **Start Address** - *Refer to*  :ref:`clusterassignments`
   - **End Address** - *Refer to*  :ref:`clusterassignments`
   - Click **Submit**

   .. figure:: images/1.png

#. Click **Save**.
