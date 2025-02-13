# NOTE: readme.txt contains important information you need to take into account
# before running this suite.

*** Settings ***
Resource                        ../resources/common.robot
Suite Setup                     Setup Browser
Suite Teardown                  End suite

*** Test Cases ***
Entering A Lead
    [tags]                      Lead
    Appstate                    Home
    LaunchApp                   Sales
    ClickText                   Leads
    VerifyText                  Change Owner
    ClickText                   New
    UseModal                    On                          # Only find fields from open modal dialoge
    VerifyText                  Led Information

    Picklist                    Salutation                  Ms.
    TypeText                    First Name                  Tina
    TypeText                    Last Name                   Smith
    Picklist                    Lead Status                 New
    # generate random phone number, just as an example
    # NOTE: initialization of random number generator is done on suite setup
    ${rand_phone}=              Generate Random String      14                          [NUMBERS]
    # concatenate leading "+" and random numbers
    ${phone}=                   SetVariable                 +${rand_phone}
    TypeText                    Phone                       ${phone}                    First Name
    TypeText                    Company                     Growmore                    Last Name
    TypeText                    Title                       Manager                     Address Information
    TypeText                    Email                       tina.smith@gmail.com        Rating
    TypeText                    Websit                     https://www.growmore.com/
    PickList                    Lead ource                 Web
    TypeText                    Zip/Postal Code             75052
    PickList                    Product Interest            GC1000 series
    Picklist                    Lead Source                 Partner Referral
    ClickText                   Save                        partial_match=False
    UseModal                    Off
    Sleep                       1

    ClickText                   Details
    VerifyField                 Name                        Ms. Tina Smith
    VerifyField                 Lead Status                 New
    VerifyField                 Phone                       ${phone}
    VerifyField                 Company                     Growmore
    VerifyField                 Website                     https://www.growmore.com/

    # as an example, let's check Phone number format. Should be "+" and 14 numbers
    ${phone_num}=               GetFieldValue               Phone
    Should Match Regexp         ${phone_num}                ^[+]\\d{14}$

    ClickText                   Leads
    VerifyText                  Tina Smith
    VerifyText                  Manager
    VerifyText                  Growmore


Converting A Lead To Opportunity-Account-Contact
    [tags]                      Lead
    Appstate                    Home
    LaunchApp                   Sales

    ClickText                   Leads
    ClickText                   Tina Smith

    ClickUntil                  Convert Lead                Convert
    ClickText                   Opportunity                 2
    TypeText                    Opportunity Name            Growmore Pace
    ClickText                   Convert                     2
    VerifyText                  Your lead has been converted                            timeout=30

    ClickText                   Go to Leads
    ClickText                   Opportunities
    VerifyText                  Growmore Pace
    ClickText                   Accounts
    VerifyText                  Growmore
    ClickText                   Contacts
    VerifyText                  Tina Smith


Creating An Account
    [tags]                      Account
    Appstate                    Home
    LaunchApp                   Sales

    ClickText                   Accounts
    ClickUntil                  Account Information         New



    PickList                    *Account Picklist           1
    TypeText                    *Test Number Field          123
    ClickText                   *Customer Since
    ClickText                   Today
    TypeText                    *Account Number             500
    PickList                    *Picklist Test              1
    TypeText                    Account Name                Growmore                    anchor=Parent Account
    TypeText                    Phone                       +12258443456789             anchor=Fax
    TypeText                    Fax                         +12258443456766
    TypeText                    Website                     https://www.growmore.com
    Picklist                    Type                        Technology Partner
    Picklist                    Industry                    Agriculture

    TypeText                    Employees                   35000
    TypeText                    Annual Revenue              12 billion
    ClickText                   Save                        partial_match=False

    ClickText                   Details
    VerifyText                  Growmore
    VerifyText                  35,000


Create A Case on an Account
    [tags]                      Case
    Appstate                    Home
    LaunchApp                   Sales
    ClickText                   Cases List
    ClickText                   New Case

    UseModal                    On
    PickList                    *Status                     New
    PickList                    *Case Origin                Web
    ComboBox                    Search Contacts...          Tina Smith
    ComboBox                    Search Accounts...          Growmore                    index=1
    PickList                    Type                        Other
    PickList                    Case Reason                 Equipment Complexity
    ClickText                   Save                        partial_match=false
    UseModal                    Off
    VerifyText                  was created.

