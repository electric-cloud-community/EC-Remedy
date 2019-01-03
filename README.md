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

Get Remedy incident details.

## CreateIncident

Creates Remedy incident.

## UpdateIncident

Updates Remedy incident.

## PollEntry

Polls Remedy entry until it gets to the desired status

## PollIncident

Polls Remedy Incident until it gets to the desired status

## PollChangeRequest

Polls Remedy Change Request until it gets to the desired status

## Create Change Request

Creates Remedy Change Request.

## UpdateChangeRequest

Updates Remedy change request.

## GetEntry

Fetches Remedy entry with the specified form name and entry ID



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
