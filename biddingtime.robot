*** Settings ***
Library           String
Library           Selenium2Library
Library           Collections
Library           biddingtime_service.py

*** Variables ***
${locator.edit.description}    id = lots-description
${locator.edit.title}    id = lots-name
${locator.edit.dgfID}    id = lots-num
${locator.edit.dgfDecisionDate}    id = lots-dgfdecisiondate
${locator.edit.dgfDecisionID}    id = lots-dgfdecisionid
${locator.edit.tenderAttempts}    id = lots-tenderattempts
${locator.edit.title_ru}    id = lots-name
${locator.edit.title_en}    id = lots-name
${locator.title_ru}    id = auction-title
${locator.title_en}    id = auction-title
${locator.title}    id = auction-title
${locator.description}    id = auction-description
${locator.minimalStep.amount}    id = auction-minimalStep_amount
${locator.value-amount}    id = auction_value_amount
${locator.value-valueAddedTaxIncluded}    id=auction-valueAddedTaxIncluded
${locator.value.currency}    id=value-currency
${locator.auctionPeriod.startDate}    id = auction-auctionPeriod_startDate
${locator.auctionPeriod.endDate}    id = auction-auctionPeriod_endDate
${locator.enquiryPeriod.startDate}    id = auction-enquiryPeriod_startDate
${locator.enquiryPeriod.endDate}    id = auction-enquiryPeriod_endDate
${locator.tenderPeriod.startDate}    id = auction-tenderPeriod_startDate
${locator.tenderPeriod.endDate}    id = auction-tenderPeriod_endDate
${locator.tenderId}    id = auction-auctionID
${locator.procuringEntity.name}    id = auction-procuringEntity_name
${locator.dgfID}    id = auction-dgfID
${locator.dgfDecisionID}    id=auction-dgfDecisionID
${locator.dgfDecisionDate}    id=auction-dgfDecisionDate
${locator.eligibilityCriteria}    id=auction-eligibilityCriteria
${locator.tenderAttempts}    id=auction-tenderAttempts
${locator.procurementMethodType}    id=auction-procurementMethodType
${locator.items[0].quantity}    id=items[0].quantity
${locator.items[0].description}    id = items[0].description
${locator.items[0].unit.code}    id = items[0].unit_code
${locator.items[0].unit.name}    id = items[0].unit_name
${locator.items[0].deliveryAddress.postalCode}    id=items[0].postalCode
${locator.items[0].deliveryAddress.region}    id=items[0].region
${locator.items[0].deliveryAddress.locality}    id=items[0].locality
${locator.items[0].deliveryAddress.streetAddress}    id=items[0].streetAddress
${locator.items[0].classification.scheme}    id=items[0].classification.scheme
${locator.items[0].classification.id}    id = items[0].classification.id
${locator.items[0].classification.description}    id = items[0].classification_description
${locator.items[0].additionalClassifications[0].scheme}    id=items[0].additionalClassifications.description
${locator.items[0].additionalClassifications[0].id}    id=items[0].additionalClassifications.id
${locator.items[0].additionalClassifications[0].description}    id=items[0].additionalClassifications.description
${locator.items[1].description}    id = items[1].description
${locator.items[1].classification.id}    id = items[1].classification.id
${locator.items[1].classification.description}    id = items[1].classification_description
${locator.items[1].classification.scheme}    id=items[1].classification.scheme
${locator.items[1].unit.code}    id = items[1].unit_code
${locator.items[1].unit.name}    id=items[1].unit_name
${locator.items[1].quantity}    id=items[1].quantity
${locator.items[2].description}    id = items[2].description
${locator.items[2].classification.id}    id = items[2].classification.id
${locator.items[2].classification.description}    id = items[2].classification_description
${locator.items[2].classification.scheme}    id=items[2].classification.scheme
${locator.items[2].unit.code}    id = items[2].unit_code
${locator.items[2].unit.name}    id = items[2].unit_name
${locator.items[2].quantity}    id=items[2].quantity
${locator.questions[0].title}    id = question[1].title
${locator.questions[0].description}    id=question[1].description
${locator.questions[0].date}    id = question[1].date
${locator.questions[0].answer}    id = question[1].answer
${locator.questions[1].title}    id = question[2].title
${locator.questions[1].description}    id=question[2].description
${locator.questions[1].date}    id = question[2].date
${locator.questions[1].answer}    id = question[2].answer
${locator.questions[2].title}    id = question[3].title
${locator.questions[2].description}    id=question[3].description
${locator.questions[2].date}    id = question[3].date
${locator.questions[2].answer}    id = question[3].answer
${locator.questions[3].title}    id = question[4].title
${locator.questions[3].description}    id=question[4].description
${locator.questions[3].date}    id = question[4].date
${locator.questions[3].answer}    id = question[4].answer
${locator.questions[4].title}    id = question[4].title
${locator.questions[4].description}    id=question[4].description
${locator.questions[4].date}    id = question[4].date
${locator.questions[4].answer}    id = question[3].answer
${locator.cancellations[0].status}    id = cancellation-status
${locator.cancellations[0].reason}    id = cancellaltion-reason
${locator.contracts.status}    css=.contract_status
${locator.procuringEntity.contactPoint.name}    id = lots-ownername
${locator.awards[0].status}    id = awards[0].status
${locator.awards[1].status}    id = awards[1].status


