#!/usr/bin/env bash
# Downloads the candidate fonts as TTF into fonts/ for index.html.
# The fonts are not committed (see .gitignore); rerun this after a fresh clone.
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p fonts

fontshare=(telma@700 tanker@400 excon@900 alpino@900 technor@900 boxing@400 kola@400
  nippo@700 stardom@400 melodrama@700 bespoke-stencil@800 aktura@400 array@700 neco@900
  clash-grotesk@700 boska@900 zodiak@401
  satoshi@500 general-sans@500 switzer@400 gambetta@401 sentient@401 erode@401)
google=("Syne:wght@800" "Climate+Crisis" "Bowlby+One" "Dela+Gothic+One" "Rubik+Mono+One"
  "Monoton" "Bungee" "Tilt+Warp" "Orbitron:wght@900" "Michroma" "Major+Mono+Display"
  "Big+Shoulders+Display:wght@900" "Unbounded:wght@900" "Bagel+Fat+One"
  "Instrument+Serif:ital@1" "Fraunces:ital,wght@1,400" "Newsreader:ital@1")

for f in "${fontshare[@]}"; do
  out="fonts/${f%@*}.ttf"
  [[ -s $out ]] && continue
  url=$(curl -fsS -A "Mozilla/5.0 Firefox/130.0" "https://api.fontshare.com/v2/css?f[]=$f" \
    | grep -o "url('[^']*\.ttf')" | head -1 | sed "s/url('//; s/')//" || true)
  if [[ -z $url ]]; then echo "skip $f (no TTF)"; continue; fi
  curl -fsS "https:$url" -o "$out" && echo "ok  $out"
done

for f in "${google[@]}"; do
  name=${f%%:*}
  out="fonts/$(tr '+A-Z' '-a-z' <<<"$name").ttf"
  [[ -s $out ]] && continue
  # Without a browser User-Agent, Google Fonts serves TTF, which opentype.js can parse.
  url=$(curl -fsS "https://fonts.googleapis.com/css2?family=$f" \
    | grep -o 'url([^)]*\.ttf)' | head -1 | sed 's/url(//; s/)//' || true)
  if [[ -z $url ]]; then echo "skip $f (no TTF)"; continue; fi
  curl -fsS "$url" -o "$out" && echo "ok  $out"
done
