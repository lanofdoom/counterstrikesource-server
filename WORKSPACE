load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")

http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "59536e6ae64359b716ba9c46c39183403b01eabfbd57578e84398b4829ca499a",
    strip_prefix = "rules_docker-0.22.0",
    urls = ["https://github.com/bazelbuild/rules_docker/releases/download/v0.22.0/rules_docker-v0.22.0.tar.gz"],
)

load(
    "@io_bazel_rules_docker//repositories:repositories.bzl",
    container_repositories = "repositories",
)

container_repositories()

load("@io_bazel_rules_docker//repositories:deps.bzl", container_deps = "deps")

container_deps()

load("@io_bazel_rules_docker//container:container.bzl", "container_pull")

#
# Container Base Image
#

container_pull(
    name = "container_base",
    registry = "index.docker.io",
    repository = "library/debian",
    tag = "bullseye",
)

#
# Server Dependencies
#

http_file(
    name = "auth_by_steam_group",
    downloaded_file_path = "auth_by_steam_group.tar.gz",
    sha256 = "34c8c51ca45a59ce18ca2c9c9a7471d03dc173ec9bdb78b4ee99edb08995317a",
    urls = ["https://lanofdoom.github.io/auth-by-steam-group/releases/v2.1.3/auth_by_steam_group.tar.gz"],
)

http_file(
    name = "deathmatch",
    downloaded_file_path = "lan_of_doom_deathmatch.tar.gz",
    sha256 = "0f58994ce6c24f63126cec7ea7fddc46731907c93635042dc4942be2aedc0f8e",
    urls = ["https://lanofdoom.github.io/counterstrike-deathmatch/releases/v1.0.1/lan_of_doom_deathmatch.tar.gz"],
)

http_file(
    name = "gungame",
    downloaded_file_path = "lan_of_doom_gungame.tar.gz",
    sha256 = "c8b5dd25f839fcc991a12c1c3957f6632589ad088bc1a25fcaf329edd4c24fa1",
    urls = ["https://lanofdoom.github.io/counterstrike-gungame/releases/v1.0.1/lan_of_doom_gungame.tar.gz"],
)

http_file(
    name = "maps",
    downloaded_file_path = "maps.tar.xz",
    sha256 = "aca6ae5736e63c1b18b119216d75904cf71b7728af26f5f4e8729a0091ac40ad",
    urls = ["https://lanofdoom.github.io/counterstrikesource-maps/releases/v4.0.0/maps.tar.xz"],
)

http_file(
    name = "map_settings",
    downloaded_file_path = "map_settings.tar.gz",
    sha256 = "b205d457a36d24c44c7f87c9c9d63b9812c9a156e837c675ee55fab09b79a472",
    urls = ["https://lanofdoom.github.io/counterstrikesource-map-settings/releases/v1.2.0/lan_of_doom_map_settings.tar.gz"],
)

http_file(
    name = "max_cash",
    downloaded_file_path = "max_cash.tar.gz",
    sha256 = "98a9f6fec86928e29ce9dd4eff715a69efb9adbc75df26f2b2ccae7b3bc387ae",
    urls = ["https://lanofdoom.github.io/counterstrikesource-max-cash/releases/v1.0.1/max_cash.tar.gz"],
)

http_file(
    name = "metamod",
    downloaded_file_path = "metamod.tar.gz",
    sha256 = "b7fc903755bb3f273afd797b36e94844b828e721d291d2a7519eecad3fa8486c",
    urls = ["https://mms.alliedmods.net/mmsdrop/1.11/mmsource-1.11.0-git1145-linux.tar.gz"],
)

http_file(
    name = "sourcemod",
    downloaded_file_path = "sourcemod.tar.gz",
    sha256 = "da1fa6c77f3268b6eb8bbdb97e9bf1d03f4084b3f0d1933e195752b44332d3b0",
    urls = ["https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6528-linux.tar.gz"],
)