*** Keywords ***
Підготувати клієнт для користувача
    [Arguments]    ${username}
    ${alias}=   Catenate   SEPARATOR=   role_  ${username}
    Set Global Variable   ${BROWSER_ALIAS}   ${alias}

    Open Browser    ${USERS.users['${username}'].homepage}    ${USERS.users['${username}'].browser}    alias=${BROWSER_ALIAS}
    Set Window Size    @{USERS.users['${username}'].size}
    Set Window Position    @{USERS.users['${username}'].position}
    Run Keyword If    '${username}' != 'biddingtime_Viewer'    Login    ${username}

Підготувати дані для оголошення тендера
    [Arguments]    ${username}    ${tender_data}    ${role_name}
    [Return]    ${tender_data}

Login
    [Arguments]    @{ARGUMENTS}
    Go to    ${USERS.users['${ARGUMENTS[0]}'].homepage}
    Input text    id=login-form-login    ${USERS.users['${ARGUMENTS[0]}'].login}
    Input text    id = login-form-password    ${USERS.users['${ARGUMENTS[0]}'].password}
    Click Element    id=login-btn
    Sleep    1

Змінити користувача
    [Arguments]    @{ARGUMENTS}
    Go to    ${USERS.users['${ARGUMENTS[0]}'].homepage}
    Sleep    1
    Input text    id=login-form-login    ${USERS.users['${ARGUMENTS[0]}'].login}
    Input text    id = login-form-password    ${USERS.users['${ARGUMENTS[0]}'].password}
    Click Element    id=login-btn
    Sleep    1

Створити тендер
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[1]} == tender_data
    Set Global Variable    ${TENDER_INIT_DATA_LIST}    ${ARGUMENTS[1]}
    ${title}=    Get From Dictionary    ${ARGUMENTS[1].data}    title
    ${dgf}=    Get From Dictionary    ${ARGUMENTS[1].data}    dgfID
    ${dgfDecisionDate}=    convert_ISO_DMY    ${ARGUMENTS[1].data.dgfDecisionDate}
    ${dgfDecisionID}=    Get From Dictionary    ${ARGUMENTS[1].data}    dgfDecisionID
    ${tenderAttempts}=    get_tenderAttempts    ${ARGUMENTS[1].data}
    ${description}=    Get From Dictionary    ${ARGUMENTS[1].data}    description
    ${procuringEntity_name}=    Get From Dictionary    ${ARGUMENTS[1].data.procuringEntity}    name
    ${items}=    Get From Dictionary    ${ARGUMENTS[1].data}    items
    ${budget}=    get_budget    ${ARGUMENTS[1]}
    ${step_rate}=    get_step_rate    ${ARGUMENTS[1]}
    ${currency}=    Get From Dictionary    ${ARGUMENTS[1].data.value}    currency
    ${valueAddedTaxIncluded}=    Get From Dictionary    ${ARGUMENTS[1].data.value}    valueAddedTaxIncluded
    ${start_day_auction}=    get_tender_dates    ${ARGUMENTS[1]}    StartDate
    ${start_time_auction}=    get_tender_dates    ${ARGUMENTS[1]}    StartTime
    ${item0}=    Get From List    ${items}    0
    ${descr_lot}=    Get From Dictionary    ${item0}    description
    ${unit}=    Get From Dictionary    ${items[0].unit}    code
    ${cav_id}=    Get From Dictionary    ${items[0].classification}    id
    ${quantity}=    get_quantity    ${items[0]}
    Switch Browser    ${BROWSER_ALIAS}
    Wait Until Page Contains Element    id=cabinet    3
    Click Element    id=cabinet
    Wait Until Page Contains Element    id=create-auction-btn    20
    Click Element    id=create-auction-btn
    Wait Until Page Contains Element    id=lots-name    20
    Select From List By Value    id=lots-procurementmethodtype    ${ARGUMENTS[1].data.procurementMethodType}
    Input text    id=lots-name    ${title}
    Input text    id=lots-description    ${description}
    Input text    id=lots-num    ${dgf}
    Input text    id=lots-dgfdecisionid    ${dgfDecisionID}
    Input text    id=lots-dgfdecisiondate    ${dgfDecisionDate}
    Input text    id=lots-dgfdecisiondate    ${dgfDecisionDate}
    Input text    id = lots-ownername    ${procuringEntity_name}
    Select From List By Value    id=lots-tenderattempts    ${tenderAttempts}
    Input text    id=lots-start_price    ${budget}
    Click Element    id=lots-nds
    Input text    id=lots-auction_date    ${start_day_auction}
    Input text    id=lots-auction_time    ${start_time_auction}
    Input text    id=lots-step    ${step_rate}
    Input text    id = lots-delivery_time    ${dgfDecisionDate}
    Input text    id = lots-delivery_term    'test'
    Input text    id = lots-requires    'test'
    Input text    id = lots-notes    'test'
    Click Element    id=submit-auction-btn
    Sleep    2
    ${items}=    Get From Dictionary    ${ARGUMENTS[1].data}    items
    ${Items_length}=    Get Length      ${items}
    :FOR   ${index}   IN RANGE   ${Items_length}
    \       Додати предмет    ${items[${index}]}          ${index}
    Sleep    1
    Click Element    id = submit-auction-btn
    Click Element    id =publish-btn
    Sleep    2
    ${tender_id}=    Get Text    id = auction-id
    ${TENDER}=    Get Text    id= auction-id
    log to console    ${TENDER}
    [Return]    ${TENDER}

