*** Settings ***
Documentation     Attach subscriptions
Resource          ../resources/global.robot
Suite Setup       Open Browser  ${FRONT_PAGE}   ${BROWSER}
#Suite Teardown    Close All Browsers

*** Variables ***

*** Test Cases ***
View accounts - check url location
    [Documentation] 
	[Tags]     regression
	Open Account Test Page		View Account
    Page should contain   View Account
    Page should contain   Attached subscriptions
	${location}=	Get location
	
View accounts - check required field
    [Documentation] 
	[Tags]     regression
	Open Account Test Page		View Account
    Page should contain   View Account
    Page should contain   Attached subscriptions
	${REQUIRED}=	Get Element Attribute	//form[@id='account_view']/div/div/input[@id='username']@required
	Should Be Equal		${REQUIRED}	true
	${REQUIRED}=	Get Element Attribute	//form[@id='account_view']/div/div/input[@id='password']@required
	Should Be Equal		${REQUIRED}	true	

View accounts - check input default info
	[Documentation] 
	[Tags]     regression
	Open Account Test Page		View Account
    Page should contain   View Account
    Page should contain   Attached subscriptions
	${INFO}=	Get Element Attribute	//form[@id='account_view']/div/div/input[@id='username']@placeholder
	Should Be Equal		${INFO}		login
	${INFO}=	Get Element Attribute	//form[@id='account_view']/div/div/input[@id='password']@placeholder
	Should Be Equal		${INFO}		password
	
View accounts - check page title
	[Documentation] 
	[Tags]     regression
	Open Account Test Page		View Account
    Page should contain   View Account
    Page should contain   Attached subscriptions
	${INFO}=	Get Text	xpath=//*[@id='view']/ol/li[2]/strong
	Should Be Equal		${INFO}		Account Viewer
	${INFO}=	Get Text	xpath=//*[@id='view']/ol/li[3]
	Should Be Equal		${INFO}		View	

View accounts - check help info
	[Documentation] 
	[Tags]     regression
	Open Account Test Page		View Account
    Page should contain   View Account
    Page should contain   Attached subscriptions
	Page should contain		Sometimes, especially when your account has tons of Subscriptions attached, it may take a while until all data are successfully retrieved. Be patient please.
	
View accounts having skus with existing username and password
    [Documentation]
    [Tags]    regression
    # Create one new account with sku ${SKU}
    ${TEST_USERNAME}  Generate Username
	Open Account Test Page		Create Account
    Page should contain   Create account
    Input Text		id=username		${TEST_USERNAME}
    Input Text		id=password		${PASSWORD}
    #Input Text		id=sku			${SKU}
    #Input Text		id=quantity		${QUANTITY}
    Click Element  id=submit
    Success Created		${TEST_USERNAME}
	#Success Created and Attach		${TEST_USERNAME}
	
	# Attach
	Click Link		Add Subscriptions
    Page should contain   Add subscriptions
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='sku']    		${SKU}
    Input Text     xpath=//form[@id='pool_create']/div/div/input[@id='quantity']    ${QUANTITY}
    Click Element  xpath=//form[@id='pool_create']/div/div/input[@id='submit']
    Success Attached	${TEST_USERNAME}
	
	# Refresh
	Click Link		Refresh Subscriptions
	Click Element  xpath=//form[@id='pool_refresh']/div/div/input[@id='submit']
	Success Refreshed		${TEST_USERNAME}
	
	# View account
    Click Link		View Account
    Page should contain   View Account
    Page should contain   Attached subscriptions  
    #Input Text     xpath=//form[@id='account_view']/div/div/input[@id='username']    ${TEST_USERNAME}
    #Input Text     xpath=//form[@id='account_view']/div/div/input[@id='password']    ${PASSWORD}
    Click Element  xpath=//form[@id='account_view']/div/div/input[@id='submit']
	Success Viewed		${TEST_USERNAME}
	# Check SKU
	#${SUCCESS_MESSAGE}=   Catenate  Attached subscriptions for '${TEST_USERNAME}''
    #${SUCCESS_MESSAGE}=   Catenate  Attached subscriptions for '${TEST_USERNAME}'
    #Page should contain 	${SUCCESS_MESSAGE}
    sleep	3
    Table Header Should Contain		xpath=//table[@id="DataTables_Table_0"]		Subscription ID
    Table Header Should Contain		xpath=//table[@id="DataTables_Table_0"]		Product Name
    Table Header Should Contain		xpath=//table[@id="DataTables_Table_0"]		Quantity
    Table Header Should Contain		xpath=//table[@id="DataTables_Table_0"]		Subscription pool
    ${RETURN}=		Get Table Cell		xpath=//table[@id="DataTables_Table_0"]		2		1
    Should Be Equal		${RETURN}    ${SKU}
    ${RETURN}=		Get Table Cell		xpath=//table[@id="DataTables_Table_0"]		2		3
    Should Be Equal		${RETURN}    ${QUANTITY}

