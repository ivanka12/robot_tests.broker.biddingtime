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
    Натиснути    id=login-btn

Підготувати дані для оголошення тендера
    [Arguments]    ${username}    ${tender_data}    ${role_name}
    [Return]    ${tender_data}

Натиснути
    [Arguments]    ${selector}
    Wait until page contains element    ${selector}
    Click element    ${selector}

Неквапливо натиснути
    [Arguments]    ${selector}
    Wait until page contains element    ${selector}
    Click element    ${selector}
    Sleep    1

Отримати текст
    [Arguments]    ${selector}
    Wait until page contains element    ${selector}
    ${return_value}=    Get text    ${selector}
    [Return]    ${return_value}

Змінити дані профілю учасника
    [Arguments]    ${data}
    Натиснути    id=cabinet
    Натиснути    id=profile
    Натиснути    id=edit-profile-btn
    Input text    id=profile-member    ${data.name}
    Input text    id=profile-phone    ${data.contactPoint.telephone}
    Input text    id=profile-email    ${data.contactPoint.email}
    Натиснути    id=save-btn
    Sleep    2

Змінити дані профілю органу приватизації
    [Arguments]    ${data}
    Натиснути    id=cabinet
    Натиснути    id=profile
    Натиснути    id=edit-profile-btn
    Input text    id=profile-firma_full    ${data.identifier.legalName}
    Input text    id=profile-member    ${data.contactPoint.name}
    Input text    id=profile-phone    ${data.contactPoint.telephone}
    Input text    id=profile-email    ${data.contactPoint.email}
    Input text    id=profile-zkpo    ${data.identifier.id}
    Натиснути    id=save-btn
    Sleep    2

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

    Run keyword    biddingtime.Змінити дані профілю органу приватизації    ${tender_data.data.assetCustodian}

    Wait Until Page Contains Element    id = cabinet

    Натиснути    id = asset
    Натиснути    id = create-asset-btn

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

    Натиснути    id=asset-save-btn
    Sleep    3
    :FOR   ${index}   IN RANGE   ${items_length}
    \       Додати предмет    ${items[${index}]}
    Натиснути    id = asset-activate-btn
    ${assetID}=    Отримати текст    id = assetID
    Run keyword    biddingtime.Оновити сторінку з об'єктом МП    ${username}    ${assetID}
    [Return]    ${assetID}

Створити лот
    [Arguments]    ${username}    ${tender_data}    ${asset_uaid}
    ${decisionDate}=    Get from dictionary    ${tender_data.data.decisions[0]}    decisionDate
    ${decisionID}=    Get from dictionary    ${tender_data.data.decisions[0]}    decisionID
    Натиснути    id=cabinet
    Натиснути    id=lot
    Натиснути    id=create-lot-btn
    Input text    id=lots-assetid    ${asset_uaid}
    Input text    id=decisions-decisiondate    ${decisionDate}
    Input text    id=decisions-decisionid    ${decisionID}
    Натиснути    id=save-btn
    Sleep    2
    Натиснути    id=activate-btn
    ${tender_uaid}=    Отримати текст    id=lotID
    [Return]    ${tender_uaid}

Додати предмет
    [Arguments]    ${item}
    ${quantity}=    Convert to string    ${item.quantity}
    Натиснути    id = create-item-btn
    Input text    id = items-description    ${item.description}
    Input text    id = items-description_ru    ${item.description_ru}
    Input text    id = items-description_en    ${item.description_en}
    Input text    id = items-quantity    ${quantity}
    Select from list by value    id = items-unit_code    ${item.unit.code}
    Input text    id = items-address_locality    ${item.address.locality}
    Input text    id = items-address_postalcode    ${item.address.postalCode}
    Select from list by value    id = items-address_region    ${item.address.region}
    Input text    id = items-address_streetaddress    ${item.address.streetAddress}
    Input text    id = search-c    ${item.classification.id}
    Натиснути    //a[contains(text(), '${item.classification.id}') and contains(@class, 'jstree-search')]/*[1]
    Sleep    1

    Неквапливо натиснути    id = save-btn

Оновити дані
    Натиснути    id=refresh-btn

Оновити сторінку з об'єктом МП
    [Arguments]    ${username}    ${tender_uaid}
    Sleep    2
    Натиснути    id=assets-list
    Input text    //input[@name="AssetsSearch[assetID]"]    ${tender_uaid}
    Натиснути    //input[@name="AssetsSearch[title]"]
    Натиснути    id=asset-view
    Run keyword    biddingtime.Оновити дані
    Sleep    2

Оновити сторінку з лотом
    [Arguments]    ${username}    ${tender_uaid}
    Sleep    2
    Натиснути    id=lots-list
    Sleep    2
    Input text    //input[@name="LotsSearch[lotID]"]    ${tender_uaid}
    Натиснути    //input[@name="LotsSearch[title]"]
    Run keyword    biddingtime.Оновити дані
    Sleep    2

Пошук лоту по ідентифікатору
    [Arguments]    ${username}    ${tender_uaid}
    Run keyword    biddingtime.Оновити сторінку з лотом    ${username}    ${tender_uaid}

Пошук об’єкта МП по ідентифікатору
    [Arguments]    ${username}    ${tender_uaid}
    Run keyword    biddingtime.Оновити сторінку з об'єктом МП    ${username}    ${tender_uaid}

Отримати інформацію з активу в договорі
    [Arguments]    ${username}    ${contract_uaid}    ${item_id}    ${field_name}
    ${return_value}=    Run Keyword    biddingtime.Отримати інформацію з активу ${item_id} контракту про ${field_name}
    [Return]    ${return_value}

Отримати інформацію з активу ${item_id} контракту про ${field_name}
    ${return_value}=    Отримати текст    id=items[${item_id}].${field_name}
    [Return]    ${return_value}

