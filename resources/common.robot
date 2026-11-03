*** Settings ***
Documentation                   Example resource file with custom keywords. NOTE: Some keywords below may need
...                             minor changes to work in different instances.
Library                         QForce
Library                         FakerLibrary
Library                         String
Library                         DateTime
Library                         QWeb
Library                         OperatingSystem

*** Variables ***
# IMPORTANT: Please read the readme.txt to understand needed variables and how to handle them!!
${BROWSER}                      chrome
# ${username}                   pace.delivery1@qentinel.com.demonew
# ${login_url}                  https://qentinel--demonew.my.salesforce.com/            # Salesforce instance. NOTE: Should be overwritten in CRT variables
${home_url}                     ${login_url}/lightning/page/home


# Static Configuration Variables
${LEAD_SALUTATION}              Ms.
${LEAD_STATUS}                  New
${LEAD_SOURCE}                  Partner Referral
${LEAD_PRODUCT_INTEREST}        GC1000 series
${LEAD_ZIP_CODE}                75052

${CONTACT_SALUTATION}           Mr.
${CONTACT_TITLE}                Manager

${ACCOUNT_TYPE}                 Technology Partner
${ACCOUNT_INDUSTRY}             Agriculture
${ACCOUNT_EMPLOYEES}            35000
${ACCOUNT_REVENUE}              12 billion

${OPPORTUNITY_TYPE}             New Business
${OPPORTUNITY_STAGE}            Prospecting
${OPPORTUNITY_AMOUNT}           5000000
${OPPORTUNITY_NEXT_STEP}        Qualification
${OPPORTUNITY_DESCRIPTION}      This is first step

${CASE_STATUS}                  New
${CASE_ORIGIN}                  Web
${CASE_TYPE}                    Other
${CASE_REASON}                  Equipment Complexity

${CONTACT_ROLE}                 Decision Maker

${APP_SALES}                    Sales
${APP_SERVICE}                  Service

# Dynamic Variables (Generated at Suite Setup)
${LEAD_FIRST_NAME}              ${EMPTY}
${LEAD_LAST_NAME}               ${EMPTY}
${LEAD_FULL_NAME}               ${EMPTY}
${LEAD_EMAIL}                   ${EMPTY}
${LEAD_TITLE}                   ${EMPTY}
${LEAD_PHONE}                   ${EMPTY}

${CONTACT_FIRST_NAME}           ${EMPTY}
${CONTACT_LAST_NAME}            ${EMPTY}
${CONTACT_FULL_NAME}            ${EMPTY}
${CONTACT_EMAIL}                ${EMPTY}

${ACCOUNT_NAME}                 ${EMPTY}
${ACCOUNT_WEBSITE}              ${EMPTY}
${ACCOUNT_PHONE}                ${EMPTY}
${ACCOUNT_FAX}                  ${EMPTY}

${OPPORTUNITY_NAME}             ${EMPTY}

${DATE_SUFFIX}                  ${EMPTY}

*** Keywords ***
Setup Browser
    # Setting search order is not really needed here, but given as an example
    # if you need to use multiple libraries containing keywords with duplicate names
    Set Library Search Order    QForce                      QWeb
    Open Browser                about:blank                 ${BROWSER}
    SetConfig                   LineBreak                   ${EMPTY}                    #\ue000
    Evaluate                    random.seed()               random                      # initialize random generator
    SetConfig                   DefaultTimeout              15s                         #sometimes salesforce is slow
    # adds a delay of 0.3 between keywords. This is helpful in cloud with limited resources.
    SetConfig                   Delay                       0.3
    # Home

End suite
    Close All Browsers


