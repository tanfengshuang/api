*** Settings ***
Documentation	How to manage accounts using account management tool
Resource	../resources/global.robot
Suite Setup	Suite Setup Steps
Test Setup	Test Setup Steps
Test Teardown	Test Teardown Steps
Suite Teardown	Suite Teardown Steps

*** Variables ***

*** Test Cases ***
Advanced Search - verify url location
    [Documentation]
    ...	Verify url location after open Advanced Search Page
	[Tags]	regression
    Location Should Be	${ADVANCED_SEARCH_PAGE}

Advanced Search - verify input value type and required field for integer attribute
    [Documentation]
    ...	Verify input value type(type="number") and required field(required="") for integer attribute
    ...	HTML:
    ...	<input class="form-control apply_to_datatype_int" type="number" value="" name="0_data_int" required=""/>
    [Tags]	regression
    # Select one integer attribute - Virt Limit
	Log	Select one integer attribute Virt Limit
    Click Button	xpath=${AdvancedSearch_Attribute_Link}
    Click Element	link=Virt Limit
    
    # Verify input value type for equals
    Log	Verify input value type for equals
    Click Element	xpath=${AdvancedSearch_IntegerAttributeOperator_Link}
	Click Element	link=equals
	${type_value}=	Get Element Attribute	${AdvancedSearch_IntegerAttributeInput_Link}@type
	Should Be Equal	${type_value}	number
	${REQUIRED}=	Get Element Attribute	${AdvancedSearch_IntegerAttributeInput_Link}@required
	Should Be Equal	${REQUIRED}	true
	
	# Verify input value type for does not equal
	Log	Verify input value type for does not equal
	Click Element	xpath=${AdvancedSearch_IntegerAttributeOperator_Link}
	Click Element	link=does not equal
	${type_value}=	Get Element Attribute	${AdvancedSearch_IntegerAttributeInput_Link}@type
	Should Be Equal	${type_value}	number
	${REQUIRED}=	Get Element Attribute	${AdvancedSearch_IntegerAttributeInput_Link}@required
	Should Be Equal	${REQUIRED}	true
	
	# Verify input value type for greater than
	Log	Verify input value type for greater than
	Click Element	xpath=${AdvancedSearch_IntegerAttributeOperator_Link}
	Click Element	link=greater than
	${type_value}=	Get Element Attribute	${AdvancedSearch_IntegerAttributeInput_Link}@type
	Should Be Equal	${type_value}	number
	${REQUIRED}=	Get Element Attribute	${AdvancedSearch_IntegerAttributeInput_Link}@required
	Should Be Equal	${REQUIRED}	true
	
	# Verify input value type for less then
	Log	Verify input value type for less then
	Click Element	xpath=${AdvancedSearch_IntegerAttributeOperator_Link}
	Click Element	link=less then
	${type_value}=	Get Element Attribute	${AdvancedSearch_IntegerAttributeInput_Link}@type
	Should Be Equal	${type_value}	number
	${REQUIRED}=	Get Element Attribute	${AdvancedSearch_IntegerAttributeInput_Link}@required
	Should Be Equal	${REQUIRED}	true
    
Advanced Search - verify input value type and required field for string attribute
    [Documentation]
    ...	Verify input value type(type="text") and required field(required="") for string attribute
    ...	HTML:
    ...	<input class="form-control apply_to_datatype_string" type="text" value="" name="0_data_string" required=""/>
    [Tags]   regression
	# Use the default string attribute SKU Name to do testing, so do nothing here
	Log	Use the default string attribute SKU Name to do testing
	
	# Verify input value type for equals
    Log	Verify input value type for equals
    Click Element	xpath=${AdvancedSearch_StringAttributeOperator_Link}
	Click Element	link=equals
	${type_value}=	Get Element Attribute	${AdvancedSearch_StringAttributeInput_Link}@type
	Should Be Equal	${type_value}	text
	${REQUIRED}=	Get Element Attribute	${AdvancedSearch_StringAttributeInput_Link}@required
	Should Be Equal	${REQUIRED}	true
	
	# Verify input value type for contains
	Log	Verify input value type for contains
	Click Element	xpath=${AdvancedSearch_StringAttributeOperator_Link}
	Click Element	link=contains
	${type_value}=	Get Element Attribute	${AdvancedSearch_StringAttributeInput_Link}@type
	Should Be Equal	${type_value}	text
	${REQUIRED}=	Get Element Attribute	${AdvancedSearch_StringAttributeInput_Link}@required
	Should Be Equal	${REQUIRED}	true
	
	# Verify input value type for does not contain
	Log	Verify input value type for does not contain
	Click Element	xpath=${AdvancedSearch_StringAttributeOperator_Link}
	Click Element	link=does not contain
	${type_value}=	Get Element Attribute	${AdvancedSearch_StringAttributeInput_Link}@type
	Should Be Equal	${type_value}	text   
	${REQUIRED}=	Get Element Attribute	${AdvancedSearch_StringAttributeInput_Link}@required
	Should Be Equal	${REQUIRED}	true

Advanced Search - verify help info
	[Documentation] 
	...	Verify help infomation listed on Advanced Search Page
	[Tags]	regression
	Page should contain	You need to search the SKU database first. To do so, use the form above.
	Page should contain	NOTE:All SKUs listed here are available on Stage Candlepin. This tool is not suitable for Production Candlepin lookups. 
        
Advanced Search with SKU Name equals
	[Documentation] 
	...	Do advanced search with SKU Name equals sth
    [Tags]	regression
    # Do advanced search with default attribute 'SKU Name', defualt operator 'equals' 
    Input Text	xpath=${AdvancedSearch_StringAttributeInput_Link}	${SKU}
    Click Element	xpath=${AdvancedSearch_Submit_Link}
    
    # Verify floating prompts during searching
    ${SUCCESS_MESSAGE}=	Set Variable	Searching for suitable results...
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    ${SUCCESS_MESSAGE}=	Set Variable	Searching the database...
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    # Verify search result
    Log	Verify search result
    Table Header Check	${verbose_name_list}
    ${length}=	Get Total Number of Table Items
    Should Be Equal	${length}	1
    ${cell_content}=	Get Table Cell	xpath=${Search_Table_Link}	2	1
    Should Be Equal	${cell_content}	${SKU}
     	
Advanced Search with SKU Name contains
    [Documentation]
    ...	Do advanced search with SKU Name contains sth
	[Tags]	regression 
	# Do advanced search with default attribute 'SKU Name', operator 'contains'   
	Log	Do advanced search with default attribute 'SKU Name', operator 'contains'
    Click Button	xpath=${AdvancedSearch_StringAttributeOperator_Link}
    Click Link		contains
    Input Text     xpath=${AdvancedSearch_StringAttributeInput_Link}	${SKU}
    Click Element  xpath=${AdvancedSearch_Submit_Link}
    
    # Verify floating prompts during searching
    Log	Verify floating prompts during searching
    ${SUCCESS_MESSAGE}=	Set Variable	Searching for suitable results...
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    ${SUCCESS_MESSAGE}=	Set Variable	Searching the database...
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    # Verify search result
    Log	Verify search result
    Table Header Check	${verbose_name_list}
    ${length}=	Get Total Number of Table Items
    ${page_number}=	Get Text	xpath=${Search_TablePageNumber_Link}
	${page_rest}=	Set Variable	${length}%20
	:For	${page}	in range	${page_number}
	\	Exit For Loop If	${page_number} == 1
	\	Loop Table To Verify Contain	20	${Table_SKUName_ColumnNumber}	${SKU}
	Loop Table To Verify Contain	${page_rest}	${Table_SKUName_ColumnNumber}	${SKU} 

