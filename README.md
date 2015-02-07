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

[1]: https://translate.google.com/
