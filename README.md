<p align=center><img src=logo.png /></p>

---

<!--
  You may rightfully ask: What the fuck, Mr. Anderson.
  Well. You know that zebra-striping? I don't want it.
  Also, I want rowspan. Thus was born the HTML table.
  To recap: "<tr></tr>"s are just for index adjustment.
-->
<table>
  <tr></tr>
  <tr>
    <td colspan="2" align="center"><b>Translation-Related</b></td>
  </tr>
  <tr>
    <td><a href="#google-translatesh"><code>google-translate.sh</code></a></td>
    <td>Automates <a href="https://translate.google.com/">Google Translate</a>.</td>
  </tr>
  <tr></tr>
  <tr>
    <td><a href="#microsoft-translatesh"><code>microsoft-translate.sh</code></a></td>
    <td>Automates <a href="http://www.bing.com/translator/">Bing Translator</a>.</td>
  </tr>
  <tr></tr>
  <tr>
    <td><a href="#yandex-translatesh"><code>yandex-translate.sh</code></a></td>
    <td>Automates <a href="https://translate.yandex.com/">Yandex.Translate</a>.</td>
  </tr>
  <tr></tr>
  <tr>
    <td><a href="#mymemory-translatesh"><code>mymemory-translate.sh</code></a></td>
    <td>Automates <a href="https://mymemory.translated.net/">MyMemory Translated</a>.</td>
  </tr>
  <tr></tr>
  <tr>
    <td><a href="#honyaku-translatesh"><code>honyaku-translate.sh</code></a></td>
    <td>Automates <a href="http://honyaku.yahoo.co.jp/">Yahoo Honyaku</a>.</td>
  </tr>
  <tr></tr>
  <tr>
    <td><a href="#compare-translationssh"><code>compare-translations.sh</code></a></td>
    <td>Compares the various translation scripts.</td>
  </tr>
  <tr><td colspan="2" align="center"><b>Protocols</b></td></tr>
  <tr>
    <td><a href="#xmlentitiessh"><code>xmlentities.sh</code></a></td>
    <td>Encodes special characters for XML and HTML.</td>
  </tr>
  <tr><td colspan="2" align="center"><b>Utilities</b></td></tr>
  <tr>
    <td><a href="#fpl2htmlsh"><code>fpl2html.sh</code></a></td>
    <td>Converts a <a href="http://www.foobar2000.org/">Foobar2000</a> playlist into HTML (<a href="http://hya-chan.tumblr.com/playlist">example</a>).</td>
  </tr>
  <tr></tr>
  <tr>
    <td><a href="#check-crcsh"><code>check-crc.sh</code></a></td>
    <td>Verifies <code>CRC32</code>s embedded in filenames.</td>
  </tr>
  <tr></tr>
  <tr>
    <td><a href="#thumbsh"><code>thumb.sh</code></a></td>
    <td>Generates a single thumbnail from a video.</td>
  </tr>
  <tr><td colspan="2" align="center"><b>Downloaders</b></td></tr>
  <tr>
    <td><a href="#download-google-fontssh"><code>download-google-fonts.sh</code></a></td>
    <td>Downloads fonts from <a href="https://www.google.com/fonts/">Google Fonts</a> and outputs matching CSS.</td>
  </tr>
  <tr></tr>
  <tr>
    <td><a href="#sankaku-downloadersh"><code>sankaku-downloader.sh</code></a></td>
    <td>Downloads media from <a href="https://chan.sankakucomplex.com">Sankaku Channel</a> in bulk, from tags.</td>
  </tr>
</table>

---

# `google-translate.sh`

Google translate from your shell. Since I've reverse-engineered the [web app][1], this might break at any moment and require fixes. Just file an issue and I'll take a look, but really, I don't even have to tell you not to use shit like this on anything resembling "production environment".

### Usage:

```bash
google-translate.sh SOURCE TARGET PHRASE
```

### Examples:

```bash
google-translate.sh auto en "Болту́н — нахо́дка для шпио́на."
google-translate.sh auto en "La croissance de l'homme ne s'effectue pas de bas en haut, mais de l'intérieur vers l'extérieur."
google-translate.sh auto en "γνῶθι σεαυτόν"
google-translate.sh auto en "馬鹿は死ななきゃ治らない。"
google-translate.sh auto en "彼女の顔は精液に包まれました"
```

