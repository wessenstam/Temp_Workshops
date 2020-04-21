.. _mssqldeploy:

-------------------------
Deploying MS SQL with Era
-------------------------

Traditional database VM deployment over resembles the diagram below. The process generally starts with a IT ticket for a database (from Dev, Test, QA, Analytics, etc.). Next one or more teams will need to deploy the storage resources and VM(s) required. Once infrastructure is ready, a DBA needs to provision and configure database software. Once provisioned, any best practices and data protection/backup policies need to be applied. Finally the database can be handed over to the end user. That's a lot of handoffs, and the potential for a lot of friction.

.. figure:: images/0.png

Whereas with a Nutanix cluster and Era, provisioning and protecting a database should take you no longer than it took to read this intro - assuming you did. Seriously the first person to walk up to Matt and mention this sentence is getting a hug. Unless you don't want a hug, maybe a high five? Anyways...

**In this lab you will manually deploy a Microsoft SQL Server VM, using a script to apply best practices. This VM will act as a master image to create a profile for deploying additional SQL VMs using Era.**

Manual VM Deployment
++++++++++++++++++++

#. In **Prism Central**, select :fa:`bars` **> Virtual Infrastructure > VMs**.

   .. figure:: images/1.png

#. Click **Create VM**.

#. Select your assigned cluster and click **OK**.

#. Fill out the following fields:

   - **Name** - *Initials*-MSSQL
   - **Description** - (Optional) Description for your VM.
   - **vCPU(s)** - 2
   - **Number of Cores per vCPU** - 1
   - **Memory** - 4 GiB

   - Select **+ Add New Disk**
      - **Type** - DISK
      - **Operation** - Clone from Image Service
      - **Image** - MSSQL-2016-VM.qcow2
      - Select **Add**

   - Select **Add New NIC**
      - **VLAN Name** - *Assigned User VLAN*
      - Select **Add**

#. Click **Save** to create the VM.

#. Select your VM and click **Actions > Power On**.

#. Once powered on, click **Actions > Launch Console** and complete Windows Server setup:

   - Click **Next**
   - **Accept** the licensing agreement
   - Enter **nutanix/4u** as the Administrator password and click **Finish**

#. Log in to the VM using the Administrator password you configured.

#. Disable Windows Firewall for all. **Do NOT modify the default keyboard mapping.**

#. Launch **File Explorer** and note the current, single disk configuration.

   .. figure:: images/2.png

   .. note::

      Best practices for database VMs involve spreading the OS, SQL binaries, databases, TempDB, and logs across separate disks in order to maximize performance. On non-AHV hypervisors, these disks should be properly spread across multiple disk controllers, as shown in the diagram below.

      .. figure:: images/2b.png

      For complete details for tuning SQL Server on Nutanix (including guidance around NUMA, hyperthreading, SQL Server configuration settings, and more), see the `Nutanix Microsoft SQL Server Best Practices Guide <https://portal.nutanix.com/#/page/solutions/details?targetId=BP-2015-Microsoft-SQL-Server:BP-2015-Microsoft-SQL-Server>`_.

#. From the desktop, launch the **01 - Rename Server.ps1** PowerShell script shortcut and fill out the following fields:

   - **Enter the Nutanix cluster IP** - *Assigned Nutanix Cluster IP*
   - **Enter the Nutanix user name for...** - admin
   - **Enter the Nutanix password for "admin"** - emeaX2020!

   The script will validate the VM name does not exceed 15 characters and then rename the server to match the VM name.

#. Once VM has rebooted, log in and launch the **02 - Complete Build.ps1** Powershell script shortcut. Fill out the following fields:

   - **Enter the Nutanix cluster IP** - *Assigned Nutanix Cluster IP*
   - **Enter the Nutanix user name for...** - admin
   - **Enter the Nutanix password for "admin"** - emeaX2020!
   - **Enter the Nutanix container name** - Default

   .. note::

      All fields in the above script are case sensitive.

   This script will setup and create disk drives according to best practices place SQL data files on those drives. The SQL Systems File is placed on the D:\ drive and data and logs files are placed on separate drives.

