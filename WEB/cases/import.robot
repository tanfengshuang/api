*** Settings ***
Documentation     How to manage accounts using account management tool
Resource          ../resources/global.robot
Suite Setup	Suite Setup Steps
Test Setup	Test Setup Steps
Test Teardown	Test Teardown Steps
Suite Teardown	Suite Teardown Steps

*** Variables ***
${DIR_PATH}		./csv/
${FILE_PATH}	./csv/test.csv

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

Import or Export with username, password, sku and quantity
    [Documentation]
    [Tags]    regression
    # Import
    ${username}=	Generate Username
    ${account_info}=	Catenate	${username},${PASSWORD},${SKU},${QUANTITY}
    Generate CSV File
    
    Empty Directory		
    #Create Directory
	Create File
	Append To File

	Choose File			xpath=//*[@id='filename']	./csv/test.csv
	# Export
	
	
Import account with existing username, password and several skus
    [Documentation]
    [Tags]    regression
    Log     Waiting   
 
Import account with several usernames
    [Documentation]     Including new username and existing username
    [Tags]    regression
    Log     Waiting 
     
Import account with existing username, password, null sku and password
    [Documentation]
    [Tags]    regression
    Log     Waiting  

Import account with existing username, password, invalid sku and password
    [Documentation]
    [Tags]    regression
    Log     Waiting  
    
Import account with existing username, password, sku and null quantity
    [Documentation]
    [Tags]    regression
    Log     Waiting  
    
Import account with existing username, password, sku and negative quantity
    [Documentation]
    [Tags]    regression
    Log     Waiting 

Import account with invalid sku and quantity pairs
    [Documentation]     
    [Tags]    regression
    Log     Waiting 
    
Import account with new username, password, sku and password
    [Documentation]
    [Tags]    regression
    Log     Waiting  
    
Import account with new username, password and several skus
    [Documentation]
    [Tags]    regression
    Log     Waiting  

Import account with new username, password, null sku and quantity
    [Documentation]
    [Tags]    regression
    Log     Waiting  

Import account with new username, password, invalid sku and quantity
    [Documentation]
    [Tags]    regression
    Log     Waiting

Import account with new username, password, sku and null quantity
    [Documentation]
    [Tags]    regression
    Log     Waiting
    
Import account with new username, password, sku and negative quantity
    [Documentation]
    [Tags]    regression
    Log     Waiting

Import account with username including special charactor and password
    [Documentation]
    [Tags]    regression
    Log     Waiting 

Import account with existing username, password including special charactor
    [Documentation]
    [Tags]    regression
    Log     Waiting 
        

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
	Close All Browsers
	Log	Suite End...