Отримати інформацію із об'єкта МП
    [Arguments]    ${username}    ${tender_uaid}    ${field_name}
    ${return_value}=    Run Keyword    biddingtime.Отримати інформацію про ${field_name}
    [Return]    ${return_value}

Отримати інформацію про dateModified
    ${return_value}=    Отримати текст    id=assets-datemodified
    ${return_value}=    convert_date_to_iso    ${return_value}
    [Return]    ${return_value}

Отримати інформацію про assetID
    ${return_value}=    Отримати текст    id=assetID
    [Return]    ${return_value}

Отримати інформацію про date
    ${return_value}=    Отримати текст    id=assets-date
    ${return_value}=    convert_date_to_iso    ${return_value}
    [Return]    ${return_value}

Отримати інформацію про status
    ${return_value}=    Отримати текст    id=assets-status
    [Return]    ${return_value}

Отримати інформацію про title
    ${return_value}=    Отримати текст    id=assets-title
    [Return]    ${return_value}

Отримати інформацію про description
    ${return_value}=    Отримати текст    id=assets-description
    [Return]    ${return_value}

Отримати інформацію про rectificationPeriod.endDate
    ${return_value}=    Отримати текст    id=assets-rectificationperiod_enddate
    ${return_value}=    convert_date_to_iso    ${return_value}
    [Return]    ${return_value}

Отримати інформацію про decisions[0].title
    ${return_value}=    Отримати текст    id=decisions-title
    [Return]    ${return_value}

Отримати інформацію про decisions[0].decisionID
    ${return_value}=    Отримати текст    id=decisions-decisionid
    [Return]    ${return_value}

Отримати інформацію про decisions[0].decisionDate
    ${return_value}=    Отримати текст    id=decisions-decisiondate
    ${return_value}=    convert_date_to_iso    ${return_value}
    [Return]    ${return_value}

Отримати інформацію про assetHolder.name
    ${return_value}=    Отримати текст    id=organizations-name
    [Return]    ${return_value}

Отримати інформацію про assetHolder.identifier.scheme
    ${return_value}=    Отримати текст    id=organizations-identifier_scheme
    [Return]    ${return_value}

Отримати інформацію про assetHolder.identifier.id
    ${return_value}=    Отримати текст    id=organizations-identifier_id
    [Return]    ${return_value}

Отримати інформацію про assetCustodian.identifier.scheme
    ${return_value}=    Отримати текст    id=custodian-identifier_scheme
    [Return]    ${return_value}

Отримати інформацію про assetCustodian.identifier.id
    ${return_value}=    Отримати текст    id=custodian-identifier_id
    [Return]    ${return_value}

Отримати інформацію про assetCustodian.name
    ${return_value}=    Отримати текст    id=custodian-name
    [Return]    ${return_value}

Отримати інформацію про assetCustodian.contactPoint.email
    ${return_value}=    Отримати текст    id=custodian-contactpoint_email
    [Return]    ${return_value}

Отримати інформацію про assetCustodian.contactPoint.name
    ${return_value}=    Отримати текст    id=custodian-contactpoint_name
    [Return]    ${return_value}

Отримати інформацію про assetCustodian.contactPoint.telephone
    ${return_value}=    Отримати текст    id=custodian-contactpoint_telephone
    [Return]    ${return_value}

Отримати інформацію про assetCustodian.identifier.legalName
    ${return_value}=    Отримати текст    id=custodian-identifier_legalName
    [Return]    ${return_value}

Отримати інформацію про documents[0].documentType
    ${return_value}=    Отримати текст    id=document-0
    [Return]    ${return_value}

Отримати інформацію з активу об'єкта МП
    [Arguments]    ${username}    ${tender_uaid}    ${item_id}    ${field_name}
    ${return_value}=    Отримати текст    id=${item_id}-${field_name}
    [Return]    ${return_value}

Отримати інформацію про items[${index}].description
    ${return_value}=    Отримати текст    id=items-${index}-description
    [Return]    ${return_value}

Отримати інформацію про items[${index}].description_ru
    ${return_value}=    Отримати текст    id=items-${index}-description_ru
    [Return]    ${return_value}

Отримати інформацію про items[${index}].description_en
    ${return_value}=    Отримати текст    id=items-${index}-description_en
    [Return]    ${return_value}

Отримати інформацію про items[${index}].classification.scheme
    ${return_value}=    Отримати текст    id=items-${index}-classification_scheme
    [Return]    ${return_value}

Отримати інформацію про items[${index}].classification.id
    ${return_value}=    Отримати текст    id=items-${index}-classification_id
    [Return]    ${return_value}

Отримати інформацію про items[${index}].unit.name
    ${return_value}=    Отримати текст    id=items-${index}-unit_name
    [Return]    ${return_value}

Отримати інформацію про items[${index}].quantity
    ${return_value}=    Отримати текст    id=items-${index}-quantity
    ${return_value}=    Convert to number    ${return_value}
    [Return]    ${return_value}

Отримати інформацію про items[${index}].registrationDetails.status
    ${return_value}=    Отримати текст    id=items-${index}-status
    [Return]    ${return_value}

Отримати інформацію щодо лоту про items[${index}].description
    ${return_value}=    Отримати текст    id=items-${index}-description
    [Return]    ${return_value}

Отримати інформацію щодо лоту про items[${index}].description_ru
    ${return_value}=    Отримати текст    id=items-${index}-description_ru
    [Return]    ${return_value}

Отримати інформацію щодо лоту про items[${index}].description_en
    ${return_value}=    Отримати текст    id=items-${index}-description_en
    [Return]    ${return_value}

Отримати інформацію щодо лоту про items[${index}].classification.scheme
    ${return_value}=    Отримати текст    id=items-${index}-classification_scheme
    [Return]    ${return_value}

