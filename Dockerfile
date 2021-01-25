FROM ubuntu:focal as configuration

# Install dependencies needed for map, plugin, and config installation
RUN apt-get update \
    && apt-get install -y -o APT::Immediate-Configure=0 --no-install-recommends --no-install-suggests \
        ca-certificates \
        curl \
        xz-utils

# Make output directories
RUN mkdir -p /opt/game/cstrike/addons \
    && mkdir -p /opt/game/cstrike/cfg \
    && mkdir -p /opt/game/cstrike/maps

# Install maps
RUN cd /opt/game/cstrike \
    && curl -sLo- "https://lanofdoom.github.io/counterstrikesource-maps/releases/v2.0.0/maps.tar.xz" | tar Jxvf - \
    && ./make_bz2_files.sh \
    && rm make_bz2_files.sh *license *readme.md

# Install SourceMod and Metamod
RUN cd /opt/game/cstrike \
    && curl -sLo- "https://mms.alliedmods.net/mmsdrop/1.11/mmsource-1.11.0-git1143-linux.tar.gz" | tar zxvf - \
    && curl -sLo- "https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6502-linux.tar.gz" | tar zxvf - \
    && cd /opt/game/cstrike/addons/sourcemod/plugins \
    && mv basevotes.smx disabled/basevotes.smx \
    && mv funcommands.smx disabled/funcommands.smx \
    && mv funvotes.smx disabled/funvotes.smx \
    && mv playercommands.smx disabled/playercommands.smx \
    && mv disabled/mapchooser.smx mapchooser.smx \
    && mv disabled/rockthevote.smx rockthevote.smx \
    && mv disabled/nominations.smx nominations.smx

# Install LAN of DOOM Plugins
RUN cd /opt/game/cstrike \
    && curl -SLo- "https://lanofdoom.github.io/auth-by-steam-group/releases/v1.2.1/auth_by_steam_group.tar.gz" | tar zxvf - \
    && curl -sL "https://lanofdoom.github.io/counterstrikesource-map-settings/releases/v1.1.0/lan_of_doom_map_settings.smx" -o /opt/game/cstrike/addons/sourcemod/plugins/lan_of_doom_map_settings.smx \
    && curl -sL "https://lanofdoom.github.io/counterstrikesource-max-cash/releases/v1.0.0/max_cash.smx" -o /opt/game/cstrike/addons/sourcemod/plugins/max_cash.smx

# Set server configuration options
COPY rtv.cfg /opt/game/cstrike/cfg/sourcemod
COPY server.cfg /opt/game/cstrike/cfg
COPY entrypoint.sh /opt/game/entrypoint.sh

FROM ghcr.io/lanofdoom/counterstrikesource-base/counterstrikesource-base:latest

# Install runtime dependencies
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y -o APT::Immediate-Configure=0 --no-install-recommends --no-install-suggests \
        ca-certificates:i386 \
        libcurl4:i386 \
    && apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# Copy in plugins and maps
COPY --chown=nobody:root --from=configuration /opt/game /opt/game

# Create Map Cycle
RUN cd /opt/game/cstrike \
    && ls maps/*.bsp | grep -v test | sed -e 's/.*\/\([^\/]*\).bsp/\1/' > /opt/game/cstrike/cfg/mapcycle.txt

# Switch user to nobody
USER nobody
ENTRYPOINT /opt/game/entrypoint.sh

# Environmental variables for frequently modified server settings
ENV CSS_ADMIN="" \
    CSS_HOSTNAME="" \
    CSS_MOTD="" \
    CSS_PASSWORD="" \
    RCON_PASSWORD="" \
    STEAM_GROUP_ID="" \
    STEAM_API_KEY=""
