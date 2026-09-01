#!/usr/bin/env bash
# 레포 이름을 정하고 푸시한다. URL 메타태그도 자동으로 맞춘다.
#   tools/push.sh sollar99-dotcom.github.io   → https://sollar99-dotcom.github.io
#   tools/push.sh myhome                      → https://sollar99-dotcom.github.io/myhome/
set -euo pipefail

REPO="${1:-}"
[ -n "$REPO" ] || { echo "사용법: tools/push.sh <레포이름>"; exit 1; }
ROOT="$(cd "$(dirname "$0")/.." && pwd)"; cd "$ROOT"

if [ "$REPO" = "sollar99-dotcom.github.io" ]; then
  BASE="https://sollar99-dotcom.github.io/"
else
  BASE="https://sollar99-dotcom.github.io/$REPO/"
fi

BASE="$BASE" python3 - index.html <<'PY'
import os, re, sys
base = os.environ['BASE']
p = sys.argv[1]
h = open(p, encoding='utf-8').read()
h = re.sub(r'https://sollar99-dotcom\.github\.io/(?:[\w.-]+/)?', base, h)
open(p, 'w', encoding='utf-8').write(h)
print('URL 을 %s 로 맞췄습니다' % base)
PY

git add -A
git diff --cached --quiet || git commit -q -m "배포 주소를 $BASE 로 설정"
git remote set-url origin "https://github.com/sollar99-dotcom/$REPO.git" 2>/dev/null \
  || git remote add origin "https://github.com/sollar99-dotcom/$REPO.git"
git push -u origin main
echo
echo "완료. 1~2분 뒤 $BASE 에서 열립니다."
echo "안 열리면 GitHub 레포 > Settings > Pages 에서 Source 를 'main' / '/ (root)' 로 지정하세요."
