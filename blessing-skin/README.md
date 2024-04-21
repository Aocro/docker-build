# blessing-skin-docker

> Github: [Aocro/docker-build/blessing-skin](https://github.com/Aocro/docker-build/tree/main/blessing-skin)

- Platforms: arm64, amd64

> Source: <https://github.com/bs-community/blessing-skin-server>

## Details

- Build the image using the [official Dockerfile](https://github.com/bs-community/blessing-skin-server/blob/dev/Dockerfile)
- Build with the latest source code
- Build with Github Action so you can check the logs at any time

## Usage

### Docker

`docker run -it --rm -p 8080:80 purposely/blessing-skin:latest`

### Docker Compose

```yml
version: '3.9'
services:
  blessingskin:
    image: purposely/blessing-skin:latest
    restart: unless-stopped
    volumes:
      - /your_data_folder/data:/app/storage
    ports:
      - '8080:80'
    environment:
      MAIL_HOST: smtp.office365.com
      MAIL_PORT: 465
      MAIL_USERNAME: MAIL_USERNAME
      MAIL_PASSWORD: MAIL_PASSWORD
      MAIL_FROM_ADDRESS: MAIL_FROM_ADDRESS
      MAIL_FROM_NAME: MAIL_FROM_NAME
```

---

- Essential Steps
  1. Create/Mount /your_data_folder/.env file, example here.

        ```env
        APP_DEBUG=false
        APP_ENV=production
        APP_FALLBACK_LOCALE=en

        DB_CONNECTION=sqlite
        DB_HOST=localhost
        DB_PORT=3306
        DB_DATABASE=/app/storage/database.db
        DB_USERNAME=username
        DB_PASSWORD=secret
        DB_PREFIX=

        # Hash Algorithm for Passwords
        #
        # Available values:
        # - BCRYPT, ARGON2I, PHP_PASSWORD_HASH
        # - MD5, SALTED2MD5
        # - SHA256, SALTED2SHA256
        # - SHA512, SALTED2SHA512
        #
        # New sites are *highly* recommended to use BCRYPT.
        #
        PWD_METHOD=BCRYPT
        APP_KEY=base64:gw4mJ1NxyIPnCYSWIhWvyfehylWu+iXwJn0PI91wmLM=

        MAIL_MAILER=smtp
        MAIL_HOST=
        MAIL_PORT=465
        MAIL_USERNAME=
        MAIL_PASSWORD=
        MAIL_ENCRYPTION=
        MAIL_FROM_ADDRESS=
        MAIL_FROM_NAME=

        CACHE_DRIVER=file
        SESSION_DRIVER=file
        QUEUE_CONNECTION=sync

        REDIS_CLIENT=phpredis
        REDIS_HOST=127.0.0.1
        REDIS_PASSWORD=null
        REDIS_PORT=6379

        PLUGINS_DIR=/app/storage/plugins
        PLUGINS_URL=null
        ```

  2. If you are using sqlite3, Create/Mount /your_data_folder/database.db file.
  3. Create /your_data_folder/plugins folder.
  4. Create /your_data_folder/framework/sessions folder.
  5. Enjoy!
