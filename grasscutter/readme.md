# Grasscutter

- Game Version: latest Grasscutter support version
- GrassCutter Version: latest

- **PLEASE MODIFY YOUR config.json**

## Usage

```yml
version: "3.9"

services:
  grasscutter-db:
    image: mongo
    container_name: grasscutter-db
    restart: always
    deploy:
      resources:
        limits:
          memory: 1G
    # ports:
    #   - "27017:27017"
    networks:
      grasscutter_network:
    volumes:
      - ${DATA_PATH}/genshin_db:/data/db
    # environment:
    #   MONGO_INITDB_ROOT_USERNAME: YOURUSERNAME # edit config.json also!
    #   MONGO_INITDB_ROOT_PASSWORD: YOURPASSWORD # edit config.json also!

  grasscutter:
    image: purposely/grasscutter
    container_name: grasscutter
    restart: always
    deploy:
      resources:
        limits:
          memory: 5G
    networks:
      grasscutter_network:
    volumes:
      - ${DATA_PATH}/genshin/logs:/app/logs # Optional
      - ${DATA_PATH}/genshin/data:/app/data # Optional
      - ${DATA_PATH}/genshin/cache:/app/cache # Optional
      - ${DATA_PATH}/genshin/plugins:/app/plugins # Optional
      - ${DATA_PATH}/genshin/GM Handbook:/app/GM Handbook # Optional
      - ${DATA_PATH}/genshin/config.json:/app/config.json:ro
    ports:
      - "443:443"
      - "22102:22102/udp"
    stdin_open: true
    tty: true
  
networks:
  grasscutter_network:
```
