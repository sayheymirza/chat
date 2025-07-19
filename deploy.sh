ssh mirza@45.159.113.112 -p 3031 'cd workspace/chat ; git pull -f ; docker compose up -d --build'
ssh mahasal@91.121.44.153 'cd app ; git pull -f ; docker compose up -d --build'