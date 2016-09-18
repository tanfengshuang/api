*** Settings ***
Documentation	Account Tool API Test for search(GET).
Resource       ../resources/global.txt

*** Variables ***

*** Test Cases ***
Search with nothing
    [Documentation]
    [Tags]    regression
    ${CONDITION}=       Create Dictionary    
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=	POST   ${SEARCH_URL}	${SEARCH_INFO}
	${SUCCESS_MSG}=		Set Variable	'{}' is not a valid query
	Should Be Equal     ${STATUS}   400
	Should Be Equal     ${MSG}	${SUCCESS_MSG}
	
Search with invalid operator
    [Documentation]	
    [Tags]    regression
    ${CONDITION}=       Create Dictionary    key=ph_product_name    operator=equal  value=Academic
	${search_info}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}	${SEARCH_INFO}
	${SUCCESS_MSG}=		Set Variable	'{u'operator': u'equal', u'value': u'Academic', u'key': u'ph_product_name'}' is not a valid query
	Should Be Equal     ${STATUS}      400
	Should Be Equal     ${MSG}	${SUCCESS_MSG}
	
Search with invalid key
    [Documentation]	
    [Tags]    regression
    ${CONDITION}=       Create Dictionary    key=ph_product_name_wrong    operator=equals  value=Academic
	${search_info}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}	${SEARCH_INFO}
	${SUCCESS_MSG}=		Set Variable	'{u'operator': u'equals', u'value': u'Academic', u'key': u'ph_product_name_wrong'}' is not a valid query
	Should Be Equal     ${STATUS}      400
	Should Be Equal     ${MSG}	${SUCCESS_MSG}

Search missing key
    [Documentation]
    [Tags]    regression
    ${CONDITION}=       Create Dictionary    operator=equals	value=Academic
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=	POST   ${SEARCH_URL}	${SEARCH_INFO}
	${SUCCESS_MSG}=		Set Variable	'{u'operator': u'equals', u'value': u'Academic'}' is not a valid query
	Should Be Equal     ${STATUS}      400
	Should Be Equal     ${MSG}	${SUCCESS_MSG}
	
Search missing operator
    [Documentation]
    [Tags]    regression
    ${CONDITION}=       Create Dictionary    key=ph_product_name    value=Academic
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}	${SEARCH_INFO}
	${SUCCESS_MSG}=		Set Variable	'{u'value': u'Academic', u'key': u'ph_product_name'}' is not a valid query
	Should Be Equal     ${STATUS}      400
	Should Be Equal     ${MSG}	${SUCCESS_MSG}
	
Search missing value
    [Documentation]
    [Tags]    regression
    ${CONDITION}=       Create Dictionary    key=ph_product_name    operator=equals
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}	${SEARCH_INFO}
	${SUCCESS_MSG}=		Set Variable	'{u'operator': u'equals', u'key': u'ph_product_name'}' is not a valid query
	Should Be Equal     ${STATUS}      400
	Should Be Equal     ${MSG}	${SUCCESS_MSG}
	
Search by Product Hierarchy: Product Name with ALL skus
    [Documentation]
    [Tags]    regression
	${SEARCH_INFO}=     Create List     
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}	${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG}
	Should Be True	${length} > 10000
    
Search by Product Hierarchy: Product Name with one product
    [Documentation]	(such as Academic)
    [Tags]    regression
    ${CONDITION}=       Create Dictionary    key=ph_product_name    operator=equals  value=Academic
	${search_info}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}	${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length} = 	Get Length 	${MSG}
	:For	${i}	in	@{MSG}
	\	Log		${i['id']} ${i['ph_product_name']}
	\	Should Be Equal	${i['ph_product_name']}	Academic
    
Search by SKU with nothing
    [Documentation]
    [Tags]    regression
    ${CONDITION}=       Create Dictionary    key=id    operator=equals  value=
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}	${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG}
	Should Be Equal As Integers	${length}	0
    
Search by SKU with one existing sku
    [Documentation]
    [Tags]    regression
    ${CONDITION}=       Create Dictionary    key=id    operator=equals  value=SER0444
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}	${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG}
	Should Be Equal As Integers	${length}	1
	Should Be Equal	${MSG[0]['id']}	SER0444
    
