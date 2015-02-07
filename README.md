<p align=center><img src=logo.png /></p>

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

This is pretty similar but uses Microsoft Translate (or [Bing Translate][2], whatever). I've coded it after snorting http packets from a Notepad++ plugin. Same thing: if this breaks file me an issue, and I'll look into it. Note how this one specifies automatic language detection by an empty argument instead of `auto`.

### Syntax:

    microsoft-translate.sh SOURCE TARGET PHRASE

### Examples:

    microsoft-translate.sh '' en "Бережливость хороша, да скупость страшна"
    microsoft-translate.sh '' en "猿も木から落ちる。"
    microsoft-translate.sh '' pt-BR "Spaghetti alla puttanesca means spaghetti of the whore"
    microsoft-translate.sh '' en "Setze jutges d'un jutjat mengen fetge d'un penjat"
    microsoft-translate.sh '' en "그녀는 공포에 봤다, 정액 사방에 비행 했다."

[1]: https://translate.google.com/
[2]: http://www.bing.com/translator/
