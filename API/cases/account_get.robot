*** Settings ***
Documentation   Account Tool API Test for View account(GET).
Resource        ../resources/global.txt


*** Variables ***


*** Test Cases ***
View account without accepting terms
	[Documentation]
    [Tags]    regression
    ${TEST_USERNAME}=	Create account without accepting terms
	${VIEW_INFO}=  Create Dictionary     username=${TEST_USERNAME}    password=${PASSWORD}
    ${STATUS}    ${MSG}=    GET     ${GET_URL}    ${VIEW_INFO}
    Should Be Equal     ${STATUS}    400
    Should Be Equal      ${MSG}      should return some error info here

View account having sku with existing username and password
    [Documentation]
    [Tags]    regression
    ${TEST_USERNAME}=	Create account with accepting terms	
    ${QUANTITY}=	Convert To Integer	${QUANTITY}	
    Add SKU		${TEST_USERNAME}	${PASSWORD}		${SKU}		${QUANTITY}  
    Refresh Account		${TEST_USERNAME}	${PASSWORD}
    sleep	20
    ${VIEW_INFO}=  Create Dictionary     username=${TEST_USERNAME}    password=${PASSWORD}
    ${STATUS}    ${MSG}=    GET     ${GET_URL}    ${VIEW_INFO}
    Should Be Equal     ${STATUS}    200
    
    @{SKU_LIST}=	Split String	${SKU}	,
    @{SKU_QUANTITY_LIST}=	Create List
    :For	${i}	IN	@{SKU_LIST}
    \	&{SKU_DICT}= 	Create Dictionary	sku=${i}	quantity=${QUANTITY}
   	\	Append To List	${SKU_QUANTITY_LIST}	${SKU_DICT}
	Log List	list_=@{SKU_QUANTITY_LIST}	
	
    ${STATUS}=	Verify View Result	${MSG}	${TEST_USERNAME}	${SKU_QUANTITY_LIST}
    Should Be Equal		${STATUS}	0
    
View account having skus with existing username and password
    [Documentation]
    [Tags]    regression
    ${TEST_USERNAME}=	Create account with accepting terms		
    ${QUANTITY}=	Convert To Integer	${QUANTITY}	
    Add SKU		${TEST_USERNAME}	${PASSWORD}		${SKUS}		${QUANTITY}  
    Refresh Account		${TEST_USERNAME}	${PASSWORD}
    sleep	20
    ${VIEW_INFO}=  Create Dictionary     username=${TEST_USERNAME}    password=${PASSWORD}
    ${STATUS}    ${MSG}=    GET     ${GET_URL}    ${VIEW_INFO}
    Should Be Equal     ${STATUS}    200
    
    @{SKU_LIST}=	Split String	${SKUS}	,
    @{SKU_QUANTITY_LIST}=	Create List
    :For	${i}	IN	@{SKU_LIST}
    \	&{SKU_DICT}= 	Create Dictionary	sku=${i}	quantity=${QUANTITY}
   	\	Append To List	${SKU_QUANTITY_LIST}	${SKU_DICT}
	Log List	list_=@{SKU_QUANTITY_LIST}	
	
    ${STATUS}=	Verify View Result	${MSG}	${TEST_USERNAME}	${SKU_QUANTITY_LIST}
    Should Be Equal		${STATUS}	0

View account without skus with existing username and password
    [Documentation]
    [Tags]    regression
    # Create one new account without any sku
    ${TEST_USERNAME}=	Create account with accepting terms	
    # View this account    	
    ${VIEW_INFO}=  Create Dictionary     username=${TEST_USERNAME}    password=${PASSWORD}
    ${STATUS}    ${MSG}=    GET     ${GET_URL}    ${VIEW_INFO}
    Should Be Equal     ${STATUS}    200
    
    @{SKU_QUANTITY_LIST}=	Create List	
    ${STATUS}=	Verify View Result	${MSG}	${TEST_USERNAME}	${SKU_QUANTITY_LIST}
    Should Be Equal 	${STATUS}	0
    
View account with existing username and null password
    [Documentation]
    [Tags]    regression
    ${VIEW_INFO}=  Create Dictionary     username=${EXISTING_USERNAME}    password=
    ${STATUS}    ${MSG}=    GET     ${GET_URL}    ${VIEW_INFO}
    ${SUCCESS_MSG}=		Catenate	Unable to verify credentials for account '${EXISTING_USERNAME}'
    Should Be Equal     ${STATUS}    400
    Should Be Equal      ${MSG}	     ${SUCCESS_MSG}

