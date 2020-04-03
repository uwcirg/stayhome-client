#!/bin/sh
set -eu

repo_path="$(cd "$(dirname "$0")" && pwd)"
cmdname="$(basename "$0")"

usage() {
    cat << USAGE >&2
Usage:
    $cmdname command

    Docker entrypoint script
    Wrapper script that executes docker-related tasks before running given command

USAGE
    exit 1
}


upsert_yaml_setting() {
    # update a setting in given flat YAML file
    local settings_file="$1"
    local setting_name="$2"
    local setting_value="$3"

    # append and exit if not present
    if ! grep --quiet "$setting_name" "$settings_file"; then
        echo "${setting_name}: ${setting_value}" >> "$settings_file"
        return
    fi

    # workaround to "resource is busy"
    cp "$settings_file" "$settings_file".bak

    sed \
        --in-place "$settings_file".bak \
        --expression '/^'$setting_name'/ s|:.*$|: '"$setting_value"'|'

    cp -f "$settings_file".bak "$settings_file"
}


write_env_to_yaml() {
    # write project-specific environment variables to app config file
    local yaml_file="$1"
    # only process environment variables starting with project name
    printenv | cut --delimiter = --fields 1 | grep '^MAPAPP_' | while read envvar_name; do
        local config_name="$(echo $envvar_name | awk -F 'MAPAPP_' '{print $NF}')"
        local config_value="$(printenv "$envvar_name")"

        upsert_yaml_setting "$yaml_file" "$config_name" "$config_value"
    done
}

write_env_to_yaml /usr/share/nginx/html/assets/assets/cfg/app_settings.yaml



echo entrypoint script complete
echo executing given command $@
exec "$@"
