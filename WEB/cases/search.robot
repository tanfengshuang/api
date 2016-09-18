*** Settings ***
Documentation	How to manage accounts using account management tool
Resource		../resources/global.robot
Suite Setup		Suite Setup Steps
Test Setup		Test Setup Steps
Test Teardown	Test Teardown Steps
Suite Teardown	Suite Teardown Steps


*** Variables ***


*** Test Cases ***
Search - verify url location
    [Documentation] 
	[Tags]	regression
    # Verify URL
    Location Should Be	${SEARCH_PAGE}
	
Search - verify input default info
	[Documentation] 
	[Tags]	regression
	# Select SKU, and then Verify the sku input default info
    Click Button		xpath=${Search_Criterion_Link}
    Click Link		SKU
    ${INFO}=	Get Element Attribute	id@placeholder
	Should Be Equal		${INFO}		SKU identifier

Search - verify help info
	[Documentation] 
	[Tags]	regression
    # Verify help info
	Page should contain	You need to search the SKU database first. To do so, use the form above.
	Page should contain	NOTE:All SKUs listed here are available on Stage Candlepin. This tool is not suitable for Production Candlepin lookups. 

Search by Product Hierarchy: Product Name with ALL Product
    [Documentation] 
    [Tags]	regression    
    # Search with default info - Product Hierarchy: Product Name, ALL Product
    Click Element  xpath=${Search_Submit_Link}
    
    
    # Verify floating prompts during searching
    ${SUCCESS_MESSAGE}=	Set Variable	Searching for suitable results...
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    ${SUCCESS_MESSAGE}=	Set Variable	Searching the database...
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
     
    # Waiting table is visible and check search result
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    Table Header Check		${verbose_name_list}
    ${length}=	Get Total Number of Table Items
    Should Be True		${length} > 10000	

Search by Product Hierarchy: Product Name with Academic
    [Documentation] 
    [Tags]	regression
    # Select Product name by Index(2) or Value(Academic)
    ${product_name}=	Set Variable	Academic
    #Select From List By Index		xpath=${Search_ProuductNameSelect_Link}		2
    Select From List By Value		xpath=${Search_ProuductNameSelect_Link}		${product_name}
    Click Element  xpath=${Search_Submit_Link}
    
    # Verify floating prompts during searching
    ${SUCCESS_MESSAGE}=	Set Variable	Searching for suitable results...
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    ${SUCCESS_MESSAGE}=	Set Variable	Searching the database...
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    
    # Waiting until table is visible and Verify search result
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    Table Header Check		${verbose_name_list}
    ${length}=	Get Total Number of Table Items
	${page_number}=	Get Text	xpath=${Search_TablePageNumber_Link}
	${page_rest}=		Set Variable	${length}%20
	:For	${page}	in range	${page_number}
	\	Exit For Loop If	${page_number} == 1
	\	Loop Table To Verify Equal	20	${Table_ProductHierarchyProductName_ColumnNumber}	${product_name}
	
	Loop Table To Verify Equal	${page_rest}	${Table_ProductHierarchyProductName_ColumnNumber}	${product_name}  

Search by SKU with nothing
    [Documentation] 
    [Tags]	regression    
    # Select search criterion - sku, and search
    Click Button		xpath=${Search_Criterion_Link}
    Click Link		SKU
    Click Element  xpath=${Search_Submit_Link}
       
    # Verify floating prompts during searching 
    ${SUCCESS_MESSAGE}=	Set Variable	Searching for suitable results...
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    ${SUCCESS_MESSAGE}=	Set Variable	Searching the database...
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    
    # Waiting until table is visible and Verify search result
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    Table Header Check		${verbose_name_list}
    ${length}=	Get Total Number of Table Items
    Should Be True		${length} > 10000

Search by SKU with existing sku
    [Documentation] 
    [Tags]	regression
	# Select search criterion - sku, and search   
    Click Button		xpath=${Search_Criterion_Link}
    Click Link		SKU
    Input Text     xpath=${Search_SKUInput_Link}		${SKU} 
    Click Element  xpath=${Search_Submit_Link}
    
    # Verify floating prompts during searching
    ${SUCCESS_MESSAGE}=	Set Variable	Searching for suitable results...
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    ${SUCCESS_MESSAGE}=	Set Variable	Searching the database...
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    
    # Waiting until table is visible and Verify search result
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    Table Header Check		${verbose_name_list}
    ${length}=	Get Total Number of Table Items
    ${page_number}=	Get Text	xpath=${Search_TablePageNumber_Link}
	${page_rest}=		Set Variable	${length}%20
	:For	${page}	in range	${page_number}
	\	Exit For Loop If	${page_number} == 1
	\	Loop Table To Verify Contain		20	${Table_SKUName_ColumnNumber}	${SKU}
	Loop Table To Verify Contain		${page_rest}	${Table_SKUName_ColumnNumber}	${SKU}   	
    
Search by SKU with invalid sku
    [Documentation] 
    [Tags]	regression
    # Select search criterion - sku, and search   
    Click Button		xpath=${Search_Criterion_Link}
    Click Link		SKU
    Input Text     xpath=${Search_SKUInput_Link}		${INVALID_SKU} 
    Click Element  xpath=${Search_Submit_Link}
    
    # Verify floating prompts during searching
    ${SUCCESS_MESSAGE}=	Set Variable	Searching for suitable results...
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    ${SUCCESS_MESSAGE}=	Set Variable	Searching the database...
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    
    # Waiting until table is visible and Verify search result
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    Table Header Check		${verbose_name_list}
    Table Column Should Contain			xpath=${Search_Table_Link}		1		No data available in table
    
