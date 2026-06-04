# Automatically generated from Exploration Lead Intake Process Testing (ID 58844) on Jun 4, 2026, 19:00:35 UTC. This is one time conversion.

# Generated from Exploration https://robotic.copado.com/explorations/58844/summary?projectId=57891&orgId=583&view=details

*** Settings ***
Metadata    Organization Id    583
Metadata    Project Id         57891
Metadata    Exploration Id     58844

Documentation    Storage uses bidirectional GitHub Integration

# You can change imported library to "QWeb" if testing generic web application, not Salesforce.
Library                 QForce
Suite Setup             Open Browser    about:blank    chrome
Suite Teardown          Close All Browsers

*** Test Cases ***

Test case
    GoTo    https://login.salesforce.com
    TypeText    Username    gmeeks+developer@copado.com
    VerifyText    ••••••••••
    TypeSecret    Password    [enter password here]
    ClickText    Log In
    TypeText    Verification Code    107457\n
    VerifyText    107457
    TypeText    Verification Code    974921\n
    LaunchApp    Sales
    ClickText    Leads
    ClickText    New
    UseModal    On
    PickList    Salutation    Mr.
    TypeText    First Name    Garrett
    TypeText    Last Name    Meeks
    # Can you add an "open - contacted" option?


    TypeText    *Company    Copado
    PickList    *Lead Status    Open - Not Contacted
    ClickText    Save    partial_match=False
    UseModal    Off
    VerifyText    was created.
    ClickText    Details
    VerifyField    Name    Mr. Garrett Meeks    partial_match=True