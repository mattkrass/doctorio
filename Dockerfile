FROM debian
ADD factorio.xz /opt/
EXPOSE 34197/udp
ENTRYPOINT ["/opt/factorio/bin/x64/factorio", "--start-server-load-latest", "--server-settings", "/opt/factorio/cfg/server-settings.json"]