Отримати інформацію щодо лоту про items[${index}].classification.id
    ${return_value}=    Отримати текст    id=items-${index}-classification_id
    [Return]    ${return_value}

Отримати інформацію щодо лоту про items[${index}].unit.name
    ${return_value}=    Отримати текст    id=items-${index}-unit_name
    [Return]    ${return_value}

Отримати інформацію щодо лоту про items[${index}].quantity
    ${return_value}=    Отримати текст    id=items-${index}-quantity
    ${return_value}=    Convert to number    ${return_value}
    [Return]    ${return_value}

Отримати інформацію щодо лоту про items[${index}].registrationDetails.status
    ${return_value}=    Отримати текст    id=items-${index}-status
    [Return]    ${return_value}

Завантажити ілюстрацію в об'єкт МП
    [Arguments]    ${username}    ${tender_uaid}    ${filepath}
    Run keyword    biddingtime.Пошук об’єкта МП по ідентифікатору    ${username}    ${tender_uaid}
    Натиснути    id=asset-upload-btn
    Select from list by value    id=files-type    illustration
    Choose file    id=files-file    ${filepath}
    Натиснути    id=upload-btn
    Wait until page contains element    id=assetID

Завантажити ілюстрацію в лот
    [Arguments]    ${username}    ${tender_uaid}    ${filepath}
    Run keyword    biddingtime.Пошук лоту по ідентифікатору    ${username}    ${tender_uaid}
    Натиснути    id=lot-upload-btn
    Select from list by value    id=files-type    illustration
    Choose file    id=files-file    ${filepath}
    Натиснути    id=upload-btn
    Wait until page contains element    id=lotID

Завантажити документ в об'єкт МП з типом
    [Arguments]    ${username}    ${tender_uaid}    ${filepath}    ${documentType}
    Run keyword    biddingtime.Пошук об’єкта МП по ідентифікатору    ${username}    ${tender_uaid}
    Натиснути    id=asset-upload-btn
    Select from list by value    id=files-type    ${documentType}
    Choose file    id=files-file    ${filepath}
    Натиснути    id=upload-btn
    Wait until page contains element    id=assetID

Завантажити документ в лот з типом
    [Arguments]    ${username}    ${tender_uaid}    ${filepath}    ${documentType}
    Run keyword    biddingtime.Пошук лоту по ідентифікатору    ${username}    ${tender_uaid}
    Натиснути    id=lot-upload-btn
    Select from list by value    id=files-type    ${documentType}
    Choose file    id=files-file    ${filepath}
    Натиснути    id=upload-btn
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
    Натиснути    id=items-0-update-btn
    ${field_value}=    Convert to string    ${field_value}
    Input text    id=items-quantity    ${field_value}
    Натиснути    id=save-btn
    Sleep    2

Змінити поле value.amount аукціону 0
    [Arguments]    ${field_value}
    Натиснути    id=auction-0-update-btn
    ${field_value}=    Convert to string    ${field_value}
    Input text    id=lotauctions-value_amount    ${field_value}
    Натиснути    id=save-btn
    Sleep    2

Змінити поле guarantee.amount аукціону 0
    [Arguments]    ${field_value}
    Натиснути    id=auction-0-update-btn
    ${field_value}=    Convert to string    ${field_value}
    Input text    id=lotauctions-guarantee_amount    ${field_value}
    Натиснути    id=save-btn
    Sleep    2

Змінити поле registrationFee.amount аукціону 0
    [Arguments]    ${field_value}
    Натиснути    id=auction-0-update-btn
    ${field_value}=    Convert to string    ${field_value}
    Input text    id=lotauctions-registrationfee_amount    ${field_value}
    Натиснути    id=save-btn
    Sleep    2

Змінити поле minimalStep.amount аукціону 0
    [Arguments]    ${field_value}
    Натиснути    id=auction-0-update-btn
    ${field_value}=    Convert to string    ${field_value}
    Input text    id=lotauctions-minimalstep_amount    ${field_value}
    Натиснути    id=save-btn
    Sleep    2

Змінити поле auctionPeriod.startDate аукціону 0
    [Arguments]    ${field_value}
    Натиснути    id=auction-0-update-btn
    Input text    id=lotauctions-auctionperiod_startdate    ${field_value}
    Натиснути    id=save-btn
    Sleep    2

Змінити title лоту
    [Arguments]    ${username}    ${tender_uaid}    ${field_value}
    Натиснути    id=update-btn
    Input text    id=lots-title    ${field_value}
    Натиснути    id=save-btn
    Sleep    2

Змінити description лоту
    [Arguments]    ${username}    ${tender_uaid}    ${field_value}
    Натиснути    id=update-btn
    Input text    id=lots-description    ${field_value}
    Натиснути    id=save-btn
    Sleep    2

Змінити title об'єкта МП
    [Arguments]    ${username}    ${tender_uaid}    ${field_value}
    Run keyword    biddingtime.Пошук об’єкта МП по ідентифікатору    ${username}    ${tender_uaid}
    Натиснути    id=asset-update-btn
    Input text    id=assets-title    ${field_value}
    Натиснути    id=asset-save-btn
    Sleep    3

Змінити description об'єкта МП
    [Arguments]    ${username}    ${tender_uaid}    ${field_value}
    Run keyword    biddingtime.Пошук об’єкта МП по ідентифікатору    ${username}    ${tender_uaid}
    Натиснути    id=asset-update-btn
    Input text    id=assets-description    ${field_value}
    Натиснути    id=asset-save-btn
    Sleep    3

Внести зміни в актив об'єкта МП
    [Arguments]    ${username}    ${item_id}    ${tender_uaid}    ${field_name}    ${field_value}
    Run keyword    biddingtime.Змінити ${field_name} об'єкта МП    ${username}    ${tender_uaid}    ${item_id}    ${field_value}

