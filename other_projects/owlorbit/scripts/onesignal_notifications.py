import traceback
from json import dumps
from requests import post, Timeout
from sherpaa import app

class PushNotificationError(Exception): pass

def push(client, alert="", **data):
    device_ids = client.device_ids
    url = app.config.get("ONESIGNAL_PUSH_URL")
    if device_ids:
        headers = app.config.get("ONESIGNAL_HEADERS")
        params = {"data": data,
                "app_id": app.config.get("ONESIGNAL_APP_KEY"),
                "ios_badgeType": "SetTo",
                "ios_badgeCount" : "1",
                "include_player_ids" : device_ids,
                "small_icon" : "parse_icon",
                "large_icon" : "sherpaa_icon",
                "contents": {"en": alert},
                "headings": {"en": "Sherpaa"},
                }
        try:
            res = post(url, dumps(params), headers=headers, timeout=10)
        except Timeout:
            print "Failed to push {} to {} via OneSignal".format(
                    data, client)
            traceback.print_exc()
            raise
        if not (200 <= res.status_code <= 299):
            raise PushNotificationError(res.text)

def send_ios_msg_notification(msg, issue, client):
    return push(client, alert="You have a new message.",
            issue_id=issue.idstr, message_id=msg.idstr)

def send_ios_review_notification(client, msg, issue):
    if msg.of.doctype == "specialist":
        text = "Please review your Sherpaa-trusted specialist"
    else:
        text = "Please review your Sherpaa experience."
    return push(client, alert=text, issue_id=issue.idstr, message_id=msg.idstr)
