*** Settings ***
Documentation     How to manage accounts using account management tool
Resource          ../resources/global.robot
Suite Setup       Open Browser  ${FRONT_PAGE}   ${BROWSER}
#Suite Teardown    Close All Browsers

*** Variables ***
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


*** Test Cases ***
Search - check url location
    [Documentation] 
	[Tags]     regression
	Open Account Test Page		Add Subscriptions
    Page should contain   Add subscriptions
	${location}=	Get location
	
Search - check input default info
	[Documentation] 
	[Tags]     regression

Search - check help info
	[Documentation] 
	[Tags]     regression

Search by Product Hierarchy: Product Name with ALL Product
    [Documentation] 
    [Tags]     regression
    Maximize Browser Window
    Go to Front Page
    Click Link		Search SKU Catalog
    Click Link		Search
    Page should contain   Search results
    Click Element  xpath=//form[@id='search_basic_form']/div/div/button[@id='submit']
    ${SUCCESS_MESSAGE}=	Set Variable	Searching for suitable results...
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    ${SUCCESS_MESSAGE}=	Set Variable	Searching the database
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    Wait Until Page Contains Element	xpath=//table[@id="DataTables_Table_0"]
    sleep 	20
    #Table Header Should Contain		xpath=//table[@id="DataTables_Table_0"]		Product Hierarchy: Product Category
    Table Header Check		${verbose_name_list}
    Table Column Should Contain			xpath=//table[@id="DataTables_Table_0"]		2		Subscriptions

Search by Product Hierarchy: Product Name with Academic
    [Documentation] 
    [Tags]     regression
	Maximize Browser Window
    Go to Front Page
    Click Link		Search SKU Catalog
    Click Link		Search
    Page should contain   Search results
    #Select From List By Index		xpath=//form[@id='search_basic_form']/div/select[@id='ph_product_name']		2
    Select From List By Value		xpath=//form[@id='search_basic_form']/div/select[@id='ph_product_name']		Academic
    Click Element  xpath=//form[@id='search_basic_form']/div/div/button[@id='submit']
    ${SUCCESS_MESSAGE}=	Set Variable	Searching for suitable results...
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    ${SUCCESS_MESSAGE}=	Set Variable	Searching the database
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    Wait Until Page Contains Element	xpath=//table[@id="DataTables_Table_0"]
    sleep 	10
    #Table Header Should Contain		xpath=//table[@id="DataTables_Table_0"]		Product Hierarchy: Product Category
    Table Header Check		${verbose_name_list}
    #Table Should Contain	xpath=//table[@id="DataTables_Table_0"]		Subscriptions
    Table Column Should Contain			xpath=//table[@id="DataTables_Table_0"]		4		Academic

Search by SKU with nothing
    [Documentation] 
    [Tags]     regression
    Maximize Browser Window
    Go to Front Page
    Click Link		Search SKU Catalog
    Click Link		Search
    Page should contain   Search results
    Click Button		xpath=//form[@id='search_basic_form']/div/div/button
    Click Link		SKU
    #Input Text     xpath=//form[@id='search_basic_form']/div/input[@id='id']		RH0103708 
    Click Element  xpath=//form[@id='search_basic_form']/div/div/button[@id='submit']
    ${SUCCESS_MESSAGE}=	Set Variable	Searching for suitable results...
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    ${SUCCESS_MESSAGE}=	Set Variable	Searching the database
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    Wait Until Page Contains Element	xpath=//table[@id="DataTables_Table_0"]
    sleep 	50
    #Table Header Should Contain		xpath=//table[@id="DataTables_Table_0"]		Product Hierarchy: Product Category
    Table Header Check		${verbose_name_list}
    Table Column Should Contain			xpath=//table[@id="DataTables_Table_0"]		2		Subscriptions

