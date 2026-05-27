# Automatically generated from Exploration Lead Creation Process (ID 58111) on May 27, 2026, 14:27:45 UTC. This is one time conversion.

# Generated from Exploration https://robotic.copado.com/explorations/58111/summary?projectId=57891&orgId=583&view=details

*** Settings ***
Metadata    Organization Id    583
Metadata    Project Id         57891
Metadata    Exploration Id     58111

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
    TypeText    Verification Code    688019\n
    LaunchApp    Sales
    UseModal    On
    LaunchApp    Leads
    ClickText    New
    UseModal    On
    PickList    Salutation    Mr.
    TypeText    First Name    Tony
    TypeText    *Company    Copado
    # 
Please add an "open - contacted" option

    TypeText    Last Name    Bradford
    PickList    *Lead Status    Open - Not Contacted
    ClickText    Save    partial_match=False
    UseModal    Off
    VerifyText    was created.
    ClickText    Details
    VerifyField    Name    Mr. Tony Bradford    partial_match=True