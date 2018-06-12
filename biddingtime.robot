*** Settings ***
Library           String
Library           Selenium2Library
Library           Collections
Library           biddingtime_service.py

*** Keywords ***
Підготувати клієнт для користувача
    [Arguments]    ${username}
    ${alias}=   Catenate   SEPARATOR=   role_  ${username}
    Set Global Variable   ${BROWSER_ALIAS}   ${alias}

    Open Browser    ${USERS.users['${username}'].homepage}    ${USERS.users['${username}'].browser}    alias=${BROWSER_ALIAS}
    Set Window Size    @{USERS.users['${username}'].size}
    Set Window Position    @{USERS.users['${username}'].position}
    Run Keyword If    '${username}' != 'biddingtime_Viewer'    Login    ${username}

Login
    [Arguments]    @{ARGUMENTS}
    Input text    id=login-form-login    ${USERS.users['${ARGUMENTS[0]}'].login}
    Input text    id = login-form-password    ${USERS.users['${ARGUMENTS[0]}'].password}
    Click Element    id=login-btn

Підготувати дані для оголошення тендера
    [Arguments]    ${username}    ${tender_data}    ${role_name}
    [Return]    ${tender_data}

Створити об'єкт МП
    [Arguments]    ${username}    ${tender_data}
    Log    ${tender_data}
    Set Global Variable    ${TENDER_INIT_DATA_LIST}    ${tender_data}

    ${title}=    Get From Dictionary    ${tender_data.data}    title
    ${title_ru}=    Get From Dictionary    ${tender_data.data}    title_ru
    ${title_en}=    Get From Dictionary    ${tender_data.data}    title_en
    ${description}=    Get From Dictionary    ${tender_data.data}    description
    ${description_ru}=    Get From Dictionary    ${tender_data.data}    description_ru
    ${description_en}=    Get From Dictionary    ${tender_data.data}    description_en

    ${decisionID}=    Get from dictionary    ${tender_data.data.decisions[0]}    decisionID
    ${decisionDate}=    Get from dictionary    ${tender_data.data.decisions[0]}    decisionDate
    ${decision_title}=    Get from dictionary    ${tender_data.data.decisions[0]}    title
    ${decision_title_ru}=    Get from dictionary    ${tender_data.data.decisions[0]}    title_ru
    ${decision_title_en}=    Get from dictionary    ${tender_data.data.decisions[0]}    title_en

    ${assetHoldername}=    Get from dictionary    ${tender_data.data.assetHolder}    name
    ${assetHolder_identifier_id}=    Get from dictionary    ${tender_data.data.assetHolder.identifier}    id
    ${assetHolder_identifier_legalName}=    Get from dictionary    ${tender_data.data.assetHolder.identifier}    legalName
    ${assetHolder_identifier_scheme}=    Get from dictionary    ${tender_data.data.assetHolder.identifier}    scheme

    ${assetHolder_address_countryName}=    Get from dictionary    ${tender_data.data.assetHolder.address}    countryName
    ${assetHolder_address_locality}=    Get from dictionary    ${tender_data.data.assetHolder.address}    locality
    ${assetHolder_address_postalCode}=    Get from dictionary    ${tender_data.data.assetHolder.address}    postalCode
    ${assetHolder_address_region}=    Get from dictionary    ${tender_data.data.assetHolder.address}    region
    ${assetHolder_address_streetAddress}=    Get from dictionary    ${tender_data.data.assetHolder.address}    streetAddress

    ${assetHolder_ContactPoint_email}=    Get from dictionary    ${tender_data.data.assetHolder.contactPoint}    email
    ${assetHolder_ContactPoint_faxNumber}=    Get from dictionary    ${tender_data.data.assetHolder.contactPoint}    faxNumber
    ${assetHolder_ContactPoint_name}=    Get from dictionary    ${tender_data.data.assetHolder.contactPoint}    name
    ${assetHolder_ContactPoint_telephone}=    Get from dictionary    ${tender_data.data.assetHolder.contactPoint}    telephone
    ${assetHolder_ContactPoint_url}=    Get from dictionary    ${tender_data.data.assetHolder.contactPoint}    url

    ${items}=    Get From Dictionary    ${tender_data.data}    items
    ${items_length}=    Get Length      ${items}

    Click element    id=cabinet
    Click element    id=profile
    Click element    id=edit-profile-btn
    Input text    id=profile-firma_full    ${tender_data.data.assetCustodian.identifier.legalName}
    Input text    id=profile-member    ${tender_data.data.assetCustodian.contactPoint.name}
    Input text    id=profile-phone    ${tender_data.data.assetCustodian.contactPoint.telephone}
    Input text    id=profile-email    ${tender_data.data.assetCustodian.contactPoint.email}
    Input text    id=profile-zkpo    ${tender_data.data.assetCustodian.identifier.id}
    Click element    id=save-btn
    Sleep    2

    Wait Until Page Contains Element    id = cabinet

    Click element    id = asset
    Click element    id = create-asset-btn

    Input text    id=assets-title    ${title}
    Input text    id=assets-title_ru    ${title_ru}
    Input text    id=assets-title_en    ${title_en}

    Input text    id=assets-description    ${description}
    Input text    id=assets-description_ru    ${description_ru}
    Input text    id=assets-description_en    ${description_en}

    Input text    id=decisions-0-decisionid    ${decisionID}
    Input text    id=decisions-0-decisiondate    ${decisionDate}
    Input text    id=decisions-0-title    ${decision_title}
    Input text    id=decisions-0-title_ru    ${decision_title_ru}
    Input text    id=decisions-0-title_en    ${decision_title_en}

    Input text    id=organizations-name    ${assetHoldername}
    Input text    id=organizations-identifier_id    ${assetHolder_identifier_id}
    Select from list by value    id=organizations-identifier_scheme    ${assetHolder_identifier_scheme}
    Input text    id=organizations-identifier_legalname    ${assetHolder_identifier_legalName}

    Input text    id=organizations-contactpoint_email    ${assetHolder_ContactPoint_email}
    Input text    id=organizations-contactpoint_faxnumber    ${assetHolder_ContactPoint_faxNumber}
    Input text    id=organizations-contactpoint_name    ${assetHolder_ContactPoint_name}
    Input text    id=organizations-contactpoint_telephone    ${assetHolder_ContactPoint_telephone}
    Input text    id=organizations-contactpoint_uri    ${assetHolder_ContactPoint_url}

    Input text    id=organizations-address_locality    ${assetHolder_address_locality}
    Input text    id=organizations-address_postalcode    ${assetHolder_address_postalCode}
    Input text    id=organizations-address_region    ${assetHolder_address_region}
    Input text    id=organizations-address_streetaddress    ${assetHolder_address_streetAddress}

    Click element    id=asset-save-btn
    Sleep    3
    :FOR   ${index}   IN RANGE   ${items_length}
    \       Додати предмет    ${items[${index}]}
    Click element    id = asset-activate-btn
    ${assetID}=    Get text    id = assetID
    Run keyword    biddingtime.Оновити сторінку з об'єктом МП    ${username}    ${assetID}
    [Return]    ${assetID}