Creating An Opportunity For The Account
    [tags]                      Account
    Appstate                    Home
    LaunchApp                   Sales
    ClickText                   Accounts
    VerifyText                  Growmore
    VerifyText                  Opportunities

    ClickUntil                  Stage                       Opportunities
    ClickUntil                  Opportunity Information     New
    TypeText                    Opportunity Name            Growmore Pace               anchor=Cancel               delay=2
    Combobox                    Search Accounts...          Growmore
    Picklist                    Type                        New Business
    ClickText                   Close Date                  Opportunity Information
    ClickText                   Next Month
    ClickText                   Today

    Picklist                    Stage                       Prospecting
    TypeText                    Amount                      5000000
    Picklist                    Lead Source                 Partner Referral
    TypeText                    Next Step                   Qualification
    TypeText                    Description                 This is first step
    ClickText                   Save                        partial_match=False         # Do not accept partial match, i.e. "Save All"

    Sleep                       1
    ClickText                   Opportunities
    VerifyText                  Growmore Pace


Change status of opportunity
    [tags]                      status_change
    Appstate                    Home
    ClickText                   Opportunities
    VerifyPageHeader            Opportunities
    ClickText                   Growmore Pace               delay=2                     # intentionally delay action - 2 seconds
    VerifyText                  Contact Roles

    ClickText                   Show actions for Contact Roles
    ClickText                   Add Contact Roles

    # verify all following texts from the dialog that opens
    VerifyAll                   Cancel, Show Selected, Name, Add Contact Roles
    ComboBox                    Search Contacts...          Tina Smith
    ClickText                   Next                        delay=3
    ClickText                   Edit Role: Item
    ClickText                   --None--
    ClickText                   Decision Maker
    ClickText                   Save                        partial_match=False
    VerifyText                  Tina Smith

    ClickText                   Mark Stage as Complete
    ClickText                   Opportunities               delay=2
    ClickText                   Growmore Pace
    VerifyStage                 Qualification               true
    VerifyStage                 Prospecting                 false
    VerifyStageColor            Qualification               navy
    VerifyStageColor            Prospecting                 green

Create A Contact For The Account
    [tags]                      Growmore.Account
    Appstate                    Home
    LaunchApp                   Sales
    ClickText                   Accounts
    VerifyText                  Growmore
    VerifyText                  Contacts

    ClickUntil                  Email                       Contacts
    ClickUntil                  Contact Information         New
    Picklist                    Salutation                  Mr.
    TypeText                    First Name                  Richard
    TypeText                    Last Name                   Brown
    TypeText                    Phone                       +00150345678134             anchor=Mobile
    TypeText                    Mobile                      +00150345678178
    Combobox                    Search Accounts...          Growmore

    TypeText                    Email                       richard.brown@gmail.com     anchor=Reports To
    TypeText                    Title                       Manager
    ClickText                   Save                        partial_match=False
    Sleep                       1
    VerifyText                  was created.
    ClickText                   Contacts
    VerifyText                  Richard Brown


Delete Test Data
    [tags]                      Test data

    # Attempt to delete 'Tina Smith' related Cases
    Appstate                    Home
    LaunchApp                   Service
    ClickText                   Cases
    ClickText                   Select a List View: Cases
    ClickText                   Recently Viewed
    ClickText                   Show Actions
    ClickText                   Delete
    UseModal                    On
    ClickText                   Delete
    VerifyText                  was deleted.

    # Attempt to delete 'Growmore' related data
    LaunchApp                   Sales
    ClickText                   Accounts
    VerifyText                  Account Name
    Set Suite Variable          ${data}                     Growmore
    ${ACCOUNT_NAME}=            Set Variable                Growmore
    DeleteAllMatchingAccounts                               ${ACCOUNT_NAME}
    VerifyNoMatchingAccounts    ${ACCOUNT_NAME}
    NoData                      # Verify no 'Growmore' data exists

    ClickText                   Opportunities
    VerifyPageHeader            Opportunities
    VerifyNoText                Safesforce Pace
    VerifyNoText                Growmore Pace
    VerifyNoText                Richard Brown
    VerifyNoText                Tina Smith

    # Delete Leads
    ClickText                   Leads
    VerifyText                  Change Owner
    VerifyNoText                Tina Smith
    VerifyNoText                Richard Brown

