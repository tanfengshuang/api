*** Setting ***
Library			Collections
Library			OperatingSystem
Library			String
Library			BuiltIn
Library			Dialogs
Library			Screenshot
Library			Selenium2Library    run_on_failure=Capture Page Screenshot    implicit_wait=0

*** Variables ***
${SERVER}				account-manager-stage.app.eng.rdu2.redhat.com
#10.3.12.152
${BROWSER}				firefox
#${BROWSER}				chrome
${REMOTE_URL}			${NONE}
${DESIRED_CAPABILITIES}	${NONE}
${TITLE}				Ethel
${ROOT}					http://${SERVER}
${FRONT_PAGE}			${ROOT}
${CREATE_PAGE}			${ROOT}/#create
${VIEW_PAGE}			${ROOT}/#view
${ACTIVATE_PAGE}		${ROOT}/#activate
${IMPORT_EXPORT_PAGE}	${ROOT}/#import_export
${ENTITLE_PAGE}			${ROOT}/#entitle
${REFRESH_PAGE}			${ROOT}/#refresh
${SEARCH_PAGE}			${ROOT}/#search_basic
${ADVANCED_SEARCH_PAGE}	${ROOT}/#search_advanced
${SPEED}          		0

${BUG_URL}				https://engineering.redhat.com/trac/content-tests/newticket?component=Stage+Account+Management+Tool&milestone=Account+Tool&type=account+tool+defect&cc=entitlement-qe@redhat.com
${STAGE_PORTAL_URL}		https://access.stage.redhat.com/
${MOJO_PAGE_URL}		https://mojo.redhat.com/docs/DOC-953386

${FIRST_NAME}			Fengshuang
${LAST_NAME}			Tan

${NOT_EXISTING_USERNAME}    not_existing_account 
${EXISTING_USERNAME}    existing_account 
${PASSWORD}             redhat
${WRONG_PASSWORD}       redhat111
${LONG_PASSWORD}		123456789012345678901234567890
${SKU}                  RH0103708
${SKUS}                 RH0103708,MCT1316F3,MCT1339 
${INVALID_SKU}			RH0103708AAA
${INVALID_SKUS}			RH0103708AAA,MCT1316F3BBB
${SPECIAL_SKU}			MCT0891
${SPECIAL_SKUS}			MCT0891,MCT0892,MCT0992
${JBOSS_SKUS}			MW0167254,MW0267188,MW0341364
${QUANTITY}             100
${STRING_QUANTITY}		string
${NEGTIVE_QUANTITY}     -1 
${UNLIMITED_QUANTITY}	unlimited

${TIMEOUT}			3600

${NOT_ACCEPT_CONTENT}	I have read and agree to the terms
#Accept Terms & Conditions 
${ACCEPT_CONTENT}		Red Hat Account Number

#ERROR
${NOT_VISIBLE_ERROR}	ElementNotVisibleException: Message: Element is not currently visible and so may not be interacted with

# Create
${Create_Username_Link}			//form[@id='account_new']/div/div/input[@id='username']
${Create_Password_Link}			//form[@id='account_new']/div/div/input[@id='password']
${Create_FirstName_Link}		//form[@id='account_new']/div/div/input[@id='first_name']
${Create_LastName_Link}			//form[@id='account_new']/div/div/input[@id='last_name']
${Create_SKU_Link}				//form[@id='account_new']/div/div/input[@id='sku']
${Create_Quantity_Link}			//form[@id='account_new']/div/div/input[@id='quantity']
${Create_ExpirationDate_Link}	//form[@id='account_new']/div/div/input[@id='expire']
${Create_Create_Link}			//form[@id='account_new']/div/div/input[@id='submit']

# View
${View_Username_Link}	//form[@id='account_view']/div/div/input[@id='username']
${View_Password_Link}	//form[@id='account_view']/div/div/input[@id='password']
${View_View_Link}		//form[@id='account_view']/div/div/input[@id='submit']