Search by SKU with two existing skus
    [Documentation]		(such as: SER0444,SER0445)
    [Tags]    regression
    ${CONDITION}=       Create Dictionary    key=id    operator=equals  value=SER0444,SER0445
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}	${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG}
	Should Be Equal As Integers	${length}	0
    
Search by SKU with part of sku
    [Documentation]		(such as SER044, 0444)
    [Tags]    regression
    ${CONDITION}=       Create Dictionary    key=id    operator=contains  value=SER044
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}	${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length} = 	Get Length 	${MSG}
	:For	${i}	in	@{MSG}
	\	Log		${i['id']}
	\	Should Contain	${i['id']}	SER044
    
Search by SKU with invalid sku
    [Documentation]		(such as RH0103708000)
    [Tags]    regression
    ${CONDITION}=       Create Dictionary    key=id    operator=equals  value=RH0103708000
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}	${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG}
	Should Be Equal As Integers	${length}	0
    
Advanced Search - Test 2 filters
    [Documentation]
    [Tags]    regression
    ${CONDITION1}=      Create Dictionary    key=ph_product_name    operator=equals  value=Academic 
    ${CONDITION2}=		Create Dictionary	 key=id    operator=equals  value=MCT0834
	${SEARCH_INFO}=     Create List     ${CONDITION1}	${CONDITION2}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}	${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG}
	Should Be Equal As Integers	${length}	1
	Should Be Equal     ${MSG[0]['id']}     MCT0834
    
Advanced Search - Test 3 filters
    [Documentation]
    [Tags]    regression
    ${virt_limit_integer}=	Convert To Integer	4
    ${CONDITION1}=      Create Dictionary    key=ph_product_name    operator=equals  value=Academic 
    ${CONDITION2}=		Create Dictionary	 key=virt_limit    operator=equals  value=${virt_limit_integer}
    ${CONDITION3}=		Create Dictionary	 key=id    operator=equals  value=MCT0834
	${SEARCH_INFO}=     Create List     ${CONDITION1}	${CONDITION2}	${CONDITION3}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}	${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG}
	Should Be Equal As Integers	${length}	1
	Should Be Equal     ${MSG[0]['id']}     MCT0834
    
Advanced Search - Test 4 filters
    [Documentation]
    [Tags]    regression
    ${virt_limit_integer}=	Convert To Integer	4
    ${sockets_integer}=	Convert To Integer	2
    ${CONDITION1}=      Create Dictionary    key=ph_product_name    operator=equals  value=Academic 
    ${CONDITION2}=		Create Dictionary	 key=virt_limit    operator=equals  value=${virt_limit_integer}
    ${CONDITION3}=		Create Dictionary	 key=sockets    operator=equals  value=${sockets_integer}
    ${CONDITION4}=		Create Dictionary	 key=id    operator=equals  value=MCT0834
	${SEARCH_INFO}=     Create List     ${CONDITION1}	${CONDITION2}	${CONDITION3}	${CONDITION4}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}	${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG}
	Should Be Equal As Integers	${length}	1
	Should Be Equal     ${MSG[0]['id']}     MCT0834
    
Advanced Search - Test 5 filters
    [Documentation]
    [Tags]    regression
    ${virt_limit_integer}=	Convert To Integer	4
    ${sockets_integer}=	Convert To Integer	2
    ${multiplier_integer}=	Convert To Integer	16
    ${CONDITION1}=       Create Dictionary    key=ph_product_name    operator=equals  value=Academic 
    ${CONDITION2}=		Create Dictionary	 key=virt_limit    operator=equals  value=${virt_limit_integer}
    ${CONDITION3}=		Create Dictionary	 key=sockets    operator=equals  value=${sockets_integer}
    ${CONDITION4}=		Create Dictionary	 key=multiplier    operator=equals  value=${multiplier_integer}
    ${CONDITION5}=		Create Dictionary	 key=id    operator=equals  value=MCT0834
	${SEARCH_INFO}=     Create List     ${CONDITION1}	${CONDITION2}	${CONDITION3}	${CONDITION4}	${CONDITION5}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}	${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG}
	Should Be Equal As Integers	${length}	1
	Should Be Equal     ${MSG[0]['id']}     MCT0834
    
