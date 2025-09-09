#!/bin/bash
set -e

export RDBMS_ROOT_PASSWORD="${rdbms_root_password}"
export RDBMS_USERNAME="${rdbms_username}"
export RDBMS_PASSWORD="${rdbms_password}"
export RDBMS_PORT="${rdbms_port}"
export MYSQL_QUERY_LOG_PATH="${mysql_query_log_path}"

${install_docker}
${install_git}
${install_nginx}
${install_mysql}
