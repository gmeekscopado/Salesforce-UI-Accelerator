# Automatically generated from Exploration Lead Generation Exploration Session (ID 55754) on Apr 23, 2026, 18:33:55 UTC. This is one time conversion.

# Generated from Exploration https://robotic.copado.com/explorations/55754/summary?projectId=57891&orgId=583&view=details

*** Settings ***
Metadata    Organization Id    583
Metadata    Project Id         57891
Metadata    Exploration Id     55754

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
    ClickText    Leads
    LaunchApp    Sales
    ClickText    New
    UseModal    On
    VerifyText    Lead Information
    PickList    Salutation    Mr.
    TypeText    First Name    Ike
    TypeText    Last Name    Chafkin
    # Please add an "open - contacted" option


    TypeText    *Company    Copado
    PickList    *Lead Status    Open - Not Contacted
    ClickText    Save    partial_match=False
    UseModal    Off
    VerifyText    Lead\nMr. Ike Chafkin\nTitle\n\nCompany\n\nCopado\n\nEmail\n\nPath\nTabs\nTabs\nActivity\nDetails\nChatter\nActivity Publisher\nActivity Timeline\nSkip to the bottom of the activity timeline\nFilters: All time • All activities • All types\n • • \nNo activities to show.\nGet started by sending an email, scheduling a task, and more.\ninformation\nTo change what's shown, try changing your filters.\n\nSkip to the top of the activity timeline\nTabs\nTabs\nRelated\nWe found no potential duplicates of this Lead.\n\nCampaign History\n(0)