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
${Lead_Conversion_Testing.Lead_Salutation}
    Picklist                    Salutation                  ${Lead_Conversion_Testing.Lead_Salutation}
    TypeText                    First Name                  ${Lead_Conversion_Testing.Lead_FirstName}
    TypeText                    Last Name                   ${Lead_Conversion_Testing.Lead_LastName}
    Picklist                    Lead Status                 ${Lead_Conversion_Testing.Lead_Status}
    
    TypeText                    Phone                       ${Lead_Conversion_Testing.Lead_Phone}               First Name
    TypeText                    Company                     ${Lead_Conversion_Testing.Lead_Company}             Last Name
    TypeText                    Title                       ${Lead_Conversion_Testing.Lead_Title}               Address Information
    TypeText                    Email                       ${Lead_Conversion_Testing.Lead_Email}               Rating
    TypeText                    Website                     ${Lead_Conversion_Testing.Account_Website}
    PickList                    Lead Source                 Web
    TypeText                    Zip/Postal Code             ${LEAD_ZIP_CODE}
    PickList                    Product Interest            ${LEAD_PRODUCT_INTEREST}
    Picklist                    Lead Source                 ${LEAD_SOURCE}
    ClickText                   Save                        partial_match=False
    UseModal                    Off
    Sleep                       1

    ClickText                   Details
    VerifyField                 Name                        ${Lead_Conversion_Testing.Lead_FullName}
    VerifyField                 Lead Status                 ${Lead_Conversion_Testing.Lead_Status}
    VerifyField                 Phone                       ${Lead_Conversion_Testing.Lead_Phone}
    VerifyField                 Company                     ${Lead_Conversion_Testing.Account_Name}
    VerifyField                 Website                     ${Lead_Conversion_Testing.Account_Website}

    # As an example, let's check Phone number format. Should be "+" and 14 numbers
    ${phone_num}=               GetFieldValue               Phone
    Should Match Regexp         ${phone_num}                ^[+]\\d{14}$

    ClickText                   Leads
    VerifyText                  ${Lead_Conversion_Testing.Lead_FirstName} ${Lead_Conversion_Testing.Lead_LastName}
    VerifyText                  ${Lead_Conversion_Testing.Lead_Title}
    VerifyText                  ${Lead_Conversion_Testing.Account_Name}


Converting A Lead To Opportunity-Account-Contact
    [Documentation]             Converts the created lead to opportunity, account, and contact
    [tags]                      Lead.Conversion
    Appstate                    Home
    LaunchApp                   ${APP_SALES}

    ClickText                   Leads
    ClickText                   ${Lead_Conversion_Testing.Lead_FirstName} ${Lead_Conversion_Testing.Lead_LastName}

    ClickUntil                  Convert Lead                Convert
    ClickText                   Opportunity                 2
    TypeText                    Opportunity Name            ${Lead_Conversion_Testing.OpportunityName}
    ClickText                   Convert                     2
    VerifyText                  Your lead has been converted                            timeout=30

    ClickText                   Go to Leads
    ClickText                   Opportunities
    VerifyText                  ${Lead_Conversion_Testing.OpportunityName}
    ClickText                   Accounts
    VerifyText                  ${Lead_Conversion_Testing.Account_Name}
    ClickText                   Contacts
    VerifyText                  ${Lead_Conversion_Testing.Lead_FirstName} ${Lead_Conversion_Testing.Lead_LastName}


Creating An Account
    [Documentation]             Creates a new account with dynamically generated data
    [tags]                      Account
    Appstate                    Home
    LaunchApp                   ${APP_SALES}

    ClickText                   Accounts
    ClickUntil                  Account Information         New

    TypeText                    Account Name                ${Lead_Conversion_Testing.Account_Name}             anchor=Parent Account
    TypeText                    Phone                       ${Lead_Conversion_Testing.Account_Phone}            anchor=Fax
    TypeText                    Fax                         ${Lead_Conversion_Testing.Account_Fax}
    TypeText                    Website                     ${Lead_Conversion_Testing.Account_Website}
    Picklist                    Type                        ${ACCOUNT_TYPE}
    Picklist                    Industry                    ${ACCOUNT_INDUSTRY}

    TypeText                    Employees                   ${ACCOUNT_EMPLOYEES}
    TypeText                    Annual Revenue              ${ACCOUNT_REVENUE}
    ClickText                   Save                        partial_match=False

    ClickText                   Details
    VerifyField                 Account Name                ${Lead_Conversion_Testing.Account_Name}
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
    ComboBox                    Search Contacts...          ${Lead_Conversion_Testing.Lead_FirstName} ${Lead_Conversion_Testing.Lead_LastName}
    ComboBox                    Search Accounts...          ${Lead_Conversion_Testing.Account_Name}                 index=1
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
    VerifyText                  ${Lead_Conversion_Testing.Account_Name}
    VerifyText                  Opportunities

    ClickUntil                  Stage                       Opportunities
    ClickUntil                  Opportunity Information     New
    TypeText                    Opportunity Name            ${Lead_Conversion_Testing.OpportunityName}         anchor=Cancel               delay=2
    Combobox                    Search Accounts...          ${Lead_Conversion_Testing.Account_Name}
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
    VerifyText                  ${Lead_Conversion_Testing.OpportunityName}


