*** Settings ***
Documentation     Account Tool API Test for refresh(POST).
Resource          ../resources/global.txt

*** Variables ***

*** Test Cases ***
Refresh account having skus and with accepting terms
    [Documentation]
    [Tags]    regression
    ${STATUS}=	Verify Activate		${EXISTING_USERNAME}	${PASSWORD}
    Should Be Equal     ${STATUS}    0
	${REFRESH_INFO}=  Create Dictionary     username=${EXISTING_USERNAME}    password=${PASSWORD}
    ${STATUS}    ${MSG}=    POST     ${REFRESH_URL}    ${REFRESH_INFO}
    ${SUCCESS_MSG}=		Catenate	Pools for '${EXISTING_USERNAME}' refreshed successfully
    Should Be Equal     ${STATUS}    200
    Should Be Equal     ${MSG}      ${SUCCESS_MSG}
    ${STATUS}=	Verify Activate		${EXISTING_USERNAME}	${PASSWORD}
    Should Be Equal     ${STATUS}    0
  
Refresh account without skus and with accepting terms
    [Documentation]
    [Tags]    regression
    ${TEST_USERNAME}=	Create account with accepting terms
    ${STATUS}=	Verify Activate		${TEST_USERNAME}	${PASSWORD}
    Should Be Equal     ${STATUS}    0
    ${REFRESH_INFO}=  Create Dictionary     username=${TEST_USERNAME}    password=${PASSWORD}
    ${STATUS}    ${MSG}=    POST     ${REFRESH_URL}    ${REFRESH_INFO}
    ${SUCCESS_MSG}=		Catenate	Pools for '${TEST_USERNAME}' refreshed successfully
    Should Be Equal     ${STATUS}    200
    Should Be Equal     ${MSG}      ${SUCCESS_MSG}
    ${STATUS}=	Verify Activate		${TEST_USERNAME}	${PASSWORD}
    Should Be Equal     ${STATUS}    0
        
Refresh account having skus and without accepting terms 
    [Documentation]
    [Tags]    regression
	${TEST_USERNAME}=	Create account without accepting terms
	${STATUS}=	Verify Activate		${TEST_USERNAME}	${PASSWORD}
    Should Be Equal     ${STATUS}    1
    ${QUANTITY}=	Convert To Integer	${QUANTITY}
	Add SKU		${TEST_USERNAME}	${PASSWORD}		${SKUS}		${QUANTITY} 
	${REFRESH_INFO}=  Create Dictionary     username=${TEST_USERNAME}    password=${PASSWORD}
    ${STATUS}    ${MSG}=    POST     ${REFRESH_URL}    ${REFRESH_INFO}
    ${SUCCESS_MSG}=		Catenate	Pools for '${TEST_USERNAME}' refreshed successfully
    Should Be Equal     ${STATUS}    200
    Should Be Equal     ${MSG}      ${SUCCESS_MSG}
    ${STATUS}=	Verify Activate		${TEST_USERNAME}	${PASSWORD}
    Should Be Equal     ${STATUS}    1

Refresh account without skus and without accepting terms
    [Documentation]
    [Tags]    regression
    ${TEST_USERNAME}=	Create account without accepting terms
    ${STATUS}=	Verify Activate		${TEST_USERNAME}	${PASSWORD}
    Should Be Equal     ${STATUS}    1
    ${REFRESH_INFO}=  Create Dictionary     username=${TEST_USERNAME}    password=${PASSWORD}
    ${STATUS}    ${MSG}=    POST     ${REFRESH_URL}    ${REFRESH_INFO}
    ${SUCCESS_MSG}=		Catenate	Pools for '${TEST_USERNAME}' refreshed successfully
    Should Be Equal     ${STATUS}    200
    Should Be Equal     ${MSG}      ${SUCCESS_MSG}
    ${STATUS}=	Verify Activate		${TEST_USERNAME}	${PASSWORD}
    Should Be Equal     ${STATUS}    1
    
Refresh account with existing username and wrong password
    [Documentation]
    [Tags]    regression
    ${REFRESH_INFO}=  Create Dictionary     username=${EXISTING_USERNAME}    password=${WRONG_PASSWORD}
    ${STATUS}    ${MSG}=    POST     ${REFRESH_URL}    ${REFRESH_INFO}
    ${SUCCESS_MSG}=		Set Variable	Invalid username or password
    Should Be Equal     ${STATUS}    400
    Should Be Equal     ${MSG}      ${SUCCESS_MSG}
    
