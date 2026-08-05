# Automatically generated from Exploration Lead Creation Process Testing (ID 62929) on Aug 5, 2026, 20:25:13 UTC. This is one time conversion.

# Generated from Exploration https://robotic.copado.com/explorations/62929/summary?projectId=57891&orgId=583&view=details

*** Settings ***
Metadata    Organization Id    583
Metadata    Project Id         57891
Metadata    Exploration Id     62929

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
    LaunchApp    Sales
    ClickText    Leads
    UseModal    On
    ClickText    New
    PickList    Salutation    Mr.
    TypeText    First Name    Robin
    TypeText    Last Name    Hood
    # Please add an "Open - Contacted" option


    TypeText    *Company    Forest
    PickList    *Lead Status    Open - Not Contacted
    ClickText    Save    partial_match=False
    UseModal    Off
    VerifyText    was created.
    ClickText    Details
    VerifyField    Name    Mr. Robin Hood    partial_match=True