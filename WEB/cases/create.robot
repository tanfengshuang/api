*** Settings ***
Documentation     Attach subscriptions
Resource          ../resources/global.robot
Suite Setup	Suite Setup Steps
Test Setup	Test Setup Steps
Test Teardown	Test Teardown Steps
Suite Teardown	Suite Teardown Steps

*** Variables ***

*** Test Cases ***
Create account - verify url location
    [Documentation] 
	[Tags]     regression
	Location Should Be	${CREATE_PAGE}
	    
Create account - verify required fields
    [Documentation] 
	[Tags]     regression
	${REQUIRED}=	Get Element Attribute	username@required
	Should Be Equal		${REQUIRED}		true
	${REQUIRED}=	Get Element Attribute	password@required
	Should Be Equal		${REQUIRED}		true

Create account - verify optional fields
	[Documentation] 
	[Tags]     regression
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
	
Create account - verify input text default info
	[Documentation] 
	[Tags]     regression
	${INFO}=	Get Element Attribute	username@placeholder
	Should Be Equal		${INFO}		login
	${INFO}=	Get Element Attribute	password@placeholder
	Should Be Equal		${INFO}		password
	${INFO}=	Get Element Attribute	first_name@placeholder
	Should Be Equal		${INFO}		(optional)
	${INFO}=	Get Element Attribute	last_name@placeholder
	Should Be Equal		${INFO}		(optional)
	${INFO}=	Get Element Attribute	sku@placeholder
	Should Be Equal		${INFO}		SKU1, SKU2,.. (optional - can be done via Add Subscription tab)
	${INFO}=	Get Element Attribute	quantity@placeholder
	Should Be Equal		${INFO}		effective to all SKUs listed above (default is 1)
	
Create account - verify page title
	[Documentation] 
	[Tags]     regression
	${INFO}=	Get Text	xpath=//*[@id='create']/ol/li[2]/strong
	Should Be Equal		${INFO}		Accounts
	${INFO}=	Get Text	xpath=//*[@id='create']/ol/li[3]
	Should Be Equal		${INFO}		New	
	
Create account - verify help info
	[Documentation] 
	[Tags]     regression
	# Check help info 1
	Page should contain		By using this form you can easily create a brand new account for Stage Candlepin.
	Page should contain		You can test your account via the Stage Customer Portal.
	
	# Check help info 2
	Page should contain		Optionally, you can attach subscription SKUs to the account in one step. This process can also be done any other time, when your account is already created. To do so, please use the Add Subscription tab.
	Page should contain		If you choose to add subscriptions while creating an account you can specify the pool's quantity as well. Please be noted, when you don't specify the quantity yourself, a default value is set. Default value is 1.
	
	# Check help info 3
	Page should contain		TIP:You can check your already created accounts via View Account tab. 
	
	# Check help info 4
	Page should contain		By default, all created accounts are also activated. That means the Terms and Conditions that have to be accepted in order to use the account are automatically accepted. If you want to keep your account inactive, just untick the checkbox.
	Page should contain		Accepting Terms and Conditions is only applicable for accounts that have been populated with Red Hat Subscription SKUs.
	
Create account - verify password length limitation
	[Documentation]
    [Tags]    regression
    # <input id="password" class="form-control" type="text" value="" required="" placeholder="password" name="password" maxlength="25"/>
    ${maxlength}=	Get Element Attribute	password@maxlength
	Should Be Equal		${maxlength}		25

Create account - verify quantity type and min value
    [Documentation]
    [Tags]    regression
    # <input id="username" class="form-control" type="text" value="" required="" placeholder="login" name="username"/>
    # <input id="quantity" class="form-control" type="number" value="" placeholder="value above 0 effective to all SKUs listed above (can be done later)" name="quantity" min="1"/>
    ${type_value}=	Get Element Attribute	quantity@type
	Should Be Equal		${type_value}		number
	${min_value}=	Get Element Attribute	quantity@min
	Should Be Equal		${min_value}		1
	
Create account with new username and password without accepting terms
    [Documentation] 
	...	Create an account without accepting terms
    ...	Actually, we cannot have a account without accepting terms and without skus, as:
    ...	Terms are accepted after call api /account/new, but become un-accepted after add a valid sku with api /account/attach
    ...	But, create(/account/new) a account and activate(/account/activate) it, and then add a valid sku, terms are still accepted
    ...	
	[Tags]     regression	  
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

