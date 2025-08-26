#!/bin/bash
set -e

# Variables
POSTGRES_VERSION=15
POSTGRES_PASSWORD="${DB_PASSWORD:-postgres}" # injected via Terraform user_data
PGDATA="/var/lib/pgsql/${POSTGRES_VERSION}/data"
PG_CONF="${PGDATA}/postgresql.conf"
PG_HBA="${PGDATA}/pg_hba.conf"

echo ">>> Updating system (skip if no NAT)..."
sudo dnf -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-9-x86_64/pgdg-redhat-repo-latest.noarch.rpm
sudo dnf -y install postgresql${POSTGRES_VERSION} postgresql${POSTGRES_VERSION}-server

echo ">>> Initializing database..."
sudo /usr/pgsql-${POSTGRES_VERSION}/bin/postgresql-${POSTGRES_VERSION}-setup initdb

echo ">>> Starting PostgreSQL..."
sudo systemctl enable postgresql-${POSTGRES_VERSION}
sudo systemctl start postgresql-${POSTGRES_VERSION}

echo ">>> Configuring PostgreSQL to listen on all addresses..."
sudo sed -i "s/^#listen_addresses =.*/listen_addresses = '*'/" ${PG_CONF}

echo ">>> Changing postgres database user password..."
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '${POSTGRES_PASSWORD}';"

echo ">>> Configuring pg_hba.conf for remote connections (VPC only)..."
sudo cp ${PG_HBA} ${PG_HBA}.bak
echo "host    all    all    10.0.0.0/16    md5" | sudo tee -a ${PG_HBA}

echo ">>> Restarting PostgreSQL..."
sudo systemctl restart postgresql-${POSTGRES_VERSION}

echo ">>> PostgreSQL ${POSTGRES_VERSION} setup complete."
