*** Settings ***
Documentation     Attach subscriptions
Resource          ../resources/global.robot
Suite Setup       Open Browser  ${FRONT_PAGE}   ${BROWSER}
Suite Teardown    Close All Browsers

*** Variables ***

*** Test Cases ***
Create accounts - check url location
    [Documentation] 
	[Tags]     regression
	Open Account Test Page		Create Account
    Page should contain   Create account
	${location}=	Get location
	    
Create accounts - check required field
    [Documentation] 
	[Tags]     regression
	Open Account Test Page		Create Account
    Page should contain   Create account
	${REQUIRED}=	Get Element Attribute	username@required
	Should Be Equal		${REQUIRED}		true
	${REQUIRED}=	Get Element Attribute	password@required
	Should Be Equal		${REQUIRED}		true

Create accounts - check optional field
	[Documentation] 
	[Tags]     regression
	Open Account Test Page		Create Account
    Page should contain   Create account
	${OPTIONAL}=	Get Element Attribute	first_name@required
	Should Be Equal As Strings		${OPTIONAL}		None
	${OPTIONAL}=	Get Element Attribute	last_name@required
	Should Be Equal As Strings		${OPTIONAL}		None
	${OPTIONAL}=	Get Element Attribute	sku@required
	Should Be Equal As Strings		${OPTIONAL}		None
	${OPTIONAL}=	Get Element Attribute	quantity@required
	Should Be Equal As Strings		${OPTIONAL}		None
	${OPTIONAL}=	Get Element Attribute	terms@required
	Should Be Equal As Strings		${OPTIONAL}		None
	
Create accounts - check input default info
	[Documentation] 
	[Tags]     regression
	Open Account Test Page		Create Account
    Page should contain   Create account
	${INFO}=	Get Element Attribute	username@placeholder
	Should Be Equal		${INFO}		login
	${INFO}=	Get Element Attribute	password@placeholder
	Should Be Equal		${INFO}		password
	${INFO}=	Get Element Attribute	first_name@placeholder
	Should Be Equal		${INFO}		(optional)
	${INFO}=	Get Element Attribute	last_name@placeholder
	Should Be Equal		${INFO}		(optional)
	${INFO}=	Get Element Attribute	sku@placeholder
	Should Be Equal		${INFO}		SKU1, SKU2,.. (can be done later)
	${INFO}=	Get Element Attribute	quantity@placeholder
	Should Be Equal		${INFO}		value above 0 effective to all SKUs listed above (can be done later)
	
Create accounts - check page title
	[Documentation] 
	[Tags]     regression
	Open Account Test Page		Create Account
    Page should contain   Create account
	${INFO}=	Get Text	xpath=//*[@id='create_form']/ol/li[2]/strong
	Should Be Equal		${INFO}		Accounts
	${INFO}=	Get Text	xpath=//*[@id='create_form']/ol/li[3]
	Should Be Equal		${INFO}		New	
	
Create accounts - check help info
	[Documentation] 
	[Tags]     regression
	Open Account Test Page		Create Account
    Page should contain   Create account
	# 1
	Page should contain		By using this form you can easily create a brand new account for Stage Candlepin.
	Page should contain		You can test your account via the Stage Customer Portal.
	# 2
	Page should contain		Optionally, you can attach Subscription SKUs to the account in no step. This process can also be done any other time, when your account is already created. To do so, please use the Attach Subscription tab.
	Page should contain		If you choose to attach subscriptions while creating an account you can specify the pool's quantity as well. Please be noted, when you don't specify the quantity yourself, a default value is set. Default value is 1.
	# 3
	Page should contain		TIP:You can check your already created accounts via View Accounts tab. 
	# 4
	Page should contain		By default, all created accounts are also activated. That means the Terms and Conditions that have to be accepted in order to use the account are automatically accepted. If you want to keep your account inactive, just untick the checkbox.
	Page should contain		Accepting Terms and Conditions is only applicable for accounts that have been populated with Red Hat Subscription SKUs.

Create accounts with new username and password without accepting terms
    [Documentation]		
    [Tags]    regression  
    ${TEST_USERNAME}  Generate Username
	Open Account Test Page		Create Account
    Page should contain   Create account
    Input Text		id=username    ${TEST_USERNAME}
    Input Text		id=password    ${PASSWORD}
    Click Element	id=terms
    Click Element	id=submit
	Created without accepting terms	${TEST_USERNAME}
	${NOT_ACCEPT_CONTENT}=	Set Variable	Accept Terms and Conditions 
	Check Terms Status		${TEST_USERNAME}	${NOT_ACCEPT_CONTENT}

Create accounts with new username and password
    [Documentation]		
    [Tags]    regression  
    ${TEST_USERNAME}  Generate Username
	Open Account Test Page		Create Account
    Page should contain   Create account
    Input Text		id=username    ${TEST_USERNAME}
    Input Text		id=password    ${PASSWORD}
    Click Element	id=submit
	Success Created		${TEST_USERNAME}

