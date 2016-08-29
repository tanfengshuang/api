*** Settings ***
Documentation   Account Tool API Test for attach(POST).
Resource        ../resources/global.txt


*** Variables ***

*** Test Cases ***    
Add subscriptions to a account without accepting terms
	[Documentation]		(integer > 0)
	[Tags]    regression
	@{SKU_LIST}=	Split String	${SKUS}	,
	${TEST_USERNAME}=	Create account without accepting terms
	${QUANTITY}=	Convert To Integer	${QUANTITY}
    Add SKU		${TEST_USERNAME}	${PASSWORD}		${SKUS}		${QUANTITY} 
    # To check if skus are added successfully, activate account to accept terms firstly
    Activate Account	${TEST_USERNAME}	${PASSWORD}
    Refresh Account		${TEST_USERNAME}	${PASSWORD}
    :For	${SKU}	in	@{SKU_LIST}
    \	${STATUS}=	Verify SKU	${SKU}	${TEST_USERNAME}	${PASSWORD}
    \	Should Be Equal     ${STATUS}   0

Add subscriptions with existing username, password, sku and quantity
	[Documentation]		(integer > 0)
	[Tags]    regression
	${TEST_USERNAME}=	Create account with accepting terms
	${QUANTITY}=	Convert To Integer	${QUANTITY}
	Add SKU		${TEST_USERNAME}	${PASSWORD}		${SKU}		${QUANTITY}     
    #Activate account	${TEST_USERNAME}	${PASSWORD}
    Refresh account		${TEST_USERNAME}	${PASSWORD}
    ${STATUS}=	Verify SKU      ${SKU}	${TEST_USERNAME}	${PASSWORD}
    Should Be Equal     ${STATUS}    0
    
Add subscriptions with existing username, password, several skus
	[Documentation]		(including correct and invalid skus) and quantity 
	[Tags]    regression
	@{SKU_LIST}=	Split String	${SKUS}	,
	${TEST_USERNAME}=	Create account with accepting terms
	${QUANTITY}=	Convert To Integer	${QUANTITY}
	Add SKU		${TEST_USERNAME}	${PASSWORD}		${SKUS}		${QUANTITY} 
	#Activate account	${TEST_USERNAME}	${PASSWORD}
    Refresh account		${TEST_USERNAME}	${PASSWORD}
    :For    ${sku}    in      @{SKU_LIST}
    \	${STATUS}=	Verify SKU	${sku}	${TEST_USERNAME}	${PASSWORD}
    \	Should Be Equal     ${STATUS}    0 


Add subscriptions with existing username, password, JBOSS skus and quantity
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
    @{SKU_LIST}=	Split String	${SPECIAL_SKUS}	,
    ${TEST_USERNAME}=	Create account with accepting terms
    ${QUANTITY}=	Convert To Integer	${QUANTITY}
    ${ADD_INFO}=  Create Dictionary     username=${TEST_USERNAME}    password=${PASSWORD}     sku=${SKU_LIST}      quantity=${QUANTITY}
    ${STATUS}    ${MSG}=    POST    ${ADD_URL}   ${ADD_INFO}
    Should Be Equal     ${STATUS}   200
    Refresh Account		${TEST_USERNAME}    ${PASSWORD}
    sleep	5
    :For    ${sku}    in      @{SKU_LIST}
    \	${STATUS}=	Verify SKU	${sku}	${TEST_USERNAME}	${PASSWORD}
    \	Should Be Equal     ${STATUS}    0 

Add subscriptions with existing username, password, sku and string quantity    
	[Documentation]
    [Tags]    regression
    @{SKU_LIST}=	Split String	${SKU}	,
    ${ADD_INFO}=  Create Dictionary     username=${EXISTING_USERNAME}    password=${PASSWORD}     sku=${SKU_LIST}      quantity=${STRING_QUANTITY}
    ${STATUS}    ${MSG}=    POST    ${ADD_URL}   ${ADD_INFO}
    Should Be Equal     ${STATUS}   400
    ${SUCCESS_MSG}=		Catenate	Bad request: 'Invalid quantity value'
    Should Be Equal      ${MSG}      ${SUCCESS_MSG}
        
