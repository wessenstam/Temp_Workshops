.. _selfservice:

------------------
HYCU: Self-Service
------------------

Overview
++++++++
HYCU self-service is a powerful feature set allowing multitenant role-based user access management. It is designed with two main use cases in mind
- Enable service providers to provide BaaS to their customers allowing them access to the data protection features. Keeping them assured their workloads are protected, or allowing advanced customers to perform backup and recovery activities on their own, without involving IT
- Enable bigger IT organizations distribution of the load of managing IT environments and delegation of ownership to the other groups (for instance devops, db admins…).

Create a HYCU User Group
========================

Let’s start by creating a new HYCU user group:

#. In HYCU > Left panel > Self-Service > New (on the top left-hand side of the screen)

   - Name – desired name of a HYCU internal user group

   .. figure:: images/1.png

#. Click *Save*

You should now have the newly created HYCU user group – eng-grp  (next to the Infrastructure Group) in the Self-Service inventory. Note that each User Group gets a different schema in HYCU internal database and HYCU makes sure to clearly separate the data for security and data confidentiality purposes.

The next steps is to configure and add users to this group. HYCU can manage users on its own or integrate with Active directory. For purpose of this exercise, let’s start with integrating the HYCU backup controller to an Active directory domain. *Please login to HYCU as the admin user*.

#. In HYCU > Upper panel > *Settings* (sprocket at the top right) > *Active Directory*

   .. figure:: images/2.png

#. Click on *New*

   .. figure:: images/3.png

#. Enter the following details:

   - Name – A simple representative name for an AD domain
   - Domain – The FQDN of a domain name
   - Provider URL – https://<DC_hostname_or_IP
   - No need to enter the port as it’s optional

   .. figure:: images/4.png

#. Click on *Save*

   .. figure:: images/5.png

#.  This will enable HYCU to add AD users and AD groups from the domain we just added. Do note, that you can add multiple AD domains within a single HYCU backup controller. This can be a very useful feature when trying to implement a multi-tenancy environment with multiple domains in a shared infrastructure.


Add Active Directory Groups and Users
=====================================

All functions of HYCU’s user-management are available within the self-service section.

#. In HYCU > Left panel > *Self-Service* > *Users* (on the top left-hand side of the screen)

   .. figure:: images/6.png

#. Click on *New*
   Here, you can add a local HYCU user (credentials managed by HYCU), an AD user and an AD group. For purpose of this exercise, we will use an AD group which has configured users in the Active directory.

   - Common Name – the exact AD group name as it exists on the AD server

   .. figure:: images/7.png

#. Simply specify the previously created AD domain that’s available in the drop down under Active Directory and click on *Save*.

   .. figure:: images/8.png

#. Until a user is actually added to a HYCU user group it will still not be able to login to HYCU. So, let’s now add a user to the previously defined HYCU user group. Click on the group *eng-grp* > *Add to Group*

   .. figure:: images/9.png

#. Add the AD group you previously added to HYCU, and assign it the role Backup Operator. You can notice HYCU has 4 roles:

   - Viewer - the role with simple read-only permissions
   - Backup Operator - the role with permissions that allows you to perform only discovery and backups of VMs
   - Restore operator - the role with permissions that only allows you to perform restores
   - Administrator - the role with backup and restore permissions, as well user management and reporting permissions

#. Click on *Add User*. This will add the AD group *hycugrp* to the HYCU internal user group *eng-grp* with backup only permissions.


Assign Ownership of Resources to Groups
=======================================

#. It’s now time to assign ownership of VMs and Shares (from Nutanix files) to eng-grp.  In HYCU > Left panel > *Virtual Machines* > Choose any desired set of VMs > *Owner* (on the top right-hand side of the screen)

   .. figure:: images/10.png

#. Select the newly created group *eng-grp* and click on *Assign*.

   .. figure:: images/11.png

#. This will assign the ownership of those VMs to eng-group. Same can be done also for Nutanix shares.  In HYCU > Left panel > *Shares* > Choose any desired set of shares > *Owner* (on the top right-hand side of the screen)

   .. figure:: images/12.png

#. You should be able to select *eng-grp* and click on *Assign*

   .. figure:: images/13.png

#. As soon as you do this, *OWNER* column will indicate user group owning the respective VM/Share. As an administrator member of default Infrastructure Group you will no longer have ownership of this data and therefore will not be able to assign a policy and start a backup, or restore. Depending on the use case, your customers might expect you to still be able to fully run the data protection for them, or at least perform certain management activities from time to time. To achieve this, you will need to add you administrator user also to the respective tenant user group:

   #. Click on the group eng-grp > Add to Group, and add your administrator user with Administrator role.

   #. Now simply navigate to the top right corner and click on the Infrastructure Group, select the tenant user group and click Switch. You are now logged in as a member of the respective user group and can perform actions on their behalf. As you would expect from a true multi-tenancy, any user can be part of multiple user groups and can simply navigate between them.

   .. figure:: images/14.png

   .. note:: Note that (re)assigning ownership of a VM/Share to a group will also delete any backup done in the previous group due to confidentiality restrains. Make sure your user groups are planned from the beginning

Demonstrating Role-based Access Control
=======================================

Let’s now also login as the member of the *eng-grp*, in this case, it would be any member of the AD group *hycugrp*. In this exercise, we have an AD user named *hycuusr1* as member of the AD group *hycugrp*. To login using an AD user, specify the username@FQDN (e.g. hycuusr1@ntnxlab.local)

.. figure:: images/15.png

#. Once logged in, navigate to the Virtual machines/Shares and notice you see only the VMs/file shares which were assigned by the Infrastructure group to you use group. Note that the targets and Self-Service options are greyed out. Only the default *Infrastructure Group* and its members have explicit permissions to configure targets. All other groups, and their members, will not be able see the targets.

   .. figure:: images/16.png

#. If the user had the *Administrator* role instead of the *Backup Operator* role, then the Self-Service option would be enabled. You would have the rights to only add or remove users from the respective HYCU user group. You still would not have the permissions to add users into HYCU (unless you have administrator privileges to the *Infrastructure Admin* group).

#. Navigate to the Policies and notice that members of user groups are not able to change the backup policies, only view and assign them. By default, when logged into HYCU, tenants will be able to see and assign all the policies. This helps in scenarios where service providers create default generic gold/silver/bronze policies and can charge based on their use.


Customizing Policies for Multi-tenancy
######################################


In some cases it makes sense to have specific policies defined per each user group (tenant), allowing also different targets per group. In that case, you need to make sure each user group sees only their own set of policies. To achieve this and assign ownership of a policy to a specific user group you will need to tweak the HYCU configuration file, as this is not yet supported through UI:

- Create a backup policy/policies with the name of the HYCU internal user group as prefix.

  - For example, if the user group name is eng-grp, then the backup policy should be names as eng-grp_<policy_name>

- Once you’re done creating appropriate policies for the user group, SSH to hycu backup controller

  - Login using hycu | hycu/4u

- Navigate to /opt/grizzly

  - Open the following file using vi editor: config.properties

- Add the following option:

.. code-block:: powershell

    policies.group.specific.synchronized=true

- Restart the grizzly service:

.. code-block:: powershell

    services grizzly restart

#. Once done, members of each user group will see and be able to assign only policies which were configured for them.

   .. figure:: images/17.png

#. Lastly, start a backup of a Virtual machine/Share by assigning a policy to it. Users with Backup Operator or Administrator roles will also be able to configure credentials and discover and protect the applications. Users with Restore Operator and Administrator role will also have the ability to perform restore and granular file and application recovery.
