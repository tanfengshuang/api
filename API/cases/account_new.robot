*** Settings ***
Documentation     Account Tool API Test for new(POST).
Resource          ../resources/global.txt

*** Variables ***

*** Test Cases ***
Verify terms after create account
    [Documentation]	Only call api /account/new, do not call api for refresh and activate.
    ...	Terms are accepted after call api /account/new, but become un-accepted after add a valid sku with api /account/attach
    ...	But, create(/account/new) a account and activate(/account/activate) it, and then add a valid sku, terms are still accepted
    [Tags]    regression
    Log	 Terms are accepted after call api /account/new
	${TEST_USERNAME}=	Create Account
	${STATUS}=	Verify Activate		${TEST_USERNAME}	${PASSWORD}
	Should Be Equal As Integers     ${STATUS}    0

Verify terms after create account and then add sku
    [Documentation]	Only call api /account/new and /account/add, do not call api for refresh and activate.do not refresh and activate
    ...	Terms are accepted after call api /account/new, but become un-accepted after add a valid sku with api /account/attach
    ...	But, create(/account/new) a account and activate(/account/activate) it, and then add a valid sku, terms are still accepted
    [Tags]    regression
    Log	Terms are accepted after call api /account/new, but are not accepted after add sku
	${TEST_USERNAME}=	Create Account
	${STATUS}=	Verify Activate		${TEST_USERNAME}	${PASSWORD}
    Add SKU		${TEST_USERNAME}	${PASSWORD}		${SKU}		${QUANTITY}
    ${STATUS}=	Verify Activate		${TEST_USERNAME}	${PASSWORD}  
	Should Be Equal     ${STATUS}    1

Verify terms after create account and then add invalid sku
    [Documentation]	Only call api /account/new and /account/add, do not call api for refresh and activate.do not refresh and activate
    ...	Terms are accepted after call api /account/new, but become un-accepted after add a valid sku with api /account/attach
    ...	But, create(/account/new) a account and activate(/account/activate) it, and then add a valid sku, terms are still accepted
    [Tags]    regression
    Log	Terms are accepted after call api /account/new, but are not accepted after add sku
	${TEST_USERNAME}=	Create Account
	${STATUS}=	Verify Activate		${TEST_USERNAME}	${PASSWORD}
	@{SKU_LIST}=	Split String	${INVALID_SKU}	,
    ${ADD_INFO}=  Create Dictionary     username=${TEST_USERNAME}    password=${PASSWORD}     sku=${SKU_LIST}      quantity=${QUANTITY}
    ${STATUS}    ${MSG}=    POST    ${ADD_URL}   ${ADD_INFO}
    
    ${STATUS}=	Verify Activate		${TEST_USERNAME}	${PASSWORD}  
	Should Be Equal     ${STATUS}    0

Create account without accepting terms
    [Documentation]
    [Tags]    regression  
    ${TEST_USERNAME}=     Generate username
    ${CREATE_INFO}=  Create Dictionary     username=${TEST_USERNAME}    password=${PASSWORD}
    ${STATUS}    ${MSG}=    POST    ${NEW_URL}    ${CREATE_INFO}
    ${SUCCESS_MSG}=	Catenate	Account '${TEST_USERNAME}' created
    Should Be Equal     ${STATUS}   200
    Should Contain      ${MSG}      ${SUCCESS_MSG}
    Add SKU		${TEST_USERNAME}	${PASSWORD}		${SKU}	${QUANTITY}
    ${STATUS}=       Verify Activate      ${TEST_USERNAME}	${PASSWORD}
    Should Be Equal     ${STATUS}    1

