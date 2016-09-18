*** Settings ***
Documentation     Add Subscriptions
Resource          ../resources/global.robot
Suite Setup	Suite Setup Steps
Test Setup	Test Setup Steps
Test Teardown	Test Teardown Steps
Suite Teardown	Suite Teardown Steps

*** Variables ***

*** Test Cases ***
Add subscriptions - verify url location
    [Documentation] 
	[Tags]     regression
	Location Should Be	${ENTITLE_PAGE}
	
Add subscriptions - verify required field
    [Documentation] 
	[Tags]     regression
	${REQUIRED}=	Get Element Attribute	${Add_Username_Link}@required
	Should Be Equal		${REQUIRED}		true
	${REQUIRED}=	Get Element Attribute	${Add_Password_Link}@required
	Should Be Equal		${REQUIRED}		true
	${REQUIRED}=	Get Element Attribute	${Add_SKUs_Link}@required
	Should Be Equal		${REQUIRED}		true

Add subscriptions - verify optional field
	[Documentation] 
	[Tags]     regression
	${OPTIONAL}=	Get Element Attribute	${Add_Quntity_Link}@required
	Should Be Equal As Strings		${OPTIONAL}		None

Add subscriptions - verify input default info
	[Documentation] 
	[Tags]     regression
	${INFO}=	Get Element Attribute	${Add_Username_Link}@placeholder
	Should Be Equal		${INFO}		login
	${INFO}=	Get Element Attribute	${Add_Password_Link}@placeholder
	Should Be Equal		${INFO}		password
	${INFO}=	Get Element Attribute	${Add_SKUs_Link}@placeholder
	Should Be Equal		${INFO}		SKU1, SKU2,..
	${INFO}=	Get Element Attribute	${Add_Quntity_Link}@placeholder
	Should Be Equal		${INFO}		effective to all SKUs listed above (default = 1)

Add subscriptions - verify page title
	[Documentation] 
	[Tags]     regression
	${INFO}=	Get Text	xpath=//*[@id='entitle']/ol/li[2]/strong
	Should Be Equal		${INFO}		Subscription Pools
	${INFO}=	Get Text	xpath=//*[@id='entitle']/ol/li[3]
	Should Be Equal		${INFO}		Entitle

Add subscriptions - verify help info
	[Documentation] 
	[Tags]     regression
    # Check help info 1
    Page should contain		You can populate your account on this tab by adding pools of subscriptions. These pools will appear in the list of all available subscriptions to systems that have registered to this account.
	Page should contain		You can test your account via the Stage Customer Portal.
	
	# Check help info 2
	Page should contain		TIP:You can check your account before adding SKUs via View Account tab.
	
	# Check Link for 'Stage Customer Portal'
	Click Element		link=Stage Customer Portal
	Sleep	2
	Location should be	${STAGE_PORTAL_URL}
	Go Back

    # Check Link for 'View Accounts'
    Click Element		xpath=//*[@id='entitle']/div[2]/div/div[2]/div[2]/a
    #Click Element		link=View Accounts
    Location should be	${VIEW_PAGE}
    

Add subscriptions - verify quantity field
    [Documentation]
    [Tags]    regression
    # <input id="username" class="form-control" type="text" value="" required="" placeholder="login" name="username"/>
    # <input id="quantity" class="form-control" type="number" value="" placeholder="value above 0 effective to all SKUs listed above" name="quantity" min="1"/>
    ${type_value}=	Get Element Attribute	${Add_Quntity_Link}@type
	Should Be Equal		${type_value}		number
	${min_value}=	Get Element Attribute	${Add_Quntity_Link}@min
	Should Be Equal		${min_value}		1 
    
Add subscriptions with existing username, password, valid sku and quantity
    [Documentation]
    [Tags]    regression
    Input Text     xpath=${Add_Username_Link}    ${EXISTING_USERNAME}
    Input Text     xpath=${Add_Password_Link}    ${PASSWORD}
    Input Text     xpath=${Add_SKUs_Link}    		${SKU}
    Input Text     xpath=${Add_Quntity_Link}    ${QUANTITY}
    Click Element  xpath=${Add_Entitle_Link}
    
    # Verify result
	Verify result after add sku successfully		${EXISTING_USERNAME}

