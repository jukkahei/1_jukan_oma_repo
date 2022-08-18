#Uses gmail to send an email to someone

import smtplib
import sys

#Below "setdefaultencoding" is one special case which was needed for location Winnipeg.
# Execution of macro failed without this when given location was Winnipeg.
#reload(sys)  Into comments at Tieto ajukkhei
#sys.setdefaultencoding('utf-8')   Into comments at Tieto ajukkhei

def send_weather_mail(location, temperature, wind, rain, clothing, username, password, target_email_address):

    print ("python got this location %s." % location)
    # Below is for removing special characters like degree from the temperature". Complainend about it when printing ..
    plain_temp = temperature.encode('ascii', 'ignore').decode('ascii')
    print ("python got this temperature %s." % plain_temp)
    print ("python got this rain 1 %s." % rain)

    sender = "Robot framework test macro"
    to = target_email_address
    subject = "Here is the current weather data at %s and clothing suggestion" % location

    headers = "From: %s\r\nTo: %s\r\nSubject: %s\r\n\r\n" % (sender, to, subject)
    msg = headers + "Hello!\nHere is the curent weather data at %s: temperature %s C , wind %s m/s , rain %s\n\nSuggested clothing:\n%s\n\n\n BR. Ronald Robot" % (location, plain_temp, wind, rain, clothing)


    mailserver = smtplib.SMTP("smtp.gmail.com", 587)
    mailserver.ehlo()
    mailserver.starttls()
    mailserver.ehlo()
    mailserver.login(username, password)
    mailserver.sendmail(username,target_email_address, msg)
    mailserver.close()