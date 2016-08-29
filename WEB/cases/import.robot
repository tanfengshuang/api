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

Import account with existing username, password, sku and quantity
    [Documentation]
    [Tags]    regression
    Log     Waiting     

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