#. Once VM has rebooted, verify the new disk configuration in **Prism** and **File Explorer**

   .. figure:: images/3.png

   .. figure:: images/4.png

#. Log in to your *Initials*\ **-MSSQL** VM and launch SQL Server Management Studio from the desktop.

#. Connect using **Windows Authentication** and verify the database server is available, with only system databases provisioned.

   .. figure:: images/5.png

   Congratulations, you now have a functioning SQL Server VM. While this process could be further automated through ``acli``, Calm, or REST API calls orchestrated by a third party tool, provisioning only solves a Day 1 problem for databases, and does little to address storage sprawl, cloning, or patch management.

Exploring Era Resources
+++++++++++++++++++++++

Era is distributed as a virtual appliance that can be installed on either AHV or ESXi. For the purposes of conserving memory resources, a shared Era server has already been deployed on your cluster.

   .. note::

      If you're interested, instructions for the brief installation of the Era appliance can be found `here <https://portal.nutanix.com/#/page/docs/details?targetId=Nutanix-Era-User-Guide-v12:era-era-installing-on-ahv-t.html>`_.

#. In **Prism Central > VMs > List**, identify the IP address assigned to the **EraServer-\*** VM using the **IP Addresses** column.

#. Open \https://*ERA-VM-IP:8443*/ in a new browser tab.

#. Login using the following credentials:

   - **Username** - admin
   - **Password** - nutanix/4u

#. From the **Dashboard** dropdown, select **Administration**.

#. Under **Cluster Details**, note that Era has already been configured for your assigned cluster.

   .. figure:: images/6.png

#. Select **Era Resources** from the left-hand menu.

#. Under **VLANs Available for Network Profiles**, click **Add**. Select your *User* VLAN and click **Add**.

   .. figure:: images/7.png

#. From the dropdown menu, select **SLAs**.

   Era has five built-in SLAs (Gold, Silver, Bronze, Zero, and Brass). SLAs control however the database server is backed up. This can with a combination of Continuous Protection, Daily, Weekly Monthly and Quarterly protection intervals.

#. From the dropdown menu, select **Profiles**.

   Profiles pre-define resources and configurations, making it simple to consistently provision environments and reduce configuration sprawl. For example, Compute Profiles specifiy the size of the database server, including details such as vCPUs, cores per vCPU, and memory.

#. Under **Network**, click **+ Create**.

   .. figure:: images/8.png

#. Fill out the following fields and click **Create**:

   - **Engine** - Microsoft SQL Server
   - **Name** - *Assigned User VLAN*-MSSQL-NETWORK
   - **Public Service VLAN** - *Assigned User VLAN*

   .. figure:: images/9.png

#. Click **+ Create** again and fill out the following fields:

   - **Engine** - Oracle
   - **Type** - Single Instance
   - **Name** - *Assigned User VLAN*-ORACLE-NETWORK
   - **Public Service VLAN** - *Assigned User VLAN*

#. Click **Create** to finish creating your Oracle network profile.

   .. figure:: images/10.png

Registering Your MSSQL VM
+++++++++++++++++++++++++

Registering a database server with Era allows you to deploy databases to that resource, or to use that resource as the basis for a Software Profile.

You must meet the following requirements before you register a SQL Server database with Era:

- A local user account or a domain user account with administrator privileges on the database server must be provided.
- Windows account or the SQL login account provided must be a member of sysadmin role.
- SQL Server instance must be running.
- Database files must not exist in C:\ Drive.
- Database must be in an online state.
- Windows remote management (WinRM) must be enabled

.. note::

   Your *XYZ*\ **-MSSQL** VM meets all of these criteria.

#. In **Era**, select **Database Servers** from the dropdown menu and **List** from the lefthand menu.

   .. figure:: images/11.png