Advanced Search with SKU Name
    [Documentation]
    ...	operator:
    ...	equals
    ...	contains
    ...	does not contain
    ...	empty or not applicable
    ...	applicable
    [Tags]    regression
    # equals
    Log	 equals operator
    ${CONDITION}=       Create Dictionary    key=id    operator=equals  value=MCT0834
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}	${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG}
	Should Be Equal As Integers	${length}	1
	Should Be Equal     ${MSG[0]['id']}     MCT0834
	# contains
	Log	contains operator
	${CONDITION}=       Create Dictionary    key=id    operator=contains  value=MCT08
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}	${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG}
	Should Contain     ${MSG[0]['id']}     MCT08
	# does not contain
	Log	does not contain operator
	${CONDITION}=       Create Dictionary    key=id    operator=does not contain  value=MCT
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}	${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG}
	Should Not Contain     ${MSG[0]['id']}     MCT
    # empty or not applicable
    Log	empty or not applicable operator
    ${CONDITION}=       Create Dictionary    key=id    operator=empty or not applicable
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}	${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG}
	Should Be Equal As Integers	${length}	0
    # applicable
    Log	applicable operator
    ${CONDITION}=       Create Dictionary    key=id    operator=applicable
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}	${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG}
	Should Be True	${length} > 10000

Advanced Search with Eng Product ID
    [Documentation]
    ...	operator:
    ...	equals
    ...	contains
    ...	does not contain
    ...	empty or not applicable
    ...	applicable
    [Tags]    regression
    # equals
    Log	 equals operator
    ${CONDITION}       Create Dictionary    key=eng_product_ids    operator=equals  value=180,240,69
	${SEARCH_INFO}     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}	${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG}
	:For	${i}	IN	@{MSG}
	\	Log		${i['id']} ${i['eng_product_ids']}
	\	Should Be Equal     ${i['eng_product_ids']}     180,240,69
	# contains
	Log	contains operator
	${CONDITION}       Create Dictionary    key=eng_product_ids    operator=contains  value=180
	${SEARCH_INFO}     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}	${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG}
	:For	${i}	IN	@{MSG}
	\	Log		${i['id']} ${i['eng_product_ids']}
	\	Should Contain     ${i['eng_product_ids']}     180
	# does not contain
	Log	does not contain operator
	${CONDITION}       Create Dictionary    key=eng_product_ids    operator=does not contain  value=180
	${SEARCH_INFO}     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}	${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG}
	:For	${i}	IN	@{MSG}
	\	Log		${i['id']} ${i['eng_product_ids']}
	\	Should Not Contain     ${i['eng_product_ids']}     180
    # empty or not applicable
    Log	empty or not applicable operator
    ${CONDITION}       Create Dictionary    key=eng_product_ids    operator=empty or not applicable
	${SEARCH_INFO}     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}	${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG} 
	:For	${i}	IN	@{MSG}
	\	Log		${i['id']} ${i['eng_product_ids']}
	\	Should Be Equal     ${i['eng_product_ids']}     n/a 
    # applicable
    Log	applicable operator
    ${CONDITION}=       Create Dictionary    key=eng_product_ids    operator=applicable
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}	${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG}
	Should Be True	${length} > 10000

Advanced Search with Several Eng PIDs
	[Documentation]
    [Tags]    regression
    ${CONDITION1}=      Create Dictionary    key=eng_product_ids    operator=contains  value=69 
    ${CONDITION2}=		Create Dictionary	 key=eng_product_ids    operator=contains  value=150
    ${CONDITION3}=		Create Dictionary	 key=eng_product_ids    operator=contains  value=76
    ${CONDITION4}=		Create Dictionary	 key=eng_product_ids    operator=contains  value=281
	${SEARCH_INFO}=     Create List     ${CONDITION1}	${CONDITION2}	${CONDITION3}	${CONDITION4}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}	${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG} 
	:For	${i}	IN	@{MSG}
	\	Log		${i['id']} ${i['eng_product_ids']}
	\	Should Contain     ${i['eng_product_ids']}     69
	\	Should Contain     ${i['eng_product_ids']}     150
	\	Should Contain     ${i['eng_product_ids']}     76
	\	Should Contain     ${i['eng_product_ids']}     281
    
