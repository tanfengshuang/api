*** Settings ***
Documentation     Add Subscriptions
Resource          ../resources/global.robot
Suite Setup       Open Browser  ${FRONT_PAGE}   ${BROWSER}
Suite Teardown    Close All Browsers

*** Variables ***


*** Test Cases ***
Attach skus - check url location
    [Documentation] 
	[Tags]     regression
	Open Account Test Page		Add Subscriptions
    Page should contain   Add subscriptions
	${location}=	Get location
	
Attach skus - check required field
    [Documentation] 
	[Tags]     regression
	Open Account Test Page		Add Subscriptions
    Page should contain   Add subscriptions
	${REQUIRED}=	Get Element Attribute	//form[@id='pool_create']/div/div/input[@id='username']@required
	Should Be Equal		${REQUIRED}		true
	${REQUIRED}=	Get Element Attribute	//form[@id='pool_create']/div/div/input[@id='password']@required
	Should Be Equal		${REQUIRED}		true
	${REQUIRED}=	Get Element Attribute	//form[@id='pool_create']/div/div/input[@id='sku']@required
	Should Be Equal		${REQUIRED}		true

Attach skus - check optional field
	[Documentation] 
	[Tags]     regression
	Open Account Test Page		Add Subscriptions
    Page should contain   Add subscriptions
	${OPTIONAL}=	Get Element Attribute	//form[@id='pool_create']/div/div/input[@id='quantity']@required
	Should Be Equal As Strings		${OPTIONAL}		None

Attach skus - check input default info
	[Documentation] 
	[Tags]     regression
	Open Account Test Page		Add Subscriptions
    Page should contain   Add subscriptions
	${INFO}=	Get Element Attribute	//form[@id='pool_create']/div/div/input[@id='username']@placeholder
	Should Be Equal		${INFO}		login
	${INFO}=	Get Element Attribute	//form[@id='pool_create']/div/div/input[@id='password']@placeholder
	Should Be Equal		${INFO}		password
	${INFO}=	Get Element Attribute	//form[@id='pool_create']/div/div/input[@id='sku']@placeholder
	Should Be Equal		${INFO}		SKU1, SKU2,..
	${INFO}=	Get Element Attribute	//form[@id='pool_create']/div/div/input[@id='quantity']@placeholder
	Should Be Equal		${INFO}		value above 0 effective to all SKUs listed above

Attach skus - check page title
	[Documentation] 
	[Tags]     regression
	Open Account Test Page		Add Subscriptions
    Page should contain   Add subscriptions
	${INFO}=	Get Text	xpath=//*[@id='entitle']/ol/li[2]/strong
	Should Be Equal		${INFO}		Subscription Pools
	${INFO}=	Get Text	xpath=//*[@id='entitle']/ol/li[3]
	Should Be Equal		${INFO}		Entitle

Attach skus - check help info
	[Documentation] 
	[Tags]     regression
	Open Account Test Page		Add Subscriptions
    Page should contain   Add subscriptions
    # 1
    Page should contain		You can populate your account on this tab by adding pools of subscriptions. These pools will appear in the list of all available subscriptions to systems that have registered to this account.
	Page should contain		You can test your account via the Stage Customer Portal.
	# 2
	Page should contain		TIP:You can check your account before adding SKUs via View Accounts tab. 

Attach skus with existing username, password, sku and quantity without accepting terms
	[Documentation]
    [Tags]    regression
    Open Account Test Page		Add Subscriptions
    Page should contain   Add subscriptions
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='username']    ${EXISTING_USERNAME}
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='password']    ${PASSWORD}
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='sku']    		${SKU}
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='quantity']    ${QUANTITY}
    Click Element  xpath=//form[@id='pool_create']/div/div/div/label/input[@id='terms']
    Click Element  xpath=//form[@id='pool_create']/div/div/input[@id='submit']
	Success Attached without accepting terms		${EXISTING_USERNAME}  
    
Attach skus with existing username, password, sku and quantity
    [Documentation]
    [Tags]    regression
    Open Account Test Page		Add Subscriptions
    Page should contain   Add subscriptions
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='username']    ${EXISTING_USERNAME}
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='password']    ${PASSWORD}
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='sku']    		${SKU}
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='quantity']    ${QUANTITY}
    Click Element  xpath=//form[@id='pool_create']/div/div/input[@id='submit']
	Success Attached		${EXISTING_USERNAME}

Attach skus with existing username, password, several skus and quantity
    [Documentation]		several skus: including correct and invalid skus 
    [Tags]    regression
    Open Account Test Page		Add Subscriptions
    Page should contain   Add subscriptions
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='username']    ${EXISTING_USERNAME}
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='password']    ${PASSWORD}
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='sku']    		${SKUS}
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='quantity']    ${QUANTITY}
    Click Element  xpath=//form[@id='pool_create']/div/div/input[@id='submit']
    #${SUCCESS_MESSAGE}=   Catenate  Attaching subscriptions to "${EXISTING_USERNAME}"
    #Wait Until Page Contains   ${SUCCESS_MESSAGE}
    Success Attached		${EXISTING_USERNAME}
    ${SUCCESS_MESSAGE}=   Set Variable  	Unable to attach SKUs (not found in the DB):
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	    timeout=500
	

