.. _protectingphysical:

----------------------------------------
HYCU: Physical Windows Server Protection
----------------------------------------

*The estimated time to complete this lab is 60 minutes.*

Overview
++++++++
HYCU 4.0 and later versions offers customers the option and ability to backup and protect physical Windows servers. Similar to application backup, HYCU will utilize patented technology allowing it to execute actions remotely, thus not requiring deployment or maintenance of any agents on the physical servers. Instead of agent based approach, HYCU performs VSS snapshot based full and incremental backups using custom change block tracking, allowing also for physical to virtual restoration.

.. note:: Even though HYCU does not integrate with HyperV hypervisor, it will still be able to perform full and incremental backups of HyperV VMs by treating them as Physical machines.

To start the backup of physical server, it first needs to be added as a source within HYCU.

#. To access the Sources dialog box, click *Administration* (the gear icon) and then select *Sources*

   .. figure:: images/1.png

#. In the Sources dialog box, click New

   .. figure:: images/2.png

   #. Enter a name for the physical Windows Server
   #. Enter the hostname or IP of the physical Windows Server
   #. Click *Save*

   .. figure:: images/3.png

   You may also use this same menu to edit any pre-existing physical Windows Servers by selecting Edit.
   If you need to delete any physical Windows Server Sources, select *Delete*.

   .. note:: Note: If you delete any physical Windows Servers from HYCU and re-add them later, HYCU will treat the newly created machine as a new source and, thus, no prior restore points will be available.  Therefore, exercise caution when deleting and re-adding these source servers.

#. Verify that you can now see the Physical Server listed under HYCU’s Virtual Machines menu

   .. figure:: images/4.png

#. Next, configure and assign credentials to the Physical server, allowing HYCU administrative access to the physical machine. Same as in Application lab, configure a set of credentials and assign them to the Physical server.

#. Click on *Credentials*, and add the Windows Local (or Domain) Admin credentials within HYCU by clicking +New and adding the Credentials (Name, Username, and Password)

   .. figure:: images/5.png

#. Assign the newly created credentials to the physical Windows Server(s)

   .. figure:: images/6.png

#. To begin backing up physical Windows Servers, you will need to assign a backup policy that explicitly utilizes an SMB target, other targets are not supported at this time.  If required, data can be copied to the via Copy and Archive policy options.

   .. figure:: images/7.png

#. Verify the policy is using an SMB target

   .. figure:: images/8.png

   The advantage of using SMB type of target is that the backup data is getting copied directly from the physical server to the respective SMB target, *not* going through the HYCU VM.
   Once policy is assigned, backup will get started and can be tracked via Jobs context. HYCU will perform a VSS based snapshot of all the disks and calculate non-zeroed/changed blocks to transfer to the target.

   .. figure:: images/9.png

#. If you need to troubleshoot, you may select the View Report Button (upper-right).

   When it comes to restoring a backup, you can perform single file/folder recovery or very seamlessly clone the full physical machine into the virtual environment. This can help with migration scenarios or can be use just for test and dev purposes. It is a feature often requiring specialized products where as in HYCU it is an integral part and comes with basic license. Bare-metal recovery needs to be performed using manual procedure.

   To clone the server into Nutanix AHV make sure you download and install the Nutanix VirtIO drivers before the backup. This can be done from `<https://support.nutanix.com>`_ (after logging in), under *Downloads* and Tools & Firmware.  Within *Tools & Firmware*, you will need to search for the Windows VirtIO drivers (this may require navigating to the third page of results, if you use the search capability.)

   .. figure:: images/10.png

   .. figure:: images/11.png

#. Within windows, ensure the Nutanix VirtIO drivers have been installed

   .. figure:: images/12.png

#. Once the full backup has completed successfully, begin the cloning process, by selecting the completed Full or incremental backup job and select *Restore VM*

   .. figure:: images/13.png

#. Select *Clone VM* and click *Next*

   .. figure:: images/14.png

#. Choose the cluster and a VM Storage Container on it

   .. figure:: images/15.png

#. Type in a *New VM Name* and select *Restore*

   .. figure:: images/16.png

#. Track the restore process in details through the Jobs view.

   .. figure:: images/17.png

#. Once the VM clone (restore) is complete, you will notice a warning stating that you will need to assign a new network adapter.

   .. figure:: images/18.png

#. You will see this message in *View Report*

   .. figure:: images/19.png

#. Login to your Nutanix Prism Element UI and verify the existence of the new cloned VM.  Add a NIC, configure a VLAN, provide an appropriate IP address, and login to test it out.

   More often than not in physical world, it is enough to recover just a single file or folder.
   To achieve this HYCU will need a staging area on one of the Virtual environments. In the Virtual Machines menu, click on a physical Windows Server and select *Prepare for Restore Files* to create a snapshot to use for a File-Level Restore. This may take little while for HYCU to rehydrate the data and establish a snapshot that can be used for a restore. Once done, *SNAP* tag will be visible on that restore point and simply click on the Restore Files.

   .. figure:: images/20.png

#. Navigate to the files you wish to restore and click Next

   .. figure:: images/21.png

#. Choose where you want to restore your files, click Next, and complete the rest of the process intuitively, according to your selection.

   .. figure:: images/22.png