# Add
${Add_Username_Link}	//form[@id='pool_create']/div/div/input[@id='username']
${Add_Password_Link}	//form[@id='pool_create']/div/div/input[@id='password']
${Add_SKUs_Link}		//form[@id='pool_create']/div/div/input[@id='sku']
${Add_Quntity_Link}		//form[@id='pool_create']/div/div/input[@id='quantity']
${Add_Expiration_Link}	//
${Add_Entitle_Link}		//form[@id='pool_create']/div/div/input[@id='submit']

# Activate
${Activate_Username_Link}	//form[@id='account_terms']/div/div/input[@id='username']
${Activate_Password_Link}	//form[@id='account_terms']/div/div/input[@id='password']
${Activate_Accept_Link}		//form[@id='account_terms']/div/div/input[@id='submit']

# Refresh
${Refresh_Username_Link}	//form[@id='pool_refresh']/div/div/input[@id='username']
${Refresh_Password_Link}	//form[@id='pool_refresh']/div/div/input[@id='password']
${Refresh_Refresh_Link}		//form[@id='pool_refresh']/div/div/input[@id='submit']

# Import or Export
${Import_Import_Link}					//form[@id='import_form']/div[2]/div[3]/div/input[@id='submit']
${Import_AcceptTerms_Link}				//form[@id='import_form']/div[2]/div[3]/div[2]/input[@id='accept']
${Import_FirstAccountItem_Link}			//form[@id='import_form']/div[2]/div[2]/div/div/div/div[2]
${Import_SecondAccountItem_Link}		//form[@id='import_form']/div[2]/div[2]/div/div/div/div[2]
${Import_ImportAdditionalBackup_Link}	//form[@id='import_form']/div[2]/div[4]/div/button
${Export_Username_Link}					//form[@id='export-form']/div/div/div/div[2]/div[2]/div/div/div/div/input[@id='username']
${Export_Password_Link}					//form[@id='export-form']/div/div/div/div[2]/div[2]/div/div/div[2]/div/input[@id='password']
${Export_Import_Link}					//form[@id='export-form']/div/div/input[@id='submit']

# Search
${Search_Submit_Link}							//form[@id='search_basic_form']/div/div/button[@id='submit']
${Search_Criterion_Link}						//form[@id='search_basic_form']/div/div/button
${Search_ProuductNameSelect_Link}				//*[@id='ph_product_name']
#//form[@id='search_basic_form']/div/select[@id='ph_product_name']
${Search_SKUInput_Link}							//form[@id='search_basic_form']/div/input[@id='id']
${Search_Table_Link}							//table[@id="DataTables_Table_0"]
${Search_TableLabels_Link}						//*[@id='search']/div/div[1]/div/div/div[2]/div[1]/button
${Search_TableColumns_Link}						//*[@id='search']/div/div[1]/div/div/div[2]/div[2]/button
${Search_TableTotalNumber_Link}					//*[@id='DataTables_Table_0_info']/strong
${Search_TableZeroNumber_Link}					//*[@id='DataTables_Table_0_info']/b
${Search_TablePageNumber_Link}					//*[@id='DataTables_Table_0_paginate']/div/span/b
${AdvancedSearch_Submit_Link}					//form[@id='search_advanced_form']/div/div/button[@id='submit']
${AdvancedSearch_Attribute_Link}				//*[@id='search_advanced_form']/div[1]/div[1]/div[1]/button
${AdvancedSearch_StringAttributeOperator_Link}	//*[@id='search_advanced_form']/div[1]/div[1]/div[2]/button
${AdvancedSearch_StringAttributeInput_Link}		//*[@id='search_advanced_form']/div[1]/div[1]/input[1]
${AdvancedSearch_IntegerAttributeOperator_Link}	//*[@id='search_advanced_form']/div[1]/div[1]/div[4]/button
${AdvancedSearch_IntegerAttributeInput_Link}	//*[@id='search_advanced_form']/div[1]/div[1]/input[2]
${AdvancedSearch_BooleanTrue_Link}				//*[@id='search_advanced_form']/div[1]/div[1]/div[3]/div/div/span[1]
${AdvancedSearch_BooleanFalse_Link}				//*[@id='search_advanced_form']/div[1]/div[1]/div[3]/div/div/span[3]

