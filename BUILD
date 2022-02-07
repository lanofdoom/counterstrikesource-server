load("@io_bazel_rules_docker//container:container.bzl", "container_image", "container_layer", "container_push")
load("@io_bazel_rules_docker//docker/util:run.bzl", "container_run_and_commit", "container_run_and_extract")
load("@com_github_lanofdoom_steamcmd//:defs.bzl", "steam_depot_layer")

container_run_and_commit(
    name = "server_base",
    image = "@base_image//image",
    commands = [
        "dpkg --add-architecture i386",
        "apt-get update",
        "apt-get install -y ca-certificates lib32gcc-s1 libcurl4:i386 libsdl2-2.0-0:i386",
        "rm -rf /var/lib/apt/lists/*",
    ],
)

#
# Build Counter-Strike: Source Layer
#

steam_depot_layer(
    name = "counterstrikesource",
    app = "232330",
    directory = "/opt/game",
)

#
# Build Maps Layer
#

container_image(
    name = "maps_container",
    base = ":server_base",
    directory = "/opt/game/cstrike",
    tars = [
        "@maps//file",
    ],
)

container_run_and_extract(
    name = "build_maps",
    commands = [
        "apt update && apt install bzip2",
        "cd /opt/game/cstrike",
        "./make_bz2_files.sh",
        "rm *.sh *.md *license",
        "chown -R nobody:root /opt",
        "tar -czvf /archive.tar.gz /opt",
    ],
    extract_file = "/archive.tar.gz",
    image = ":maps_container.tar",
)

container_layer(
    name = "maps",
    tars = [
        ":build_maps/archive.tar.gz",
    ],
)

#
# Build Sourcemod Layer
#

container_image(
    name = "sourcemod_container",
    base = ":server_base",
    directory = "/opt/game/cstrike",
    tars = [
        "@metamod//file",
        "@sourcemod//file",
    ],
)

container_run_and_extract(
    name = "build_sourcemod",
    commands = [
        "cd /opt/game/cstrike/addons/sourcemod",
        "mv plugins/basevotes.smx plugins/disabled/basevotes.smx",
        "mv plugins/funcommands.smx plugins/disabled/funcommands.smx",
        "mv plugins/funvotes.smx plugins/disabled/funvotes.smx",
        "mv plugins/playercommands.smx plugins/disabled/playercommands.smx",
        "mv plugins/disabled/mapchooser.smx plugins/mapchooser.smx",
        "mv plugins/disabled/rockthevote.smx plugins/rockthevote.smx",
        "mv plugins/disabled/nominations.smx plugins/nominations.smx",
        "chown -R nobody:root /opt",
        "tar -czvf /archive.tar.gz /opt",
    ],
    extract_file = "/archive.tar.gz",
    image = ":sourcemod_container.tar",
)

container_layer(
    name = "sourcemod",
    tars = [
        ":build_sourcemod/archive.tar.gz",
    ],
)

#
# Build LAN of DOOM Plugin and Config Layer
#

container_layer(
    name = "lanofdoom_server_config",
    directory = "/opt/game/cstrike/cfg",
    files = [
        ":server.cfg",
    ],
)

container_layer(
    name = "lanofdoom_server_entrypoint",
    directory = "/opt/game",
    files = [
        ":entrypoint.sh",
    ],
)

container_layer(
    name = "lanofdoom_server_plugins",
    directory = "/opt/game/cstrike",
    tars = [
        "@auth_by_steam_group//file",
        "@disable_buyzones//file",
        "@disable_radar//file",
        "@disable_round_timer//file",
        "@free_for_all//file",
        "@gungame//file",
        "@map_settings//file",
        "@max_cash//file",
        "@remove_objectives//file",
        "@respawn//file",
        "@spawn_protection//file",
        "@weapon_cleanup//file",
    ],
)

container_image(
    name = "config_container",
    base = ":server_base",
    layers = [
        ":lanofdoom_server_config",
        ":lanofdoom_server_entrypoint",
        ":lanofdoom_server_plugins",
    ],
)

container_run_and_extract(
    name = "build_lanofdoom",
    commands = [
        "chown -R nobody:root /opt",
        "tar -czvf /archive.tar.gz /opt",
    ],
    extract_file = "/archive.tar.gz",
    image = ":config_container.tar",
)

container_layer(
    name = "lanofdoom",
    tars = [
        ":build_lanofdoom/archive.tar.gz",
    ],
)

#
# Build Final Image
#

container_image(
    name = "server_image",
    base = ":server_base",
    entrypoint = ["/opt/game/entrypoint.sh"],
    env = {
        "CSS_ADMIN": "",
        "CSS_HOSTNAME": "",
        "CSS_MAP": "de_dust2",
        "CSS_MOTD": "",
        "CSS_PASSWORD": "",
        "CSS_PORT": "27015",
        "RCON_PASSWORD": "",
        "STEAM_GROUP_ID": "",
        "STEAM_API_KEY": "",
    },
    layers = [
        ":counterstrikesource",
        ":maps",
        ":sourcemod",
        ":lanofdoom_server_config",
        ":lanofdoom_server_plugins",
        ":lanofdoom_server_entrypoint",
    ],
    symlinks = {"/root/.steam/sdk32/steamclient.so": "/opt/game/bin/steamclient.so"},
    workdir = "/opt/game",
)

container_push(
    name = "push_server_image",
    format = "Docker",
    image = ":server_image",
    registry = "ghcr.io",
    repository = "lanofdoom/counterstrikesource-server",
    tag = "latest",
)
