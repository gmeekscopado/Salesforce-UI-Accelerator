# Automatically generated from Exploration Lead Creation Process Testing (ID 59431) on Jun 11, 2026, 22:16:58 UTC. This is one time conversion.

# Generated from Exploration https://robotic.copado.com/explorations/59431/summary?projectId=57891&orgId=583&view=details

*** Settings ***
Metadata    Organization Id    583
Metadata    Project Id         57891
Metadata    Exploration Id     59431

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
    TypeText    Verification Code    618062\n
    TypeText    Quick Find    sales
    LaunchApp    Sales
    ClickText    Leads
    ClickText    New
    UseModal    On
    PickList    Salutation    Mr.
    TypeText    First Name    John
    TypeText    Last Name    Katich
    # Please add an "open -  contacted" option!


    TypeText    *Company    Copado
    PickList    *Lead Status    Open - Not Contacted
    ClickText    Save    partial_match=False
    UseModal    Off
    VerifyText    was created.
    ClickText    Details
    VerifyField    Name    Mr. John Katich    partial_match=True