Додати предмет
    [Arguments]    ${item}    ${index}
    Click Element    id = create-item-btn
    Sleep    2
    Input text    id=items-description    ${item.description}
    Input text    id=items-quantity    ${item.quantity}
    Select From List By Value    id=items-unit_code    ${item.unit.code}
    Select From List By Value    id=items-address_region    ${item.deliveryAddress.region}
    Input text    id=items-classification_id    ${item.classification.id}
    Input text    id=items-address_postalcode    ${item.deliveryAddress.postalCode}
    Input text    id=items-address_locality    ${item.deliveryAddress.locality}
    Input text    id=items-address_streetaddress    ${item.deliveryAddress.streetAddress}
    Click Element    id = btn-item-add

Додати предмет закупівлі
    [Arguments]  ${username}  ${tender_uaid}  ${item}
    biddingtime.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
    Click Element  id=lot-update-btn
    Run Keyword And Ignore Error  Click Element    id = btn-item-add

Видалити предмет закупівлі
    [Arguments]  ${username}  ${tender_uaid}  ${item_id}
    biddingtime.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
    Click Element  id=lot-update-btn
    Run Keyword And Ignore Error  Click Element    id = btn-item-add

Завантажити документ
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[1]} == ${filepath}
    ...    ${ARGUMENTS[2]} == ${TENDER}
    biddingtime.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[2]}
    Click Element    id=lot-update-btn
    Wait Until Page Contains Element    id = files-type    20
    Select From List By Value    id = files-type    technicalSpecifications
    Choose File    id = file-type-input    ${ARGUMENTS[1]}
    Sleep    1
    Click Element    id=lot-document-upload-btn
    Reload Page

Завантажити документ в тендер з типом
    [Arguments]    ${username}    ${tender_uaid}    ${filepath}    ${doc_type}
    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Click Element    id=lot-update-btn
    Wait Until Page Contains Element    id = files-type    20
    Select From List By Value    id = files-type    ${doc_type}
    Choose File    id = file-type-input    ${filepath}
    Sleep    1
    Click Element    id=lot-document-upload-btn

Завантажити ілюстрацію
    [Arguments]  ${username}  ${tender_uaid}  ${filepath}
    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Click Element    id=lot-update-btn
    Wait Until Page Contains Element    id = files-type    20
    Select From List By Value    id = files-type    illustration
    Choose File    id = file-type-input    ${filepath}
    Sleep    1
    Click Element    id=lot-document-upload-btn
    Reload Page

Додати Virtual Data Room
    [Arguments]  ${username}  ${tender_uaid}  ${vdr_url}
    biddingtime.Пошук тендера по ідентифікатору   ${username}   ${tender_uaid}
    Click Element    id=lot-update-btn
    Wait Until Page Contains Element    id = lots-vdr    20
    Input Text    id = lots-vdr    ${vdr_url}
    Click Element    id=submit-auction-btn
    Reload Page

Додати публічний паспорт активу
    [Arguments]  ${username}  ${tender_uaid}  ${accessDetails}
    biddingtime.Пошук тендера по ідентифікатору   ${username}   ${tender_uaid}
    Click Element    id=lot-update-btn
    Wait Until Page Contains Element    id = lots-passport    20
    Input text    id = lots-passport    ${accessDetails} 
    Click Element    id=submit-auction-btn
    Reload Page

Додати офлайн документ
  [Arguments]  ${username}  ${tender_uaid}  ${accessDetails}  ${title}=Familiarization with bank asset
  biddingtime.Пошук тендера по ідентифікатору   ${username}   ${tender_uaid}
  Click Element  id = lot-update-btn
  Wait Until Element Is Visible  id = lots-address
  Input Text  id = lots-address    ${accessDetails}
  Click Element    id = submit-auction-btn

