# Automatically generated from Exploration Create a new Lead (ID 51054) on Mar 6, 2026, 18:50:12 UTC. This is one time conversion.

# Generated from Exploration https://robotic.copado.com/explorations/51054/summary?projectId=57891&orgId=583&view=details

*** Settings ***
Metadata    Organization Id    583
Metadata    Project Id         57891
Metadata    Exploration Id     51054

Documentation    Storage uses bidirectional GitHub Integration

# You can change imported library to "QWeb" if testing generic web application, not Salesforce.
Library                 QForce
Suite Setup             Open Browser    about:blank    chrome
Suite Teardown          Close All Browsers

*** Test Cases ***

Test case
    ClickText    New
    UseModal    On
    LaunchApp    Leads
    PickList    Salutation    Mr.
    TypeText    First Name    Ike
    TypeText    Last Name    Chafkin
    # There is no "Open - Not Working" option


    TypeText    *Company    Copado
    PickList    *Lead Status    Open - Not Contacted
    ClickText    Save    partial_match=False
    UseModal    Off
    VerifyText    was created.