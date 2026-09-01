# sollar99-dotcom.github.io

Sollar 개인 홈페이지. → https://sollar99-dotcom.github.io

## 고치는 법

파일은 `index.html` **하나뿐**입니다. CSS·JS·이미지가 전부 그 안에 들어 있습니다.

1. `index.html` 을 연다 (더블클릭하면 브라우저에서 바로 미리보기가 된다)
2. 고친다
3. `git add -A && git commit -m "수정" && git push` → 1~2분 뒤 반영

## 글 추가하는 법

1. 맨 아래 `<!-- 글 전문 -->` 블록에 `<article id="src-p6" data-date="…" data-tags="…">` 를 하나 복사해 추가
2. `기록` 섹션에 `<button class="row" data-post="p6">` 행을 하나 복사해 추가
3. 끝. `data-post` 와 `id="src-…"` 를 짝지어 모달이 자동 연결된다

LinkedIn 원문 링크를 붙이려면 `<article>` 에 `data-src="글 주소"` 를 추가한다.
그러면 모달 하단에 "LinkedIn에서 보기" 버튼이 자동으로 나타난다.

## 사진 바꾸는 법

스크립트가 리사이즈 · base64 변환 · 삽입을 한 번에 한다.

```
tools/set-photo.sh portrait ~/Desktop/헤드샷.jpg   # 히어로 오른쪽 인물 사진
tools/set-photo.sh plate    ~/Desktop/풍경.jpg     # 전면 가로 사진
```

`portrait` 는 정사각 중앙 크롭 후 640px, `plate` 는 900px 로 줄인다.
원본은 `assets/` 에 자동 보관된다. 몇 번을 다시 돌려도 안전하다.

## 폴더

- `index.html` — 페이지 전부
- `assets/` — 이미지 원본 보관 (`og.png` 만 예외적으로 직접 참조)
- `.nojekyll` — GitHub Pages 의 Jekyll 빌드를 건너뛴다
