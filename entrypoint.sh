#!/bin/bash -ue

[ -z "${CSS_ADMIN}" ] || echo "${CSS_ADMIN} \"99:z\"" > /opt/game/cstrike/addons/sourcemod/configs/admins_simple.ini

[ -z "${CSS_MOTD}" ] || echo "${CSS_MOTD}" > /opt/game/cstrike/motd.txt

/opt/game/srcds_run \
    -game cstrike \
    -strictbindport \
    +map de_dust2 \
    +hostname "$CSS_HOSTNAME" \
    +rcon_password "$RCON_PASSWORD" \
    +sv_password "$CSS_PASSWORD" \
    +sm_auth_by_steam_group_group_id "$STEAM_GROUP_ID" \
    +sm_auth_by_steam_group_steam_key "$STEAM_API_KEY"