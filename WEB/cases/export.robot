*** Settings ***
Documentation     How to manage accounts using account management tool
Resource          ../resources/global.robot
Suite Setup       Open Browser  ${FRONT_PAGE}   ${BROWSER}
Suite Teardown    Close All Browsers



*** Variables ***


*** Test Cases ***
Export accounts - check url location
    [Documentation]
    [Tags]    regression
  
Export accounts - check required field
    [Documentation]
    [Tags]    regression
  
Export accounts - check input default info
    [Documentation]
    [Tags]    regression
  
Export accounts - check page title
    [Documentation]
    [Tags]    regression
  
Export accounts - check help info
    [Documentation]
    [Tags]    regression

Export account with existing username and password
    [Documentation]
    [Tags]    regression
    Log     Waiting   

Export account with several username and password pairs
    [Documentation]
    [Tags]    regression
    Log     Waiting 
    
Export account without any sku
    [Documentation]
    [Tags]    regression
    Log     Waiting 
        
Export account with existing username and null password
    [Documentation]
    [Tags]    regression
    Log     Waiting  
    
Export account with existing username and wrong password
    [Documentation]
    [Tags]    regression
    Log     Waiting  

Export account with wrong username and password pairs
    [Documentation]
    [Tags]    regression
    Log     Waiting 

Export account with not existing username and password
    [Documentation]
    [Tags]    regression
    Log     Waiting  

Export with username including special character, password
    [Documentation]
    [Tags]    regression
    Log     Waiting 

Export with existing username, password including special charactor
    [Documentation]
    [Tags]    regression
    Log     Waiting 
        

*** Keywords ***