Створити лот
    [Arguments]    ${username}    ${tender_data}    ${asset_uaid}
    ${decisionDate}=    Get from dictionary    ${tender_data.data.decisions[0]}    decisionDate
    ${decisionID}=    Get from dictionary    ${tender_data.data.decisions[0]}    decisionID
    Click element    id=cabinet
    Click element    id=lot
    Click element    id=create-lot-btn
    Input text    id=lots-assetid    ${asset_uaid}
    Input text    id=decisions-decisiondate    ${decisionDate}
    Input text    id=decisions-decisionid    ${decisionID}
    Click element    id=save-btn
    Sleep    2
    Click element    id=activate-btn
    ${tender_uaid}=    Get text    id=lotID
    [Return]    ${tender_uaid}

Додати предмет
    [Arguments]    ${item}
    ${quantity}=    Convert to string    ${item.quantity}
    Click element    id = create-item-btn
    Input text    id = items-description    ${item.description}
    Input text    id = items-description_ru    ${item.description_ru}
    Input text    id = items-description_en    ${item.description_en}
    Input text    id = items-quantity    ${quantity}
    Select from list by value    id = items-unit_code    ${item.unit.code}
    Select from list by value    id = items-additionalclassifications    ${item.additionalClassifications[0].id}
    Input text    id = items-address_locality    ${item.address.locality}
    Input text    id = items-address_postalcode    ${item.address.postalCode}
    Select from list by value    id = items-address_region    ${item.address.region}
    Input text    id = items-address_streetaddress    ${item.address.streetAddress}
    Input text    id = items-classification_id    ${item.classification.id}

    Click element    id = save-btn