#. Click **+ Register** and fill out the following fields:

   - **Engine** - Microsoft SQL Server
   - **IP Address or Name of VM** - *Initials*\ -MSSQL
   - **Windows Administrator Name** - Administrator
   - **Windows Administrator Password** - nutanix/4u
   - **Instance** - MSSQLSERVER (This should auto-populate after providing credentials)
   - **Connect to SQL Server Admin** - Windows Admin User
   - **User Name** - Administrator

   .. note::

      If **Instance** does not automatically populate, disable the Windows Firewall in your *XYZ*\ **-MSSQL** VM.

   .. figure:: images/12.png

   .. note::

    You can click **API Equivalent** for many operations in Era to enter an interactive wizard providing JSON payload based data you've input or selected within the UI, and examples of the API call in multiple languages (cURL, Python, Golang, Javascript, and Powershell).

    .. figure:: images/17.png

#. Click **Register** to begin ingesting the Database Server into Era.

#. Select **Operations** from the dropdown menu to monitor the registration. This process should take approximately 5 minutes.

   .. figure:: images/13.png

   .. note::

      It is also possible to register existing databases on any server, which will also register the database server it is on.

Creating A Software Profile
+++++++++++++++++++++++++++

Before additional SQL Server VMs can be provisioned, a Software Profile must first be created from the database server VM registered in the previous step. A software profile is a template that includes the SQL Server database and operating system. This template exists as a hidden, cloned disk image on your Nutanix storage.

#. Select **Profiles** from the dropdown menu and **Software** from the lefthand menu.

   .. figure:: images/14.png

#. Click **+ Create** and fill out the following fields:

   - **Engine** - Microsoft SQL Server
   - **Name** - *Initials*\ _MSSQL_2016
   - **Description** - (Optional)
   - **Database Server** - Select your registered *Initials*\ -MSSQL VM

   .. figure:: images/15.png

#. Click **Create**.

#. Select **Operations** from the dropdown menu to monitor the registration. This process should take approximately 5 minutes.

   .. figure:: images/16.png

#. Once the profile creation completes successfully, Shutdown (Gracefully) your *Initials*\ **-MSSQL** VM in Prism.

Creating a New MSSQL Database Server
++++++++++++++++++++++++++++++++++++

You've completed all the one time operations required to be able to provision any number of SQL Server VMs. Follow the steps below to provision a database of a fresh database server, with best practices automatically applied by Era.

#. In **Era**, select **Databases** from the dropdown menu and **Sources** from the lefthand menu.

#. Click **+ Provision > Single Node Database**.

   .. figure:: images/18.png

#. In the **Provision a Database** wizard, fill out the following fields to configure the Database Server:

   - **Engine** - Microsoft SQL Server
   - **Database Server** - Create New Server
   - **Database Server Name** - *Initials*\ -MSSQL2
   - **Description** - (Optional)
   - **Software Profile** - *Initials*\ _MSSQL_2016
   - **Compute Profile** - CUSTOM_EXTRA_SMALL
   - **Network Profile** - *User VLAN*\ _MSSQL_NETWORK
   - **Database Time Zone** - Eastern Standard Time
   - Select **Join Domain**
   - **Windows Domain Profile** - NTNXLAB
   - **Windows License Key** - (Leave Blank)
   - **Administrator Password** - nutanix/4u
   - **Instance Name** - MSSQLSERVER
   - **Server Collation** - Default
   - **Database Parameter Profile** - DEFAULT_SQLSERVER_INSTANCE_PARAMS
   - **SQL Service Startup Account** - ntnxlab.local\\Administrator
   - **SQL Service Startup Account Password** - nutanix/4u

   .. figure:: images/19.png

   .. note::

      A **Instance Name** is the name of the database server, this is not the hostname. The default is **MSSQLSERVER**. You can install multiple separate instances of MSSQL on the same server as long as they have different instance names. This was more common on a physical server, however, you do not need additional MSSQL licenses to run multiple instances of SQL on the same server.

      **Server Collation** is a configuration setting that determines how the database engine should treat character data at the server, database, or column level. SQL Server includes a large set of collations for handling the language and regional differences that come with supporting users and applications in different parts of the world. A collation can also control case sensitivity on database. You can have different collations for each database on a single instance. The default collation is **SQL_Latin1_General_CP1_CI_AS** which breaks out like below:

         - **Latin1** makes the server treat strings using charset latin 1, basically **ASCII**
         - **CP1** stands for Code Page 1252. CP1252 is  single-byte character encoding of the Latin alphabet, used by default in the legacy components of Microsoft Windows for English and some other Western languages
         - **CI** indicates case insensitive comparisons, meaning **ABC** would equal **abc**
         - **AS** indicates accent sensitive, meaning **ü** does not equal **u**

      **Database Parameter Profiles** define the minimum server memory SQL Server should start with, as well as the maximum amount of memory SQL server will use. By default, it is set high enough that SQL Server can use all available server memory. You can also enable contained databases feature which will isolate the database from others on the instance for authentication.

