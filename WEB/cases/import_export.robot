*** Settings ***
Documentation     How to manage accounts using account management tool
Resource          ../resources/global.robot
Suite Setup	Suite Setup Steps
Test Setup	Test Setup Steps
Test Teardown	Test Teardown Steps
Suite Teardown	Suite Teardown Steps

*** Variables ***
${DIR_PATH}		/tmp/csv
${FILE_PATH}	${DIR_PATH}/test.csv

*** Test Cases ***    
Import or Export - verify url location
    [Documentation]
    [Tags]    regression
	Location Should Be	${IMPORT_EXPORT_PAGE}
  
Import or Export - verify required field
    [Documentation]
    [Tags]    regression
    Click Link		Export
    # <input id="username" class="form-control" type="text" value="" title="Login must be at least 5 characters long (up to 255) and cannot contain spaces or the following special characters: (") ($) (^) (<) (>) (|) (+) (%) (/) (;) (:) (,) (\) (*) (=) (~)" required="" placeholder="login" pattern="^[^\s"$\^<>|+%\/;:,\\*=~]{5,255}$" name="username" minlenght="5" maxlength="255"/>
    ${REQUIRED}=	Get Element Attribute	${Export_Username_Link}@required
	Should Be Equal		${REQUIRED}		true
	${REQUIRED}=	Get Element Attribute	${Export_Password_Link}@required
	Should Be Equal		${REQUIRED}		true
  
Import or Export - verify input default info
    [Documentation]
    [Tags]    regression
    Click Link		Export
    ${INFO}=	Get Element Attribute	${Export_Username_Link}@placeholder
	Should Be Equal		${INFO}		login
	${INFO}=	Get Element Attribute	${Export_Password_Link}@placeholder
	Should Be Equal		${INFO}		password
  
Import or Export - verify page title
    [Documentation]
    [Tags]    regression
    ${INFO}=	Get Text	xpath=//*[@id='import_export']/ol/li[1]/a
    Should Be Equal		${INFO}		Home
    ${INFO}=	Get Text	xpath=//*[@id='import_export']/ol/li[2]/strong
	Should Be Equal		${INFO}		Accounts
	${INFO}=	Get Text	xpath=//*[@id='import_export']/ol/li[3]
	Should Be Equal		${INFO}		Import or Export	

Import or Export an account with username, password, sku and quantity
    [Documentation]
    [Tags]    regression
    # - Import an account
    # 1. Generate csv file content 
    ${username}=	Generate Username
    ${account_info}=	Catenate	${username},${PASSWORD},${SKU},${QUANTITY},
    
    # 2. Create/Empty csv directory and create new csv file for testing
    Create Directory	${DIR_PATH}
    Empty Directory	${DIR_PATH}
	Create File	${FILE_PATH}	content=${account_info}	encoding=UTF-8

	# 3. Upload csv file
	Choose File		xpath=//*[@id='filename']	${FILE_PATH}

	# 4. Click Import button
	Wait Until Page Contains Element   xpath=${Import_Import_Link}
	Click Element	xpath=${Import_Import_Link}
	
	# 5. Verify floating msgs
	${SUCCESS_MESSAGE}=	Set Variable	Importing accounts
	Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=100
	${SUCCESS_MESSAGE}=	Catenate	Successfully imported account(s): ${username}
	Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=100
	
	# 6. 
	Mouse Over	xpath=${Import_FirstAccountItem_Link}
	Page Should Contain	Empty account created
	Page Should Contain	All pools attached
	Page Should Contain	Refresh successfull
	Page Should Contain	Ts&Cs accepted
	Page Should Contain	Done
	
	# - Export the account
	Click Link	Export
	Input Text	xpath=${Export_Username_Link}	${username}
	Input Text	xpath=${Export_Password_Link}	${PASSWORD}
	Click Element	xpath=${Export_Import_Link}
	
	${SUCCESS_MESSAGE}=	Set Variable	Exporting accounts
	Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=100
	${SUCCESS_MESSAGE}=	Catenate	Exported account(s): ${username}
	Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=100
	
	#exported_accounts.csv
	
	