Оновити сторінку з об'єктом МП
    [Arguments]    ${username}    ${tender_uaid}
    Sleep    2
    Click element    id=assets-list
    Input text    //input[@name="AssetsSearch[assetID]"]    ${tender_uaid}
    Click element    //input[@name="AssetsSearch[title]"]
    Click element    id=asset-view
    Click element    id=refresh-btn
    Sleep    2

Оновити сторінку з лотом
    [Arguments]    ${username}    ${tender_uaid}
    Sleep    2
    Click element    id=lots-list
    Input text    //input[@name="LotsSearch[lotID]"]    ${tender_uaid}
    Click element    //input[@name="LotsSearch[title]"]
    Click element    id=lot-view
    Click element    id=refresh-btn
    Sleep    2

Пошук лоту по ідентифікатору
    [Arguments]    ${username}    ${tender_uaid}
    Run keyword    biddingtime.Оновити сторінку з лотом    ${username}    ${tender_uaid}

Пошук об’єкта МП по ідентифікатору
    [Arguments]    ${username}    ${tender_uaid}
    Run keyword    biddingtime.Оновити сторінку з об'єктом МП    ${username}    ${tender_uaid}

Отримати інформацію із об'єкта МП
    [Arguments]    ${username}    ${tender_uaid}    ${field_name}
    ${return_value}=    Run Keyword    biddingtime.Отримати інформацію про ${field_name}
    [Return]    ${return_value}

Отримати інформацію про dateModified
    ${return_value}=    Get text    id=assets-datemodified
    [Return]    ${return_value}

Отримати інформацію про assetID
    ${return_value}=    Get text    id=assetID
    [Return]    ${return_value}

Отримати інформацію про date
    ${return_value}=    Get text    id=assets-date
    [Return]    ${return_value}

Отримати інформацію про status
    ${return_value}=    Get text    id=assets-status
    [Return]    ${return_value}

Отримати інформацію про title
    ${return_value}=    Get text    id=assets-title
    [Return]    ${return_value}

Отримати інформацію про description
    ${return_value}=    Get text    id=assets-description
    [Return]    ${return_value}

Отримати інформацію про rectificationPeriod.endDate
    ${return_value}=    Get text    id=assets-rectificationperiod_enddate
    [Return]    ${return_value}

Отримати інформацію про decisions[0].title
    ${return_value}=    Get text    id=decisions-title
    [Return]    ${return_value}

Отримати інформацію про decisions[0].decisionID
    ${return_value}=    Get text    id=decisions-decisionid
    [Return]    ${return_value}

Отримати інформацію про decisions[0].decisionDate
    ${return_value}=    Get text    id=decisions-decisiondate
    [Return]    ${return_value}

Отримати інформацію про assetHolder.name
    ${return_value}=    Get text    id=organizations-name
    [Return]    ${return_value}

Отримати інформацію про assetHolder.identifier.scheme
    ${return_value}=    Get text    id=organizations-identifier_scheme
    [Return]    ${return_value}

Отримати інформацію про assetHolder.identifier.id
    ${return_value}=    Get text    id=organizations-identifier_id
    [Return]    ${return_value}

Отримати інформацію про assetCustodian.identifier.scheme
    ${return_value}=    Get text    id=custodian-identifier_scheme
    [Return]    ${return_value}

Отримати інформацію про assetCustodian.identifier.id
    ${return_value}=    Get text    id=custodian-identifier_id
    [Return]    ${return_value}

Отримати інформацію про assetCustodian.name
    ${return_value}=    Get text    id=custodian-name
    [Return]    ${return_value}

Отримати інформацію про assetCustodian.contactPoint.email
    ${return_value}=    Get text    id=custodian-contactpoint_email
    [Return]    ${return_value}

Отримати інформацію про assetCustodian.contactPoint.name
    ${return_value}=    Get text    id=custodian-contactpoint_name
    [Return]    ${return_value}

Отримати інформацію про assetCustodian.contactPoint.telephone
    ${return_value}=    Get text    id=custodian-contactpoint_telephone
    [Return]    ${return_value}

