.. _clusterinfoprod:

--------------------
Your Cluster Details
--------------------

.. _clusterassignments:

Cluster Assignments
+++++++++++++++++++

Refer to the link below to look up your assigned cluster for the event. If your cluster details are not found, first verify you have entered the same e-mail address used to register for GTS (and not an alias), otherwise contact **te-emea@nutanix.com** and request to be added.

`Click here to search for your cluster details. <http://10.42.7.121:3000/>`_

.. note::

   .. raw:: html

     <strong><font color="red">If you are using the Google Chrome browser and macOS 10.5 Catalina, you may encounter issues with self-signed certifications in Prism and be unable to access the cluster. See below for available workarounds.</font></strong>

  **Workaround 1** - Use Firefox and accept the self-signed certificate.

  **Workaround 2** - In Chrome, type *thisisunsafe* in your browser and it will trust the page for the remainder of the browser session.

.. _stagingdetails:

Cluster Staging Details
+++++++++++++++++++++++

Each attendee will have access to a a **SHARED** AOS 5.11.2.3 (AHV 20170830.337) cluster, staged as follows:

.. note::

  Refer to :ref:`clusterassignments` for the *XX* and *YY* octets for your cluster and replace where appropriate.

  For example, if your **Cluster/Prism Element Virtual IP** is 10.42.10.37, substitute *42* for *XX* and *10* for *YY* below.

Virtual Machines
................

The following VMs/Services have already been provisioned to each cluster:

.. list-table::
   :widths: 25 25 50
   :header-rows: 1

   * - VM Name
     - IP Address
     - Description
   * - **Prism Central**
     - 10.XX.YY.39
     - Nutanix Prism Central 5.11.2
   * - **AutoAD**
     - 10.XX.YY.41
     - ntnxlab.local Domain Controller
   * - **GTSPrismOpsLabUtilityServer**
     - 10.XX.YY.42
     - Shared VM used in Prism Pro labs
   * - **BootcampFS**
     - (DHCP) bootcampfs.ntnxlab.local
     - Single-node Nutanix Files cluster
   * - **DDC**
     - 10.XX.YY.45
     - Shared Citrix Delivery Controller/StoreFront
   * - **Era**
     - 10.XX.YY.22
     - Shared Era

Images
......

All disk images required to complete the labs have been uploaded to the Image Service for each cluster.

Credentials
...........

The lab guides will explicitly share any unique credentials, the table below contains common credentials used throughout the labs:

.. list-table::
  :widths: 33 33 33
  :header-rows: 1

  * - Name
    - Username
    - Password
  * - **Prism Element**
    - admin
    - *Will Be Provided*
  * - **Prism Central**
    - admin
    - *Will Be Provided*
  * - **Controller VMs**
    - nutanix
    - *Will Be Provided*
  * - **Prism Central VM**
    - admin
    - *Will Be Provided*
  * - **NTNXLAB Domain**
    - NTNXLAB\\Administrator
    - nutanix/4u

Networks
........

At the beginning of each lab track, you will be instructed to create a user specific VLAN, detailed in the :ref:`clusterassignments` spreadsheet. This network will be used for the majority of exercises. The following, additional virtual networks have been pre-configured for each cluster:

.. list-table::
   :widths: 33 33 33
   :header-rows: 1

   * -
     - **Primary** Network
     - **Secondary** Network
   * - **IPAM**
     - Enabled
     - Enabled
   * - **DHCP Pool**
     - 10.XX.YY.50 - 124
     - 10.XX.YY.132 - 229
   * - **Default Gateway**
     - 10.XX.YY.1
     - 10.XX.YY.129
   * - **Netmask**
     - 255.255.255.128
     - 255.255.255.128
   * - **DNS**
     - 10.XX.YY.40 (DC VM)
     - 10.XX.YY.40 (DC VM)

.. raw:: html

   <strong><font color="red">Unless instructed otherwise in a lab, please use your user specific VLAN for VM deployments. If instructed to use the Primary or Secondary networks for an exercise, be sure to clean up unneeded VMs afterwards (or remove their NICs) to ensure IP space availability. With ~6 users sharing each cluster, IP space and memory are the two most contended resources.</font></strong>