Add subscriptions with existing username, password, sku and null quantity
    [Documentation]		Is it neccessary to check default quantity?
    [Tags]    regression
    ${TEST_USERNAME}=	Create account with accepting terms
    @{SKU_LIST}=	Split String	${SKU}	,
    ${ADD_INFO}=  Create Dictionary     username=${TEST_USERNAME}    password=${PASSWORD}     sku=@{SKU_LIST}      quantity=
    ${STATUS}    ${MSG}=    POST    ${ADD_URL}   ${ADD_INFO}
    Should Be Equal     ${STATUS}   400
    ${SUCCESS_MSG}=		Catenate	Bad request: Parameter 'quantity' is either missing or of wrong type
    Should Be Equal      ${MSG}     ${SUCCESS_MSG}
    
Add subscriptions with existing username, password, sku and zero quantity
    [Documentation]
    [Tags]    regression
    @{SKU_LIST}=	Split String	${SKU}	,
    ${ZERO_QUANTITY}=	Convert To Integer	0
    ${ADD_INFO}=  Create Dictionary     username=${EXISTING_USERNAME}    password=${PASSWORD}     sku=${SKU_LIST}      quantity=${ZERO_QUANTITY}
    ${STATUS}    ${MSG}=    POST    ${ADD_URL}   ${ADD_INFO}
    Should Be Equal     ${STATUS}   400
    ${SUCCESS_MSG}=		Catenate	Bad request: 'Invalid quantity value'
    Should Be Equal      ${MSG}      ${SUCCESS_MSG}
    
Add subscriptions with existing username, password, sku and negative quantity
    [Documentation]
    [Tags]    regression
    @{SKU_LIST}=	Split String	${SKU}	,
    ${NEGTIVE_QUANTITY}=	Convert To Integer	${NEGTIVE_QUANTITY}
    ${ADD_INFO}=  Create Dictionary     username=${EXISTING_USERNAME}    password=${PASSWORD}     sku=${SKU_LIST}      quantity=${NEGTIVE_QUANTITY}
    ${STATUS}    ${MSG}=    POST    ${ADD_URL}   ${ADD_INFO}
    Should Be Equal     ${STATUS}   400
    ${SUCCESS_MSG}=		Catenate	Bad request: 'Invalid quantity value'
    Should Be Equal      ${MSG}      ${SUCCESS_MSG}
    
Add subscriptions with existing username, password, invalid sku and quantity
    [Documentation]
    [Tags]    regression
    @{INVALID_SKU_LIST}=	Split String	${INVALID_SKU}	,
    ${QUANTITY}=	Convert To Integer	${QUANTITY}
    ${ADD_INFO}=  Create Dictionary     username=${EXISTING_USERNAME}    password=${PASSWORD}     sku=${INVALID_SKU_LIST}      quantity=${QUANTITY}
    ${STATUS}    ${MSG}=    POST    ${ADD_URL}   ${ADD_INFO}
    Should Be Equal     ${STATUS}   400
    ${SUCCESS_MSG}=		Catenate	Unable to attach SKUs (not found in the DB): [u'${INVALID_SKU}']
    Should Be Equal      ${MSG}      ${SUCCESS_MSG}
    
Add subscriptions with existing username, password, invalid sku and zero quantity
    [Documentation]
    [Tags]    regression
    @{INVALID_SKU_LIST}=	Split String	${INVALID_SKU}	,
    ${ZERO_QUANTITY}=	Convert To Integer	0
    ${ADD_INFO}=  Create Dictionary     username=${EXISTING_USERNAME}    password=${PASSWORD}     sku=${INVALID_SKU_LIST}      quantity=${ZERO_QUANTITY}
    ${STATUS}    ${MSG}=    POST    ${ADD_URL}   ${ADD_INFO}
    Should Be Equal     ${STATUS}   400
    ${SUCCESS_MSG}=		Catenate	Bad request: 'Invalid quantity value'
    Should Be Equal      ${MSG}      ${SUCCESS_MSG}
    
