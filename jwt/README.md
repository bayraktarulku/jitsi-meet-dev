## JWT

```
apt install jitsi-meet-tokens
```

#### Change settings in this file --> /etc/jitsi/meet/meet.mydomain.com-config.js
```
    // If true all users without a token will be considered guests and all users
    // with token will be considered non-guests. Only guests will be allowed to
    // edit their profile.
    enableUserRolesBasedOnToken: true,

    // Whether or not some features are checked based on token.
    enableFeaturesBasedOnToken: true,
```

#### Features we can change with JWT

* __"recording"__ : false -> Guests can't start recordings.
* __"livestreaming"__ : false -> Guests can't start live streaming.
* __"screen-sharing"__ : false  -> Guests can't screen share.
* __"outbound-call"__


#### Packages

```bash
apt install php-cli composer
composer require firebase/php-jwt
```


#### Generate jwt

```bash
php jwt.php
```
