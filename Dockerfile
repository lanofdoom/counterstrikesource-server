FROM ubuntu:focal as steam-install-cstrike

# Download and install steamcmd and srcds
RUN dpkg --add-architecture i386 && apt-get update && export DEBIAN_FRONTEND=noninteractive \
 && apt-get install --no-install-recommends -y -o APT::Immediate-Configure=0 \
    ca-certificates \
    curl \
    lib32gcc1 \
    libc6 \
    libcurl4:i386 \
    libncurses5:i386 \
    xz-utils \
    unzip \
 && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

RUN mkdir -p /opt/steam \
 && curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - -C /opt/steam

RUN /opt/steam/steamcmd.sh +login anonymous +force_install_dir /opt/game +app_update 232330 validate +quit || true

# Download plugins and maps
RUN cd /opt/game/cstrike \
 && curl -sLo- "https://lanofdoom.github.io/counterstrikesource-maps/releases/v2.0.0/maps.tar.xz" | tar Jxvf - \
 && curl -sLo- "https://mms.alliedmods.net/mmsdrop/1.11/mmsource-1.11.0-git1143-linux.tar.gz" | tar zxvf - \
 && curl -sLo- "https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6502-linux.tar.gz" | tar zxvf - \
 && curl -SLo- "https://lanofdoom.github.io/auth-by-steam-group/releases/v1.0.1/auth_by_steam_group.tar.gz" | tar zxvf - \
 && curl -sL "https://lanofdoom.github.io/counterstrikesource-map-settings/releases/v1.1.0/lan_of_doom_map_settings.smx" -o /opt/game/cstrike/addons/sourcemod/plugins/lan_of_doom_map_settings.smx \
 && curl -sL "https://lanofdoom.github.io/counterstrikesource-max-cash/releases/v1.0.0/max_cash.smx" -o /opt/game/cstrike/addons/sourcemod/plugins/max_cash.smx

# Create bz2 version of map data
RUN cd /opt/game/cstrike && ./make_bz2_files.sh

# Enable Metamod (required for SourceMod)
COPY metamod.vdf metamod_x64.vdf /opt/game/cstrike/addons/

# Enable/disable the desired set of sourcemod plugins
RUN cd /opt/game/cstrike/addons/sourcemod/plugins \
 && mv basevotes.smx disabled/basevotes.smx \
 && mv funcommands.smx disabled/funcommands.smx \
 && mv funvotes.smx disabled/funvotes.smx \
 && mv playercommands.smx disabled/playercommands.smx \
 && mv disabled/mapchooser.smx mapchooser.smx \
 && mv disabled/rockthevote.smx rockthevote.smx \
 && mv disabled/nominations.smx nominations.smx

# Set server configuration options
RUN ls /opt/game/cstrike/maps/*.bsp | grep -v test | sed -e 's/.*\/\([^\/]*\).bsp/\1/' > /opt/game/cstrike/cfg/mapcycle.txt
COPY rtv.cfg /opt/game/cstrike/cfg/sourcemod
COPY server.cfg /opt/game/cstrike/cfg
COPY entrypoint.sh /opt/game/entrypoint.sh

# Create Final Image
FROM ubuntu:focal

RUN dpkg --add-architecture i386 && apt-get update && export DEBIAN_FRONTEND=noninteractive \
 && apt-get install --no-install-recommends -y -o APT::Immediate-Configure=0 \
    ca-certificates \
    curl \
    lib32gcc1 \
    libc6 \
    libcurl4:i386 \
    libncurses5:i386 \
    unzip \
 && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

USER nobody
COPY --chown=nobody:root --from=steam-install-cstrike /opt/game /opt/game

CMD /opt/game/entrypoint.sh

# Environmental variables for frequently modified server settings
ENV CSS_ADMIN="" \
    CSS_HOSTNAME="" \
    CSS_MOTD="" \
    RCON_PASSWORD="" \
    STEAM_GROUP_ID="" \
    STEAM_API_KEY=""
