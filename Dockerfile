FROM ubuntu:focal

# Environmental variables for frequently modified server settings
ENV CSS_HOSTNAME ""
ENV RCON_PASSWORD ""
ENV STEAM_GROUP_ID ""
ENV STEAM_API_KEY ""

# Download and install steamcmd and srcds
RUN  dpkg --add-architecture i386 && apt-get update && export DEBIAN_FRONTEND=noninteractive \
   && apt-get install --no-install-recommends -y -o APT::Immediate-Configure=0 \
   ca-certificates \
   curl \
   lib32gcc1 \
   libc6 \
   libcurl4:i386 \
   libncurses6:i386 \
   unzip \
   && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

RUN mkdir -p /opt/steam && curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - -C /opt/steam
RUN /opt/steam/steamcmd.sh +login anonymous +force_install_dir /opt/game +app_update 232330 validate +quit || true
RUN chown -R nobody:root /opt/steam /opt/game

USER nobody

# Download plugins and maps
RUN cd /opt/game/cstrike \
 && curl -sLo- "https://lanofdoom.github.io/counterstrikesource-maps/releases/v1.0.0/maps.tar.gz" | tar xvzf - \
 && curl -sLo- "https://mms.alliedmods.net/mmsdrop/1.11/mmsource-1.11.0-git1143-linux.tar.gz" | tar xvzf - \
 && curl -sLo- "https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6502-linux.tar.gz" | tar xvzf - \
 && curl -SLo- "https://lanofdoom.github.io/auth-by-steam-group/releases/v1.0.1/auth_by_steam_group.tar.gz" | tar xvzf - \
 && curl -sL "https://lanofdoom.github.io/counterstrikesource-map-settings/releases/v1.0.0/lan_of_doom_map_settings.smx" -o /opt/game/cstrike/addons/sourcemod/plugins/lan_of_doom_map_settings.smx \
 && curl -sL "https://lanofdoom.github.io/counterstrikesource-max-cash/releases/v1.0.0/max_cash.smx" -o /opt/game/cstrike/addons/sourcemod/plugins/max_cash.smx

# Enable Metamod (required for SourceMod)
COPY metamod.vdf /opt/game/cstrike/addons
COPY metamod_x64.vdf /opt/game/cstrike/addons

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

# Configure entrypoint
COPY entrypoint.sh /opt/game/entrypoint.sh
CMD /opt/game/entrypoint.sh
