.. _oraclepatch:

-----------------
Database Patching
-----------------

Maintaining consistent patch levels across database servers in a traditional environment can be a very difficult process. Era makes this simple by providing a means of database engine patching through versioned software profiles. Groups of database servers can be patched or rolled back through Era using the web interface, or via CLI or API.

Each quarter, Oracle releases a grouping of patches referred to as a PSU. **In this lab you will walk through the deployment and patching of both Oracle and Grid software for an Oracle 19c database using Era.**

Manual Oracle VM Deployment
+++++++++++++++++++++++++++

In this exercise, you will deploy an Oracle database VM, using pre-created disk images. This VM is the running Oracle 19c with April PSU patches applied.

#. In **Prism Central**, select :fa:`bars` **> Virtual Infrastructure > VMs**.

#. Click **Create VM**.

#. Select your assigned cluster and click **OK**.

#. Fill out the following fields:

   - **Name** - *Initials*\ _oracle_base
   - **Description** - (Optional) Description for your VM.
   - **vCPU(s)** - 2
   - **Number of Cores per vCPU** - 1
   - **Memory** - 8 GiB

   - Select **+ Add New Disk**
      - **Type** - DISK
      - **Operation** - Clone from Image Service
      - **Image** - 19c_bootdisk.qcow2
      - Select **Add**

   - Select **+ Add New Disk**
      - **Type** - DISK
      - **Operation** - Clone from Image Service
      - **Image** - 19c_disk1.qcow2
      - Select **Add**

   - Select **+ Add New Disk**
      - **Type** - DISK
      - **Operation** - Clone from Image Service
      - **Image** - 19c_disk2.qcow2
      - Select **Add**

   - Select **+ Add New Disk**
      - **Type** - DISK
      - **Operation** - Clone from Image Service
      - **Image** - 19c_disk3.qcow2
      - Select **Add**

   - Select **+ Add New Disk**
      - **Type** - DISK
      - **Operation** - Clone from Image Service
      - **Image** - 19c_disk4.qcow2
      - Select **Add**

   - Select **+ Add New Disk**
      - **Type** - DISK
      - **Operation** - Clone from Image Service
      - **Image** - 19c_disk5.qcow2
      - Select **Add**

   - Select **+ Add New Disk**
      - **Type** - DISK
      - **Operation** - Clone from Image Service
      - **Image** - 19c_disk6.qcow2
      - Select **Add**

   - Select **+ Add New Disk**
      - **Type** - DISK
      - **Operation** - Clone from Image Service
      - **Image** - 19c_disk7.qcow2
      - Select **Add**

   - Select **+ Add New Disk**
      - **Type** - DISK
      - **Operation** - Clone from Image Service
      - **Image** - 19c_disk8.qcow2
      - Select **Add**

   - Select **+ Add New Disk**
      - **Type** - DISK
      - **Operation** - Clone from Image Service
      - **Image** - 19c_disk9.qcow2
      - Select **Add**

   - Select **Add New NIC**
      - **VLAN Name** - *Assigned User VLAN*
      - Select **Add**

#. Click **Save** to create the VM.

   You will now create a copy of this VM which will later be used to install October PSU patches.

#. Once the VM has been created, select your *Initials*\ **_oracle_base** and click **Actions > Clone**.

   .. figure:: images/1.png

#. Change the name to *Initials*\ **_oracle_patched** and click **Save**.

#. Select both VMs and click **Actions > Power On**.

Register Oracle Server with Era
+++++++++++++++++++++++++++++++

In this exercise, you will register your April PSU VM and register it as version 1.0 of your Oracle 19c Software Profile. The Software Profile is a template containing both the operating system and database software, and can be used to deploy additional database servers.

#. In **Era**, select **Database Servers** from the dropdown menu and **List** from the lefthand menu.

   .. raw:: html

     <strong><font color="red">Ensure you are registering a source Database Server and not a source Database.</font></strong>

#. Click **+ Register**.

#. Click **+ Register** and fill out the following **Database Server** fields:

   - **Engine** - Oracle
   - **IP Address or Name of VM** - *Initials*\ _oracle_base
   - **Database Version** - 19.0.0.0
   - **Era Drive User** - oracle
   - **Oracle Database Home** - /u02/app/oracle/product/19.0.0/dbhome_1
   - **Grid Infrastructure Home** - /u01/app/19.0.0/grid
   - **Provide Credentials Through** - Password
   - **Password** - Nutanix/4u

   .. note::

      The Era Drive User can be any user on the VM that has sudo access with NOPASSWD setting. Era will use this user's credentials to perform various operations, such as taking snapshots.

      Oracle Database Home is the directory where the Oracle database software is installed, and is a mandatory parameter for registering a database server.

      Grid Infrastructure Home is the directory where the Oracle Grid Infrastructure software is installed. This is only applicable for Oracle RAC or SIHA databases.

   .. figure:: images/2.png

