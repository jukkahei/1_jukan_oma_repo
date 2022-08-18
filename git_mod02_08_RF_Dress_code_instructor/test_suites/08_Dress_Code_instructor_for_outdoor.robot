*** Settings ***
Suite Setup       Initialize
Suite Teardown    Cleanup
Library           SeleniumLibrary    ${SELENIUM_TIMEOUT}    ${SELENIUM_IMPLICIT_WAIT}
Library           Collections
Library           String
Library           XML
Library           ${OWN_WORKING_DIRECTORY}/lib/Send_email.py    #Library    Selenium2Library    #Library    ${OWN_WORKING_DIRECTORY}/lib/MyStaticLibrary.py
Library           ${OWN_WORKING_DIRECTORY}/lib/Find_right_mapping_table_row_based_on_temperature.py
Library           Dialogs
Library           OperatingSystem

*** Variables ***
${SELENIUM_TIMEOUT}    5
${SELENIUM_IMPLICIT_WAIT}    2
${SHORT_SLEEP}    0.1s
${BROWSER}        chrome
${WEB_PAGE}       https://en.ilmatieteenlaitos.fi/
#${LOCATION_FIELD_ID}    id=location-menu-input  Jukkahei: dont' work anymore 16.08.2022
${LOCATION_FIELD_ID}    //*[@id="header-search-location-field"]
# Note !!, Set    your own working directory path here if you are running this macro
#JukkaHei 16.08.2022 Changed ${OWN_WORKING_DIRECTORY}    C:/Users/heikkjuk/Tieto/Omat/Robot_Jmeter_apuja_asennusohjeita_etc/Hyvia_Robotti_faileja_Valalta/Valan_Robot_Framework_koulutusmatsku/oma_harjoittelu/mod02_08_RF_Dress_code_instructor
${OWN_WORKING_DIRECTORY}    C:/Users/ajukkhei/TIETO/Testiautomaatio/oma_harjoittelu_08_2022/mod02_08_RF_Dress_code_instructor

*** Test Cases ***
Ask info from the user
    [Tags]    smoke
    Log To Console    ajukkhei test log 1 ${BROWSER}
    # Below valid googlemail account is used for sending emails with    this macro
    # Note!!    First time when trying to use this macro, googlemail could refuse..
    # and you will get mail to that googlemail where it is said in finnish
    #"Google esti juuri kirjautumisen Google-tilillesi ajukkhei@gmail.com sovelluksesta, joka saattaa
    #vaarantaa tilisi". In that mail there is a link where user can allow robot framework to use the mail
    #for sending ... (reduced security level)
    ${ASKED_USERNAME} =    Get Value From User    Give some google mail username (needed for smtp mailserver.login)    ajukkhei@gmail.com
    # Important Note !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # It is possible that given password below can be see in the file debug.txt INFO log
    #20170112 10:56:07.770 - INFO - ${ASKED_PASSWORD} = Given password is shown here !
    #
    # See the web dicussion about this via the link below
    #https://github.com/robotframework/Selenium2Library/issues/202
    # 16.08.2022 JukkaHei: Ei enää toiminut sp-lähetys. gmail. vaatii applikaatiosalasanat, asetetaan google tilille security kohdassa about. ${ASKED_PASSWORD} =    Get Value From User    Give some google mail password (needed for smtp mailserver.login)    hidden=yes
    # 18.08.2022 JukkaHei: 2 test comment for training git usage
    Set Suite Variable    ${ASKED_PASSWORD}    sdyupgulgrwkxynd
    ${ASKED_TARGET_EMAIL_ADDRESS} =    Get Value From User    Give email address which weather and clothing info will be sent    ajukkhei@gmail.com
    ${ASKED_LOCATION} =    Get Value From User    Give Location
    #Set local parameters to be visible at this suite level
    Set Suite Variable    ${USERNAME}    ${ASKED_USERNAME}
    Set Suite Variable    ${PASSWORD}    ${ASKED_PASSWORD}
    Set Suite Variable    ${TARGET_EMAIL_ADDRESS}    ${ASKED_TARGET_EMAIL_ADDRESS}
    Set Suite Variable    ${LOCATION}    ${ASKED_LOCATION}
    Sleep    2s

Set location
    #pause execution    JukkaHei pause 1
    Input Text    ${LOCATION_FIELD_ID}    ${LOCATION}
    Sleep    2s
    #Below is needed to press enter when starting to searc the location which user gave

Test Libary Keywords
    #Send Enter Key    #Into Comments, couln't get work ok right away at Tieto
    #Click Button    name =changelocation    16.8.2022 Don't work 16.08.2022
    #pause execution    JukkaHei pause 2
    Click Button    //html/body/div/div/div/div[2]/div/div/header/div/div[2]/div/div[2]/button
    Sleep    4s

