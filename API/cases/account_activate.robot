*** Settings ***
Documentation   Account Tool API Test for attach(POST).
Resource        ../resources/global.txt


*** Variables ***


*** Test Cases ***
Activate account without accepting terms and having skus
    [Documentation]		a account without accepting terms
    [Tags]    regression
    ${TEST_USERNAME}=	Create account without accepting terms
    ${QUANTITY}=	Convert To Integer	${QUANTITY}
    Add SKU		${TEST_USERNAME}	${PASSWORD}		${SKU}		${QUANTITY}
    ${STATUS}=	Verify Activate		${TEST_USERNAME}	${PASSWORD}
    Should Be Equal     ${STATUS}    1
    Activate account	${TEST_USERNAME}	${PASSWORD}
    
Activate account without accepting terms and without skus
    [Documentation]		a account without accepting terms
    [Tags]    regression
    ${TEST_USERNAME}=	Create account without accepting terms
    Activate account	${TEST_USERNAME}	${PASSWORD}

Activate account with accepting terms and having skus
	[Documentation]		a account without accepting terms
    [Tags]    regression
    ${TEST_USERNAME}=	Create account with accepting terms
    ${QUANTITY}=	Convert To Integer	${QUANTITY}
    Add SKU		${TEST_USERNAME}	${PASSWORD}		${SKU}		${QUANTITY}
    ${STATUS}=	Verify Activate		${TEST_USERNAME}	${PASSWORD}
    Should Be Equal     ${STATUS}    0
    Activate account	${TEST_USERNAME}	${PASSWORD}

Activate account with accepting terms and without skus 
	[Documentation]		a account without accepting terms
    [Tags]    regression
    ${TEST_USERNAME}=	Create account with accepting terms
    ${QUANTITY}=	Convert To Integer	${QUANTITY}
    Add SKU		${TEST_USERNAME}	${PASSWORD}		${SKU}		${QUANTITY}
    ${STATUS}=	Verify Activate		${TEST_USERNAME}	${PASSWORD}
    Should Be Equal     ${STATUS}    0
    Activate account	${TEST_USERNAME}	${PASSWORD}

Verify terms after activate and refresh account without accepting terms
	[Documentation]	do not refresh and activate
    [Tags]    regression
	${TEST_USERNAME}=	Create Account without accepting terms
	${STATUS}=	Verify Activate		${TEST_USERNAME}	${PASSWORD}
    Should Be Equal     ${STATUS}    1
    Activate Account	${TEST_USERNAME}	${PASSWORD}
	Refresh Account		${TEST_USERNAME}	${PASSWORD}
    ${STATUS}=	Verify Activate		${TEST_USERNAME}	${PASSWORD}
    Should Be Equal     ${STATUS}    0 
    
Verify terms after activate and refresh account with accepting terms
	[Documentation]	do not refresh and activate
    [Tags]    regression
	${TEST_USERNAME}=	Create Account with accepting terms
	${STATUS}=	Verify Activate		${TEST_USERNAME}	${PASSWORD}
    Should Be Equal     ${STATUS}    0
    Activate Account	${TEST_USERNAME}	${PASSWORD}
	Refresh Account		${TEST_USERNAME}	${PASSWORD}
    ${STATUS}=	Verify Activate		${TEST_USERNAME}	${PASSWORD}
    Should Be Equal     ${STATUS}    0 

Verify terms after create,activate,refresh account and then add sku 
	[Documentation]	do not refresh and activate
    [Tags]    regression
	${TEST_USERNAME}=	Create Account with accepting terms
	${STATUS}=	Verify Activate		${TEST_USERNAME}	${PASSWORD}
	Should Be Equal     ${STATUS}    0
	${QUANTITY}=	Convert To Integer	${QUANTITY}
    Add SKU		${TEST_USERNAME}	${PASSWORD}	${SKU}	${QUANTITY}
    ${STATUS}=	Verify Activate		${TEST_USERNAME}	${PASSWORD}  
	Should Be Equal     ${STATUS}    0
    
