// Czcionki i przełączniki wspólne dla całego szablonu.

#let font-sans = ("Times New Roman", "Liberation Sans")
#let font-mono = ("Liberation Mono", "DejaVu Sans Mono", "Courier New")

// Priorytetowa nazwa staje pierwsza. Reszta listy zostaje zapasem, bez powtórki.
#let z-priorytetem(priorytet, lista) = {
  (priorytet,) + lista.filter(nazwa => nazwa != priorytet)
}

// W main.typ można podać tylko zmieniane pola.
// `interlinia` to ułamek `rozmiar`. Odstępy akapitu, nagłówków i wzorów biorą się z tego iloczynu.
// `czcionka` i `czcionka-kodu` są próbowane przed zapasowymi krojami.
#let knobs-domyslne = (
  stronnicowanie: "prosty",
  kolor-linku: none,
  tekst: (
    rozmiar: 12pt,
    interlinia: 0.57,
    czcionka: "Times New Roman",
    czcionka-kodu: "Liberation Mono",
    kolor-kodu: rgb("#4a4a4a"),
  ),
  kod: (
    numeracja: true,
    tlo: rgb("#f2f2eb"),
    kolor-tekstu: black,
    kolor-numeru: rgb("#808080"),
    kolor-slowa: rgb("#0000ff"),
    kolor-komentarza: rgb("#009900"),
    kolor-napisu: rgb("#9400d1"),
    ramka: false,
    kolor-ramki: rgb("#aaaaaa"),
    zalacznik: false,
  ),
)

#let stan-knobs = state("zpi-knobs", knobs-domyslne)

#let czcionka-tekstu() = z-priorytetem(stan-knobs.get().tekst.czcionka, font-sans)
#let czcionka-kodu() = z-priorytetem(stan-knobs.get().tekst.czcionka-kodu, font-mono)

#let polacz(bazowe, nadpisane) = {
  let wynik = bazowe
  for (klucz, wartosc) in nadpisane.pairs() {
    if (
      type(wartosc) == dictionary
        and klucz in bazowe
        and type(bazowe.at(klucz)) == dictionary
    ) {
      wynik.insert(klucz, polacz(bazowe.at(klucz), wartosc))
    } else {
      wynik.insert(klucz, wartosc)
    }
  }
  wynik
}