Create account with new username, password, sku and quantity without accepting terms
    [Documentation]		
    [Tags]    regression 
    ${TEST_USERNAME}  Generate Username
    Input Text		id=username    ${TEST_USERNAME}
    Input Text		id=password    ${PASSWORD}
    Input Text		id=sku			${SKU}
    Input Text		id=quantity		${QUANTITY}
    Click Element	id=terms
    Click Element	id=submit

	# Verify result after created with sku and without accepting terms	
	${SUCCESS_MESSAGE}=   Catenate  Creating account "${TEST_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=50 
    ${SUCCESS_MESSAGE}=   Set Variable  Adding subscriptions to "${TEST_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=50
    ${SUCCESS_MESSAGE}=   Catenate  Creating account owners in Candlepin
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=50 
    ${SUCCESS_MESSAGE}=   Catenate  Account "${TEST_USERNAME}" created
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=50
    
	# Verify terms 
	Check Terms Status		${TEST_USERNAME}	${NOT_ACCEPT_CONTENT}
    
Create account with new username and password
    [Documentation]		
    [Tags]    regression  
    ${TEST_USERNAME}  Generate Username
    Input Text		id=username    ${TEST_USERNAME}
    Input Text		id=password    ${PASSWORD}
    Click Element	id=submit
    
    # Verify result
	Verify result after create account successfully		${TEST_USERNAME}

Create account with new username, password and first_name
    [Documentation]
    [Tags]    regression
	${TEST_USERNAME}  Generate Username
    Input Text     id=username    ${TEST_USERNAME}
    Input Text     id=password    ${PASSWORD}
    Input Text     id=first_name  ${FIRST_NAME}
    Click Element  id=submit
    
    # Verify result
    Verify result after create account successfully		${TEST_USERNAME}
    
Create account with new username, password and last_name
    [Documentation]
    [Tags]    regression
	${TEST_USERNAME}  Generate Username
    Input Text     id=username    ${TEST_USERNAME}
    Input Text     id=password    ${PASSWORD}
    Input Text     id=last_name   ${LAST_NAME}
    Click Element  id=submit
    
    # Verify result
    Verify result after create account successfully		${TEST_USERNAME}
    
Create account with new username, password, first_name and last_name
    [Documentation]
    [Tags]    regression
	${TEST_USERNAME}  Generate username
    Input Text     id=username    ${TEST_USERNAME}
    Input Text     id=password    ${PASSWORD}
    Input Text     id=first_name  ${FIRST_NAME}
    Input Text     id=last_name   ${LAST_NAME}
    Click Element  id=submit
    
    # Verify result
    Verify result after create account successfully		${TEST_USERNAME}

Create account with one existing username and password
    [Documentation]
    [Tags]    regression
    Input Text     id=username    ${EXISTING_USERNAME}
    Input Text     id=password    ${PASSWORD}
    Click Element  id=submit
    
    # Verify result
    User Already Exists

Create account with one existing username and wrong password
    [Documentation]
    [Tags]    regression
    Input Text     id=username    ${EXISTING_USERNAME}
    Input Text     id=password    ${WRONG_PASSWORD}
    Click Element  id=submit
    
    # Verify result
    User Already Exists
    
