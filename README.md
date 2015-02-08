<p align=center><img src=logo.png /></p>

---

* [`google-translate.sh`](#google-translatesh)
* [`microsoft-translate.sh`](#microsoft-translatesh)
* [`yandex-translate.sh`](#yandex-translatesh)
* [`mymemory-translate.sh`](#mymemory-translatesh)

---

# `google-translate.sh`

Google translate from your shell. Since I've reverse-engineered the [web app][1], this might break at any moment and require fixes. Just file an issue and I'll take a look, but really, I don't even have to tell you not to use shit like this on anything resembling "production environment".

### Syntax:

    google-translate.sh SOURCE TARGET PHRASE

### Examples:

    google-translate.sh auto en "Болту́н — нахо́дка для шпио́на."
    google-translate.sh auto en "La croissance de l'homme ne s'effectue pas de bas en haut, mais de l'intérieur vers l'extérieur."
    google-translate.sh auto en "γνῶθι σεαυτόν"
    google-translate.sh auto en "馬鹿は死ななきゃ治らない。"
    google-translate.sh auto en "彼女の顔は精液に包まれました"

# `microsoft-translate.sh`

This is pretty similar but uses Microsoft Translate (or [Bing Translate][2], whatever). I've coded it after snorting http packets from a Notepad++ plugin. Same thing: if this breaks file me an issue, and I'll look into it. Note how this one specifies automatic language detection by an empty argument instead of `auto`. Note that it seems to have the best automatic language detection around, and honestly for some languages the translation seems better than Google Translate, which came as a surprise to me.

| Note |
|------|
| I've considered adding a [BabelFish][3] script, but it has just a few languages, no automatic detection and the results seem to be coming all from MS translate! It would be MS translate with less features.

### Syntax:

    microsoft-translate.sh SOURCE TARGET PHRASE

### Examples:

    microsoft-translate.sh '' en "Бережливость хороша, да скупость страшна"
    microsoft-translate.sh '' en "猿も木から落ちる。"
    microsoft-translate.sh '' pt-BR "Spaghetti alla puttanesca means spaghetti of the whore"
    microsoft-translate.sh '' en "Setze jutges d'un jutjat mengen fetge d'un penjat"
    microsoft-translate.sh '' en "그녀는 공포에 봤다, 정액 사방에 비행 했다."

# `yandex-translate.sh`

Another alternative translation service, probably especially good with Russian but at the same time carrying a comparable set of features to the other ones. Note the script has to query their service twice if you don't specify the language (their [web app][4] also does this). Automatic language detection is also somewhat poor for short phrases.

### Syntax:

    yandex-translate.sh SOURCE TARGET PHRASE

### Example:

    yandex-translate.sh '' en "Когда я говорил, что хочу всё и сразу, то не имел в виду проблемы и неприятности."

# `mymemory-translate.sh`

This is an [automatic-translation-aggregator type of thing][5], which also seems to feature human contributions. The most surprising aspect is that the API seems to be intentionally out in the clear so it was pretty easy to add it. Automatic language detection is laughable and it may give you weird results for too-short content, so give it a spin but YMMV.

### Syntax:

    mymemory-translate.sh SOURCE TARGET PHRASE

### Example:

    mymemory-translate.sh '' en "A detecção automática de idiomas desse bagulho é bem ruinzinha."

[1]: https://translate.google.com/
[2]: http://www.bing.com/translator/
[3]: http://www.babelfish.com/
[4]: https://translate.yandex.com/
[5]: http://mymemory.translated.net/