Create account with new username, password and first_name
    [Documentation]
    [Tags]    regression
	${TEST_USERNAME}  Generate Username
    Open Account Test Page		Create Account
    Page should contain   Create account
    Input Text     id=username    ${TEST_USERNAME}
    Input Text     id=password    ${PASSWORD}
    Input Text     id=first_name  ${FIRST_NAME}
    Click Element  id=submit
    Success Created		${TEST_USERNAME}
    
Create account with new username, password and last_name
    [Documentation]
    [Tags]    regression
	${TEST_USERNAME}  Generate Username
    Open Account Test Page		Create Account
    Page should contain   Create account
    Input Text     id=username    ${TEST_USERNAME}
    Input Text     id=password    ${PASSWORD}
    Input Text     id=last_name   ${LAST_NAME}
    Click Element  id=submit
    Success Created		${TEST_USERNAME}
    
Create accounts with new username, password, first_name and last_name
    [Documentation]
    [Tags]    regression
	${TEST_USERNAME}  Generate username
    Open Account Test Page		Create Account
    Page should contain   Create account
    Input Text     id=username    ${TEST_USERNAME}
    Input Text     id=password    ${PASSWORD}
    Input Text     id=first_name  ${FIRST_NAME}
    Input Text     id=last_name   ${LAST_NAME}
    Click Element  id=submit
    Success Created		${TEST_USERNAME}

Create accounts with one existing username and password
    [Documentation]
    [Tags]    regression
    Open Account Test Page		Create Account
    Page should contain   Create account
    Input Text     id=username    ${EXISTING_USERNAME}
    Input Text     id=password    ${PASSWORD}
    Click Element  id=submit
    User Already Exist

Create accounts with one existing username and wrong password
    [Documentation]
    [Tags]    regression
    Open Account Test Page		Create Account
    Page should contain   Create account
    Input Text     id=username    ${EXISTING_USERNAME}
    Input Text     id=password    ${WRONG_PASSWORD}
    Click Element  id=submit
    User Already Exist
    
Create accounts with one username including special character and password
    [Documentation]
    [Tags]    regression
    Open Account Test Page		Create Account
    Page should contain   Create account
    ${TEST_USERNAME}=	Generate username
    ${TEST_USERNAME}=	Catenate	${TEST_USERNAME} \\
    Input Text     id=username    ${TEST_USERNAME}
    Input Text     id=password    ${PASSWORD}
    Input Text     id=first_name  ${FIRST_NAME}
    Input Text     id=last_name   ${LAST_NAME}
    Click Element  id=submit
    ${SUCCESS_MESSAGE}=   Set Variable	Application encountered an network issue, please try again later
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    Test File a bug Link
    
Create accounts with one new username and password including special character
    [Documentation]
    [Tags]    regression
	${TEST_USERNAME}  Generate Username
    Open Account Test Page		Create Account
    Page should contain   Create account
    Input Text     id=username    ${TEST_USERNAME}
    Input Text     id=password    ${SPECIAL_PASSWORD}
    Input Text     id=first_name  ${FIRST_NAME}
    Input Text     id=last_name   ${LAST_NAME}
    Click Element  id=submit
    Success Created		${TEST_USERNAME}

Create accounts with new username, password, sku and quantity
    [Documentation]
    [Tags]    regression
	${TEST_USERNAME}  Generate Username
    Open Account Test Page		Create Account
    Page should contain   Create account
    Input Text		id=username     ${TEST_USERNAME}
    Input Text		id=password     ${PASSWORD}
    Input Text		id=first_name   ${FIRST_NAME}
    Input Text		id=last_name	${LAST_NAME}
    Input Text		id=sku			${SKU}
    Input Text		id=quantity		${QUANTITY}
    Click Element  id=submit
    Success Created and Attach	${TEST_USERNAME}	${SKU}
    
Create accounts with new username, password, skus and quantity
    [Documentation]
    [Tags]    regression
	${TEST_USERNAME}  Generate Username
    Open Account Test Page		Create Account
    Page should contain   Create account
    Input Text		id=username     ${TEST_USERNAME}
    Input Text		id=password     ${PASSWORD}
    Input Text		id=first_name   ${FIRST_NAME}
    Input Text		id=last_name	${LAST_NAME}
    Input Text		id=sku			${SKUS}
    Input Text		id=quantity		${QUANTITY}
    Click Element  id=submit
    Success Created and Attach		${TEST_USERNAME}	${SKUS}
    
Create accounts with new username, password, sku and null quantity
    [Documentation]
    [Tags]    regression
	${TEST_USERNAME}  Generate Username
    Open Account Test Page		Create Account
    Page should contain   Create account
    Input Text		id=username     ${TEST_USERNAME}
    Input Text		id=password     ${PASSWORD}
    Input Text		id=first_name   ${FIRST_NAME}
    Input Text		id=last_name	${LAST_NAME}
    Input Text		id=sku			${SKU}
    Click Element  id=submit
    #Success Created and Attach	${TEST_USERNAME}

