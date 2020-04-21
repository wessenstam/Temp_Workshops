.. _cloning:

-------------------------------
Time Machine, Cloning, and APIs
-------------------------------

Copy Data Management, or database cloning, is a critical Day 2 database operation, with multiple teams including developers, QA, analysts, and others requesting non-production instances. As previously discussed, all of these clones can lead to tremendous storage capacity utilization. This is made worse by the constant need for these instances to be updated with up-to-date production data.

Era provides Time Machines to simplify cloning operations. Time Machines capture and maintain snapshots and transactional logs of your source databases as defined in the schedule. For every source database you register with Era, a Time Machine is created for that source database. You create clones and refresh clones either to a point in time (by using transactional logs) or by using snapshots.

**In this lab you will use Era to create a clone of your SQL Server database to be used as part of a test environment. After making changes to your production database, you will refresh your test environment.**

Cloning from the Era UI
+++++++++++++++++++++++

In this exercise you will explore the workflow for cloning a database through the Era web interface. **At the end of this exercise you will NOT click Clone to begin the cloning process, you will instead create the clone programmatically in the next exercise. This exercise is simply to show the UI workflow.**

#. In **Era**, select **Time Machines** from the dropdown menu.

#. Select the Time Machine associated with your production database (e.g. *xyz-fiesta_TM*).

.. #. Before cloning our database, we want to ensure a snapshot has been taken representative of the data you imported into your database in the previous exercise. Select **Actions > Snapshot**.

.. #. Provide a **Snapshot Name** and click **Create**.

#. Select **Actions > Clone Database > Single Node Database**.

   By default, a clone will be created from the most recent **Point in Time**. Alternatively you can explicitly specify a previous point in time or snapshot.

#. Click **Next**.

   .. figure:: images/1.png

   Databases can be cloned to a brand new server which will be automatically provisioned by Era, or as an additional database on an existing server.

#. Make the following selections and click **Next**:

   - **Database Server** - Create New Server
   - **Database Server Name** - *Default*
   - **Compute Profile** - CUSTOM_EXTRA_SMALL
   - **Network Profile** - *User Assigned VLAN*\ _MSSQL_NETWORK
   - **Administrator Password** - nutanix/4u
   - Select **Join Domain**
   - **Windows Domain Profile** - NTNXLAB
   - **Domain User Account** - ntnxlab.local\\Administrator

   .. figure:: images/2.png

#. **DO NOT CLICK CLONE**. Select **API Equivalent**.

#. Review the **JSON Data** and example **Script** presented by the Era UI for programmatically generating a database clone based on your inputs.

   .. figure:: images/3.png

#. Click **Close** and then click **X** to close the Clone Database wizard.

Cloning from Calm
+++++++++++++++++

Databases aren't applications, they can be comprised of multiple components. For this dev/test workflow, we'll leverage Calm to spin up a development copy of our Fiesta web tier, and call on Era to provision a clone of the production database programmatically.

#. `Download the FiestaClonedDB Blueprint by right-clicking here <https://raw.githubusercontent.com/nutanixworkshops/ts2020/master/db/cloning/FiestaClonedDB.json>`_.

#. From **Prism Central > Calm**, select **Blueprints** from the lefthand menu and click **Upload Blueprint**.

#. Select **FiestaClonedDB.json**.

#. Update the **Blueprint Name** to include your initials.

#. Select your Calm project and click **Upload**.

   .. figure:: images/4.png

#. In order to launch the Blueprint you must first assign a network to the VM. Select the **NodeReact** Service, and in the **VM** Configuration menu on the right, select *Your Assigned User VLAN* as the **NIC 1** network.

   .. figure:: images/5.png

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

#. Expand the **era_creds** credential and provide the **Era** password.

   .. figure:: images/6.png

#. Click **Save** and click **Back** once the Blueprint has completed saving.

#. Click **Launch** and fill out the following fields:

   - **Name of the Application** - XYZ-DevFiesta
   - **cloned_db_name** - *Leaving this value blank will create a new Database Server based on the name of the source database being cloned*
   - **db_dialect** - mssql
   - **db_domain_name** - ntnxlab.local
   - **db_password** - nutanix/4u
   - **db_username** - Administrator
   - **era_ip** - *IP address of your assigned Era server*
   - **source_db_name** - *The Era database to be cloned (NOT the Time Machine name)*

   .. note::

      Variables may show up in a different order than displayed in the lab, be sure you are putting the correct information in the appropriate fields.

   .. figure:: images/7.png

#. Click **Create**.

#. Select the **Audit** tab to monitor the deployment. Note that the NodeReact VM is provisioned in parallel to the database clone, but the package installation on the NodeReact VM will not take place until after cloning completes, as the web tier is dependent on database availability.

   .. figure:: images/8.png

   You can also monitor progress of the database clone through the **Era > Operations** page.

   .. figure:: images/9.png

   .. note::

      If your database cloning operation fails quickly within Era, validate that the SLA for the Time Machine has been set to **DEFAULT_OOB_BRONZE_SLA**. If it is set to **DEFAULT_OOB_BRASS_SLA** (the default) cloning will fail due to lack of continuous protection snapshots. To update the Time Machine SLA, you will need to connect to Era via ssh and run the following:

      ::

         > ssh era@<ERA-VM-IP>
         Password: Nutanix.1
         > era
         era > time_machine update name="INSERT-TM-NAME" sla_name="DEFAULT_OOB_BRONZE_SLA"

   This process should complete in ~25 minutes.