Отримати інформацію про assetCustodian.identifier.legalName
    ${return_value}=    Get text    id=custodian-identifier_legalName
    [Return]    ${return_value}

Отримати інформацію про documents[0].documentType
    ${return_value}=    Get text    id=document-0
    [Return]    ${return_value}

Отримати інформацію з активу об'єкта МП
    [Arguments]    ${username}    ${tender_uaid}    ${item_id}    ${field_name}
    ${return_value}=    Get text    id='${item_id}-${field_name}'
    [Return]    ${return_value}

Отримати інформацію про items[${index}].description
    ${return_value}=    Get text    id=items-${index}-description
    [Return]    ${return_value}

Отримати інформацію про items[${index}].description_ru
    ${return_value}=    Get text    id=items-${index}-description_ru
    [Return]    ${return_value}

Отримати інформацію про items[${index}].description_en
    ${return_value}=    Get text    id=items-${index}-description_en
    [Return]    ${return_value}

Отримати інформацію про items[${index}].classification.scheme
    ${return_value}=    Get text    id=items-${index}-classification_scheme
    [Return]    ${return_value}

Отримати інформацію про items[${index}].classification.id
    ${return_value}=    Get text    id=items-${index}-classification_id
    [Return]    ${return_value}

Отримати інформацію про items[${index}].unit.name
    ${return_value}=    Get text    id=items-${index}-unit_name
    [Return]    ${return_value}

Отримати інформацію про items[${index}].quantity
    ${return_value}=    Get text    id=items-${index}-quantity
    ${return_value}=    Convert to number    ${return_value}
    [Return]    ${return_value}

Отримати інформацію про items[${index}].registrationDetails.status
    ${return_value}=    Get text    id=items-${index}-status
    [Return]    ${return_value}

Отримати інформацію щодо лоту про items[${index}].description
    ${return_value}=    Get text    id=items-${index}-description
    [Return]    ${return_value}

Отримати інформацію щодо лоту про items[${index}].description_ru
    ${return_value}=    Get text    id=items-${index}-description_ru
    [Return]    ${return_value}

Отримати інформацію щодо лоту про items[${index}].description_en
    ${return_value}=    Get text    id=items-${index}-description_en
    [Return]    ${return_value}

Отримати інформацію щодо лоту про items[${index}].classification.scheme
    ${return_value}=    Get text    id=items-${index}-classification_scheme
    [Return]    ${return_value}

Отримати інформацію щодо лоту про items[${index}].classification.id
    ${return_value}=    Get text    id=items-${index}-classification_id
    [Return]    ${return_value}

Отримати інформацію щодо лоту про items[${index}].unit.name
    ${return_value}=    Get text    id=items-${index}-unit_name
    [Return]    ${return_value}

Отримати інформацію щодо лоту про items[${index}].quantity
    ${return_value}=    Get text    id=items-${index}-quantity
    ${return_value}=    Convert to number    ${return_value}
    [Return]    ${return_value}

Отримати інформацію щодо лоту про items[${index}].registrationDetails.status
    ${return_value}=    Get text    id=items-${index}-status
    [Return]    ${return_value}

Завантажити ілюстрацію в об'єкт МП
    [Arguments]    ${username}    ${tender_uaid}    ${filepath}
    Run keyword    biddingtime.Пошук об’єкта МП по ідентифікатору    ${username}    ${tender_uaid}
    Click element    id=asset-upload-btn
    Select from list by value    id=files-type    illustration
    Choose file    id=files-file    ${filepath}
    Click element    id=upload-btn
    Wait until page contains element    id=assetID

Завантажити ілюстрацію в лот
    [Arguments]    ${username}    ${tender_uaid}    ${filepath}
    Run keyword    biddingtime.Пошук лоту по ідентифікатору    ${username}    ${tender_uaid}
    Click element    id=lot-upload-btn
    Select from list by value    id=files-type    illustration
    Choose file    id=files-file    ${filepath}
    Click element    id=upload-btn
    Wait until page contains element    id=lotID

Завантажити документ в об'єкт МП з типом
    [Arguments]    ${username}    ${tender_uaid}    ${filepath}    ${documentType}
    Run keyword    biddingtime.Пошук об’єкта МП по ідентифікатору    ${username}    ${tender_uaid}
    Click element    id=asset-upload-btn
    Select from list by value    id=files-type    ${documentType}
    Choose file    id=files-file    ${filepath}
    Click element    id=upload-btn
    Wait until page contains element    id=assetID

