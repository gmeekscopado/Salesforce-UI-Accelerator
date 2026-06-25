# Automatically generated from Exploration Lead Creation Process Testing (ID 60440) on Jun 25, 2026, 20:20:59 UTC. This is one time conversion.

# Generated from Exploration https://robotic.copado.com/explorations/60440/summary?projectId=57891&orgId=583&view=details

*** Settings ***
Metadata    Organization Id    583
Metadata    Project Id         57891
Metadata    Exploration Id     60440

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
    ClickText    Log In
    TypeText    Verification Code    359616\n
    ClickText    Leads
    LaunchApp    Sales
    ClickText    New
    UseModal    On
    PickList    Salutation    Mr.
    TypeText    First Name    John
    TypeText    Last Name    Smith
    # Please add an "open - contacted" option!


    TypeText    *Company    Copado
    ClickText    Save    partial_match=False
    UseModal    Off
    VerifyText    was created.
    ClickText    Details
    VerifyField    Name    Mr. John Smith    partial_match=True