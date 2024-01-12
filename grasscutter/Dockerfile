FROM alpine AS build

# See https://gitlab.com/YuukiPS/GC-Resources.git branch name
ARG RESOURCES_VERSION="4.0"
# If this token is set, it will enable the usage of the Github Action API to fetch the latest artifact versions from the development branch.
ARG GITHUB_ACCESS_TOKEN=""

WORKDIR /app

# Download curl & git
RUN apk add curl && apk add git jq

# Download latest jar
RUN if [ -n $GITHUB_ACCESS_TOKEN ]; then \
    echo Downloading from latest github artifacts... \
    && curl -H "Authorization: Bearer $GITHUB_ACCESS_TOKEN" -LJO $(curl -s -H "Authorization: Bearer $GITHUB_ACCESS_TOKEN" \
    "https://api.github.com/repos/Grasscutters/Grasscutter/actions/workflows/build.yml/runs?status=success&per_page=1" \
    | jq -r '.workflow_runs[0].artifacts_url' \
    | xargs curl -s -H "Authorization: Bearer $GITHUB_ACCESS_TOKEN" \
    | jq -r '.artifacts[0].archive_download_url') \
    && unzip Grasscutter.zip && mv *.jar grasscutter.jar; \
else \
    echo Downloading from latest github release... \
    && curl -L -o grasscutter.jar $(curl -s https://api.github.com/repos/Grasscutters/Grasscutter/releases/latest | grep -o "browser_download_url.*" | cut -d'"' -f3); \
fi

# Download latest resources
RUN git clone -b $RESOURCES_VERSION --depth 1 https://gitlab.com/YuukiPS/GC-Resources.git

# Download keystore
RUN curl -L -O "https://github.com/Grasscutters/Grasscutter/raw/development/keystore.p12"

# Build
FROM openjdk:17-jdk-slim

WORKDIR /app

COPY --from=build /app/grasscutter.jar /app/grasscutters.jar
COPY --from=build /app/keystore.p12 /app/keystore.p12
COPY --from=build /app/GC-Resources/Resources /app/resources

ENTRYPOINT ["java", "-jar", "grasscutters.jar"]