Attach skus with existing username, password, sku and null quantity
    [Documentation]
    [Tags]    regression
    Open Account Test Page		Add Subscriptions
    Page should contain   Add subscriptions
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='username']    ${EXISTING_USERNAME}
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='password']    ${PASSWORD}
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='sku']    		${SKU}
    Click Element  xpath=//form[@id='pool_create']/div/div/input[@id='submit']
    # What should be the correct reaction for quantity is null
	Success Attached		${EXISTING_USERNAME}

Attach skus with existing username, password, sku and zero quantity
    [Documentation]		also include 'Success Attached' info, for AJAX testing, think about how to except some result...
    [Tags]    regression
    Open Account Test Page		Add Subscriptions
    Page should contain   Add subscriptions
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='username']    ${EXISTING_USERNAME}
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='password']    ${PASSWORD}
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='sku']    		${SKU}
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='quantity']    0
    Click Element  xpath=//form[@id='pool_create']/div/div/input[@id='submit']
	${SUCCESS_MESSAGE}=   Catenate  Attaching subscriptions to "${EXISTING_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    ${SUCCESS_MESSAGE}=   Set Variable	Bad request: 'Invalid quantity value'
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    Test File a bug Link

Attach skus with existing username, password, invalid sku and zero quantity
    [Documentation]		also include 'Success Attached' info, for AJAX testing, think about how to except some result...
    [Tags]    regression
    Open Account Test Page		Add Subscriptions
    Page should contain   Add subscriptions
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='username']    ${EXISTING_USERNAME}
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='password']    ${PASSWORD}
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='sku']    		${WRONG_SKU}
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='quantity']    0
    Click Element  xpath=//form[@id='pool_create']/div/div/input[@id='submit']
	${SUCCESS_MESSAGE}=   Catenate  Attaching subscriptions to "${EXISTING_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    #${SUCCESS_MESSAGE}=   Set Variable  	Unable to attach SKUs (not found in the DB):
    #Wait Until Page Contains   ${SUCCESS_MESSAGE}	    timeout=50
    ${SUCCESS_MESSAGE}=   Set Variable	Bad request: 'Invalid quantity value'
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    Test File a bug Link

Attach skus with existing username, password, sku and negative quantity
    [Documentation]
    [Tags]    regression
    Open Account Test Page		Add Subscriptions
    Page should contain   Add subscriptions
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='username']    ${EXISTING_USERNAME}
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='password']    ${PASSWORD}
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='sku']    		${SKUS}
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='quantity']    ${NEGTIVE_QUANTITY}
    Click Element  xpath=//form[@id='pool_create']/div/div/input[@id='submit']
	${SUCCESS_MESSAGE}=   Catenate  Attaching subscriptions to "${EXISTING_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    ${SUCCESS_MESSAGE}=   Set Variable	Bad request: 'Invalid quantity value'
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    Test File a bug Link

Attach skus with existing username, password, invalid sku and quantity
    [Documentation]
    [Tags]    regression
    Open Account Test Page		Add Subscriptions
    Page should contain   Add subscriptions
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='username']    ${EXISTING_USERNAME}
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='password']    ${PASSWORD}
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='sku']    		${WRONG_SKU}
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='quantity']    ${QUANTITY}
    Click Element  xpath=//form[@id='pool_create']/div/div/input[@id='submit']
    ${SUCCESS_MESSAGE}=   Catenate  Attaching subscriptions to "${EXISTING_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
	${SUCCESS_MESSAGE}=   Set Variable  Unable to attach SKUs (not found in the DB): [u'${WRONG_SKU}']
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    Test File a bug Link

Attach skus with existing username, password, invalid skus and quantity
    [Documentation]
    [Tags]    regression
    Open Account Test Page		Add Subscriptions
    Page should contain   Add subscriptions
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='username']    ${EXISTING_USERNAME}
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='password']    ${PASSWORD}
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='sku']    		${WRONG_SKUS}
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='quantity']    ${QUANTITY}
    Click Element  xpath=//form[@id='pool_create']/div/div/input[@id='submit']
    ${SUCCESS_MESSAGE}=   Catenate  Attaching subscriptions to "${EXISTING_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
	${SUCCESS_MESSAGE}=   Set Variable  Unable to attach SKUs (not found in the DB):
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    Test File a bug Link

Attach skus with existing username, wrong password, sku and quantity
    [Documentation]
    [Tags]    regression
    Open Account Test Page		Add Subscriptions
    Page should contain   Add subscriptions
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='username']    ${EXISTING_USERNAME}
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='password']    ${WRONG_PASSWORD}
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='sku']    		${SKU}
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='quantity']    ${QUANTITY}
    Click Element  xpath=//form[@id='pool_create']/div/div/input[@id='submit']
    ${SUCCESS_MESSAGE}=   Catenate  Accepting Ts&Cs for "${EXISTING_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
	${SUCCESS_MESSAGE}=   Set Variable  	Invalid username or password
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    Test File a bug Link

Attach skus with new username, password, sku and quantity
    [Documentation]
    [Tags]    regression
    ${TEST_USERNAME}=	Generate username 
    Open Account Test Page		Add Subscriptions
    Page should contain   Add subscriptions
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='username']    ${TEST_USERNAME}
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='password']	${PASSWORD}
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='sku']    		${SKU}
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='quantity']    ${QUANTITY}
    Click Element  xpath=//form[@id='pool_create']/div/div/input[@id='submit']
    ${SUCCESS_MESSAGE}=   Catenate  Accepting Ts&Cs for "${TEST_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
	${SUCCESS_MESSAGE}=   Set Variable  	Invalid username or password
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    Test File a bug Link  


*** Keywords ***

