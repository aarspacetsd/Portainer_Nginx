<?php
// Test file for Laravel setup
echo "<h1>Laravel Docker Stack Test</h1>";
echo "<h2>PHP Information</h2>";
phpinfo();

echo "<hr>";
echo "<h2>Database Connection Test</h2>";

try {
    $host = $_ENV['DB_HOST'] ?? 'db';
    $dbname = $_ENV['DB_DATABASE'] ?? 'laravel';
    $username = $_ENV['DB_USERNAME'] ?? 'appuser';
    $password = $_ENV['DB_PASSWORD'] ?? 'apppass';
    
    $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    echo "<p style='color: green;'>✓ Database connection successful!</p>";
    echo "<p>Connected to: $dbname on $host</p>";
    
} catch(PDOException $e) {
    echo "<p style='color: red;'>✗ Database connection failed: " . $e->getMessage() . "</p>";
}
?>