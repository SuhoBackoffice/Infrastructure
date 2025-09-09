#!/bin/bash

set -e
set -u

echo "[INFO] MySQL Docker 환경 설정 시작"

mkdir -p /home/ubuntu/slowlogs
chown -R ubuntu:ubuntu /home/ubuntu/slowlogs

PROJECT_DIR="/home/ubuntu/server"
if [ ! -d "$PROJECT_DIR" ]; then
  echo "[INFO] Git 저장소 클론 중..."
  git clone https://github.com/SuhoBackoffice/Backend.git "$PROJECT_DIR"
fi

cd "$PROJECT_DIR"
git pull origin main

# .env 파일 생성
cat <<EOF > "$PROJECT_DIR/docker/db/.env"
RDBMS_ROOT_PASSWORD=$RDBMS_ROOT_PASSWORD
RDBMS_USERNAME=$RDBMS_USERNAME
RDBMS_PASSWORD=$RDBMS_PASSWORD
RDBMS_PORT=$RDBMS_PORT
MYSQL_QUERY_LOG_PATH=$MYSQL_QUERY_LOG_PATH
EOF

echo "[INFO] .env 파일 생성 완료"

cd "$PROJECT_DIR/docker/db"
docker-compose -f db-docker-compose.yml up -d

echo "[SUCCESS] MySQL Docker 컨테이너가 성공적으로 실행되었습니다"
