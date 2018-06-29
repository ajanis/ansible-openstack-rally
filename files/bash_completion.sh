#!/bin/bash

# Standalone _filedir() alternative.
# This exempts from dependence of bash completion routines
function _rally_filedir()
{
    test "${1}" \
        && COMPREPLY=( \
            $(compgen -f -- "${cur}" | grep -E "${1}") \
            $(compgen -o plusdirs -- "${cur}") ) \
        || COMPREPLY=( \
            $(compgen -o plusdirs -f -- "${cur}") \
            $(compgen -d -- "${cur}") )
}

_rally()
{
    declare -A SUBCOMMANDS
    declare -A OPTS

    OPTS["db_create"]=""
    OPTS["db_ensure"]=""
    OPTS["db_recreate"]=""
    OPTS["db_revision"]=""
    OPTS["db_show"]="--creds"
    OPTS["db_upgrade"]=""
    OPTS["deployment_check"]="--deployment"
    OPTS["deployment_config"]="--deployment"
    OPTS["deployment_create"]="--name --fromenv --filename --no-use"
    OPTS["deployment_destroy"]="--deployment"
    OPTS["deployment_list"]=""
    OPTS["deployment_recreate"]="--filename --deployment"
    OPTS["deployment_show"]="--deployment"
    OPTS["deployment_use"]="--deployment"
    OPTS["env_check"]="--env --json --detailed"
    OPTS["env_create"]="--name --description --extras --spec --json --no-use"
    OPTS["env_delete"]="--env --force"
    OPTS["env_destroy"]="--env --skip-cleanup --json --detailed"
    OPTS["env_info"]="--env --json"
    OPTS["env_list"]="--json"
    OPTS["env_show"]="--env --json"
    OPTS["env_use"]="--env --json"
    OPTS["plugin_list"]="--name --platform --plugin-base"
    OPTS["plugin_show"]="--name --platform"
    OPTS["task_abort"]="--uuid --soft"
    OPTS["task_delete"]="--force --uuid"
    OPTS["task_detailed"]="--uuid --iterations-data"
    OPTS["task_export"]="--uuid --type --to"
    OPTS["task_import"]="--file --deployment --tag"
    OPTS["task_list"]="--deployment --all-deployments --status --tag --uuids-only"
    OPTS["task_report"]="--out --open --html --html-static --json --uuid"
    OPTS["task_results"]="--uuid"
    OPTS["task_sla-check"]="--uuid --json"
    OPTS["task_sla_check"]="--uuid --json"
    OPTS["task_start"]="--deployment --task --task-args --task-args-file --tag --no-use --abort-on-sla-failure"
    OPTS["task_status"]="--uuid"
    OPTS["task_trends"]="--out --open --tasks"
    OPTS["task_use"]="--uuid"
    OPTS["task_validate"]="--deployment --task --task-args --task-args-file"
    OPTS["verify_add-verifier-ext"]="--id --source --version --extra-settings"
    OPTS["verify_configure-verifier"]="--id --deployment-id --reconfigure --extend --override --show"
    OPTS["verify_create-verifier"]="--name --type --platform --source --version --system-wide --extra-settings --no-use"
    OPTS["verify_delete"]="--uuid"
    OPTS["verify_delete-verifier"]="--id --deployment-id --force"
    OPTS["verify_delete-verifier-ext"]="--id --name"
    OPTS["verify_import"]="--id --deployment-id --file --run-args --no-use"
    OPTS["verify_list"]="--id --deployment-id --tag --status"
    OPTS["verify_list-plugins"]="--platform"
    OPTS["verify_list-verifier-exts"]="--id"
    OPTS["verify_list-verifier-tests"]="--id --pattern"
    OPTS["verify_list-verifiers"]="--status"
    OPTS["verify_report"]="--uuid --type --to --open"
    OPTS["verify_rerun"]="--uuid --deployment-id --failed --tag --concurrency --detailed --no-use"
    OPTS["verify_show"]="--uuid --sort-by --detailed"
    OPTS["verify_show-verifier"]="--id"
    OPTS["verify_start"]="--id --deployment-id --tag --pattern --concurrency --load-list --skip-list --xfail-list --detailed --no-use"
    OPTS["verify_update-verifier"]="--id --update-venv --version --system-wide --no-system-wide"
    OPTS["verify_use"]="--uuid"
    OPTS["verify_use-verifier"]="--id"

    for OPT in ${!OPTS[*]} ; do
        CMD=${OPT%%_*}
        CMDSUB=${OPT#*_}
        SUBCOMMANDS[${CMD}]+="${CMDSUB} "
    done

    COMMANDS="${!SUBCOMMANDS[*]}"
    COMPREPLY=()

    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"

    if [[ $cur =~ ^(\.|\~|\/) ]] || [[ $prev =~ ^--out(|put-file)$ ]] ; then
        _rally_filedir
    elif [[ $prev =~ ^--(task|filename)$ ]] ; then
        _rally_filedir "\.json|\.yaml|\.yml"
    elif [ $COMP_CWORD == "1" ] ; then
        COMPREPLY=($(compgen -W "$COMMANDS" -- ${cur}))
    elif [ $COMP_CWORD == "2" ] ; then
        COMPREPLY=($(compgen -W "${SUBCOMMANDS[${prev}]}" -- ${cur}))
    else
        COMMAND="${COMP_WORDS[1]}_${COMP_WORDS[2]}"
        COMPREPLY=($(compgen -W "${OPTS[$COMMAND]}" -- ${cur}))
    fi
    return 0
}

complete -o filenames -F _rally rally