Import or Export an account with username, password, skus and quantity
    [Documentation]
    [Tags]    regression
    # - Import an account
    # 1. Generate csv file content 
    ${username}=	Generate Username
    ${account_info}=	Catenate	${username},${PASSWORD},${SKUS},${QUANTITY},
    
    # 2. Create/Empty csv directory and create new csv file for testing
    Create Directory	${DIR_PATH}
    Empty Directory	${DIR_PATH}
	Create File	${FILE_PATH}	content=${account_info}	encoding=UTF-8

	# 3. Upload csv file
	Choose File		xpath=//*[@id='filename']	${FILE_PATH}

	# 4. Click Import button
	Wait Until Page Contains Element   xpath=${Import_Import_Link}
	Click Element	xpath=${Import_Import_Link}
	
	# 5. Verify floating msgs
	${SUCCESS_MESSAGE}=	Set Variable	Importing accounts
	Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=100
	${SUCCESS_MESSAGE}=	Catenate	Successfully imported account(s): ${username}
	Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=100
	
	# 6. 
	Mouse Over	xpath=${Import_FirstAccountItem_Link}
	Page Should Contain	Empty account created
	Page Should Contain	All pools attached
	Page Should Contain	Refresh successfull
	Page Should Contain	Ts&Cs accepted
	Page Should Contain	Done
	
	# - Export the account
	Click Link	Export
	Input Text	xpath=${Export_Username_Link}	${username}
	Input Text	xpath=${Export_Password_Link}	${PASSWORD}
	Click Element	xpath=${Export_Import_Link}
	
	${SUCCESS_MESSAGE}=	Set Variable	Exporting accounts
	Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=100
	${SUCCESS_MESSAGE}=	Catenate	Exported account(s): ${username}
	Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=100
	
	#exported_accounts.csv   
 
Import account with several usernames
    [Documentation]     Including new username and existing username
    [Tags]    regression
    Log     Waiting 
     
Import account with username, password, null sku and password
    [Documentation]
    [Tags]    regression
    # 1. Generate csv file content 
    ${username}=	Generate Username
    ${account_info}=	Catenate	${username},${PASSWORD},,${QUANTITY}
    
    # 2. Create/Empty csv directory and create new csv file for testing
    Create Directory	${DIR_PATH}
    Empty Directory	${DIR_PATH}
	Create File	${FILE_PATH}	content=${account_info}	encoding=UTF-8

	# 3. Upload csv file
	Choose File		xpath=//*[@id='filename']	${FILE_PATH}

	# 4. Click Import button
	Wait Until Page Contains Element   xpath=${Import_Import_Link}
	Click Element	xpath=${Import_Import_Link}
	
	# 5. Verify floating msgs
	${SUCCESS_MESSAGE}=	Set Variable	Importing accounts
	Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=100
	${SUCCESS_MESSAGE}=	Catenate	Successfully imported account(s): ${username}
	Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=100
	
	# 6. 
	Mouse Over	xpath=${Import_FirstAccountItem_Link}
	Page Should Contain	Empty account created
	Page Should Contain	All pools attached
	Page Should Contain	Refresh successfull
	Page Should Contain	Ts&Cs accepted
	Page Should Contain	Done

Import account with username, password, invalid sku and password
    [Documentation]
    [Tags]    regression
    # 1. Generate csv file content 
    ${username}=	Generate Username
    ${account_info}=	Catenate	${username},${PASSWORD},${INVALID_SKU},${QUANTITY}
    
    # 2. Create/Empty csv directory and create new csv file for testing
    Create Directory	${DIR_PATH}
    Empty Directory	${DIR_PATH}
	Create File	${FILE_PATH}	content=${account_info}	encoding=UTF-8

	# 3. Upload csv file
	Choose File		xpath=//*[@id='filename']	${FILE_PATH}

	# 4. Click Import button
	Wait Until Page Contains Element   xpath=${Import_Import_Link}
	Click Element	xpath=${Import_Import_Link}
	
	# 5. Verify floating msgs
	${SUCCESS_MESSAGE}=	Set Variable	Importing accounts
	Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=100
	${SUCCESS_MESSAGE}=	Catenate	Failed to import account(s): ${username}
	Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=100
	
	# 6. 
	Mouse Over	xpath=${Import_FirstAccountItem_Link}
	Page Should Contain	Empty account created
	${INVALID_SKU_LIST}=	Split String	${INVALID_SKU}	,
    Page Should Contain	Bad request: Value of 'sku (${INVALID_SKU_LIST})' parameter is not valid input
    
Import account with username, password, sku and null quantity
    [Documentation]
    [Tags]    regression
    # 1. Generate csv file content 
    ${username}=	Generate Username
    ${account_info}=	Catenate	${username},${PASSWORD},${SKU},,
    
    # 2. Create/Empty csv directory and create new csv file for testing
    Create Directory	${DIR_PATH}
    Empty Directory	${DIR_PATH}
	Create File	${FILE_PATH}	content=${account_info}	encoding=UTF-8

	# 3. Upload csv file
	Choose File		xpath=//*[@id='filename']	${FILE_PATH}

	# 4. Click Import button
	Wait Until Page Contains Element   xpath=${Import_Import_Link}
	Click Element	xpath=${Import_Import_Link}
	
	# 5. Verify floating msgs
	${SUCCESS_MESSAGE}=	Set Variable	Importing accounts
	Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=100
	${SUCCESS_MESSAGE}=	Catenate	Failed to import account(s): ${username}
	Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=100
	
	# 6. 
	Mouse Over	xpath=${Import_FirstAccountItem_Link}
	Page Should Contain	Empty account created
	Page Should Contain	Bad request: Value of 'quantity' parameter is not valid input, reason: Quantity has to be of integer type and greater than 0
    