Create accounts with new username, password, sku and negative quantity
    [Documentation]
    [Tags]    regression
	${TEST_USERNAME}  Generate Username
    Open Account Test Page		Create Account
    Page should contain   Create account
    Input Text		id=username     ${TEST_USERNAME}
    Input Text		id=password     ${PASSWORD}
    Input Text		id=first_name   ${FIRST_NAME}
    Input Text		id=last_name	${LAST_NAME}
    Input Text		id=sku			${SKU}
    Input Text		id=quantity		${NEGTIVE_QUANTITY}
    Click Element  id=submit
    #Success Created and Attach	${TEST_USERNAME}

Create accounts with new username, password, sku and zero quantity
    [Documentation]
    [Tags]    regression
	${TEST_USERNAME}  Generate Username
    Open Account Test Page		Create Account
    Page should contain   Create account
    Input Text		id=username     ${TEST_USERNAME}
    Input Text		id=password     ${PASSWORD}
    Input Text		id=first_name   ${FIRST_NAME}
    Input Text		id=last_name	${LAST_NAME}
    Input Text		id=sku			${SKU}
    Input Text		id=quantity		0
    Click Element  id=submit
    #Success Created and Attach	${TEST_USERNAME}

Create accounts with new username, password, null sku and quantity
    [Documentation]
    [Tags]    regression
	${TEST_USERNAME}  Generate Username
    Open Account Test Page		Create Account
    Page should contain   Create account
    Input Text		id=username     ${TEST_USERNAME}
    Input Text		id=password     ${PASSWORD}
    Input Text		id=first_name   ${FIRST_NAME}
    Input Text		id=last_name	${LAST_NAME}
    Input Text		id=quantity		${QUANTITY}
    Click Element  id=submit
    #Success Created and Attach	${TEST_USERNAME}
    
Create accounts with new username, password, wrong sku and quantity
    [Documentation]
    [Tags]    regression
	${TEST_USERNAME}  Generate Username
    Open Account Test Page		Create Account
    Page should contain   Create account
	Input Text		id=username     ${TEST_USERNAME}
    Input Text		id=password     ${PASSWORD}
    Input Text		id=first_name   ${FIRST_NAME}
    Input Text		id=last_name	${LAST_NAME}
    Input Text		id=sku			${WRONG_SKU}
    Input Text		id=quantity		${QUANTITY}
    Click Element  id=submit
    #Success Created and Attach	${TEST_USERNAME}

Create accounts with new username, password, wrong skus and quantity
    [Documentation]
    [Tags]    regression
	${TEST_USERNAME}  Generate Username
    Open Account Test Page		Create Account
    Page should contain   Create account
	Input Text		id=username     ${TEST_USERNAME}
    Input Text		id=password     ${PASSWORD}
    Input Text		id=first_name   ${FIRST_NAME}
    Input Text		id=last_name	${LAST_NAME}
    Input Text		id=sku			${WRONG_SKUS}
    Input Text		id=quantity		${QUANTITY}
    Click Element  id=submit
    #Success Created and Attach	${TEST_USERNAME}

Create accounts with new username, password, wrong sku and negative quantity
    [Documentation]
    [Tags]    regression
	${TEST_USERNAME}  Generate Username
    Open Account Test Page		Create Account
    Page should contain   Create account
	Input Text		id=username     ${TEST_USERNAME}
    Input Text		id=password     ${PASSWORD}
    Input Text		id=first_name   ${FIRST_NAME}
    Input Text		id=last_name	${LAST_NAME}
    Input Text		id=sku			${WRONG_SKU}
    Input Text		id=quantity		${NEGTIVE_QUANTITY}
    Click Element  id=submit
    ${SUCCESS_MESSAGE}=   Catenate  Account "${TEST_USERNAME}" successfully created.
    #Success Created and Attach	${TEST_USERNAME}

*** Keywords ***

User Already Exist
    ${FAIL_MESSAGE}=	Set Variable	User already exist
    Wait Until Page Contains   ${FAIL_MESSAGE} 
    Test File a bug Link
    
An example how to catch a piece of a page that is displayed just for a moment
       [Documentation]   There is a piece of html generated by javascript on a "create account" page. It is a message dnd it disappears in a moment. You can use keyword "Pause Execution" and "Log Source". Just click on a button "Pause" when the piece appears. And "Log Source" will show you the piece.
       ${UNIQUE_ID}  Generate Random String
       ${TEST_USERNAME}  Catenate   test-user ${UNIQUE_ID}
       Go to Front Page
       Wait Until Page Contains Element   link=Create Account
       Click Link       Create Account
       Page should contain   Create account
       Input Text     id=username    ${TEST_USERNAME}
       Input Text     id=password    redhat
       Input Text     id=first_name  Jan
       Input Text     id=last_name   Stavel
       Click Element  id=submit
       Pause Execution
       #Log Source     loglevel=WARN
       Log Source		loglevel=DEBUG
    
others
    #${SUCCESS_MESSAGE}=   Catenate  Attached subscriptions for '${TEST_USERNAME}'
    ${SUCCESS_MESSAGE}=   Catenate  Attached subscriptions for '${TEST_USERNAME}''