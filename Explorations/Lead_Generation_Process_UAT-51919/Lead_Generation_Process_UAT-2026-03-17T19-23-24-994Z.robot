# Automatically generated from Exploration Lead Generation Process UAT (ID 51919) on Mar 17, 2026, 19:23:25 UTC. This is one time conversion.

# Generated from Exploration https://robotic.copado.com/explorations/51919/summary?projectId=57891&orgId=583&view=details

*** Settings ***
Metadata              Organization Id             583
Metadata              Project Id                  57891
Metadata              Exploration Id              51919

Documentation         Storage uses bidirectional GitHub Integration

# You can change imported library to "QWeb" if testing generic web application, not Salesforce.
Library               QForce
Resource              ../resources/common.robot
Suite Setup           Open Browser                about:blank             chrome
Suite Teardown        Close All Browsers

*** Test Cases ***

Test case
    Appstate          Home
    ClickText         Leads
    LaunchApp         Sales
    ClickText         New
    UseModal          On
    PickList          Salutation                  Mr.
    TypeText          First Name                  Devon
    TypeText          Last Name                   Montgomery
    TypeText          *Company                    Copado
    # Can we add in an "Open - Contacted" option?


    VerifyPickList    *Lead Status                *
    PickList          *Lead Status                Open - Not Contacted
    ClickText         Save                        partial_match=False
    UseModal          Off
    VerifyText        was created.
    ClickText         Details
    VerifyField       Name                        Mr. Devon Montgomery    partial_match=True