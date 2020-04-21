.. _protectingapps:

-----------------------------------
HYCU: Protecting Applications (SQL)
-----------------------------------

*The estimated time to complete this lab is 60 minutes.*

Overview
++++++++
HYCU has a very unique ability to protect applications without requiring deployment or maintenances of agents on the client virtual machines. HYCU will discover what applications are running in the environment as well as protect them in the most appropriate manner using application consistent backups. This enables customers to focus on their applications instead of the virtual machines requiring many configuration steps to perform adequate backup. In this lab we will use SQL Server but the same principles are used to backup and recover other applications.

Assigning credentials
=====================

#. Let’s start by selecting the VM that has SQL Server installed and then select *Credentials* in the upper right corner of the HYCU UI.

#. Once the credentials screen appears, then add the credentials (using *+New*) for the SQL server. It is required that the credentials have sysadmin privileges on the VM.

#. Once the credentials are entered, click *Assign* to assign the credentials to the VM and start the discovery process.

   .. figure:: images/1.png

#. Note that when assigning the credentials, the discovery is automatically launched. Discovery will use WinRM on windows and SSH on Linux VMs.

   .. figure:: images/2.png

   .. figure:: images/3.png

#. In most of the cases, based on machine defaults, discovery will succeed without any additional steps required. In case of failure, it will be simplest to troubleshoot using the `following KB <https://support.hycu.com/hc/en-us/articles/115003880025-Troubleshooting-Application-discovery-failed-Windows->`_.

#. Once discovery has completed, select Applications on the left side of the HYCU UI and you will see the SQL instance appear.  Select this instance by clicking on the name and you will notice a window appear in the lower left corner of the screen.  This window has details about the application instance.

   .. figure:: images/4.png

#. Note that the discovery icon for the selected SQL application is marked green. This means that the provided credentials had the required backup admin privileges on the SQL database. If this had not been the case, we would have needed to configure a different OS user which has these permissions. This can be achieved by clicking on *Configuration*, specifying the toggle “Use VM credentials with access to the application” and entering them.

   .. figure:: images/5.png

#. Note also two other very important options:

   .. figure:: images/6.png

#. If customers are taking care of log truncation on their own, which usually done to truncate logs on 15 minute intervals, HYCU needs to be made aware of this so it does not truncate the logs. You can disable HYCU log truncation using the “Backup and truncate SQL transction logs” toggle. If this options is configured, note that HYCU will leave the database in recovery mode after restore, so manually backed up logs can be applied to it.

   .. figure:: images/7.png

   When performing a backup, HYCU will trigger a SQL log backup which will copy the logs to a temporary location. These logs will be backed up as part of VM snapshot and truncated at the end. It is a best practice to keep these logs on a separate disk and specify the path to it. This will enable Faster point in time recovery as HYCU will be able to recover just the disk holding the logs.

#. Exit out of this screen without making any changes.

#. Select Policies in the top right corner of the UI to assign a policy to the application to start the backups.  For this exercise, apply the Gold policy.

   .. figure:: images/8.png

#. Once the policy is applied, the backup will start automatically.

   .. figure:: images/9.png

   By double-clicking on the green job progress bar, HYCU will bring up the Jobs page and display the job details.  You will be able to follow all the steps HYCU is taking to perform an application consistent backup. In short, HYCU will quiesce the databases to assure their consistency, snapshot the VM (whcih includes all of the disks) and unfreeze the database afterwards. After backing up the changed blocks using the CBT API, it will also truncate the logs (unless specified differently).

   .. figure:: images/10.png

#. Once the backup is completed, clear the filter by clicking on the X in the search box at the top of the screen

   .. figure:: images/11.png

#. Select the Application pane (left hand side of the HYCU UI) and then select the SQL instance.  You will notice that the job is complete and the backup status is green.  By hovering your cursor over the green status button you will see that the backup was application consistent and how long it took to perform a full backup.

   .. figure:: images/12.png

#. Manually launch another backup of this SQL instance by selecting “Backup” at the top right center of the UI.  A window will pop up asking if you want to perform a full backup.  Do not select the full backup option as we want to perform an incremental.

   .. figure:: images/13.png

   Note that incremental was much faster.

Restoring SQL Server
====================
To restore a complete SQL Server VM, its instance or a single DB, select the application and then select the backup you wish to use for the restore.  For this exercise, let’s select the full backup and click on Restore (center right on the screen). Since application backup is backing up the complete virtual machine by snapshotting all the disks, you can restore the whole server. The same can be achieved from the Virtual Machines context, where you can use the same app backups also for a single file or folder recovery.

#. For this lab, let’s focus on granular SQL recovery by selecting *Restore databases* and clicking *Next*

   .. figure:: images/14.png

   .. figure:: images/15.png

#. Now you will see that you have the option to restore the entire instance or an individual database.  If you select the entire instance, all databases will be restored.

   .. figure:: images/16.png

   HYCU restore gives you an abundance of recovery options, let’s explore different use cases.

#. For moving production data into a Dev/Test SQL instance you can use *Target Instance* dropdown menu to select a different SQL instance.  In this lab, we do not have a separate SQL instance, but the screen shot below shows how this can be done if you have more than one SQL instance in your Nutanix environment which has been discovered by HYCU.

   .. figure:: images/17.png

#. More than often in case of database corruption or human error, customers need to go back into exact point in time before the accident occurred. HYCU will restore the logs from the subsequent restore point (remember the importance of temporary log location kept separate) and replay them to the specified point in time.

   .. figure:: images/18.png

#. To achieve this simply select the individual database, specify the desired *Point in time* and click *Next*.

#. Following menu gives you an ability not to overwrite the database, but restore it under a different name (prefix) and location. This can be useful for testing purposes but can also give you the ability to extract a single table from a database restored to a temporary location.

   .. figure:: images/19.png

#. In this case let’s simply perform overwrite restore by clicking *Restore*.

Summary
=======
You have now completed the exercise of backing up and recovering a standard SQL instance.  HYCU can also backup and recover AlwaysOn SQL as well as SQL Failover Clusters.
HYCU can also backup and perform granular recovery for Microsoft Exchange incl. DAG (database and mailbox level recovery) and for Oracle (tablespace level recovery).
For AD, HYCU can perform application consistent backups, for granular recovery it is recommended to simply use AD recycle bin.  Restores of AD VMs is performed using non-authoritative restores.  Once the AD VM is restored and joined back into the domain, it will synchronize with the domain.  To perform and authoritative restore please reach out to HYCU support.
For up to date list of application integrations check out latest HYCU compatibility matrix at support.hycu.com. Bear in mind that even if HYCU does not integrate directly with an application, application consistent backup can be achieved through pre and post exec scripts.