Завантажити документ в лот з типом
    [Arguments]    ${username}    ${tender_uaid}    ${filepath}    ${documentType}
    Run keyword    biddingtime.Пошук лоту по ідентифікатору    ${username}    ${tender_uaid}
    Click element    id=lot-upload-btn
    Select from list by value    id=files-type    ${documentType}
    Choose file    id=files-file    ${filepath}
    Click element    id=upload-btn
    Wait until page contains element    id=lotID

Завантажити документ в умови проведення аукціону
    [Arguments]    ${username}    ${tender_uaid}    ${filepath}    ${documentType}    ${auction_index}
    Run keyword    biddingtime.Завантажити документ в лот з типом    ${username}    ${tender_uaid}    ${filepath}    ${documentType}

Внести зміни в об'єкт МП
    [Arguments]    ${username}    ${tender_uaid}    ${field_name}    ${field_value}
    Run keyword    biddingtime.Змінити ${field_name} об'єкта МП    ${username}    ${tender_uaid}    ${field_value}

Внести зміни в лот
    [Arguments]    ${username}    ${tender_uaid}    ${fieldname}    ${fieldvalue}
    Run keyword    biddingtime.Змінити ${fieldname} лоту    ${username}    ${tender_uaid}    ${field_value}

Внести зміни в актив лоту
    [Arguments]    ${username}    ${item_id}    ${tender_uaid}    ${fieldname}    ${fieldvalue}
    Run keyword    biddingtime.Змінити поле ${fieldname} активу лоту    ${field_value}

Внести зміни в умови проведення аукціону
    [Arguments]    ${username}    ${tender_uaid}    ${fieldname}    ${fieldvalue}    ${auction_index}
    Run keyword    biddingtime.Змінити поле ${fieldname} аукціону ${auction_index}    ${field_value}

Змінити поле quantity активу лоту
    [Arguments]    ${field_value}
    Click element    id=items-0-update-btn
    ${field_value}=    Convert to string    ${field_value}
    Input text    id=items-quantity    ${field_value}
    Click element    id=save-btn
    Sleep    2

Змінити поле value.amount аукціону 0
    [Arguments]    ${field_value}
    Click element    id=auction-0-update-btn
    ${field_value}=    Convert to string    ${field_value}
    Input text    id=lotauctions-value_amount    ${field_value}
    Click element    id=save-btn
    Sleep    2

Змінити поле guarantee.amount аукціону 0
    [Arguments]    ${field_value}
    Click element    id=auction-0-update-btn
    ${field_value}=    Convert to string    ${field_value}
    Input text    id=lotauctions-guarantee_amount    ${field_value}
    Click element    id=save-btn
    Sleep    2

Змінити поле registrationFee.amount аукціону 0
    [Arguments]    ${field_value}
    Click element    id=auction-0-update-btn
    ${field_value}=    Convert to string    ${field_value}
    Input text    id=lotauctions-registrationfee_amount    ${field_value}
    Click element    id=save-btn
    Sleep    2

Змінити поле minimalStep.amount аукціону 0
    [Arguments]    ${field_value}
    Click element    id=auction-0-update-btn
    ${field_value}=    Convert to string    ${field_value}
    Input text    id=lotauctions-minimalstep_amount    ${field_value}
    Click element    id=save-btn
    Sleep    2

Змінити поле auctionPeriod.startDate аукціону 0
    [Arguments]    ${field_value}
    Click element    id=auction-0-update-btn
    Input text    id=lotauctions-auctionperiod_startdate    ${field_value}
    Click element    id=save-btn
    Sleep    2

Змінити title лоту
    [Arguments]    ${username}    ${tender_uaid}    ${field_value}
    Click element    id=update-btn
    Input text    id=lots-title    ${field_value}
    Click element    id=save-btn
    Sleep    2

Змінити description лоту
    [Arguments]    ${username}    ${tender_uaid}    ${field_value}
    Click element    id=update-btn
    Input text    id=lots-description    ${field_value}
    Click element    id=save-btn
    Sleep    2