Create account with one username including special character and password
    [Documentation]
    ...	<input id="username" class="form-control" type="text" value="" title="Login must be at least 5 characters long (up to 255) and cannot contain spaces or 
    ...	the following special characters: (") ($) (^) (<) (>) (|) (+) (%) (/) (;) (:) (,) (\) (*) (=) (~)" required="" placeholder="login" 
    ...	pattern="^[^\s"$\^<>|+%\/;:,\\*=~]{5,255}$" name="username" minlenght="5" maxlength="255"/>
    [Tags]    regression
    #@{SPECIAL_CHARACTER}=    Create List     <	>	(	)	!	*	&	|	.	@	$	^	\	~	`	'	"	{	}	[	]
    @{SPECIAL_CHARACTER}=	Create List		(	)	!	&	.	@	`	'	{	}	[	]
    :For    ${i}    in      @{SPECIAL_CHARACTER}
    \       Log     ${i}
    \		${TEST_USERNAME}=     Generate username
    \       ${TEST_USERNAME}=  Catenate     ${TEST_USERNAME}${i}
    \       Input Text     id=username    ${TEST_USERNAME}
    \		Input Text     id=password    ${PASSWORD}
    \       Input Text     id=first_name  ${FIRST_NAME}
    \		Input Text     id=last_name   ${LAST_NAME}
    \		Click Element  id=submit
    \		# Verify result
    \       Verify result after create account successfully		${TEST_USERNAME}
    
Create account with one new username and password including special character
    [Documentation]
    [Tags]    regression
    @{SPECIAL_CHARACTER}=    Create List     <	>	(	)	!	*	&	|	.	@	$	^	\	~	`	'	"	{	}	[	]	/	\\	\#	%	;	:	,	?
    :For    ${i}    in      @{SPECIAL_CHARACTER}
    \       Log     ${i}
	\		${TEST_USERNAME}=  Generate Username
	\		${SPECIAL_PASSWORD}=	Catenate     ${PASSWORD}${i}
    \		Input Text     id=username    ${TEST_USERNAME}
    \		Input Text     id=password    ${SPECIAL_PASSWORD}
    \		Input Text     id=first_name  ${FIRST_NAME}
    \		Input Text     id=last_name   ${LAST_NAME}
    \		Click Element  id=submit
    \		# Verify result
    \		Verify result after create account successfully		${TEST_USERNAME}

Create account with new username, password, valid sku and quantity
    [Documentation]
    [Tags]    regression
	${TEST_USERNAME}  Generate Username
    Input Text		id=username     ${TEST_USERNAME}
    Input Text		id=password     ${PASSWORD}
    Input Text		id=first_name   ${FIRST_NAME}
    Input Text		id=last_name	${LAST_NAME}
    Input Text		id=sku			${SKU}
    Input Text		id=quantity		${QUANTITY}
    Click Element  id=submit
    
    # Verify result
	Verify result after create create and add sku successfully	${TEST_USERNAME}
    
Create account with new username, password, valid skus and quantity
    [Documentation]
    [Tags]    regression
	${TEST_USERNAME}  Generate Username
    Input Text		id=username     ${TEST_USERNAME}
    Input Text		id=password     ${PASSWORD}
    Input Text		id=first_name   ${FIRST_NAME}
    Input Text		id=last_name	${LAST_NAME}
    Input Text		id=sku			${SKUS}
    Input Text		id=quantity		${QUANTITY}
    Click Element  id=submit
    
	# Verify result
	Verify result after create create and add sku successfully	${TEST_USERNAME}

Create account with new username, password, invalid sku and quantity
    [Documentation]
    [Tags]    regression
	${TEST_USERNAME}  Generate Username
    Input Text		id=username     ${TEST_USERNAME}
    Input Text		id=password     ${PASSWORD}
    Input Text		id=first_name   ${FIRST_NAME}
    Input Text		id=last_name	${LAST_NAME}
    Input Text		id=sku			${INVALID_SKU}
    Input Text		id=quantity		${QUANTITY}
    Click Element  id=submit
    
    # Verify result
    ${SUCCESS_MESSAGE}=   Catenate  Creating account "${TEST_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=20
    ${SUCCESS_MESSAGE}=   Catenate  Accepting Ts&Cs for "${TEST_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=20 
    ${INVALID_SKU_LIST}=	Split String	${INVALID_SKU}	,
    #${SUCCESS_MESSAGE}=   Set Variable  Unable to add SKUs (not found in the DB): ${INVALID_SKU_LIST}
    ${SUCCESS_MESSAGE}=   Catenate  Bad request: Value of 'sku (${INVALID_SKU_LIST})' parameter is not valid input
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=50
    ${SUCCESS_MESSAGE}=   Set Variable  Creating account owners in Candlepin
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=50
    ${SUCCESS_MESSAGE}=   Catenate  Account "${TEST_USERNAME}" created
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=50
 
