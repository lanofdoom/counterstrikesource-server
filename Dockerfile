FROM ubuntu:focal

ENV STEAM_DIR=/opt/steam
ENV SRCDS_DIR=/opt/game
ENV GAME_DIR=${SRCDS_DIR}/cstrike
ENV LD_LIBRARY_PATH="$SRCDS_DIR:$SRCDS_DIR/bin:$LD_LIBRARY_PATH"

# Download and install steamcmd and srcds
RUN  dpkg --add-architecture i386 && apt-get update && export DEBIAN_FRONTEND=noninteractive \
   && apt-get install --no-install-recommends -y -o APT::Immediate-Configure=0 \
   ca-certificates \
   curl \
   lib32gcc1 \
   libc6 \
   libcurl4:i386 \
   unzip \
   && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

RUN mkdir -p ${STEAM_DIR} && curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - -C ${STEAM_DIR}
RUN ${STEAM_DIR}/steamcmd.sh +login anonymous +force_install_dir ${SRCDS_DIR} +app_update 232330 validate +quit || true
RUN chown -R nobody:root ${STEAM_DIR} ${SRCDS_DIR}

USER nobody

# Download plugins and maps
RUN cd ${GAME_DIR} \
 && curl -sLo- "https://lanofdoom.github.io/counterstrikesource-maps/releases/v1.0.0/maps.tar.gz" | tar xvzf - \
 && curl -sLo- "https://mms.alliedmods.net/mmsdrop/1.11/mmsource-1.11.0-git1143-linux.tar.gz" | tar xvzf - \
 && curl -sLo- "https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6502-linux.tar.gz" | tar xvzf - \
 && curl -SLo- "https://lanofdoom.github.io/auth-by-steam-group/releases/v1.0.0/auth_by_steam_group.tar.gz" | tar xvzf - \
 && curl -sL "https://lanofdoom.github.io/counterstrikesource-max-cash/releases/v1.0.0/max_cash.smx" -o ${GAME_DIR}/addons/sourcemod/plugins/max_cash.smx

# Enable Metamod (required for SourceMod)
COPY metamod.vdf ${GAME_DIR}/addons
COPY metamod_x64.vdf ${GAME_DIR}/addons

# Enable/disable the desired set of sourcemod plugins
RUN cd ${GAME_DIR}/addons/sourcemod/plugins \
 && mv basevotes.smx disabled/basevotes.smx \
 && mv funcommands.smx disabled/funcommands.smx \
 && mv funvotes.smx disabled/funvotes.smx \
 && mv playercommands.smx disabled/playercommands.smx \
 && mv disabled/mapchooser.smx mapchooser.smx \
 && mv disabled/rockthevote.smx rockthevote.smx \
 && mv disabled/nominations.smx nominations.smx

# Set server configuration options
RUN ls ${GAME_DIR}/maps/*.bsp | grep -v test | sed -e 's/.*\/\([^\/]*\).bsp/\1/' > ${GAME_DIR}/cfg/mapcycle.txt
COPY rtv.cfg ${GAME_DIR}/cfg/sourcemod
COPY server.cfg ${GAME_DIR}/cfg

# Configure entrypoint
COPY entrypoint.sh /opt/game/entrypoint.sh
CMD /opt/game/entrypoint.sh