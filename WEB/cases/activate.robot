*** Settings ***
Documentation     How to manage accounts using account management tool
Resource          ../resources/global.robot
Suite Setup	Suite Setup Steps
Test Setup	Test Setup Steps
Test Teardown	Test Teardown Steps
Suite Teardown	Suite Teardown Steps

*** Variables ***
${Activate_Username_Link}	//form[@id='account_terms']/div/div/input[@id='username']
${Activate_Password_Link}	//form[@id='account_terms']/div/div/input[@id='password']
${Activate_Accept_Link}		//form[@id='account_terms']/div/div/input[@id='submit']

*** Test Cases *** 
Activate account - verify url location
    [Documentation] 
	[Tags]     regression
	Location Should Be	${ACTIVATE_PAGE}
	
Activate account - verify required field
    [Documentation] 
	[Tags]     regression
	${REQUIRED}=	Get Element Attribute	${Activate_Username_Link}@required
	Should Be Equal		${REQUIRED}	true
	${REQUIRED}=	Get Element Attribute	${Activate_Password_Link}@required
	Should Be Equal		${REQUIRED}	true	

Activate account - verify input default info
	[Documentation] 
	[Tags]     regression
	${INFO}=	Get Element Attribute	${Activate_Username_Link}@placeholder
	Should Be Equal		${INFO}		login
	${INFO}=	Get Element Attribute	${Activate_Password_Link}@placeholder
	Should Be Equal		${INFO}		password
	
Activate account - verify page title
	[Documentation] 
	[Tags]     regression
	${INFO}=	Get Text	xpath=//*[@id='activate']/ol/li[2]/strong
	Should Be Equal		${INFO}		Accounts
	${INFO}=	Get Text	xpath=//*[@id='activate']/ol/li[3]
	Should Be Equal		${INFO}		Activate	

Activate accounts - verify help info
	[Documentation] 
	[Tags]     regression
    Page should contain   Account activation in Ethel stands for accepting all Terms and Conditions which are required to successfully subscribe and use the account on your machine. If you check Accept Terms and Conditions when creating account or attaching subscriptions, the activation is done for you and there's no need for you to use this form.

Activate account without sku and without accepting terms
	[Documentation] 
	...	Create an account without accepting terms
    ...	Actually, we cannot have a account without accepting terms and without skus, as:
    ...	Terms are accepted after call api /account/new, but become un-accepted after add a valid sku with api /account/attach
    ...	But, create(/account/new) a account and activate(/account/activate) it, and then add a valid sku, terms are still accepted
    ...	
    ...	I keep this case for now
	[Tags]     regression
	Log	Waiting

Activate account having sku and with accepting terms
    [Documentation] 
	[Tags]     regression
	Input Text     xpath=${Activate_Username_Link}    ${EXISTING_USERNAME}
    Input Text     xpath=${Activate_Password_Link}    ${PASSWORD}
	Click Element	xpath=${Activate_Accept_Link}
	
	# Verify result via Ethel
	Verify result after accept terms successfully	${EXISTING_USERNAME}
	
	# Verify terms via Stage Customer Portal
	Open Browser	${STAGE_PORTAL_URL}   ${BROWSER}	
	Select Window	url=${STAGE_PORTAL_URL}
	Wait Until Page Contains	Log In		timeout=100
	Click Element		xpath=//*[@id='home-login-btn']
	Wait Until Page Contains	Log in to your Red Hat account		timeout=100
	Input Text     id=username    ${EXISTING_USERNAME}
	Input Text     id=password    ${PASSWORD}
    Click Element  id=_eventId_submit
    Wait Until Page Contains	Red Hat Account Number
	
Activate account with existing username and wrong password
    [Documentation] 
	[Tags]     regression
	Input Text     xpath=${Activate_Username_Link}    ${EXISTING_USERNAME}
    Input Text     xpath=${Activate_Password_Link}    ${WRONG_PASSWORD}
	Click Element	xpath=${Activate_Accept_Link}
	
	# Verify result
	${SUCCESS_MESSAGE}=   Catenate  Accepting Ts&Cs for "${EXISTING_USERNAME}"
	Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=20
	${SUCCESS_MESSAGE}=   Set Variable  	Invalid username or password
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
	Test File a bug Link

Activate account with new username and password
    [Documentation] 
	[Tags]     regression
	# Create an account without accepting temrs
	Get Window Identifiers
    Click Link       Create Account
    Page should contain Element   xpath=${Create_Create_Link}
    ${TEST_USERNAME}  Generate Username
    Input Text		id=username    ${TEST_USERNAME}
    Input Text		id=password    ${PASSWORD}
    Click Element	id=terms
    Click Element	id=submit
    
	# Verify result after created without sku and without accepting terms
	${SUCCESS_MESSAGE}=   Catenate  Creating account "${TEST_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=50 
    ${SUCCESS_MESSAGE}=   Catenate  Creating account owners in Candlepin
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=50 
    ${SUCCESS_MESSAGE}=   Catenate  Account "${TEST_USERNAME}" created
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=50 
	
	# Verify terms
	Check Terms Status		${TEST_USERNAME}	${ACCEPT_CONTENT}
	Get Window Identifiers

    Switch Browser	1
	Click Link		Activate Account
	Input Text     xpath=${Activate_Username_Link}    ${TEST_USERNAME}
    Input Text     xpath=${Activate_Password_Link}    ${PASSWORD}
	Click Element	xpath=${Activate_Accept_Link}
	Verify result after accept terms successfully	${TEST_USERNAME}
	
	${ACCEPT_CONTENT}=	Set Variable	Red Hat Account Number
	Check Terms Status		${TEST_USERNAME}	${ACCEPT_CONTENT}

*** Keywords ***    
Verify result after accept terms successfully
	[Documentation]	
	[Arguments]   ${TEST_USERNAME}
	${SUCCESS_MESSAGE}=   Catenate  Accepting Ts&Cs for "${TEST_USERNAME}"
	Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=20
	${SUCCESS_MESSAGE}=   Set Variable  All Terms and Conditions accepted	
	Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=20

Suite Setup Steps
	Log	Suite Begin...
	Open Browser  ${FRONT_PAGE}   ${BROWSER}
	Maximize Browser Window

Test Setup Steps
	Log	Suite Begin...   
    Go to Front Page
    Wait Until Page Contains Element   link=Activate Account
    Click Link       Activate Account
    Page should contain   Accept Terms and Conditions
    Capture Page Screenshot

Test Teardown Steps
	Capture Page Screenshot
	Log	Testing End...

Suite TearDown Steps
	Close All Browsers
	Log	Suite End...	
	