Advanced Search with SKU Name does not contain
    [Documentation] 
    ...	Do advanced search with SKU Name does not contain sth
	[Tags]	regression
	# Do advanced search with default attribute 'SKU Name', operator 'does not contain'   
	Log	Do advanced search with default attribute 'SKU Name', operator 'does not contain'
    Click Button	xpath=${AdvancedSearch_StringAttributeOperator_Link}
    Click Link	does not contain
    Input Text	xpath=${AdvancedSearch_StringAttributeInput_Link}	${SKU}
    Click Element	xpath=${AdvancedSearch_Submit_Link}
    
    # Verify floating prompts during searching
    Log	Verify floating prompts during searching
    ${SUCCESS_MESSAGE}=	Set Variable	Searching for suitable results...
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    ${SUCCESS_MESSAGE}=	Set Variable	Searching the database...
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}

	# Verify search result
	Log	Verify search result
    Table Header Check	${verbose_name_list}
    ${length}=	Get Total Number of Table Items
    ${page_number}=	Get Text	xpath=${Search_TablePageNumber_Link}
	${page_rest}=	Set Variable	${length}%20
	:For	${page}	in range	${page_number}
	\	Exit For Loop If	${page_number} == 1
	\	Loop Table To Verify Not Contain	20	${Table_SKUName_ColumnNumber}	${SKU}
	Loop Table To Verify Not Contain	${page_rest}	${Table_SKUName_ColumnNumber}	${SKU} 
    
Advanced Search with SKU Name is empty or not applicable
    [Documentation]
    ...	Do advanced search with SKU Name is empty or not applicable
    [Tags]   regression
    # SKU Name is empty or not applicable - key=id    operator=empty or not applicable
    Log	SKU Name is empty or not applicable 
	Click Element	xpath=${AdvancedSearch_StringAttributeOperator_Link}
	Click Element	link=empty or not applicable
	Log	Submit
    Click Element  xpath=${AdvancedSearch_Submit_Link}
    
	# Keep waiting util search result table is visible
	Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}    

	# Verify search result
    Log	Verify search result
    Table Header Check	${verbose_name_list}
	Table Column Should Contain		xpath=${Search_Table_Link}	1	No data available in table

Advanced Search with SKU Name is applicable
    [Documentation]
    ...	Do advanced search with SKU Name is empty or not applicable
    [Tags]	regression    
    # Do advanced search with SKU Name applicable - key=id    operator=applicable
    Log	Do advanced search with SKU Name applicable
    Click Element	xpath=${AdvancedSearch_StringAttributeOperator_Link}
	Click Element	link=applicable
	Log	Submit
    Click Element  xpath=${AdvancedSearch_Submit_Link}
    
	# Keep waiting util search result table is visible
	Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}    

	# Verify search result
    Log	Verify search result
    ${length}=	Get Total Number of Table Items
	${page_number}=	Get Text	xpath=${Search_TablePageNumber_Link}
	${page_rest}=	Set Variable	${length}%20
	:For	${page}	in range	${page_number}
	\	Exit For Loop If	${page_number} == 1
	\	Loop Table To Verify Not Contain	20	${Table_SKUName_ColumnNumber}	n/a

	Loop Table To Verify Not Contain	${page_rest}	${Table_SKUName_ColumnNumber}	n/a

Advanced Search with Arch contains
	[Documentation] 
	...	Do advanced search with Arch contains sth
    [Tags]	regression
    # Do advanced search with default attribute 'SKU Name', operator 'does not contain'  
    Log	Do advanced search with default attribute 'SKU Name', operator 'does not contain'
    Click Button	xpath=${AdvancedSearch_Attribute_Link}
    Click Link		Arch
    Click Button	xpath=${AdvancedSearch_StringAttributeOperator_Link}
    Click Link		contains
    Input Text     xpath=${AdvancedSearch_StringAttributeInput_Link}	x86_64
    Click Element  xpath=${AdvancedSearch_Submit_Link}
    
    # Verify floating prompts during searching
    Log	Verify floating prompts during searching
    ${SUCCESS_MESSAGE}=	Set Variable	Searching for suitable results...
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    ${SUCCESS_MESSAGE}=	Set Variable	Searching the database...
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    # Verify search result
    Log	Verify search result
    Table Header Check	${verbose_name_list}
    ${length}=	Get Total Number of Table Items
    ${page_number}=	Get Text	xpath=${Search_TablePageNumber_Link}
	${page_rest}=	Set Variable	${length}%20
	:For	${page}	in range	${page_number}
	\	Exit For Loop If	${page_number} == 1
	\	Loop Table To Verify Contain	20	${Table_Arch_ColumnNumber}	x86_64
	Loop Table To Verify Contain	${page_rest}	${Table_Arch_ColumnNumber}	x86_64
 
Advanced Search - Test comovement relation for String attribute
	[Documentation] 
	...	Test comovement relation for String attribute
	...	Operators:
	...	equals
    ...	contains
    ...	does not contain
    ...	empty or not applicable
    ...	applicable
    [Tags]	regression 
    # Select string attribute 'Arch'
    Log	Select String attribute 'Arch'
    Click Button	xpath=${AdvancedSearch_Attribute_Link}
    Click Link		Arch
    Click Button	xpath=${AdvancedSearch_StringAttributeOperator_Link}	
    
    # Veriy related operators for String attribute
    Log	Veriy related operators for String attribute
    Page Should Contain Element	link=equals
    Page Should Contain Element	link=contains
    Page Should Contain Element	link=does not contain
    Page Should Contain Element	link=empty or not applicable
    Page Should Contain Element	link=applicable

Advanced Search - Test comovement relation for Boolean attribute
	[Documentation] 
	...	Test comovement relation for Boolean attribute
	...	Operators:
	...	equals
    [Tags]	regression  
	# Select Boolean attribute 'Virt-only', click True/False, and then verify result
	Log	Select Boolean attribute 'Virt-only', click True/False, and then verify result
    Click Button	xpath=${AdvancedSearch_Attribute_Link}
    Click Link		Virt-only
    Page Should Contain	True
    Click Element	xpath=${AdvancedSearch_BooleanTrue_Link}
    Page Should Contain	False

Advanced Search - Test comovement relation for Integer attribute
	[Documentation] 
	...	Test comovement relation for Integer attribute
	...	Operators:
    ...	equals 	
    ...	does not equal
    ...	greater than
    ...	less then
    ...	empty or not applicable
    ...	applicable
    ...	unlimited 
    [Tags]	regression 
    # Select Integer attribute 'Multiplier'
    Log	Select Integer attribute 'Multiplier'
    Click Button	xpath=${AdvancedSearch_Attribute_Link}
    Click Link		Multiplier
    Click Button	xpath=${AdvancedSearch_IntegerAttributeOperator_Link}
    
    # Veriy related operators for Integer attribute
    Log	Veriy related operators for Integer attribute
    Page Should Contain Element	link=equals
    Page Should Contain Element	link=does not equal
    Page Should Contain Element	link=greater than
    Page Should Contain Element	link=less then
    Page Should Contain Element	link=empty or not applicable
    Page Should Contain Element	link=applicable
    Page Should Contain Element	link=unlimited

Advanced Search - add or delete one filter
	[Documentation] 
	...	To Test add or delete one filter
    [Tags]	regression
    # Add one new filter
    Log	Add one new filter
    Click Element	link=Add another filter
    Page Should Contain Element	xpath=${AdvancedSearch_SecondFilter_Attribute_Link}
    Element Should Be Visible	xpath=${AdvancedSearch_SecondFilter_Attribute_Link}
    
    # Delete newly added filter just now
    Log	Delete newly added filter
    Click Element	xpath=${AdvancedSearch_DeleteFilter_Link}
    Page Should Not Contain Element	xpath=${AdvancedSearch_SecondFilter_Attribute_Link}
        