Add subscriptions with existing username, password, valid skus and quantity
    [Documentation]		several skus: including correct and invalid skus 
    [Tags]    regression
    Input Text     xpath=${Add_Username_Link}    ${EXISTING_USERNAME}
    Input Text     xpath=${Add_Password_Link}    ${PASSWORD}
    Input Text     xpath=${Add_SKUs_Link}    		${SKUS}
    Input Text     xpath=${Add_Quntity_Link}    ${QUANTITY}
    Click Element  xpath=${Add_Entitle_Link}
    
    # Verify result
    Verify result after add sku successfully		${EXISTING_USERNAME}	

Add subscriptions with existing username, password, valid sku and null quantity
    [Documentation]
    [Tags]    regression
    Input Text     xpath=${Add_Username_Link}    ${EXISTING_USERNAME}
    Input Text     xpath=${Add_Password_Link}    ${PASSWORD}
    Input Text     xpath=${Add_SKUs_Link}    		${SKU}
    Click Element  xpath=${Add_Entitle_Link}

	# Verify result
	Verify result after add sku successfully		${EXISTING_USERNAME}	

Add subscriptions with existing username, password, invalid sku and null quantity
    [Documentation]		
    [Tags]    regression
    Input Text     xpath=${Add_Username_Link}    ${EXISTING_USERNAME}
    Input Text     xpath=${Add_Password_Link}    ${PASSWORD}
    Input Text     xpath=${Add_SKUs_Link}    		${INVALID_SKU}
    Click Element  xpath=${Add_Entitle_Link}
	
	# Verify result
	${SUCCESS_MESSAGE}=   Catenate  Adding subscriptions to "${EXISTING_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    ${INVALID_SKU_LIST}=	Split String	${INVALID_SKU}	,
	${SUCCESS_MESSAGE}=   Set Variable  Bad request: Value of 'sku (${INVALID_SKU_LIST})' parameter is not valid input
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    Test File a bug Link	

Add subscriptions with existing username, password, invalid sku and quantity
    [Documentation]
    [Tags]    regression
    Input Text     xpath=${Add_Username_Link}    ${EXISTING_USERNAME}
    Input Text     xpath=${Add_Password_Link}    ${PASSWORD}
    Input Text     xpath=${Add_SKUs_Link}    		${INVALID_SKU}
    Input Text     xpath=${Add_Quntity_Link}    ${QUANTITY}
    Click Element  xpath=${Add_Entitle_Link}
    
    # Verify result
    ${SUCCESS_MESSAGE}=   Catenate  Adding subscriptions to "${EXISTING_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    ${INVALID_SKU_LIST}=	Split String	${INVALID_SKU}	,
	${SUCCESS_MESSAGE}=   Set Variable  Bad request: Value of 'sku (${INVALID_SKU_LIST})' parameter is not valid input
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    Test File a bug Link

Add subscriptions with existing username, password, invalid skus and quantity
    [Documentation]
    [Tags]    regression
    Input Text     xpath=${Add_Username_Link}    ${EXISTING_USERNAME}
    Input Text     xpath=${Add_Password_Link}    ${PASSWORD}
    Input Text     xpath=${Add_SKUs_Link}    		${INVALID_SKUS}
    Input Text     xpath=${Add_Quntity_Link}    ${QUANTITY}
    Click Element  xpath=${Add_Entitle_Link}
    
    # Verify result
    ${SUCCESS_MESSAGE}=   Catenate  Adding subscriptions to "${EXISTING_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
	${INVALID_SKU_LIST}=	Split String	${INVALID_SKUS}	,
	${SUCCESS_MESSAGE}=   Set Variable  Bad request: Value of 'sku (${INVALID_SKU_LIST})' parameter is not valid input
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    Test File a bug Link

