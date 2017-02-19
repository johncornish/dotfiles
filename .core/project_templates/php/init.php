<?php
$src = glob('src/*.php');

foreach ($src as $s) {
	require_once $s;
}

//Connect to the Products database.
$host = 'localhost';
$user = 'test';
$pass = 'test';
$db = 'chegg';

$db = new Database($host, $user, $pass, $db);