Fetch given location temperature
    #pause execution    JukkaHei pause 3
    # 16.08.2022 JukkaHei: Ao. kolme eivät enää toimineet
    #${FETCHED_LOCAL_TEMP} =    Get text    //*[@id="p_p_id_localweatherportlet_WAR_fmiwwwweatherportlets_"]/div/div/div/div[2]/div/div[1]/div/div[2]/table/tbody/tr[2]/td[1]/div
    #${FETCHED_WIND_AMOUNT} =    Get text    //*[@id="p_p_id_localweatherportlet_WAR_fmiwwwweatherportlets_"]/div/div/div/div[2]/div/div[1]/div/div[2]/table/tbody/tr[3]/td[1]/div
    #${FETCHED_RAIN_TEXT} =    Get text    //*[@id="p_p_id_localweatherportlet_WAR_fmiwwwweatherportlets_"]/div/div/div/div[2]/div/div[1]/div/div[2]/table/tbody/tr[6]/th

    ${FETCHED_LOCAL_TEMP} =    Get text    //html/body/div/div/div/div[3]/div[4]/div[2]/div/div[2]/div/div/div[1]/div[1]/div[2]/div/div[1]/div/div/table/tbody/tr[2]/td[1]/span
    ${FETCHED_WIND_AMOUNT} =    Get text    //html/body/div/div/div/div[3]/div[4]/div[2]/div/div[2]/div/div/div[1]/div[1]/div[2]/div/div[1]/div/div/table/tbody/tr[6]/td[1]/span
    ${FETCHED_RAIN_TEXT} =    Get text    //html/body/div/div/div/div[3]/div[4]/div[2]/div/div[2]/div/div/div[1]/div[1]/div[2]/div/div[1]/div/div/table/tbody/tr[10]/td[1]/span/span[1]

    Log To Console    Fetched rain text is    ${FETCHED_RAIN_TEXT}
    # Code goes below rain amount fetch if rain text does not contain rain probability too (usually when location is outside of Finland)
    ${FETCHED_RAIN_AMOUNT} =    Run Keyword If    '${FETCHED_RAIN_TEXT}' == 'Precipitation amount'    Get text    //html/body/div/div/div/div[3]/div[4]/div[2]/div/div[2]/div/div/div[1]/div[1]/div[2]/div/div[1]/div/div/table/tbody/tr[12]/td[1]/div/div[1]
    Run Keyword If    '${FETCHED_RAIN_TEXT}' == 'Precipitation amount'    Set Suite Variable    ${LOCAL_RAIN_AMOUNT}    ${FETCHED_RAIN_AMOUNT}
    # Code goes below rain amount fetch if rain text contains rain probability too (usually in Finland and near locations like Stockholm)
    ${FETCHED_RAIN_AMOUNT} =    Run Keyword If    '${FETCHED_RAIN_TEXT}' == 'Probability and amount of precipitation'    Get text    //*[@id="p_p_id_localweatherportlet_WAR_fmiwwwweatherportlets_"]/div/div/div/div[2]/div/div[1]/div/div[2]/table/tbody/tr[9]/td[1]/span
    Run Keyword If    '${FETCHED_RAIN_TEXT}' == 'Probability and amount of precipitation'    Set Suite Variable    ${LOCAL_RAIN_AMOUNT}    ${FETCHED_RAIN_AMOUNT}
    Set Suite Variable    ${LOCAL_TEMP}    ${FETCHED_LOCAL_TEMP}
    Set Suite Variable    ${LOCAL_WIND_AMOUNT}    ${FETCHED_WIND_AMOUNT}
    Log To Console    .
    Log To Console    ***
    Log To Console    Temperature in ${LOCATION} is ${LOCAL_TEMP} C
    Log To Console    This windy it is: ${LOCAL_WIND_AMOUNT} m/s
    Log To Console    This rainy it is: ${LOCAL_RAIN_AMOUNT}
    Log To Console    ***
    # Clothing data is fetched below

Read data from csv file
    #pause execution    JukkaHei pause 4 Own working dir is: ${OWN_WORKING_DIRECTORY}/mapping_weather_to_clothing.csv
    ${ALL_FILE_CONTENT}=    Get File    ${OWN_WORKING_DIRECTORY}/mapping_weather_to_clothing.csv
    #pause execution    JukkaHei pause 5
    #Find rigth row for clothing data file (clothing is desided based on the temperature on the given location"
    ${ROW_NUM}=    Find Mappping Table Row    ${LOCAL_TEMP}
    Log    ROOOOW NUUUUUMBEEER HERE: ${ROW_NUM}
    #Below we get the right clothing based on the row num parameter
    ${CLOTHING}    Get Line    ${ALL_FILE_CONTENT}    ${ROW_NUM}
    Set Suite Variable    ${SUITE_LEVEL_CLOTHING}    ${CLOTHING}
    #This procedure below sends the weather data and clothing suggestion mail to the given email address
    #Note! When executing program give only valid values. Checking imput values feature is missing from
    #this version 1.0.
    #Note 2. When Robot is executing this macro, do not take control by mouse or keyboard, because
    #then execution will fail

Report weather data by mail
    Send Weather Mail    ${LOCATION}    ${LOCAL_TEMP}    ${LOCAL_WIND_AMOUNT}    ${LOCAL_RAIN_AMOUNT}    ${SUITE_LEVEL_CLOTHING}    ${USERNAME}
    ...    ${PASSWORD}    ${TARGET_EMAIL_ADDRESS}
    #This procedure below writes the weather data and clothing suggestion to the text file

Write weather data to a text file
    Create File    ${OWN_WORKING_DIRECTORY}/weather_data_and_clothing_suggestion.txt    Hello.${\n}${\n}Here is the curent weather data at ${LOCATION}: temperature ${LOCAL_TEMP} C , wind ${LOCAL_WIND_AMOUNT} m/s , rain ${LOCAL_RAIN_AMOUNT}${\n}Suggested clothing: ${SUITE_LEVEL_CLOTHING} ${\n}${\n}${\n}${\n}BR. Ronald Robot

*** Keywords ***
Initialize
    Open Browser    ${WEB_PAGE}    browser=${BROWSER}
    Maximize Browser Window
    Sleep    1s

Cleanup
    Close Browser
