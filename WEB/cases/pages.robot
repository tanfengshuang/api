*** Settings ***
Documentation     How to manage accounts using account management tool
Resource          ../resources/global.robot
Suite Setup       Open Browser  ${FRONT_PAGE}   ${BROWSER}
Suite Teardown    Close All Browsers

*** Variables ***


*** Test Cases ***
Succeed to open home page
    [Documentation]
    [Tags]    regression 
    Go to Front Page
    Manage Account Page

Succeed to switch to Search SKU Catalog
    [Documentation]
    [Tags]    regression 
    Go to Front Page
    Search SKU Catalog Page	
	
Succeed to switch back to Manage Account Page 
    [Documentation]
    [Tags]    regression 
    Go to Front Page
    Click Link       Search SKU Catalog
    Manage Account Page
    Click Link       Manage Accounts
    Search SKU Catalog Page 

Verify url location
	[Documentation]
    [Tags]    regression 
    Go to Front Page
    ${location}=	Get location
    Should be Equal		${location}		${FRONT_PAGE}/

Verify window title
	[Documentation]
    [Tags]    regression 
	${t}=	Get Window Titles

Test Work Flow - Create View Attach Refresh
	[Documentation]
    [Tags]    regression 
    Go to Front Page

Test Work Flow - Create Activate View Attach Refresh
	[Documentation]
    [Tags]    regression 
    Go to Front Page
    
Verify Home link
	[Documentation]
    [Tags]    regression 
    Go to Front Page
    
Verify Help part
	[Documentation]
    [Tags]    regression 
    Go to Front Page

          
*** Keywords ***
Manage Account Page
    Page should contain link 	Manage Accounts
    Page should contain link 	Search SKU Catalog
    Page should contain link  	Create Account
    Page should contain link  	View Account
    Page should contain link	Activate Account
    Page should contain link  	Import or Export
    Page should contain link  	Add Subscriptions
    Page should contain link  	Refresh Subscriptions
    
Search SKU Catalog Page
    Page should contain link  Search
    Page should contain link  Advanced search	