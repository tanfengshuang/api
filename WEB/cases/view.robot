*** Settings ***
Documentation     Attach subscriptions
Resource          ../resources/global.robot
Suite Setup       Open Browser  ${FRONT_PAGE}   ${BROWSER}
#Suite Teardown    Close All Browsers

*** Variables ***
${View_Username_Link}	//form[@id='account_view']/div/div/input[@id='username']
${View_Password_Link}	//form[@id='account_view']/div/div/input[@id='password']
${View_View_Link}		//form[@id='account_view']/div/div/input[@id='submit']

*** Test Cases ***
View account - verify url location
    [Documentation] 
	[Tags]     regression
	Open Account Test Page		View Account
    Page should contain   View Account
    Page should contain   Attached Subscriptions
	${location}=	Get location
	
View account - verify required field
    [Documentation] 
	[Tags]     regression
	Open Account Test Page		View Account
    Page should contain   View Account
    Page should contain   Attached Subscriptions
	${REQUIRED}=	Get Element Attribute	//form[@id='account_view']/div/div/input[@id='username']@required
	Should Be Equal		${REQUIRED}	true
	${REQUIRED}=	Get Element Attribute	//form[@id='account_view']/div/div/input[@id='password']@required
	Should Be Equal		${REQUIRED}	true	

View account - verify input default info
	[Documentation] 
	[Tags]     regression
	Open Account Test Page		View Account
    Page should contain   View Account
    Page should contain   Attached Subscriptions
	${INFO}=	Get Element Attribute	//form[@id='account_view']/div/div/input[@id='username']@placeholder
	Should Be Equal		${INFO}		login
	${INFO}=	Get Element Attribute	//form[@id='account_view']/div/div/input[@id='password']@placeholder
	Should Be Equal		${INFO}		password
	
View account - verify page title
	[Documentation] 
	[Tags]     regression
	Open Account Test Page		View Account
    Page should contain   View Account
    Page should contain   Attached Subscriptions
	${INFO}=	Get Text	xpath=//*[@id='view']/ol/li[2]/strong
	Should Be Equal		${INFO}		Accounts
	${INFO}=	Get Text	xpath=//*[@id='view']/ol/li[3]
	Should Be Equal		${INFO}		View	

View account - verify help info
	[Documentation] 
	[Tags]     regression
	Open Account Test Page		View Account
    Page should contain   View Account
    Page should contain   Attached Subscriptions
	Page should contain		Sometimes, especially when your account contains a lot of subscriptions, it may take a while until all data are successfully retrieved. Be patient please.
	
View account having sku and without accepting terms
	[Documentation] 
	[Tags]     regression

View account without sku and without accepting terms
	[Documentation] 
	...	Create an account without accepting terms
    ...	Actually, we cannot have a account without accepting terms and without skus, as:
    ...	Terms are accepted after call api /account/new, but become un-accepted after add a valid sku with api /account/attach
    ...	But, create(/account/new) a account and activate(/account/activate) it, and then add a valid sku, terms are still accepted
    ...	
    ...	I keep this case for now
	[Tags]     regression
	Log	Waiting

View account having skus with existing username and password
    [Documentation]
    [Tags]    regression
    # Create one new account with sku ${SKU}
    ${TEST_USERNAME}  Generate Username
	Open Account Test Page		Create Account
    Page should contain   Create Account
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
    Page should contain   Attached Subscriptions  
    #Input Text     xpath=//form[@id='account_view']/div/div/input[@id='username']    ${TEST_USERNAME}
    #Input Text     xpath=//form[@id='account_view']/div/div/input[@id='password']    ${PASSWORD}
    Click Element  xpath=//form[@id='account_view']/div/div/input[@id='submit']
	Success Viewed		${TEST_USERNAME}
	# Check SKU
	#${SUCCESS_MESSAGE}=   Catenate  Attached Subscriptions for '${TEST_USERNAME}''
    #${SUCCESS_MESSAGE}=   Catenate  Attached Subscriptions for '${TEST_USERNAME}'
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

View account without skus with existing username and password
    [Documentation]
    [Tags]    regression
    # Create one new account without any sku
    ${TEST_USERNAME}  Generate Username
	Open Account Test Page		Create Account
    Page should contain   Create Account
    Input Text     id=username    ${TEST_USERNAME}
    Input Text     id=password    ${PASSWORD}
    Click Element  id=submit
	Success Created		${TEST_USERNAME}
	
	# View account
    Click Link		View Account
    Page should contain   View Account
    Page should contain   Attached Subscriptions
    #Input Text     xpath=//form[@id='account_view']/div/div/input[@id='username']    ${TEST_USERNAME}
    #Input Text     xpath=//form[@id='account_view']/div/div/input[@id='password']    ${PASSWORD}
    Click Element  xpath=//form[@id='account_view']/div/div/input[@id='submit']
	Success Viewed		${TEST_USERNAME}
	# Check SKU
	${SUCCESS_MESSAGE}=   Set Variable  	No data available in table
	Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=20