Змінити title об'єкта МП
    [Arguments]    ${username}    ${tender_uaid}    ${field_value}
    Run keyword    biddingtime.Пошук об’єкта МП по ідентифікатору    ${username}    ${tender_uaid}
    Click element    id=asset-update-btn
    Input text    id=assets-title    ${field_value}
    Click element    id=asset-save-btn
    Sleep    3

Змінити description об'єкта МП
    [Arguments]    ${username}    ${tender_uaid}    ${field_value}
    Run keyword    biddingtime.Пошук об’єкта МП по ідентифікатору    ${username}    ${tender_uaid}
    Click element    id=asset-update-btn
    Input text    id=assets-description    ${field_value}
    Click element    id=asset-save-btn
    Sleep    3

Внести зміни в актив об'єкта МП
    [Arguments]    ${username}    ${item_id}    ${tender_uaid}    ${field_name}    ${field_value}
    Run keyword    biddingtime.Змінити ${field_name} об'єкта МП    ${username}    ${tender_uaid}    ${item_id}    ${field_value}

Змінити quantity об'єкта МП
    [Arguments]    ${username}    ${tender_uaid}    ${item_id}    ${field_value}
    Run keyword    biddingtime.Оновити сторінку з об'єктом МП    ${username}    ${tender_uaid}
    Click element    id=items-0-update-btn
    ${field_value}=    Convert to string    ${field_value}
    Input text    id=items-quantity    ${field_value}
    Click element    id=save-btn
    Sleep    2

Отримати кількість активів в об'єкті МП
    [Arguments]    ${username}    ${tender_uaid}
    Run keyword    biddingtime.Оновити сторінку з об'єктом МП    ${username}    ${tender_uaid}
    ${number_of_items}=  Get Matching Xpath Count  //tr[@class="item"]
    [Return]  ${number_of_items}

Додати актив до об'єкта МП
    [Arguments]    ${username}    ${tender_uaid}    ${item}
    Run keyword    biddingtime.Додати предмет    ${item}

Отримати документ
    [Arguments]    ${username}    ${tender_uaid}    ${doc_id}
    Run keyword    biddingtime.Оновити сторінку з об'єктом МП    ${username}    ${tender_uaid}
    ${file_name}    Get Text    xpath=//*[contains(text(),'${doc_id}')]
    ${url}    Get Element Attribute    xpath=//*[contains(text(),'${doc_id}')]@href
    download_file    ${url}    ${file_name.split('/')[-1]}    ${OUTPUT_DIR}
    [Return]    ${file_name.split('/')[-1]}

Додати умови проведення аукціону
  [Arguments]  ${username}  ${auction}  ${index}  ${tender_uaid}
  Run KeyWord  biddingtime.Додати умови проведення аукціону номер ${index}  ${username}  ${tender_uaid}  ${auction}

Додати умови проведення аукціону номер 0
  [Arguments]  ${username}  ${tender_uaid}  ${auction}
  biddingtime.Оновити сторінку з лотом    ${username}  ${tender_uaid}
  Click Element    id=auction-0-update-btn
  Input Text  id=lotauctions-auctionperiod_startdate    ${auction.auctionPeriod.startDate}
  ${value_amount}=    Convert To String    ${auction.value.amount}
  Input Text    id=lotauctions-value_amount    ${value_amount}
  ${value_valueaddedtaxincluded}=    Convert To String    ${auction.value.valueAddedTaxIncluded}
  Run Keyword If    ${value_valueaddedtaxincluded} == True    Select Checkbox  id=lotauctions-value_valueaddedtaxincluded
  ${minimalStep}=    Convert To String    ${auction.minimalStep.amount}
  Input Text    id=lotauctions-minimalstep_amount    ${minimalStep}
  ${guarantee_amount}=    Convert To String    ${auction.guarantee.amount}
  Input Text    id=lotauctions-guarantee_amount    ${guarantee_amount}
  ${registrationFee}=  Convert To String    ${auction.registrationFee.amount}
  Input Text    id=lotauctions-registrationfee_amount    ${registrationFee}
  Click element    id=save-btn

Додати умови проведення аукціону номер 1
  [Arguments]  ${username}  ${tender_uaid}  ${auction}
  Run keyword    biddingtime.Оновити сторінку з лотом    ${username}  ${tender_uaid}
  Click Element    id=auction-1-update-btn
  Input text    id=lotauctions-tenderingduration    ${auction.tenderingDuration}
  Click element    id=save-btn
  Click element    id=verification-btn