Змінити quantity об'єкта МП
    [Arguments]    ${username}    ${tender_uaid}    ${item_id}    ${field_value}
    Run keyword    biddingtime.Оновити сторінку з об'єктом МП    ${username}    ${tender_uaid}
    Натиснути    id=items-0-update-btn
    ${field_value}=    Convert to string    ${field_value}
    Input text    id=items-quantity    ${field_value}
    Натиснути    id=save-btn
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
    ${file_name}    Get Element Attribute    xpath=//a[contains(text(),'${doc_id}')]@name
    ${url}    Get Element Attribute    xpath=//a[contains(text(),'${doc_id}')]@href
    download_file    ${url}    ${file_name}    ${OUTPUT_DIR}
    [Return]    ${file_name}

Додати умови проведення аукціону
  [Arguments]  ${username}  ${auction}  ${index}  ${tender_uaid}
  Run KeyWord  biddingtime.Додати умови проведення аукціону номер ${index}  ${username}  ${tender_uaid}  ${auction}

Додати умови проведення аукціону номер 0
  [Arguments]  ${username}  ${tender_uaid}  ${auction}
  Log    ${auction}
  biddingtime.Оновити сторінку з лотом    ${username}  ${tender_uaid}
  Натиснути    id=auction-0-update-btn
  Input Text  id=lotauctions-auctionperiod_startdate    ${auction.auctionPeriod.startDate}
  ${value_amount}=    Convert To String    ${auction.value.amount}
  Input Text    id=lotauctions-value_amount    ${value_amount}
  ${value_valueaddedtaxincluded}=    Convert To String    ${auction.value.valueAddedTaxIncluded}
  Run Keyword If    '${value_valueaddedtaxincluded}' == '${True}'    Select Checkbox  id=lotauctions-value_valueaddedtaxincluded
  ${minimalStep}=    Convert To String    ${auction.minimalStep.amount}
  Input Text    id=lotauctions-minimalstep_amount    ${minimalStep}
  ${guarantee_amount}=    Convert To String    ${auction.guarantee.amount}
  Input Text    id=lotauctions-guarantee_amount    ${guarantee_amount}
  ${registrationFee}=  Convert To String    ${auction.registrationFee.amount}
  Input Text    id=lotauctions-registrationfee_amount    ${registrationFee}

  Input text    id=lotauctions-bankaccount_description    ${auction.bankAccount.bankName}
  Input text    id=lotauctions-bankaccount_bankname    ${auction.bankAccount.description}
  ${id}=    Convert to string    ${auction.bankAccount.accountIdentification[0].id}
  ${scheme}=    Convert to string    ${auction.bankAccount.accountIdentification[0].scheme}
  ${description}=    Convert to string    ${auction.bankAccount.accountIdentification[0].description}
  Input text    id=lotauctions-bankaccount_accountidentification_id    ${id}
  Select from list by value    id=lotauctions-bankaccount_accountidentification_scheme    ${scheme}
  Input text    id=lotauctions-bankaccount_accountidentification_description    ${description}

  Натиснути    id=save-btn

Додати умови проведення аукціону номер 1
  [Arguments]  ${username}  ${tender_uaid}  ${auction}
  Run keyword    biddingtime.Оновити сторінку з лотом    ${username}  ${tender_uaid}
  Натиснути    id=auction-1-update-btn
  Input text    id=lotauctions-tenderingduration    ${auction.tenderingDuration}
  Натиснути    id=save-btn
  Натиснути    id=verification-btn

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
    Натиснути    id=asset-upload-btn
    Select from list by value    id=files-type    cancellationDetails
    ${filepath}=    get_upload_file_path
    Choose file    id=files-file    ${filepath}
    Натиснути    id=upload-btn

Видалити об'єкт МП
    [Arguments]    ${username}    ${tender_uaid}
    Натиснути    id=delete-btn
    Confirm Action

Завантажити документ для видалення лоту
    [Arguments]    ${username}    ${tender_uaid}    ${filepath}
    Run keyword    biddingtime.Пошук лоту по ідентифікатору    ${username}    ${tender_uaid}
    Натиснути    id=lot-upload-btn
    Select from list by value    id=files-type    cancellationDetails
    ${filepath}=    get_upload_file_path
    Choose file    id=files-file    ${filepath}
    Натиснути    id=upload-btn

Видалити лот
    [Arguments]    ${username}    ${tender_uaid}
    Натиснути    id=delete-btn
    Confirm Action

Отримати інформацію щодо лоту про status
    Run keyword    biddingtime.Оновити дані
    ${return_value}=    Отримати текст    id=lots-status
    [Return]    ${return_value}

Отримати інформацію щодо лоту про dateModified
    ${return_value}=    Отримати текст    id=lots-datemodified
    [Return]    ${return_value}

Отримати інформацію щодо лоту про lotID
    ${return_value}=    Отримати текст    id=lots-lotid
    [Return]    ${return_value}

Отримати інформацію щодо лоту про date
    ${return_value}=    Отримати текст    id=lots-date
    [Return]    ${return_value}

Отримати інформацію щодо лоту про rectificationPeriod.endDate
    ${return_value}=    Отримати текст    id=lots-rectificationperiod_enddate
    ${return_value}=    convert_date_to_iso    ${return_value}
    [Return]    ${return_value}

Отримати інформацію щодо лоту про assets
    ${return_value}=    Отримати текст    id=lots-assetid
    [Return]    ${return_value}

Отримати інформацію щодо лоту про title
    ${return_value}=    Отримати текст    id=lots-title
    [Return]    ${return_value}

Отримати інформацію щодо лоту про title_ru
    ${return_value}=    Отримати текст    id=lots-title_ru
    [Return]    ${return_value}

Отримати інформацію щодо лоту про title_en
    ${return_value}=    Отримати текст    id=lots-title_en
    [Return]    ${return_value}