Пошук тендера по ідентифікатору
    [Arguments]    ${username}  ${tender_uaid}
    Switch Browser    ${BROWSER_ALIAS}
    Go to    ${USERS.users['${username}'].default_page}
    Wait Until Page Contains Element    id = auctionssearch-main_search
    Input Text    id = auctionssearch-main_search    ${tender_uaid}
    Sleep    1
    Click Element    id = public-search-btn
    Sleep    2
    Wait Until Page Contains Element    id=auction-view-btn
    Click Element    id=auction-view-btn

Отримати інформацію про cancellations[0].status
    Wait Until Page Contains Element    id = cancellation-status
    ${return_value}=    Get text    id = cancellation-status
    [Return]    ${return_value}

Отримати інформацію про cancellations[0].reason
    Wait Until Page Contains Element    id = cancellation-reason
    ${return_value}=    Get text    id = cancellation-reason
    [Return]    ${return_value}

Оновити сторінку з тендером
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} = username
    ...    ${ARGUMENTS[1]} = ${TENDER_UAID}
    Switch Browser    ${BROWSER_ALIAS}
    biddingtime.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[1]}

Отримати інформацію із предмету
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[1]} == tender_uaid
    ...    ${ARGUMENTS[2]} == item_id
    ...    ${ARGUMENTS[3]} == field_name
    ${return_value}=    Run Keyword And Return    biddingtime.Отримати інформацію із тендера    ${username}    ${tender_uaid}    ${field_name}
    [Return]    ${return_value}

Отримати кількість предметів в тендері
    [Arguments]  ${username}  ${tender_uaid}
    biddingtime.Пошук тендера по ідентифікатору   ${username}   ${tender_uaid}
    ${number_of_items}=  Get Matching Xpath Count  //div[@class="item"]
    [return]  ${number_of_items}

Отримати інформацію із тендера
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[1]} == tender_uaid
    ...    ${ARGUMENTS[2]} == fieldname
    ${return_value}=    Run Keyword    Отримати інформацію про ${ARGUMENTS[2]}
    [Return]    ${return_value}

Отримати текст із поля і показати на сторінці
    [Arguments]    ${fieldname}
    Sleep    1
    ${return_value}=    Get Text    ${locator.${fieldname}}
    [Return]    ${return_value}

Отримати інформацію про title
    ${return_value}=    Отримати текст із поля і показати на сторінці    title
    [Return]    ${return_value}

Отримати інформацію про procurementMethodType
    ${return_value}=    Отримати текст із поля і показати на сторінці    procurementMethodType
    [Return]    ${return_value}

Отримати інформацію про dgfID
    ${return_value}=    Отримати текст із поля і показати на сторінці    dgfID
    [Return]    ${return_value}

Отримати інформацію про dgfDecisionID
    ${return_value}=    Отримати текст із поля і показати на сторінці    dgfDecisionID
    [Return]    ${return_value}

Отримати інформацію про dgfDecisionDate
    ${date_value}=    Отримати текст із поля і показати на сторінці    dgfDecisionDate
    ${return_value}=    biddingtime_service.convert_date    ${date_value}
    [Return]    ${return_value}

Отримати інформацію про tenderAttempts
    ${data}=    Отримати текст із поля і показати на сторінці    tenderAttempts
    ${return_value}=    Convert To Number    ${data}
    [Return]    ${return_value}

Отримати інформацію про tender.data.auctionUrl
    ${return_value}=    Отримати текст із поля і показати на сторінці    tender.data.auctionUrl
    [Return]    ${return_value}

Отримати інформацію про bid.data.participationUr
    ${return_value}=    Отримати текст із поля і показати на сторінці    bid.data.participationUr
    [Return]    ${return_value}

Отримати інформацію про eligibilityCriteria
    ${return_value}=    Отримати текст із поля і показати на сторінці    eligibilityCriteria

Отримати інформацію про status
    Reload Page
    Wait Until Page Contains Element    id = auction-status
    Sleep    1
    ${return_value}=    Get Text    id = auction-status
    [Return]    ${return_value}

Отримати інформацію про description
    ${return_value}=    Отримати текст із поля і показати на сторінці    description
    [Return]    ${return_value}

Отримати інформацію про value.amount
    ${return_value}=    Отримати текст із поля і показати на сторінці    value-amount
    ${return_value}=    Convert To Number    ${return_value.replace(' ', '').replace(',', '.')}
    [Return]    ${return_value}

Отримати інформацію про minimalStep.amount
    ${return_value}=    Отримати текст із поля і показати на сторінці    minimalStep.amount
    ${return_value}=    Convert To Number    ${return_value.replace(' ', '').replace(',', '.')}
    [Return]    ${return_value}

