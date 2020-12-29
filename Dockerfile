FROM debian:testing-20201012-slim as steam-install-cstrike
RUN  dpkg --add-architecture i386 && apt-get update && export DEBIAN_FRONTEND=noninteractive \
   && apt-get install --no-install-recommends -y -o APT::Immediate-Configure=0 \
   ca-certificates \
   curl \
   lib32gcc-s1 \
   libc6 \
   libcurl4:i386 \
   unzip \
   && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

RUN mkdir -p /opt/steam && curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - -C /opt/steam

RUN /opt/steam/steamcmd.sh +login anonymous +force_install_dir /opt/install +app_update 232330 validate +quit || true


FROM debian:testing-20201012-slim
RUN  dpkg --add-architecture i386 && apt-get update && export DEBIAN_FRONTEND=noninteractive \
   && apt-get install --no-install-recommends -y -o APT::Immediate-Configure=0 \
   ca-certificates \
   curl \
   lib32gcc-s1 \
   libc6 \
   libcurl4:i386 \
   unzip \
   && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts


ENV SRCDS_DIR=/opt/game
ENV GAME_DIR=${SRCDS_DIR}/cstrike
ENV LD_LIBRARY_PATH="$SRCDS_DIR:$SRCDS_DIR/bin:$LD_LIBRARY_PATH"

USER nobody
COPY --chown=nobody:root --from=steam-install-cstrike /opt/install $SRCDS_DIR

ADD maps.tar.gz ${GAME_DIR}/

RUN cd ${GAME_DIR} \
 && curl -sLo- "https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6502-linux.tar.gz" | tar xvzf - \
 && curl -sLo- "https://mms.alliedmods.net/mmsdrop/1.11/mmsource-1.11.0-git1143-linux.tar.gz" | tar xvzf - \
 && curl -sLo- "http://users.alliedmods.net/~kyles/builds/SteamWorks/SteamWorks-git132-linux.tar.gz" | tar xvzf - \
 && rm ${GAME_DIR}/addons/sourcemod/plugins/playercommands.smx \
       ${GAME_DIR}/addons/sourcemod/plugins/funvotes.smx \
       ${GAME_DIR}/addons/sourcemod/plugins/funcommands.smx \
 && curl -sL "https://raw.githubusercontent.com/lanofdoom/counterstrikesource-max-cash/6c48d983ea61a146c108d431f17d1ca4ac6403da/latest/max_cash.smx" \
 -o ${GAME_DIR}/addons/sourcemod/plugins/max_cash.smx

COPY server.cfg ${GAME_DIR}/cfg
COPY metamod.vdf ${GAME_DIR}/addons

COPY admins_simple.ini ${GAME_DIR}/addons/sourcemod/configs
COPY motd.txt ${GAME_DIR}/cfg/motd.txt

ENTRYPOINT ["/opt/game/srcds_linux", "-game cstrike", "+map de_dust2", "-strictbindport"]
