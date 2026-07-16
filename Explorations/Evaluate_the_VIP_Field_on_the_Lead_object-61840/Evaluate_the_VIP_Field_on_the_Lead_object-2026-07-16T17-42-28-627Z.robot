# Automatically generated from Exploration Evaluate the VIP Field on the Lead object (ID 61840) on Jul 16, 2026, 17:42:28 UTC. This is one time conversion.

# Generated from Exploration https://robotic.copado.com/explorations/61840/summary?projectId=57891&orgId=583&view=details

*** Settings ***
Metadata    Organization Id    583
Metadata    Project Id         57891
Metadata    Exploration Id     61840

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
    PickList    Salutation    Mr.
    TypeText    First Name    Blake
    TypeText    Last Name    Jarvis
    PickList    *Lead Status    Nurturing
    TypeText    *Company    Copado
    # This should be a checkbox, not a text field.


    VerifyText    VIP
    ClickText    Save    partial_match=False
    UseModal    Off
    ClickText    Details
    VerifyField    Name    Mr. Blake Jarvis    partial_match=True