Activate account with null username and null password
    [Documentation]
    [Tags]    regression
    ${ACTIVATE_INFO}=  Create Dictionary     username=    password=
    ${STATUS}    ${MSG}=    POST     ${ACTIVATE_URL}    ${ACTIVATE_INFO}
    ${SUCCESS_MSG}=		Catenate	Unable to verify credentials for account ''
    Should Be Equal     ${STATUS}    400
    Should Be Equal     ${MSG}      ${SUCCESS_MSG}
    
Activate account with username and null password
    [Documentation]
    [Tags]    regression
    ${ACTIVATE_INFO}=  Create Dictionary     username=${EXISTING_USERNAME}    password=
    ${STATUS}    ${MSG}=    POST     ${ACTIVATE_URL}    ${ACTIVATE_INFO}
    ${SUCCESS_MSG}=		Catenate	Unable to verify credentials for account '${EXISTING_USERNAME}'
    Should Be Equal     ${STATUS}    400
    Should Be Equal     ${MSG}      ${SUCCESS_MSG}
    
Activate account with null username and password
    [Documentation]
    [Tags]    regression
    ${ACTIVATE_INFO}=  Create Dictionary     username=    password=${PASSWORD}
    ${STATUS}    ${MSG}=    POST     ${ACTIVATE_URL}    ${ACTIVATE_INFO}
    ${SUCCESS_MSG}=		Catenate	Unable to verify credentials for account ''
    Should Be Equal     ${STATUS}    400
    Should Be Equal     ${MSG}      ${SUCCESS_MSG}
    
Activate account with existing username and wrong password
    [Documentation]
    [Tags]    regression
    ${ACTIVATE_INFO}=  Create Dictionary     username=${EXISTING_USERNAME}    password=${WRONG_PASSWORD}
    ${STATUS}    ${MSG}=    POST     ${ACTIVATE_URL}    ${ACTIVATE_INFO}
    ${SUCCESS_MSG}=		Set Variable	Invalid username or password
    Should Be Equal     ${STATUS}    400
    Should Be Equal     ${MSG}      ${SUCCESS_MSG}
    
Activate account with new username and password 
    [Documentation]
    [Tags]    regression
    ${TEST_USERNAME}=	Generate Username
    ${ACTIVATE_INFO}=  Create Dictionary     username=${TEST_USERNAME}    password=${PASSWORD}
    ${STATUS}    ${MSG}=    POST     ${ACTIVATE_URL}    ${ACTIVATE_INFO}
    ${SUCCESS_MSG}=		Set Variable	Invalid username or password
    Should Be Equal     ${STATUS}    400
    Should Be Equal     ${MSG}      ${SUCCESS_MSG}
    
Activate account with nothing
	[Documentation]
    [Tags]    regression
    ${ACTIVATE_INFO}=  Create Dictionary  
    ${STATUS}    ${MSG}=    POST     ${ACTIVATE_URL}    ${ACTIVATE_INFO}
    ${SUCCESS_MSG}=		Set Variable	Bad request: Parameter 'username' is either missing or of wrong type
    Should Be Equal     ${STATUS}    400
    Should Be Equal     ${MSG}      ${SUCCESS_MSG}
    
Activate account missing username
	[Documentation]
    [Tags]    regression
    ${ACTIVATE_INFO}=  Create Dictionary     password=${PASSWORD}
    ${STATUS}    ${MSG}=    POST     ${ACTIVATE_URL}    ${ACTIVATE_INFO}
    ${SUCCESS_MSG}=		Set Variable	Bad request: Parameter 'username' is either missing or of wrong type
    Should Be Equal     ${STATUS}    400
    Should Be Equal     ${MSG}      ${SUCCESS_MSG}

Activate account missing password
    ${ACTIVATE_INFO}=  Create Dictionary     username=${EXISTING_USERNAME}
    ${STATUS}    ${MSG}=    POST     ${ACTIVATE_URL}    ${ACTIVATE_INFO}
    ${SUCCESS_MSG}=		Set Variable	Bad request: Parameter 'password' is either missing or of wrong type
    Should Be Equal     ${STATUS}    400
    Should Be Equal     ${MSG}      ${SUCCESS_MSG}
*** Keywords ***
