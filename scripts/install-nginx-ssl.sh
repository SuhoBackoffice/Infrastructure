#!/bin/bash

# Nginx & Certbot 설치
apt-get update -y
apt-get install -y nginx certbot python3-certbot-nginx

# 공통 프록시 헤더(중복 제거용)
cat >/etc/nginx/proxy-common.conf <<'CONF'
proxy_http_version 1.1;
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto $scheme;
# WebSocket/HMR 대응(Next.js 등)
proxy_set_header Upgrade $http_upgrade;
proxy_set_header Connection "upgrade";
client_max_body_size 20m;
CONF

# 기본 서버 블록 구성
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
cat >/etc/nginx/sites-available/default <<'EOT'
# Redirect (suhotech.co.kr -> www.suhotech.co.kr)
server {
    listen 80;
    server_name suhotech.co.kr;
    # $request_uri 변수는 사용자가 요청한 경로와 파라미터를 그대로 유지해줍니다.
    # 예: suhotech.co.kr/about?id=1 -> www.suhotech.co.kr/about?id=1
    return 301 https://www.suhotech.co.kr$request_uri;
}

# Front (Next.js :3000)
server {
    listen 80;
    server_name www.suhotech.co.kr;

    location /_next/ {
        proxy_pass http://127.0.0.1:3000;
        include /etc/nginx/proxy-common.conf;
    }

    location / {
        proxy_pass http://127.0.0.1:3000;
        include /etc/nginx/proxy-common.conf;
    }
}

# API (Spring :8080)
server {
    listen 80;
    server_name api.suhotech.co.kr;

    location / {
        proxy_pass http://127.0.0.1:8080;
        include /etc/nginx/proxy-common.conf;
    }
}
EOT

# Nginx 설정 테스트 및 리로드
nginx -t && systemctl reload nginx

# Certbot - 세 도메인 모두 인증서 발급 + HTTP->HTTPS 리다이렉트 자동 설정
while true; do
  certbot --nginx \
    -d suhotech.co.kr \
    -d www.suhotech.co.kr \
    -d api.suhotech.co.kr \
    --non-interactive --agree-tos --redirect -m ksu9801@gmail.com && break

  echo "Certbot 실패, 5분 후 재시도..."
  sleep 300
done

# 리다이렉트를 308으로 바꾸고 싶다면(선택)
# certbot이 추가한 파일(보통 같은 default 파일)에 return 301이 생긴 뒤에야 의미 있음.
sed -i 's/return 301 /return 308 /g' /etc/nginx/sites-available/default
nginx -t && systemctl reload nginx