Login
    [Documentation]             Login to Salesforce instance. Takes instance_url, username and password as
    ...                         arguments. Uses values given in Copado Robotic Testing's variables section by default.
    [Arguments]                 ${sf_instance_url}=${login_url}                         ${sf_username}=${username}                  ${sf_password}=${password}
    GoTo                        ${sf_instance_url}
    TypeText                    Username                    ${sf_username}              delay=1
    TypeSecret                  Password                    ${sf_password}
    ClickText                   Log In
    # We'll check if variable ${secret} is given. If yes, fill the MFA dialog.
    # If not, MFA is not expected.
    # ${secret} is ${None} unless specifically given.
    ${MFA_needed}=              Run Keyword And Return Status                           Should Not Be Equal         ${None}         ${secret}
    Run Keyword If              ${MFA_needed}               Fill MFA                    ${sf_username}              ${secret}       ${sf_instance_url}


Login As
    [Documentation]             Login As different persona. User needs to be logged into Salesforce with Admin rights
    ...                         before calling this keyword to change persona.
    ...                         Example:
    ...                         LoginAs                     Chatter Expert
    [Arguments]                 ${persona}
    ClickText                   Setup
    ClickItem                   Setup                       delay=1
    SwitchWindow                NEW
    TypeText                    Search Setup                ${persona}                  delay=2
    ClickElement                //*[@title\="${persona}"]                               delay=2                     # wait for list to populate, then click
    VerifyText                  Freeze                      timeout=45                  # this is slow, needs longer timeout
    ClickText                   Login                       anchor=Freeze               partial_match=False         delay=1


Fill MFA
    [Documentation]             Gets the MFA OTP code and fills the verification dialog (if needed)
    [Arguments]                 ${sf_username}=${username}                              ${mfa_secret}=${secret}     ${sf_instance_url}=${login_url}
    ${mfa_code}=                GetOTP                      ${sf_username}              ${mfa_secret}               ${login_url}
    TypeSecret                  Verification Code           ${mfa_code}
    ClickText                   Verify

Verify JWT Authentication
    [Documentation]    Uses JWT Authentication via an external Client Appstate
    # This is the preferred authentication method now:
    JWTAuthenticate    ${client_id}    ${username}    ${private_key}
    JwtLogin
    LaunchApp    Sales
    
Home
    [Documentation]             Example appstarte: Navigate to homepage, login if needed
    GoTo                        ${home_url}
    ${login_status} =           IsText                      To access this page, you have to log in to Salesforce.                  2
    Run Keyword If              ${login_status}             Login
    ClickText                   Home
    VerifyTitle                 Home | Salesforce


    # Example of custom keyword with robot fw syntax. NOTE: These keywords may need to be adjusted
    # to work in your environment
VerifyStage
    [Documentation]             Verifies that stage given in ${text} is at ${selected} state; either selected (true) or not selected (false)
    [Arguments]                 ${text}                     ${selected}=true
    VerifyElement               //a[@title\="${text}" and (@aria-checked\="${selected}" or @aria-selected\="${selected}")]


VerifyStageColor
    [Documentation]             Example keyword on how to verify background color of element.
    ...                         Note that this keyword might need adjusting in your instance (colors and locators can be different)
    [Arguments]                 ${stage_text}               ${color}=navy
    &{COLORS}=                  Create Dictionary           navy=rgba(1, 68, 134, 1)    green=rgba(59, 167, 85, 1)

    ${elem}=                    GetWebElement               ${stage_text}               element_type=item
    ${background_color}=        Evaluate                    $elem.value_of_css_property("background-color")
    Should Be Equal             ${COLORS.${color}}          ${background_color}         msg=Error: Background color ( ${background_color}) differs from ${color} (${COLORS.${color}})


NoData
    VerifyNoText                ${data}                     timeout=3                   delay=2


DeleteAccounts
    [Documentation]             RunBlock to remove all data until it doesn't exist anymore
    ClickText                   ${data}
    ClickText                   Delete
    VerifyText                  Are you sure you want to delete this account?
    ClickText                   Delete                      2
    VerifyText                  Undo
    VerifyNoText                Undo
    ClickText                   Accounts                    partial_match=False


