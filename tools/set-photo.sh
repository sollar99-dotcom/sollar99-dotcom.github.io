#!/usr/bin/env bash
# 사진을 index.html 안에 base64 로 심는다.
#   사용법: tools/set-photo.sh portrait ~/Desktop/헤드샷.jpg
#           tools/set-photo.sh plate    ~/Desktop/사막.jpg
# portrait = 히어로 오른쪽 인물 사진 (정사각으로 잘라 640px)
# plate    = 전면 가로 사진 (900px)
set -euo pipefail

SLOT="${1:-}"; SRC="${2:-}"
[ -f "$SRC" ] || { echo "파일을 찾을 수 없습니다: $SRC"; exit 1; }
case "$SLOT" in portrait|plate) ;; *) echo "첫 인자는 portrait 또는 plate"; exit 1;; esac

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
WORK="$TMP/w.jpg"; cp "$SRC" "$WORK"

if [ "$SLOT" = portrait ]; then
  # 정사각 중앙 크롭 후 640px
  D=$(sips -g pixelWidth -g pixelHeight "$WORK" | awk '/pixel/{print $2}' | sort -n | head -1)
  sips -c "$D" "$D" "$WORK" >/dev/null
  sips -Z 640 -s format jpeg -s formatOptions 62 "$WORK" >/dev/null
else
  sips -Z 900 -s format jpeg -s formatOptions 55 "$WORK" >/dev/null
fi

cp "$WORK" "$ROOT/assets/$SLOT.jpg"
base64 -i "$WORK" | tr -d '\n' > "$TMP/b64"

SLOT="$SLOT" B64="$TMP/b64" python3 - "$ROOT/index.html" <<'PY'
import os, re, sys
path = sys.argv[1]
slot = os.environ['SLOT']
b64  = open(os.environ['B64']).read()
uri  = 'data:image/jpeg;base64,' + b64
h = open(path, encoding='utf-8').read()

if slot == 'portrait':
    img = ('<img src="%s" alt="Sollar 프로필 사진" width="640" height="640" />' % uri)
    # 자리표시자든 기존 사진이든 모두 교체
    pat = re.compile(r'(<div class="portrait-frame">\s*)'
                     r'(?:<!--.*?-->\s*)?'
                     r'(?:<div class="portrait-fallback">.*?</div>|<img\b[^>]*?/>)',
                     re.S)
    h, n = pat.subn(lambda m: m.group(1) + img, h, count=1)
else:
    img = ('<img class="plate-img" src="%s" alt="사막의 바위 아치 아래에 서 있는 모습" '
           'width="900" height="1200" />' % uri)
    pat = re.compile(r'<img class="plate-img"[^>]*?/>', re.S)
    h, n = pat.subn(img, h, count=1)

if not n:
    sys.exit('교체할 자리를 찾지 못했습니다 (%s)' % slot)
open(path, 'w', encoding='utf-8').write(h)
print('%s 자리에 사진을 넣었습니다 → %s' % (slot, path))
PY

echo "index.html 크기: $(wc -c < "$ROOT/index.html") bytes"