View account with existing username and wrong password
    [Documentation]
    [Tags]    regression
    ${VIEW_INFO}=  Create Dictionary     username=${EXISTING_USERNAME}    password=${WRONG_PASSWORD}
    ${STATUS}    ${MSG}=    GET     ${GET_URL}    ${VIEW_INFO}
    ${SUCCESS_MSG}=		Set Variable	Invalid username or password
    Should Be Equal     ${STATUS}    400
    Should Be Equal      ${MSG}	     ${SUCCESS_MSG}
    
View account with existing username and password including special sku
    [Documentation]		
    ...	To check quantity for sku whose multiplier is not 1
    ...	${SPECIAL_SKU}: MCT0891
    ...	MCT0891: multiplier is 4
    [Tags]    regression
    ${TEST_USERNAME}=	Create account with accepting terms	
    ${QUANTITY}=	Convert To Integer	${QUANTITY}	
    Add SKU		${TEST_USERNAME}	${PASSWORD}		${SPECIAL_SKU}		${QUANTITY}
    Refresh Account	${TEST_USERNAME}	${PASSWORD}
    sleep	5
    	
    ${VIEW_INFO}=  Create Dictionary     username=${TEST_USERNAME}    password=${PASSWORD}
    ${STATUS}    ${MSG}=    GET     ${GET_URL}    ${VIEW_INFO}
    Should Be Equal     ${STATUS}    200
    
    ${MULTIPLIER_QUANTITY}=	Evaluate	${QUANTITY}*4
    @{SPECIAL_SKU_LIST}=	Split String	${SPECIAL_SKU}	,
    @{SKU_QUANTITY_LIST}=	Create List
    :For	${i}	IN	@{SPECIAL_SKU_LIST}
    \	&{SPECIAL_SKU_DICT}= 	Create Dictionary	sku=${i}	quantity=${MULTIPLIER_QUANTITY}
   	\	Append To List	${SKU_QUANTITY_LIST}	${SPECIAL_SKU_DICT}
	Log List	list_=@{SKU_QUANTITY_LIST}	
	
    ${STATUS}=	Verify View Result	${MSG}	${TEST_USERNAME}	${SKU_QUANTITY_LIST}
    Should Be Equal		${STATUS}	0

View account with existing username and password including special skus
    [Documentation]		
    ...	To check quantity for skus whose multiplier is not 1
    ...	${SPECIAL_SKUS}: MCT0891,MCT0892,MCT0992
    ...	MCT0891: multiplier is 4
    ...	MCT0892: multiplier is 4 
    ...	MCT0992: multiplier is 4
    [Tags]    regression
    ${TEST_USERNAME}=	Create account with accepting terms	
    ${QUANTITY}=	Convert To Integer	${QUANTITY}	
    Add SKU		${TEST_USERNAME}	${PASSWORD}		${SPECIAL_SKUS}		${QUANTITY}
    Refresh Account	${TEST_USERNAME}	${PASSWORD}
    sleep	10
    	
    ${VIEW_INFO}=  Create Dictionary     username=${TEST_USERNAME}    password=${PASSWORD}
    ${STATUS}    ${MSG}=    GET     ${GET_URL}    ${VIEW_INFO}
    Should Be Equal     ${STATUS}    200
    
    ${MULTIPLIER_QUANTITY}=	Evaluate	${QUANTITY}*4
    @{SPECIAL_SKU_LIST}=	Split String	${SPECIAL_SKUS}	,
    @{SKU_QUANTITY_LIST}=	Create List
    :For	${i}	IN	@{SPECIAL_SKU_LIST}
    \	&{SPECIAL_SKU_DICT}= 	Create Dictionary	sku=${i}	quantity=${MULTIPLIER_QUANTITY}
   	\	Append To List	${SKU_QUANTITY_LIST}	${SPECIAL_SKU_DICT}
	Log List	list_=@{SKU_QUANTITY_LIST}	
	
    ${STATUS}=	Verify View Result	${MSG}	${TEST_USERNAME}	${SKU_QUANTITY_LIST}
    Should Be Equal		${STATUS}	0