#. Click **Next**, and fill out the following fields to configure the Database:

   - **Database Name** - *Initials*\ -fiesta
   - **Description** - (Optional)
   - **Size (GiB)** - 200 (Default)
   - **Database Parameter Profile** - DEFAULT_SQLSERVER_DATABASE_PARAMS

   .. figure:: images/20.png

   .. note::

      Common applications for pre/post-installation scripts include:

      - Data masking scripts
      - Register the database with DB monitoring solution
      - Scripts to update DNS/IPAM
      - Scripts to automate application setup, such as app-level cloning for Oracle PeopleSoft

#. Click **Next** and fill out the following fields to configure the Time Machine for your database:

   .. note::

      .. raw:: html

        <strong><font color="red">It is critical to select the BRONZE SLA in the following step. The default BRASS SLA does NOT include Continuous Protection snapshots.</font></strong>

   - **Name** - *initials*\ -fiesta_TM (Default)
   - **Description** - (Optional)
   - **SLA** - DEFAULT_OOB_BRONZE_SLA
   - **Schedule** - (Defaults)

   .. figure:: images/21.png

#. Click **Provision** to begin creating your new database server VM and **fiesta** database.

#. Select **Operations** from the dropdown menu to monitor the provisioning. This process should take approximately 20 minutes.

   .. figure:: images/22.png

   .. note::

      Observe the step for applying best practices in **Operations**.

      Some of the best practices automatically configured by Era include:

      - Distribute databases and log files across multiple vDisks.
      - Do not use Windows dynamic disks or other in-guest volume management
      - Distribute vDisks across multiple SCSI controllers (for ESXi)
      - For each database, use multiple data files: one file per vCPU.
      - Configure initial log file size to 4 GB or 8 GB and iterate by the initial amount to reach the desired size.
      - Use multiple TempDB data files, all the same size.
      - Use available hypervisor network control mechanisms (for example, VMware NIOC).


Exploring the Provisioned DB Server
++++++++++++++++++++++++++++++++++++

#. In **Prism Element > Storage > Volume Groups**, locate the **ERA_**\ *Initials*\ **_MSSQL2_\*** VG and observe the layout on the **Virtual Disk** tab. <What does this tell us?>

   .. figure:: images/23.png

#. View the disk layout of your newly provisioned VM in Prism. <What are all of these disks and how is this different from the original VM we registered?>

   .. figure:: images/24.png

#. In Prism, note the IP address of your *Initials*\ **-MSSQL2** VM and connect to it via RDP using the following credentials:

   - **User Name** - NTNXLAB\\Administrator
   - **Password** - nutanix/4u

#. Open **Start > Run > diskmgmt.msc** to view the in-guest disk layout. Right-click an unlabeled volume and select **Change Drive Letter and Paths** to view the path to which Era has mounted the volume. Note there are dedicated drives corresponding to SQL data and log locations, similar to the original SQL Server to which you manually applied best practices. <Anything else to share here?>

   .. figure:: images/25.png

Migrating Fiesta App Data
+++++++++++++++++++++++++

In this exercise you will import data directly into your database from a backup exported from another database. While this is a suitable method for migrating data, it potentially involved downtime for an application, or our database potentially not having the very latest data.

Another approach could involve adding your new Era database to an existing database cluster (AlwaysOn Availability Group) and having it replicate to your Era provisioned database. Application level synchronous or asynchronous replication (such as SQL Server AAG or Oracle RAC) can be used to provide Era benefits like cloning and Time Machine to databases whose production instances run on bare metal or non-Nutanix infrastructure.