Search by SKU with existing sku
    [Documentation] 
    [Tags]     regression
    Maximize Browser Window
    Go to Front Page
    Click Link		Search SKU Catalog
    Click Link		Search
    Page should contain   Search results
    Click Button		xpath=//form[@id='search_basic_form']/div/div/button
    Click Link		SKU
    Input Text     xpath=//form[@id='search_basic_form']/div/input[@id='id']		RH0103708 
    Click Element  xpath=//form[@id='search_basic_form']/div/div/button[@id='submit']
    ${SUCCESS_MESSAGE}=	Set Variable	Searching for suitable results...
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    ${SUCCESS_MESSAGE}=	Set Variable	Searching the database
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    Wait Until Page Contains Element	xpath=//table[@id="DataTables_Table_0"]
    sleep 	10
    #Table Header Should Contain		xpath=//table[@id="DataTables_Table_0"]		Product Hierarchy: Product Category
    Table Header Check		${verbose_name_list}
    Table Column Should Contain			xpath=//table[@id="DataTables_Table_0"]		1		RH0103708
    
Search by SKU with invalid sku
    [Documentation] 
    [Tags]     regression
    Maximize Browser Window
    Go to Front Page
    Click Link		Search SKU Catalog
    Click Link		Search
    Page should contain   Search results
    Click Button		xpath=//form[@id='search_basic_form']/div/div/button
    Click Link		SKU
    Input Text     xpath=//form[@id='search_basic_form']/div/input[@id='id']		asdfe 
    Click Element  xpath=//form[@id='search_basic_form']/div/div/button[@id='submit']
    ${SUCCESS_MESSAGE}=	Set Variable	Searching for suitable results...
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    ${SUCCESS_MESSAGE}=	Set Variable	Searching the database
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    Wait Until Page Contains Element	xpath=//table[@id="DataTables_Table_0"]
    sleep 	10
    #Table Header Should Contain		xpath=//table[@id="DataTables_Table_0"]		Product Hierarchy: Product Category
    Table Header Check		${verbose_name_list}
    Table Column Should Contain			xpath=//table[@id="DataTables_Table_0"]		1		No data available in table
    
View Search result with Labels
    [Documentation] 
    [Tags]     regression	
    Maximize Browser Window
    Go to Front Page
    Click Link		Search SKU Catalog
    Click Link		Search
    Page should contain   Search results
    Select From List By Value		xpath=//form[@id='search_basic_form']/div/select[@id='ph_product_name']		Academic
    Click Element  xpath=//form[@id='search_basic_form']/div/div/button[@id='submit']
    Wait Until Page Contains Element	xpath=//table[@id="DataTables_Table_0"]
    sleep 	10
    
    @{verbose_name_list}=	Split String	${verbose_name_list}	,
	@{candlepin_internal_list}=	Split String	${candlepin_internal_list}	,
	@{verbose_name_candlepin_internal_list}=	Split String	${verbose_name_candlepin_internal_list}	,
	
    Click Button		xpath=//div[@id='search']/div/div[1]/div/div/div[2]/div/button
    Table Header Check 		@{verbose_name_list}
    Click Link		Candlepin internals
    Table Header Check 		@{verbose_name_candlepin_internal_list}
    Click Link		Verbose names
    Table Header Check 		@{candlepin_internal_list}
    ${RETURN}=		Get Table Cell		xpath=//table[@id="DataTables_Table_0"]		1		1 
    Should Be Equal     ${RETURN}    id