View account with existing username and password including JBOSS skus
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
    ${TEST_USERNAME}=	Create account with accepting terms
    ${QUANTITY}=	Convert To Integer	${QUANTITY}	
    Add SKU		${TEST_USERNAME}    ${PASSWORD}     ${JBOSS_SKUS}      ${QUANTITY}
    Refresh Account		${TEST_USERNAME}    ${PASSWORD}
    sleep	10
    
	${VIEW_INFO}=  Create Dictionary     username=${TEST_USERNAME}    password=${PASSWORD}
    ${STATUS}    ${MSG}=    GET     ${GET_URL}    ${VIEW_INFO}
    Should Be Equal     ${STATUS}    200
    
    @{JBOSS_SKU_LIST}=	Split String	${JBOSS_SKUS}	,
    @{SKU_QUANTITY_LIST}=	Create List
    :For	${i}	IN	@{JBOSS_SKU_LIST}
    \	&{JBOSS_SKU_DICT}= 	Create Dictionary	sku=${i}	quantity=${UNLIMITED_QUANTITY}
   	\	Append To List	${SKU_QUANTITY_LIST}	${JBOSS_SKU_DICT}
	Log List	list_=@{SKU_QUANTITY_LIST}	
	
    ${STATUS}=	Verify View Result	${MSG}	${TEST_USERNAME}	${SKU_QUANTITY_LIST}
    Should Be Equal		${STATUS}	0
 
View account with not existing username and password
    [Documentation]
    [Tags]    regression
    ${TEST_USERNAME}=	Generate Username
    ${VIEW_INFO}=  Create Dictionary     username=${TEST_USERNAME}    password=${PASSWORD}
    ${STATUS}    ${MSG}=    GET     ${GET_URL}    ${VIEW_INFO}
    ${SUCCESS_MSG}=		Set Variable	Invalid username or password
    Should Be Equal     ${STATUS}    400
    Should Be Equal      ${MSG}	     ${SUCCESS_MSG}

View account missing username
	[Documentation]
    [Tags]    regression
    ${VIEW_INFO}=  Create Dictionary     password=${PASSWORD}
    ${STATUS}    ${MSG}=    GET     ${GET_URL}    ${VIEW_INFO}
    ${SUCCESS_MSG}=		Set Variable	Bad request: Parameter 'username' is either missing or of wrong type
    Should Be Equal     ${STATUS}    400
    Should Be Equal      ${MSG}	     ${SUCCESS_MSG}
    
View account missing password
	[Documentation]
    [Tags]    regression
    ${VIEW_INFO}=  Create Dictionary     username=${EXISTING_USERNAME}
    ${STATUS}    ${MSG}=    GET     ${GET_URL}    ${VIEW_INFO}
    ${SUCCESS_MSG}=		Set Variable	Bad request: Parameter 'password' is either missing or of wrong type
    Should Be Equal     ${STATUS}    400
    Should Be Equal      ${MSG}	     ${SUCCESS_MSG}

View account with nothing
	[Documentation]
    [Tags]    regression
    ${VIEW_INFO}=  Create Dictionary   
    ${STATUS}    ${MSG}=    GET     ${GET_URL}    ${VIEW_INFO}
    ${SUCCESS_MSG}=		Set Variable	Bad request: Parameter 'username' is either missing or of wrong type
    Should Be Equal     ${STATUS}    400
    Should Be Equal      ${MSG}	     ${SUCCESS_MSG}

*** Keywords ***

View account without skus with existing username and password
    [Documentation]
    [Tags]    default
    # Create one new account without any sku
    # View this account
    ${view_info}  Create Dictionary     username=${existing_username}    password=${password}
    
    Create Session  httpbin  http://httpbin.org
    &{data}=  Create Dictionary  name=bulkan  surname=evcimen
    &{headers}=  Create Dictionary  Content-Type=application/x-www-form-urlencoded
    ${resp}=  Post Request  httpbin  /post  data=${data}  headers=${headers}
    Dictionary Should Contain Value  ${resp.json()['form']}  bulkan
    Dictionary Should Contain Value  ${resp.json()['form']}  evcimen
    
    Log     ${resp.headers}
    
    # Check
    #Create Session  google  http://www.google.com
    #Create Session  github  https://api.github.com
    #${resp}=  Get Request  google  /
    #Should Be Equal As Strings  ${resp.status_code}  200
    
    Log     ${resp.text}
    Log     ${resp.status_code}

    #${resp}=  Get Request  github  /users/bulkan
    #Should Be Equal As Strings  ${resp.status_code}  200
    #Dictionary Should Contain Value  ${resp.json()}  Bulkan Evcimen

    
View account without skus with existing username and password --
    [Documentation]
    [Tags]    default
    # Create one new account without any sku
    # View this account
    ${view_info}  Create Dictionary     username=${existing_username}    password=${password}
    
    Create Session  httpbin  http://httpbin.org
    &{data}=  Create Dictionary  name=bulkan  surname=evcimen
    &{headers}=  Create Dictionary  Content-Type=application/x-www-form-urlencoded
    ${resp}=  Post Request  httpbin  /post  data=${data}  headers=${headers}
    Dictionary Should Contain Value  ${resp.json()['form']}  bulkan
    Dictionary Should Contain Value  ${resp.json()['form']}  evcimen