#. From your *Initials*\ **-MSSQL2** RDP session, launch **Microsoft SQL Server Management Studio** from the desktop and click **Connect** to authenticate as the currently logged in user.

   .. figure:: images/26.png

#. Expand the *Initials*\ **-fiesta** database and note that it contains no tables. With the database selected, click **New Query** from the menu to import your production application data.

   .. figure:: images/27.png

#. Copy and paste the following script into the query editor and click **Execute**:

   .. literalinclude:: FiestaDB-MSSQL.sql
     :caption: FiestaDB Data Import Script
     :language: sql

   .. figure:: images/28.png

#. Note the status bar should read **Query executed successfully**.

#. You can view the contents of the database by clicking **New Query** and executing the following:

   .. code-block:: sql

      SELECT * FROM dbo.products
      SELECT * FROM dbo.stores
      SELECT * FROM dbo.InventoryRecords

   .. figure:: images/29.png

#. In **Era > Time Machines**, select your *initials*\ **-fiesta_TM** Time Machine. Select **Actions > Log Catch Up > Yes** to ensure the imported data has been flushed to disk prior to the cloning operation in the next lab.

Provision Fiesta Web Tier
+++++++++++++++++++++++++

Manipulating data using **SQL Server Management Studio** is boring, especially when THE *Sharon Santana* went through all of the trouble of building a neat front end for your business critical app. In this section you'll deploy the web tier of the application and connect it to your production database.

#. `Download the Fiesta Blueprint by right-clicking here <https://raw.githubusercontent.com/nutanixworkshops/ts2020/master/db/mssqldeploy/FiestaNoDB.json>`_. This single-VM Blueprint is used to provision only the web tier portion of the application.

#. From **Prism Central > Calm**, select **Blueprints** from the lefthand menu and click **Upload Blueprint**.

   .. figure:: images/30.png

#. Select **FiestaNoDB.json**.

#. Update the **Blueprint Name** to include your initials. Even across different projects, Calm Blueprint names must be unique.

#. Select your Calm project and click **Upload**.

   .. figure:: images/31.png

#. In order to launch the Blueprint you must first assign a network to the VM. Select the **NodeReact** Service, and in the **VM** Configuration menu on the right, select *Your Assigned User VLAN* as the **NIC 1** network.

   .. figure:: images/32.png

#. Click **Credentials** to define a private key used to authenticate to the CentOS VM that will be provisioned by the Blueprint.