Advanced Search with String attribute - equals
    [Documentation]
    ...	operator for string attribute:
    ...	equals
    ...	contains
    ...	does not contain
    ...	empty or not applicable
    ...	applicable
    [Tags]    regression
    # equals
    Log	equals
    ${CONDITION}=       Create Dictionary    key=arch    operator=equals  value=x86_64,ppc64le,ppc64,ia64,ppc,s390,x86,s390x
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}		${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG} 
	:For	${i}	IN	@{MSG}
	\	Log		${i['id']} ${i['arch']}
	\	Should Be Equal     ${i['arch']}     x86_64,ppc64le,ppc64,ia64,ppc,s390,x86,s390x
	
Advanced Search with String attribute - contains
    [Documentation]
    ...	operator for string attribute:
    ...	equals
    ...	contains
    ...	does not contain
    ...	empty or not applicable
    ...	applicable
    [Tags]    regression
    # contains
    Log	contains
    ${CONDITION}=       Create Dictionary    key=arch    operator=contains  value=ppc64le
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}		${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG} 
	:For	${i}	IN	@{MSG}
	\	Log		${i['id']} ${i['arch']}
	\	Should Contain     ${i['arch']}     ppc64le

Advanced Search with String attribute - does not contain  
    [Documentation]
    ...	operator for string attribute:
    ...	equals
    ...	contains
    ...	does not contain
    ...	empty or not applicable
    ...	applicable
    [Tags]    regression
    # does not contain
    Log	does not contain
    ${CONDITION}=       Create Dictionary    key=support_type    operator=does not contain  value=L1-L3
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}		${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG} 
	:For	${i}	IN	@{MSG}
	\	Log		${i['id']} ${i['support_type']}
	\	Should Not Contain     ${i['support_type']}     L1-L3
    
Advanced Search with String attribute - empty or not applicable
    [Documentation]
    ...	operator for string attribute:
    ...	equals
    ...	contains
    ...	does not contain
    ...	empty or not applicable
    ...	applicable
    [Tags]    regression
    # empty or not applicable
    Log	empty or not applicable
    ${CONDITION}=       Create Dictionary    key=derived_sku    operator=empty or not applicable
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}		${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG} 
	:For	${i}	IN	@{MSG}
	\	Log		${i['id']} ${i['derived_sku']}
	\	Should Be Equal     ${i['derived_sku']}     n/a
    
Advanced Search with String attribute - applicable
    [Documentation]
    ...	operator for string attribute:
    ...	equals
    ...	contains
    ...	does not contain
    ...	empty or not applicable
    ...	applicable
    [Tags]    regression
    # applicable
    Log	applicable
    ${CONDITION}=       Create Dictionary    key=derived_sku    operator=applicable
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}		${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG} 
	:For	${i}	IN	@{MSG}
	\	Log		${i['id']} ${i['derived_sku']}
	\	Should Not Be Equal     ${i['derived_sku']}     n/a
    
Advanced Search with Integer attribute - equals n/a
    [Documentation]
    ...	operator for Integer attribute:
    ...	equals 	
    ...	does not equal
    ...	greater than
    ...	less then
    ...	empty or not applicable
    ...	applicable
    ...	unlimited 
    [Tags]    regression
    # equals
    Log	equals n/a
    ${CONDITION}=       Create Dictionary    key=virt_limit    operator=equals		value=n/a
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}		${SEARCH_INFO}
	Should Be Equal     ${STATUS}      400
	${SUCCESS_MSG}= 	Set Variable	'{u'operator': u'equals', u'value': u'n/a', u'key': u'virt_limit'}' is not a valid query
	Should Be Equal		${MSG}	${SUCCESS_MSG}

