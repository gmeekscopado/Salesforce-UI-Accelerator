# NOTE: readme.txt contains important information you need to take into account
# before running this suite.
#
# DYNAMIC DATA GENERATION VERSION
# This version uses FakerLibrary to generate realistic test data dynamically
# Install requirement: pip install robotframework-faker

*** Settings ***
Resource                        ../resources/common.robot
Suite Setup                     Setup Suite With Dynamic Data
Suite Teardown                  End suite

*** Test Cases ***
Entering A Lead
    [Documentation]             Creates a new lead with dynamically generated data
    [tags]                      Lead
    Appstate                    Home
    LaunchApp                   ${APP_SALES}
    ClickText                   Leads
    VerifyText                  Change Owner
    ClickText                   New
    UseModal                    On                          # Only find fields from open modal dialoge
    VerifyText                  Lead Information

    Picklist                    Salutation                  ${LEAD_SALUTATION}
    TypeText                    First Name                  ${LEAD_FIRST_NAME}
    TypeText                    Last Name                   ${LEAD_LAST_NAME}
    Picklist                    Lead Status                 ${LEAD_STATUS}
    
    TypeText                    Phone                       ${LEAD_PHONE}               First Name
    TypeText                    Company                     ${ACCOUNT_NAME}             Last Name
    TypeText                    Title                       ${LEAD_TITLE}               Address Information
    TypeText                    Email                       ${LEAD_EMAIL}               Rating
    TypeText                    Website                     ${ACCOUNT_WEBSITE}
    PickList                    Lead Source                 Web
    TypeText                    Zip/Postal Code             ${LEAD_ZIP_CODE}
    PickList                    Product Interest            ${LEAD_PRODUCT_INTEREST}
    Picklist                    Lead Source                 ${LEAD_SOURCE}
    ClickText                   Save                        partial_match=False
    UseModal                    Off
    Sleep                       1

    ClickText                   Details
    VerifyField                 Name                        ${LEAD_FULL_NAME}
    VerifyField                 Lead Status                 ${LEAD_STATUS}
    VerifyField                 Phone                       ${LEAD_PHONE}
    VerifyField                 Company                     ${ACCOUNT_NAME}
    VerifyField                 Website                     ${ACCOUNT_WEBSITE}

    # As an example, let's check Phone number format. Should be "+" and 14 numbers
    ${phone_num}=               GetFieldValue               Phone
    Should Match Regexp         ${phone_num}                ^[+]\\d{14}$

    ClickText                   Leads
    VerifyText                  ${LEAD_FIRST_NAME} ${LEAD_LAST_NAME}
    VerifyText                  ${LEAD_TITLE}
    VerifyText                  ${ACCOUNT_NAME}


Converting A Lead To Opportunity-Account-Contact
    [Documentation]             Converts the created lead to opportunity, account, and contact
    [tags]                      Lead.Conversion
    Appstate                    Home
    LaunchApp                   ${APP_SALES}

    ClickText                   Leads
    ClickText                   ${LEAD_FIRST_NAME} ${LEAD_LAST_NAME}

    ClickUntil                  Convert Lead                Convert
    ClickText                   Opportunity                 2
    TypeText                    Opportunity Name            ${OPPORTUNITY_NAME}
    ClickText                   Convert                     2
    VerifyText                  Your lead has been converted                            timeout=30

    ClickText                   Go to Leads
    ClickText                   Opportunities
    VerifyText                  ${OPPORTUNITY_NAME}
    ClickText                   Accounts
    VerifyText                  ${ACCOUNT_NAME}
    ClickText                   Contacts
    VerifyText                  ${LEAD_FIRST_NAME} ${LEAD_LAST_NAME}


Creating An Account
    [Documentation]             Creates a new account with dynamically generated data
    [tags]                      Account
    Appstate                    Home
    LaunchApp                   ${APP_SALES}

    ClickText                   Accounts
    ClickUntil                  Account Information         New

    TypeText                    Account Name                ${ACCOUNT_NAME}             anchor=Parent Account
    TypeText                    Phone                       ${ACCOUNT_PHONE}            anchor=Fax
    TypeText                    Fax                         ${ACCOUNT_FAX}
    TypeText                    Website                     ${ACCOUNT_WEBSITE}
    Picklist                    Type                        ${ACCOUNT_TYPE}
    Picklist                    Industry                    ${ACCOUNT_INDUSTRY}

    TypeText                    Employees                   ${ACCOUNT_EMPLOYEES}
    TypeText                    Annual Revenue              ${ACCOUNT_REVENUE}
    ClickText                   Save                        partial_match=False

    ClickText                   Details
    VerifyField                 Account Name                ${ACCOUNT_NAME}
    VerifyField                 Employees                   35,000


Create A Case on an Account
    [Documentation]             Creates a case associated with the account and contact
    [tags]                      Account.Case
    Appstate                    Home
    LaunchApp                   ${APP_SALES}
    ClickText                   Cases List
    ClickText                   New Case

    UseModal                    On
    PickList                    *Status                     ${CASE_STATUS}
    PickList                    *Case Origin                ${CASE_ORIGIN}
    ComboBox                    Search Contacts...          ${LEAD_FIRST_NAME} ${LEAD_LAST_NAME}
    ComboBox                    Search Accounts...          ${ACCOUNT_NAME}                 index=1
    PickList                    Type                        ${CASE_TYPE}
    PickList                    Case Reason                 ${CASE_REASON}
    ClickText                   Save                        partial_match=false
    UseModal                    Off
    VerifyText                  was created.


