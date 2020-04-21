.. _clusteraccess:

----------------------
Accessing Your Cluster
----------------------

Clusters used for **Hands on Learning** run within the Hosted POC environment, hosted in the Nutanix PHX and RTP data centers.

In order to access these resources you must be connected by one of the options listed below. Connection to a virtual desktop environment **is not necessary**, but details for connecting to the HPOC through an HTML5 Frame desktop is available for those experiencing issues with the VPN or unable to install VPN software.

.. note::

  Certain labs leverage a Windows VM with pre-installed tools to provide a controlled environment. It is **highly recommended** that you connect to these Windows VMs using the Microsoft Remote Desktop client rather than the VM console launched via Prism. An RDP connection will allow you to copy and paste between your device and the VMs.

Connectivity
...........

- **Username** - Refer to :ref:`clusterassignments`
- **Password** - Refer to :ref:`clusterassignments`

Lab Access Methods
..................

Frame session
+++++++++++++

1. Login to https://frame.nutanix.com/x/labs using your supplied credentials.
2. Accept the **Nutanix Cloud Services Term of Services** by clicking on the **I Accept** button.
3. Double click on the *Desktop* icon to start your Frame Session.
4. This will give you a 6 hour windows for your labs. In the Windows 10 session you should have all tools needed for the labs pre-installed
   
   .. figure:: images/Framesession.png


Parallels VDI
+++++++++++++

1. Login to https://xld-uswest1.nutanix.com (for PHX) or https://xld-useast1.nutanix.com (for RTP) using your supplied credentials
2. Select HTML5 (web browser) OR Install the Parallels Client
3. Select a desktop or application of your choice.

Pulse Secure VPN Client
+++++++++++++++++++++++

1. If client already installed skip to step 5
2. To download the client, login to https://xlv-uswest1.nutanix.com or https://xlv-useast1.nutanix.com using the supplied user credentials
3. Download and install client
4. Logout of the Web UI
5. Open client and ADD a connection with the following details:

  - Type: Policy Secure (UAC) or Connection Server(VPN)
  - Name: X-Labs - PHX
  - Server URL: xlv-uswest1.nutanix.com

  OR

  - Type: Policy Secure (UAC) or Connection Server(VPN)
  - Name: X-Labs - RTP
  - Server URL: xlv-useast1.nutanix.com

6. Once setup, login with the supplied credentials

   
  

