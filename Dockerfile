FROM debian
ADD factorio.xz /opt/
ADD server-settings.json /opt/factorio/data
ENTRYPOINT ["/opt/factorio/bin/x64/factorio", "--start-server-load-latest", "--server-settings", "/opt/factorio/data/server-settings.json"]