View Search result with Labels
    [Documentation] 
    [Tags]	regression	
	# Select prouct name, then search with this specified product name
	${product_name}=	Set Variable	Academic
    Select From List By Value		xpath=${Search_ProuductNameSelect_Link}		${product_name}
    Click Element  xpath=${Search_Submit_Link}
    
    # Wait a momment to display table items
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
   
	# Verify table header before click 'Lables' button - only verbose name
	Table Header Check 		${verbose_name_list}
    
    # Check 'Candlepin internals', and then verify table header for verbose name and candlepin internals
    Click Button		xpath=${Search_TableLabels_Link}
    Click Link		Candlepin internals
    Table Header Check 		${verbose_name_candlepin_internal_list}
    
    # Uncheck 'Verbose names', and then verify table header only for candlepin internals
    Click Link		Verbose names
    Table Header Check 		${candlepin_internal_list}
    ${RETURN}=		Get Table Cell		xpath=${Search_Table_Link}		1		1 
    Should Be Equal     ${RETURN}    id

View Search result with Columns    
    [Documentation] 
    [Tags]	regression	
    # Select prouct name, then search with this specified product name
	${product_name}=	Set Variable	Academic
    Select From List By Value		xpath=${Search_ProuductNameSelect_Link}		${product_name}
    Click Element  xpath=${Search_Submit_Link}
    
    # Wait a momment to display table items
    Wait Until Page Contains Element	xpath=${Search_Table_Link}
    sleep 	10   
    
	@{verbose_name_list}=	Split String	${verbose_name_list}	,
	@{candlepin_internal_list}=	Split String	${candlepin_internal_list}	,
	@{verbose_name_candlepin_internal_list}=	Split String	${verbose_name_candlepin_internal_list}	,
	@{range}=		Evaluate	range(1, 30)

	# Hide all columns first - only with Label Verbose names
    Click Button		xpath=${Search_TableColumns_Link}
    Click Link			Hide all
    # Verify SKU Name header
    ${RETURN}=		Get Table Cell		xpath=${Search_Table_Link}		1		-1
    Should Be Equal     ${RETURN}    SKU Name
    # Show columns one by one, and verify headers
    :For	${i}	IN		@{range}
	\		${value}=	Strip String	@{verbose_name_list}[${i}]
	\		${j}=	Evaluate	${i}+3	
	\		${xpath}=	Catenate	//*[@id='search']/div/div[1]/div/div/div[2]/div[2]/ul/li[${j}]/a/span[1]
	\		Verify Table Header Column Title		${xpath}	${value}

	#${Search_TableLabels_Link}						//*[@id='search']/div/div[1]/div/div/div[2]/div[1]/button
	#${Search_TableColumns_Link}						//*[@id='search']/div/div[1]/div/div/div[2]/div[2]/button
	
	# Check 'Candlepin internals', uncheck 'Verbose names'
    Click Button		xpath=${Search_TableLabels_Link}
    Click Link		Candlepin internals
    Click Link		Verbose names
    # Hide all columns first - only with Label Candlepin internals
    Click Button		xpath=${Search_TableColumns_Link}
    Click Link			Hide all
    # Verify SKU Name header
    ${RETURN}=		Get Table Cell		xpath=${Search_Table_Link}		1		-1
    Should Be Equal     ${RETURN}    id
    # Show columns one by one, and verify headers
	:For	${i}	IN		@{range}
	\		${value}=	Strip String	@{candlepin_internal_list}[${i}]
	\		${j}=	Evaluate	${i}+3	
	\		${xpath}=	Catenate	//*[@id='search']/div/div[1]/div/div/div[2]/div[2]/ul/li[${j}]/a/span[2]
	\		Verify Table Header Column Title		${xpath}	${value}
	
	# Uncheck 'Verbose names'
    Click Button		xpath=${Search_TableLabels_Link}
    Click Link		Verbose names
    # Hide all columns first - with Labels Verbose names and Candlepin internals
    Click Button		xpath=${Search_TableColumns_Link}
    Click Link			Hide all
    # Verify SKU Name header
    ${RETURN}=		Get Table Cell		xpath=${Search_Table_Link}		1		-1
    Should Be Equal     ${RETURN}    SKU Name\nid
    # Show columns one by one, and verify headers
	:For	${i}	IN		@{range}
	\		${value}=	Strip String	@{verbose_name_candlepin_internal_list}[${i}]
	\		${j}=	Evaluate	${i}+3	
	\		${xpath}=	Catenate	//*[@id='search']/div/div[1]/div/div/div[2]/div[2]/ul/li[${j}]/a/span[1]
	\		Verify Table Header Column Title		${xpath}	${value}
 
View Search result with Columns 2
 	[Documentation] 
	[Tags]	regression
	Log	Waiting
    
*** Keywords ***
Suite Setup Steps
	Log	Suite Begin...
	Open Browser  ${FRONT_PAGE}   ${BROWSER}
	Maximize Browser Window

Test Setup Steps
	Log	Suite Begin...
	Go to Front Page
    Click Link	Search SKU Catalog
    Click Link	Search
    Page should contain	Search results
    Capture Page Screenshot

Test Teardown Steps
	Capture Page Screenshot
	Log	Testing End...

Suite TearDown Steps
	Close All Browsers
	Log	Suite End...