Внести зміни в тендер
    [Arguments]  ${username}  ${tender_uaid}  ${field_name}  ${field_value}
    ${testFilePath}=    get_upload_file_path
    biddingtime.Пошук тендера по ідентифікатору    ${username}  ${tender_uaid}
    Click Element    id = lot-edit-btn
    Input Text    ${locator.edit.${field_name}}    ${field_value}
    Choose File    id = file-type-input    ${testFilePath}
    Click Element    id=submit-auction-btn
    Sleep    10
    Wait Until Page Contains Element    id = lots-name    15

Отримати інформацію про items[${index}].quantity
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[${index}].quantity
    ${return_value}=    Convert To Number    ${return_value.replace(' ', '').replace(',', '.')}
    [Return]    ${return_value}

Отримати інформацію про items[${index}].unit.code
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[${index}].unit.code
    [Return]    ${return_value}

Отримати інформацію про items[${index}].unit.name
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[${index}].unit.name
    [Return]    ${return_value}

Отримати інформацію про items[${index}].description
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[${index}].description
    [Return]    ${return_value}

Отримати інформацію про items[${index}].classification.id
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[${index}].classification.id
    [Return]    ${return_value}

Отримати інформацію про items[${index}].classification.scheme
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[${index}].classification.scheme
    [Return]    ${return_value}

Отримати інформацію про items[${index}].classification.description
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[${index}].classification.description
    [Return]    ${return_value}

Отримати інформацію про value.currency
    ${return_value}=    Get Text    id = auction-value_currency
    [Return]    ${return_value}

Отримати інформацію про value.valueAddedTaxIncluded
    ${return_value}=    is_checked    auction-valueAddedTaxIncluded
    [Return]    ${return_value}

Отримати інформацію про auctionID
    ${return_value}=    Отримати текст із поля і показати на сторінці    tenderId
    [Return]    ${return_value}

Отримати інформацію про procuringEntity.name
    ${return_value}=    Отримати текст із поля і показати на сторінці    procuringEntity.name
    [Return]    ${return_value}

Отримати інформацію про items[0].deliveryLocation.latitude
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].deliveryLocation.latitude
    ${return_value}=    Convert To Number    ${return_value}
    [Return]    ${return_value}

Отримати інформацію про items[0].deliveryLocation.longitude
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].deliveryLocation.longitude
    ${return_value}=    Convert To Number    ${return_value}
    [Return]    ${return_value}

Отримати інформацію про auctionPeriod.startDate
    ${date_value}=    Get Text    id = auction-auctionPeriod_startDate
    ${return_value}=    convert_date_to_iso    ${date_value}
    [Return]    ${return_value}

Отримати інформацію про auctionPeriod.endDate
    ${date_value}=    Get Text    id = auction-auctionPeriod_endDate
    ${return_value}=    convert_date_to_iso    ${date_value}
    [Return]    ${return_value}

Отримати інформацію про tenderPeriod.startDate
    ${date_value}=    Get Text    id = auction-tenderPeriod_startDate
    ${return_value}=    convert_date_to_iso    ${date_value}
    [Return]    ${return_value}

Отримати інформацію про tenderPeriod.endDate
    ${date_value}=    Get Text    id = auction-tenderPeriod_endDate
    ${return_value}=    convert_date_to_iso    ${date_value}
    [Return]    ${return_value}

Отримати інформацію про enquiryPeriod.startDate
    ${date_value}=    Get Text    id = auction-enquiryPeriod_startDate
    ${return_value}=    convert_date_to_iso    ${date_value}
    [Return]    ${return_value}

Отримати інформацію про enquiryPeriod.endDate
    ${date_value}=    Get Text    id = auction-enquiryPeriod_endDate
    ${return_value}=    convert_date_to_iso    ${date_value}
    [Return]    ${return_value}

Отримати інформацію про items[0].deliveryAddress.countryName
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].deliveryAddress.countryName
    [Return]    ${return_value.split(', ')[0]}

Отримати інформацію про items[0].deliveryAddress.postalCode
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].postalCode
    [Return]    ${return_value.split(', ')[1]}

Отримати інформацію про items[0].deliveryAddress.region
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].region
    [Return]    ${return_value.split(', ')[2]}

Отримати інформацію про items[0].deliveryAddress.locality
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].locality
    [Return]    ${return_value.split(', ')[3]}

Отримати інформацію про items[0].deliveryAddress.streetAddress
    ${return_value}=    Отримати текст із поля і показати на сторінці    items[0].streetAddress
    [Return]    ${return_value.split(', ')[4]}

Отримати інформацію про items[0].deliveryDate.endDate
    ${date_value}=    Отримати текст із поля і показати на сторінці    items[0].deliveryDate.endDate
    ${return_value}=    biddingtime_service.convert_date    ${date_value}
    [Return]    ${return_value}

