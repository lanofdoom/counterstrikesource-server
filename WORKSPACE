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
# Steam Dependencies
#

http_archive(
    name = "com_github_lanofdoom_steamcmd",
    sha256 = "",
    strip_prefix = "steamcmd-145893649026af482aca342fcd23b1af70622ed7",
    urls = ["https://github.com/lanofdoom/steamcmd/archive/145893649026af482aca342fcd23b1af70622ed7.zip"],
)

load("@com_github_lanofdoom_steamcmd//:repositories.bzl", "steamcmd_repos")

steamcmd_repos()

load("@com_github_lanofdoom_steamcmd//:deps.bzl", "steamcmd_deps")

steamcmd_deps()

load("@com_github_lanofdoom_steamcmd//:nugets.bzl", "steamcmd_nugets")

steamcmd_nugets()

#
# Server Dependencies
#

http_file(
    name = "auth_by_steam_group",
    downloaded_file_path = "auth_by_steam_group.tar.gz",
    sha256 = "2b912b1df5331cf58868df283fdcf3e226b7a50e0a2170f7fd0d0581b18b1fdc",
    urls = ["https://lanofdoom.github.io/auth-by-steam-group/releases/v2.2.0/auth_by_steam_group.tar.gz"],
)

http_file(
    name = "disable_buyzones",
    downloaded_file_path = "disable_buyzones.tar.gz",
    sha256 = "20a376c6e1acc54f646fa9f551f130e1cd18e8d4b2183e9ba21acabb88c38721",
    urls = ["https://lanofdoom.github.io/counterstrikesource-disable-buyzones/releases/v1.0.0/lan_of_doom_disable_buyzones.tar.gz"],
)

http_file(
    name = "disable_radar",
    downloaded_file_path = "disable_radar.tar.gz",
    sha256 = "2e84c3d37e8f44a9e562d4d94d43459c1c41c43ec776542a4cc7558a0487b6b8",
    urls = ["https://lanofdoom.github.io/counterstrikesource-disable-radar/releases/v1.0.0/lan_of_doom_disable_radar.tar.gz"],
)

http_file(
    name = "disable_round_timer",
    downloaded_file_path = "disable_round_timer.tar.gz",
    sha256 = "9655ab21ac776ce87f2e8540fbe520a7ed093ecf8cb51fb99a081d8284eabb03",
    urls = ["https://lanofdoom.github.io/counterstrikesource-disable-round-timer/releases/v1.0.1/lan_of_doom_disable_round_timer.tar.gz"],
)

http_file(
    name = "ffa_spawns",
    downloaded_file_path = "ffa_spawns.tar.gz",
    sha256 = "1e6493251bc9f5fe21e7e6f182f50ad5d7e25b95ee2040902d99adc6e2ac45cc",
    urls = ["https://lanofdoom.github.io/counterstrikesource-ffa-spawns/releases/v1.0.0/lan_of_doom_ffa_spawns.tar.gz"],
)

http_file(
    name = "free_for_all",
    downloaded_file_path = "free_for_all.tar.gz",
    sha256 = "22f9f842d6a47af06b769368b46478b6a96e9624e3d06cfb41c3d0786752a4b0",
    urls = ["https://lanofdoom.github.io/counterstrikesource-free-for-all/releases/v1.0.0/lan_of_doom_ffa.tar.gz"],
)

http_file(
    name = "gungame",
    downloaded_file_path = "lan_of_doom_gungame.tar.gz",
    sha256 = "6d58de8f681424b2b70b2c896912087a2fe84901a6026cea86fa27948dcdda11",
    urls = ["https://lanofdoom.github.io/counterstrikesource-gungame/releases/v1.0.2/lan_of_doom_gungame.tar.gz"],
)

http_file(
    name = "maps",
    downloaded_file_path = "maps.tar.xz",
    sha256 = "3bd4cd6c3b896371a4d961e6141790ca215617d0f0151707c5b1e75328f5efdd",
    urls = ["https://lanofdoom.github.io/counterstrikesource-maps/releases/v6.0.1/maps.tar.xz"],
)

http_file(
    name = "maps_bz2",
    downloaded_file_path = "maps_bz2.tar.xz",
    sha256 = "4ebf348125ebe472ab2acc5823487fa240a537264fbe92f91ad33aa16700f97e",
    urls = ["https://lanofdoom.github.io/counterstrikesource-maps/releases/v6.0.1/maps_bz2.tar.xz"],
)

http_file(
    name = "map_settings",
    downloaded_file_path = "map_settings.tar.gz",
    sha256 = "61ff32d090f63f2dc599796f0f7d0542540d76d2a46595447b0555cd9b4f4239",
    urls = ["https://lanofdoom.github.io/counterstrikesource-map-settings/releases/v1.4.0/lan_of_doom_map_settings.tar.gz"],
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
    name = "paintball",
    downloaded_file_path = "paintball.tar.gz",
    sha256 = "5d83d570c62fcb21525845d77abd9e3d044d3d45faf120874b11a71430534a87",
    urls = ["https://lanofdoom.github.io/counterstrikesource-paintball/releases/v0.8.0/lan_of_doom_paintball.tar.gz"],
)

http_file(
    name = "remove_objectives",
    downloaded_file_path = "respawn.tar.gz",
    sha256 = "5f6c84e6b4e5da1f07d256edef1ec7ad8a1db92247c12e74d6d22d6fd1186254",
    urls = ["https://lanofdoom.github.io/counterstrikesource-remove-objectives/releases/v1.0.0/lan_of_doom_remove_objectives.tar.gz"],
)

http_file(
    name = "respawn",
    downloaded_file_path = "respawn.tar.gz",
    sha256 = "194b158a9b9cdbd790021ceec1f5d5ece3edd5a1cee34e76d5e198abc93ab797",
    urls = ["https://lanofdoom.github.io/counterstrikesource-respawn/releases/v1.0.0/lan_of_doom_respawn.tar.gz"],
)

http_file(
    name = "spawn_protection",
    downloaded_file_path = "spawn_protection.tar.gz",
    sha256 = "ae1a845ccd579832f7a3af44c9821957d01816cedbcdf7a8cb26c4e16f3ed5f5",
    urls = ["https://lanofdoom.github.io/counterstrikesource-spawn-protection/releases/v1.0.0/lan_of_doom_spawn_protection.tar.gz"],
)

http_file(
    name = "sourcemod",
    downloaded_file_path = "sourcemod.tar.gz",
    sha256 = "9f59ddf32a649695e4c7dac0dfebdc382590486e60ff6473d7b87a31b6bfa01b",
    urls = ["https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6529-linux.tar.gz"],
)

#
# Container Base Image
#

container_pull(
    name = "base_image",
    registry = "index.docker.io",
    repository = "i386/debian",
    tag = "bullseye-slim",
)