# MarzneshinMigration

A tool to migrate from Marzban to Marzneshin in three simple steps:
1. Data Export
2. Data Import
3. Subscription Handling

## Prerequisites (All Servers)

Ensure the following software is installed:

- Python 3.8+
- pip (Python package installer)
- venv (Python virtual environment)

### Install on Ubuntu/Debian:
```bash
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y python3 python3-pip python3-venv unzip wget
```

## 1. Export Data

Extracts Admins, Users, and JWT key from Marzban.

### Setup & Run

Download and set up the export tool:
```bash
cd /root
wget -O master.zip https://github.com/erfjab/MarzneshinMigration/archive/refs/heads/master.zip
unzip -o master.zip
mkdir -p /root/export
cp -r MarzneshinMigration-master/export/* /root/export/
rm -rf MarzneshinMigration-master master.zip
```

Set up Python environment:
```bash
cd /root/export
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

### Database Preparation

- **SQLite**: Ensure Marzban is stopped.
- **MySQL**: Have your database credentials ready.

### Export Process

Run the export script and follow the prompts:
```bash
cd /root/export
source venv/bin/activate
python3 export.py
```

The export script will generate a `marzban.json` file containing the exported data.

## 2. Import Data

### Setup & Run

Follow the same prerequisites installation as in step 1.

Download and set up the import tool:
```bash
cd /root
wget -O master.zip https://github.com/erfjab/MarzneshinMigration/archive/refs/heads/master.zip
unzip -o master.zip
mkdir -p /root/import
cp -r MarzneshinMigration-master/import/* /root/import/
rm -rf MarzneshinMigration-master master.zip
```

### Configure Marzneshin

Edit your Marzneshin Docker configuration (`/etc/opt/marzneshin/docker-compose.yml`) to add the following volumes:
```yaml
volumes:
  - /root/import/docker/models/user.py:/app/app/models/user.py
  - /root/import/docker/db/crud.py:/app/app/db/crud.py
```

Restart Marzneshin to apply the changes:
```bash
marzneshin restart
```

### Configure Import

Edit the environment file for import:
```bash
cd /root/import
nano .env
```

Set up the Python environment:
```bash
cd /root/import
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

### Run Import

Start the import process:
```bash
cd /root/import
source venv/bin/activate
python3 main.py
```

> **Important:** After completing the import, delete the Docker map files to avoid conflicts.