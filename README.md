# EC-Remedy

This plugin allows to work with REST API of BMC Remedy System.


# Procedures

## CreateEntry

Creates Remedy entry.

## QueryEntries

Retrieves a list of Remedy entries.

## UpdateEntry

Updates Remedy entry.

## GetIncidentStatus

Retrieves a list of Remedy entries.

## CreateIncident

Creates Remedy incident.

## UpdateIncident

Updates Remedy incident.

## Create Change Request

Creates Remedy Change Request.



# Building the plugin
1. Download or clone the EC-Remedy repository.

    ```
    git clone https://github.com/electric-cloud/EC-Remedy.git
    ```

5. Zip up the files to create the plugin zip file.

    ```
     cd EC-Remedy
     zip -r EC-Remedy.zip ./*
    ```

6. Import the plugin zip file into your ElectricFlow server and promote it.
