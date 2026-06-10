# 패치된 code-push-server (Cloudflare R2 지원)를 "로컬 소스"로 직접 빌드한다.
# lisong 기본 Dockerfile은 npm 배포 패키지를 설치해 패치가 무시되므로, 이 파일로 빌드해야 함.
# 네이티브 모듈 없음(bcryptjs/mysql2 모두 순수 JS) → 빌드 툴 불필요.
#
# ⚠️ node:8.17.0-alpine 풀이 안 되면 node:10-alpine 로 바꿔도 동작(engines >= 6, 순수 JS deps).
FROM node:8.17.0-alpine

WORKDIR /code-push-server

# 1) 의존성 먼저 설치 (레이어 캐시). 원본 이미지와 동일하게 --no-optional.
COPY package.json package-lock.json ./
RUN npm install --production --no-optional

# 2) 패치된 소스 복사 (.dockerignore 가 node_modules/.git 제외)
COPY . .

ENV NODE_ENV=production
EXPOSE 3000

# bin/www 가 PORT(기본 3000)로 listen
CMD ["node", "./bin/www"]