View Search result with Columns    
    [Documentation] 
    [Tags]     regression	
    Maximize Browser Window
    Go to Front Page
    Click Link		Search SKU Catalog
    Click Link		Search
    Page should contain   Search results
    Select From List By Value		xpath=//form[@id='search_basic_form']/div/select[@id='ph_product_name']		Academic
    Click Element  xpath=//form[@id='search_basic_form']/div/div/button[@id='submit']
    Wait Until Page Contains Element	xpath=//table[@id="DataTables_Table_0"]
    sleep 	10   
    
	@{verbose_name_list}=	Split String	${verbose_name_list}	,
	@{candlepin_internal_list}=	Split String	${candlepin_internal_list}	,
	@{verbose_name_candlepin_internal_list}=	Split String	${verbose_name_candlepin_internal_list}	,
	@{range}=		Evaluate	range(1, 30)

	# With Label Verbose names
    Click Button		xpath=//*[@id='search']/div/div[1]/div/div/div[2]/div[2]/button
    Click Link			Hide all
    ${RETURN}=		Get Table Cell		xpath=//table[@id="DataTables_Table_0"]		1		-1
    Should Be Equal     ${RETURN}    SKU Name
    :For	${i}	IN		@{range}
	\		${value}=	Strip String	@{verbose_name_list}[${i}]
	\		${j}=	Evaluate	${i}+3	
	\		${xpath}=	Catenate	//*[@id='search']/div/div[1]/div/div/div[2]/div[2]/ul/li[${j}]/a/span[1]
	\		Check Table Header Column Title		${xpath}	${value}
		
	# With Label Candlepin internals
    Click Button		xpath=//div[@id='search']/div/div[1]/div/div/div[2]/div/button
    Click Link		Candlepin internals
    Click Link		Verbose names
    Click Button		xpath=//*[@id='search']/div/div[1]/div/div/div[2]/div[2]/button
    Click Link			Hide all
    ${RETURN}=		Get Table Cell		xpath=//table[@id="DataTables_Table_0"]		1		-1
    Should Be Equal     ${RETURN}    id
	:For	${i}	IN		@{range}
	\		${value}=	Strip String	@{candlepin_internal_list}[${i}]
	\		${j}=	Evaluate	${i}+3	
	\		${xpath}=	Catenate	//*[@id='search']/div/div[1]/div/div/div[2]/div[2]/ul/li[${j}]/a/span[2]
	\		Check Table Header Column Title		${xpath}	${value}

	# With Labels Verbose names and Candlepin internals
    Click Button		xpath=//div[@id='search']/div/div[1]/div/div/div[2]/div/button
    Click Link		Verbose names
    Click Button		xpath=//*[@id='search']/div/div[1]/div/div/div[2]/div[2]/button
    Click Link			Hide all
    ${RETURN}=		Get Table Cell		xpath=//table[@id="DataTables_Table_0"]		1		-1
    Should Be Equal     ${RETURN}    SKU Name\nid
	:For	${i}	IN		@{range}
	\		${value}=	Strip String	@{verbose_name_candlepin_internal_list}[${i}]
	\		${j}=	Evaluate	${i}+3	
	\		${xpath}=	Catenate	//*[@id='search']/div/div[1]/div/div/div[2]/div[2]/ul/li[${j}]/a/span[1]
	\		Check Table Header Column Title		${xpath}	${value}
 
View Search result with Columns 2
 	[Documentation] 
	[Tags]     regression
 
Advanced Search - check url location
    [Documentation] 
	[Tags]     regression
	Open Account Test Page		Add Subscriptions
    Page should contain   Add subscriptions
	${location}=	Get location
	
Advanced Search - check required field
    [Documentation] 
	[Tags]     regression	

Advanced Search - check input default info
	[Documentation] 
	[Tags]     regression

Advanced Search - check help info
	[Documentation] 
	[Tags]     regression
        
Advanced Search with SKU Name equals
	[Documentation] 
    [Tags]     regression
    Maximize Browser Window
    Go to Front Page
    Click Link		Search SKU Catalog
    Click Link		Advanced search
    Page should contain   Search results
    Input Text     xpath=//form[@id='search_advanced_form']/div/div/input[@name='0_data_string']		RH0103708
    Click Element  xpath=//form[@id='search_advanced_form']/div/div/button[@id='submit']
    ${SUCCESS_MESSAGE}=	Set Variable	Searching for suitable results...
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    ${SUCCESS_MESSAGE}=	Set Variable	Searching the database
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    Wait Until Page Contains Element	xpath=//table[@id="DataTables_Table_0"]
    sleep 	10
    #Table Header Should Contain		xpath=//table[@id="DataTables_Table_0"]		Product Hierarchy: Product Category
    Table Header Check		${verbose_name_list}
    Table Column Should Contain		xpath=//table[@id="DataTables_Table_0"]		1		RH0103708
     	
