# installing the project

0. Install the required packages:
```bash
apt update && apt upgrade
apt install curl git
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

1. Generate a new ssh key pair for the server:
```bash
ssh-keygen -t ed25519
```

2. Get the public key:
```bash
cat ~/.ssh/id_ed25519.pub
```

3. Navigate to [Deploy keys](https://github.com/szabot1/ikt/settings/keys) and add the public key to the repository.

4. Clone the repository:
```bash
git clone git@github.com:szabot1/ikt.git /home/ikt -b master --depth 1
```

5. Start watchtower:
```bash
chmod +x /home/ikt/server/watchtower.sh
/home/ikt/server/watchtower.sh
```

6. Start postgres and redis:
```bash
docker compose -f /home/ikt/db/docker-compose.yaml up -d
```

7. Run migrations:
```bash
cd /home/ikt/db
chmod +x migrate.sh
./migrate.sh
```