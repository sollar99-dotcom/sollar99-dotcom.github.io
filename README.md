# myhome

Sollar 개인 홈페이지. → https://sollar99-dotcom.github.io/myhome/

## 고치는 법

파일은 `index.html` **하나뿐**입니다. CSS·JS·이미지가 전부 그 안에 들어 있습니다.

1. `index.html`을 연다 (더블클릭하면 브라우저에서 바로 미리보기가 된다)
2. 고친다
3. `git add -A && git commit -m "수정" && git push` → 1~2분 뒤 반영

## 글 추가하는 법

1. 맨 아래 `<!-- 글 전문 -->` 블록에 `<article id="src-p6" data-date="…" data-tags="…">` 를 하나 복사해서 추가
2. `기록` 섹션에 `<button class="post" data-post="p6">` 카드를 하나 복사해서 추가
3. 끝. 모달은 `data-post` 와 `id="src-…"` 를 짝지어 자동으로 연결된다

LinkedIn 원문 링크를 붙이고 싶으면 `<article>` 에 `data-src="글 주소"` 를 추가하면
모달 하단에 "LinkedIn에서 보기" 버튼이 자동으로 나타난다.

## 폴더

- `index.html` — 페이지 전부
- `assets/` — 이미지 원본 보관 (배포에 직접 쓰이지 않음, `og.png` 만 예외)
- `.nojekyll` — GitHub Pages 의 Jekyll 빌드를 건너뛴다
