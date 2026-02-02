# Automatically generated from Exploration Contact Creation Process (ID 48591) on Feb 2, 2026, 17:27:27 UTC. This is one time conversion.

# Generated from Exploration https://robotic.copado.com/explorations/48591/summary?projectId=57891&orgId=583&view=details

*** Settings ***
Metadata    Organization Id    583
Metadata    Project Id         57891
Metadata    Exploration Id     48591

Documentation    Storage uses bidirectional GitHub Integration

# You can change imported library to "QWeb" if testing generic web application, not Salesforce.
Library                 QForce
Suite Setup             Open Browser    about:blank    chrome
Suite Teardown          Close All Browsers

*** Test Cases ***

Test case
    LaunchApp    Sales
    ClickText    Contacts
    ClickText    New
    UseModal    On
    PickList    Salutation    Dr.
    # Please make the "web" option more detailed: i.e. Search Engine, AI, website


    TypeText    Last Name    Shaboygan
    PickList    Lead Source    Web
    ClickText    Save    partial_match=False
    UseModal    Off
    VerifyText    was created