from datetime import timedelta

PRODUCTION = False
_SERVER_NAME = "staging.sherpaa.com"
MAX_CONTENT_LENGTH = 50 * 1024 * 1024
PERMANENT_SESSION_LIFETIME = timedelta(hours=24)
UPLOADS_DIR = "/srv/uploads/local"

# this is used by Flask to sign cookies and other
# cryptographic actions
# http://flask.pocoo.org/docs/0.10/api/#flask.Flask.secret_key
SECRET_KEY = "LaDyLgw14mEgpiIJUU"

# ---------- Email

SUPPRESS_EMAILS = True
MANDRILL_APIKEY = "Ju-t-oLGVJrJwZTFQOoqmw"
MANDRILL_SENDURL = "https://mandrillapp.com/api/1.0/messages/send-template.json"
MANDRILL_SENDPARAMS = {
        "key": MANDRILL_APIKEY,
        "async": False,
        "message": {
            "merge": True,
            },
        "template_content": [],
        }

# ---------- Alert recipients

EMAIL_ADDRESS_EPRESCRIBE_FAILURE_UNMATCHED_REFREQ =\
    ("technology@sherpaa.com", "Sherpaa Technology")

# ---------- Parse

PARSE_APP_KEY = "19rqkZe2DHeNqjlywouKMhkDhaujNDx6vH9V9yd8"
PARSE_REST_KEY = "2kkQQBHi5BAxel5NYhMKUt3a28Qalt7m1pWKP9no"
PARSE_PUSHURL = "https://api.parse.com/1/push"
PARSE_HEADERS = {
        "X-Parse-Application-Id": PARSE_APP_KEY,
        "X-Parse-REST-API-Key": PARSE_REST_KEY,
        "Content-Type": "application/json"
        }

# ---------- OneSignal

ONESIGNAL_APP_KEY = "7b265d4e-5e9a-4a55-ac07-e513da4e45fd"
ONESIGNAL_REST_KEY = "OTFhYmRmODMtN2I4Zi00NTJmLWJjODQtNWI1ODk5NTgwYTE1"
ONESIGNAL_URL = "https://onesignal.com/api/v1"
ONESIGNAL_PUSH_URL = ONESIGNAL_URL + "/notifications"
ONESIGNAL_EXPORT_URL = ONESIGNAL_URL + "/players/csv_export?app_id=" +\
                       ONESIGNAL_APP_KEY
ONESIGNAL_HEADERS = {
        "Authorization": "Basic " + ONESIGNAL_REST_KEY,
        "Content-Type": "application/json"
	}

# ---------- Phaxio

PHAXIO_SENDURL = "https://api.phaxio.com/v1/send"
PHAXIO_APIKEY = "e5f6fcb8b690731697a1cbce32e955d3e3a7f782"
PHAXIO_SECRET = "b5ec14abeed8be6f2b4dfa3891d5bf279893616c"
SHERPAAS_PHAX = "9179796515"

# ----------

PASSWORD_RESET_HOURS_VALID = 3
MONGODB_DB = "test"
MONGODB_USERNAME = "sherpaa"
MONGODB_PASSWORD = "ohmanisbuddyeverlazy"
MONGODB_AUTORUN_MIGRATIONS = True
ACCOUNT_MANAGERS = (
    ("cheryl@sherpaa.com", "Cheryl Swirnow"),
    ("sean@sherpaa.com", "Sean Mihlo"),
)
DEPENDENTS_MANAGERS = (
    ("sean@sherpaa.com", "Sean Mihlo"),
)
ARCHIVED_ISSUE_REVIEW_DELAY = timedelta(days=3)
REFERRAL_REVIEW_DELAY = timedelta(days=14)
SLOW_REQUEST_CUTOFF = timedelta(milliseconds=500)
INVITE_REMINDER_LEVELS = [(1, timedelta(days=10)), (2, timedelta(days=30))]
FREELANCERS_LIMIT = 4000
IOS_VERSION = "2.5.0"
IOS_MIN_VERSION = "2.5.0"
BUILD_NO = "07182016a"
DUCKSBOARD_APIKEY = "35OeGEpRq69s9NlWxps4cdoCi3ZmUs1H3izomHtGEcFW2ZglZd"
ENABLE_ROLLBACK_OF_TESTING_DATA = False

# ---------- Surescripts

# Used to transmit XML message to surescripts.  Note that the following data
# correspond to the staging environment.
SURESCRIPT_CONFIGURATION = {
    'user':  'surescripts',
    'password': 'mKXSVmVDESUhiSur',
    'url': "https://staging.surescripts.net/SherpaaTest10.6MU2/"
           "AuthenticatingXmlServer.aspx",
    'directory_url': "https://staging.surescripts.net/Directory4dot6/"
                     "directoryxmlserver.aspx",
    'directory_account_id': 2575,
    'directory_user_name': "SherpaaDir",
    # Password needs to be hashed and encoded as such:
    # base64.b64encode(hashlib.sha1(bytearray(
    # str.upper('<password>'), 'utf-16-le')).digest())
    'directory_password': b'''jfJs2RGp56TKC7FWTwhsCqurAFE=''',
    'pharmacy_download_loc': "https://staging.surescripts.net/Downloads/",
    'sender': 'SHPD46.dp@surescripts.com',
    'version_id': '4.6',
    'taxonomy_code': '183500000X'
}
SURESCRIPTS_REQUEST_TIMEOUT_IN_SECONDS = 10

# ---------- Sherpaa's address

# Sherpaa's address is used in the creation of a prescription that will be
# send to surescripts. More precisely, this address will be send as the address
# of all of the guides..
SHERPAAS_ADDRESS = {
    'street': '584 Broadway, Suite 510',
    'city': 'New York',
    'state': 'NY',
    'zip_code': '10012'
}

# ---------- First Databank

# The drugs database settings to contain the data from FDB
DRUGS_DATABASE = {
    'hostname': 'localhost',
    'user': 'root',
    'password': '1111',
    'database': 'drugs'
}

# First Databank FTP site credentials
FTP_FDBHEALTH_COM_USER = "SherpaaFTP"
FTP_FDBHEALTH_COM_PASSWORD = "28xB*5gz7P"

# ----------

CACHE_EXPIRATION_TIME = timedelta(minutes=10)
SUPERVISION_GRACEPERIOD = timedelta(days=3)
SHERPAA_HOURS = (8, 20)
