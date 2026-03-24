# Automatically generated from Exploration Exploratory Testing (ID 52601) on Mar 24, 2026, 18:34:37 UTC. This is one time conversion.

# Generated from Exploration https://robotic.copado.com/explorations/52601/summary?projectId=57891&orgId=583&view=details

*** Settings ***
Metadata    Organization Id    583
Metadata    Project Id         57891
Metadata    Exploration Id     52601

Documentation    Storage uses bidirectional GitHub Integration

# You can change imported library to "QWeb" if testing generic web application, not Salesforce.
Library                 QForce
Suite Setup             Open Browser    about:blank    chrome
Suite Teardown          Close All Browsers

*** Test Cases ***

Test case
    Appstate    Home
    ClickText    Leads
    ClickText    New
    UseModal    On
    PickList    Salutation    Mr.
    TypeText    First Name    Anthony
    TypeText    Last Name    Winbush
    # Please add an "Open - Contacted" option


    TypeText    *Company    Copado
    PickList    *Lead Status    Open - Not Contacted
    ClickText    Save    partial_match=False
    UseModal    Off
    VerifyText    was created.
    ClickText    Details
    VerifyField    Name    Mr. Anthony Winbush    partial_match=True