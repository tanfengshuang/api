*** Setting ***
Library           Collections
Library           OperatingSystem
Library           String
Library           BuiltIn
Library           Dialogs
Library				Screenshot
Library           Selenium2Library    run_on_failure=Capture Page Screenshot    implicit_wait=0

*** Variables ***
${SERVER}         10.3.12.152
#${SERVER}			localhost:8080
${BROWSER}        firefox
#${BROWSER}        chrome
${REMOTE_URL}     ${NONE}
${DESIRED_CAPABILITIES}    ${NONE}
${ROOT}           http://${SERVER}
${FRONT PAGE}     ${ROOT}
${SPEED}          0

${BUG_URL}			https://engineering.redhat.com/trac/content-tests/newticket?component=Stage+Account+Management+Tool&milestone=Account+Tool&type=account+tool+defect&cc=entitlement-qe@redhat.com
${STAGE_PORTAL_URL}		https://access.stage.redhat.com/

${FIRST_NAME}		Fengshuang
${LAST_NAME}		Tan
${EXISTING_USERNAME}    aaa 
${PASSWORD}             redhat
${WRONG_PASSWORD}       redhat111
${SPECIAL_USERNAME}		special_username	
${SPECIAL_PASSWORD}		redhat\\\\
${SKU}                  RH0103708
${SKUS}                 RH0103708,MCT1111,RH0103708AAA,MCT1316F3,MCT1339 
${WRONG_SKU}            RH0103708AAA
${WRONG_SKUS}           RH0103708AAA,MCT1316F3BBB
${QUANTITY}             100
${NEGTIVE_QUANTITY}    -1 

*** Keywords ***
Generate Username
    [Documentation]
    [Tags]    global
    ${time}    Get Time    epoch
    ${random_str}=    Generate Random String    length=4    chars=[LOWER]
    ${username}=    Catenate    user${time}${random_str}
    #${create_info}    Create Dictionary     username=${username}    password=${password}
    [Return]    ${username}

Open Account Test Page
    [Documentation]
	[Arguments]   ${TEST_PAGE}
	Maximize Browser Window
    Go to Front Page
    Wait Until Page Contains Element   link=${TEST_PAGE}
    Click Link       ${TEST_PAGE}

Success Created
    [Documentation]
	[Arguments]   ${TEST_USERNAME}
    ${SUCCESS_MESSAGE}=   Catenate  Creating account "${TEST_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=20
    ${SUCCESS_MESSAGE}=   Catenate  Accepting Ts&Cs for "${TEST_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=20 
    #${SUCCESS_MESSAGE}=   Catenate  Mapping account into Candlepin
    ${SUCCESS_MESSAGE}=   Set Variable  Creating account owners in Candlepin
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=20
    ${SUCCESS_MESSAGE}=   Catenate  Account "${TEST_USERNAME}" created
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=20
    #${SUCCESS_MESSAGE}=   Catenate  Userspace for "${TEST_USERNAME}" account's subscriptions prepared.
    #Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=20

Success Created and Attach
 	[Documentation] 
 	[Arguments]   ${TEST_USERNAME}	${SKUS}  
 	Log	 Waiting

Created without accepting terms
	[Documentation]
	[Arguments]   ${TEST_USERNAME}
	${SUCCESS_MESSAGE}=   Catenate  Creating account "${TEST_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=20 
    ${SUCCESS_MESSAGE}=   Catenate  Creating account owners in Candlepin
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=40 
    ${SUCCESS_MESSAGE}=   Catenate  Account "${TEST_USERNAME}" created
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=40 

Check Terms Status
	[Documentation]	
	[Arguments]   ${TEST_USERNAME}	${CONTENT}
	Open Browser	${STAGE_PORTAL_URL}   ${BROWSER}
	Maximize Browser Window	
	Wait Until Page Contains	Log In		timeout=100
	Click Element		xpath=//*[@id='home-login-btn']
	Wait Until Page Contains	Log in to your Red Hat account		timeout=100
	Input Text     id=username    ${TEST_USERNAME}
	Input Text     id=password    ${PASSWORD}
    Click Element  id=_eventId_submit
    Wait Until Page Contains	${CONTENT}
	
