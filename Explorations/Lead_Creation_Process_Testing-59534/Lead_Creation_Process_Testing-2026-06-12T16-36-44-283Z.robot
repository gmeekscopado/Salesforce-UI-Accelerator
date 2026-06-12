# Automatically generated from Exploration Lead Creation Process Testing (ID 59534) on Jun 12, 2026, 16:36:44 UTC. This is one time conversion.

# Generated from Exploration https://robotic.copado.com/explorations/59534/summary?projectId=57891&orgId=583&view=details

*** Settings ***
Metadata    Organization Id    583
Metadata    Project Id         57891
Metadata    Exploration Id     59534

Documentation    Storage uses bidirectional GitHub Integration

# You can change imported library to "QWeb" if testing generic web application, not Salesforce.
Library                 QForce
Suite Setup             Open Browser    about:blank    chrome
Suite Teardown          Close All Browsers

*** Test Cases ***

Test case
    GoTo    https://login.salesforce.com
    TypeText    Username    gmeeks+developer@copado.com
    TypeSecret    Password    [enter password here]
    TypeText    Verification Code    211677\n
    LaunchApp    Sales
    ClickText    Leads
    ClickText    New
    UseModal    On
    PickList    Salutation    Prof.
    TypeText    First Name    Kelly
    TypeText    Last Name    Reyna
    # Please add an "open - contacted" option


    TypeText    *Company    UNT
    PickList    *Lead Status    Open - Not Contacted
    ClickText    Save    partial_match=False
    UseModal    Off
    VerifyText    was created.
    ClickText    Details
    VerifyField    Name    Prof. Kelly Reyna    partial_match=True