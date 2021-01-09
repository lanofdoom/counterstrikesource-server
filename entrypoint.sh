#!/bin/bash -ue

[ -z "${CSS_MOTD}" ] || echo "${CSS_MOTD}" > /opt/game/cstrike/motd.txt

[ -z "${CSS_ADMIN}" ] || echo "${CSS_ADMIN} \"99:z\"" > /opt/game/cstrike/addons/sourcemod/configs/admins_simple.ini

LD_LIBRARY_PATH="/opt/game:/opt/game/bin:${LD_LIBRARY_PATH:-}" /opt/game/srcds_linux \
    -game cstrike \
    -tickrate 100 \
    -strictbindport \
    +map de_dust2 \
    +hostname "$CSS_HOSTNAME" \
    +rcon_password "$RCON_PASSWORD" \
    +sm_auth_by_steam_group_group_id "$STEAM_GROUP_ID" \
    +sm_auth_by_steam_group_steam_key "$STEAM_API_KEY"