Отримати інформацію щодо лоту про description
    ${return_value}=    Отримати текст    id=lots-description
    [Return]    ${return_value}

Отримати інформацію щодо лоту про lotHolder.name
    ${return_value}=    Отримати текст    id=organizations-name
    [Return]    ${return_value}

Отримати інформацію щодо лоту про lotHolder.identifier.scheme
    ${return_value}=    Отримати текст    id=organizations-identifier_scheme
    [Return]    ${return_value}

Отримати інформацію щодо лоту про lotHolder.identifier.id
    ${return_value}=    Отримати текст    id=organizations-identifier_id
    [Return]    ${return_value}

Отримати інформацію щодо лоту про lotCustodian.identifier.scheme
    ${return_value}=    Отримати текст    id=custodian-identifier_scheme
    [Return]    ${return_value}

Отримати інформацію щодо лоту про lotCustodian.identifier.id
    ${return_value}=    Отримати текст    id=custodian-identifier_id
    [Return]    ${return_value}

Отримати інформацію щодо лоту про lotCustodian.identifier.legalName
    ${return_value}=    Отримати текст    id=custodian-identifier_legalName
    [Return]    ${return_value}

Отримати інформацію щодо лоту про lotCustodian.contactPoint.name
    ${return_value}=    Отримати текст    id=custodian-contactpoint_name
    [Return]    ${return_value}

Отримати інформацію щодо лоту про lotCustodian.contactPoint.telephone
    ${return_value}=    Отримати текст    id=custodian-contactpoint_telephone
    [Return]    ${return_value}

Отримати інформацію щодо лоту про lotCustodian.contactPoint.email
    ${return_value}=    Отримати текст    id=custodian-contactpoint_email
    [Return]    ${return_value}

Отримати інформацію щодо лоту про decisions[${index}].decisionDate
    ${return_value}=    Отримати текст    id=decisions-${index}-decisionDate
    [Return]    ${return_value}

Отримати інформацію щодо лоту про decisions[${index}].decisionID
    ${return_value}=    Отримати текст    id=decisions-${index}-decisionID
    [Return]    ${return_value}

Отримати інформацію щодо лоту про decisions[${index}].title
    ${return_value}=    Отримати текст    id=decisions-${index}-title
    [Return]    ${return_value}

Отримати інформацію щодо лоту про auctions[${index}].procurementMethodType
    ${return_value}=    Отримати текст    id=auctions-${index}-procurementMethodType
    [Return]    ${return_value}

Отримати інформацію щодо лоту про auctions[${index}].status
    ${return_value}=    Отримати текст    id=auctions-${index}-status
    [Return]    ${return_value}

Отримати інформацію щодо лоту про auctions[${index}].tenderAttempts
    ${return_value}=    Отримати текст    id=auctions-${index}-tenderAttempts
    ${return_value}=    Convert to number    ${return_value}
    [Return]    ${return_value}

Отримати інформацію щодо лоту про auctions[${index}].value.amount
    ${return_value}=    Отримати текст    id=auctions-${index}-value_amount
    ${return_value}=    Convert to number    ${return_value}
    [Return]    ${return_value}

Отримати інформацію щодо лоту про auctions[${index}].minimalStep.amount
    ${return_value}=    Отримати текст    id=auctions-${index}-minimalStep_amount
    ${return_value}=    Convert to number    ${return_value}
    [Return]    ${return_value}

Отримати інформацію щодо лоту про auctions[${index}].guarantee.amount
    ${return_value}=    Отримати текст    id=auctions-${index}-guarantee_amount
    ${return_value}=    Convert to number    ${return_value}
    [Return]    ${return_value}

Отримати інформацію щодо лоту про auctions[${index}].registrationFee.amount
    ${return_value}=    Отримати текст    id=auctions-${index}-registrationFee_amount
    ${return_value}=    Convert to number    ${return_value}
    [Return]    ${return_value}

Отримати інформацію щодо лоту про auctions[${index}].tenderingDuration
    ${return_value}=    Отримати текст    id=auctions-${index}-tenderingDuration
    [Return]    ${return_value}

Отримати інформацію щодо лоту про auctions[${index}].auctionPeriod.startDate
    ${return_value}=    Отримати текст    id=auctions-${index}-auctionPeriod_startDate
    [Return]    ${return_value}

Отримати інформацію щодо лоту про auctions[${index}].auctionID
    ${return_value}=    Отримати текст    id=auctions-${index}-auctionID
    [Return]    ${return_value}

Отримати значення поля description щодо активу лоту
    [Arguments]    ${username}    ${tender_uaid}    ${item_id}
    ${return_value}=    Отримати текст    id=items-${item_id}-description
    [Return]    ${return_value}

Отримати значення поля classification.scheme щодо активу лоту
    [Arguments]    ${username}    ${tender_uaid}    ${item_id}
    ${return_value}=    Отримати текст    id=items-${item_id}-classification_scheme
    [Return]    ${return_value}

Отримати значення поля classification.id щодо активу лоту
    [Arguments]    ${username}    ${tender_uaid}    ${item_id}
    ${return_value}=    Отримати текст    id=items-${item_id}-classification_id
    [Return]    ${return_value}

Отримати значення поля unit.name щодо активу лоту
    [Arguments]    ${username}    ${tender_uaid}    ${item_id}
    ${return_value}=    Отримати текст    id=items-${item_id}-unit_name
    [Return]    ${return_value}

Отримати значення поля quantity щодо активу лоту
    [Arguments]    ${username}    ${tender_uaid}    ${item_id}
    ${return_value}=    Отримати текст    id=items-${item_id}-quantity
    ${return_value}=    Convert to number    ${return_value}
    [Return]    ${return_value}

Отримати значення поля registrationDetails.status щодо активу лоту
    [Arguments]    ${username}    ${tender_uaid}    ${item_id}
    ${return_value}=    Отримати текст    id=items-${item_id}-registrationDetails_status
    [Return]    ${return_value}