View accounts without skus with existing username and password
    [Documentation]
    [Tags]    regression
    # Create one new account without any sku
    ${TEST_USERNAME}  Generate Username
	Open Account Test Page		Create Account
    Page should contain   Create account
    Input Text     id=username    ${TEST_USERNAME}
    Input Text     id=password    ${PASSWORD}
    Click Element  id=submit
	Success Created		${TEST_USERNAME}
	
	# View account
    Click Link		View Account
    Page should contain   View Account
    Page should contain   Attached subscriptions
    #Input Text     xpath=//form[@id='account_view']/div/div/input[@id='username']    ${TEST_USERNAME}
    #Input Text     xpath=//form[@id='account_view']/div/div/input[@id='password']    ${PASSWORD}
    Click Element  xpath=//form[@id='account_view']/div/div/input[@id='submit']
	Success Viewed		${TEST_USERNAME}
	# Check SKU
	${SUCCESS_MESSAGE}=   Set Variable  	No data available in table
	Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=20

View accounts with existing username and wrong password
    [Documentation]
    [Tags]    regression
    Open Account Test Page		View Account
    Page should contain   View Account
    Page should contain   Attached subscriptions
    Input Text     xpath=//form[@id='account_view']/div/div/input[@id='username']    ${EXISTING_USERNAME}
    Input Text     xpath=//form[@id='account_view']/div/div/input[@id='password']    ${WRONG_PASSWORD}
    Click Element  xpath=//form[@id='account_view']/div/div/input[@id='submit']
	${SUCCESS_MESSAGE}=   Set Variable  	Invalid username or password
	Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=20
	Test File a bug Link   
    
View accounts with existing username and password including sepcial skus
    [Documentation]
    [Tags]    regression
    Open Account Test Page		View Account
    Page should contain   View Account
    Page should contain   Attached subscriptions
    Input Text     xpath=//form[@id='account_view']/div/div/input[@id='username']    ${SPECIAL_USERNAME}
    Input Text     xpath=//form[@id='account_view']/div/div/input[@id='password']    ${SPECIAL_PASSWORD}
    Click Element  xpath=//form[@id='account_view']/div/div/input[@id='submit']
	Success Viewed		${SPECIAL_USERNAME}
	# Check SKU
	#${SUCCESS_MESSAGE}=   Catenate  Attached subscriptions for '${SPECIAL_USERNAME}''
    #${SUCCESS_MESSAGE}=   Catenate  Attached subscriptions for '${SPECIAL_USERNAME}'
    #Page should contain 	${SUCCESS_MESSAGE}
  
View accounts with not existing username and password
    [Documentation]
    [Tags]    regression
    ${TEST_USERNAME}  Generate Username
    Open Account Test Page		View Account
    Page should contain   View Account
    Page should contain   Attached subscriptions
    Input Text     xpath=//form[@id='account_view']/div/div/input[@id='username']    ${TEST_USERNAME}
    Input Text     xpath=//form[@id='account_view']/div/div/input[@id='password']    ${TEST_USERNAME}
    Click Element  xpath=//form[@id='account_view']/div/div/input[@id='submit']
	${SUCCESS_MESSAGE}=   Set Variable  	Invalid username or password
	Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=20
	Test File a bug Link 
    

*** Keywords ***
Success Viewed
	[Documentation]
	[Arguments]   ${TEST_USERNAME}
    ${SUCCESS_MESSAGE}=   Catenate  Fetching "${TEST_USERNAME}" account details
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    #${SUCCESS_MESSAGE}=   Set Variable  	Data retrieved successfully
    ${SUCCESS_MESSAGE}=   Set Variable  	Data retieved sucessfully
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	    timeout=500
    
Others
	${SUCCESS_MESSAGE}=   Set Variable		User is not present in Candlepin
	Wait Until Page Contains   ${SUCCESS_MESSAGE}
	Test File a bug Link
	
	${SUCCESS_MESSAGE}=   Set Variable  	No data available in table
	Wait Until Page Contains   ${SUCCESS_MESSAGE}
	
	${SUCCESS_MESSAGE}=   Set Variable  	Invalid username or password
	Wait Until Page Contains   ${SUCCESS_MESSAGE}
	Test File a bug Link
	
	