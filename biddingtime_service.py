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