Advanced Search with Integer attribute - equals unlimited
    [Documentation]
    ...	operator for Integer attribute:
    ...	equals 	
    ...	does not equal
    ...	greater than
    ...	less then
    ...	empty or not applicable
    ...	applicable
    ...	unlimited 
    [Tags]    regression
    Log	equals unlimited
    ${CONDITION}=       Create Dictionary    key=virt_limit    operator=equals		value=unlimited
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}		${SEARCH_INFO}
	Should Be Equal     ${STATUS}      400
	${SUCCESS_MSG}= 	Set Variable	'{u'operator': u'equals', u'value': u'unlimited', u'key': u'virt_limit'}' is not a valid query
	Should Be Equal		${MSG}	${SUCCESS_MSG}
	
Advanced Search with Integer attribute - equals an integer number
    [Documentation]
    ...	operator for Integer attribute:
    ...	equals 	
    ...	does not equal
    ...	greater than
    ...	less then
    ...	empty or not applicable
    ...	applicable
    ...	unlimited 
    [Tags]    regression
	Log	equals an integer number
	${virt_limit_integer}=	Convert To Integer	4
	${CONDITION}=       Create Dictionary    key=virt_limit    operator=equals		value=${virt_limit_integer}
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}		${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG} 
	:For	${i}	IN	@{MSG}
	\	Log		${i['id']} ${i['virt_limit']}
	\	Should Be Equal As Integers     ${i['virt_limit']}     ${virt_limit_integer}

Advanced Search with Integer attribute - does not equal an integer number
    [Documentation]
    ...	operator for Integer attribute:
    ...	equals 	
    ...	does not equal
    ...	greater than
    ...	less then
    ...	empty or not applicable
    ...	applicable
    ...	unlimited 
    [Tags]    regression
    Log	does not equal an integer number
    ${virt_limit_integer}=	Convert To Integer	20
    ${CONDITION}=       Create Dictionary    key=virt_limit    operator=does not equal  value=${virt_limit_integer}
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}		${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG} 
	:For	${i}	IN	@{MSG}
	\	Log		${i['id']} ${i['virt_limit']}
	\	Should Not Be Equal	${i['virt_limit']}  20

Advanced Search with Integer attribute - does not equal n/a
    [Documentation]
    ...	operator for Integer attribute:
    ...	equals 	
    ...	does not equal
    ...	greater than
    ...	less then
    ...	empty or not applicable
    ...	applicable
    ...	unlimited 
    [Tags]    regression
    Log	does not equal n/a
    ${CONDITION}=       Create Dictionary    key=virt_limit    operator=does not equal		value=n/a
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}		${SEARCH_INFO}
	Should Be Equal     ${STATUS}      400
	${SUCCESS_MSG}= 	Set Variable	'{u'operator': u'does not equal', u'value': u'n/a', u'key': u'virt_limit'}' is not a valid query
	Should Be Equal		${MSG}	${SUCCESS_MSG}

Advanced Search with Integer attribute - does not equal unlimited
    [Documentation]
    ...	operator for Integer attribute:
    ...	equals 	
    ...	does not equal
    ...	greater than
    ...	less then
    ...	empty or not applicable
    ...	applicable
    ...	unlimited 
    [Tags]    regression
	Log	does not equal unlimited
    ${CONDITION}=       Create Dictionary    key=virt_limit    operator=does not equal		value=unlimited
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}		${SEARCH_INFO}
	Should Be Equal     ${STATUS}      400
	${SUCCESS_MSG}= 	Set Variable	'{u'operator': u'does not equal', u'value': u'unlimited', u'key': u'virt_limit'}' is not a valid query
	Should Be Equal		${MSG}	${SUCCESS_MSG}
    
Advanced Search with Integer attribute - greater than an integer number
    [Documentation]
    ...	operator for Integer attribute:
    ...	equals 	
    ...	does not equal
    ...	greater than
    ...	less then
    ...	empty or not applicable
    ...	applicable
    ...	unlimited 
    [Tags]    regression
    Log	greater than an integer number
    ${sockets_integer}=	Convert To Integer	20
    ${CONDITION}=       Create Dictionary    key=sockets    operator=greater than  value=${sockets_integer}
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}		${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG} 
	:For	${i}	IN	@{MSG}
	\	Log		${i['id']} ${i['sockets']}
	\	Should Be True     ${i['sockets']} > ${sockets_integer}

