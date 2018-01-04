# -*- coding: utf-8 -*-
import pytz
import dateutil.parser
import urllib
import os

from datetime import datetime
from robot.libraries.BuiltIn import BuiltIn

def get_webdriver():
   se2lib = BuiltIn().get_library_instance('Selenium2Library')
   return se2lib._current_browser()

def is_checked(locator):
   driver = get_webdriver()
   return driver.find_element_by_id(locator).is_selected()

def get_str(value):
   return str(value)

def get_budget(initial_tender_data):
   return str(initial_tender_data.data.value.amount)

def get_step_rate(initial_tender_data):
   return str(initial_tender_data.data.minimalStep.amount)

def get_quantity(item):
   return str(item.quantity)

def get_tenderAttempts(item):
   return str(item.tenderAttempts)

def get_tender_dates(initial_tender_data, key):
   data_period = initial_tender_data.data.auctionPeriod
   start_dt = dateutil.parser.parse(data_period['startDate'])
   data = {
       'StartDate': start_dt.strftime("%d.%m.%Y"),
       'StartTime': start_dt.strftime("%H:%M"),
   }
   return data.get(key, '')

def convert_ISO_DMY(isodate):
   return dateutil.parser.parse(isodate).strftime("%d.%m.%Y")

def convert_date(isodate):
   return datetime.strptime(isodate, '%d.%m.%Y').date().isoformat()

def convert_date_to_iso(v_date):
   full_value = v_date
   date_obj = datetime.strptime(full_value, "%d.%m.%Y %H:%M")
   time_zone = pytz.timezone('Europe/Kiev')
   localized_date = time_zone.localize(date_obj)
   return localized_date.strftime("%Y-%m-%dT%H:%M:%S.%f%z")

def convert_date_time_to_iso(v_date_time):
   date_obj = datetime.strptime(v_date_time, "%d.%m.%Y %H:%M")
   time_zone = pytz.timezone('Europe/Kiev')
   localized_date = time_zone.localize(date_obj)
   return localized_date.strftime("%Y-%m-%dT%H:%M:%S.%f%z")

def download_file(url, file_name, output_dir):
   urllib.urlretrieve(url, ('{}/{}'.format(output_dir, file_name)))

def inc(value):
   return int(value) + 1

def to_str(value):
   return str(value)

def to_int(value):
   return int(value)