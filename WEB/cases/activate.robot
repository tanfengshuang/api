*** Settings ***
Documentation     How to manage accounts using account management tool
Resource          ../resources/global.robot
Suite Setup       Open Browser  ${FRONT_PAGE}   ${BROWSER}	Alias=1
#Suite Teardown    Close All Browsers

*** Variables ***


*** Test Cases *** 
Activate account - check url location
    [Documentation] 
	[Tags]     regression
	${location}=	Get location
	
Activate account - check required field
    [Documentation] 
	[Tags]     regression
	Open Account Test Page		Activate Account
    Page should contain   Accept Terms and Conditions
	${REQUIRED}=	Get Element Attribute	//form[@id='account_terms']/div/div/input[@id='username']@required
	Should Be Equal		${REQUIRED}	true
	${REQUIRED}=	Get Element Attribute	//form[@id='account_terms']/div/div/input[@id='password']@required
	Should Be Equal		${REQUIRED}	true	

Activate account - check input default info
	[Documentation] 
	[Tags]     regression
	Open Account Test Page		Activate Account
    Page should contain   Accept Terms and Conditions
	${INFO}=	Get Element Attribute	//form[@id='account_terms']/div/div/input[@id='username']@placeholder
	Should Be Equal		${INFO}		login
	${INFO}=	Get Element Attribute	//form[@id='account_terms']/div/div/input[@id='password']@placeholder
	Should Be Equal		${INFO}		password
	
Activate account - check page title
	[Documentation] 
	[Tags]     regression
	Open Account Test Page		Activate Account
    Page should contain   Accept Terms and Conditions
	${INFO}=	Get Text	xpath=//*[@id='activate']/ol/li[2]/strong
	Should Be Equal		${INFO}		Accounts
	${INFO}=	Get Text	xpath=//*[@id='activate']/ol/li[3]
	Should Be Equal		${INFO}		Activate	

Activate accounts - check help info
	[Documentation] 
	[Tags]     regression
	Open Account Test Page		Activate Account
    Page should contain   Accept Terms and Conditions
    Page should contain   Account activation in Ethel stands for accepting all Terms and Conditions which are required to successfully subscribe and use the account on your machine. If you check Accept Terms and Conditions when creating account or attaching subscriptions, the activation is done for you and there's no need for you to use this form.

Activate account with existing username and password
    [Documentation] 
	[Tags]     regression
	Open Account Test Page		Activate Account
	Page should contain   Accept Terms and Conditions
	Input Text     xpath=//form[@id='account_terms']/div/div/input[@id='username']    ${EXISTING_USERNAME}
    Input Text     xpath=//form[@id='account_terms']/div/div/input[@id='password']    ${PASSWORD}
	Click Element	xpath=//form[@id='account_terms']/div/div/input[@id='submit']
	Success Accepted Terms	${EXISTING_USERNAME}
	
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
	Open Account Test Page		Activate Account
	Page should contain   Accept Terms and Conditions
	Input Text     xpath=//form[@id='account_terms']/div/div/input[@id='username']    ${EXISTING_USERNAME}
    Input Text     xpath=//form[@id='account_terms']/div/div/input[@id='password']    ${WRONG_PASSWORD}
	Click Element	xpath=//form[@id='account_terms']/div/div/input[@id='submit']
	${SUCCESS_MESSAGE}=   Catenate  Accepting Ts&Cs for "${EXISTING_USERNAME}"
	Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=20
	${SUCCESS_MESSAGE}=   Set Variable  	Invalid username or password
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
	Test File a bug Link

Activate account with new username and password
    [Documentation] 
	[Tags]     regression
	${TEST_USERNAME}=	Create account without accepting temrs	
	
	${NOT_ACCEPT_CONTENT}=	Set Variable	Red Hat Terms & Conditions 
	Check Terms Status		${TEST_USERNAME}	${NOT_ACCEPT_CONTENT}

    Switch Browser	1
	Click Link		Activate Account
	Click Element	xpath=//form[@id='account_terms']/div/div/input[@id='submit']
	Success Accepted Terms	${TEST_USERNAME}
	
	${ACCEPT_CONTENT}=	Set Variable	Red Hat Account Number
	Check Terms Status		${TEST_USERNAME}	${ACCEPT_CONTENT}

*** Keywords ***
Create account without accepting temrs
	[Documentation]		  
    ${TEST_USERNAME}  Generate Username
	Open Account Test Page		Create Account
    Page should contain   Create account
    Input Text		id=username    ${TEST_USERNAME}
    Input Text		id=password    ${PASSWORD}
    Click Element	id=terms
    Click Element	id=submit
	Created without accepting terms	${TEST_USERNAME}
	[Return]	${TEST_USERNAME}
	
Success Accepted Terms
	[Documentation]	
	[Arguments]   ${TEST_USERNAME}
	${SUCCESS_MESSAGE}=   Catenate  Accepting Ts&Cs for "${TEST_USERNAME}"
	Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=20
	${SUCCESS_MESSAGE}=   Set Variable  All Terms and Conditions accepted	
	Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=20
