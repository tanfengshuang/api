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
    Click Link	Search SKU Catalog
    Search SKU Catalog Page	
	
Succeed to switch back to Manage Account Page 
    [Documentation]
    [Tags]    regression 
    Go to Front Page
    Click Link       Search SKU Catalog
    Manage Account Page
    Click Link       Manage Accounts
    Search SKU Catalog Page 

Verify window title
	[Documentation]
    [Tags]    regression 
	${title}=	Get Window Titles
    Should be Equal		${title}		${TITLE}

Verify url location
	[Documentation]
    [Tags]    regression 
    Go to Front Page
    Location Should Be	${FRONT_PAGE}
    #${location}=	Get location	${FRONT_PAGE}
    #Should be Equal		${location}		${FRONT_PAGE}
    
    Click Link			Create Account
    Location Should Be	${CREATE_PAGE}
    
    Click Link			View Account
    Location Should Be	${VIEW_PAGE}
    
    Click Link			Activate Account
    Location Should Be	${ACTIVATE_PAGE}
    
    Click Link			Import or Export
    Location Should Be	${IMPORT_EXPORT_PAGE}
    
    Click Link			Add Subscriptions
    Location Should Be	${ENTITLE_PAGE}
    
    Click Link			Refresh Subscriptions
    Location Should Be	${REFRESH_PAGE}
    
    Click Link	Search SKU Catalog
    Click Link			Search
    Location Should Be	${SEARCH_PAGE}
    
    Click Link			Advanced search
    Location Should Be	${ADVANCED_SEARCH_PAGE}

Verify link redirect
	[Documentation]
    [Tags]    regression 
    Go to Front Page
    Go To    ${ROOT}
    
    Go To    ${CREATE_PAGE}
    Page Should Contain	Create Account
    
    Go To    ${VIEW_PAGE}
    Page Should Contain	View Account
    
    Go To    ${ACTIVATE_PAGE}
    Page Should Contain	Activate Account
    
    Go To    ${IMPORT_EXPORT_PAGE}
    Page Should Contain	Import or Export
        
    Go To    ${ENTITLE_PAGE}
    Page Should Contain	Add Subscriptions
    
    Go To    ${REFRESH_PAGE}
    Page Should Contain 	Refresh Subscriptions
    
    Go To    ${SEARCH_PAGE}
    Page Should Contain 	Search results

    Go To    ${ADVANCED_SEARCH_PAGE}
    Page Should Contain 	Search results
    Page Should Contain 	Add another filter

          
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