load("@io_bazel_rules_docker//container:container.bzl", "container_image", "container_layer", "container_push")
load("@io_bazel_rules_docker//docker/package_managers:download_pkgs.bzl", "download_pkgs")
load("@io_bazel_rules_docker//docker/package_managers:install_pkgs.bzl", "install_pkgs")
load("@io_bazel_rules_docker//docker/util:run.bzl", "container_run_and_extract")

#
# Build Counter-Strike: Source Layer
#

container_run_and_extract(
    name = "download_counter_strike_source",
    commands = [
        "sed -i -e's/ main/ main non-free/g' /etc/apt/sources.list",
        "echo steam steam/question select 'I AGREE' | debconf-set-selections",
        "echo steam steam/license note '' | debconf-set-selections",
        "apt update",
        "apt install -y ca-certificates steamcmd",
        "/usr/games/steamcmd +login anonymous +force_install_dir /opt/game +app_update 232330 validate +quit",
        "rm -rf /opt/game/steamapps",
        "chown -R nobody:root /opt/game",
        "tar -czvf /archive.tar.gz /opt/game/",
    ],
    extract_file = "/archive.tar.gz",
    image = "@base_image//image",
)

container_layer(
    name = "counter_strike_source",
    tars = [
        ":download_counter_strike_source/archive.tar.gz",
    ],
)

#
# Build Maps Layer
#

container_image(
    name = "maps_container",
    base = "@base_image//image",
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
# Build SourceMod Layer
#

container_image(
    name = "sourcemod_container",
    base = "@base_image//image",
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
# Build LAN of DOOM Plugin and Config Layers
#

container_layer(
    name = "lanofdoom_server_config",
    directory = "/opt/game/cstrike/cfg",
    files = [
        ":server.cfg",
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

container_image(
    name = "config_container",
    base = "@base_image//image",
    layers = [
        ":lanofdoom_server_config",
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
# Build Server Base Image
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
# Build Final Image
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
        ":sourcemod",
        ":lanofdoom",
    ],
)

container_push(
    name = "push_server_image",
    format = "Docker",
    image = ":server_image",
    registry = "ghcr.io",
    repository = "lanofdoom/counterstrikesource-server",
    tag = "latest",
)