Отримати інформацію з активу лоту
    [Arguments]    ${username}    ${tender_uaid}    ${item_id}    ${field_name}
    ${return_value}=    Run keyword     biddingtime.Отримати значення поля ${field_name} щодо активу лоту    ${username}    ${tender_uaid}    ${item_id}
    [Return]    ${return_value}

Отримати інформацію із лоту
    [Arguments]    ${username}    ${tender_uaid}    ${field_name}
    ${return_value}=    Run keyword    biddingtime.Отримати інформацію щодо лоту про ${field_name}
    [Return]    ${return_value}

Завантажити документ для видалення об'єкта МП
    [Arguments]    ${username}    ${tender_uaid}    ${filepath}
    Run keyword    biddingtime.Пошук об’єкта МП по ідентифікатору    ${username}    ${tender_uaid}
    Click element    id=asset-upload-btn
    Select from list by value    id=files-type    cancellationDetails
    ${filepath}=    get_upload_file_path
    Choose file    id=files-file    ${filepath}
    Click element    id=upload-btn

Видалити об'єкт МП
    [Arguments]    ${username}    ${tender_uaid}
    Click element    id=delete-btn
    Confirm Action

Завантажити документ для видалення лоту
    [Arguments]    ${username}    ${tender_uaid}    ${filepath}
    Run keyword    biddingtime.Пошук лоту по ідентифікатору    ${username}    ${tender_uaid}
    Click element    id=lot-upload-btn
    Select from list by value    id=files-type    cancellationDetails
    ${filepath}=    get_upload_file_path
    Choose file    id=files-file    ${filepath}
    Click element    id=upload-btn

Видалити лот
    [Arguments]    ${username}    ${tender_uaid}
    Click element    id=delete-btn
    Confirm Action

Отримати інформацію щодо лоту про status
    ${return_value}=    Get text    id=lots-status
    [Return]    ${return_value}

Отримати інформацію щодо лоту про dateModified
    ${return_value}=    Get text    id=lots-datemodified
    [Return]    ${return_value}

Отримати інформацію щодо лоту про lotID
    ${return_value}=    Get text    id=lots-lotid
    [Return]    ${return_value}

Отримати інформацію щодо лоту про date
    ${return_value}=    Get text    id=lots-date
    [Return]    ${return_value}

Отримати інформацію щодо лоту про rectificationPeriod.endDate
    ${return_value}=    Get text    id=lots-rectificationperiod_enddate
    [Return]    ${return_value}

Отримати інформацію щодо лоту про assets
    ${return_value}=    Get text    id=lots-assetid
    [Return]    ${return_value}

Отримати інформацію щодо лоту про title
    ${return_value}=    Get text    id=lots-title
    [Return]    ${return_value}

Отримати інформацію щодо лоту про title_ru
    ${return_value}=    Get text    id=lots-title_ru
    [Return]    ${return_value}

Отримати інформацію щодо лоту про title_en
    ${return_value}=    Get text    id=lots-title_en
    [Return]    ${return_value}

Отримати інформацію щодо лоту про description
    ${return_value}=    Get text    id=lots-description
    [Return]    ${return_value}

Отримати інформацію щодо лоту про lotHolder.name
    ${return_value}=    Get text    id=organizations-name
    [Return]    ${return_value}

Отримати інформацію щодо лоту про lotHolder.identifier.scheme
    ${return_value}=    Get text    id=organizations-identifier_scheme
    [Return]    ${return_value}

Отримати інформацію щодо лоту про lotHolder.identifier.id
    ${return_value}=    Get text    id=organizations-identifier_id
    [Return]    ${return_value}

Отримати інформацію щодо лоту про lotCustodian.identifier.scheme
    ${return_value}=    Get text    id=custodian-identifier_scheme
    [Return]    ${return_value}

Отримати інформацію щодо лоту про lotCustodian.identifier.id
    ${return_value}=    Get text    id=custodian-identifier_id
    [Return]    ${return_value}

Отримати інформацію щодо лоту про lotCustodian.identifier.legalName
    ${return_value}=    Get text    id=custodian-identifier_legalName
    [Return]    ${return_value}

Отримати інформацію щодо лоту про lotCustodian.contactPoint.name
    ${return_value}=    Get text    id=custodian-contactpoint_name
    [Return]    ${return_value}

