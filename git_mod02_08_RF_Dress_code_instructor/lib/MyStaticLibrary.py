from resources.variables import *


from robot.api.deco import keyword
import datetime

# 9th of Jan 2016 JukkaHei:
# Below Sendkeys was needed to be downloaded from unofficial place:
# http://www.lfd.uci.edu/~gohlke/pythonlibs/#sendkeys and then .whl
# file was installed wiht "pip install SendKeys-0.3-cp27-none-win_amd64.whl" command
# Enter pressing was needed for starting to search weather location.
# Didn't fully work only with seach button.
#import SendKeys  into comments at Tieto ajukkhei

__all__ = ['convert_to_upper', 'convert_to_lower', 'print_some_text', 'is_valid_date', 'send_enter_key']


def convert_to_upper(string):
    return string.upper()


def convert_to_lower(string):
    return string.lower()


@keyword('Log Text')
def print_some_text(string):
    print (string)


def _not_a_keyword():
    print ("Not a keyword")


def still_not_a_keyword():
    print ("Not a keyword")


def is_valid_date(string):
    """Checks if provided string is a valid date
    Accepted format is: %Y-%m-%d
    """
    try:
        datetime.datetime.strptime(string, '%Y-%m-%d')
        return True
    except ValueError:
        return False


#def send_enter_key():  Into comemnts at Tieto, ajukkhei
#    """
#    Sends ENTER key to application
#    Works only in Windows
#    """
#    #import SendKeys
#    SendKeys.SendKeys("{ENTER}")