Отримати інформацію про auction[0].status
    ${return_value}=     Отримати текст із поля і показати на сторінці    auction[0].status
    [Return]    ${return_value}

Отримати інформацію про auction[1].status
    ${return_value}=     Отримати текст із поля і показати на сторінці    auction[1].status
    [Return]    ${return_value}

Задати запитання на тендер
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[1]} == tenderUaId
    ...    ${ARGUMENTS[2]} == questionId
    ${title}=    Get From Dictionary    ${ARGUMENTS[2].data}    title
    ${description}=    Get From Dictionary    ${ARGUMENTS[2].data}    description
    biddingtime.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[1]}
    Click Element    id = tab-selector-2
    Wait Until Page Contains Element    id= create-question-btn
    Click Element    id=create-question-btn
    Sleep    1
    Input text    id=question-title    ${title}
    Input text    id=question-description    ${description}
    Click Element    id= submit-question-btn
    ${description}=    Get From Dictionary    ${ARGUMENTS[2].data}    description

Задати запитання на предмет
  [Arguments]  ${username}  ${tender_uaid}  ${item_id}  ${question}
  biddingtime.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  Sleep    2
  Click Element     id = ${item_id}item
  Sleep  3
  Input text          id=question-title                 ${question.data.title}
  Input text          id=question-description          ${question.data.description}
  Click Element     id=submit-question-btn
  Sleep  3

Отримати інформацію про questions[${index}].title
    ${index}=    inc    ${index}
    Wait Until Page Contains Element    id = questions[${index}].title
    ${return_value}=    Get text    id = questions[${index}].title
    [Return]    ${return_value}

Отримати інформацію про questions[${index}].description
    ${index}=    inc    ${index}
    Wait Until Page Contains Element    id = questions[${index}].description
    ${return_value}=    Get text    id = questions[${index}].description
    [Return]    ${return_value}

Отримати інформацію про questions[${index}].answer
    ${index}=    inc    ${index}
    Wait Until Page Contains Element    id = questions[${index}].answer
    ${return_value}=    Get text    id = questions[${index}].answer
    [Return]    ${return_value}

Отримати інформацію про questions[${index}].date
    ${index}=    inc    ${index}
    Wait Until Page Contains Element    id = questions[${index}].date
    ${return_value}=    Get text    id = questions[${index}].date
    ${return_value}=    convert_date_time_to_iso    ${return_value}
    [Return]    ${return_value}

Отримати інформацію про awards[${index}].status
    ${return_value}=     Отримати текст із поля і показати на сторінці    awards[${index}].status
    [Return]    ${return_value}

Відповісти на запитання
    [Arguments]  ${username}  ${tender_uaid}  ${answer_data}  ${question_id}
    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Click Element    id = tab-selector-2
    Sleep    2
    Click Element    id = question[${question_id}].answer
    Sleep    3
    Input Text    id=questions-answer    ${answer_data.data.answer}
    Click Element    id=create-question-btn
    Click Element    id = tab-selector-2

Перейти до сторінки запитань
    [Arguments]    ${username}    ${tender_uaid}
    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Click Element    id = tab-selector-2

Отримати інформацію із запитання
    [Arguments]    ${username}    ${tender_uaid}    ${question_id}    ${field_name}
    biddingtime.Перейти до сторінки запитань    ${username}    ${tender_uaid}
    Sleep    1
    ${return_value}=    Run Keyword If    '${field_name}' == 'title'    Отримати інформацію про questions[${index}].title
    ...    ELSE IF    '${field_name}' == 'answer'    Отримати інформацію про questions[${index}].answer
    ...    ELSE    Отримати інформацію про questions[${index}].description
    [Return]    ${return_value}

Подати цінову пропозицію
    [Arguments]  ${username}  ${tender_uaid}  ${bid}
    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    ${amount}=    bid_value    ${bid}    
    sleep    2
    Click Element    id = bid-create-btn
    Sleep    2s
    Run Keyword If    ${bid['data'].qualified} != ${False}    Click Element    id=bids-oferta
    Run Keyword If    '${amount}' != ''   Input Text    id=bids-value_amount    ${amount}
    Sleep    2
    Click Element    id = bid-save-btn
    Click Element    id = bid-activate-btn
    sleep    10
    Reload Page

Скасувати цінову пропозицію
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} == username
    ...    ${ARGUMENTS[1]} == tenderId
    Sleep    3
    Click Element    id=bid-delete-btn

Отримати інформацію із пропозиції
    [Arguments]    ${username}    ${tender_uaid}    ${field}
    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Click Element    id =bid-create-btn
    Wait Until Page Contains Element    id=bids-value_amount
    ${value}=    Get Text    id=bids-value_amount
    ${value}=    Convert To Number    ${value}
    [Return]    ${value}