Advanced Search with Integer attribute - greater than n/a
    [Documentation]
    ...	operator for Integer attribute:
    ...	equals 	
    ...	does not equal
    ...	greater than
    ...	less then
    ...	empty or not applicable
    ...	applicable
    ...	unlimited 
    [Tags]    regression
    # greater than
    Log	greater than
    ${CONDITION}=       Create Dictionary    key=sockets    operator=greater than  value=n/a
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}		${SEARCH_INFO}
	Should Be Equal     ${STATUS}      400
	${SUCCESS_MSG}= 	Set Variable	'{u'operator': u'greater than', u'value': u'n/a', u'key': u'sockets'}' is not a valid query
	Should Be Equal		${MSG}	${SUCCESS_MSG}

Advanced Search with Integer attribute - greater than unlimited
    [Documentation]
    ...	operator for Integer attribute:
    ...	equals 	
    ...	does not equal
    ...	greater than
    ...	less then
    ...	empty or not applicable
    ...	applicable
    ...	unlimited 
    [Tags]    regression
    # greater than
    Log	greater than
    ${CONDITION}=       Create Dictionary    key=sockets    operator=greater than  value=unlimited
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}		${SEARCH_INFO}
	Should Be Equal     ${STATUS}      400
	${SUCCESS_MSG}= 	Set Variable	'{u'operator': u'greater than', u'value': u'unlimited', u'key': u'sockets'}' is not a valid query
	Should Be Equal		${MSG}	${SUCCESS_MSG}

Advanced Search with Integer attribute - less then an integer number
    [Documentation]
    ...	operator for Integer attribute:
    ...	equals 	
    ...	does not equal
    ...	greater than
    ...	less then
    ...	empty or not applicable
    ...	applicable
    ...	unlimited 
    [Tags]    regression
    # less then
    Log	less then
    ${sockets_integer}=	Convert To Integer	128
    ${CONDITION}=       Create Dictionary    key=sockets    operator=less then		value=${sockets_integer}
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}		${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG} 
	:For	${i}	IN	@{MSG}
	\	Log		${i['id']} ${i['sockets']}
	\	Should Be True     ${i['sockets']} < ${sockets_integer}

Advanced Search with Integer attribute - less then n/a
    [Documentation]
    ...	operator for Integer attribute:
    ...	equals 	
    ...	does not equal
    ...	greater than
    ...	less then
    ...	empty or not applicable
    ...	applicable
    ...	unlimited 
    [Tags]    regression
    # less then
    Log	less then
    ${CONDITION}=       Create Dictionary    key=sockets    operator=less then		value=n/a
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}		${SEARCH_INFO}
	Should Be Equal     ${STATUS}      400
	${SUCCESS_MSG}= 	Set Variable	'{u'operator': u'less then', u'value': u'n/a', u'key': u'sockets'}' is not a valid query
	Should Be Equal		${MSG}	${SUCCESS_MSG}

Advanced Search with Integer attribute - less then unlimited
    [Documentation]
    ...	operator for Integer attribute:
    ...	equals 	
    ...	does not equal
    ...	greater than
    ...	less then
    ...	empty or not applicable
    ...	applicable
    ...	unlimited 
    [Tags]    regression
    # less then
    Log	less then
    ${CONDITION}=       Create Dictionary    key=sockets    operator=less then		value=unlimited
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}		${SEARCH_INFO}
	Should Be Equal     ${STATUS}      400
	${SUCCESS_MSG}= 	Set Variable	'{u'operator': u'less then', u'value': u'unlimited', u'key': u'sockets'}' is not a valid query
	Should Be Equal		${MSG}	${SUCCESS_MSG}

