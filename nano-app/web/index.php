<?php

require_once __DIR__ . '/../vendor/autoload.php';

$db = new PDO(getenv('DSN') ?: 'sqlite:/tmp/test.db', getenv('DB_PASSWD') ?: null);
$counter = new Counter($db);

header('Content-Type:text/plain');
header('Access-Control-Allow-Origin: *');
header("Access-Control-Allow-Methods: GET, PUT, DELETE, OPTIONS");

switch ($_SERVER['REQUEST_METHOD']) {
    case 'GET': echo $counter->getCurrentCounter(); break;
    case 'PUT': $counter->increaseCounter(); echo $counter->getCurrentCounter(); break;
    case 'DELETE': $counter->reset(); echo "OK"; break;
}