Advanced Search - Test 2 filters
	[Documentation] 
	...	Do advanced search with 2 filters
    [Tags]	regression
    
    # Set search filter 1 - key=id    operator=equals  value=MCT0834
    Log	Set search filter 1
    Input Text		xpath=${AdvancedSearch_StringAttributeInput_Link}	MCT0834
       
    # Set search filter 2 - key=ph_product_name    operator=equals  value=Academic 
    Log	Set search filter 2
    Click Element	link=Add another filter
    Click Button	xpath=${AdvancedSearch_SecondFilter_Attribute_Link}
    Click Element	link=Product Hierarchy: Product Name
    Input Text		xpath=${AdvancedSearch_SecondFilter_StringAttributeInput_Link}	Academic

    # Submit
    Log	Submit
    Click Element  xpath=${AdvancedSearch_Submit_Link}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    # Verify search result
    Log	Verify search result
    ${length}=	Get Total Number of Table Items
    Should Be Equal	${length}	1
    ${RETURN}=	Get Table Cell	xpath=${Search_Table_Link}	2	${Table_SKUName_ColumnNumber}
    Should Be Equal	${RETURN}    MCT0834	
	
Advanced Search - Test 3 filters
	[Documentation] 
	...	Do advanced search with 3 filters
    [Tags]	regression    
    # Set search filter 1 - key=id    operator=equals  value=MCT0834
    Log	Set search filter 1
    Input Text		xpath=${AdvancedSearch_StringAttributeInput_Link}	MCT0834
       
    # Set search filter 2 - key=ph_product_name    operator=equals  value=Academic 
    Log	Set search filter 2
    Click Element	link=Add another filter
    Click Button	xpath=${AdvancedSearch_SecondFilter_Attribute_Link}
    Click Element	link=Product Hierarchy: Product Name
    Input Text		xpath=${AdvancedSearch_SecondFilter_StringAttributeInput_Link}	Academic

	# Set search filter 3 - key=virt_limit    operator=equals  value=4
	Log	Set search filter 3
	Click Element	link=Add another filter
    Click Button	xpath=${AdvancedSearch_ThirdFilter_Attribute_Link}
    Click Element	link=Virt Limit
    Input Text		xpath=${AdvancedSearch_ThirdFilter_IntegerAttributeInput_Link}	4

    # Submit
    Log	Submit
    Click Element  xpath=${AdvancedSearch_Submit_Link}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    # Verify search result
    Log	Verify search result
    ${length}=	Get Total Number of Table Items
    Should Be Equal	${length}	1
    ${RETURN}=	Get Table Cell	xpath=${Search_Table_Link}	2	${Table_SKUName_ColumnNumber}
    Should Be Equal	${RETURN}    MCT0834
    
Advanced Search - Test 4 filters
	[Documentation] 
	...	Do advanced search with 4 filters
    [Tags]	regression
    
    # Set search filter 1 - key=id    operator=equals  value=MCT0834
    Log	Set search filter 1
    Input Text		xpath=${AdvancedSearch_StringAttributeInput_Link}	MCT0834
       
    # Set search filter 2 - key=ph_product_name    operator=equals  value=Academic 
    Log	Set search filter 2
    Click Element	link=Add another filter
    Click Button	xpath=${AdvancedSearch_SecondFilter_Attribute_Link}
    Click Element	link=Product Hierarchy: Product Name
    Input Text		xpath=${AdvancedSearch_SecondFilter_StringAttributeInput_Link}	Academic

	# Set search filter 3 - key=virt_limit    operator=equals  value=4
	Log	Set search filter 3
	Click Element	link=Add another filter
    Click Button	xpath=${AdvancedSearch_ThirdFilter_Attribute_Link}
    Click Element	link=Virt Limit
    Input Text		xpath=${AdvancedSearch_ThirdFilter_IntegerAttributeInput_Link}	4

	# Set search filter 4 - key=sockets    operator=equals  value=2
	Log	Set search filter 4
	Click Element	link=Add another filter
    Click Button	xpath=${AdvancedSearch_FourthFilter_Attribute_Link}
    Click Element	link=Socket(s)
    Input Text		xpath=${AdvancedSearch_FourthFilter_IntegerAttributeInput_Link}	2
	
    # Submit
    Log	Submit
    Click Element  xpath=${AdvancedSearch_Submit_Link}
	
	# Keep waiting util search result table is visible
	Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
	
	# Verify search result
    Log	Verify search result
    ${length}=	Get Total Number of Table Items
    Should Be Equal	${length}	1
    ${RETURN}=	Get Table Cell	xpath=${Search_Table_Link}	2	${Table_SKUName_ColumnNumber}
    Should Be Equal	${RETURN}    MCT0834
    
Advanced Search - Test 5 filters
	[Documentation] 
	...	Do advanced search with 5 filters
    [Tags]	regression
    
    # Set search filter 1 - key=id    operator=equals  value=MCT0834
    Log	Set search filter 1
    Input Text		xpath=${AdvancedSearch_StringAttributeInput_Link}	MCT0834
       
    # Set search filter 2 - key=ph_product_name    operator=equals  value=Academic 
    Log	Set search filter 2
    Click Element	link=Add another filter
    Click Button	xpath=${AdvancedSearch_SecondFilter_Attribute_Link}
    Click Element	link=Product Hierarchy: Product Name
    Input Text		xpath=${AdvancedSearch_SecondFilter_StringAttributeInput_Link}	Academic

	# Set search filter 3 - key=virt_limit    operator=equals  value=4
	Log	Set search filter 3
	Click Element	link=Add another filter
    Click Button	xpath=${AdvancedSearch_ThirdFilter_Attribute_Link}
    Click Element	link=Virt Limit
    Input Text		xpath=${AdvancedSearch_ThirdFilter_IntegerAttributeInput_Link}	4

	# Set search filter 4 - key=sockets    operator=equals  value=2
	Log	Set search filter 4
	Click Element	link=Add another filter
    Click Button	xpath=${AdvancedSearch_FourthFilter_Attribute_Link}
    Click Element	link=Socket(s)
    Input Text		xpath=${AdvancedSearch_FourthFilter_IntegerAttributeInput_Link}	2
	
	# Set search filter 5 - key=multiplier    operator=equals  value=16
	Log	Set search filter 5
	Click Element	link=Add another filter
    Click Button	xpath=${AdvancedSearch_FifthFilter_Attribute_Link}
    Click Element	link=Multiplier
    Input Text		xpath=${AdvancedSearch_FifthFilter_IntegerAttributeInput_Link}	16
    
    # Submit
    Log	Submit
    Click Element  xpath=${AdvancedSearch_Submit_Link}

	# Keep waiting util search result table is visible
	Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}

	# Verify search result
    Log	Verify search result
    ${length}=	Get Total Number of Table Items
    Should Be Equal	${length}	1
    ${RETURN}=	Get Table Cell	xpath=${Search_Table_Link}	2	${Table_SKUName_ColumnNumber}
    Should Be Equal	${RETURN}    MCT0834