${AdvancedSearch_SecondFilter_Attribute_Link}					//*[@id='search_advanced_form']/div[1]/div[2]/div[1]/button
${AdvancedSearch_SecondFilter_StringAttributeOperator_Link}		//*[@id='search_advanced_form']/div[1]/div[2]/div[2]/button
${AdvancedSearch_SecondFilter_StringAttributeInput_Link}		//*[@id='search_advanced_form']/div[1]/div[2]/input[1]
${AdvancedSearch_SecondFilter_IntegerAttributeOperator_Link}	//*[@id='search_advanced_form']/div[1]/div[2]/div[4]/button
${AdvancedSearch_SecondFilter_IntegerAttributeInput_Link}		//*[@id='search_advanced_form']/div[1]/div[2]/input[2]
${AdvancedSearch_SecondFilter_BooleanTrue_Link}					//*[@id='search_advanced_form']/div[1]/div[2]/div[3]/div/div/span[1]
${AdvancedSearch_SecondFilter_BooleanFalse_Link}				//*[@id='search_advanced_form']/div[1]/div[2]/div[3]/div/div/span[3]

${AdvancedSearch_ThirdFilter_Attribute_Link}					//*[@id='search_advanced_form']/div[1]/div[3]/div[1]/button
${AdvancedSearch_ThirdFilter_StringAttributeOperator_Link}		//*[@id='search_advanced_form']/div[1]/div[3]/div[2]/button
${AdvancedSearch_ThirdFilter_StringAttributeInput_Link}			//*[@id='search_advanced_form']/div[1]/div[3]/input[1]
${AdvancedSearch_ThirdFilter_IntegerAttributeOperator_Link}		//*[@id='search_advanced_form']/div[1]/div[3]/div[4]/button
${AdvancedSearch_ThirdFilter_IntegerAttributeInput_Link}		//*[@id='search_advanced_form']/div[1]/div[3]/input[2]
${AdvancedSearch_ThirdFilter_BooleanTrue_Link}					//*[@id='search_advanced_form']/div[1]/div[3]/div[3]/div/div/span[1]
${AdvancedSearch_ThirdFilter_BooleanFalse_Link}					//*[@id='search_advanced_form']/div[1]/div[3]/div[3]/div/div/span[3]

${AdvancedSearch_FourthFilter_Attribute_Link}					//*[@id='search_advanced_form']/div[1]/div[4]/div[1]/button
${AdvancedSearch_FourthFilter_StringAttributeOperator_Link}		//*[@id='search_advanced_form']/div[1]/div[4]/div[2]/button
${AdvancedSearch_FourthFilter_StringAttributeInput_Link}		//*[@id='search_advanced_form']/div[1]/div[4]/input[1]
${AdvancedSearch_FourthFilter_IntegerAttributeOperator_Link}	//*[@id='search_advanced_form']/div[1]/div[4]/div[4]/button
${AdvancedSearch_FourthFilter_IntegerAttributeInput_Link}		//*[@id='search_advanced_form']/div[1]/div[4]/input[2]
${AdvancedSearch_FourthFilter_BooleanTrue_Link}					//*[@id='search_advanced_form']/div[1]/div[4]/div[3]/div/div/span[1]
${AdvancedSearch_FourthFilter_BooleanFalse_Link}				//*[@id='search_advanced_form']/div[1]/div[4]/div[3]/div/div/span[3]