Advanced Search with Integer attribute - empty or not applicable
    [Documentation]
    ...	operator for Integer attribute:
    ...	equals 	
    ...	does not equal
    ...	greater than
    ...	less then
    ...	empty or not applicable
    ...	applicable
    ...	unlimited 
    [Tags]    regression
    # empty or not applicable
    Log	empty or not applicable
    ${CONDITION}=       Create Dictionary    key=virt_limit    operator=empty or not applicable
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}		${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG} 
	:For	${i}	IN	@{MSG}
	\	Log		${i['id']} ${i['virt_limit']}
	\	Should Be Equal     ${i['virt_limit']}     n/a

Advanced Search with Integer attribute - applicable    
    [Documentation]
    ...	operator for Integer attribute:
    ...	equals 	
    ...	does not equal
    ...	greater than
    ...	less then
    ...	empty or not applicable
    ...	applicable
    ...	unlimited 
    [Tags]    regression
    # applicable
    Log	applicable
    ${CONDITION}=       Create Dictionary    key=virt_limit    operator=applicable
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}		${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG} 
	:For	${i}	IN	@{MSG}
	\	Log		${i['id']} ${i['virt_limit']}
	\	Should Not Be Equal     ${i['virt_limit']}     n/a

Advanced Search with Integer attribute - unlimited
    [Documentation]
    ...	operator for Integer attribute:
    ...	equals 	
    ...	does not equal
    ...	greater than
    ...	less then
    ...	empty or not applicable
    ...	applicable
    ...	unlimited 
    [Tags]    regression
    # unlimited
    Log	unlimited 
    ${CONDITION}=       Create Dictionary    key=virt_limit    operator=unlimited
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}		${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG} 
	:For	${i}	IN	@{MSG}
	\	Log		${i['id']} ${i['virt_limit']}
	\	Should Be Equal     ${i['virt_limit']}     unlimited
	
Advanced Search with Boolean attribute - equals True
    [Documentation]	Boolean attribute:	such as, virt_only is True
    ...	operator: equals
    [Tags]    regression
    ${boolean_true}=	Convert To Boolean	True
    ${CONDITION}=       Create Dictionary    key=virt_only    operator=equals	value=${boolean_true}
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}		${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG} 
	:For	${i}	IN	@{MSG}
	\	Log		${i['id']} ${i['virt_only']}
	\	Should Be Equal     ${i['virt_only']}     True
	
Advanced Search with Boolean attribute - equals False
    [Documentation]	Boolean attribute:	such as, virt_only is True
    ...	operator: equals
    [Tags]    regression
    ${boolean_false}=	Convert To Boolean	False
    ${CONDITION}=       Create Dictionary    key=virt_only    operator=equals	value=${boolean_false}
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}		${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG} 
	:For	${i}	IN	@{MSG}
	\	Log		${i['id']} ${i['virt_only']}
	\	Should Be Equal     ${i['virt_only']}     False

Advanced Search with Boolean attribute - equals 1
    [Documentation]	Boolean attribute:	such as, virt_only is True
    ...	operator: equals
    [Tags]    regression
    ${integer_number}=	Convert To Integer	1
    ${boolean_true}=	Convert To Boolean	${integer_number}
    ${CONDITION}=       Create Dictionary    key=virt_only    operator=equals	value=${boolean_true}
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}		${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG} 
	:For	${i}	IN	@{MSG}
	\	Log		${i['id']} ${i['virt_only']}
	\	Should Be Equal     ${i['virt_only']}     True

Advanced Search with Boolean attribute - equals 8000
    [Documentation]	Boolean attribute:	such as, virt_only is True
    ...	operator: equals
    [Tags]    regression
    ${integer_number}=	Convert To Integer	8000
    ${boolean_true}=	Convert To Boolean	${integer_number}
    ${CONDITION}=       Create Dictionary    key=virt_only    operator=equals	value=${boolean_true}
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}		${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG} 
	:For	${i}	IN	@{MSG}
	\	Log		${i['id']} ${i['virt_only']}
	\	Should Be Equal     ${i['virt_only']}     True
	
