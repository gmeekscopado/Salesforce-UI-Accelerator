# Automatically generated from Exploration Lead Generation Process Testing (ID 57774) on May 21, 2026, 16:29:41 UTC. This is one time conversion.

# Generated from Exploration https://robotic.copado.com/explorations/57774/summary?projectId=57891&orgId=583&view=details

*** Settings ***
Metadata    Organization Id    583
Metadata    Project Id         57891
Metadata    Exploration Id     57774

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
    TypeText    Verification Code    378856\n
    LaunchApp    Sales
    UseModal    On
    UseModal    On
    GoTo    https://copado-9d-dev-ed.develop.lightning.force.com/lightning/page/home
    UseModal    On
    LaunchApp    Leads
    ClickText    New
    UseModal    On
    PickList    Salutation    Mr.
    TypeText    First Name    Devon
    TypeText    Last Name    Montgomery
    # Please add an "open - contacted" option


    TypeText    *Company    Copado
    PickList    *Lead Status    Open - Not Contacted
    ClickText    Save    partial_match=False
    UseModal    Off
    VerifyText    as created.
    ClickText    Details
    VerifyField    Name    Mr. Devon Montgomery    partial_match=True