${AdvancedSearch_FifthFilter_Attribute_Link}					//*[@id='search_advanced_form']/div[1]/div[5]/div[1]/button
${AdvancedSearch_FifthFilter_StringAttributeOperator_Link}		//*[@id='search_advanced_form']/div[1]/div[5]/div[2]/button
${AdvancedSearch_FifthFilter_StringAttributeInput_Link}			//*[@id='search_advanced_form']/div[1]/div[5]/input[1]
${AdvancedSearch_FifthFilter_IntegerAttributeOperator_Link}		//*[@id='search_advanced_form']/div[1]/div[5]/div[4]/button
${AdvancedSearch_FifthFilter_IntegerAttributeInput_Link}		//*[@id='search_advanced_form']/div[1]/div[5]/input[2]
${AdvancedSearch_FifthFilter_BooleanTrue_Link}					//*[@id='search_advanced_form']/div[1]/div[5]/div[3]/div/div/span[1]
${AdvancedSearch_FifthFilter_BooleanFalse_Link}					//*[@id='search_advanced_form']/div[1]/div[5]/div[3]/div/div/span[3]

${AdvancedSearch_DeleteFilter_Link}								//*[@id='search_advanced_form']/div[1]/div[2]/a/span

# Column Number in search result table
${Table_SKUName_ColumnNumber}								1
${Table_ProductHierarchyProductCategory_ColumnNumber}		2
${Table_ProductHierarchyProductLine_ColumnNumber}			3
${Table_ProductHierarchyProductName_ColumnNumber}			4
${Table_ProductName_ColumnNumber}							5
${Table_VirtLimit_ColumnNumber}								6
${Table_Sockets_ColumnNumber}								7
${Table_VCPU_ColumnNumber}									8
${Table_Multiplier_ColumnNumber}							9
${Table_UnlimitedProduct_ColumnNumber}						10
${Table_RequiredConsumerType_ColumnNumber}					11
${Table_ProductFamily_ColumnNumber}							12
${Table_ManagementEnabled_ColumnNumber}						13
${Table_Variant_ColumnNumber}								14
${Table_SupportLevel_ColumnNumber}							15
${Table_SupportType_ColumnNumber}							16
${Table_EnabledConsumerTypes_ColumnNumber}					17
${Table_Virt-only_ColumnNumber}								18
${Table_Cores_ColumnNumber}									19
${Table_JONManagement_ColumnNumber}							20
${Table_RAM_ColumnNumber}									21
${Table_InstanceBasedVirtMultiplier_ColumnNumber}			22
${Table_CloudAccessEnabled_ColumnNumber}					23
${Table_StackingID_ColumnNumber}							24
${Table_MultiEntitlement_ColumnNumber}						25
${Table_HostLimited_ColumnNumber}							26
${Table_DerivedSKU_ColumnNumber}							27
${Table_Arch_ColumnNumber}									28
${Table_EngProductIDs_ColumnNumber}							29
${Table_Username_ColumnNumber}								30


${candlepin_internal_list}		id,
								...	ph_category,
								...	ph_product_line,
								...	ph_product_name,
								...	name,
								...	virt_limit,
								...	sockets,
								...	vcpu,
								...	multiplier,
								...	unlimited_product,
								...	requires_consumer_type,
								...	product_family,
								...	management_enabled,
								...	variant,
								...	support_level,
								...	support_type,
								...	enabled_consumer_types,
								...	virt_only,
								...	cores,
								...	jon_management,
								...	ram,
								...	instance_multiplier,
								...	cloud_access_enabled,
								...	stacking_id,
								...	multi_entitlement,
								...	host_limited,
								...	derived_sku,
								...	arch,
								...	eng_product_ids,
								...	username
