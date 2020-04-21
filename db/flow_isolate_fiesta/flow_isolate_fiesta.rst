.. _dbflow_isolate_fiesta:

-----------------------------------------
Isolating Database Environments with Flow
-----------------------------------------

Isolation policies are used when one group of VMs must be completely blocked from communicating with another group of VMs without any whitelist exceptions. A common example is using isolation policies to block VMs tagged **Environment: Dev** from talking to VMs in **Environment: Production**. Do not use isolation policies if you want to create exceptions between the two groups, instead use an Application Policy which allows a whitelist model.

**In this exercise you protect the production and development Fiesta applications by creating new environment categories and assigning these to the cloned Fiesta application VMs. Next you will create and implement an isolation security policy that uses the newly created categories to stop the two environments from communicating.**

Creating and Assigning Categories
+++++++++++++++++++++++++++++++++

#. In **Prism Central**, select :fa:`bars` **> Virtual Infrastructure > Categories**.

#. Select the checkbox for **Environment** and click **Actions > Update**.

#. Click the :fa:`plus-circle` icon beside the last value to add an additional Category value.

#. Specify *Initials*-**Prod** as the value name to add a production environment category.

#. Enter *Initials*-**Dev** to create a development environment category.

   .. figure:: images/37.png

#. Click **Save**.

#. In **Prism Central**, select :fa:`bars` **> Virtual Infrastructure > VMs**.

#. Click **Filters** and search for *Initials*-**MSSQL** in the **NAME** field to display your production and development database virtual machines.

   .. note::

     If you previously created a Label for your application VMs you can also search for that label. Alternatively you can search for the **AppType:** *Initials*-**Fiesta** category from the Filters pane.

   .. figure:: images/38.png

#. Using the checkboxes, select the database VM *Initials*-**MSSQL2** associated with the production application and select **Actions > Manage Categories**.

#. Specify **Environment:**\ *Initials*-**Prod** in the search bar and click the **Save** icon to assign the production category to this VM.

   .. figure:: images/39.png

#. Repeat the previous step to assign **Environment:**\ *Initials*-**Dev** to the development VM *Initials*-**MSSQL2**\_ *date*.

#. Click **Filters** and search for *Initials*-**_Fiesta** in **CATEGORIES** to display your production web VM.

   .. figure:: images/40.png

#. Using the checkboxes, select the web VM associated with the production application and select **Actions > Manage Categories**.

#. Specify **Environment:**\ *Initials*-**Prod** in the search bar and click the **Save** icon to assign the category to this VM.

#. Click **Filters** and search for *Initials*-**DevFiesta** in **CATEGORIES** to display your development web VM.

#. Specify **Environment:**\ *Initials*-**Dev** in the search bar and click the **Save** icon to assign the category to this VM.

Creating an Isolation Policy
++++++++++++++++++++++++++++

#. In **Prism Central**, select :fa:`bars` **> Virtual Infrastructure > Policies > Security Policies**.

#. Click **Create Security Policy > Isolate Environments (Isolation Policy) > Create**.

#. Fill out the following fields:

   - **Name** - *Initials*-Isolate-dev-prod
   - **Purpose** - *Initials* - Isolate dev from prod
   - **Isolate This Category** - Environment:*Initials*Dev
   - **From This Category** - Environment:*Initials*-Prod
   - Do **NOT** select **Apply this isolation only within a subset of the datacenter**. This option provides additional granularity by only applying to VMs assigned a third, mutual category.

   .. figure:: images/41.png

#. Click **Apply Now** to save the policy and begin enforcement immediately.

#. Open the production database *Initials*\ **-MSSQL-2** console.

   Can you ping the production Fiesta web VM from the production database? What policy blocks this traffic?

   Can you ping the development Fiesta web VM from the production database?

   Using these simple policies it is possible to block traffic between groups of VMs such as production and development, to isolate a lab system, or provide isolation for a development and web database.

Placing a Policy in Monitor Mode
++++++++++++++++++++++++++++++++

#. In **Prism Central**, select :fa:`bars` **> Virtual Infrastructure > Policies > Security Policies**.

#. Select *Initials*-**Isolate-dev-prod** and click **Actions > Monitor**.

#. Type **MONITOR** in the confirmation dialogue and click **OK** to disable the policy.

#. Return to the *Initials*\ **-MSSQL2** console and verify the development web VM is accessible using ping from production.

Takeaways
+++++++++

- In this exercise you created categories and an isolation security policy with ease without having to alter or change any networking configuration.
- After tagging the VMs with the categories created, the VMs simply behaved according to the policies they belong to.
- The isolation policy is evaluated at a higher priority than the application security policy.