Активувати процедуру
    [Arguments]    ${username}    ${tender_uaid}
    [Return]    ${True}

Оновити сторінку з тендером
    [Arguments]    ${username}    ${tender_uaid}
    Натиснути    id=auctions-list
    Input text    id=auctionssearch-main_search    ${tender_uaid}
    Неквапливо натиснути    id=public-search-btn
    Неквапливо натиснути    id=refresh-btn

Пошук тендера по ідентифікатору
    [Arguments]    ${username}    ${tender_uaid}
    Run keyword    biddingtime.Оновити сторінку з тендером    ${username}    ${tender_uaid}

Отримати інформацію із тендера
    [Arguments]    ${username}    ${tender_uaid}    ${field_name}
    Run keyword    biddingtime.Оновити сторінку з тендером    ${username}    ${tender_uaid}
    ${return_value}=    Run keyword    biddingtime.Отримати значення поля ${field_name} тендеру
    [Return]    ${return_value}

Отримати значення поля auctionID тендеру
    ${return_value}=    Отримати текст    id=auction-auctionID
    [Return]    ${return_value}

Отримати значення поля status тендеру
    ${return_value}=    Отримати текст    id=auction-status
    [Return]    ${return_value}

Отримати значення поля title тендеру
    ${return_value}=    Отримати текст    id=auction-title
    [Return]    ${return_value}

Отримати значення поля description тендеру
    ${return_value}=    Отримати текст    id=auction-description
    [Return]    ${return_value}

Отримати значення поля minNumberOfQualifiedBids тендеру
    ${return_value}=    Отримати текст    id=auction-minNumberOfQualifiedBids
    ${return_value}=    Convert to number    ${return_value}
    [Return]    ${return_value}

Отримати значення поля procurementMethodType тендеру
    ${return_value}=    Отримати текст    id=auction-procurementMethodType
    [Return]    ${return_value}

Отримати значення поля procuringEntity.name тендеру
    ${return_value}=    Отримати текст    id=auction-procuringEntity_name
    [Return]    ${return_value}

Отримати значення поля value.amount тендеру
    ${return_value}=    Отримати текст    id=auction_value_amount
    ${return_value}=    Convert to number    ${return_value}
    [Return]    ${return_value}

Отримати значення поля guarantee.amount тендеру
    ${return_value}=    Отримати текст    id=auction-guarantee_amount
    ${return_value}=    Convert to number    ${return_value}
    [Return]    ${return_value}

Отримати значення поля minimalStep.amount тендеру
    ${return_value}=    Отримати текст    id=auction-minimalStep_amount
    ${return_value}=    Convert to number    ${return_value}
    [Return]    ${return_value}

Отримати значення поля registrationFee.amount тендеру
    ${return_value}=    Отримати текст    id=auction-registrationFee_amount
    ${return_value}=    Convert to number    ${return_value}
    [Return]    ${return_value}

Отримати значення поля tenderPeriod.endDate тендеру
    ${return_value}=    Отримати текст    id=auction-tenderPeriod_endDate
    ${return_value}=    convert_date_to_iso    ${return_value}
    [Return]    ${return_value}

Отримати інформацію із предмету
    [Arguments]    ${username}    ${tender_uaid}    ${item_id}    ${field_name}
    ${return_value}=    Отримати текст    id=items[${item_id}].${field_name}
    ${return_value}=    Run keyword if    '${field_name}' == 'quantity'    Convert to number    ${return_value}
    ...   ELSE    Set variable    ${return_value}
    [Return]    ${return_value}

Отримати значення поля items[${index}].unit.name тендеру
    ${return_value}=    Отримати текст    id=items[${index}].unit_name
    [Return]    ${return_value}

Отримати значення поля items[${index}].description тендеру
    ${return_value}=    Отримати текст    id=items[${index}].description
    [Return]    ${return_value}

Отримати інформацію із запитання
    [Arguments]    ${username}    ${tender_uaid}    ${question_id}    ${field_name}
    Run keyword    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Неквапливо натиснути    id=tab-selector-2
    ${return_value}=    Отримати текст    id=questions-${question_id}-${field_name}
    [Return]    ${return_value}

Отримати значення поля questions[0].description тендеру
    Неквапливо натиснути    id=tab-selector-2
    ${return_value}=    Отримати текст    name=questions-0-description
    [Return]    ${return_value}

Отримати значення поля questions[0].title тендеру
    Неквапливо натиснути    id=tab-selector-2
    ${return_value}=    Отримати текст    name=questions-0-title
    [Return]    ${return_value}

Отримати значення поля questions[0].answer тендеру
    Неквапливо натиснути    id=tab-selector-2
    ${return_value}=    Отримати текст    name=questions-0-answer
    [Return]    ${return_value}

Отримати значення поля questions[1].description тендеру
    Неквапливо натиснути    id=tab-selector-2
    ${return_value}=    Отримати текст    name=questions-1-description
    [Return]    ${return_value}

Отримати значення поля questions[1].title тендеру
    Неквапливо натиснути    id=tab-selector-2
    ${return_value}=    Отримати текст    name=questions-1-title
    [Return]    ${return_value}

Отримати значення поля questions[1].answer тендеру
    Неквапливо натиснути    id=tab-selector-2
    ${return_value}=    Отримати текст    name=questions-1-answer
    [Return]    ${return_value}

Відповісти на запитання
    [Arguments]    ${username}    ${tender_uaid}    ${answer_data}    ${question_id}
    Run keyword    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Неквапливо натиснути    id=tab-selector-2
    Натиснути    id=question-${question_id}-answer
    Input text    id=questions-answer    ${answer_data.data.answer}
    Натиснути    id=create-question-btn
    Sleep    2
    Run keyword    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}