${verbose_name_list}			SKU Name,
								...	Product Hierarchy: Product Category,
								...	Product Hierarchy: Product Line,
								...	Product Hierarchy: Product Name,
								...	Product Name,
								...	Virt Limit,
								...	Socket(s),
								...	VCPU,
								...	Multiplier,
								...	Unlimited Product,
								...	Required Consumer Type,
								...	Product Family,
								...	Management Enabled,
								...	Variant,
								...	Support Level,
								...	Support Type,
								...	Enabled Consumer Types,
								...	Virt-only,
								...	Cores,
								...	JON Management,
								...	RAM,
								...	Instance Based Virt Multiplier,
								...	Cloud Access Enabled,
								...	Stacking ID,
								...	Multi Entitlement,
								...	Host Limited,
								...	Derived SKU,
								...	Arch,
								...	Eng Product ID(s),
								...	Username

${verbose_name_candlepin_internal_list}		SKU Name\nid,
											...	Product Hierarchy: Product Category\nph_category,
											...	Product Hierarchy: Product Line\nph_product_line,
											...	Product Hierarchy: Product Name\nph_product_name,
											...	Product Name\nname,
											...	Virt Limit\nvirt_limit,
											...	Socket(s)\nsockets,
											...	VCPU\nvcpu,
											...	Multiplier\nmultiplier,
											...	Unlimited Product\nunlimited_product,
											...	Required Consumer Type\nrequires_consumer_type,
											...	Product Family\nproduct_family,
											...	Management Enabled\nmanagement_enabled,
											...	Variant\nvariant,
											...	Support Level\nsupport_level,
											...	Support Type\nsupport_type,
											...	Enabled Consumer Types\nenabled_consumer_types,
											...	Virt-only\nvirt_only,
											...	Cores\ncores,
											...	JON Management\njon_management,
											...	RAM\nram,
											...	Instance Based Virt Multiplier\ninstance_multiplier,
											...	Cloud Access Enabled\ncloud_access_enabled,
											...	Stacking ID\nstacking_id,
											...	Multi Entitlement\nmulti_entitlement,
											...	Host Limited\nhost_limited,
											...	Derived SKU\nderived_sku,
											...	Arch\narch,
											...	Eng Product ID(s)\neng_product_ids,
											...	Username\nusername


*** Keywords ***
Generate Username
    [Documentation]
    ...	Generate one username
    [Tags]    global
    ${time}    Get Time    epoch
    ${random_str}=    Generate Random String    length=4    chars=[LOWER]
    ${username}=    Catenate    user${time}${random_str}
    [Return]    ${username}

Verify result after create account successfully
    [Documentation]
    ...	Only create account, not add any skus
	[Arguments]   ${TEST_USERNAME}
    ${SUCCESS_MESSAGE}=   Catenate  Creating account "${TEST_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=50
    ${SUCCESS_MESSAGE}=   Catenate  Accepting Ts&Cs for "${TEST_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=50 
    ${SUCCESS_MESSAGE}=   Set Variable  Creating account owners in Candlepin
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=50
    ${SUCCESS_MESSAGE}=   Catenate  Account "${TEST_USERNAME}" created
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=50

Verify result after create create and add sku successfully
 	[Documentation] 
 	...	Create account and add sku
 	...	For 'Create' Page
 	[Arguments]   ${TEST_USERNAME}  
 	${SUCCESS_MESSAGE}=   Catenate  Creating account "${TEST_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=50
    ${SUCCESS_MESSAGE}=   Catenate  Accepting Ts&Cs for "${TEST_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=50 
    ${SUCCESS_MESSAGE}=   Set Variable  Adding subscriptions to "${TEST_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=70
    ${SUCCESS_MESSAGE}=   Set Variable  Creating account owners in Candlepin
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=70
    ${SUCCESS_MESSAGE}=   Catenate  Account "${TEST_USERNAME}" created
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=70