Add subscriptions with existing username, null password, sku and quantity
    [Documentation]
    [Tags]    regression
    @{SKU_LIST}=	Split String	${SKU}	,
    ${QUANTITY}=	Convert To Integer	${QUANTITY}
    ${ADD_INFO}=  Create Dictionary     username=${EXISTING_USERNAME}    password=     sku=${SKU_LIST}      quantity=${QUANTITY}
    ${STATUS}    ${MSG}=    POST    ${ADD_URL}   ${ADD_INFO}
    Should Be Equal     ${STATUS}   400
    ${SUCCESS_MSG}=		Catenate	Unable to verify credentials for account '${EXISTING_USERNAME}'
    Should Be Equal      ${MSG}      ${SUCCESS_MSG}
    
Add subscriptions with existing username, wrong password, sku and quantity
    [Documentation]
    [Tags]    regression
    @{SKU_LIST}=	Split String	${SKU}	,
    ${QUANTITY}=	Convert To Integer	${QUANTITY}
    ${ADD_INFO}=  Create Dictionary     username=${EXISTING_USERNAME}    password=${WRONG_PASSWORD}     sku=${SKU_LIST}      quantity=${QUANTITY}
    ${STATUS}    ${MSG}=    POST    ${ADD_URL}   ${ADD_INFO}
    Should Be Equal     ${STATUS}   400
    ${SUCCESS_MSG}=		Catenate	Invalid username or password
    Should Be Equal      ${MSG}      ${SUCCESS_MSG}
    
Add subscriptions with null username, null password, sku and quantity
    [Documentation]
    [Tags]    regression
    @{SKU_LIST}=	Split String	${SKU}	,
    ${QUANTITY}=	Convert To Integer	${QUANTITY}
    ${ADD_INFO}=  Create Dictionary     username=    password=     sku=${SKU_LIST}      quantity=${QUANTITY}
    ${STATUS}    ${MSG}=    POST    ${ADD_URL}   ${ADD_INFO}
    Should Be Equal     ${STATUS}   400
    ${SUCCESS_MSG}=		Catenate	Unable to verify credentials for account ''
    Should Be Equal      ${MSG}      ${SUCCESS_MSG}
    
Add subscriptions with new username, password, sku and quantity
    [Documentation]
    [Tags]    regression
    ${TEST_USERNAME}=	Generate Username
    @{SKU_LIST}=	Split String	${SKU}	,
    ${QUANTITY}=	Convert To Integer	${QUANTITY}
    ${ADD_INFO}=  Create Dictionary     username=${TEST_USERNAME}    password=${PASSWORD}     sku=${SKU_LIST}      quantity=${QUANTITY}
    ${STATUS}    ${MSG}=    POST    ${ADD_URL}   ${ADD_INFO}
    Should Be Equal     ${STATUS}   400
    ${SUCCESS_MSG}=		Catenate	Invalid username or password
    Should Be Equal      ${MSG}      ${SUCCESS_MSG}
    
Add subscriptions with new username, password, null sku and null quantity
    [Documentation]
    [Tags]    regression
    ${TEST_USERNAME}=	Create account with accepting terms
    ${ADD_INFO}=  Create Dictionary     username=${TEST_USERNAME}    password=${PASSWORD}     sku=      quantity=
    ${STATUS}    ${MSG}=    POST    ${ADD_URL}   ${ADD_INFO}
    Should Be Equal     ${STATUS}    400
    ${SUCCESS_MSG}=		Catenate	Bad request: 'No SKUs listed'
    Should Be Equal      ${MSG}      ${SUCCESS_MSG}

