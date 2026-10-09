# name-lab

A playground for animated 3D type: real extruded letters built from a font's outlines
with three.js and opentype.js, with physics-style animation and a live control panel.
It is used to design the 3D name for the next [sebk.no](https://sebk.no).

Try it live at **[namelab.sebk.no](https://namelab.sebk.no)**.

- **Treatments:** solid extrusion, molecular (atoms along the outlines, bonds between
  them), terminal cells (letters made of extruded blocks).
- **Animations:** shockwave, tumble drop, type & pop, assemble. Each is seeded, with
  controls for chaos, springiness, settle pose, idle drift and time scale.
- **Interaction:** letters get pushed when the cursor touches them, and the whole name
  tilts with the mouse.
- **Look:** palettes, materials (matte, gloss, chrome, glass, glow), background,
  bloom, grain, vignette, camera.
- **Context:** mock "hero" and "finale" screens, and heading/body/mono font pairing.
- **Copy settings:** exports the current settings as JSON.

`fonts.html` is a simpler 2D specimen page for comparing fonts.

## Running it

```sh
scripts/fetch-fonts.sh          # downloads the fonts into fonts/ (not committed)
python -m http.server 8765      # opentype.js needs to fetch the fonts over http
```

Open <http://localhost:8765>.

Keys: `Space` replays, `R` rerolls the seed, `↑`/`↓` switch font.
Add `?at=4` to the URL to fast-forward the animation by 4 seconds (useful for
screenshots); any setting can also be passed as a URL parameter, e.g. `?font=excon`.
Settings are saved in localStorage; "reset everything" clears them.

## Deploy (server)

```sh
git clone https://github.com/sebkaul/name-lab.git
cd name-lab
scripts/deploy.sh                          # publishes to /srv/http/namelab
WEBROOT=/var/www/namelab scripts/deploy.sh # or somewhere else
```

Needs `git`, `curl` and `rsync`. `deploy.sh` pulls the latest commit, runs
`fetch-fonts.sh`, stages `index.html`, `fonts.html` and `fonts/`, and only then syncs
them to the web root. nginx config: [`nginx/namelab.sebk.no.conf`](nginx/namelab.sebk.no.conf).

## Fonts

The fonts come from [Fontshare](https://www.fontshare.com) (ITF Free Font License) and
[Google Fonts](https://fonts.google.com) (SIL OFL). They are downloaded by the script and not
redistributed in this repository.

## Licence

The code is under the [MIT licence](LICENSE). The fonts are not: each keeps its own licence
(ITF Free Font License or SIL OFL, see above).