Refresh account with existing username and null password
    [Documentation]
    [Tags]    regression
    ${REFRESH_INFO}=  Create Dictionary     username=${EXISTING_USERNAME}    password=
    ${STATUS}    ${MSG}=    POST     ${REFRESH_URL}    ${REFRESH_INFO}
    ${SUCCESS_MSG}=		Catenate	Unable to verify credentials for account '${EXISTING_USERNAME}'
    Should Be Equal     ${STATUS}    400
    Should Be Equal     ${MSG}      ${SUCCESS_MSG}
    
Refresh account with new username and password
    [Documentation]
    [Tags]    regression
    ${TEST_USERNAME}=	Generate Username
    ${REFRESH_INFO}=  Create Dictionary     username=${TEST_USERNAME}    password=${PASSWORD}
    ${STATUS}    ${MSG}=    POST     ${REFRESH_URL}    ${REFRESH_INFO}
    ${SUCCESS_MSG}=		Set Variable	Invalid username or password
    Should Be Equal     ${STATUS}    400
    Should Be Equal     ${MSG}      ${SUCCESS_MSG}
    
Refresh account with null username and password
    [Documentation]
    [Tags]    regression
    ${REFRESH_INFO}=  Create Dictionary     username=    password=${PASSWORD}
    ${STATUS}    ${MSG}=    POST     ${REFRESH_URL}    ${REFRESH_INFO}
    ${SUCCESS_MSG}=		Set Variable	Unable to verify credentials for account ''
    Should Be Equal     ${STATUS}    400
    Should Be Equal     ${MSG}      ${SUCCESS_MSG}
        
Refresh account with null username and null password   
    [Documentation]
    [Tags]    regression
    ${REFRESH_INFO}=  Create Dictionary     username=    password=
    ${STATUS}    ${MSG}=    POST     ${REFRESH_URL}    ${REFRESH_INFO}
    ${SUCCESS_MSG}=		Set Variable	Unable to verify credentials for account ''
    Should Be Equal     ${STATUS}    400
    Should Be Equal     ${MSG}      ${SUCCESS_MSG}  

Refresh account with nothing
    [Documentation]
    [Tags]    regression
    ${REFRESH_INFO}=  Create Dictionary     password=${PASSWORD}
    ${STATUS}    ${MSG}=    POST     ${REFRESH_URL}    ${REFRESH_INFO}
    ${SUCCESS_MSG}=		Set Variable	Bad request: Parameter 'username' is either missing or of wrong type
    Should Be Equal     ${STATUS}    400
    Should Be Equal     ${MSG}      ${SUCCESS_MSG}
    
Refresh account missing username
    [Documentation]
    [Tags]    regression
    ${REFRESH_INFO}=  Create Dictionary     password=${PASSWORD}
    ${STATUS}    ${MSG}=    POST     ${REFRESH_URL}    ${REFRESH_INFO}
    ${SUCCESS_MSG}=		Set Variable	Bad request: Parameter 'username' is either missing or of wrong type
    Should Be Equal     ${STATUS}    400
    Should Be Equal     ${MSG}      ${SUCCESS_MSG}
    
Refresh account missing password
    [Documentation]
    [Tags]    regression
    ${REFRESH_INFO}=  Create Dictionary     username=${EXISTING_USERNAME}
    ${STATUS}    ${MSG}=    POST     ${REFRESH_URL}    ${REFRESH_INFO}
    ${SUCCESS_MSG}=		Set Variable	Bad request: Parameter 'password' is either missing or of wrong type
    Should Be Equal     ${STATUS}    400
    Should Be Equal     ${MSG}      ${SUCCESS_MSG}

Verify terms after refresh account without accepting terms	
	[Documentation]	do not refresh and activate
    [Tags]    regression
	${TEST_USERNAME}=	Create Account without accepting terms
	${STATUS}=	Verify Activate		${TEST_USERNAME}	${PASSWORD}
    Should Be Equal     ${STATUS}    1
    Refresh Account		${TEST_USERNAME}	${PASSWORD}
    ${STATUS}=	Verify Activate		${TEST_USERNAME}	${PASSWORD}
    Should Be Equal     ${STATUS}    1    

Verify terms after refresh account with accepting terms	
	[Documentation]	do not refresh and activate
    [Tags]    regression
	${TEST_USERNAME}=	Create Account with accepting terms
	${STATUS}=	Verify Activate		${TEST_USERNAME}	${PASSWORD}
    Should Be Equal     ${STATUS}    0
    Refresh Account		${TEST_USERNAME}	${PASSWORD}
    ${STATUS}=	Verify Activate		${TEST_USERNAME}	${PASSWORD}
    Should Be Equal     ${STATUS}    0    

*** Keywords ***
 