*** Settings ***
Documentation     Attach subscriptions
Resource          ../resources/global.robot
Suite Setup	Suite Setup Steps
Test Setup	Test Setup Steps
Test Teardown	Test Teardown Steps
Suite Teardown	Suite Teardown Steps

*** Variables ***

*** Test Cases ***
Refresh Subscriptions - verify url location
    [Documentation] 
	[Tags]     regression
	${location}=	Get location
	
Refresh Subscriptions - verify required field
    [Documentation] 
	[Tags]     regression
	${REQUIRED}=	Get Element Attribute	${Refresh_Username_Link}@required
	Should Be Equal		${REQUIRED}		true
	${REQUIRED}=	Get Element Attribute	${Refresh_Password_Link}@required
	Should Be Equal		${REQUIRED}		true

Refresh Subscriptions - verify input default info
	[Documentation] 
	[Tags]     regression
	${INFO}=	Get Element Attribute	${Refresh_Username_Link}@placeholder
	Should Be Equal		${INFO}		login
	${INFO}=	Get Element Attribute	${Refresh_Password_Link}@placeholder
	Should Be Equal		${INFO}		password

Refresh Subscriptions - verify page title
	[Documentation] 
	[Tags]     regression
	${INFO}=	Get Text	xpath=//*[@id='refresh']/ol/li[2]/strong
	Should Be Equal		${INFO}		Subscription Pools
	${INFO}=	Get Text	xpath=//*[@id='refresh']/ol/li[3]
	Should Be Equal		${INFO}		Refresh

Refresh Subscriptions - verify help info
	[Documentation] 
	[Tags]     regression
    # Check help info
    Page should contain		You can refresh the Subscriptions of your account here. This is necessary in case some discrepancy between candlepin pool data and customer's current subscription data occures. For further info, see this Mojo page.
    # Check Mojo page link
    # <a href="https://mojo.redhat.com/docs/DOC-953386">Mojo page</a>
    ${LINK}=	Get Element Attribute	//*[@id='refresh']/div[2]/div/div[2]/div/p/a@href
    Should Be Equal		${LINK}		${MOJO_PAGE_URL}

Refresh Subscriptions having skus with accepting terms
    [Tags]    regression
    Input Text     xpath=${Refresh_Username_Link}    ${EXISTING_USERNAME}
    Input Text     xpath=${Refresh_Password_Link}    ${PASSWORD}
    Click Element  xpath=${Refresh_Refresh_Link}
    
    # Verify result	
	${SUCCESS_MESSAGE}=   Catenate  Refreshing subscriptions for "${EXISTING_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}		timeout=500
    ${SUCCESS_MESSAGE}=   Set Variable  	All attached pools were refreshed successfully
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	    timeout=500

Refresh Subscriptions with existing username and wrong password
    [Tags]    regression
    Input Text     xpath=${Refresh_Username_Link}    ${EXISTING_USERNAME}
    Input Text     xpath=${Refresh_Password_Link}    ${WRONG_PASSWORD}
    Click Element  xpath=${Refresh_Refresh_Link}
    
    # Verify result
    ${SUCCESS_MESSAGE}=   Catenate  Refreshing subscriptions for "${EXISTING_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
	${SUCCESS_MESSAGE}=   Set Variable  	Invalid username or password
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    Test File a bug Link

Refresh Subscriptions with new username and password
    [Tags]    regression
    ${TEST_USERNAME}=	Generate username
    Input Text     xpath=${Refresh_Username_Link}    ${TEST_USERNAME}
    Input Text     xpath=${Refresh_Password_Link}    ${PASSWORD}
    Click Element  xpath=${Refresh_Refresh_Link}
    
    # Verify result
    ${SUCCESS_MESSAGE}=   Catenate  Refreshing subscriptions for "${TEST_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
	${SUCCESS_MESSAGE}=   Set Variable  	Invalid username or password
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    Test File a bug Link

*** Keywords ***
Suite Setup Steps
	Log	Suite Begin...
	Open Browser  ${FRONT_PAGE}   ${BROWSER}
	Maximize Browser Window

Test Setup Steps
	Log	Suite Begin...   
    Go to Front Page
    Wait Until Page Contains Element   link=Refresh Subscriptions
    Click Link       Refresh Subscriptions
    Page should contain Element	${Refresh_Refresh_Link}
    Capture Page Screenshot

Test Teardown Steps
	Capture Page Screenshot
	Log	Testing End...

Suite TearDown Steps
	Close All Browsers
	Log	Suite End...	