Create account with new username and password
    [Documentation]
    [Tags]    regression  
    ${TEST_USERNAME}=     Generate username
    ${CREATE_INFO}=  Create Dictionary     username=${TEST_USERNAME}    password=${PASSWORD}
    ${STATUS}    ${MSG}=    POST    ${NEW_URL}    ${CREATE_INFO}
    ${SUCCESS_MSG}=	Catenate	Account '${TEST_USERNAME}' created
    Should Be Equal     ${STATUS}   200
    Should Contain      ${MSG}      ${SUCCESS_MSG}
    ${STATUS}=       Verify Account Login      ${TEST_USERNAME}	${PASSWORD}
    Should Be Equal     ${STATUS}    0
    
    #&{headers}=  Create Dictionary  Content-Type=application/application/json
    #Create Session  httpbin     ${url}     headers=&{headers}
    #&{create_info}      Create Dictionary     username=aaa    password=${password}
    #${resp}=  Post Request      httpbin      /account/refresh      data=&{create_info}  headers=${headers}
    #Log         ${resp.status_code}
    #Log         ${resp.content}
    #Should Be Equal     ${resp.status_code}  200
    
Create account with new username, password and first_name
    [Documentation]
    [Tags]    regression
    ${TEST_USERNAME}=     Generate username
    ${CREATE_INFO}=  Create Dictionary     username=${TEST_USERNAME}    password=${PASSWORD}		first_name=${FIRST_NAME}
    ${STATUS}    ${MSG}=    POST    ${NEW_URL}    ${CREATE_INFO}
    ${SUCCESS_MSG}=		Catenate	Account '${TEST_USERNAME}' created
    Should Be Equal     ${STATUS}	200
    Should Contain      ${MSG}      ${SUCCESS_MSG}
    ${STATUS}=       Verify Account Login      ${TEST_USERNAME}	${PASSWORD}
    Should Be Equal     ${STATUS}    0

Create account with new username, password and last_name
    [Documentation]
    [Tags]    regression
    ${TEST_USERNAME}=     Generate username
    ${CREATE_INFO}=  Create Dictionary     username=${TEST_USERNAME}    password=${PASSWORD}		last_name=${LAST_NAME}
    ${STATUS}    ${MSG}=    POST    ${NEW_URL}    ${CREATE_INFO}
    ${SUCCESS_MSG}=		Catenate	Account '${TEST_USERNAME}' created
    Should Be Equal     ${STATUS}   200
    Should Contain      ${MSG}      ${SUCCESS_MSG}
    ${STATUS}=       Verify Account Login      ${TEST_USERNAME}	${PASSWORD}
    Should Be Equal     ${STATUS}    0

Create account with new username, password, first_name and last_name
    [Documentation]
    [Tags]    regression
    ${TEST_USERNAME}=     Generate username
    ${CREATE_INFO}=  Create Dictionary     username=${TEST_USERNAME}    password=${PASSWORD}     first_name=${FIRST_NAME}     last_name=${LAST_NAME}
    ${STATUS}    ${MSG}=    POST    ${NEW_URL}    ${CREATE_INFO}
    ${SUCCESS_MSG}=		Catenate	Account '${TEST_USERNAME}' created
    Should Be Equal     ${STATUS}	200
    Should Be Equal		${MSG}		${SUCCESS_MSG}
    ${STATUS}=       Verify Account Login      ${TEST_USERNAME}	${PASSWORD}
    Should Be Equal     ${STATUS}    0

Create account with new username and null password
    [Documentation]
    [Tags]    regression
    ${TEST_USERNAME}=     Generate username
    ${CREATE_INFO}=  Create Dictionary     username=${TEST_USERNAME}    password=     first_name=${FIRST_NAME}     last_name=${LAST_NAME}
    ${STATUS}    ${MSG}=    POST    ${NEW_URL}    ${CREATE_INFO}
    ${SUCCESS_MSG}=		Set Variable	Bad request: Value of 'password' parameter is not valid input, reason: Password must be in range of 1-25 characters
    Should Be Equal     ${status}   400
    Should Be Equal     ${MSG}      ${SUCCESS_MSG}

Create account with null username and null password
    [Documentation]
    [Tags]    regression
    ${CREATE_INFO}=    Create Dictionary     username=    password=
    ${STATUS}    ${MSG}=    POST    ${NEW_URL}    ${CREATE_INFO}
    ${SUCCESS_MSG}=		Set Variable	Bad request: Value of 'username' parameter is not valid input, reason: Login must be at least 5 characters long
    Should Be Equal     ${STATUS}   400
    Should Contain      ${MSG}      ${SUCCESS_MSG}