Отримати інформацію щодо лоту про lotCustodian.contactPoint.telephone
    ${return_value}=    Get text    id=custodian-contactpoint_telephone
    [Return]    ${return_value}

Отримати інформацію щодо лоту про lotCustodian.contactPoint.email
    ${return_value}=    Get text    id=custodian-contactpoint_email
    [Return]    ${return_value}

Отримати інформацію щодо лоту про decisions[${index}].decisionDate
    ${return_value}=    Get text    id=decisions-${index}-decisionDate
    [Return]    ${return_value}

Отримати інформацію щодо лоту про decisions[${index}].decisionID
    ${return_value}=    Get text    id=decisions-${index}-decisionID
    [Return]    ${return_value}

Отримати інформацію щодо лоту про decisions[${index}].title
    ${return_value}=    Get text    id=decisions-${index}-title
    [Return]    ${return_value}

Отримати інформацію щодо лоту про auctions[${index}].procurementMethodType
    ${return_value}=    Get text    id=auctions-${index}-procurementMethodType
    [Return]    ${return_value}

Отримати інформацію щодо лоту про auctions[${index}].status
    ${return_value}=    Get text    id=auctions-${index}-status
    [Return]    ${return_value}

Отримати інформацію щодо лоту про auctions[${index}].tenderAttempts
    ${return_value}=    Get text    id=auctions-${index}-tenderAttempts
    ${return_value}=    Convert to number    ${return_value}
    [Return]    ${return_value}

Отримати інформацію щодо лоту про auctions[${index}].value.amount
    ${return_value}=    Get text    id=auctions-${index}-value_amount
    ${return_value}=    Convert to number    ${return_value}
    [Return]    ${return_value}

Отримати інформацію щодо лоту про auctions[${index}].minimalStep.amount
    ${return_value}=    Get text    id=auctions-${index}-minimalStep_amount
    ${return_value}=    Convert to number    ${return_value}
    [Return]    ${return_value}

Отримати інформацію щодо лоту про auctions[${index}].guarantee.amount
    ${return_value}=    Get text    id=auctions-${index}-guarantee_amount
    ${return_value}=    Convert to number    ${return_value}
    [Return]    ${return_value}

Отримати інформацію щодо лоту про auctions[${index}].registrationFee.amount
    ${return_value}=    Get text    id=auctions-${index}-registrationFee_amount
    ${return_value}=    Convert to number    ${return_value}
    [Return]    ${return_value}

Отримати інформацію щодо лоту про auctions[${index}].tenderingDuration
    ${return_value}=    Get text    id=auctions-${index}-tenderingDuration
    [Return]    ${return_value}

Отримати інформацію щодо лоту про auctions[${index}].auctionPeriod.startDate
    ${return_value}=    Get text    id=auctions-${index}-auctionPeriod_startDate
    [Return]    ${return_value}

Отримати значення поля description щодо активу лоту
    [Arguments]    ${username}    ${tender_uaid}    ${item_id}
    ${return_value}=    Get text    id=items-${item_id}-description
    [Return]    ${return_value}

Отримати значення поля classification.scheme щодо активу лоту
    [Arguments]    ${username}    ${tender_uaid}    ${item_id}
    ${return_value}=    Get text    id=items-${item_id}-classification_scheme
    [Return]    ${return_value}

Отримати значення поля classification.id щодо активу лоту
    [Arguments]    ${username}    ${tender_uaid}    ${item_id}
    ${return_value}=    Get text    id=items-${item_id}-classification_id
    [Return]    ${return_value}

Отримати значення поля unit.name щодо активу лоту
    [Arguments]    ${username}    ${tender_uaid}    ${item_id}
    ${return_value}=    Get text    id=items-${item_id}-unit_name
    [Return]    ${return_value}

Отримати значення поля quantity щодо активу лоту
    [Arguments]    ${username}    ${tender_uaid}    ${item_id}
    ${return_value}=    Get text    id=items-${item_id}-quantity
    ${return_value}=    Convert to number    ${return_value}
    [Return]    ${return_value}

Отримати значення поля registrationDetails.status щодо активу лоту
    [Arguments]    ${username}    ${tender_uaid}    ${item_id}
    ${return_value}=    Get text    id=items-${item_id}-registrationDetails_status
    [Return]    ${return_value}