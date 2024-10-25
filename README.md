# migration

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
wget -O master.zip https://github.com/erfjab/migration/archive/refs/heads/master.zip
unzip -o master.zip
mkdir -p /root/export
cp -r migration-master/export/* /root/export/
rm -rf migration-master master.zip
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
wget -O master.zip https://github.com/erfjab/migration/archive/refs/heads/master.zip
unzip -o master.zip
mkdir -p /root/import
cp -r migration-master/import/* /root/import/
rm -rf migration-master master.zip
```

### Configure Marzneshin

Edit your Marzneshin Docker configuration (`nano /etc/opt/marzneshin/docker-compose.yml`) to add the following volumes:
```yaml
    volumes:
      - /var/lib/marzneshin:/var/lib/marzneshin
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
nano .env
```
```
MARZNESHIN_USERNAME = "sudo_user"
MARZNESHIN_PASSWORD = "sudo_pass"
MARZNESHIN_ADDRESS="https://sub.domain.com:port"
MARZBAN_USERS_DATA="marzban.json"
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


## 3. Handler Sub


### 1. Server Setup

#### 1.1: Update the Server

Ensure your server is up to date:

```bash
sudo apt update && sudo apt upgrade -y
```

#### 1.2: Install Docker

Install Docker using this command:

```bash
curl -fsSL https://get.docker.com | sh
```

---

### 2. Download and Configure

#### 2.1: Create Directory and Download `docker-compose.yml`

Create the necessary directory and download the `docker-compose.yml` file:

```bash
mkdir -p /opt/erfjab/migration/data
curl -o /opt/erfjab/migration/docker-compose.yml https://raw.githubusercontent.com/erfjab/migration/master/docker-compose.yml
cd /opt/erfjab/migration
```

#### 2.2: Download and Configure `.env`

Download the example environment file:

```bash
curl -o .env https://raw.githubusercontent.com/erfjab/holderbot/master/.env.example
```

Edit the `.env` file:

```bash
nano .env
```

---

### 3. Run the Handler

#### 3.1: Pull the Latest Docker Image

Pull the latest Docker image for the Handler:

```bash
docker compose pull
```

#### 3.2: Start the Handler

Start the Handler in detached mode:

```bash
docker compose up -d
```

#### 3.3: Verify the Handler is Running

Check the status of running containers:

```bash
docker compose ps
```

---

### Updating the Handler

To update the Handler to the latest version:

1. Pull the latest Docker image:

    ```bash
    docker compose pull
    ```

2. Restart the Handler:

    ```bash
    docker compose up -d
    ```

---

### Managing the Handler with Docker

#### Restart the Handler

```bash
docker compose restart
```

#### Stop the Handler

```bash
docker compose down
```

#### View Real-Time Logs

```bash
docker compose logs -f
```
