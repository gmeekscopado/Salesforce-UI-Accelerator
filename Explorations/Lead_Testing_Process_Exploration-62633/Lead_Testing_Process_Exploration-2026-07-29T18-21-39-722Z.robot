# Automatically generated from Exploration Lead Testing Process Exploration (ID 62633) on Jul 29, 2026, 18:21:39 UTC. This is one time conversion.

# Generated from Exploration https://robotic.copado.com/explorations/62633/summary?projectId=57891&orgId=583&view=details

*** Settings ***
Metadata    Organization Id    583
Metadata    Project Id         57891
Metadata    Exploration Id     62633

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
    TypeText    Verification Code    190792\n
    LaunchApp    Sales
    ClickText    Leads
    ClickText    New
    UseModal    On
    PickList    Salutation    Mr.
    TypeText    First Name    Jacob
    TypeText    Last Name    Marks
    # Please add an "Open - Contacted" picklist option


    TypeText    *Company    IBM
    PickList    *Lead Status    Open - Not Contacted
    ClickText    Save    partial_match=False
    UseModal    Off
    VerifyText    was created
    ClickText    Details
    VerifyField    Name    Mr. Jacob Marks    partial_match=True