Advanced Search with Eng Products equals
	[Documentation] 
    [Tags]	regression
    # Eng Products equals - key=eng_product_ids    operator=equals  value=180,240,69
    Log	 equals operator
    Click Button	xpath=${AdvancedSearch_Attribute_Link}
    Click Element	link=Eng Product ID(s)
    Input Text		xpath=${AdvancedSearch_StringAttributeInput_Link}	180,240,69
    Log	Submit
    Click Element  xpath=${AdvancedSearch_Submit_Link}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    Log	Verify search result   
    ${length}=	Get Total Number of Table Items
    ${page_number}=	Get Text	xpath=${Search_TablePageNumber_Link}
	${page_rest}=	Set Variable	${length}%20
	:For	${page}	in range	${page_number}
	\	Exit For Loop If	${page_number} == 1
	\	Loop Table To Verify Equal	20	29	180,240,69	

	Loop Table To Verify Equal	${page_rest}	29	180,240,69
 
	# Eng Products contains - key=eng_product_ids    operator=contains  value=180
	Log	contains operator
	Click Element	xpath=${AdvancedSearch_StringAttributeOperator_Link}
	Click Element	link=contains
	Input Text		xpath=${AdvancedSearch_StringAttributeInput_Link}	180
	Log	Submit
    Click Element  xpath=${AdvancedSearch_Submit_Link}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    # Verify search result
    Log	Verify search result   
    ${length}=	Get Total Number of Table Items
    ${page_number}=	Get Text	xpath=${Search_TablePageNumber_Link}
	${page_rest}=	Set Variable	${length}%20
	:For	${page}	in range	${page_number}
	\	Exit For Loop If	${page_number} == 1
	\	Loop Table To Verify Contain	20	29	180

	Loop Table To Verify Contain	${page_rest}	29	180
	
	# Eng Products does not contain - key=eng_product_ids    operator=does not contain  value=180
	Log	does not contain operator
	Click Element	xpath=${AdvancedSearch_StringAttributeOperator_Link}
	Click Element	link=does not contain
	Input Text		xpath=${AdvancedSearch_StringAttributeInput_Link}	180
	Log	Submit
    Click Element  xpath=${AdvancedSearch_Submit_Link}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
      
    Log	Verify search result
    ${length}=	Get Total Number of Table Items
    ${page_number}=	Get Text	xpath=${Search_TablePageNumber_Link}
	${page_rest}=	Set Variable	${length}%20
	:For	${page}	in range	${page_number}
	\	Exit For Loop If	${page_number} == 1
	\	Loop Table To Verify Not Contain	20	29	180

	Loop Table To Verify Not Contain	${page_rest}	29	180
	
    # Eng Products empty or not applicable - key=eng_product_ids    operator=empty or not applicable
    Log	empty or not applicable operator
    Click Element	xpath=${AdvancedSearch_StringAttributeOperator_Link}
	Click Element	link=empty or not applicable
	Log	Submit
    Click Element  xpath=${AdvancedSearch_Submit_Link}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    Log	Verify search result  
    ${length}=	Get Total Number of Table Items
    ${page_number}=	Get Text	xpath=${Search_TablePageNumber_Link}
	${page_rest}=	Set Variable	${length}%20
	:For	${page}	in range	${page_number}
	\	Exit For Loop If	${page_number} == 1
	\	Loop Table To Verify Equal	20	29	n/a

	Loop Table To Verify Equal	${page_rest}	29	n/a
    
    # Eng Products applicable - key=eng_product_ids    operator=applicable
    Log	applicable operator
    Click Element	xpath=${AdvancedSearch_StringAttributeOperator_Link}
	Click Element	link=empty or not applicable
	Log	Submit
    Click Element  xpath=${AdvancedSearch_Submit_Link}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    Log	Verify search result   
    ${length}=	Get Total Number of Table Items
    ${page_number}=	Get Text	xpath=${Search_TablePageNumber_Link}
	${page_rest}=	Set Variable	${length}%20
	:For	${page}	in range	${page_number}
	\	Exit For Loop If	${page_number} == 1
	\	Loop Table To Verify Not Contain	20	29	n/a

	Loop Table To Verify Not Contain	${page_rest}	29	n/a
    
Advanced Search with several Eng PIDs
	[Documentation] 
    [Tags]	regression
    
    # Eng Products contains 69 150 76 281
    Log	 Eng Products contains 69 150 76 281
    
    # Set search filter 1 - key=eng_product_ids    operator=contains  value=69
    Log	Set search filter 1
    Click Button	xpath=${AdvancedSearch_Attribute_Link}
    Click Element	link=Eng Product ID(s)
    Click Element	xpath=${AdvancedSearch_StringAttributeOperator_Link}
	Click Element	link=contains
    Input Text		xpath=${AdvancedSearch_StringAttributeInput_Link}	69
       
    # Set search filter 2 - key=eng_product_ids    operator=contains  value=150
    Log	Set search filter 2
    Click Element	link=Add another filter
    Click Button	xpath=${AdvancedSearch_SecondFilter_Attribute_Link}
    Click Element	link=Eng Product ID(s)
    Click Element	xpath=${AdvancedSearch_SecondFilter_StringAttributeOperator_Link}
	Click Element	link=contains
    Input Text		xpath=${AdvancedSearch_SecondFilter_StringAttributeInput_Link}	150

	# Set search filter 3 - key=eng_product_ids    operator=contains  value=76
	Log	Set search filter 3
	Click Element	link=Add another filter
    Click Button	xpath=${AdvancedSearch_ThirdFilter_Attribute_Link}
    Click Element	link=Eng Product ID(s)
    Click Element	xpath=${AdvancedSearch_ThirdFilter_StringAttributeOperator_Link}
	Click Element	link=contains
    Input Text		xpath=${AdvancedSearch_ThirdFilter_StringAttributeInput_Link}	76

	# Set search filter 4 - key=eng_product_ids    operator=contains  value=281
	Log	Set search filter 4
	Click Element	link=Add another filter
    Click Button	xpath=${AdvancedSearch_FourthFilter_Attribute_Link}
    Click Element	link=Eng Product ID(s)
    Click Element	xpath=${AdvancedSearch_FourthFilter_StringAttributeOperator_Link}
	Click Element	link=contains
    Input Text		xpath=${AdvancedSearch_FourthFilter_StringAttributeInput_Link}	281
    
    # Submit
    Log	Submit
    Click Element  xpath=${AdvancedSearch_Submit_Link}
	
	# Keep waiting util search result table is visible
	Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
	Log	Verify search result 
	${length}=	Get Total Number of Table Items
    ${page_number}=	Get Text	xpath=${Search_TablePageNumber_Link}
	${page_rest}=	Set Variable	${length}%20
	:For	${page}	in range	${page_number}
	\	Exit For Loop If	${page_number} == 1
	\	Loop Table To Verify Contain	20	29	69	
	\	Loop Table To Verify Contain	20	29	150
	\	Loop Table To Verify Contain	20	29	76
	\	Loop Table To Verify Contain	20	29	281

	Loop Table To Verify Contain	${page_rest}	29	69
	Loop Table To Verify Contain	${page_rest}	29	150
	Loop Table To Verify Contain	${page_rest}	29	76
	Loop Table To Verify Contain	${page_rest}	29	281
    
Advanced Search with String attribute - equals
	[Documentation] 
    [Tags]	regression    
    # String attribute equals - key=arch    operator=equals  value=x86_64,ppc64le,ppc64,ia64,ppc,s390,x86,s390x
    Log	equals
    Click Button	xpath=${AdvancedSearch_Attribute_Link}
    Click Element	link=Arch
    Input Text		xpath=${AdvancedSearch_StringAttributeInput_Link}	x86_64,ppc64le,ppc64,ia64,ppc,s390,x86,s390x
    Log	Submit	
    Click Element  xpath=${AdvancedSearch_Submit_Link}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    Log	Verify search result
    ${length}=	Get Total Number of Table Items
    ${page_number}=	Get Text	xpath=${Search_TablePageNumber_Link}
	${page_rest}=	Set Variable	${length}%20
	:For	${page}	in range	${page_number}
	\	Exit For Loop If	${page_number} == 1
	\	Loop Table To Verify Equal	20	28	x86_64,ppc64le,ppc64,ia64,ppc,s390,x86,s390x

	Loop Table To Verify Equal	${page_rest}	28	x86_64,ppc64le,ppc64,ia64,ppc,s390,x86,s390x
	
