.. _aag:

---------------------------------
Simplifying Database Availability
---------------------------------

Up to this point, we have been using Era to create single instance databases. For any real, production database, you would want to use a clustered solution to provide high availability, reducing any chance of downtime for your application or your business. Era supports provisioning and managing Microsoft SQL Server AlwaysOn Availability Group and Oracle RAC clustered databases.

SQL Server AAG clusters have many moving parts, and deploying a single cluster can easily take several hours or more.

**In this lab you will clone your existing production SQL Server database to a database cluster and test its availability using the Fiesta app.**

Creating an Era Managed Network
+++++++++++++++++++++++++++++++

.. note::

   This operation only needs to be performed **ONCE** per cluster. If the **EraManaged** network has already been added as a resource in Era, you can move on to :ref:`provisioningaag`.

   .. figure:: images/1.png

Era requires a network whose IPs are managed by the Era appliance, allowing it to assign that static IPs required for the cluster VMs and floating IP for the SQL Listener.

#. In **Prism Central**, select :fa:`bars` **> Virtual Infrastructure > Subnets**.\

#. Click **Network Config**, select *Your Assigned Cluster*, and click **OK**.

#. Click **+ Create Network** and fill out the following fields:

   - **Name** - EraManaged
   - **VLAN ID** - *Refer to*  :ref:`clusterassignments`

   .. figure:: images/2.png

#. Click **Save**.

#. In **Era > Administration > Era Resources**, click **Add** to create a new Era network.

   .. figure:: images/3.png

#. Fill out the following fields and click **Add**:

   - **Select a VLAN** - EraManaged
   - Select **Manage IP Address Pool**
   - **Gateway** - *Refer to*  :ref:`clusterassignments`
   - Select **Verify**
   - **Subnet Mask** - *Refer to*  :ref:`clusterassignments`
   - **Primary DNS** - *Refer to*  :ref:`clusterassignments`
   - **DNS Domain** - ntnxlab.local
   - **First Address** - *Refer to*  :ref:`clusterassignments`
   - **Last Address** - *Refer to*  :ref:`clusterassignments`

   .. figure:: images/4.png

#. In **Era > Profiles > Network**, click **+ Create** to add the **EraManaged** network to a profile.

#. Fill out the following fields:

   - **Engine** - Microsoft SQL Server
   - **Name** - ERAMANAGED_MSSQL_NETWORK
   - **Public Service VLAN** - EraManaged

   .. figure:: images/5.png

#. Click **Create**.

.. _provisioningaag:

Provisioning an AAG
+++++++++++++++++++

#. In **Era**, select **Time Machines** from the dropdown menu.

#. Select the Time Machine associated with your production database (e.g. *xyz-fiesta_TM*, NOT *xyz-fiesta2_TM*).

#. Select **Actions > Clone Database > Cluster Database**.

   By default, a clone will be created from the most recent **Point in Time**. Alternatively you can explicitly specify a previous point in time or snapshot.

#. Click **Next**.

   .. figure:: images/6.png

#. Fill out the following fields and click **Next**:

   - **Windows Cluster** - Create New Cluster
   - **Windows Cluster Name** - *Initials*\ -clusterdb
   - **Compute Profile** - CUSTOM_EXTRA_SMALL
   - **Network Profile** - ERAMANAGED__MSSQL_NETWORK
   - **Windows Domain Profile** - NTNXLAB
   - **Administrator Password** - nutanix/4u
   - **Instance Name** - MSSQLSERVER
   - **SQL Service Startup Account** - ntnxlab.local\\Administrator
   - **SQL Service Startup Account Password** - nutanix/4u
   - **SQL Server Authentication Mode** - Windows Authentication
   - **Domain User Account** - ntnxlab.local\\Administrator

   .. figure:: images/7.png

#. Modify the following default **Topology** fields and click **Next**:

   - **Always on Availability Group Name** - *Initials*\ -aag

   .. figure:: images/8.png

   .. note::

      SQL 2016 and above supports up to 9 secondary replicas.

      The **Primary** server indicates which host you want the AAG to start on.

      **Auto Failover** allows the AAG to failover automatically when it detects the **Primary** host is unavailable. This is preferred in most deployments as it requires no additional administrator intervention, allowing for maximum application uptime.

      **Availability Mode** can be configured as either **Synchronous** or **Asynchronous**.

         - **Synchronous-commit replicas** - Data is committed to both primary and secondary nodes at the same time. This mode supports both **Automatic** and **Manual Failover**.
         - **Asynchronous-commit replicas** - Data is committed to primary first and then after some time-interval, data is committed to the secondary nodes. This mode only supports **Manual Failover**.

      **Readable Secondaries** allows you to offload your secondary read-only workloads from your primary replica, which conserves its resources for your mission critical workloads. If you have mission critical read-workload or the workload that cannot tolerate latency (up to a few seconds), you should run it on the primary.

#. Click **Clone**.

   .. figure:: images/9.png

#. Monitor the refresh on the **Operations** page. This operation should take approximately 35 minutes. **You can proceed to the while your clustered database servers are provisioned.**

   .. figure:: images/10.png

Configure Fiesta for AAG
++++++++++++++++++++++++

Rather than deploy an additional Fiesta web server VM, you will update the configuration of your existing VM to point to the database cluster.

#. In **Era > Databases > Clones**, and select your most recent clone to view the details of the AAG deployment. Note the **Listener IP Address** of the Always on Availability Group.

   .. figure:: images/11.png

#. In **Prism Central > Calm > Applications**, select your *Initials*\ **-DevFiesta** deployment. In the **Services** tab, select the **NodeReact** service and click **Open Terminal > Proceed** to open a new tab with an SSH session into the VM.

   .. figure:: images/12.png

#. Run: cat Fiesta/config/config.js and note the DB_HOST_ADDRESS value.

   .. figure:: images/13.png

#. Run sudo sed -i 's/CURRENT_DB_HOST_ADDRESS_VALUE/AAG_LISTENER_IP_ADDRESS_VALUE/g' ~/Fiesta/config/config.js

#. cat Fiesta/config/config.js to confirm update

   .. figure:: images/14.png

#. sudo systemctl restart fiesta

Failing A Cluster Server
++++++++++++++++++++++++

Time to break stuff!

#. Open your **Dev Fiesta** web app and make a change such as deleting a store and/or adding additional products to a store.

   .. figure:: images/15.png

#. In **Prism Central > VMs**, power off *Initials*\ **-clusterdb-1** VM.

   .. note:: You can double check which VM is currently the primary member of the AAG but noting which VM currently displays the AAG's Listener IP Address and Windows Cluster IP in Prism Central.

   .. figure:: images/16.png

#. Refresh **Prism Central** and note that the **Listener** and **Cluster** IP addresses are now assigned to the other **clusterdb** VM.

   .. figure:: images/17.png

#. Refresh your **Dev Fiesta** web app and validate data is being displayed properly.

Takeaways
+++++++++

What are the key things we learned in this lab?

- Production databases require high levels of availability to prevent downtime
- Era makes the deployment of complex, clustered databases as easy (and as fast) as single instance databases