DeleteLeads
    [Documentation]             RunBlock to remove all data until it doesn't exist anymore
    ClickText                   ${data}
    ClickText                   Delete
    VerifyText                  Are you sure you want to delete this lead?
    ClickText                   Delete                      2
    VerifyText                  Undo
    VerifyNoText                Undo
    ClickText                   Leads                       partial_match=False

HandleAccountMatch
    [Documentation]             Handles the account match scenario by selecting the matching account and retrying conversion
    ClickText                   Select                      anchor=Matching Account     timeout=5
    ClickText                   Convert                     timeout=5

DeleteAllMatchingAccounts
    [Arguments]                 ${account_name}
    [Documentation]             Deletes all accounts with the given name
    DeleteAllMatchingRecords    Accounts                    ${account_name}             Are you sure you want to delete this account?

VerifyNoMatchingAccounts
    [Arguments]                 ${account_name}
    [Documentation]             Verifies that no accounts with the given name exist
    TypeText                    Search this list...         ${account_name}\n           anchor=View
    VerifyNoText                ${account_name}             partial_match=false         timeout=5s

DeleteAllMatchingRecords
    [Arguments]                 ${list_tab}                 ${record_name}              ${confirmation_text}
    [Documentation]             Opens the list tab, filters by name and deletes matching records until none are left.
    ...                         The loop is capped so a stuck delete can never hang the suite.
    ClickText                   ${list_tab}
    VerifyText                  Search this list...
    TypeText                    Search this list...         ${record_name}\n
    FOR    ${i}    IN RANGE    20
        ${found}=               IsText                      ${record_name}              timeout=3
        IF    not ${found}
            BREAK
        END
        ClickText               ${record_name}
        ClickText               Delete
        VerifyText              ${confirmation_text}
        ClickText               Delete                      2
        VerifyText              was deleted                 timeout=15
        ClickText               ${list_tab}
        VerifyText              Search this list...
        TypeText                Search this list...         ${record_name}\n
    END

DeleteAllMatchingCases
    [Arguments]                 ${search_text}
    [Documentation]             Deletes cases found by searching the Cases list, until none are left
    ClickText                   Cases
    VerifyText                  Search this list...
    TypeText                    Search this list...         ${search_text}\n
    FOR    ${i}    IN RANGE    20
        ${found}=               IsText                      Show Actions                timeout=3
        IF    not ${found}
            BREAK
        END
        ClickText               Show Actions
        ClickText               Delete
        UseModal                On
        ClickText               Delete
        UseModal                Off
        VerifyText              was deleted                 timeout=15
        ClickText               Cases
        VerifyText              Search this list...
        TypeText                Search this list...         ${search_text}\n
    END

Cleanup Test Data
    [Documentation]             Deletes all data created by the suite. Every step is wrapped so one failure
    ...                         never stops the rest of the cleanup. Safe to run even if earlier tests failed.
    Run Keyword And Ignore Error    AppState                Home
    Run Keyword And Ignore Error    LaunchApp               ${APP_SALES}
    Run Keyword And Ignore Error    DeleteAllMatchingCases      ${Lead_Conversion_Testing.Lead_LastName}
    Run Keyword And Ignore Error    DeleteAllMatchingRecords    Opportunities           ${Lead_Conversion_Testing.OpportunityName}      Are you sure you want to delete this opportunity?
    Run Keyword And Ignore Error    DeleteAllMatchingRecords    Contacts                ${Lead_Conversion_Testing.Contact_FirstName}    Are you sure you want to delete this contact?
    Run Keyword And Ignore Error    DeleteAllMatchingRecords    Contacts                ${Lead_Conversion_Testing.Lead_LastName}        Are you sure you want to delete this contact?
    Run Keyword And Ignore Error    DeleteAllMatchingRecords    Leads                   ${Lead_Conversion_Testing.Lead_LastName}        Are you sure you want to delete this lead?
    Run Keyword And Ignore Error    DeleteAllMatchingRecords    Accounts                ${Lead_Conversion_Testing.Account_Name}         Are you sure you want to delete this account?