Import account with username, password, sku and negative quantity
    [Documentation]
    [Tags]    regression
    # 1. Generate csv file content 
    ${username}=	Generate Username
    ${account_info}=	Catenate	${username},${PASSWORD},${SKU},${NEGTIVE_QUANTITY}
    
    # 2. Create/Empty csv directory and create new csv file for testing
    Create Directory	${DIR_PATH}
    Empty Directory	${DIR_PATH}
	Create File	${FILE_PATH}	content=${account_info}	encoding=UTF-8

	# 3. Upload csv file
	Choose File		xpath=//*[@id='filename']	${FILE_PATH}

	# 4. Click Import button
	Wait Until Page Contains Element   xpath=${Import_Import_Link}
	Click Element	xpath=${Import_Import_Link}
	
	# 5. Verify floating msgs
	${SUCCESS_MESSAGE}=	Set Variable	Importing accounts
	Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=100
	${SUCCESS_MESSAGE}=	Catenate	Failed to import account(s): ${username}
	Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=100
	
	# 6. 
	Mouse Over	xpath=${Import_FirstAccountItem_Link}
	Page Should Contain	Empty account created
	Page Should Contain	Bad request: Value of 'quantity' parameter is not valid input, reason: Quantity has to be of integer type and greater than 0
	

Import or Export an account with username including special charactor and password
    [Documentation]
    [Tags]    regression
    Log     Waiting 

Import or Export an account with existing username, password including special charactor
    [Documentation]
    [Tags]    regression
    Log     Waiting 
    
Import or Export an account without any sku
    [Documentation]
    [Tags]    regression
    # - Import an account
    # 1. Generate csv file content 
    ${username}=	Generate Username
    ${account_info}=	Catenate	${username},${PASSWORD}
    
    # 2. Create/Empty csv directory and create new csv file for testing
    Create Directory	${DIR_PATH}
    Empty Directory	${DIR_PATH}
	Create File	${FILE_PATH}	content=${account_info}	encoding=UTF-8

	# 3. Upload csv file
	Choose File		xpath=//*[@id='filename']	${FILE_PATH}

	# 4. Click Import button
	Wait Until Page Contains Element   xpath=${Import_Import_Link}
	Click Element	xpath=${Import_Import_Link}
	
	# 5. Verify floating msgs
	${SUCCESS_MESSAGE}=	Set Variable	Importing accounts
	Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=100
	${SUCCESS_MESSAGE}=	Catenate	Successfully imported account(s): ${username}
	Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=100
	
	# 6. 
	Mouse Over	xpath=${Import_FirstAccountItem_Link}
	Page Should Contain	Empty account created
	Page Should Contain	All pools attached
	Page Should Contain	Refresh successfull
	Page Should Contain	Ts&Cs accepted
	Page Should Contain	Done
	
	# - Export the account
	Click Link	Export
	Input Text	xpath=${Export_Username_Link}	${username}
	Input Text	xpath=${Export_Password_Link}	${PASSWORD}
	Click Element	xpath=${Export_Import_Link}
	
	${SUCCESS_MESSAGE}=	Set Variable	Exporting accounts
	Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=100
	${SUCCESS_MESSAGE}=	Catenate	Exported account(s): ${username}
	Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=100
	
	#exported_accounts.csv 
    
Export account with existing username and wrong password
    [Documentation]
    [Tags]    regression
	Click Link	Export
	Input Text	xpath=${Export_Username_Link}	${EXISTING_USERNAME}
	Input Text	xpath=${Export_Password_Link}	${WRONG_PASSWORD}
	Click Element	xpath=${Export_Import_Link}

	${SUCCESS_MESSAGE}=	Set Variable	Exporting accounts
	Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=100
	${SUCCESS_MESSAGE}=	Catenate	Failed to export account(s): ${EXISTING_USERNAME}
	Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=100

Export account with not existing username and password
    [Documentation]
    [Tags]    regression
    Click Link	Export
	Input Text	xpath=${Export_Username_Link}	${NOT_EXISTING_USERNAME}
	Input Text	xpath=${Export_Password_Link}	${PASSWORD}
	Click Element	xpath=${Export_Import_Link}

	${SUCCESS_MESSAGE}=	Set Variable	Exporting accounts
	Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=100
	${SUCCESS_MESSAGE}=	Catenate	Failed to export account(s): ${NOT_EXISTING_USERNAME}
	Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=100        

*** Keywords ***
Suite Setup Steps
	Log	Suite Begin...
	Open Browser  ${FRONT_PAGE}   ${BROWSER}
	Maximize Browser Window

Test Setup Steps
	Log	Suite Begin...   
    Go to Front Page
    Wait Until Page Contains Element   link=Import or Export
    Click Link       Import or Export
    Page should contain	Drag a file with backup here to import your accounts
    Capture Page Screenshot

Test Teardown Steps
	Capture Page Screenshot
	Log	Testing End...

Suite TearDown Steps
	#Close All Browsers
	Log	Suite End...