# LAN of DOOM Counter-Strike: Source Server
Docker image for a private, preconfigured private Counter-Strike: Source server as used by the LAN of DOOM.

# Installation
Run ``docker pull ghcr.io/lanofdoom/counterstrikesource-server/counterstrikesource-server:latest``

# Installed Addons
*  LAN of DOOM Authenticate by Steam Group
*  LAN of DOOM Map Settings
*  LAN of DOOM Max Cash
*  MetaMod:Source
*  SourceMod

# Environmental Variables
``CSS_HOSTNAME`` The name of the server as listed in Valve's server browser.

``CSS_PASSWORD`` The password users must enter in order to join the server.

``RCON_PASSWORD`` The rcon password for the server.

``STEAM_GROUP_ID`` The Steam group to use for the allowlist of users joining the server.

``STEAM_API_KEY`` The [Steam API key](https://steamcommunity.com/dev/apikey) to use for the group membership checks with the Steam's Web API.
