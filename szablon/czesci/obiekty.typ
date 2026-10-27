// Rysunek, tabela, listing i odsyłacz w tekście.

#import "kod.typ": blok-kodu
#import "strona.typ": jako-tekst
#import "wspolne.typ": stan-knobs

#let _zalaczone = state("zpi-zalaczniki", ())

// Dołącza plik do PDF. Ten sam plik dołącza się raz. `wlaczony: false` nic nie dodaje.
#let zalacz(plik, wlaczony: true, opis: none) = context {
  if not wlaczony { return }
  if plik in _zalaczone.get() { return }
  _zalaczone.update(stare => stare + (plik,))
  let opis-tekst = if opis == none { "" } else { jako-tekst(opis).trim() }
  pdf.attach(
    plik,
    relationship: "data",
    mime-type: "text/plain",
    description: if opis-tekst == "" { plik } else { opis-tekst },
  )
}

#let _podpis(it, nazwa, rozmiar, interlinia) = {
  if it.caption == none { return }
  set text(size: 0.875 * rozmiar)
  set par(leading: interlinia, spacing: 0pt, first-line-indent: 0pt, justify: false)
  let cialo = it.caption.body
  grid(
    columns: (auto, 1fr),
    column-gutter: 0.35em,
    align: (left, left),
    text(weight: "bold")[
      #nazwa
      #context { counter(figure.where(kind: it.kind)).display(it.numbering) }.
    ],
    cialo,
  )
}

#let pokaz-figure(it, nazwa, podpis-nad: false) = context {
  let tekst = stan-knobs.get().tekst
  let rozmiar = tekst.rozmiar
  let interlinia = tekst.interlinia * rozmiar
  set par(first-line-indent: 0pt, justify: false)
  block(above: 2 * interlinia, below: 2 * interlinia, breakable: true)[
    #if podpis-nad [
      #align(center, _podpis(it, nazwa, rozmiar, interlinia))
      #v(1.3 * interlinia)
      #align(center, it.body)
    ] else [
      #align(center, it.body)
      #v(interlinia)
      #align(center, _podpis(it, nazwa, rozmiar, interlinia))
    ]
  ]
}

#let numer-w-sekcji(n) = context {
  let rozdzial = counter(heading).get().first()
  numbering("1.1", rozdzial, n)
}

// Odsyłacz do rysunku, tabeli albo listingu: numer i strona.
// Rysunek dostaje przedrostek „Rysunek”. `nazwa: none` zostawia sam numer.
#let odnosnik(etykieta, nazwa: auto) = link(
  etykieta,
  context {
    let el = query(etykieta).first()
    let rodzaj = el.kind
    let roz = counter(heading).at(el.location()).first()
    let n = counter(figure.where(kind: rodzaj)).at(el.location()).first()
    let strona = counter(page).at(el.location()).first()
    let przedrostek = if nazwa != auto {
      nazwa
    } else if rodzaj == image {
      "Rysunek"
    } else {
      none
    }
    if przedrostek != none {
      [#przedrostek #roz.#n (s. #strona)]
    } else {
      [#roz.#n (s. #strona)]
    }
  },
)

#let rysunek(tresc, tytul) = figure(
  tresc,
  kind: image,
  supplement: [Rys.],
  caption: tytul,
)

#let tabela(tytul, tresc) = figure(
  tresc,
  kind: table,
  supplement: [Tab.],
  caption: tytul,
)

#let listing(podpis, ..args, plik: none, jezyk: none, numeracja: auto, kolory: (:), zalacznik: auto) = {
  let kod = if args.pos().len() > 0 {
    args.pos().first()
  } else {
    args.named().at("kod", default: none)
  }
  let surowe = if plik != none {
    read(plik)
  } else if kod != none {
    kod
  } else {
    panic("listing wymaga kodu albo argumentu plik")
  }
  let zrodlo = if type(surowe) == str { surowe } else { surowe.text }
  let lang = if jezyk != none {
    jezyk
  } else if plik == none and type(surowe) != str {
    surowe.lang
  } else {
    none
  }
  figure(
    {
      context {
        let dolacz = if zalacznik == auto {
          stan-knobs.get().kod.zalacznik
        } else {
          zalacznik
        }
        if dolacz and plik != none {
          zalacz(plik, opis: podpis)
        }
      }
      blok-kodu(zrodlo, jezyk: lang, numeracja: numeracja, kolory: kolory)
    },
    kind: "listing",
    supplement: [Listing],
    caption: podpis,
  )
}

// Ścieżka od katalogu głównego projektu, z ukośnikiem na początku: "/kod/main.cpp".
#let listing-plik(sciezka, podpis, jezyk: none, numeracja: auto, kolory: (:), zalacznik: auto) = listing(
  podpis,
  plik: sciezka,
  jezyk: jezyk,
  numeracja: numeracja,
  kolory: kolory,
  zalacznik: zalacznik,
)