#. Expand the **CENTOS** credential and use your preferred SSH key, or paste in the following value as the **SSH Private Key**:

   ::

     -----BEGIN RSA PRIVATE KEY-----
     MIIEowIBAAKCAQEAii7qFDhVadLx5lULAG/ooCUTA/ATSmXbArs+GdHxbUWd/bNG
     ZCXnaQ2L1mSVVGDxfTbSaTJ3En3tVlMtD2RjZPdhqWESCaoj2kXLYSiNDS9qz3SK
     6h822je/f9O9CzCTrw2XGhnDVwmNraUvO5wmQObCDthTXc72PcBOd6oa4ENsnuY9
     HtiETg29TZXgCYPFXipLBHSZYkBmGgccAeY9dq5ywiywBJLuoSovXkkRJk3cd7Gy
     hCRIwYzqfdgSmiAMYgJLrz/UuLxatPqXts2D8v1xqR9EPNZNzgd4QHK4of1lqsNR
     uz2SxkwqLcXSw0mGcAL8mIwVpzhPzwmENC5OrwIBJQKCAQB++q2WCkCmbtByyrAp
     6ktiukjTL6MGGGhjX/PgYA5IvINX1SvtU0NZnb7FAntiSz7GFrODQyFPQ0jL3bq0
     MrwzRDA6x+cPzMb/7RvBEIGdadfFjbAVaMqfAsul5SpBokKFLxU6lDb2CMdhS67c
     1K2Hv0qKLpHL0vAdEZQ2nFAMWETvVMzl0o1dQmyGzA0GTY8VYdCRsUbwNgvFMvBj
     8T/svzjpASDifa7IXlGaLrXfCH584zt7y+qjJ05O1G0NFslQ9n2wi7F93N8rHxgl
     JDE4OhfyaDyLL1UdBlBpjYPSUbX7D5NExLggWEVFEwx4JRaK6+aDdFDKbSBIidHf
     h45NAoGBANjANRKLBtcxmW4foK5ILTuFkOaowqj+2AIgT1ezCVpErHDFg0bkuvDk
     QVdsAJRX5//luSO30dI0OWWGjgmIUXD7iej0sjAPJjRAv8ai+MYyaLfkdqv1Oj5c
     oDC3KjmSdXTuWSYNvarsW+Uf2v7zlZlWesTnpV6gkZH3tX86iuiZAoGBAKM0mKX0
     EjFkJH65Ym7gIED2CUyuFqq4WsCUD2RakpYZyIBKZGr8MRni3I4z6Hqm+rxVW6Dj
     uFGQe5GhgPvO23UG1Y6nm0VkYgZq81TraZc/oMzignSC95w7OsLaLn6qp32Fje1M
     Ez2Yn0T3dDcu1twY8OoDuvWx5LFMJ3NoRJaHAoGBAJ4rZP+xj17DVElxBo0EPK7k
     7TKygDYhwDjnJSRSN0HfFg0agmQqXucjGuzEbyAkeN1Um9vLU+xrTHqEyIN/Jqxk
     hztKxzfTtBhK7M84p7M5iq+0jfMau8ykdOVHZAB/odHeXLrnbrr/gVQsAKw1NdDC
     kPCNXP/c9JrzB+c4juEVAoGBAJGPxmp/vTL4c5OebIxnCAKWP6VBUnyWliFhdYME
     rECvNkjoZ2ZWjKhijVw8Il+OAjlFNgwJXzP9Z0qJIAMuHa2QeUfhmFKlo4ku9LOF
     2rdUbNJpKD5m+IRsLX1az4W6zLwPVRHp56WjzFJEfGiRjzMBfOxkMSBSjbLjDm3Z
     iUf7AoGBALjvtjapDwlEa5/CFvzOVGFq4L/OJTBEBGx/SA4HUc3TFTtlY2hvTDPZ
     dQr/JBzLBUjCOBVuUuH3uW7hGhW+DnlzrfbfJATaRR8Ht6VU651T+Gbrr8EqNpCP
     gmznERCNf9Kaxl/hlyV5dZBe/2LIK+/jLGNu9EJLoraaCBFshJKF
     -----END RSA PRIVATE KEY-----

   .. figure:: images/33.png

#. Click **Save** and click **Back** once the Blueprint has completed saving.

#. Click **Launch** and fill out the following fields:

   - **Name of the Application** - *Initials*\ -Fiesta
   - **db_dialect** - mssql
   - **db_domain_name** - ntnxlab.local
   - **db_host_address** - The IP of your *Initials*\ **-MSSQL2** VM
   - **db_name** - *Initials*\ -fiesta (as configured when you deployed through Era)
   - **db_password** - nutanix/4u
   - **db_username** - Administrator

   .. figure:: images/34.png

#. Click **Create**.

#. Select the **Audit** tab to monitor the deployment. This process should take < 5 minutes.

   .. figure:: images/35.png

#. Once the application status changes to **Running**, select the **Services** tab and select the **NodeReact** service to obtain the **IP Address** of your web server.

   .. figure:: images/36.png

#. Open \http://*NODEREACT-IP-ADDRESS:5001*/ in a new browser tab to access the **Fiesta** application.

   .. figure:: images/37.png

   Congratulations! You've completed the deployment of your production application.

Takeaways
+++++++++

What are the key things we learned in this lab?

- Existing databases can be easily onboarded into Era, and turned into templates
- Existing brownfield databases can also be registered with Era
- Profiles allow administrators to provision resources based on published standards
- Customizable recovery SLAs allow you to tune continuous, daily, and monthly RPO based on your app's requirements
- Era provides One-click provisioning of multiple database engines, including automatic application of database best practices