Create account with null username and password
    [Documentation]
    [Tags]    regression
    ${CREATE_INFO}=    Create Dictionary     username=    password=${PASSWORD}
    ${STATUS}    ${MSG}=    POST    ${NEW_URL}    ${CREATE_INFO}
    ${SUCCESS_MSG}=		Set Variable	Bad request: Value of 'username' parameter is not valid input, reason: Login must be at least 5 characters long
    Should Be Equal     ${STATUS}   400
    Should Contain      ${MSG}      ${SUCCESS_MSG}

Create account with one existing username and password
    [Documentation]
    [Tags]    regression
    ${CREATE_INFO}=    Create Dictionary     username=${EXISTING_USERNAME}    password=${PASSWORD}
    ${STATUS}    ${MSG}=    POST    ${NEW_URL}    ${CREATE_INFO}
    ${SUCCESS_MSG}=		Set Variable	User already exist
    Should Be Equal     ${STATUS}    400
    Should Contain      ${MSG}      ${SUCCESS_MSG}
    ${STATUS}=       Verify Account Login      ${EXISTING_USERNAME}	${PASSWORD}
    Should Be Equal     ${STATUS}    0

Create account with one existing username and null password
    [Documentation]
    [Tags]    regression
    ${CREATE_INFO}=    Create Dictionary     username=${EXISTING_USERNAME}    password=
    ${STATUS}    ${MSG}=    POST    ${NEW_URL}    ${CREATE_INFO}
    ${SUCCESS_MSG}=		Set Variable	Bad request: Value of 'password' parameter is not valid input, reason: Password must be in range of 1-25 characters
    Should Be Equal     ${STATUS}    400
    Should Be Equal     ${MSG}      ${SUCCESS_MSG}

Create account with one existing username and wrong password
    [Documentation]
    [Tags]    regression
    ${CREATE_INFO}=    Create Dictionary     username=${EXISTING_USERNAME}    password=${WRONG_PASSWORD}
    ${STATUS}    ${MSG}=    POST    ${NEW_URL}    ${CREATE_INFO}
    ${SUCCESS_MSG}=		Set Variable	User already exist
    Should Be Equal     ${STATUS}    400
    Should Contain      ${MSG}      ${SUCCESS_MSG}
    ${STATUS}=       Verify Account Login      ${EXISTING_USERNAME}	${PASSWORD}
    Should Be Equal     ${STATUS}    0
    

Create account with one username including special charactor and password
    [Documentation]
    [Tags]    regression
    # (") ($) (^) (<) (>) (|) (+) (%) (/) (;) (:) (,) (\\) (*) (=) (~)'
    @{SPECIAL_CHARACTER}=    Create List     "	$	^	<	>	|	+	%	/	;	:	,	\\	*	=	~
    :For    ${i}    in      @{SPECIAL_CHARACTER}
    \       Log     ${i}
    \       ${TEST_USERNAME}=     Generate username
    \       ${CREATE_INFO}=  Create Dictionary     username=${TEST_USERNAME}${i}    password=${PASSWORD}
    \       ${STATUS}    ${MSG}=    POST    ${NEW_URL}    ${CREATE_INFO}
    \       Should Be Equal     ${STATUS}   400
    \		${SUCCESS_MSG}=		Set Variable	Bad request: Value of 'username' parameter is not valid input, reason: Login must be at least 5 characters long
    \       Should Contain		${MSG}	${SUCCESS_MSG}

Create account with one new username and password including special charactor
    [Documentation]
    [Tags]    regression
    # Investigate how to set list in 'Variables' part 
    # What's the expected result -  should create or not ???
    @{SPECIAL_CHARACTER}    Create List     <   >   (   )   \   /
    :For    ${i}    in      @{SPECIAL_CHARACTER}
    \       Log     ${i}
    \       ${TEST_USERNAME}     Generate username
    \       ${CREATE_INFO}    Create Dictionary     username=${TEST_USERNAME}    password=${PASSWORD}${i}
    \       ${STATUS}    ${MSG}=    POST    ${NEW_URL}    ${CREATE_INFO}
    \       Should Be Equal     ${STATUS}   200
    \       ${STATUS}       Verify Account Login      ${TEST_USERNAME}	${PASSWORD}${i}
    \       Should Be Equal     ${STATUS}    0

