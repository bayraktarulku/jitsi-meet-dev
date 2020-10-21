<?php
require_once 'vendor/autoload.php';
use \Firebase\JWT\JWT;

$LINK = "https://meet.mydomain.com";
$ROOM = "myroom";

$key = "mysecret";
$payload = array(
    "aud" => "myapp",
    "iss" => "myapp",
    "sub" => "meet.mydomain.com",
    "exp" => time() + (60*60),
    "room" => "$ROOM",
    "moderator" => true,
    "context" => array(
        "user" => array(
            "name" => "username",
            "email" => "username@mydomain.com",
            "avatar" => "https://avatar.com/avatar/xxx.png"
        ),
                ),
        "features" => array(
            "recording" => false,
            "livestreaming" => false,
            "screen-sharing" => true,
            "outbound-call" => false,
        )
    )
);