Advanced Search with String attribute - contains
	[Documentation] 
    [Tags]	regression
    
    # String attribute contains - key=arch    key=arch    operator=contains  value=ppc64le
    Log	contains
    Click Button	xpath=${AdvancedSearch_Attribute_Link}
    Click Element	link=Arch
    Click Element	xpath=${AdvancedSearch_StringAttributeOperator_Link}
	Click Element	link=contains
    Input Text		xpath=${AdvancedSearch_StringAttributeInput_Link}	ppc64le
    Log	Submit
    Click Element  xpath=${AdvancedSearch_Submit_Link}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    Log	Verify search result
    ${length}=	Get Total Number of Table Items
    ${page_number}=	Get Text	xpath=${Search_TablePageNumber_Link}
	${page_rest}=	Set Variable	${length}%20
	:For	${page}	in range	${page_number}
	\	Exit For Loop If	${page_number} == 1
	\	Loop Table To Verify Contain	20	28	ppc64le

	Loop Table To Verify Contain	${page_rest}	28	ppc64le
    
Advanced Search with String attribute - does not contain
	[Documentation] 
    [Tags]	regression
    
    # String attribute does not contain - key=support_type    operator=does not contain  value=L1-L3
    Log	does not contain
    Click Button	xpath=${AdvancedSearch_Attribute_Link}
    Click Element	link=Support Type
    Click Element	xpath=${AdvancedSearch_StringAttributeOperator_Link}
	Click Element	link=does not contain
    Input Text		xpath=${AdvancedSearch_StringAttributeInput_Link}	L1-L3
    Log	Submit
    Click Element  xpath=${AdvancedSearch_Submit_Link}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    Log	Verify search result
    ${length}=	Get Total Number of Table Items
    ${page_number}=	Get Text	xpath=${Search_TablePageNumber_Link}
	${page_rest}=	Set Variable	${length}%20
	:For	${page}	in range	${page_number}
	\	Exit For Loop If	${page_number} == 1
	\	Loop Table To Verify Not Contain	20	16	L1-L3

	Loop Table To Verify Not Contain	${page_rest}	16	L1-L3
    
Advanced Search with String attribute - empty or not applicable
	[Documentation] 
    [Tags]	regression
    
    # String attribute empty or not applicable - key=derived_sku    operator=empty or not applicable
    Log	empty or not applicable
    Click Button	xpath=${AdvancedSearch_Attribute_Link}
    Click Element	link=Derived SKU
    Click Element	xpath=${AdvancedSearch_StringAttributeOperator_Link}
	Click Element	link=empty or not applicable
	Log	Submit
    Click Element  xpath=${AdvancedSearch_Submit_Link}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    Log	Verify search result  
    ${length}=	Get Total Number of Table Items
    ${page_number}=	Get Text	xpath=${Search_TablePageNumber_Link}
	${page_rest}=	Set Variable	${length}%20
	:For	${page}	in range	${page_number}
	\	Exit For Loop If	${page_number} == 1
	\	Loop Table To Verify Equal	20	27	n/a
	
	Loop Table To Verify Equal	${page_rest}	27	n/a
    
Advanced Search with String attribute - applicable
	[Documentation] 
    [Tags]	regression
    
    # String attribute applicable - key=derived_sku    operator=applicable
    Log	applicable
    Click Button	xpath=${AdvancedSearch_Attribute_Link}
    Click Element	link=Derived SKU
    Click Element	xpath=${AdvancedSearch_StringAttributeOperator_Link}
	Click Element	link=applicable
	Log	Submit
    Click Element  xpath=${AdvancedSearch_Submit_Link}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    Log	Verify search result
    ${length}=	Get Total Number of Table Items
    ${page_number}=	Get Text	xpath=${Search_TablePageNumber_Link}
	${page_rest}=	Set Variable	${length}%20
	:For	${page}	in range	${page_number}
	\	Exit For Loop If	${page_number} == 1
	\	Loop Table To Verify Not Contain	20	27	n/a
	
	Loop Table To Verify Not Contain	${page_rest}	27	n/a
    
Advanced Search with Integer attribute - equals -1
	[Documentation] 
	...	-1 equals n/a
	...	-2 equals unlimited 
    [Tags]	regression
    # Integer attribute equals -1 - key=virt_limit    operator=equals	value=-1
    Log	virt_limit equals -1
    Click Button	xpath=${AdvancedSearch_Attribute_Link}
    Click Element	link=Virt Limit
    Click Element	xpath=${AdvancedSearch_IntegerAttributeOperator_Link}
	Click Element	link=equals
	Input Text		xpath=${AdvancedSearch_IntegerAttributeInput_Link}	-1
	Log	Submit
    Click Element  	xpath=${AdvancedSearch_Submit_Link}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    Log	Verify search result
    ${length}=	Get Total Number of Table Items
    ${page_number}=	Get Text	xpath=${Search_TablePageNumber_Link}
	${page_rest}=	Set Variable	${length}%20
	:For	${page}	in range	${page_number}
	\	Exit For Loop If	${page_number} == 1
	\	Loop Table To Verify Equal	20	6	n/a
	
	Loop Table To Verify Equal	${page_rest}	6	n/a

Advanced Search with Integer attribute - equals -2
	[Documentation]	
	...	-1 equals n/a
	...	-2 equals unlimited 
    [Tags]	regression
    # Integer attribute equals -2 - key=virt_limit    operator=equals	value=-2
    Log	virt_limit equals -2
    Click Button	xpath=${AdvancedSearch_Attribute_Link}
    Click Element	link=Virt Limit
    Click Element	xpath=${AdvancedSearch_IntegerAttributeOperator_Link}
	Click Element	link=equals
	Input Text		xpath=${AdvancedSearch_IntegerAttributeInput_Link}	-2
	Log	Submit
    Click Element  	xpath=${AdvancedSearch_Submit_Link}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    Log	Verify search result
    ${length}=	Get Total Number of Table Items
    ${page_number}=	Get Text	xpath=${Search_TablePageNumber_Link}
	${page_rest}=	Set Variable	${length}%20
	:For	${page}	in range	${page_number}
	\	Exit For Loop If	${page_number} == 1
	\	Loop Table To Verify Equal	20	6	unlimited
	
	Loop Table To Verify Equal	${page_rest}	6	unlimited

Advanced Search with Integer attribute - equals 0
	[Documentation] 
    [Tags]	regression    
    # Integer attribute equals 0 - key=virt_limit    operator=equals	value=0
    Log	virt_limit equals -1
    Click Button	xpath=${AdvancedSearch_Attribute_Link}
    Click Element	link=Virt Limit
    Click Element	xpath=${AdvancedSearch_IntegerAttributeOperator_Link}
	Click Element	link=equals
	Input Text		xpath=${AdvancedSearch_IntegerAttributeInput_Link}	0
	Log	Submit
    Click Element  	xpath=${AdvancedSearch_Submit_Link}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    Log	Verify search result
    Page Should Contain	Showing 0 Results
    ${length}=	Get Text	xpath=${Search_TableZeroNumber_Link}
    Should Be Equal	${length}	0
      
Advanced Search with Integer attribute - equals an integer number
	[Documentation] 
    [Tags]	regression
    # Integer attribute equals 0 - key=virt_limit    operator=equals	value=4
    Log	virt_limit equals 4
    Click Button	xpath=${AdvancedSearch_Attribute_Link}
    Click Element	link=Virt Limit
    Click Element	xpath=${AdvancedSearch_IntegerAttributeOperator_Link}
	Click Element	link=equals
	Input Text		xpath=${AdvancedSearch_IntegerAttributeInput_Link}	4
	Log	Submit
    Click Element  	xpath=${AdvancedSearch_Submit_Link}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    Log	Verify search result
    ${length}=	Get Total Number of Table Items
    ${page_number}=	Get Text	xpath=${Search_TablePageNumber_Link}
	${page_rest}=	Set Variable	${length}%20
	:For	${page}	in range	${page_number}
	\	Exit For Loop If	${page_number} == 1
	\	Loop Table To Verify Equal	20	6	4
	
	Loop Table To Verify Equal	${page_rest}	6	4
    
