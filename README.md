# Quarton perusteet

Tämä repositorio sisältää verkkokirjan **Quarton perusteet**. Kirja on kirjoitettu Quarto-järjestelmässä (versio 1.6.39).

## Lataaminen

Voit ladata kirjan omalle laitteellesi Gitillä: `git clone https://github.com/osaal/quartonperusteet.git`

# Renderöinti

Ennen renderöintiä tulee AINA ajaa skripti `_flatten-output.R`. Skripti siirtää kaikki `.qmd`-tiedostot "src"-kansiosta yläkansioon renderöintiä varten. Renderöinnin jälkeen Quarto ajaa automaattisesti post-render-skriptin `_restore-dirs.R`, mikä siirtää tiedostot takaisin alkuperäisiin paikkoihinsa.

JOS skriptiä `_flatten-output.R` ei ajeta, renderi tulee kaatumaan ennen toimimista.

Skriptin takia `quarto preview` EI toimi!