View account with existing username and wrong password
    [Documentation]
    [Tags]    regression
    Open Account Test Page		View Account
    Page should contain   View Account
    Page should contain   Attached Subscriptions
    
    Input Text     xpath=//form[@id='account_view']/div/div/input[@id='username']    ${EXISTING_USERNAME}
    Input Text     xpath=//form[@id='account_view']/div/div/input[@id='password']    ${WRONG_PASSWORD}
    Click Element  xpath=//form[@id='account_view']/div/div/input[@id='submit']
    
	${SUCCESS_MESSAGE}=   Set Variable  	Invalid username or password
	Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=20
	Test File a bug Link   
    
View account with one existing username including special sku
    [Documentation]		
    ...	To check quantity for sku whose multiplier is not 1
    ...	${SPECIAL_SKU}: MCT0891
    ...	MCT0891: multiplier is 4
    [Tags]    regression
    # Create one account with special sku
    
    
    Open Account Test Page		View Account
    Page should contain   View Account
    Page should contain   Attached Subscriptions
    
    Input Text     xpath=//form[@id='account_view']/div/div/input[@id='username']    ${_USERNAME}
    Input Text     xpath=//form[@id='account_view']/div/div/input[@id='password']    ${WRONG_PASSWORD}
    Click Element  xpath=//form[@id='account_view']/div/div/input[@id='submit']
    
	${SUCCESS_MESSAGE}=   Set Variable  	Invalid username or password
	Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=20
	Test File a bug Link   
    
    ${TEST_USERNAME}=	Create account with accepting terms	
    ${QUANTITY}=	Convert To Integer	${QUANTITY}	
    Add SKU		${TEST_USERNAME}	${PASSWORD}		${SPECIAL_SKU}		${QUANTITY}
    Refresh Account	${TEST_USERNAME}	${PASSWORD}
    sleep	5
    	
    ${VIEW_INFO}=  Create Dictionary     username=${TEST_USERNAME}    password=${PASSWORD}
    ${STATUS}    ${MSG}=    GET     ${GET_URL}    ${VIEW_INFO}
    Should Be Equal     ${STATUS}    200
    
    #${MULTIPLIER_QUANTITY}=	Evaluate	${QUANTITY}*4
    @{SPECIAL_SKU_LIST}=	Split String	${SPECIAL_SKU}	,
    @{SKU_QUANTITY_LIST}=	Create List
    :For	${i}	IN	@{SPECIAL_SKU_LIST}
    \	&{SPECIAL_SKU_DICT}= 	Create Dictionary	sku=${i}	quantity=${QUANTITY}
   	\	Append To List	${SKU_QUANTITY_LIST}	${SPECIAL_SKU_DICT}
	Log List	list_=@{SKU_QUANTITY_LIST}	
	
    ${STATUS}=	Verify View Result	${MSG}	${TEST_USERNAME}	${SKU_QUANTITY_LIST}
    Should Be Equal		${STATUS}	0

View account with one existing username including special skus 
	[Documentation]		
    ...	To check quantity for skus whose multiplier is not 1
    ...	${SPECIAL_SKUS}: MCT0891,MCT0892,MCT0992
    ...	MCT0891: multiplier is 4
    ...	MCT0892: multiplier is 4 
    ...	MCT0992: multiplier is 4
    [Tags]    regression
       
    
View account with one existing username including jboss skus
    [Documentation]	
	...	Some JBOSS SKUs: MW0167254,MW0267188,MW0341364
	...	Related trac ticket https://engineering.redhat.com/trac/content-tests/ticket/311
	...	For JBoss SKUs the adapters always return unlimited quantity.
	...	JBoss is core-band capacity, but since there is no reconciliation evaluation for each system against the core-band capacity the adapter returns unlimited. 
	...	In reality, an unknown number of systems could attach the subscription and the system's cores in use would be decremented against the core-band until the 
	...	core-band was consumed. When the core-band are completely consumed then the next system to attach would not be able to consume the content (status Red). 
	...	For now, the consumption is contractual and the quantity is unlimited.
	...	MW0167254
	[Tags]    regression
    Open Account Test Page		View Account
    Page should contain   View Account
    Page should contain   Attached Subscriptions
    Input Text     xpath=//form[@id='account_view']/div/div/input[@id='username']    ${}
    Input Text     xpath=//form[@id='account_view']/div/div/input[@id='password']    ${JBOSS_SKUS}
    Click Element  xpath=//form[@id='account_view']/div/div/input[@id='submit']
	Success Viewed		${SPECIAL_USERNAME}
	# Check SKU
	#${SUCCESS_MESSAGE}=   Catenate  Attached Subscriptions for '${SPECIAL_USERNAME}''
    #${SUCCESS_MESSAGE}=   Catenate  Attached Subscriptions for '${SPECIAL_USERNAME}'
    #Page should contain 	${SUCCESS_MESSAGE}
  
View account with not existing username and password
    [Documentation]
    [Tags]    regression
    ${TEST_USERNAME}  Generate Username
    Open Account Test Page		View Account
    Page should contain   View Account
    Page should contain   Attached Subscriptions
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
	
	