-- Initialize the database for production
-- This script runs when the PostgreSQL container starts for the first time

-- The POSTGRES_DB, POSTGRES_USER and POSTGRES_PASSWORD environment variables
-- will automatically create the database and user, so this file is optional
-- but can be used for additional setup if needed

-- Example: Create additional extensions
-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
-- CREATE EXTENSION IF NOT EXISTS "hstore";

-- Grant all privileges to the user (already done by default setup)
-- GRANT ALL PRIVILEGES ON DATABASE budgetingkid_production TO budgetingkid;