Creating An Opportunity For The Account
    [Documentation]             Creates an opportunity for the account
    [tags]                      Account.Opportunity
    Appstate                    Home
    LaunchApp                   ${APP_SALES}
    ClickText                   Accounts
    VerifyText                  ${ACCOUNT_NAME}
    VerifyText                  Opportunities

    ClickUntil                  Stage                       Opportunities
    ClickUntil                  Opportunity Information     New
    TypeText                    Opportunity Name            ${OPPORTUNITY_NAME}         anchor=Cancel               delay=2
    Combobox                    Search Accounts...          ${ACCOUNT_NAME}
    Picklist                    Type                        ${OPPORTUNITY_TYPE}
    ClickText                   Close Date                  Opportunity Information
    ClickText                   Next Month
    ClickText                   Today

    Picklist                    Stage                       ${OPPORTUNITY_STAGE}
    TypeText                    Amount                      ${OPPORTUNITY_AMOUNT}
    Picklist                    Lead Source                 ${LEAD_SOURCE}
    TypeText                    Next Step                   ${OPPORTUNITY_NEXT_STEP}
    TypeText                    Description                 ${OPPORTUNITY_DESCRIPTION}
    ClickText                   Save                        partial_match=False         # Do not accept partial match, i.e. "Save All"

    Sleep                       1
    ClickText                   Opportunities
    VerifyText                  ${OPPORTUNITY_NAME}


Change status of opportunity
    [Documentation]             Changes the opportunity status and adds contact role
    [tags]                      Opportunity.Status
    Appstate                    Home
    ClickText                   Opportunities
    VerifyPageHeader            Opportunities
    ClickText                   ${OPPORTUNITY_NAME}         delay=2                     # intentionally delay action - 2 seconds
    VerifyText                  Contact Roles
    ClickText                   Show actions for Contact Roles
    # ClickText                 Show more actions           anchor=Contact Roles
    ClickText                   Add Contact Roles
    UseModal                    On

    # Verify all following texts from the dialog that opens
    VerifyAll                   Cancel, Show Selected, Name, Add Contact Roles
    ComboBox                    Search Contacts...          ${LEAD_FIRST_NAME} ${LEAD_LAST_NAME}
    ClickText                   Next                        delay=3
    ClickText                   Edit Role: Item
    PickList                    Role                        ${CONTACT_ROLE}
    ClickText                   Save                        partial_match=False
    VerifyText                  ${LEAD_FIRST_NAME} ${LEAD_LAST_NAME}

    ClickText                   Mark Stage as Complete
    ClickText                   Opportunities               delay=2
    ClickText                   ${OPPORTUNITY_NAME}
    ClickText                   Details
    VerifyStage                 Qualification               true
    VerifyStage                 Prospecting                 false
    VerifyStageColor            Qualification               navy
    VerifyStageColor            Prospecting                 green


Create A Contact For The Account
    [Documentation]             Creates an additional contact for the account
    [tags]                      Account.Contact
    Appstate                    Home
    LaunchApp                   ${APP_SALES}
    ClickText                   Accounts
    VerifyText                  ${ACCOUNT_NAME}
    VerifyText                  Contacts

    ClickUntil                  Email                       Contacts
    ClickUntil                  Contact Information         New
    Picklist                    Salutation                  ${CONTACT_SALUTATION}
    TypeText                    First Name                  ${CONTACT_FIRST_NAME}
    TypeText                    Last Name                   ${CONTACT_LAST_NAME}
    
    # Generate random phone numbers for contact
    ${contact_phone}=           Generate Phone Number
    ${contact_mobile}=          Generate Phone Number
    TypeText                    Phone                       ${contact_phone}            anchor=Mobile
    TypeText                    Mobile                      ${contact_mobile}
    
    Combobox                    Search Accounts...          ${ACCOUNT_NAME}
    TypeText                    Email                       ${CONTACT_EMAIL}            anchor=Reports To
    TypeText                    Title                       ${CONTACT_TITLE}
    ClickText                   Save                        partial_match=False
    Sleep                       1
    VerifyText                  was created.
    ClickText                   Contacts
    VerifyText                  ${CONTACT_FIRST_NAME} ${CONTACT_LAST_NAME}


Delete Test Data
    [Documentation]             Cleans up all test data created during the test suite
    [tags]                      Test data

    # Attempt to delete 'Tina Smith' related Cases
    Appstate                    Home
    LaunchApp                   ${APP_SERVICE}
    ClickText                   Cases
    ClickText                   Select a List View: Cases
    ClickText                   Recently Viewed
    ClickText                   Show Actions
    ClickText                   Delete
    UseModal                    On
    ClickText                   Delete
    VerifyText                  was deleted.

    # Attempt to delete dynamically generated account data
    LaunchApp                   ${APP_SALES}
    ClickText                   Accounts
    VerifyText                  Account Name
    Set Suite Variable          ${data}                     ${ACCOUNT_NAME}
    DeleteAllMatchingAccounts                               ${ACCOUNT_NAME}
    VerifyNoMatchingAccounts    ${ACCOUNT_NAME}
    NoData                      # Verify no data exists

    ClickText                   Opportunities
    VerifyPageHeader            Opportunities
    VerifyNoText                Safesforce Pace
    VerifyNoText                ${OPPORTUNITY_NAME}
    VerifyNoText                ${CONTACT_FIRST_NAME} ${CONTACT_LAST_NAME}
    VerifyNoText                ${LEAD_FIRST_NAME} ${LEAD_LAST_NAME}

    # Delete Leads
    ClickText                   Leads
    VerifyText                  Change Owner
    VerifyNoText                ${LEAD_FIRST_NAME} ${LEAD_LAST_NAME}
    VerifyNoText                ${CONTACT_FIRST_NAME} ${CONTACT_LAST_NAME}