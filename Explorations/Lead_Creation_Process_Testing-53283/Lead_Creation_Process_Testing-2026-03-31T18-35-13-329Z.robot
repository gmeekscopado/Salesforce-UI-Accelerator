# Automatically generated from Exploration Lead Creation Process Testing (ID 53283) on Mar 31, 2026, 18:35:13 UTC. This is one time conversion.

# Generated from Exploration https://robotic.copado.com/explorations/53283/summary?projectId=57891&orgId=583&view=details

*** Settings ***
Metadata    Organization Id    583
Metadata    Project Id         57891
Metadata    Exploration Id     53283

Documentation    Storage uses bidirectional GitHub Integration

# You can change imported library to "QWeb" if testing generic web application, not Salesforce.
Library                 QForce
Suite Setup             Open Browser    about:blank    chrome
Suite Teardown          Close All Browsers

*** Test Cases ***

Test case
    LaunchApp    Sales
    ClickText    Leads
    ClickText    New
    UseModal    On
    PickList    Salutation    Ms.
    TypeText    First Name    Tina
    TypeText    Last Name    Turner
    # Can we please add a "open - contacted" option?


    TypeText    *Company    Growmore
    PickList    *Lead Status    Open - Not Contacted
    ClickText    Save    partial_match=False
    UseModal    Off
    VerifyText    was created.
    ClickText    Details
    VerifyField    Name    Ms. Tina Turner    partial_match=True