*** Settings ***
Documentation     Attach subscriptions
Resource          ../resources/global.robot
Suite Setup       Open Browser  ${FRONT_PAGE}   ${BROWSER}
Suite Teardown    Close All Browsers

*** Variables ***


*** Variables ***
${correct_username}    "ftan_test"
${wrong_username}    "not"
${correct_password}    "redhat"
${wrong_password}    "redhat111"

*** Test Cases ***
Refresh accounts - check url location
    [Documentation] 
	[Tags]     regression
	Open Account Test Page		Refresh Subscriptions
    Page should contain   Refresh account subscriptions
	${location}=	Get location
	
Refresh accounts - check required field
    [Documentation] 
	[Tags]     regression
	Open Account Test Page		Refresh Subscriptions
    Page should contain   Refresh account subscriptions
	${REQUIRED}=	Get Element Attribute	//form[@id='pool_refresh']/div/div/input[@id='username']@required
	Should Be Equal		${REQUIRED}		true
	${REQUIRED}=	Get Element Attribute	//form[@id='pool_refresh']/div/div/input[@id='password']@required
	Should Be Equal		${REQUIRED}		true

Refresh accounts - check input default info
	[Documentation] 
	[Tags]     regression
	Open Account Test Page		Refresh Subscriptions
    Page should contain   Refresh account subscriptions
	${INFO}=	Get Element Attribute	//form[@id='pool_refresh']/div/div/input[@id='username']@placeholder
	Should Be Equal		${INFO}		login
	${INFO}=	Get Element Attribute	//form[@id='pool_refresh']/div/div/input[@id='password']@placeholder
	Should Be Equal		${INFO}		password

Refresh accounts - check page title
	[Documentation] 
	[Tags]     regression
	Open Account Test Page		Refresh Subscriptions
    Page should contain   Refresh account subscriptions
	${INFO}=	Get Text	xpath=//*[@id='refresh']/ol/li[2]/strong
	Should Be Equal		${INFO}		Subscription Pools
	${INFO}=	Get Text	xpath=//*[@id='refresh']/ol/li[3]
	Should Be Equal		${INFO}		Refresh

Refresh accounts - check help info
	[Documentation] 
	[Tags]     regression
	Open Account Test Page		Refresh Subscriptions
    Page should contain   Refresh account subscriptions
    Page should contain		You can refresh the Subscriptions of your account on this tab.You can populate your account on this tab by adding pools of subscriptions. These pools will appear in the list of all available subscriptions to systems that have registered to this account.

Refresh accounts having skus
    [Tags]    regression
    Open Account Test Page		Refresh Subscriptions
    Page should contain   Refresh account subscriptions
    Input Text     xpath=//form[@id='pool_refresh']/div/div/input[@id='username']    ${EXISTING_USERNAME}
    Input Text     xpath=//form[@id='pool_refresh']/div/div/input[@id='password']    ${PASSWORD}
    Click Element  xpath=//form[@id='pool_refresh']/div/div/input[@id='submit']
	Success Refreshed		${EXISTING_USERNAME}
    #Pause Execution
    #Log Source     loglevel=WARN

Refresh accounts without sku
    [Tags]    regression
    Log		Waiting

Refresh accounts with accepting terms
    [Tags]    regression
    Log		Waiting

Refresh accounts without accepting terms
    [Tags]    regression
    Log		Waiting

Refresh accounts with existing username and wrong password
    [Tags]    regression
    Open Account Test Page		Refresh Subscriptions
    Page should contain   Refresh account subscriptions
    Input Text     xpath=//form[@id='pool_refresh']/div/div/input[@id='username']    ${EXISTING_USERNAME}
    Input Text     xpath=//form[@id='pool_refresh']/div/div/input[@id='password']    ${WRONG_PASSWORD}
    Click Element  xpath=//form[@id='pool_refresh']/div/div/input[@id='submit']
    ${SUCCESS_MESSAGE}=   Catenate  Refreshing subscriptions for "${EXISTING_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
	${SUCCESS_MESSAGE}=   Set Variable  	Invalid username or password
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    Test File a bug Link

Refresh accounts with new username and password
    [Tags]    regression
    Open Account Test Page		Refresh Subscriptions
    Page should contain   Refresh account subscriptions
    ${TEST_USERNAME}=	Generate username
    Input Text     xpath=//form[@id='pool_refresh']/div/div/input[@id='username']    ${TEST_USERNAME}
    Input Text     xpath=//form[@id='pool_refresh']/div/div/input[@id='password']    ${PASSWORD}
    Click Element  xpath=//form[@id='pool_refresh']/div/div/input[@id='submit']
    ${SUCCESS_MESSAGE}=   Catenate  Refreshing subscriptions for "${TEST_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
	${SUCCESS_MESSAGE}=   Set Variable  	Invalid username or password
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    Test File a bug Link

*** Keywords ***