#. While the clone operation is taking place, use this as an opportunity to further explore this Blueprint. Return to the Blueprint and select the **DBClone** service. Note in the **VM** Configuration panel that Calm is not deploying a virtual machine, but rather taking advantage of the **Existing Machine** setting.

   .. figure:: images/10.png

#. Under **Services > DBClone > VM > Pre-create**, note the scripts that are run to connect to the Era instance, obtain the necessary information required to create the clone, based on the **source_db_name** defined as a runtime variable.

   .. figure:: images/11.png

#. Select the **5CloneDb** task and maximize the **Script** field. Note that the JSON **payload** in this script is what was provided by the Era UI in the previous exercise.

   .. figure:: images/12.png

   Following this script, the **6MonitorOperation** polls Era to determine whether or not the clone operation has successfully completed. Once the clone is complete, the **CLONE_SERVER_IP** can be determined and assigned to the **CloneDb** service.

#. Under **Services > NodeReact > Package > Install**, note the scripts that are run to install the required software for the Fiesta application and configure the database connection.

   .. figure:: images/13.png

#. Select the **ConfApp** task and maximize the script field. Can you spot how the app is being configured to use the IP address of the database server cloned by Era?

   .. figure:: images/14.png

#. In Calm, once the application status changes to **Running**, select the **Services** tab and select the **NodeReact** service to obtain the **IP Address** of your web server.

   .. figure:: images/15.png

#. Open \http://*NODEREACT-IP-ADDRESS*/ in a new browser tab to access the development instance of your **Fiesta** application.

Refreshing Cloned Databases
+++++++++++++++++++++++++++

Now that you have a functioning development environment, it's time to create some changes within your production environment.

#. In a new browser tab, return to your **Production** Fiesta web app. Click **Products > Add New Product**.

   .. figure:: images/16.png

#. Fill out the following fields and click **Submit**:

   - **Product Name** - The Best Balloons
   - **Suggested Retail Price** - 100.00
   - **Product Image URL** - https://partycity6.scene7.com/is/image/PartyCity/_pdp_sq_?$_1000x1000_$&$product=PartyCity/251182
   - **Product Comments** - Everybody Knows

   .. figure:: images/17.png

#. Click **Stores** from the menu and select **View Store** from one of the available stores.

#. Click **Add New Store Product**. Fill out the following fields and click **Submit**:

   - **Product Name** - The Best Balloons
   - **Local Product Price** - 99.99
   - **Initial Qty** - 1000

#. Verify the inventory for the added product appears on the **Store Details** page.

   .. figure:: images/18.png

#. In a separate browser tab, open your **Dev** Fiesta web app. Confirm that the products and inventory added to the **Production** instance are not present.

#. In **Era > Time Machines**, select the Time Machine that corresponds to your production database. Select **Actions > Log Catch Up > Yes** to ensure the latest database entries have been flushed to disk.

   .. figure:: images/19.png

#. Monitor the log catch up on the **Operations** page. This should take approximately 1 minute.

   .. figure:: images/20.png

#. In **Era > Databases > Clones**, select your cloned database and click **Refresh**.

   .. figure:: images/21.png

#. By default, the database will be refreshed to the most recent **Point in Time**, but you can manually specify a time or individual snapshot. For the purposes of this exercise, use the most recent time. Click **Refresh**.

   .. figure:: images/22.png

#. Monitor the refresh on the **Operations** page. This should take approximately 4 minutes.

#. Once the refresh has completed, open your **Dev** Fiesta web app and validate the product and inventory data now matches your production database.

   .. figure:: images/18.png

   With a few mouse clicks, your DBA was able to push current production data to the cloned database. This could be further automated through the Era CLI or APIs.

(Optional) Provisioning Additional Databases to Existing Servers
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

It's not uncommon to have a single database server running multiple databases, especially in test/dev environments. In this exercise you will provision an additional database for a next generation version of the Fiesta application to your existing development SQL Server VM.

#. In **Era > Databases > Sources**, click **Provision > Single Node Database**.

#. In the **Provision a Database** wizard, fill out the following fields to configure the Database Server:

   - **Engine** - Microsoft SQL Server
   - **Database Server** - Use Registered Server
   - **Name** - *Select your cloned Database Server*

   .. figure:: images/23.png

#. Click **Next**, and fill out the following fields to configure the Database:

   - **Database Name** - *Initials*\ -fiesta2
   - **Description** - (Optional)
   - **Size (GiB)** - 200 (Default)
   - **Database Parameter Profile** - DEFAULT_SQLSERVER_DATABASE_PARAMS

   .. figure:: images/24.png

#. Click **Next** and fill out the following fields to configure the Time Machine for your database:

   - **Name** - *initials*\ -fiesta2_TM (Default)
   - **Description** - (Optional)
   - **SLA** - DEFAULT_OOB_BRASS_SLA
   - **Schedule** - (Defaults)

   .. figure:: images/25.png

#. Click **Provision** to begin creating the **fiesta2** database on your existing server.

#. Select **Operations** from the dropdown menu to monitor the provisioning. This process should take approximately 8 minutes.

   .. figure:: images/26.png

#. Once the operation has completed, RDP to the cloned, development Database Server and validate in **SQL Server Management Studio** that your **fiesta2** database is available on your development server.

   .. figure:: images/27.png

Takeaways
+++++++++

What are the key things we learned in this lab?

- Era makes it simple to create space efficient, zero-byte database clones to any point-in-time
- Era provides production-like QoS for clones, with fast creation and data refresh
- Era operations can be performed through REST API, making it easy to integration with Nutanix Calm or third-party automation solutions
