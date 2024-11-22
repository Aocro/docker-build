# Github-Release-Mirror

> Github: [Aocro/docker-build/github-release-mirror](https://github.com/Aocro/docker-build/tree/main/github-release-mirror)

> Forked from [richardklose/github-release-mirror](https://github.com/richardklose/github-release-mirror)

Choose whether to mirror only the latest version of the repository or all versions.

## Usage

1. Create crontab

```crontab
0 3 * * * /opt/mirror.sh sass/node-sass all
0 4 * * * /opt/mirror.sh electron/electron latest
```

then put it in `${DATA_PATH}/github-release-mirror`

2. Docker compose

```yaml
services:
  github-release-mirror:
    image: purposely/github-release-mirror:latest
    volumes:
      - ${GITHUB_RELEASE_MIRROR_PATH}:/mirror
      - ${DATA_PATH}/github-release-mirror:/etc/cron.d/mirror-jobs:ro
    environment:
      ALL_PROXY: ${PROXY_HTTP_Q}
      TZ: ${TIME_ZONE}
    ports:
      - 80:80
```

3. (Optional) Environments
  - time zone: `TZ=${YOUR_TIME_ZONE}`
  - proxy: `ALL_PROXY=${YOUR_PROXY}`