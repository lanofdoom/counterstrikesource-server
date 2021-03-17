load("@io_bazel_rules_docker//container:container.bzl", "container_image", "container_layer", "container_push")
load("@io_bazel_rules_docker//docker/package_managers:download_pkgs.bzl", "download_pkgs")
load("@io_bazel_rules_docker//docker/package_managers:install_pkgs.bzl", "install_pkgs")
load("@io_bazel_rules_docker//docker/util:run.bzl", "container_run_and_commit", "container_run_and_extract")

#
# Build Maps Layer
#

container_image(
    name = "maps_container",
    directory = "/opt/game/cstrike",
    tars = [
        "@maps//file",
    ],
    base = "@ubuntu//image",
)

container_run_and_extract(
    name = "maps",
    extract_file = "/archive.tar.gz",
    commands = [
        "cd /opt/game/cstrike",
        "./make_bz2_files.sh",
        "rm *.sh *.md *license",
        "chown -R nobody:root /opt",
        "tar -czvf /archive.tar.gz /opt",
    ],
    image = ":maps_container.tar",
)

#
# Build Sourcemod Layer
#

container_image(
    name = "sourcemod_container",
    directory = "/opt/game/cstrike",
    tars = [
        "@metamod//file",
        "@sourcemod//file",
    ],
    base = "@ubuntu//image",
)

container_run_and_extract(
    name = "sourcemod",
    extract_file = "/archive.tar.gz",
    commands = [
        "cd /opt/game/cstrike/addons/sourcemod/plugins",
        "mv basevotes.smx disabled/basevotes.smx",
        "mv funcommands.smx disabled/funcommands.smx",
        "mv funvotes.smx disabled/funvotes.smx",
        "mv playercommands.smx disabled/playercommands.smx",
        "mv disabled/mapchooser.smx mapchooser.smx",
        "mv disabled/rockthevote.smx rockthevote.smx",
        "mv disabled/nominations.smx nominations.smx",
        "chown -R nobody:root /opt",
        "tar -czvf /archive.tar.gz /opt",
    ],
    image = ":sourcemod_container.tar",
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
    name = "lanofdoom",
    extract_file = "/archive.tar.gz",
    commands = [
        "chown -R nobody:root /opt",
        "tar -czvf /archive.tar.gz /opt",
    ],
    image = ":config_container.tar",
)

#
# Build Final Image
#

container_image(
    name = "server_base_with_no_entrypoint",
    user = "root",
    entrypoint = [],
    base = "@server_base//image",
)

download_pkgs(
    name = "plugin_deps",
    image_tar = ":server_base_with_no_entrypoint.tar",
    packages = [
        "ca-certificates:i386",
        "libcurl4:i386",
    ],
)

install_pkgs(
    name = "server_with_plugin_deps_image",
    image_tar = ":server_base_with_no_entrypoint.tar",
    installables_tar = ":plugin_deps.tar",
    installation_cleanup_commands = "rm -rf /var/lib/apt/lists/*",
    output_image_name = "server_with_plugin_deps_image",
)

container_image(
    name = "server_image",
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
    tars = [
        ":lanofdoom/archive.tar.gz",
        ":maps/archive.tar.gz",
        ":sourcemod/archive.tar.gz",
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