Check Terms Status
	[Documentation]	
	[Arguments]   ${TEST_USERNAME}	${CONTENT}
	Open Browser	${STAGE_PORTAL_URL}   ${BROWSER}
	Maximize Browser Window	
	Wait Until Page Contains	Log In		timeout=100
	Click Element		xpath=//*[@id='home-login-btn']
	Wait Until Page Contains	Log in to your Red Hat account		timeout=100
	Input Text     id=username    ${TEST_USERNAME}
	Input Text     id=password    ${PASSWORD}
    Click Element  id=_eventId_submit
    Wait Until Page Contains	${CONTENT}
	
Verify result after add sku successfully
	[Documentation]
	...	For 'Add Subscriptions' Page
	[Arguments]   ${TEST_USERNAME}
	${SUCCESS_MESSAGE}=   Catenate  Accepting Ts&Cs for "${TEST_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=50
    ${SUCCESS_MESSAGE}=   Catenate  Adding subscriptions to "${TEST_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=20
    ${SUCCESS_MESSAGE}=   Set Variable  	All pools successfully added
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	    timeout=500

Verify result after add sku when uncheck terms button
	#Success Attached without accepting terms
	[Documentation]
	...	For 'Add Subscriptions' Page
	[Arguments]   ${TEST_USERNAME}
    ${SUCCESS_MESSAGE}=   Catenate  Adding subscriptions to "${TEST_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    ${SUCCESS_MESSAGE}=   Set Variable  	All pools successfully added
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	    timeout=500
        
Test File a bug Link
	[Documentation]
	@{L1}=	List Windows
	Wait Until Page Contains Element		link=File a bug
	Sleep	0.1
    Click Element	link=File a bug
    @{L2}=	List Windows
    Select Window	new
    Maximize Browser Window
	Wait Until Page Contains	Create New Ticket	20
	Location should be	${BUG_URL}
	Close Window
	Select Window

Open Browser To Start Page
    [Documentation]    This keyword also tests 'Set Selenium Speed' and 'Set Selenium Timeout'
    ...    against all reason.
    ${default speed}    ${default timeout} =    Open Browser To Start Page Without Testing Default Options
    Should Be Equal    ${default speed}    0 seconds
    Should Be Equal    ${default timeout}    5 seconds

Open Browser To Start Page Without Testing Default Options
    [Documentation]    Open Browser To Start Page Without Testing Default Options
    Open Browser    ${FRONT PAGE}    ${BROWSER}    remote_url=${REMOTE_URL}
    ...    desired_capabilities=${DESIRED_CAPABILITIES}
    ${orig speed} =    Set Selenium Speed    ${SPEED}
    ${orig timeout} =    Set Selenium Timeout    10 seconds
    [Return]    ${orig speed}    5 seconds

Open Browser To Start Page And Test Implicit Wait
    [Arguments]    ${implicit_wait}
    [Documentation]    This keyword tests that 'Set Selenium Implicit Wait' and
    ...    'Get Selenium Implicit Wait' work as expected
    Should Not Be Equal    0    ${implicit_wait}
    ...    Please do not pass in a value of 0 for the implicit wait argument for this function
    ${old_wait}=    Set Selenium Implicit Wait    ${implicit_wait}
    Open Browser    ${FRONT PAGE}    ${BROWSER}    remote_url=${REMOTE_URL}
    ...    desired_capabilities=${DESIRED_CAPABILITIES}
    ${default_implicit_wait} =    Get Selenium Implicit Wait
    Should Be Equal    ${implicit_wait} seconds    ${default_implicit_wait}
    #be sure to revert the implicit wait to whatever it was before so as to not effect other tests
    Set Selenium Implicit Wait    ${old_wait}

Cannot Be Executed In IE
    [Documentation]    Cannot Be Executed In IE
    ${runsInIE}=    Set Variable If    "${BROWSER}".replace(' ', '').lower() in ['ie', '*iexplore', 'internetexplorer']    ${TRUE}
    Run Keyword If    ${runsInIE}    Set Tags    ie-incompatible
    Run Keyword If    ${runsInIE}    Fail And Set Non-Critical
    ...    This test does not work in Internet Explorer