Advanced Search with SKU Name contains
    [Documentation] 
	[Tags]     regression
    Maximize Browser Window
    Go to Front Page
    Click Link		Search SKU Catalog
    Click Link		Advanced search
    Page should contain   Search results
    Click Button		xpath=//form[@id='search_advanced_form']/div/div/div[2]/button
    Click Link			contains
    #Click Element		link=SKU Name
    Input Text     xpath=//form[@id='search_advanced_form']/div/div/input[@name='0_data_string']		RH01037
    Click Element  xpath=//form[@id='search_advanced_form']/div/div/button[@id='submit']
    ${SUCCESS_MESSAGE}=	Set Variable	Searching for suitable results...
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    ${SUCCESS_MESSAGE}=	Set Variable	Searching the database
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    Wait Until Page Contains Element	xpath=//table[@id="DataTables_Table_0"]
    sleep 	20
    #Table Header Should Contain		xpath=//table[@id="DataTables_Table_0"]		Product Hierarchy: Product Category
    Table Header Check		${verbose_name_list}
    Table Column Should Contain		xpath=//table[@id="DataTables_Table_0"]		1		RH0103708

Advanced Search with SKU Name does not contain
    [Documentation] 
	[Tags]     regression
	Maximize Browser Window
    Go to Front Page
    Click Link		Search SKU Catalog
    Click Link		Advanced search
    Page should contain   Search results
    Click Button		xpath=//form[@id='search_advanced_form']/div/div/div[2]/button
    Click Link			does not contain
    #Click Element		link=SKU Name
    Input Text     xpath=//form[@id='search_advanced_form']/div/div/input[@name='0_data_string']		RH01037
    Click Element  xpath=//form[@id='search_advanced_form']/div/div/button[@id='submit']
    ${SUCCESS_MESSAGE}=	Set Variable	Searching for suitable results...
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    ${SUCCESS_MESSAGE}=	Set Variable	Searching the database
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    Wait Until Page Contains Element	xpath=//table[@id="DataTables_Table_0"]
    sleep 	20
    #Table Header Should Contain		xpath=//table[@id="DataTables_Table_0"]		Product Hierarchy: Product Category
    Table Header Check		${verbose_name_list}
    Table Column Should Contain		xpath=//table[@id="DataTables_Table_0"]		2		Subscriptions

Advanced Search with Arch contains
	[Documentation] 
    [Tags]     regression
    Maximize Browser Window
    Go to Front Page
    Click Link		Search SKU Catalog
    Click Link		Advanced search
    Page should contain   Search results
    Click Button		xpath=//form[@id='search_advanced_form']/div/div/div/button
    Click Link			Arch
    Click Button		xpath=//form[@id='search_advanced_form']/div/div/div[2]/button
    Click Link			contains
    Input Text     xpath=//form[@id='search_advanced_form']/div/div/input[@name='0_data_string']		x86_64
    Click Element  xpath=//form[@id='search_advanced_form']/div/div/button[@id='submit']
    ${SUCCESS_MESSAGE}=	Set Variable	Searching for suitable results...
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    ${SUCCESS_MESSAGE}=	Set Variable	Searching the database
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    Wait Until Page Contains Element	xpath=//table[@id="DataTables_Table_0"]
    #Wait Until Page Does Not Contain	Searching for suitable results...		timeout=50
    sleep 	20
    #Table Header Should Contain		xpath=//table[@id="DataTables_Table_0"]		Product Hierarchy: Product Category
    Table Header Check		${verbose_name_list}
    Table Should Contain		xpath=//table[@id="DataTables_Table_0"]		x86_64
 
Advanced Search - Test comovement relation
	[Documentation] 
    [Tags]     regression 

Advanced Search - add or delete one filter
	[Documentation] 
    [Tags]     regression
        
Advanced Search - Test 2 filters
	[Documentation] 
    [Tags]     regression
	
Advanced Search - Test 3 filters
	[Documentation] 
    [Tags]     regression

Advanced Search - Test 4 filters
	[Documentation] 
    [Tags]     regression
	
Advanced Search - Test 5 filters
	[Documentation] 
    [Tags]     regression



Advanced Search with SKU Name
	[Documentation] 
    [Tags]     regression
    
    
Advanced Search with Arch
	[Documentation] 
    [Tags]     regression
    
    
Advanced Search with Eng Products
	[Documentation] 
    [Tags]     regression
    
    
Advanced Search with Several Eng PIDs
	[Documentation] 
    [Tags]     regression
    
    
Advanced Search with String attribute - equals
	[Documentation] 
    [Tags]     regression
    
    