Add subscriptions with nothing
	[Documentation]
    [Tags]    regression
    @{SKU_LIST}=	Split String	${SKU}	,
    ${QUANTITY}=	Convert To Integer	${QUANTITY}
    ${ADD_INFO}=  Create Dictionary     password=${PASSWORD}     sku=@{SKU_LIST}      quantity=${QUANTITY}
    ${STATUS}    ${MSG}=    POST    ${ADD_URL}   ${ADD_INFO}
    Should Be Equal     ${STATUS}    400
    ${SUCCESS_MSG}=		Catenate	Bad request: Parameter 'username' is either missing or of wrong type
    Should Be Equal      ${MSG}      ${SUCCESS_MSG}

Add subscriptions missing username
	[Documentation]
    [Tags]    regression
    @{SKU_LIST}=	Split String	${SKU}	,
    ${QUANTITY}=	Convert To Integer	${QUANTITY}
    ${ADD_INFO}=  Create Dictionary     password=${PASSWORD}     sku=@{SKU_LIST}      quantity=${QUANTITY}
    ${STATUS}    ${MSG}=    POST    ${ADD_URL}   ${ADD_INFO}
    Should Be Equal     ${STATUS}    400
    ${SUCCESS_MSG}=		Catenate	Bad request: Parameter 'username' is either missing or of wrong type
    Should Be Equal      ${MSG}      ${SUCCESS_MSG}

Add subscriptions missing password
	[Documentation]
    [Tags]    regression
    @{SKU_LIST}=	Split String	${SKU}	,
    ${QUANTITY}=	Convert To Integer	${QUANTITY}
    ${ADD_INFO}=  Create Dictionary     username=${EXISTING_USERNAME}	sku=@{SKU_LIST}      quantity=${QUANTITY}
    ${STATUS}    ${MSG}=    POST    ${ADD_URL}   ${ADD_INFO}
    Should Be Equal     ${STATUS}    400
    ${SUCCESS_MSG}=		Catenate	Bad request: Parameter 'password' is either missing or of wrong type
    Should Be Equal      ${MSG}      ${SUCCESS_MSG}

Add subscriptions missing sku
	[Documentation]
    [Tags]    regression
    ${QUANTITY}=	Convert To Integer	${QUANTITY}
    ${ADD_INFO}=  Create Dictionary     username=${EXISTING_USERNAME}    password=${PASSWORD}     quantity=${QUANTITY}
    ${STATUS}    ${MSG}=    POST    ${ADD_URL}   ${ADD_INFO}
    Should Be Equal     ${STATUS}    400
    ${SUCCESS_MSG}=		Catenate	Bad request: Parameter 'sku' is either missing or of wrong type
    Should Be Equal      ${MSG}      ${SUCCESS_MSG}
    
Add subscriptions missing quantity
	[Documentation]
    [Tags]    regression
    @{SKU_LIST}=	Split String	${SKU}	,
    ${TEST_USERNAME}=	Create account with accepting terms
    ${ADD_INFO}=  Create Dictionary     username=${TEST_USERNAME}    password=${PASSWORD}     sku=@{SKU_LIST}
    ${STATUS}    ${MSG}=    POST    ${ADD_URL}   ${ADD_INFO}
    Should Be Equal     ${STATUS}    200
    # These SKUs have been attached to 'aaa' account: [u'RH0103708']
    ${SUCCESS_MSG}=		Catenate	These SKUs have been attached to '${TEST_USERNAME}' account: @{SKU_LIST}
    Should Be Equal      ${MSG}      ${SUCCESS_MSG}
    Refresh Account		${TEST_USERNAME}	${PASSWORD}
    :For	${sku}	in	@{SKU_LIST}
    \	${STATUS}=	Verify SKU	${sku}	${TEST_USERNAME}	${PASSWORD}
    \	Should Be Equal     ${STATUS}   0

*** Keywords ***