Cleanup And End Suite
    [Documentation]             Suite teardown: always cleans up, then always closes the browser
    Run Keyword And Ignore Error    Cleanup Test Data
    End suite



Setup Suite With Dynamic Data
    [Documentation]             Initializes browser and generates all dynamic test data
    Setup Browser
    Generate Dynamic Test Data

Generate Dynamic Test Data
    [Documentation]             Generates realistic test data using FakerLibrary
    
    # Generate date suffix for uniqueness (YYYYMMDD format)
    ${current_date}=            Get Current Date            result_format=%Y%m%d
    Set Suite Variable          ${DATE_SUFFIX}              ${current_date}
    
    # Generate Lead Data
    ${lead_fname}=              FakerLibrary.First Name Female
    ${lead_lname}=              FakerLibrary.Last Name
    ${lead_email}=              FakerLibrary.Email
    ${lead_title}=              FakerLibrary.Job
    ${lead_phone}=              Generate Phone Number
    
    Set Suite Variable          ${LEAD_FIRST_NAME}          ${lead_fname}
    Set Suite Variable          ${LEAD_LAST_NAME}           ${lead_lname}
    Set Suite Variable          ${LEAD_FULL_NAME}           ${LEAD_SALUTATION} ${lead_fname} ${lead_lname}
    Set Suite Variable          ${LEAD_EMAIL}               ${lead_email}
    Set Suite Variable          ${LEAD_TITLE}               ${lead_title}
    Set Suite Variable          ${LEAD_PHONE}               ${lead_phone}
    
    # Generate Contact Data
    ${contact_fname}=           FakerLibrary.First Name Male
    ${contact_lname}=           FakerLibrary.Last Name
    ${contact_email}=           FakerLibrary.Email
    
    Set Suite Variable          ${CONTACT_FIRST_NAME}       ${contact_fname}
    Set Suite Variable          ${CONTACT_LAST_NAME}        ${contact_lname}
    Set Suite Variable          ${CONTACT_FULL_NAME}        ${contact_fname} ${contact_lname}
    Set Suite Variable          ${CONTACT_EMAIL}            ${contact_email}
    
    # Generate Account Data
    ${company_name}=            FakerLibrary.Company
    ${account_name_unique}=     Set Variable                ${company_name}_${DATE_SUFFIX}
    ${website}=                 FakerLibrary.Url
    ${account_phone}=           Generate Phone Number
    ${account_fax}=             Generate Phone Number
    
    Set Suite Variable          ${ACCOUNT_NAME}             ${account_name_unique}
    Set Suite Variable          ${ACCOUNT_WEBSITE}          ${website}
    Set Suite Variable          ${ACCOUNT_PHONE}            ${account_phone}
    Set Suite Variable          ${ACCOUNT_FAX}              ${account_fax}
    
    # Generate Opportunity Data
    ${opp_name}=                Set Variable                ${company_name} Pace_${DATE_SUFFIX}
    Set Suite Variable          ${OPPORTUNITY_NAME}         ${opp_name}
    
    # Log all generated data for debugging
    Log To Console              ${\n}=== DYNAMIC TEST DATA GENERATED ===${\n}
    Log To Console              Lead: ${LEAD_FULL_NAME} (${LEAD_EMAIL})
    Log To Console              Contact: ${CONTACT_FULL_NAME} (${CONTACT_EMAIL})
    Log To Console              Account: ${ACCOUNT_NAME}
    Log To Console              Opportunity: ${OPPORTUNITY_NAME}
    Log To Console              Date Suffix: ${DATE_SUFFIX}
    Log To Console              ======================================${\n}

Generate Phone Number
    [Documentation]             Generates a random phone number in international format
    ${rand_phone}=              Generate Random String      14                          [NUMBERS]
    ${phone}=                   Set Variable                +${rand_phone}
    [Return]                    ${phone}