Add subscriptions with existing username, password, valid and invalid skus and quantity
    [Documentation]
    [Tags]    regression
    ${VALID_INVALID_SKUS}=	Catenate	${SKU},${INVALID_SKU}
    Input Text     xpath=${Add_Username_Link}    ${EXISTING_USERNAME}
    Input Text     xpath=${Add_Password_Link}    ${PASSWORD}
    Input Text     xpath=${Add_SKUs_Link}    		${VALID_INVALID_SKUS}
    Input Text     xpath=${Add_Quntity_Link}    ${QUANTITY}
    Click Element  xpath=${Add_Entitle_Link}
    
    # Verify result
    ${SUCCESS_MESSAGE}=   Catenate  Adding subscriptions to "${EXISTING_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    ${INVALID_SKU_LIST}=	Split String	${INVALID_SKU}	,
	#${SUCCESS_MESSAGE}=   Set Variable  Unable to attach SKUs (not found in the DB): ${INVALID_SKU_LIST}
	${SUCCESS_MESSAGE}=   Set Variable  Bad request: Value of 'sku (${INVALID_SKU_LIST})' parameter is not valid input
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    Test File a bug Link

Add subscriptions with existing username, wrong password, sku and quantity
    [Documentation]
    [Tags]    regression
    Input Text     xpath=${Add_Username_Link}    ${EXISTING_USERNAME}
    Input Text     xpath=${Add_Password_Link}    ${WRONG_PASSWORD}
    Input Text     xpath=${Add_SKUs_Link}    		${SKU}
    Input Text     xpath=${Add_Quntity_Link}    ${QUANTITY}
    Click Element  xpath=${Add_Entitle_Link}
    
    # Verify result
    ${SUCCESS_MESSAGE}=   Catenate  Accepting Ts&Cs for "${EXISTING_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
	${SUCCESS_MESSAGE}=   Set Variable  	Invalid username or password
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    Test File a bug Link

Add subscriptions with new username, password, sku and quantity
    [Documentation]
    [Tags]    regression
    ${TEST_USERNAME}=	Generate username
    Input Text     xpath=${Add_Username_Link}    ${TEST_USERNAME}
    Input Text     xpath=${Add_Password_Link}	${PASSWORD}
    Input Text     xpath=${Add_SKUs_Link}    		${SKU}
    Input Text     xpath=${Add_Quntity_Link}    ${QUANTITY}
    Click Element  xpath=${Add_Entitle_Link}
    
    # Verify result
    ${SUCCESS_MESSAGE}=   Catenate  Accepting Ts&Cs for "${TEST_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
	${SUCCESS_MESSAGE}=   Set Variable  	Invalid username or password
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    Test File a bug Link  

Add subscriptions with existing username, password, sku and quantity without accepting terms
	[Documentation]
    [Tags]    regression
    Input Text     xpath=${Add_Username_Link}    ${EXISTING_USERNAME}
    Input Text     xpath=${Add_Password_Link}    ${PASSWORD}
    Input Text     xpath=${Add_SKUs_Link}    		${SKU}
    Input Text     xpath=${Add_Quntity_Link}    ${QUANTITY}
    Click Element  xpath=//form[@id='pool_create']/div/div/div/label/input[@id='terms']
    Click Element  xpath=${Add_Entitle_Link}
    
    # Verify result	
    ${SUCCESS_MESSAGE}=   Catenate  Adding subscriptions to "${EXISTING_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=20
    ${SUCCESS_MESSAGE}=   Set Variable  	All pools successfully added
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	    timeout=500

*** Keywords ***
Suite Setup Steps
	Log	Suite Begin...
	Open Browser  ${FRONT_PAGE}   ${BROWSER}
	Maximize Browser Window

Test Setup Steps
	Log	Suite Begin...   
    Go to Front Page
    Wait Until Page Contains Element   link=Add Subscriptions
    Click Link       Add Subscriptions
    Page Should Contain Element	xpath=${Add_Entitle_Link}
    Capture Page Screenshot

Test Teardown Steps
	Capture Page Screenshot
	Log	Testing End...

Suite TearDown Steps
	Close All Browsers
	Log	Suite End...	
	