Create account with new username, password, invalid skus and quantity
    [Documentation]
    [Tags]    regression
	${TEST_USERNAME}  Generate Username
    Input Text		id=username     ${TEST_USERNAME}
    Input Text		id=password     ${PASSWORD}
    Input Text		id=first_name   ${FIRST_NAME}
    Input Text		id=last_name	${LAST_NAME}
    Input Text		id=sku			${INVALID_SKUS}
    Input Text		id=quantity		${QUANTITY}
    Click Element  id=submit
    
    # Verify result
    ${SUCCESS_MESSAGE}=   Catenate  Creating account "${TEST_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=20
    ${SUCCESS_MESSAGE}=   Catenate  Accepting Ts&Cs for "${TEST_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=20 
    ${INVALID_SKU_LIST}=	Split String	${INVALID_SKUS}	,
    #${SUCCESS_MESSAGE}=   Set Variable  Unable to add SKUs (not found in the DB): ${INVALID_SKU_LIST}
    ${SUCCESS_MESSAGE}=   Catenate  Bad request: Value of 'sku (${INVALID_SKU_LIST})' parameter is not valid input
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=50
    ${SUCCESS_MESSAGE}=   Set Variable  Creating account owners in Candlepin
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=50
    ${SUCCESS_MESSAGE}=   Catenate  Account "${TEST_USERNAME}" created
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=50
        
Create account with new username, password, valid and invalid skus and quantity
    [Documentation]
    [Tags]    regression
	${TEST_USERNAME}=  Generate Username
    ${VALID_INVALID_SKUS}=	Catenate	${SKU},${INVALID_SKU}
    Input Text		id=username     ${TEST_USERNAME}
    Input Text		id=password     ${PASSWORD}
    Input Text		id=first_name   ${FIRST_NAME}
    Input Text		id=last_name	${LAST_NAME}
    Input Text		id=sku			${VALID_INVALID_SKUS}
    Input Text		id=quantity		${QUANTITY}
    Click Element  id=submit
    
    # Verify result
 	${SUCCESS_MESSAGE}=   Catenate  Creating account "${TEST_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=20
    ${SUCCESS_MESSAGE}=   Catenate  Accepting Ts&Cs for "${TEST_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=20
    ${SUCCESS_MESSAGE}=   Set Variable  Adding subscriptions to "${TEST_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=50 
    ${INVALID_SKU_LIST}=	Split String	${INVALID_SKU}	,
    #${SUCCESS_MESSAGE}=   Set Variable  Unable to add SKUs (not found in the DB): ${INVALID_SKU_LIST}
    ${SUCCESS_MESSAGE}=   Catenate  Bad request: Value of 'sku (${INVALID_SKU_LIST})' parameter is not valid input
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=50
    ${SUCCESS_MESSAGE}=   Set Variable  Creating account owners in Candlepin
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=50
    ${SUCCESS_MESSAGE}=   Catenate  Account "${TEST_USERNAME}" created
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=50
    
Create account with new username, password, sku and null quantity
    [Documentation]
    [Tags]    regression
	${TEST_USERNAME}  Generate Username
    Input Text		id=username     ${TEST_USERNAME}
    Input Text		id=password     ${PASSWORD}
    Input Text		id=first_name   ${FIRST_NAME}
    Input Text		id=last_name	${LAST_NAME}
    Input Text		id=sku			${SKU}
    Click Element  id=submit
    
    # Verify result
    Verify result after create create and add sku successfully	${TEST_USERNAME}	    

Create account with new username, password, null sku and quantity
    [Documentation]
    [Tags]    regression
	${TEST_USERNAME}  Generate Username
    Input Text		id=username     ${TEST_USERNAME}
    Input Text		id=password     ${PASSWORD}
    Input Text		id=first_name   ${FIRST_NAME}
    Input Text		id=last_name	${LAST_NAME}
    Input Text		id=quantity		${QUANTITY}
    Click Element  id=submit
    Verify result after create account successfully	${TEST_USERNAME}
	

*** Keywords ***
User Already Exists
    ${FAIL_MESSAGE}=	Set Variable	User already exists
    Wait Until Page Contains   ${FAIL_MESSAGE} 
    Test File a bug Link
    
Suite Setup Steps
	Log	Suite Begin...
	Open Browser  ${FRONT_PAGE}   ${BROWSER}
	Maximize Browser Window

Test Setup Steps
	Log	Suite Begin...   
    Go to Front Page
    Wait Until Page Contains Element   link=Create Account
    Click Link       Create Account
    Page should contain Element   xpath=${Create_Create_Link}
    Capture Page Screenshot

Test Teardown Steps
	Capture Page Screenshot
	Log	Testing End...

Suite TearDown Steps
	Close All Browsers
	Log	Suite End...	
	
	