### Dependencies:

`perl` `curl` `tr` `node`

# `microsoft-translate.sh`

This is pretty similar but uses Microsoft Translate (or [Bing Translate][2], whatever). I've coded it after snorting http packets from a Notepad++ plugin. Same thing: if this breaks file me an issue, and I'll look into it. Note how this one specifies automatic language detection by an empty argument instead of `auto`. Note that it seems to have the best automatic language detection around, and honestly for some languages the translation seems better than Google Translate, which came as a surprise to me.

| Note |
|------|
| I've considered adding a [BabelFish][3] script, but it has just a few languages, no automatic detection and the results seem to be coming all from MS translate! It would be MS translate with less features.

### Usage:

```bash
microsoft-translate.sh SOURCE TARGET PHRASE
```

### Examples:

```bash
microsoft-translate.sh '' en "Бережливость хороша, да скупость страшна"
microsoft-translate.sh '' en "猿も木から落ちる。"
microsoft-translate.sh '' pt-BR "Spaghetti alla puttanesca means spaghetti of the whore"
microsoft-translate.sh '' en "Setze jutges d'un jutjat mengen fetge d'un penjat"
microsoft-translate.sh '' en "그녀는 공포에 봤다, 정액 사방에 비행 했다."
```

### Dependencies:

`sed` `iconv` `wget`

# `yandex-translate.sh`

Another alternative translation service, probably especially good with Russian but at the same time carrying a comparable set of features to the other ones. Note the script has to query their service twice if you don't specify the language (their [web app][4] also does this). Automatic language detection is also somewhat poor for short phrases.

### Usage:

```bash
yandex-translate.sh SOURCE TARGET PHRASE
```

### Example:

```bash
yandex-translate.sh '' en "Когда я говорил, что хочу всё и сразу, то не имел в виду проблемы и неприятности."
```

### Dependencies:

`perl` `curl` `sed`

# `mymemory-translate.sh`

This is an [automatic-translation-aggregator type of thing][5], which also seems to feature human contributions. The most surprising aspect is that the API seems to be intentionally out in the clear so it was pretty easy to add it. Automatic language detection is laughable and it may give you weird results for too-short content, so give it a spin but YMMV.

### Usage:

```bash
mymemory-translate.sh SOURCE TARGET PHRASE
```

### Example:

```bash
mymemory-translate.sh '' en "A detecção automática de idiomas desse bagulho é bem ruinzinha."
```

### Dependencies:

`perl` `wget` `grep` `sed` `curl` `node`

# `honyaku-translate.sh`

This is a script that automates the [Yahoo Honyaku][10] engine. It's probably best for Japanese to English, which is good, because it's the weak spot of other translation engines (not saying I expect this to do well either). The supported languages are `en`, `ja`, `pt`, `es`, `ko`, `fr`, `zh`, `it`, `de`, and empty string means automatic detection (which sucks saggy meat curtains, like MyMemory's).

### Usage:

```bash
honyaku-translate.sh SOURCE TARGET PHRASE
```

### Example:

```bash
honyaku-translate.sh '' en '俺の妹がこんなに可愛いわけがない'
```

### Dependencies:

`perl` `curl` `grep` `sed` `node`

# `compare-translations.sh`

This script compares the different translation engines using their respective scripts.

### Usage:

```bash
compare-translations.sh PHRASE
```

### Example:

```bash
compare-translations.sh "Niemand ist mehr Sklave, als der sich für frei hält, ohne es zu sein."
compare-translations.sh "Les opinions ont plus causé de maux sur ce petit globe que la peste et les tremblements de terre."
```

### Dependencies:

`microsoft-translate.sh` `google-translate.sh` `yandex-translate.sh` `mymemory-translate.sh`

# `fpl2html.sh`

This script converts a Foobar2000 playlist into an HTML list, that can be easily copy-pasted into places that accept HTML. I made it for my girlfriend to upload her playlist as a tumblr page ([see it as an example][6]). With slight editing you can do other things with playlists; there are many fields which were parsed in the script but not used.

It uses [an utility called `fplreader` by Jacob Hipps][7], there's a download link there but it's 404'd so I compiled it myself, there's a copy here (Windows 7 x64) in case you don't want to compile it. Note that you'll have to compile it if you're on Linux, BSD or whatever but if you're not on Windows you're probably used to compiling stuff anyway, lol.

### Usage:

```bash
fpl2html.sh path/to/playlist.fpl > path/to/playlist.html # Will take a while
```

### Dependencies:

`sed` `iconv` `perl` [`fplreader`][7]

# `xmlentities.sh`

This takes raw UTF-8 from `STDIN` and adds XML entities (valid in HTML, too), such as `&amp;` and [`&#x2603;`][8].

### Usage:

```bash
echo 'déjà-vu' | xmlentities.sh # 'd&#x00e9;j&#x00e0;-vu'
```

### Dependencies:

`sed` `iconv`

# `check-crc.sh`

If you happen to download anime, you'll notice lots of files with CRCs on the filename. This tool is designed to find CRCs in files, and check if they match. Point it to a directory, and it will scan all filenames (recursively), check the ones that seem to have a valid CRC32 (SFV-compatible) in them, checksum them, see if they match, keep doing this while you have a fun time elsewhere, and give you a report at the end (either all OK or showing files that didn't match). Non-zero exit code means something went wrong, and all output is to stderr, so you can also run it as part of something else in a script.

