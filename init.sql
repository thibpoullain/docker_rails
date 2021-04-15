CREATE USER unac WITH PASSWORD 'unac' CREATEDB;
CREATE DATABASE unac_backend_development;
CREATE DATABASE unac_backend_test;
GRANT ALL PRIVILEGES ON DATABASE unac_backend_development TO unac;
GRANT ALL PRIVILEGES ON DATABASE unac_backend_test TO unac;