###
###	Keep these cases here for now
###
Create account with one username including ; and password
    [Documentation]
    [Tags]    regression
	# Unable to verify if account creation was successful
    # Unable to Create account
    ${TEST_USERNAME}=     Generate username
    ${SPECIAL_CHARACTER}=    Set Variable	;
    @{NUMBER_LIST}=	Evaluate	range(10)
    :For    ${i}    in      @{NUMBER_LIST}
    \       Log     ${i}
    \		#Select Window	url=${FRONT_PAGE}
    \       ${TEST_USERNAME}=  Catenate     ${TEST_USERNAME}${SPECIAL_CHARACTER}
    \       Input Text     id=username    ${TEST_USERNAME}
    \		Input Text     id=password    ${PASSWORD}
    \       Input Text     id=first_name  ${FIRST_NAME}
    \		Input Text     id=last_name   ${LAST_NAME}
    \		Click Element  id=submit
    \		${SUCCESS_MESSAGE}=   Catenate  Creating account "${TEST_USERNAME}"
    \		Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=50
    \		Wait Until Page Contains   Unable to verify if account creation was successful
    \		Test File a bug Link

Create account with one username including : and password
    [Documentation]
    [Tags]    regression
	# Invalid username or password 
    ${TEST_USERNAME}=     Generate username
    ${SPECIAL_CHARACTER}=    Set Variable	:
    @{NUMBER_LIST}=	Evaluate	range(10)
    :For    ${i}    in      @{NUMBER_LIST}
    \       Log     ${i}
    \		#Select Window	url=${FRONT_PAGE}
    \       ${TEST_USERNAME}=  Catenate     ${TEST_USERNAME}${SPECIAL_CHARACTER}
    \       Input Text     id=username    ${TEST_USERNAME}
    \		Input Text     id=password    ${PASSWORD}
    \       Input Text     id=first_name  ${FIRST_NAME}
    \		Input Text     id=last_name   ${LAST_NAME}
    \		Click Element  id=submit
    \		${SUCCESS_MESSAGE}=   Catenate  Creating account "${TEST_USERNAME}"
    \		Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=50
    \		Wait Until Page Contains   Invalid username or password
    \		Test File a bug Link

Create account with one username including ? and password
    [Documentation]
    [Tags]    regression
	# Unable to verify if account creation was successful
    ${TEST_USERNAME}=     Generate username
    ${SPECIAL_CHARACTER}=    Set Variable	?
    @{NUMBER_LIST}=	Evaluate	range(10)
    :For    ${i}    in      @{NUMBER_LIST}
    \       Log     ${i}
    \		#Select Window	url=${FRONT_PAGE}
    \       ${TEST_USERNAME}=  Catenate     ${TEST_USERNAME}${SPECIAL_CHARACTER}
    \       Input Text     id=username    ${TEST_USERNAME}
    \		Input Text     id=password    ${PASSWORD}
    \       Input Text     id=first_name  ${FIRST_NAME}
    \		Input Text     id=last_name   ${LAST_NAME}
    \		Click Element  id=submit
    \		${SUCCESS_MESSAGE}=   Catenate  Creating account "${TEST_USERNAME}"
    \		Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=50
    \		Wait Until Page Contains   Unable to verify if account creation was successful
    \		Test File a bug Link

Create account with one username including , and password
    [Documentation]
    [Tags]    regression
	# Unable to verify if account creation was successful
    ${TEST_USERNAME}=     Generate username
    ${SPECIAL_CHARACTER}=    Set Variable	,
    @{NUMBER_LIST}=	Evaluate	range(10)
    :For    ${i}    in      @{NUMBER_LIST}
    \       Log     ${i}
    \		#Select Window	url=${FRONT_PAGE}
    \       ${TEST_USERNAME}=  Catenate     ${TEST_USERNAME}${SPECIAL_CHARACTER}
    \       Input Text     id=username    ${TEST_USERNAME}
    \		Input Text     id=password    ${PASSWORD}
    \       Input Text     id=first_name  ${FIRST_NAME}
    \		Input Text     id=last_name   ${LAST_NAME}
    \		Click Element  id=submit
    \		${SUCCESS_MESSAGE}=   Catenate  Creating account "${TEST_USERNAME}"
    \		Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=50
    \		Wait Until Page Contains   Unable to verify if account creation was successful
    \		Test File a bug Link