Змінити цінову пропозицію
    [Arguments]  ${username}  ${tender_uaid}  ${amount}  ${amount_value}
    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    sleep    2
    Click Element    id = bid-create-btn
    Sleep    2s
    Click Element    id = bid-update-btn
    Sleep    2
    Click Element    id = bids-oferta
    ${value}=    Convert To String    ${amount_value}
    Input Text    id=bids-value_amount    ${value}
    Sleep    2
    Click Element    id = bid-save-btn
    sleep    10
    Reload Page

Завантажити фінансову ліцензію
    [Arguments]  ${username}    ${tender_uaid}    ${path}
    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Sleep    1s
    Click Element    id = bid-create-btn
    Sleep    2s
    Select From List By Value    id = files-type    financialLicense
    Choose File    id = files-file    ${path}
    Click Element    id = document-upload-btn
    Sleep    5
    Reload Page

Змінити документ в ставці
    [Arguments]    @{ARGUMENTS}
    [Documentation]
    ...    ${ARGUMENTS[0]} ==  username
    ...    ${ARGUMENTS[1]} ==  file
    ...    ${ARGUMENTS[2]} ==  award_index
    Reload Page
    biddingtime.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[1]}
    Click Element    id = bids[${ARGUMENTS[2]}].link
    Select From List By Value    id = files-type    commercialProposal
    Choose File       id = files-file    ${ARGUMENTS[1]}
    Sleep   2
    Click Element     id=document-upload-btn
    Reload Page

Завантажити документ в ставку
    [Arguments]    @{ARGUMENTS}
    [Documentation]
    ...    ${ARGUMENTS[1]} ==  file
    ...    ${ARGUMENTS[2]} ==  award_index
    Reload Page
    Click Element    id = bids[${ARGUMENTS[2]}].link
    Select From List By Value    id = files-type    commercialProposal
    Choose File       id = files-file    ${ARGUMENTS[1]}
    Sleep   2
    Click Element     id=document-upload-btn
    Reload Page

Отримати посилання на аукціон для глядача
    [Arguments]  ${username}  ${tender_uaid}  ${lot_id}=${Empty}
    Switch Browser  ${BROWSER_ALIAS}
    Wait Until Keyword Succeeds   10 x   15 s   Run Keywords
    ...   Reload Page
    ...   AND   Element Should Be Visible   id = auction-url
    ${tender.data.auctionUrl}=    Get Text    id = auction-url
    [Return]    ${tender.data.auctionUrl}

Отримати посилання на аукціон для учасника
    [Arguments]  ${username}  ${tender_uaid}  ${lot_id}=${Empty}
    Switch Browser  ${BROWSER_ALIAS}
    Wait Until Keyword Succeeds   10 x   15 s   Run Keywords
    ...   Reload Page
    ...   AND   Element Should Be Visible   id = auction-url
    ${tender.data.auctionUrl}=    Get Text    id = auction-url
    [Return]    ${tender.data.auctionUrl}

Отримати інформацію із документа по індексу
    [Arguments]    ${username}    ${tender_uaid}    ${document_index}    ${field}
    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Sleep    5
    ${doc_value}    Get Text    name = ${document_index}.${field}
    [Return]    ${doc_value}

