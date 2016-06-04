<?php

require_once __DIR__ . '/../vendor/autoload.php';

$dsn = getenv('DSN') ? getenv('DSN') : 'sqlite::memory:';

$counter = new Counter(new PDO($dsn));

if (isset($_GET['c']) && $_GET['c'] == 'reset') {
    $counter->reset();
} else {
    $counter->increaseCounter();
}

$currentCount = $counter->getCurrentCounter();

echo "<h1>You're # <span>".$currentCount."</span>";

