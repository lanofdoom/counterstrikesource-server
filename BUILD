load("@io_bazel_rules_docker//container:container.bzl", "container_image", "container_layer", "container_push")
load("@io_bazel_rules_docker//docker/package_managers:download_pkgs.bzl", "download_pkgs")
load("@io_bazel_rules_docker//docker/package_managers:install_pkgs.bzl", "install_pkgs")
load("@io_bazel_rules_docker//docker/util:run.bzl", "container_run_and_commit", "container_run_and_extract")

#
# Build Maps Layer
#

container_image(
    name = "maps_container",
    directory = "/maps",
    tars = [
        "@maps//file",
    ],
    base = "@ubuntu//image",
)

container_run_and_extract(
    name = "extract_maps",
    extract_file = "/maps.tar",
    commands = [
        "cd maps",
        "mkdir cfg",
        "./make_bz2_files.sh",
        "rm *.sh *.md *license",
        "chown -R nobody:root .",
        "tar -cvf /maps.tar *",
    ],
    image = ":maps_container.tar",
)

container_layer(
    name = "maps_layer",
    compression = "gzip",
    directory = "/opt/game/cstrike",
    tars = [
        ":extract_maps/maps.tar",
    ],
)

#
# Build Sourcemod Layer
#

container_image(
    name = "sourcemod_container",
    directory = "/sourcemod",
    tars = [
        "@metamod//file",
        "@sourcemod//file",
    ],
    base = "@ubuntu//image",
)

container_run_and_extract(
    name = "configure_sourcemod",
    extract_file = "/sourcemod.tar",
    commands = [
        "cd sourcemod/addons/sourcemod/plugins",
        "mv basevotes.smx disabled/basevotes.smx",
        "mv funcommands.smx disabled/funcommands.smx",
        "mv funvotes.smx disabled/funvotes.smx",
        "mv playercommands.smx disabled/playercommands.smx",
        "mv disabled/mapchooser.smx mapchooser.smx",
        "mv disabled/rockthevote.smx rockthevote.smx",
        "mv disabled/nominations.smx nominations.smx",
        "cd /sourcemod",
        "chown -R nobody:root .",
        "tar -cvf /sourcemod.tar *",
    ],
    image = ":sourcemod_container.tar",
)

container_layer(
    name = "sourcemod_layer",
    compression = "gzip",
    directory = "/opt/game/cstrike",
    tars = [
        ":configure_sourcemod/sourcemod.tar",
    ],
)

#
# Build Image With i386 Enabled
#

container_run_and_extract(
    name = "enable_i386_sources",
    docker_run_flags = ["--entrypoint=''", "--user='root'"],
    image = "@server_base//image",
    extract_file = "/var/lib/dpkg/arch",
    commands = [
        "dpkg --add-architecture i386",
    ],
)

container_image(
    name = "server_with_i386_packages",
    base = "@server_base//image",
    user = "root",
    entrypoint = [],
    compression = "gzip",
    directory = "/var/lib/dpkg",
    files = [
        ":enable_i386_sources/var/lib/dpkg/arch",
    ],
)

#
# Build LAN of DOOM Plugin and Config Layer
#

container_layer(
    name = "lanofdoom_server_config",
    compression = "gzip",
    directory = "/opt/game/cstrike/cfg",
    files = [
        ":server.cfg",
    ],
)

container_layer(
    name = "lanofdoom_server_entrypoint",
    compression = "gzip",
    directory = "/opt/game",
    files = [
        ":entrypoint.sh",
    ],
)

container_layer(
    name = "lanofdoom_server_plugins",
    compression = "gzip",
    directory = "/opt/game/cstrike",
    tars = [
        "@auth_by_steam_group//file",
        "@map_settings//file",
        "@max_cash//file",
    ],
)

container_image(
    name = "config_container",
    layers = [
        ":lanofdoom_server_config",
        ":lanofdoom_server_entrypoint",
        ":lanofdoom_server_plugins",
    ],
    base = "@ubuntu//image",
)

container_run_and_extract(
    name = "configure_lanofdoom_layer",
    extract_file = "/lanofdoom.tar",
    commands = [
        "chown -R nobody:root /opt",
        "tar -cvf /lanofdoom.tar /opt",
    ],
    image = ":config_container.tar",
)

container_layer(
    name = "lanofdoom_layer",
    compression = "gzip",
    tars = [
        ":configure_lanofdoom_layer/lanofdoom.tar",
    ],
)

#
# Build Final Image
#

download_pkgs(
    name = "plugin_deps",
    image_tar = ":server_with_i386_packages.tar",
    packages = [
        "ca-certificates:i386",
        "libcurl4:i386",
    ],
)

install_pkgs(
    name = "server_with_plugin_deps_image",
    image_tar = ":server_with_i386_packages.tar",
    installables_tar = ":plugin_deps.tar",
    installation_cleanup_commands = "rm -rf /var/lib/apt/lists/*",
    output_image_name = "server_with_plugin_deps_image",
)

container_image(
    name = "server_image",
    compression = "gzip",
    user = "nobody",
    entrypoint = ["/opt/game/entrypoint.sh"],
    env = {
        "CSS_ADMIN": "",
        "CSS_HOSTNAME": "",
        "CSS_MOTD": "",
        "CSS_PASSWORD": "",
        "RCON_PASSWORD": "",
        "STEAM_GROUP_ID": "",
        "STEAM_API_KEY": "",
    },
    layers = [
        ":lanofdoom_layer",
        ":maps_layer",
        ":sourcemod_layer",
    ],
    base = ":server_with_plugin_deps_image",
)

container_push(
   name = "push_server_image",
   image = ":server_image",
   format = "Docker",
   registry = "ghcr.io",
   repository = "lanofdoom/counterstrikesource-server/counterstrikesource-server",
   tag = "latest",
)