Отримати інформацію із документа
    [Arguments]    ${username}    ${tender_uaid}    ${doc_id}    ${field}
    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Sleep    5
    ${doc_value}    Get Text    xpath=(//a[contains(@name,'${field}.${doc_id}')])
    [Return]    ${doc_value}

Отримати кількість документів в тендері
    [Arguments]    ${username}    ${tender_uaid}
    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    ${tender_doc_number}    Get Matching Xpath Count    (//*[@id='auction-documents']/table)
    [Return]    ${tender_doc_number}

Отримати кількість документів в ставці
  [Arguments]  ${username}  ${tender_uaid}  ${bid_index}
  biddingtime.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
  ${bid_doc_number}   Get Matching Xpath Count   xpath=(//*[@id='pnAwardList']/div[last()]/div/div[1]/div/div/div[2]/table)
  [Return]  ${bid_doc_number}

Отримати документ
    [Arguments]    ${username}    ${tender_uaid}    ${doc_id}
    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    sleep    1
    ${file_name}    Get Text    xpath=//*[contains(text(),'${doc_id}')]
    ${url}    Get Element Attribute    xpath=//*[contains(text(),'${doc_id}')]@href
    download_file    ${url}    ${file_name.split('/')[-1]}    ${OUTPUT_DIR}
    [Return]    ${file_name.split('/')[-1]}

Отримати дані із документу пропозиції
    [Arguments]    ${username}    ${tender_uaid}    ${bid_index}    ${document_index}    ${field}
    ${document_index}=    inc    ${document_index}
    ${result}    Get Text    id = document-id
    [Return]    ${result}

Скасування рішення кваліфікаційної комісії
    [Arguments]    ${username}    ${tender_uaid}    ${award_num}
    Sleep    20
    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Wait Until Page Contains Element    id = bids[${award_num}].link
    Click Element    id = bids[${award_num}].link
    Sleep    2
    Click Element    id = cancel-bid-btn

Скасувати закупівлю
    [Arguments]  @{ARGUMENTS}
    [Documentation]
    ...      ${ARGUMENTS[0]} = username
    ...      ${ARGUMENTS[1]} = tenderUaId
    ...      ${ARGUMENTS[2]} = cancellation_reason
    ...      ${ARGUMENTS[3]} = doc_path
    ...      ${ARGUMENTS[4]} = description
    Click element    id = cabinet
    Sleep   2
    Input Text    name = LotSearch[auctionID]    ${ARGUMENTS[1]}
    Click Element    name = LotSearch[name]
    Click Element    id = view-btn
    Sleep    1
    Click Element    id = cancel-auction-btn
    Sleep    1
    Select From List By Value    id = cancellations-reason    ${ARGUMENTS[2]}
    Click Element    id = create-cancellation-btn
    Sleep    1
    Click Element    id = add-cancellation-document
    Sleep    1
    Choose File    id = files-file    ${ARGUMENTS[3]}
    Sleep    1
    Input Text    id = cancellations-description    ${ARGUMENTS[4]}
    Click Element    id = upload-document
    Sleep    1
    Click Element    id = confirm-cancellation-btn

Завантажити документ рішення кваліфікаційної комісії
    [Arguments]    ${username}    ${filepath}    ${tender_uaid}    ${award_num}
    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Wait Until Page Contains Element    id = bids[${award_num}].link
    Click Element    id = bids[${award_num}].link
    Click Element    id = disqualify-link
    Choose File    id = files-file    ${filepath}
    Sleep    1
    Click Element    id=upload-disqualification-btn
    Sleep 2

Завантажити протокол аукціону в авард
    [Arguments]    ${username}    ${tender_uaid}    ${filepath}    ${award_index}
    ${testFilePath}=    get_upload_file_path
    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Wait Until Page Contains Element    id = bids[${award_index}].link
    Click Element    id = bids[${award_index}].link
    Sleep    1
    Wait Until Page Contains Element    id = upload-protocol-btn
    Click Element    id = upload-protocol-btn
    Choose File    id = files-file    ${testFilePath}
    Sleep    1
    Click Element    id=bid-upload-protocol

Підтвердити постачальника
    [Arguments]  ${username}  ${tender_uaid}  ${award_num}
    biddingtime.Пошук тендера по ідентифікатору  ${username}  ${tender_uaid}
    Wait Until Page Contains Element      id = bids[${award_num}].link
    Click Element    id = bids[${award_num}].link
    Wait Until Page Contains Element      id = confirm-payment-btn
    Click Element    id = confirm-payment-btn
    Sleep    1

Завантажити угоду до тендера
    [Arguments]    ${username}    ${tender_uaid}    ${contract_num}    ${filepath}
    biddingtime.Пошук тендера по ідентифікатору    ${username}    ${tender_uaid}
    Wait Until Page Contains Element    id = bids[0].link
    Click Element    id = bids[0].link
    Wait Until Page Contains Element    id = upload-contract-link
    Click Element    id = upload-contract-link
    Choose File    id = files-file    ${filepath}
    Sleep    1
    Click Element    id = upload-contract-btn
    Sleep    10

Підтвердити наявність протоколу аукціону
    [Arguments]  ${username}  ${tender_uaid}  ${award_index}
    biddingtime.Пошук тендера по ідентифікатору    ${username}  ${tender_uaid}
    Wait Until Page Contains Element    id=bids[0].link
    Click Element    id=bids[0].link
    Wait Until Page Contains Element    id = confirm-payment-btn

Підтвердити підписання контракту
    [Arguments]    ${username}    ${tender_uaid}    ${contract_num}
    ${file_path}    ${file_title}    ${file_content}=    create_fake_doc
    biddingtime.Пошук тендера по ідентифікатору    ${username}  ${tender_uaid}
    Sleep    1
    Wait Until Page Contains Element    id = bids[0].link
    Click Element    id = bids[0].link
    Wait Until Page Contains Element    id = contract-signed-btn
    Click Element    id = contract-signed-btn
    Click Element    id = contract-signed-submit

Дискваліфікувати постачальника
    [Arguments]  ${username}  ${tender_uaid}  ${award_num}  ${description}
    ${testFilePath}=    get_upload_file_path
    biddingtime.Пошук тендера по ідентифікатору    ${username}  ${tender_uaid}
    Wait Until Page Contains Element    id = bids[${award_num}].link
    Click Element    id = bids[${award_num}].link
    Click Element    id = disqualify-link
    Input text          id = awards-description    ${description}
    Choose File    id = files-file    ${testFilePath}
    Click Element       id = upload-disqualification-btn