Advanced Search with Integer attribute - does not equal
	[Documentation] 
    [Tags]	regression
    # Integer attribute equals 0 - key=virt_limit    operator=does not equal  value=4
    Log	virt_limit does not equal 4
    Click Button	xpath=${AdvancedSearch_Attribute_Link}
    Click Element	link=Virt Limit
    Click Element	xpath=${AdvancedSearch_IntegerAttributeOperator_Link}
	Click Element	link=does not equal
	Input Text		xpath=${AdvancedSearch_IntegerAttributeInput_Link}	4
	Log	Submit
    Click Element  	xpath=${AdvancedSearch_Submit_Link}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    Log	Verify search result
    ${length}=	Get Total Number of Table Items
    ${page_number}=	Get Text	xpath=${Search_TablePageNumber_Link}
	${page_rest}=	Set Variable	${length}%20
	:For	${page}	in range	${page_number}
	\	Exit For Loop If	${page_number} == 1
	\	Loop Table To Verify Not Equal	20	6	4
	
	Loop Table To Verify Not Equal	${page_rest}	6	4
    
Advanced Search with Integer attribute - greater than
	[Documentation] 
    [Tags]	regression
    # Integer attribute equals 0 - key=sockets    operator=greater than  value=20
    Log	sockets greater than 20
    Click Button	xpath=${AdvancedSearch_Attribute_Link}
    Click Element	link=Socket(s)
    Click Element	xpath=${AdvancedSearch_IntegerAttributeOperator_Link}
	Click Element	link=greater than
	Input Text		xpath=${AdvancedSearch_IntegerAttributeInput_Link}	20
	Log	Submit
    Click Element  	xpath=${AdvancedSearch_Submit_Link}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    Log	Verify search result
    ${length}=	Get Total Number of Table Items
    ${page_number}=	Get Text	xpath=${Search_TablePageNumber_Link}
	${page_rest}=	Set Variable	${length}%20
	:For	${page}	in range	${page_number}
	\	Exit For Loop If	${page_number} == 1
	\	Loop Table To Verify Greater Than	20	7	20
	
	Loop Table To Verify Greater Than	${page_rest}	7	20
    
Advanced Search with Integer attribute - less then
	[Documentation] 
    [Tags]	regression
    # Integer attribute equals 0 - key=sockets    operator=less then  value=128
    Log	sockets less then 128
    Click Button	xpath=${AdvancedSearch_Attribute_Link}
    Click Element	link=Socket(s)
    Click Element	xpath=${AdvancedSearch_IntegerAttributeOperator_Link}
	Click Element	link=less then
	Input Text		xpath=${AdvancedSearch_IntegerAttributeInput_Link}	128
	Log	Sumbit
    Click Element  	xpath=${AdvancedSearch_Submit_Link}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    Log	Verify search result
    ${length}=	Get Total Number of Table Items
    ${page_number}=	Get Text	xpath=${Search_TablePageNumber_Link}
	${page_rest}=	Set Variable	${length}%20
	:For	${page}	in range	${page_number}
	\	Exit For Loop If	${page_number} == 1
	\	Loop Table To Verify Less Then	20	7	4
	
	Loop Table To Verify Less Then	${page_rest}	7	4
    
Advanced Search with Integer attribute - empty or not applicable
	[Documentation] 
    [Tags]	regression
    # Integer attribute empty or not applicable - key=virt_limit    operator=empty or not applicable
    Log	virt_limit empty or not applicable
    Click Button	xpath=${AdvancedSearch_Attribute_Link}
    Click Element	link=Virt Limit
    Click Element	xpath=${AdvancedSearch_IntegerAttributeOperator_Link}
	Click Element	link=empty or not applicable
	Log	Submit
    Click Element  	xpath=${AdvancedSearch_Submit_Link}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    Log	Verify search result
    ${length}=	Get Total Number of Table Items
    ${page_number}=	Get Text	xpath=${Search_TablePageNumber_Link}
	${page_rest}=	Set Variable	${length}%20
	:For	${page}	in range	${page_number}
	\	Exit For Loop If	${page_number} == 1
	\	Loop Table To Verify Equal	20	6	n/a
	
	Loop Table To Verify Equal	${page_rest}	6	n/a
    
    
Advanced Search with Integer attribute - applicable
	[Documentation] 
    [Tags]	regression
    # Integer attribute empty or not applicable - key=virt_limit    operator=applicable
    Log	virt_limit applicable
    Click Button	xpath=${AdvancedSearch_Attribute_Link}
    Click Element	link=Virt Limit
    Click Element	xpath=${AdvancedSearch_IntegerAttributeOperator_Link}
	Click Element	link=applicable
	Log	Submit
    Click Element  	xpath=${AdvancedSearch_Submit_Link}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    Log	Verify search result
    ${length}=	Get Total Number of Table Items
    ${page_number}=	Get Text	xpath=${Search_TablePageNumber_Link}
	${page_rest}=	Set Variable	${length}%20
	:For	${page}	in range	${page_number}
	\	Exit For Loop If	${page_number} == 1
	\	Loop Table To Verify Not Equal	20	6	n/a
	
	Loop Table To Verify Not Equal	${page_rest}	6	n/a
    
Advanced Search with Integer attribute - unlimited
	[Documentation] 
    [Tags]	regression
    # Integer attribute empty or not applicable - key=virt_limit    operator=unlimited
    Log	virt_limit unlimited
    Click Button	xpath=${AdvancedSearch_Attribute_Link}
    Click Element	link=Virt Limit
    Click Element	xpath=${AdvancedSearch_IntegerAttributeOperator_Link}
	Click Element	link=unlimited
	Log	Submit
    Click Element  	xpath=${AdvancedSearch_Submit_Link}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    Log	Verify search result
    ${length}=	Get Total Number of Table Items
    ${page_number}=	Get Text	xpath=${Search_TablePageNumber_Link}
	${page_rest}=	Set Variable	${length}%20
	:For	${page}	in range	${page_number}
	\	Exit For Loop If	${page_number} == 1
	\	Loop Table To Verify Equal	20	6	unlimited
	
	Loop Table To Verify Equal	${page_rest}	6	unlimited
    
Advanced Search with Integer attribute - does not equal 0
	[Documentation] 
    [Tags]	regression
    # Integer attribute does not equal 0 - key=virt_limit    operator=does not equal  value=0
    Log	virt_limit does not equal 0
    Click Button	xpath=${AdvancedSearch_Attribute_Link}
    Click Element	link=Virt Limit
    Click Element	xpath=${AdvancedSearch_IntegerAttributeOperator_Link}
	Click Element	link=does not equal
	Input Text		xpath=${AdvancedSearch_IntegerAttributeInput_Link}	0
	Log	Submit
    Click Element  	xpath=${AdvancedSearch_Submit_Link}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    Log	Verify search result
    ${length}=	Get Total Number of Table Items
    ${page_number}=	Get Text	xpath=${Search_TablePageNumber_Link}
	${page_rest}=	Set Variable	${length}%20
	:For	${page}	in range	${page_number}
	\	Exit For Loop If	${page_number} == 1
	\	Loop Table To Verify Not Equal	20	6	0
	
	Loop Table To Verify Not Equal	${page_rest}	6	0
    