Fail And Set Non-Critical
    [Arguments]    ${msg}
    [Documentation]    Fails And Set Non-Critical
    Remove Tags    regression
    Fail    ${msg}

Go to Front Page
    [Documentation]    Goes to front page
    Go To    ${FRONT PAGE}

Go To Page "${relative url}"
    [Documentation]    Goes to page
    Go To    ${ROOT}/${relative url}

Set ${level} Loglevel
    [Documentation]    Sets loglevel
    Set Log Level    ${level}

Verify Location Is "${relative url}"
    [Documentation]    Verifies location
    Location Should Be    ${ROOT}/${relative url}
    
    
    
    
#################################################
##                     Search                  ##
#################################################   
 
Table Header Check
	[Documentation]
	[Arguments]   ${header_list}
	#@{header_list} 	Evaluate	${header_list}.split(",")
	@{header_list}=	Split String	${header_list}	,
	:FOR	${i} 	IN		@{header_list}
	\	${i}=	Strip String	${i}
	\	Table Header Should Contain		xpath=${Search_Table_Link}		${i}

Verify Table Header Column Title
	[Documentation]
	[Arguments]   ${xpath}	${value}
	Click Element		xpath=${xpath}
    ${cell_content}=		Get Table Cell		xpath=${Search_Table_Link}		1		-1
    Should Be Equal		${cell_content}    ${value}	

Get Total Number of Table Items
	[Documentation]
	${string_length}=	Get Text	xpath=${Search_TableTotalNumber_Link}
	${length}=	Replace String	${string_length}	,	${EMPTY}
	${length}=	Convert To Integer	${length}
	[Return]	${length}

Loop Table To Verify Equal
	[Documentation]
	[Arguments]    ${length}	${column}	${str}
	:For	${i}	in range	${length}
	\	${row_number}=		Evaluate	2+${i}
	\	${cell_content}=	Get Table Cell	xpath=${Search_Table_Link}	${row_number}	${column}
	\	Should Be Equal		${cell_content}	${str}

Loop Table To Verify Not Equal
	[Documentation]
	[Arguments]    ${length}	${column}	${str}
	:For	${i}	in range	${length}
	\	${row_number}=		Evaluate	2+${i}
	\	${cell_content}=	Get Table Cell	xpath=${Search_Table_Link}	${row_number}	${column}
	\	Should Not Be Equal		${cell_content}	${str}

Loop Table To Verify Contain
	[Documentation]
	[Arguments]    ${length}	${column}	${str}
	:For	${i}	in range	${length}
	\	${row_number}=		Evaluate	2+${i}
	\	${cell_content}=	Get Table Cell	xpath=${Search_Table_Link}	${row_number}	${column}
	\	Table Cell Should Contain     xpath=${Search_Table_Link}	${row_number}	${column}     ${str}
	
Loop Table To Verify Not Contain
	[Documentation]
	[Arguments]    ${length}	${column}	${str}
	:For	${i}	in range	${length}
	\	${row_number}=		Evaluate	2+${i}
	\	${cell_content}=		Get Table Cell		xpath=${Search_Table_Link}		${row_number}		${column}
	\	Should Not Contain		${cell_content}	${str}
	
Loop Table To Verify Greater Than
	[Documentation]
	[Arguments]    ${length}	${column}	${int}
	:For	${i}	in range	${length}
	\	${row_number}=		Evaluate	2+${i}
	\	${cell_content}=		Get Table Cell		xpath=${Search_Table_Link}		${row_number}		${column}
	\	Should Be True		${cell_content}	> ${int}
	
Loop Table To Verify Less Then
	[Documentation]
	[Arguments]    ${length}	${column}	${int}
	:For	${i}	in range	${length}
	\	${row_number}=		Evaluate	2+${i}
	\	${cell_content}=		Get Table Cell		xpath=${Search_Table_Link}		${row_number}		${column}
	\	Should Be True		${cell_content}	< ${int}



