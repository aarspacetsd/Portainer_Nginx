-- Grant additional permissions to application user
GRANT ALL PRIVILEGES ON *.* TO 'appuser'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

-- Create additional databases if needed
-- CREATE DATABASE IF NOT EXISTS laravel_test;