#. Click **Register** and monitor the progress on the **Operations** page. This process should take approximately 2 minutes. Wait for the registration operation to successfully complete before moving on.

   Once the *Initials*\ **_oracle_base** server has been registered with Era, we need to create a software profile in order to deploy additional Oracle VMs.

#. Select **Profiles** from the dropdown menu and **Software** from the lefthand menu.

#. Click **+ Create** and fill out the following fields:

   - **Engine** - Oracle
   - **Type** - Single Instance
   - **Name** - *Initials*\ _ORACLE_19C
   - **Description** - (Optional)
   - **Database Server** - Select your registered *Initials*\ _oracle_base VM

   .. figure:: images/3.png

#. Click **Create**.

#. Select **Operations** from the dropdown menu to monitor the registration. This process should take approximately 5 minutes.

#. Once the profile creation completes successfully, power off your *Initials*\ **_oracle_base** VM in Prism.

Create Oracle Server with Era
+++++++++++++++++++++++++++++

In this exercise you will deploy a fresh Oracle database using your *Initials*\ **_ORACLE_19C** 1.0 Software Profile.

#. Select **Databases** from the dropdown menu and **Sources** from the lefthand menu.

#. Click **+ Provision > Single Node Database**.

#. In the **Provision a Database** wizard, fill out the following fields to configure the Database Server:

   - **Engine** - Oracle
   - **Database Server** - Create New Server
   - **Database Server Name** - *Initials*\ _oracle_prod
   - **Description** - (Optional)
   - **Software Profile** - *Initials*\ _ORACLE_19C
   - **Compute Profile** - ORACLE_SMALL
   - **Network Profile** - *User VLAN*\ _ORACLE_NETWORK
   - Select **Enable High Availability**
   - **SYS ASM Password** - oracle
   - **SSH Public Key for Node Access** -

   ::

      ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAii7qFDhVadLx5lULAG/ooCUTA/ATSmXbArs+GdHxbUWd/bNGZCXnaQ2L1mSVVGDxfTbSaTJ3En3tVlMtD2RjZPdhqWESCaoj2kXLYSiNDS9qz3SK6h822je/f9O9CzCTrw2XGhnDVwmNraUvO5wmQObCDthTXc72PcBOd6oa4ENsnuY9HtiETg29TZXgCYPFXipLBHSZYkBmGgccAeY9dq5ywiywBJLuoSovXkkRJk3cd7GyhCRIwYzqfdgSmiAMYgJLrz/UuLxatPqXts2D8v1xqR9EPNZNzgd4QHK4of1lqsNRuz2SxkwqLcXSw0mGcAL8mIwVpzhPzwmENC5Orw==


   .. note::

         By selecting Enable High Availability, Oracle Grid is configured as part of the deployment and Oracle Automatic Storage Management (ASM) is used for volume management. Without High Availability enabled, Linux LVM and file systems would be used for database storage. Gris and ASM are required for clustered Oracle RAC deployments.

   .. figure:: images/4.png

#. Click **Next**, and fill out the following fields to configure the Database:

   -  **Database Name** - *Initials*\ _proddb
   -  **SID** - *Initials*\ prod
   -  **SYS and SYSTEM Password** - Nutanix/4u
   -  **Database Parameter Profile** - ORACLE_SMALL_PARAMS

   .. figure:: images/5.png

   .. note::

      For each database engine supported by Era, you have the opportunity to run scripts before and after database creation. Common use cases include:

      - Data masking scripts
      - Register the database with DB monitoring solution
      - Scripts to update DNS/IPAM
      - Scripts to automate application setup, such as app-level cloning for Oracle PeopleSoft

      **Encryption** can be used in situations where compliance requires encryption and stops would-be attackers from bypassing the database and reading sensitive information directly from storage by enforcing data-at-rest encryption in the database layer.

#. Click **Next** and fill out the following fields to configure the Time Machine for your database:

   - **Name** - *Initials*\ _proddb_TM (Default)
   - **Description** - (Optional)
   - **SLA** - DEFAULT_OOB_GOLD_SLA
   - **Schedule** - (Defaults)

   .. figure:: images/6.png

#. Click **Provision** to begin creating your new database server VM and *Initials*\ **_proddb** database.

#. Select **Operations** from the dropdown menu to monitor the provisioning. This process should take approximately 60 minutes (depending on your cluster configuration), but you can proceed to the following exercises while the database is being provisioned.

Patching Base Oracle VM
+++++++++++++++++++++++

In this exercise, you will apply the October PSU patches to your manually cloned VM, register the database server with Era, and then use it as the basis for creating a new version of your *Initials*\ **_ORACLE_19C** Software Profile.

