#!/bin/bash

# Start Server
/opt/game/srcds_linux \
    -game cstrike \
    -tickrate 100 \
    -strictbindport \
    +map de_dust2 \
    +hostname "$CSS_HOSTNAME" \
    +rcon_password "$RCON_PASSWORD" \
    +sm_auth_by_steam_group_group_id "$STEAM_GROUP_ID" \
    +sm_auth_by_steam_group_steam_key "$STEAM_API_KEY"