Advanced Search with String attribute - contains
	[Documentation] 
    [Tags]     regression
    
Advanced Search with String attribute - does not contain
	[Documentation] 
    [Tags]     regression
    
Advanced Search with String attribute - empty or not applicable
	[Documentation] 
    [Tags]     regression
    
Advanced Search with String attribute - applicable
	[Documentation] 
    [Tags]     regression
    
    
Advanced Search with Integer attribute - equals n/a
	[Documentation] 
    [Tags]     regression
    
    
Advanced Search with Integer attribute - equals unlimited
	[Documentation] 
    [Tags]     regression
    
    
Advanced Search with Integer attribute - equals a integer number
	[Documentation] 
    [Tags]     regression
    
    
Advanced Search with Integer attribute - does not equal
	[Documentation] 
    [Tags]     regression
    
    
Advanced Search with Integer attribute - greater than
	[Documentation] 
    [Tags]     regression
    
Advanced Search with Integer attribute - less then
	[Documentation] 
    [Tags]     regression
    
Advanced Search with Integer attribute - empty or not applicable
	[Documentation] 
    [Tags]     regression
    
Advanced Search with Integer attribute - applicable
	[Documentation] 
    [Tags]     regression
    
Advanced Search with Integer attribute - unlimited
	[Documentation] 
    [Tags]     regression
    
Advanced Search with Integer attribute - does not equal unlimited
	[Documentation] 
    [Tags]     regression
    
Advanced Search with Integer attribute - does not equal n/a
	[Documentation] 
    [Tags]     regression
    
Advanced Search with Integer attribute - less then n/a
	[Documentation] 
    [Tags]     regression
    
Advanced Search with Integer attribute - less then unlimited
	[Documentation] 
    [Tags]     regression
    
Advanced Search with Integer attribute - greater than n/a
	[Documentation] 
    [Tags]     regression
    
Advanced Search with Integer attribute - greater than unlimited
	[Documentation] 
    [Tags]     regression
    
Advanced Search with Boolean attribute - equals 1
	[Documentation] 
    [Tags]     regression
    
Advanced Search with Boolean attribute - equals 0
	[Documentation] 
    [Tags]     regression
    
Advanced Search with Boolean attribute - equals 8000
	[Documentation] 
    [Tags]     regression
    
Advanced Search with Boolean attribute - equals 
	[Documentation] 
    [Tags]     regression

Advanced Search with Arch equals invalid arch(auch as xx888)
	[Documentation] 
    [Tags]     regression
    
Advanced Search with String attribute is equals and does not equal
	[Documentation] 
    [Tags]     regression
    
Advanced Search with String attribute is applicable and empty or not applicable
	[Documentation] 
    [Tags]     regression
    
Advanced Search with Integer attribute is equals and does not equal
	[Documentation] 
    [Tags]     regression
    
Advanced Search with Integer attribute is applicable and empty or not applicable
	[Documentation] 
    [Tags]     regression
    
Advanced Search with Integer attribute is less than and greater than one same number
	[Documentation] 
    [Tags]     regression
    
Advanced Search with Boolean attribute is False and True(such as, Virt-only is False and Virt-only is True) 
	[Documentation] 
    [Tags]     regression
    
*** Keywords ***
Open Search Test Page
    [Documentation]
	[Arguments]   ${TEST_PAGE}
	Maximize Browser Window
    Go to Front Page
    Wait Until Page Contains Element   link=${TEST_PAGE}
    Click Link       ${TEST_PAGE}
    
Table Header Check
	[Documentation]
	[Arguments]   ${header_list}
	#@{header_list} 	Evaluate	${header_list}.split(",")
	@{header_list}=	Split String	${header_list}	,
	:FOR	${i} 	IN		@{header_list}
	\	${i}=	Strip String	${i}
	\	Table Header Should Contain		xpath=//table[@id="DataTables_Table_0"]		${i}

Check Table Header Column Title
	[Documentation]
	[Arguments]   ${xpath}	${value}
	Click Element		xpath=${xpath}
    ${RETURN}=		Get Table Cell		xpath=//table[@id="DataTables_Table_0"]		1		-1
    Should Be Equal		${RETURN}    ${value}	