Change status of opportunity
    [Documentation]             Changes the opportunity status and adds contact role
    [tags]                      Opportunity.Status
    Appstate                    Home
    ClickText                   Opportunities
    VerifyPageHeader            Opportunities
    ClickText                   ${Lead_Conversion_Testing.OpportunityName}         delay=2                     # intentionally delay action - 2 seconds
    VerifyText                  Contact Roles
    ClickText                   Show actions for Contact Roles
    # ClickText                 Show more actions           anchor=Contact Roles
    ClickText                   Add Contact Roles
    UseModal                    On

    # Verify all following texts from the dialog that opens
    VerifyAll                   Cancel, Show Selected, Name, Add Contact Roles
    ComboBox                    Search Contacts...          ${Lead_Conversion_Testing.Lead_FirstName} ${Lead_Conversion_Testing.Lead_LastName}
    ClickText                   Next                        delay=3
    ClickText                   Edit Role: Item
    PickList                    Role                        ${CONTACT_ROLE}
    ClickText                   Save                        partial_match=False
    VerifyText                  ${Lead_Conversion_Testing.Lead_FirstName} ${Lead_Conversion_Testing.Lead_LastName}

    ClickText                   Mark Stage as Complete
    ClickText                   Opportunities               delay=2
    ClickText                   ${Lead_Conversion_Testing.OpportunityName}
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
    VerifyText                  ${Lead_Conversion_Testing.Account_Name}
    VerifyText                  Contacts

    ClickUntil                  Email                       Contacts
    ClickUntil                  Contact Information         New
    Picklist                    Salutation                  ${CONTACT_SALUTATION}
    TypeText                    First Name                  ${Lead_Conversion_Testing.Contact_FirstName}
    TypeText                    Last Name                   ${Lead_Conversion_Testing.Contact_FirstName}
    
    # Generate random phone numbers for contact
    ${contact_phone}=           Generate Phone Number
    ${contact_mobile}=          Generate Phone Number
    TypeText                    Phone                       ${contact_phone}            anchor=Mobile
    TypeText                    Mobile                      ${contact_mobile}
    
    Combobox                    Search Accounts...          ${Lead_Conversion_Testing.Account_Name}
    TypeText                    Email                       ${Lead_Conversion_Testing.Contact_Email}            anchor=Reports To
    TypeText                    Title                       ${CONTACT_TITLE}
    ClickText                   Save                        partial_match=False
    Sleep                       1
    VerifyText                  was created.
    ClickText                   Contacts
    VerifyText                  ${Lead_Conversion_Testing.Contact_FirstName} ${Lead_Conversion_Testing.Contact_LastName}


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
    Set Suite Variable          ${data}                     ${Lead_Conversion_Testing.Account_Name}
    DeleteAllMatchingAccounts                               ${Lead_Conversion_Testing.Account_Name}
    VerifyNoMatchingAccounts    ${Lead_Conversion_Testing.Account_Name}
    NoData                      # Verify no data exists

    ClickText                   Opportunities
    VerifyPageHeader            Opportunities
    VerifyNoText                Safesforce Pace
    VerifyNoText                ${Lead_Conversion_Testing.OpportunityName}
    VerifyNoText                ${Lead_Conversion_Testing.Contact_FirstName} ${Lead_Conversion_Testing.Contact_LastName}
    VerifyNoText                ${Lead_Conversion_Testing.Lead_FirstName} ${Lead_Conversion_Testing.Lead_LastName}

    # Delete Leads
    ClickText                   Leads
    VerifyText                  Change Owner
    VerifyNoText                ${Lead_Conversion_Testing.Lead_FirstName} ${Lead_Conversion_Testing.Lead_LastName}
    VerifyNoText                ${Lead_Conversion_Testing.Contact_FirstName} ${Lead_Conversion_Testing.Contact_LastName}