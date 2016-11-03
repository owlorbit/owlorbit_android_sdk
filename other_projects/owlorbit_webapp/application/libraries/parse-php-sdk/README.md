Parse PHP SDK for Codeigniter Framework
-------------

The Parse PHP SDK gives you access to the powerful Parse cloud platform
from your PHP app or script.
This fork is modified code for Codeigniter framework.

Installation
------------

Download this repo.
Unzip files.
Copy parse-php-sdk folder to your application/libraries folder.


Initialization
---------------

Load library in your controller or model file where you want to use Parse.

```php
$this->load->library('parse-php-sdk/src/Parse/ParseClient');
$this->parseclient->initialize( PARSE_APP_ID, PARSE_REST_KEY, PARSE_MASTER_KEY );
```

Usage
-----

Import corresponding file where you'll be using the classes.

```php
$this->load->library('parse-php-sdk/src/Parse/ParseObject');
```

Objects:

```php
$object = $this->parseobject->create("TestObject");
$objectId = $object->getObjectId();
$php = $object->get("elephant");

// Set values:
$object->set("elephant", "php");
$object->set("today", new DateTime());
$object->setArray("mylist", [1, 2, 3]);
$object->setAssociativeArray(
  "languageTypes", array("php" => "awesome", "ruby" => "wtf")
);

// Save:
$object->save();
```

Users: (Not available for now)


Security: (Not available for now)


Queries: (Not available for now)


Cloud Functions:

```php
$this->load->library('parse-php-sdk/src/Parse/ParseCloud');
```

```php
$results = $this->parsecloud->run("aCloudFunction", array("from" => "php"));
```

Analytics:

```php
$this->load->library('parse-php-sdk/src/Parse/ParseAnalytics');
```

```php
$this->parseanalytics->track("logoReaction", array(
  "saw" => "elephant",
  "said" => "cute"
));
```

Files:

```php
$this->load->library('parse-php-sdk/src/Parse/ParseFile');
```

```php
// Get from a Parse Object:
$file = $aParseObject->get("aFileColumn");
$name = $file->getName();
$url = $file->getURL();
// Download the contents:
$contents = $file->getData();

// Upload from a local file:
$file = $this->parsefile->createFromFile(
  "/tmp/foo.bar", "Parse.txt", "text/plain"
);

// Upload from variable contents (string, binary)
$file = $this->parsefile->createFromData($contents, "Parse.txt", "text/plain");
```

Push:

```php
$this->load->library('parse-php-sdk/src/Parse/ParseFile');
```

```php
$data = array("alert" => "Hi!");

// Push to Channels
$this->parsepush->send(array(
  "channels" => ["PHPFans"],
  "data" => $data
));