Подати цінову пропозицію
    [Arguments]    ${username}    ${tender_uaid}    ${bid}
    Run keyword    biddingtime.Змінити дані профілю учасника    ${bid.data.tenderers[0]}
    Run keyword    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Натиснути    id=bid-create-btn
    ${amount}=    Convert to string    ${bid.data.value.amount}
    Input text    id=bids-value_amount    ${amount}
    Run keyword if    '${bid.data.qualified}' == '${True}'    Натиснути    id=bids-oferta
    Натиснути    id=bid-save-btn
    Натиснути    id=bid-activate-btn
    Натиснути    id=refresh-btn

Скасувати закупівлю
    [Arguments]    ${username}    ${tender_uaid}    ${cancellation_reason}    ${document}    ${description}
    Run keyword    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Натиснути    id=lot-view-btn
    Натиснути    id=cancel-auction-btn
    Select from list by value    id=cancellations-reason    ${cancellation_reason}
    Натиснути    id=create-cancellation-btn
    Натиснути    id=add-cancellation-document
    Choose file    id=files-file    ${document}
    Input text    id=cancellations-description    ${description}
    Натиснути    id=upload-document
    Натиснути    confirm-cancellation-btn
    Натиснути   id=refresh-btn

Отримати значення поля cancellations[0].status тендеру
    ${return_value}=    Отримати текст    id=cancellation-status
    [Return]    ${return_value}

Отримати значення поля cancellations[0].reason тендеру
    ${return_value}=    Отримати текст    id=cancellation-reason
    [Return]    ${return_value}

Отримати інформацію із документа
    [Arguments]    ${username}    ${tender_uaid}    ${doc_id}    ${field}
    ${return_value}=    Run keyword    biddingtime.Отримати значення поля ${field} документу    ${doc_id}
    [Return]    ${return_value}

Отримати значення поля title документу
    [Arguments]    ${doc_id}
    ${return_value}=    Отримати текст    id=documents-${doc_id}-title
    [Return]    ${return_value}

Отримати значення поля description документу
    [Arguments]    ${doc_id}
    ${return_value}=    Отримати текст    id=documents-${doc_id}-description
    [Return]    ${return_value}

Скасувати цінову пропозицію
    [Arguments]    ${username}    ${tender_uaid}
    Натиснути    id=bid-delete-btn

Отримати посилання на аукціон для глядача
    [Arguments]    ${username}    ${tender_uaid}    ${lot_id}=${Empty}
    Run keyword    biddingtime.Оновити сторінку з тендером    ${username}    ${tender_uaid}
    ${return_value}=    Отримати текст    id=auction-url
    [Return]    ${return_value}

Отримати інформацію із пропозиції
    [Arguments]    ${username}    ${tender_uaid}    ${field}
    Run keyword    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Натиснути    id=bid-create-btn
    ${return_value}=    Run keyword    biddingtime.Отримати інформацію з пропозиції шодо ${field}
    [Return]    ${return_value}

biddingtime.Отримати інформацію з пропозиції шодо value.amount
    ${return_value}=    Отримати текст    id=bids-value_amount
    ${return_value}=    Convert to number    ${return_value}
    [Return]    ${return_value}

Задати запитання на тендер
    [Arguments]    ${username}    ${tender_uaid}    ${question}
    Run keyword    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Неквапливо натиснути    id=create-question-btn
    Input text    id=question-title    ${question.data.title}
    Input text    id=question-description    ${question.data.description}
    Натиснути    id=submit-question-btn
    Sleep    2
    Run keyword    biddingtime.Оновити дані

Задати запитання на предмет
    [Arguments]    ${username}    ${tender_uaid}    ${item_id}    ${question}
    Run keyword    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Неквапливо натиснути    id=${item_id}item
    Input text    id=question-title    ${question.data.title}
    Input text    id=question-description    ${question.data.description}
    Натиснути    id=submit-question-btn
    Sleep    2
    Run keyword    biddingtime.Оновити дані

Завантажити документ в ставку
    [Arguments]    ${username}    ${path}    ${tender_uaid}    ${doc_type}=commercialProposal
    Run keyword    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Натиснути    id=bid-create-btn
    Select from list by value    id=files-type    ${doc_type}
    ${filepath}=    get_upload_file_path
    Choose file    id=files-file    ${filepath}
    Натиснути    id=document-upload-btn

Змінити цінову пропозицію
    [Arguments]    ${username}    ${tender_uaid}    ${fieldname}    ${field_value}
    Натиснути    id=bid-update-btn
    ${amount}=    Convert to string    ${field_value}
    Input text    id=bids-value_amount    ${amount}
    Натиснути    id=bids-oferta
    Натиснути    bid-save-btn
    Run keyword    biddingtime.Оновити дані

Отримати посилання на аукціон для учасника
    [Arguments]    ${username}    ${tender_uaid}    ${lot_id}=${Empty}
    Run keyword    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    ${return_value}=    Отримати текст    id=auction-url
    [Return]    ${return_value}

Завантажити протокол аукціону в авард
    [Arguments]    ${username}    ${tender_uaid}    ${filepath}    ${award_index}
    Run keyword    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Натиснути    id=bids[0]-link
    Натиснути    id=upload-protocol-btn
    ${filepath}=    get_upload_file_path
    Choose file    id=files-file    ${filepath}
    Натиснути    id=bid-upload-protocol
    Sleep    3

Завантажити протокол погодження в авард
    [Arguments]    ${username}    ${tender_uaid}    ${filepath}    ${award_index}
    Run keyword    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Натиснути    id=bids[0]-link
    Натиснути    id=upload-admission-btn
    ${filepath}=    get_upload_file_path
    Choose file    id=files-file    ${filepath}
    Натиснути    id=bid-upload-admission
    Sleep    3

Активувати кваліфікацію учасника
    [Arguments]    ${username}    ${tender_uaid}
    Run keyword    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Натиснути    id=bids[0]-link
    Натиснути    id=confirm-admission-btn

