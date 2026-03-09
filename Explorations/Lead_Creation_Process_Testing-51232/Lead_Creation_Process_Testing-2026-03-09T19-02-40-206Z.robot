# Automatically generated from Exploration Lead Creation Process Testing (ID 51232) on Mar 9, 2026, 19:02:40 UTC. This is one time conversion.

# Generated from Exploration https://robotic.copado.com/explorations/51232/summary?projectId=57891&orgId=583&view=details

*** Settings ***
Metadata    Organization Id    583
Metadata    Project Id         57891
Metadata    Exploration Id     51232

Documentation    Storage uses bidirectional GitHub Integration

# You can change imported library to "QWeb" if testing generic web application, not Salesforce.
Library                 QForce
Suite Setup             Open Browser    about:blank    chrome
Suite Teardown          Close All Browsers

*** Test Cases ***

Test case
    GoTo    https://login.salesforce.com
    LaunchApp    Sales
    ClickText    Leads
    ClickText    New
    UseModal    On
    PickList    Salutation    Mr.
    TypeText    First Name    Carlos
    TypeText    Last Name    Garcia
    # Can we add a "Open - Contacted" option?


    TypeText    *Company    Copado
    PickList    *Lead Status    Open - Not Contacted
    ClickText    Save    partial_match=False
    UseModal    Off
    VerifyText    was created.
    ClickText    Details
    VerifyField    Name    Mr. Carlos Garcia    partial_match=True