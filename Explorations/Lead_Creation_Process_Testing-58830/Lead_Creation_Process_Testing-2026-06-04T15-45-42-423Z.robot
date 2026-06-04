# Automatically generated from Exploration Lead Creation Process Testing (ID 58830) on Jun 4, 2026, 15:45:43 UTC. This is one time conversion.

# Generated from Exploration https://robotic.copado.com/explorations/58830/summary?projectId=57891&orgId=583&view=details

*** Settings ***
Metadata    Organization Id    583
Metadata    Project Id         57891
Metadata    Exploration Id     58830

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
    ClickText    New
    UseModal    On
    PickList    Salutation    Mr.
    TypeText    First Name    Michael
    TypeText    Last Name    McHugh
    # Please add an "open - contacted" option


    TypeText    *Company    Copado
    PickList    *Lead Status    Open - Not Contacted
    ClickText    Save    partial_match=False
    UseModal    Off
    VerifyText    was created.
    ClickText    Details
    VerifyField    Name    Mr. Michael McHugh    partial_match=True