Success Attached
	[Documentation]
	[Arguments]   ${TEST_USERNAME}
	${SUCCESS_MESSAGE}=   Catenate  Accepting Ts&Cs for "${TEST_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=50
    ${SUCCESS_MESSAGE}=   Catenate  Attaching subscriptions to "${TEST_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	timeout=20
    ${SUCCESS_MESSAGE}=   Set Variable  	All pools successfully attached
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	    timeout=500

Success Attached without accepting terms
	[Documentation]
	[Arguments]   ${TEST_USERNAME}
    ${SUCCESS_MESSAGE}=   Catenate  Attaching subscriptions to "${TEST_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}
    ${SUCCESS_MESSAGE}=   Set Variable  	All pools successfully attached
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	    timeout=500
    
Success Refreshed
	[Documentation]
	[Arguments]   ${TEST_USERNAME}
    ${SUCCESS_MESSAGE}=   Catenate  Refreshing subscriptions for "${TEST_USERNAME}"
    Wait Until Page Contains   ${SUCCESS_MESSAGE}		timeout=500
    ${SUCCESS_MESSAGE}=   Set Variable  	All pools successfully refreshed
    Wait Until Page Contains   ${SUCCESS_MESSAGE}	    timeout=500
        
Test File a bug Link
	[Documentation]
	Wait Until Page Contains Element		link=File a bug
    # Test File a bug later
    Click Element	link=File a bug
    #Open Browser	${BUG_URL}		${BROWSER}
    Select Window	url=${BUG_URL}
    Maximize Browser Window
	Wait Until Page Contains	Create New Ticket 
	Select Window

Open Browser To Start Page
    [Documentation]    This keyword also tests 'Set Selenium Speed' and 'Set Selenium Timeout'
    ...    against all reason.
    ${default speed}    ${default timeout} =    Open Browser To Start Page Without Testing Default Options
    Should Be Equal    ${default speed}    0 seconds
    Should Be Equal    ${default timeout}    5 seconds

Open Browser To Start Page Without Testing Default Options
    [Documentation]    Open Browser To Start Page Without Testing Default Options
    Open Browser    ${FRONT PAGE}    ${BROWSER}    remote_url=${REMOTE_URL}
    ...    desired_capabilities=${DESIRED_CAPABILITIES}
    ${orig speed} =    Set Selenium Speed    ${SPEED}
    ${orig timeout} =    Set Selenium Timeout    10 seconds
    [Return]    ${orig speed}    5 seconds

Open Browser To Start Page And Test Implicit Wait
    [Arguments]    ${implicit_wait}
    [Documentation]    This keyword tests that 'Set Selenium Implicit Wait' and
    ...    'Get Selenium Implicit Wait' work as expected
    Should Not Be Equal    0    ${implicit_wait}
    ...    Please do not pass in a value of 0 for the implicit wait argument for this function
    ${old_wait}=    Set Selenium Implicit Wait    ${implicit_wait}
    Open Browser    ${FRONT PAGE}    ${BROWSER}    remote_url=${REMOTE_URL}
    ...    desired_capabilities=${DESIRED_CAPABILITIES}
    ${default_implicit_wait} =    Get Selenium Implicit Wait
    Should Be Equal    ${implicit_wait} seconds    ${default_implicit_wait}
    #be sure to revert the implicit wait to whatever it was before so as to not effect other tests
    Set Selenium Implicit Wait    ${old_wait}

Cannot Be Executed In IE
    [Documentation]    Cannot Be Executed In IE
    ${runsInIE}=    Set Variable If    "${BROWSER}".replace(' ', '').lower() in ['ie', '*iexplore', 'internetexplorer']    ${TRUE}
    Run Keyword If    ${runsInIE}    Set Tags    ie-incompatible
    Run Keyword If    ${runsInIE}    Fail And Set Non-Critical
    ...    This test does not work in Internet Explorer

Fail And Set Non-Critical
    [Arguments]    ${msg}
    [Documentation]    Fails And Set Non-Critical
    Remove Tags    regression
    Fail    ${msg}

Go to Front Page
    [Documentation]    Goes to front page
    Go To    ${FRONT PAGE}

Go To Page "${relative url}"
    [Documentation]    Goes to page
    Go To    ${ROOT}/${relative url}

Set ${level} Loglevel
    [Documentation]    Sets loglevel
    Set Log Level    ${level}

Verify Location Is "${relative url}"
    [Documentation]    Verifies location
    Location Should Be    ${ROOT}/${relative url}