Advanced Search with Integer attribute - does not equal -1
	[Documentation] 
    [Tags]	regression
    # Integer attribute does not equal -1 - key=virt_limit    operator=does not equal  value=-1
    Log	virt_limit does not equal -1
    Click Button	xpath=${AdvancedSearch_Attribute_Link}
    Click Element	link=Virt Limit
    Click Element	xpath=${AdvancedSearch_IntegerAttributeOperator_Link}
	Click Element	link=does not equal
	Input Text		xpath=${AdvancedSearch_IntegerAttributeInput_Link}	-1
	Log	Submit
    Click Element  	xpath=${AdvancedSearch_Submit_Link}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    Log	Verify search result
    ${length}=	Get Total Number of Table Items
    ${page_number}=	Get Text	xpath=${Search_TablePageNumber_Link}
	${page_rest}=	Set Variable	${length}%20
	:For	${page}	in range	${page_number}
	\	Exit For Loop If	${page_number} == 1
	\	Loop Table To Verify Not Equal	20	6	-1
	
	Loop Table To Verify Not Equal	${page_rest}	6	-1
    
Advanced Search with Integer attribute - less then 0
	[Documentation] 
    [Tags]	regression
    # Integer attribute less then 0 - key=sockets    operator=less then  value=0
    Log	sockets less then 0
    Click Button	xpath=${AdvancedSearch_Attribute_Link}
    Click Element	link=Socket(s)
    Click Element	xpath=${AdvancedSearch_IntegerAttributeOperator_Link}
	Click Element	link=less then
	Input Text		xpath=${AdvancedSearch_IntegerAttributeInput_Link}	0
	Log	Submit
    Click Element  	xpath=${AdvancedSearch_Submit_Link}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    Log	Verify search result
    Page Should Contain	Showing 0 Results
    ${length}=	Get Text	xpath=${Search_TableZeroNumber_Link}
    Should Be Equal	${length}	0
    
Advanced Search with Integer attribute - less then -1
	[Documentation] 
    [Tags]	regression
    # Integer attribute less then -1 - key=sockets    operator=less then  value=-1
    Log	sockets less then -1
    Click Button	xpath=${AdvancedSearch_Attribute_Link}
    Click Element	link=Socket(s)
    Click Element	xpath=${AdvancedSearch_IntegerAttributeOperator_Link}
	Click Element	link=less then
	Input Text		xpath=${AdvancedSearch_IntegerAttributeInput_Link}	-1
	Log	Submit
    Click Element  	xpath=${AdvancedSearch_Submit_Link}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    Log	Verify search result
    Page Should Contain	Showing 0 Results
    ${length}=	Get Text	xpath=${Search_TableZeroNumber_Link}
    Should Be Equal	${length}	0
    
Advanced Search with Integer attribute - greater than 0
	[Documentation] 
    [Tags]	regression
    # Integer attribute greater than 0 - key=sockets    operator=greater than  value=0
    Log	sockets greater than 0
    Click Button	xpath=${AdvancedSearch_Attribute_Link}
    Click Element	link=Socket(s)
    Click Element	xpath=${AdvancedSearch_IntegerAttributeOperator_Link}
	Click Element	link=greater than
	Input Text		xpath=${AdvancedSearch_IntegerAttributeInput_Link}	0
	Log	Submit
    Click Element  	xpath=${AdvancedSearch_Submit_Link}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    Log	Verify search result
    ${length}=	Get Total Number of Table Items
    ${page_number}=	Get Text	xpath=${Search_TablePageNumber_Link}
	${page_rest}=	Set Variable	${length}%20
	:For	${page}	in range	${page_number}
	\	Exit For Loop If	${page_number} == 1
	\	Loop Table To Verify Greater Than	20	7	0
	
	Loop Table To Verify Greater Than	${page_rest}	7	0
    
Advanced Search with Integer attribute - greater than -1
	[Documentation] 
    [Tags]	regression
    # Integer attribute greater than -1 - key=sockets    operator=greater than  value=-1
    Log	sockets greater than -1
    Click Button	xpath=${AdvancedSearch_Attribute_Link}
    Click Element	link=Socket(s)
    Click Element	xpath=${AdvancedSearch_IntegerAttributeOperator_Link}
	Click Element	link=greater than
	Input Text		xpath=${AdvancedSearch_IntegerAttributeInput_Link}	-1
	Log	Submit
    Click Element  	xpath=${AdvancedSearch_Submit_Link}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    Log	Verify search result
    ${length}=	Get Total Number of Table Items
    ${page_number}=	Get Text	xpath=${Search_TablePageNumber_Link}
	${page_rest}=	Set Variable	${length}%20
	:For	${page}	in range	${page_number}
	\	Exit For Loop If	${page_number} == 1
	\	Loop Table To Verify Greater Than	20	7	-1
	
	Loop Table To Verify Greater Than	${page_rest}	7	-1
    
    
Advanced Search with Boolean attribute - equals True
	[Documentation] 
    [Tags]	regression
    # Boolean attribute equals True - key=virt_only    operator=equals	value=True
    Log	virt_only attribute equals True
    Click Button	xpath=${AdvancedSearch_Attribute_Link}
    Click Element	link=Virt-only
    Log	Submit
    Click Element	xpath=${AdvancedSearch_Submit_Link}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    Log	Verify search result
    ${length}=	Get Total Number of Table Items
    ${page_number}=	Get Text	xpath=${Search_TablePageNumber_Link}
	${page_rest}=	Set Variable	${length}%20
	:For	${page}	in range	${page_number}
	\	Exit For Loop If	${page_number} == 1
	\	Loop Table To Verify Equal	20	18	True
	
	Loop Table To Verify Equal	${page_rest}	18	True
	
Advanced Search with Boolean attribute - equals False
	[Documentation] 
    [Tags]	regression
    # Boolean attribute equals False - key=virt_only    operator=equals	value=False
    Log	virt_only attribute equals False
    Click Button	xpath=${AdvancedSearch_Attribute_Link}
    Click Element	link=Virt-only
    Click Element  	xpath=${AdvancedSearch_BooleanTrue_Link}
    
    Log	Submit
    Click Element	xpath=${AdvancedSearch_Submit_Link}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    Log	Verify search result
    ${length}=	Get Total Number of Table Items
    ${page_number}=	Get Text	xpath=${Search_TablePageNumber_Link}
	${page_rest}=	Set Variable	${length}%20
	:For	${page}	in range	${page_number}
	\	Exit For Loop If	${page_number} == 1
	\	Loop Table To Verify Equal	20	18	False
	
	Loop Table To Verify Equal	${page_rest}	18	False    

Advanced Search with Arch contains invalid arch
	[Documentation] 	auch as xx888
    [Tags]	regression
    # key=arch    operator=contains  value=xx86_64 
    Log	Arch contains invalid arch
    Click Button	xpath=//form[@id='search_advanced_form']/div/div/div/button
    Click Link		Arch
    Click Button	xpath=//form[@id='search_advanced_form']/div/div/div[2]/button
    Click Link		contains
    Input Text     xpath=//form[@id='search_advanced_form']/div/div/input[@name='0_data_string']	xx86_64
    
    Log	Submit
    Click Element  xpath=${AdvancedSearch_Submit_Link}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    Log	Chceck search result
    Page Should Contain	Showing 0 Results  
    ${length}=	Get Text	xpath=${Search_TableZeroNumber_Link}
    Should Be Equal	${length}	0
	