Create account with one username including # and password
    [Documentation]
    [Tags]    regression
	# Unable to verify if account creation was successful 
    ${TEST_USERNAME}=     Generate username
    #${SPECIAL_CHARACTER}=    Set Variable	\#
    @{NUMBER_LIST}=	Evaluate	range(10)
    :For    ${i}    in      @{NUMBER_LIST}
    \       Log     ${i}
    \		#Select Window	url=${FRONT_PAGE}
    \       ${TEST_USERNAME}=  Catenate     ${TEST_USERNAME}#
    \       Input Text     id=username    ${TEST_USERNAME}
    \		Input Text     id=password    ${PASSWORD}
    \       Input Text     id=first_name  ${FIRST_NAME}
    \		Input Text     id=last_name   ${LAST_NAME}
    \		Click Element  id=submit
    \		${SUCCESS_MESSAGE}=   Catenate  Creating account "${TEST_USERNAME}"
    \		Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=50
    \		Wait Until Page Contains   Unable to verify if account creation was successful
    \		Test File a bug Link
			
Create account with one username including / and password 
    [Documentation]
    [Tags]    regression
    # Unable to verify if account creation was successful
    # Unable to Create account
    ${TEST_USERNAME}=     Generate username
    ${SPECIAL_CHARACTER}=    Set Variable	/
    @{NUMBER_LIST}=	Evaluate	range(10)
    :For    ${i}    in      @{NUMBER_LIST}
    \       Log     ${i}
    \       ${TEST_USERNAME}=  Catenate     ${TEST_USERNAME}${SPECIAL_CHARACTER}
    \       Input Text     id=username    ${TEST_USERNAME}
    \		Input Text     id=password    ${PASSWORD}
    \       Input Text     id=first_name  ${FIRST_NAME}
    \		Input Text     id=last_name   ${LAST_NAME}
    \		Click Element  id=submit
    \		${SUCCESS_MESSAGE}=   Catenate  Creating account "${TEST_USERNAME}"
    \		Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=50
    \		Wait Until Page Contains   Unable to verify if account creation was successful
    \		Test File a bug Link

Create account with one username including % and password 
    [Documentation]
    [Tags]    regression
	# Application encountered an network issue, please try again later
    # Unable to Create account
    ${TEST_USERNAME}=     Generate username
    ${SPECIAL_CHARACTER}=    Set Variable	%
    @{NUMBER_LIST}=	Evaluate	range(10)
    :For    ${i}    in      @{NUMBER_LIST}
    \       Log     ${i}
    \       ${TEST_USERNAME}=  Catenate     ${TEST_USERNAME}${SPECIAL_CHARACTER}
    \       Input Text     id=username    ${TEST_USERNAME}
    \		Input Text     id=password    ${PASSWORD}
    \       Input Text     id=first_name  ${FIRST_NAME}
    \		Input Text     id=last_name   ${LAST_NAME}
    \		Click Element  id=submit
    \		${SUCCESS_MESSAGE}=   Catenate  Creating account "${TEST_USERNAME}"
    \		Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=50
    \		Wait Until Page Contains   Application encountered an network issue, please try again later
    \		Test File a bug Link

Create account with one username including \ and password 
    [Documentation]
    [Tags]    regression
	# Application encountered an network issue, please try again later
    # Unable to Create account
    ${TEST_USERNAME}=     Generate username 
    @{SPECIAL_CHARACTER}=    Create List	\\	\\\	\\\\	\\\\\	\\\\\\	\\\\\\\	\\\\\\\\	\\\\\\\\\	\\\\\\\\\\
    :For    ${i}    in      @{SPECIAL_CHARACTER}
    \       Log     ${i}
    \       ${TEST_USERNAME}=  Catenate     ${TEST_USERNAME}${i}
    \       Input Text     id=username    ${TEST_USERNAME}
    \		Input Text     id=password    ${PASSWORD}
    \       Input Text     id=first_name  ${FIRST_NAME}
    \		Input Text     id=last_name   ${LAST_NAME}
    \		Click Element  id=submit
    \		${SUCCESS_MESSAGE}=   Catenate  Creating account "${TEST_USERNAME}"
    \		Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=50
    \		Wait Until Page Contains   Application encountered an network issue, please try again later
    \		Test File a bug Link