### Usage:

```bash
check-crc.sh '[Fansubs]_-_Love.Wierd.Filenames 12v2_(1080i,HE-AAC+VP9){404B00B5}.ogm'
check-crc.sh 'folder-full-of-shitty-names-to-be-renamed-after-checking-crc'
```

### Dependencies:

`find` `wc` `tr` `sed` `awk` `grep` `cat` `cut` `basename` `python`

| Note |
|------|
| Python (2.7) was used because it can calculate CRC32s out of the box in Windows and Linux. I'll drop this dependency if you suggest me an alternative that is either self-contained or only depends on a core language (on Node and Perl you need to install stuff and PHP's crc32 seems to load the whole "string" in memory like a retarded motherfucker). The `cksum` util doesn't count because it uses Ethernet's checksum algorithm. |

# `thumb.sh`

Generates a thumbnail from a video (not a page of thumnails, just a single thumbnail).

The frame selected is at 25% of the video. This is usually representative of the video, but you may want to edit the source if you think the frame at one third, or half, would be better.

### Usage:

```bash
thumb.sh <video-name.ext> [thumb-name.ext]
```

### Dependencies:

`ffmpeg` `grep` `sed` `cut`

# `download-google-fonts.sh`

Downloads Google fonts so they can be used locally ([like with NW.js][9]) or in your own server (be careful with cross-browser format support in such a case).

The first parameter is an URL Google gives you to embed the font, like `http://fonts.googleapis.com/css?family=Asap:400,700italic`, and the second parameter can be an user agent string (to get fonts for a specific platform), a format name (`woff`/`woff2`/`ttf`), or nothing, in which case the default is `ttf`.

The standard output of the script will be re-written CSS that you can use to require the fonts themselves. It also supports saving fonts (and adjusting file references in the CSS) to a custom directory (third parameter).

### Usage:

```bash
download-google-fonts.sh "$url" "$formatOrUserAgent" "$subdirName" > "$name.css"
```

### Dependencies:

`grep` `sed` `wget` `tr` `cut`

# `sankaku-downloader.sh`

Downloads content from [Sankaku Channel][11], including `jpeg`/`png` images, animated `gifs`, `webm` videos, and `swf` flash games, from tags that you can pass to it, just as you would use on the website itself. Content is downloaded to a folder named after the tags you specified.

### Usage:

```bash
sankaku-downloader.sh 'hjl brown_hair -rating:e'
```

### Dependencies:

`tr` `awk` `grep` `perl` `sed` `curl`

| Note |
|------|
| Directory-unsafe characters are replaced by `�` (so you notice them very easily and do something about it, like renaming the folder to something sensible). |

[1]:  https://translate.google.com/
[2]:  http://www.bing.com/translator/
[3]:  http://www.babelfish.com/
[4]:  https://translate.yandex.com/
[5]:  http://mymemory.translated.net/
[6]:  http://hya-chan.tumblr.com/playlist
[7]:  https://github.com/tetrisfrog/fplreader
[8]:  http://unicodesnowmanforyou.com/
[9]:  https://github.com/nwjs/nw.js
[10]: http://honyaku.yahoo.co.jp/
[11]: https://chan.sankakucomplex.com/