Advanced Search with Boolean attribute - equals 0
    [Documentation]	Boolean attribute:	such as, virt_only is True
    ...	operator: equals
    [Tags]    regression
    ${integer_zero}=	Convert To Integer	0
    ${boolean_false}=	Convert To Boolean	${integer_zero}
    ${CONDITION}=       Create Dictionary    key=virt_only    operator=equals	value=${boolean_false}
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}		${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG} 
	:For	${i}	IN	@{MSG}
	\	Log		${i['id']} ${i['virt_only']}
	\	Should Be Equal     ${i['virt_only']}     False
    
Advanced Search with Arch contains invalid arch
    [Documentation]	invalid arch: auch as xx888
    [Tags]    regression
    ${CONDITION}=       Create Dictionary    key=arch    operator=contains  value=xx86_64
	${SEARCH_INFO}=     Create List     ${CONDITION}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}		${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG} 
	Should Be Equal As Integers		${length}	0
	
Advanced Search with String attribute is equals and does not contain
    [Documentation]
    [Tags]    regression
    ${CONDITION1}=       Create Dictionary    key=ph_product_line    operator=equals  value=RHEL
    ${CONDITION2}=       Create Dictionary    key=ph_product_line    operator=does not contain  value=RHEL
	${SEARCH_INFO}=     Create List     ${CONDITION1}	${CONDITION2}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}		${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG} 
	Should Be Equal As Integers		${length}	0
    
Advanced Search with String attribute is applicable and empty or not applicable
    [Documentation]
    [Tags]    regression
    ${CONDITION1}=       Create Dictionary    key=stacking_id     operator=applicable
    ${CONDITION2}=       Create Dictionary    key=stacking_id     operator=empty or not applicable
	${SEARCH_INFO}=     Create List     ${CONDITION1}	${CONDITION2}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}		${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG} 
	Should Be Equal As Integers		${length}	0
    
Advanced Search with Integer attribute equals and does not equal
    [Documentation]
    [Tags]    regression
    ${sockets_integer}=		Convert to Integer	20
    ${CONDITION1}=       Create Dictionary    key=sockets    operator=equals  value=${sockets_integer}
    ${CONDITION2}=       Create Dictionary    key=sockets    operator=does not equal  value=${sockets_integer}
	${SEARCH_INFO}=     Create List     ${CONDITION1}	${CONDITION2}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}		${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG} 
	Should Be Equal As Integers		${length}	0
    
Advanced Search with Integer attribute is applicable and empty or not applicable
    [Documentation]
    [Tags]    regression
    ${CONDITION1}=       Create Dictionary    key=sockets    operator=applicable
    ${CONDITION2}=       Create Dictionary    key=sockets    operator=empty or not applicable
	${SEARCH_INFO}=     Create List     ${CONDITION1}	${CONDITION2}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}		${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG} 
	Should Be Equal As Integers		${length}	0
    
Advanced Search with Integer attribute is less than and greater than one same number
    [Documentation]
    [Tags]    regression
    ${sockets_integer}=		Convert to Integer	20
    ${CONDITION1}=       Create Dictionary    key=sockets    operator=greater than	value=${sockets_integer}
    ${CONDITION2}=       Create Dictionary    key=sockets    operator=less then	value=${sockets_integer}
	${SEARCH_INFO}=     Create List     ${CONDITION1}	${CONDITION2}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}		${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG} 
	Should Be Equal As Integers		${length}	0
    
Advanced Search with Boolean attribute is False and True
    [Documentation]	such as, Virt-only is False and Virt-only is True
    [Tags]    regression
    ${boolean_true}=	Convert To Boolean	True
    ${boolean_false}=	Convert To Boolean	False
    ${CONDITION1}=       Create Dictionary    key=multi_entitlement    operator=equals	value=${boolean_true}
    ${CONDITION2}=       Create Dictionary    key=multi_entitlement    operator=equals	value=${boolean_false}
	${SEARCH_INFO}=     Create List     ${CONDITION1}	${CONDITION2}
	${STATUS}  ${MSG}=     POST   ${SEARCH_URL}		${SEARCH_INFO}
	Should Be Equal     ${STATUS}      200
	${length}= 	Get Length 	${MSG} 
	Should Be Equal As Integers		${length}	0
	
*** Keywords ***
    	