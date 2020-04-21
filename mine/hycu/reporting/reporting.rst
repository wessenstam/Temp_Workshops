.. _reporting:

----------------
HYCU: Reporting
----------------

*The estimated time to complete this lab is 60 minutes.*

Overview
++++++++
HYCU’s unique and powerful reporting runs on HYCU controller Virtual machine and does not require any additional infrastructure. This is a standard offering which is included as a part of HYCU’s base license. HYCU provides you all the basic options you would expect in a reporting tool, such as scheduling, delivery in various formats and ad-hoc exports. However, on top of this, HYCU reporting provides you with amazing flexibility of creating customer reports using practically every field from HYCUs internal database, combined with data filtering, time selection and various report types. Let’s now walk through each of these options

#. Login to HYCU as the admin user. In HYCU select > left panel > *Reports*

.. figure:: images/1.png

When you click on reports, you can actually view several out of the box backup reports ready to be used. You can select any report and click on the preview |preview| button to view the output of a given report. In this exercise, let’s preview the most commonly used backup reports – “VM backup status” report. This report details the backup status of all VMs in the last 24 hours.

.. |preview| image:: images/2.png

.. figure:: images/3.png

As you can see, this report has the following key details:
   - VM name
   - Backup completion status (OK for backup success; FATAL for backup failure)
   - Backup type (Incremental or FULL backup)
   - Backup policy
   - Backup duration with start time and end time
   - Amount of data transferred


You can export this report by clicking on little download icon  |download-icon| this will present you with the following options to export the report.

.. |download-icon| image:: images/4.png

.. figure:: images/5.png

Simplest way of creating a report to fit your needs is to edit an existing report. For instance, let’s take the same VM backup status report. You can edit that report to include additional information that provides more details of your backed up VMs, and let’s get the report for the last week instead of just 24 hours.
Under *Reports* > Click on “*VM backup status*” report > Click on the *Edit* button

This will provide a slightly different view of the report. On the left-hand side, you will be able to see most of the HYCUs metadata information, which you can use for reporting by drag & dropping it to X or Y axis.

.. figure:: images/6.png

Here, let’s drag and drop the following fields from the Report Tag Pool (on the left hand-side) to Y-AXIS TAGS in order to add more details into the report:
   - “Avg Change Rate” -> Right in between “Job duration” and “Size of backed up data” fields
      - This provides the data change rate between backups
   - “Compliancy Status” -> Right in between “Status” and “Backup Type” fields
      - This provides info on whether the backup job completed on time. You can have compliance status failed (status to RED) even if the backup job completes successfully.
   - “Owner” -> Right below “VM name” field
      - This provides you HYCU-user group who has explicit rights to backups on the given VM. This is direct reference to the Self-service section
   - “Target name” -> At the very end
      - This provides you backup target location of a given VM. We do have a separate report detailing the backup target information

Once you’re done adding the fields this is how your Y-AXIS TAGS would look like:

.. figure:: images/7.png

From the dropdown in the upper row select the 1 week time instead of 24 hours and simply change the name of the report on the top-left hand side of the screen to create a new report

.. figure:: images/8.png

Click on “*Save As*” on the top right-hand side of the screen to save the newly created report

You should be able to view the saved report under the *Reports* section. Click *Generate* to generate the report at that exact time, using current HYCU data which is residing in HYCU’s reporting database. HYCU’s reporting database is getting synchronized with the main database every 12 hours.

With HYCU, you can also schedule any backup report on a regular basis to generate a historical set of reports allowing you to have insight into the product over period of time. In order not to lose any data in the reports, make sure reporting schedule is shorter than the shortest retention set in the HYCU policies.

Let’s click on our newly created report “*VM backup status detailed*” > Click on the *Scheduler*

.. figure:: images/9.png

Choose Daily under the Interval dropdown and enable the “*SEND*” toggle switch

.. figure:: images/10.png

This will enable you to email the reports that get generated in PDF, PNG or CSV formats. Specify desired email address and click *Schedule*. In order to email the report, you will need to configure the SMTP settings from the HYCU Administration menu.

In case you have multiple HYCU’s or you want to share your custom built report with community, HYCU also allows you export and import your favorite backup reports. For instance, if you wanted to use the newly created report “*VM backup status detailed*” in another HYCU controller, you will have to perform the following steps:

- On the source HYCU backup controller:
  - Navigate to Reports
  - Simply click on the “VM backup status detailed” report and click on “Export” on the top left-hand side of the screen. This will export the report configuration in JSON format and download it locally to your computer.
- On the destination HYCU backup controller:
  - Navigate to Reports
  - Click on the “import” button

  .. figure:: images/11.png

  - Click on the “*Browse*” button to add the newly imported JSON file from the source HYCU backup controller:

  .. figure:: images/12.png

- As you can see, HYCU can recognize the report your importing in as it automatically fills in the name and the report description
- Click on the “*Import*” button to import the report on the destination HYCU controller

HYCU can also help you in creating brand new custom reports to fit your exact needs. Unlike editing existing reports, in this exercise, we’ll be creating a brand-new report from scratch.

Report 1 – Target utilization per source
========================================

In this report, our goal is to create a high-level information on how our backup targets are being utilized from backup sources (which includes hypervisors, Nutanix files and physical hosts)

- Navigate to *Reports*
- Click on *New*
  - This will show case the entire reporting schema
- Simply clear the X-AXIS TAGS and Y-AXIS TAGS.
  - Click on the clear button as shown below

  .. figure:: images/13.png

  .. figure:: images/14.png

  .. figure:: images/15.png

- Under the report type, choose “Stacked bar chart”
- On the X-AXIS TAGS, choose “Target Name” and on Y-AXIS TAGS, choose “source Name”
- This is how the end-report would look like:

.. figure:: images/16.png

- Provide a name to the report under the *NAME* field and click on *Save*

Report 2 – VM backup size per target for specific User Group
============================================================

The goal of this report is to provide a VM backup target utilization in a graphical view. To spice it up we will make the report for a single HYCU tenant User Group which is perfect for service providers looking for a way to see how one of their customers is utilizing the targets, and potentially even bill on top of this.

- Navigate to Reports
  - Click on *New*
  - This will show case the entire reporting schema
- Simply clear the X-AXIS TAGS and Y-AXIS TAGS.
  - Click on the clear button as shown below

  .. figure:: images/13.png

  .. figure:: images/14.png

  .. figure:: images/15.png

- Under the report type, choose “Horizontal Stacked bar chart”
- On the X-AXIS TAGS, choose “VM Name”, “Size of Backed up Data” and on Y-AXIS TAGS, choose “target Name” and “Owner”
- On the X-AXIS TAGS select Owner dropdown and select only a single User Group
- This is how the end-report would look like:

  .. figure:: images/17.png

- Provide a name to the report under the *NAME* field and click on *Save*
