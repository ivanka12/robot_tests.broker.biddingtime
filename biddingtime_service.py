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

def download_file(url, file_name, output_dir):
   urllib.urlretrieve(url, ('{}/{}'.format(output_dir, file_name)))

def get_upload_file_path():
   return os.path.join(os.getcwd(), 'src', 'robot_tests.broker.biddingtime', 'LICENSE.txt')

def convert_date_to_iso(v_date):
   full_value = v_date
   date_obj = datetime.strptime(full_value, "%d.%m.%Y %H:%M")
   time_zone = pytz.timezone('Europe/Kiev')
   localized_date = time_zone.localize(date_obj)
   return localized_date.strftime("%Y-%m-%dT%H:%M:%S.%f%z")