Create account with the password more than 25 characters
	[Documentation]
    [Tags]    regression
    ${TEST_USERNAME}=     Generate username
	${PASSWORD}=		Set Variable	123456789012345678901234567890
	${CREATE_INFO}=  Create Dictionary     username=${TEST_USERNAME}    password=${PASSWORD}
    ${STATUS}    ${MSG}=    POST    ${NEW_URL}    ${CREATE_INFO}
    ${SUCCESS_MSG}=		Catenate	Bad request: Value of 'password' parameter is not valid input, reason: Password must be in range of 1-25 characters
    Should Be Equal     ${STATUS}    400
    Should Be Equal      ${MSG}      ${SUCCESS_MSG}
	
Create account - test character limit for username 
	[Documentation]
    [Tags]    regression
    ${TEST_USERNAME}=    Generate username
	${TEST_USERNAME}=	Catenate		${TEST_USERNAME}123456789012345678901234567890
	${CREATE_INFO}=  Create Dictionary     username=${TEST_USERNAME}    password=${PASSWORD}
    ${STATUS}    ${MSG}=    POST    ${NEW_URL}    ${CREATE_INFO}
    ${SUCCESS_MSG}=		Catenate	Account '${TEST_USERNAME}' created
    Should Be Equal     ${STATUS}    200
    Should Contain      ${MSG}      ${SUCCESS_MSG}
    ${STATUS}=       Verify Account Login      ${TEST_USERNAME}	${PASSWORD}
    Should Be Equal     ${STATUS}    0

Create account with nothing
	[Documentation]
    [Tags]    regression
    ${CREATE_INFO}=    Create Dictionary
    ${STATUS}    ${MSG}=    POST    ${NEW_URL}    ${CREATE_INFO}
    ${SUCCESS_MSG}=		Set Variable	Bad request: Parameter 'username' is either missing or of wrong type
    Should Be Equal     ${STATUS}    400
    Should Contain      ${MSG}      ${SUCCESS_MSG}
    
Create account missing username
	[Documentation]
    [Tags]    regression
    ${CREATE_INFO}=    Create Dictionary     password=${WRONG_PASSWORD}
    ${STATUS}    ${MSG}=    POST    ${NEW_URL}    ${CREATE_INFO}
    ${SUCCESS_MSG}=		Set Variable	Bad request: Parameter 'username' is either missing or of wrong type
    Should Be Equal     ${STATUS}    400
    Should Contain      ${MSG}      ${SUCCESS_MSG}

Create account missing password
	[Documentation]
    [Tags]    regression
    ${CREATE_INFO}=    Create Dictionary     username=${EXISTING_USERNAME}
    ${STATUS}    ${MSG}=    POST    ${NEW_URL}    ${CREATE_INFO}
    ${SUCCESS_MSG}=		Set Variable	Bad request: Parameter 'password' is either missing or of wrong type
    Should Be Equal     ${STATUS}    400
    Should Contain      ${MSG}      ${SUCCESS_MSG}

*** Keywords ***
Create Account
    [Documentation]
    [Tags]    regression  
    ${TEST_USERNAME}=     Generate username
    ${CREATE_INFO}=  Create Dictionary     username=${TEST_USERNAME}    password=${PASSWORD}
    ${STATUS}    ${MSG}=    POST    ${NEW_URL}    ${CREATE_INFO}
    ${SUCCESS_MSG}=	Catenate	Account '${TEST_USERNAME}' created
    Should Be Equal     ${STATUS}    200
    Should Be Equal     ${MSG}    ${SUCCESS_MSG}
    [Return]	${TEST_USERNAME}


Create account with expire date
	#Bad request: Value of 'expire' parameter is not valid input, reason: Expiration date must be in range 0-365 days from today in 'mm/dd/yyyy' format.