#. In **Prism Central**, note the IP address of your *Initials*\ **_oracle_patched** VM.

#. Connect to your *Initials*\ **_oracle_patched** VM via SSH using the following credentials:

   - **User Name** - root
   - **Password** - Nutanix/4u

#. Execute the following script to download and install the Oracle and Grid October PSU patches:

    .. code-block:: bash

      cd Downloads
      ./applypsu.sh

#. Observe that the script will first display the current patch level of the VM, note the April dates on the displayed releases. Press any key to continue the patch installation.

   .. figure:: images/7.png

#. If prompted, type **A** to overwrite any existing files while extracting the patch and follow any prompts to press any key to continue. The script should run for approximately 20 minutes.

   .. figure:: images/8.png

#. Once the script has finished, return to **Era > Database Servers > List**.

#. Click **+ Register** and fill out the following **Database Server** fields:

   - **Engine** - Oracle
   - **IP Address or Name of VM** - *Initials*\ _oracle_patched
   -  **Database Version** - 19.0.0.0
   - **Era Drive User** - oracle
   - **Oracle Database Home** - /u02/app/oracle/product/19.0.0/dbhome_1
   -  **Grid Infrastructure Home** - /u01/app/19.0.0/grid
   - **Provide Credentials Through** - Password
   - **Password** - Nutanix/4u

   .. figure:: images/9.png

#. Click **Register** and monitor the progress on the **Operations** page. This process should take approximately 2 minutes.

#. Once registration completes, select **Era > Profiles > Software** and click your *Initials*\ **_ORACLE_19C** Software Profile. Observe that Era provides complete introspection into the packages installed within the operating system, including the **Database Software** and **Grid Software**. Note the **Patches Found** under **Database Software**.

   .. figure:: images/10.png

#. With your *Initials*\ **_ORACLE_19C** Software Profile selected, click **+ Create** to create a new version based on the *Initials*\ **_oracle_patched** VM you registered in the previous step.

#. Fill out the following fields and click **Create**:

   - **Name** - *Initials*\ _ORACLE_19C (Oct19 PSU)
   - Select *Initials*\ **_oracle_patched**

   .. figure:: images/11.png

#. Monitor the progress on the **Operations** page. This process should take approximately 5 minutes.

#. Return to **Era > Profiles > Software** and click your *Initials*\ **_ORACLE_19C** Software Profile. Note the 2.0 version now appears, with additional patches found under **Database Software** and **Grid Infrastructure Software**.

   .. figure:: images/12.png

   Before you can apply to patched Software Profile to your *Initials*\ **_oracle_prod** VM, the Software Profile must first be published, otherwise Era will not show the version as available or recommended for updating.

#. Select the **2.0** profile and click **Update**.

#. Under **Status**, select **Published** and click **Next**.

   .. figure:: images/13.png

#. Optionally, you can provide notes regarding patches applied to Operating System, Oracle, and Grid software. Click **Next > Update**.

   .. figure:: images/14.png

#. Return to **Era > Database Servers > List** and click your *Initials*\ **_oracle_prod** database server.

#. Under **Profiles**, note that the newer, published software profile is being recommended as an available update to the database server. Click **Update**.

   .. figure:: images/15.png

#. Select the desired patch profile from the drop down menu (in a real environment you could potentially publish several options) and click **Patch 1 Database** to begin the update process.

   .. note::

      Era also offers the ability to schedule patching application, allowing you to select a pre-determined maintenance window. For clustered database deployments, Era supports rolling updates, ensuring database accessibility throughout the update process.

      .. figure:: images/17.png

#. Monitor the progress on the **Operations** page. This process should take approximately 25 minutes.

   During the patching process, Era will gracefully bring down database and Grid services, shut down the VM, replace the relevant virtual disks with thin clones from the 2.0 Software Profile, and bring the database server back online. <Anything more to add here?>

   .. figure:: images/18.png

#. Once the patching operation has completed, you can easily validate the VM is running with the patched software outside of Era. SSH into your *Initials*\ **_oracle_prod** VM with the following credentials:

   - **User Name** - oracle
   - **Password** - Nutanix/4u

#. Execute the following command to display installed patch versions:

   ::

      $ORACLE_HOME/OPatch/opatch lsinventory | egrep 'appl|desc'

   .. figure:: images/19.png

Takeaways
+++++++++

What are the key things we learned in this lab?

- Era can make you 3 inches taller, and help bring in your groceries from the car
- Software Profiles can be versioned and used to deploy consistent updates to existing database servers
- Software Profiles also simplify the patching process reducing the amount of manual patching needed in an environment
- Scheduling updates can be used to hit change windows or SLA uptime windows.