Advanced Search with String attribute equals and does not contain
	[Documentation] 
    [Tags]	regression
    # key=ph_product_line    operator=equals  value=RHEL
    Log	String attribute equals
    Click Button	xpath=//form[@id='search_advanced_form']/div/div/div/button
    Click Link		Product Hierarchy: Product Line
    Click Button	xpath=//form[@id='search_advanced_form']/div/div/div[2]/button
    Click Link		equals
    Input Text     xpath=//form[@id='search_advanced_form']/div/div/input[@name='0_data_string']	RHEL

    # key=ph_product_line    operator=does not contain  value=RHEL
    Log	String attribute does not contain
    Click Element	link=Add another filter
    Click Button	xpath=${AdvancedSearch_SecondFilter_Attribute_Link}
    Click Element	link=Product Hierarchy: Product Line
    Click Element	xpath=${AdvancedSearch_SecondFilter_StringAttributeOperator_Link}
    Click Element	link=does not contain
    Input Text	xpath=${AdvancedSearch_SecondFilter_StringAttributeInput_Link}	RHEL
    
    # Submit
    Log	Submit
    Click Element  xpath=${AdvancedSearch_Submit_Link}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    # Check result    
    Log	Chceck search result
    Page Should Contain	Showing 0 Results  
    ${length}=	Get Text	xpath=${Search_TableZeroNumber_Link}
    Should Be Equal	${length}	0
    
Advanced Search with String attribute is applicable and empty or not applicable
	[Documentation] 
    [Tags]	regression
    # key=stacking_id     operator=applicable
    Log	String attribute is applicable
    Click Button	xpath=//form[@id='search_advanced_form']/div/div/div/button
    Click Link		Stacking ID
    Click Button	xpath=//form[@id='search_advanced_form']/div/div/div[2]/button
    Click Link		applicable
    
    # key=stacking_id     operator=empty or not applicable
    Log	String attribute empty or not applicable
    Click Element	link=Add another filter
    Click Button	xpath=${AdvancedSearch_SecondFilter_Attribute_Link}
    Click Element	link=Stacking ID
    Click Button	xpath=${AdvancedSearch_SecondFilter_StringAttributeOperator_Link}
    Click Element	link=empty or not applicable
    
    # Submit
    Log	Submit
    Click Element  xpath=${AdvancedSearch_Submit_Link}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    # Check result
    Log	Chceck search result
    Page Should Contain	Showing 0 Results 
    ${length}=	Get Text	xpath=${Search_TableZeroNumber_Link}
    Should Be Equal	${length}	0
    
    
Advanced Search with Integer attribute equals and does not equal
	[Documentation] 
    [Tags]	regression
    # key=sockets    operator=equals  value=20
    Log	Integer attribute Socket(s) equals 20
    Click Button	xpath=//form[@id='search_advanced_form']/div/div/div/button
    Click Link		Socket(s)
    Click Button	xpath=${AdvancedSearch_IntegerAttributeOperator_Link}
    Click Element	link=equals
    Input Text     xpath=${AdvancedSearch_IntegerAttributeInput_Link}	20

    # key=sockets    operator=does not equal  value=20
    Log	Integer attribute Socket(s) does not equal 20
    Click Element	link=Add another filter
    Click Button	xpath=${AdvancedSearch_Attribute_Link}
    Click Link	Socket(s)
    Click Element	xpath=${AdvancedSearch_SecondFilter_IntegerAttributeOperator_Link}
    Click Element	link=does not equal
    Input Text	xpath=${AdvancedSearch_SecondFilter_IntegerAttributeInput_Link}	20
    
    # Submit
    Log	Submit
    Click Element  xpath=${AdvancedSearch_Submit_Link}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    # Check result
    Log	Verify search result
    Page Should Contain	Showing 0 Results 
    ${length}=	Get Text	xpath=${Search_TableZeroNumber_Link}
    Should Be Equal	${length}	0 
    
Advanced Search with Integer attribute is applicable and empty or not applicable
	[Documentation] 
    [Tags]	regression
    # key=sockets    operator=applicable
    Log	Integer attribute Socket(s) applicable
    Click Button	xpath=//form[@id='search_advanced_form']/div/div/div/button
    Click Link		Socket(s)
    Click Button	xpath=${AdvancedSearch_IntegerAttributeOperator_Link}
    Click Element	link=applicable

    # key=sockets    operator=empty or not applicable
    Log	Integer attribute Socket(s) empty or not applicable
    Click Element	link=Add another filter
    Click Button	xpath=${AdvancedSearch_Attribute_Link}
    Click Link	Socket(s)
    Click Element	xpath=${AdvancedSearch_SecondFilter_IntegerAttributeOperator_Link}
    Click Element	link=empty or not applicable
    
    # Submit
    Log	Submit
    Click Element  xpath=${AdvancedSearch_Submit_Link}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    # Check result
    Log	Verify search result
    Page Should Contain	Showing 0 Results  
    ${length}=	Get Text	xpath=${Search_TableZeroNumber_Link}
    Should Be Equal	${length}	0
    
Advanced Search with Integer attribute is less than and greater than one same number
	[Documentation] 
    [Tags]	regression
    # key=sockets    operator=greater than	value=20
    Log	Integer attribute is greater than one number
    Click Button	xpath=//form[@id='search_advanced_form']/div/div/div/button
    Click Link		Socket(s)
    Click Button	xpath=${AdvancedSearch_IntegerAttributeOperator_Link}
    Click Element	link=greater than
    Input Text     xpath=${AdvancedSearch_IntegerAttributeInput_Link}	20

    # key=sockets    operator=less then	value=20
    Log	Integer attribute is less then one same number
    Click Element	link=Add another filter
    Click Button	xpath=${AdvancedSearch_Attribute_Link}
    Click Link	Socket(s)
    Click Element	xpath=${AdvancedSearch_SecondFilter_IntegerAttributeOperator_Link}
    Click Element	link=less then
    Input Text	xpath=${AdvancedSearch_SecondFilter_IntegerAttributeInput_Link}	20
    
    # Submit
    Log	Submit
    Click Element  xpath=${AdvancedSearch_Submit_Link}
    
    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    # Check result
    Log	Verify search result
    Page Should Contain	Showing 0 Results  
    ${length}=	Get Text	xpath=${Search_TableZeroNumber_Link}
    Should Be Equal	${length}	0
    
    
Advanced Search with Boolean attribute is False and True
	[Documentation] 	such as, Virt-only is False and Virt-only is True 
    [Tags]	regression
    # key=multi_entitlement    operator=equals	value=True
    Log	Boolean attribute is True
    Click Button	xpath=//form[@id='search_advanced_form']/div/div/div/button
    Click Link		Multi Entitlement

    # key=multi_entitlement    operator=equals	value=False
    Log	Boolean attribute is False
    Click Element	link=Add another filter
    Click Button	xpath=${AdvancedSearch_Attribute_Link}
    Click Link	Multi Entitlement
    Click Element	xpath=${AdvancedSearch_SecondFilter_BooleanTrue_Link}
    
    # Submit
    Log	Submit
    Click Element  xpath=${AdvancedSearch_Submit_Link}

    # Keep waiting util search result table is visible
    Log	Keep waiting util search result table is visible
    Wait Until Element Is Visible	xpath=${Search_Table_Link}	timeout=${TIMEOUT}	error=${NOT_VISIBLE_ERROR}
    
    # Check result
    Log	Verify search result
    Page Should Contain	Showing 0 Results  
    ${length}=	Get Text	xpath=${Search_TableZeroNumber_Link}
    Should Be Equal	${length}	0

*** Keywords ***    
Suite Setup Steps
	Log	Suite Begin...
	Open Browser  ${FRONT_PAGE}   ${BROWSER}
	Maximize Browser Window

Test Setup Steps
	Log	Suite Begin...
	Go to Front Page
    Click Link	Search SKU Catalog
    Click Link	Advanced search
    Page should contain	Search results
    Capture Page Screenshot

Test Teardown Steps
	Capture Page Screenshot
	Log	Testing End...

Suite TearDown Steps
	Close All Browsers
	Log	Suite End...