load("@io_bazel_rules_docker//container:container.bzl", "container_image", "container_layer", "container_push")
load("@io_bazel_rules_docker//docker/package_managers:download_pkgs.bzl", "download_pkgs")
load("@io_bazel_rules_docker//docker/package_managers:install_pkgs.bzl", "install_pkgs")
load("@com_github_lanofdoom_steamcmd//:defs.bzl", "steam_depot_layer")

#
# Counter-Strike: Source Layer
#

steam_depot_layer(
    name = "counter_strike_source",
    app = "232330",
    directory = "/opt/game",
)

#
# Maps Layer
#

container_layer(
    name = "maps",
    directory = "/opt/game/cstrike",
    tars = [
        "@maps//file",
        "@maps_bz2//file",
    ],
)

#
# MetaMod Layer
#

container_layer(
    name = "metamod",
    directory = "/opt/game/cstrike",
    tars = [
        "@metamod//file",
    ],
)

#
# SourceMod Layer
#

container_layer(
    name = "sourcemod",
    directory = "/opt/game/cstrike",
    tars = [
        "@sourcemod//file",
    ],
)

#
# Authorization Layer
#

container_layer(
    name = "authorization",
    directory = "/opt/game/cstrike",
    tars = [
        "@auth_by_steam_group//file",
    ],
)

#
# Plugins Layers
#

container_layer(
    name = "plugins",
    directory = "/opt/game/cstrike",
    tars = [
        "@disable_buyzones//file",
        "@disable_radar//file",
        "@disable_round_timer//file",
        "@ffa_spawns//file",
        "@free_for_all//file",
        "@gungame//file",
        "@map_settings//file",
        "@max_cash//file",
        "@paintball//file",
        "@remove_objectives//file",
        "@respawn//file",
        "@spawn_protection//file",
    ],
)

#
# Config Layer
#

container_layer(
    name = "config",
    directory = "/opt/game/cstrike/cfg",
    files = [
        ":server.cfg",
    ],
)

#
# Base Image
#

download_pkgs(
    name = "server_deps",
    image_tar = "@base_image//image",
    packages = [
        "ca-certificates",
        "libcurl4",
    ],
)

install_pkgs(
    name = "server_base",
    image_tar = "@base_image//image",
    installables_tar = ":server_deps.tar",
    installation_cleanup_commands = "rm -rf /var/lib/apt/lists/*",
    output_image_name = "server_base",
)

#
# Final Image
#

container_image(
    name = "server_image",
    base = ":server_base",
    entrypoint = ["/entrypoint.sh"],
    env = {
        "CSS_HOSTNAME": "",
        "CSS_MAP": "de_dust2",
        "CSS_MOTD": "",
        "CSS_PASSWORD": "",
        "CSS_PORT": "27015",
        "RCON_PASSWORD": "",
        "STEAM_GROUP_ID": "",
        "STEAM_API_KEY": "",
    },
    files = [
        ":entrypoint.sh",
    ],
    layers = [
        ":counter_strike_source",
        ":maps",
        ":metamod",
        ":sourcemod",
        ":authorization",
        ":plugins",
        ":config",
    ],
    symlinks = {
        "/root/.steam/sdk32/steamclient.so": "/opt/game/bin/steamclient.so"
    },
)

container_push(
    name = "push_server_image",
    format = "Docker",
    image = ":server_image",
    registry = "ghcr.io",
    repository = "lanofdoom/counterstrikesource-server",
    tag = "latest",
)