Підтвердити постачальника
    [Arguments]    ${username}    ${tender_uaid}    ${award_num}
    Run keyword    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Натиснути    id=bids[0]-link
    Натиснути    id=confirm-protocol-btn
    Sleep    3

Завантажити протокол дискваліфікації в авард
    [Arguments]    ${username}    ${tender_uaid}    ${filename}    ${award_index}
    Run keyword    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Натиснути    id=bids[0]-link
    Натиснути    id=disqualify-link
    ${filepath}=    get_upload_file_path
    Choose file    id=files-file    ${filepath}

Дискваліфікувати постачальника
    [Arguments]    ${username}    ${tender_uaid}    ${award_index}    ${description}
    Input text    id=awards-description    ${description}
    Натиснути    id=upload-disqualification-btn
    Sleep    3

Встановити дату підписання угоди
    [Arguments]    ${username}    ${tender_uaid}    ${contract_num}    ${field_value}
    Run keyword    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Натиснути    id=bids[0]-link
    Натиснути    id=contract-signed-btn
    Input text    id=contracts-datesigned    ${field_value}
    Натиснути    id=contract-signed-submit
    Sleep    3

Завантажити угоду до тендера
    [Arguments]    ${username}    ${tender_uaid}    ${contract_num}    ${filepath}
    Run keyword    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Натиснути    id=bids[0]-link
    Натиснути    id=upload-contract-link
    ${filepath}=    get_upload_file_path
    Choose file    id=files-file    ${filepath}
    Натиснути    id=upload-contract-btn
    Sleep    3

Підтвердити підписання контракту
    [Arguments]    ${username}    ${tender_uaid}    ${contract_num}
    Run keyword    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Натиснути    id=bids[0]-link
    Натиснути    id=contract-signed-btn
    Натиснути    id=contract-signed-submit
    Sleep    3

Завантажити протокол скасування в контракт
    [Arguments]    ${username}    ${tender_uaid}    ${filepath}    ${contract_num}
    Run keyword    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Натиснути    id=bids[0]-link
    Натиснути    id=contract-upload-cancellation
    ${filepath}    get_upload_file_path
    Choose file    id=files-file    ${filepath}
    Натиснути    id=upload-contract-btn
    Sleep    3

Скасувати контракт
    [Arguments]    ${username}    ${tender_uaid}    ${contract_num}
    Run keyword    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Натиснути    id=bids[0]-link
    Натиснути    id=confirm-declining-contract
    Sleep    3

Отримати кількість авардів в тендері
    [Arguments]    ${username}    ${tender_uaid}
    ${awards_count}=    Get text    id=awards-count
    ${awards_count}=    Convert to number    ${awards_count}
    [Return]    ${awards_count}

Скасування рішення кваліфікаційної комісії
    [Arguments]    ${username}    ${tender_uaid}    ${award_num}
    Run keyword    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Натиснути    id=bids[1]-link
    Натиснути    id=cancel-bid-btn

Активувати контракт
    [Arguments]    ${username}    ${contract_uaid}
    Run keyword    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${contract_uaid}

Отримати інформацію із договору
    [Arguments]    ${username}    ${contract_uaid}    ${field_name}
    Run keyword    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${contract_uaid}
    ${return_value}=    Отримати текст    id=contract-${field_name}
    [Return]    ${return_value}

Вказати дату отримання оплати
    [Arguments]    ${username}    ${contract_uaid}    ${dateMet}    ${milestone_index}
    Run keyword    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${contract_uaid}
    Натиснути    id=bids[0]-link
    Input text    id=milestones-datemet    ${dateMet}
    Натиснути    id=confirm-milestone-btn
    Sleep    3

Завантажити наказ про завершення приватизації
    [Arguments]    ${username}    ${contract_uaid}    ${filepath}
    Run keyword    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${contract_uaid}
    Натиснути    id=bids[0]-link
    Select from list by value    id=milestones-type    approvalProtocol
    Choose file    id=files-file    ${filepath}
    Натиснути    id=upload-milestone-document-btn
    Sleep    59

Вказати дату прийняття наказу
    [Arguments]    ${username}    ${contract_uaid}    ${dateMet}
    Run keyword    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${contract_uaid}
    Натиснути    id=bids[0]-link
    Input text    id=milestones-datemet    ${dateMet}
    Натиснути    id=confirm-milestone-btn
    Sleep    3

Вказати дату виконання умов контракту
    [Arguments]    ${username}    ${contract_uaid}    ${dateMet}
    Run keyword    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${contract_uaid}
    Натиснути    id=bids[0]-link
    Input text    id=milestones-datemet    ${dateMet}
    Натиснути    id=confirm-milestone-btn
    Sleep    3

Підтвердити відсутність оплати
    [Arguments]    ${username}    ${contract_uaid}    ${milestone_index}
    Run keyword    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${contract_uaid}
    Натиснути    id=bids[0]-link
    Натиснути    id=decline-milestone-btn
    Sleep    3

Підтвердити відсутність наказу про приватизацію
    [Arguments]    ${username}    ${contract_uaid}    ${filepath}
    Run keyword    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${contract_uaid}
    Натиснути    id=bids[0]-link
    Select from list by value    id=milestones-type    rejectionProtocol
    Choose file    id=files-file    ${filepath}
    Натиснути    id=upload-milestone-document-btn
    Sleep    3
    Run keyword    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${contract_uaid}
    Натиснути    id=bids[0]-link
    Натиснути    id=decline-milestone-btn
    Sleep    3

Підтвердити невиконання умов приватизації
    [Arguments]    ${username}    ${contract_uaid}
    Run keyword    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${contract_uaid}
    Натиснути    id=bids[0]-link
    Натиснути    id=decline-milestone-btn
    Sleep    3