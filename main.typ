// Sprawozdanie — plik główny.
// Kompilacja: typst compile main.typ

#import "@preview/zap:0.6.0"
#import "@preview/karnaugh-express:0.1.1": karnaugh

#import "szablon/template.typ": (
  bibliografia, praca, spis-tresci, spis-rysunkow, spis-tabel, spis-listingow,
  rysunek, tabela, odnosnik,
)

#let tablica-prawdy-3(funkcja) = {
  let komorki = ([*$A$*], [*$B$*], [*$C$*], [*$Y$*])
  for a in range(2) {
    for b in range(2) {
      for c in range(2) {
        komorki.push([#a])
        komorki.push([#b])
        komorki.push([#c])
        komorki.push([#funkcja(a, b, c)])
      }
    }
  }
  table(
    columns: 4,
    inset: 6pt,
    stroke: 0.5pt,
    align: center,
    ..komorki,
  )
}

// Zrzut ekranu: szeroki, ograniczona wysokość — dwa mieszczą się na stronie z opisem.
#let zrzut(sciezka, tytul) = rysunek(
  image(sciezka, width: 100%, height: 9.5cm, fit: "contain"),
  tytul,
)

#let schemat-zap-zad1 = zap.circuit({
  import zap: *
  cetz.draw.set-style(zap: (variant: "ieee"))
  land("and1", (0, 0.55))
  lor("or1", (2.8, 0))
  wstub("and1.in1", label: $A$)
  wstub("and1.in2", label: $B$)
  wstub("or1.in2", label: $C$)
  zwire("and1.out", "or1.in1")
  estub("or1.out", label: $Y$)
})

#let schemat-zap-zad2 = zap.circuit({
  import zap: *
  cetz.draw.set-style(zap: (variant: "ieee"))
  lor("or1", (0, 0.55))
  lnot("not1", (2.6, -0.55))
  land("and1", (4.8, 0))
  wstub("or1.in1", label: $A$)
  wstub("or1.in2", label: $B$)
  wstub("not1.in1", label: $C$)
  zwire("or1.out", "and1.in1")
  zwire("not1.out", "and1.in2")
  estub("and1.out", label: $Y$)
})

#let schemat-zap-zad3 = zap.circuit({
  import zap: *
  cetz.draw.set-style(zap: (variant: "ieee"))
  land("and1", (0, 0.7))
  lor("or1", (2.8, 0.15))
  land("and2", (5.6, 0))
  wstub("and1.in1", label: $T$)
  wstub("and1.in2", label: $H$)
  wstub("or1.in2", label: $A$)
  wstub("and2.in2", label: $C$)
  zwire("and1.out", "or1.in1")
  zwire("or1.out", "and2.in1")
  estub("and2.out", label: $W$)
})

#let knobs = (
  kod: (
    numeracja: false,
    ramka: true,
    kolor-ramki: rgb("#000000"),
  ),
)

#show: praca.with(
  tytul: [Sterowanie kombinacyjne w sterowniku PLC],
  przedmiot: [SYSTEMY WBUDOWANE],
  autorzy: (
    "Maciej Wójs",
  ),
  prowadzacy: [dr inż. Ihor Pazdriy],
  knobs: knobs,
)

#spis-tresci(wlaczony: false)

= Temat i cel ćwiczenia

Tematem ćwiczenia jest analiza i synteza algorytmów sterowania kombinacyjnego
w oparciu o sterowniki PLC (Programmable Logic Controller) oraz ich testowanie
sprzętowe. Celem jest przełożenie zadania sterowania na sygnały wejściowe
i wyjściowe, tablicę prawdy, funkcję logiczną, schemat logiczny oraz program
w języku LD (Ladder Diagram), a następnie sprawdzenie zgodności działania
układu z założeniami projektowymi.

W ramach ćwiczenia zrealizowano trzy zadania: dwie funkcje trójwejściowe
oraz układ sterowania wentylatorem z czterema wejściami.

= Wykorzystany sterownik PLC

Programy przygotowano i przetestowano w środowisku Siemens LOGO! Soft Comfort
w języku LD. Adresy sygnałów odpowiadają wejściom cyfrowym `I1`–`I4` oraz
wyjściu cyfrowemu `Q1` sterownika LOGO!. Symulacja umożliwia wymuszanie stanów
wejść przełącznikami oraz obserwację stanu wyjścia (żarówka `Q1`).

= Wykaz wejść i wyjść

Przyporządkowanie sygnałów używanych w zadaniach 1–3 przedstawia
Tabela #odnosnik(<tab-io>).

#tabela(
  [Przyporządkowanie sygnałów wejściowych i wyjściowych],
  table(
    columns: (1.4cm, 1.6cm, 2.2cm, 1fr),
    inset: 6pt,
    stroke: 0.5pt,
    [*Symbol*], [*Adres*], [*Typ*], [*Opis*],
    [A], [I1], [wejście], [Sygnał wejściowy A (w zad. 1–2) / ręczne uruchomienie (zad. 3: I3)],
    [B], [I2], [wejście], [Sygnał wejściowy B],
    [C], [I3 / I4], [wejście], [Sygnał C (zad. 1–2: I3) / sprawdzenie zasilania (zad. 3: I4)],
    [T], [I1], [wejście], [Przekroczenie temperatury (zadanie 3)],
    [H], [I2], [wejście], [Przekroczenie wilgotności (zadanie 3)],
    [Y], [Q1], [wyjście], [Wyjście funkcji logicznej (zadania 1–2)],
    [W], [Q1], [wyjście], [Sterowanie wentylatorem (zadanie 3)],
  ),
) <tab-io>

W zadaniach 1 i 2 sygnały $A$, $B$, $C$ i $Y$ odpowiadają kolejno `I1`,
`I2`, `I3` i `Q1`. W zadaniu 3 sygnały $T$, $H$, $A$, $C$ i $W$ odpowiadają
`I1`, `I2`, `I3`, `I4` i `Q1`.

= Algorytm sterowania kombinacyjnego

Układ sterowania kombinacyjnego nie posiada pamięci ani stanu wewnętrznego.
Wartość każdego wyjścia wynika wyłącznie z bieżących wartości wejść:
$Y = f(X)$, gdzie $X$ jest wektorem sygnałów wejściowych.
Projektowanie przebiega według kolejności: opis zadania $->$ określenie
wejść i wyjść $->$ tablica prawdy $->$ funkcja logiczna $->$ schemat logiczny
$->$ program PLC $->$ test sprzętowy (lub w symulacji LOGO!).

W języku LD koniunkcja (AND) odpowiada połączeniu szeregowemu styków,
alternatywa (OR) — połączeniu równoległemu, a negacja (NOT) — stykowi
normalnie zamkniętemu (NC).

= Funkcje logiczne

W ćwiczeniu zaimplementowano następujące funkcje ($and$ = koniunkcja,
$or$ = alternatywa, $not$ = negacja):

- zadanie 1: $Y = (A and B) or C$,
- zadanie 2: $Y = (A or B) and not C$,
- zadanie 3: $W = ((T and H) or A) and C$.

= Zadanie 1 — $Y = (A and B) or C$

== Określenie kombinacji wejść

Układ ma trzy wejścia, dlatego należy sprawdzić $2^3 = 8$ kombinacji wartości
$A$, $B$ i $C$. Wyjście $Y$ jest aktywne, gdy jednocześnie aktywne są $A$ i $B$
albo aktywne jest $C$.

== Tablica prawdy

Tablica #odnosnik(<tab-zad1>) zawiera wszystkie kombinacje wejść oraz wartość
funkcji $Y = (A and B) or C$.

#tabela(
  [Tablica prawdy dla $Y = (A and B) or C$],
  tablica-prawdy-3((a, b, c) => {
    if (a == 1 and b == 1) or c == 1 { 1 } else { 0 }
  }),
) <tab-zad1>

== Funkcja kanoniczna i minimalizacja

Z tablicy prawdy widać, że $Y = 1$ dla kombinacji nr 1, 3, 5, 6 i 7, czyli:

$ Y = sum m(1, 3, 5, 6, 7) $

Pełna funkcja (jeszcze przed uproszczeniem):

$ Y &= (not A and not B and C) \
    & or (not A and B and C) \
    & or (A and not B and C) \
    & or (A and B and not C) \
    & or (A and B and C) $

Upraszczanie mapą Karnaugha (#odnosnik(<rys-kmap-zad1>)):
- grupa 4 jedynek przy $C = 1$ (kombinacje 1, 3, 5, 7) → zostaje $C$,
- grupa 2 jedynek przy $A = B = 1$ (kombinacje 6, 7) → zostaje $A and B$.

#rysunek(
  karnaugh(
    ("a", "b", "c"),
    (0, 1, 0, 1, 0, 1, 1, 1),
    var-disp: ($A$, $B$, $C$),
    terms: ("c", "a & b"),
    grid-size: 1.05cm,
  ),
  [Mapa Karnaugha zadania 1 — grupy $C$ oraz $A and B$],
) <rys-kmap-zad1>

Po uproszczeniu wychodzi (to samo co w treści zadania):

$ Y = (A and B) or C $

== Schemat logiczny

Schemat bramkowy dla zminimalizowanej funkcji przedstawia
#odnosnik(<rys-zap-zad1>): bramka AND łączy $A$ i $B$, a bramka OR sumuje
wynik z sygnałem $C$.

#rysunek(
  schemat-zap-zad1,
  [Schemat logiczny funkcji $Y = (A and B) or C$],
) <rys-zap-zad1>

== Implementacja w PLC i test sprzętowy

Funkcję zrealizowano w LD jako dwie równoległe gałęzie: szeregowe styki
`I1` (A) i `I2` (B) oraz równoległy styk `I3` (C), z cewką wyjściową `Q1`.
Poniżej schemat programu oraz stan z wszystkimi wejściami wyłączonymi.


#zrzut(
  "/assets/zad1/0schemat.png",
  [Program LD zadania 1 w LOGO! Soft Comfort],
) <rys-ld-zad1>

#zrzut(
  "/assets/zad1/1wszystkieWylaczone.png",
  [Zadanie 1: wszystkie wejścia wyłączone ($A B C = 000$), $Y = 0$],
) <rys-zad1-000>


Kolejne kombinacje: wyjście aktywne dzięki $C$ oraz dzięki $A and B$.

#zrzut(
  "/assets/zad1/2AiC-wlaczone-zalezy-od-c.png",
  [Zadanie 1: $A = 1$, $C = 1$, $B = 0$ — wyjście aktywne dzięki gałęzi $C$],
) <rys-zad1-101>

#zrzut(
  "/assets/zad1/3AiB-C-wylaczone.png",
  [Zadanie 1: $A = 1$, $B = 1$, $C = 0$ — wyjście aktywne dzięki $A and B$],
) <rys-zad1-110>

= Zadanie 2 — $Y = (A or B) and not C$

== Tablica prawdy

Wyjście jest aktywne, gdy co najmniej jedno z wejść $A$ lub $B$ jest równe 1
oraz jednocześnie $C = 0$.

#tabela(
  [Tablica prawdy dla $Y = (A or B) and not C$],
  tablica-prawdy-3((a, b, c) => {
    if (a == 1 or b == 1) and c == 0 { 1 } else { 0 }
  }),
) <tab-zad2>

== Funkcja kanoniczna i minimalizacja

$Y = 1$ dla kombinacji nr 2, 4 i 6:

$ Y = sum m(2, 4, 6) $

Pełna funkcja:

$ Y &= (not A and B and not C) \
    & or (A and not B and not C) \
    & or (A and B and not C) $

Na mapie Karnaugha (#odnosnik(<rys-kmap-zad2>)):
- para przy $A and not C$ (kombinacje 4, 6) → $A and not C$,
- para z zawinięciem przy $B and not C$ (kombinacje 2, 6) → $B and not C$.

#rysunek(
  karnaugh(
    ("a", "b", "c"),
    (0, 0, 1, 0, 1, 0, 1, 0),
    var-disp: ($A$, $B$, $C$),
    terms: ("a & !c", "b & !c"),
    grid-size: 1.05cm,
  ),
  [Mapa Karnaugha zadania 2 — grupy $A and not C$ oraz $B and not C$],
) <rys-kmap-zad2>

Po uproszczeniu:

$ Y &= (A and not C) or (B and not C) \
    &= (A or B) and not C $

== Schemat logiczny

Układ składa się z bramki OR dla $A$ i $B$, negacji $C$ oraz bramki AND
(#odnosnik(<rys-zap-zad2>)).

#rysunek(
  schemat-zap-zad2,
  [Schemat logiczny funkcji $Y = (A or B) and not C$],
) <rys-zap-zad2>

== Implementacja algorytmu w PLC

W LD sygnały $A$ (`I1`) i $B$ (`I2`) połączono równolegle (OR), a następnie
szeregowo ze stykiem NC na `I3` (NOT $C$). Cewka `Q1` realizuje wyjście $Y$.

#zrzut(
  "/assets/zad2/0schemat.png",
  [Program LD zadania 2 — styki równoległe A/B oraz NC dla C],
) <rys-ld-zad2>

#zrzut(
  "/assets/zad2/1A-wlaczone-C-wylaczone.png",
  [Zadanie 2: kombinacja z włączonym $A$ i wyłączonym $C$],
) <rys-zad2-a>

#pagebreak()

== Testy kombinacji wejściowych

Dla $B = 1$ i $C = 0$ obserwowano $Y = 1$; przy $C = 1$ wyjście było
wyłączone — zgodnie z Tabelą #odnosnik(<tab-zad2>).

#zrzut(
  "/assets/zad2/2B-wlaczone-C-wylaczone.png",
  [Zadanie 2: $B = 1$, $C = 0$ — wyjście $Y$ aktywne],
) <rys-zad2-b>

#zrzut(
  "/assets/zad2/3AiB-C-wlaczone.png",
  [Zadanie 2: przy $C = 1$ wyjście pozostaje nieaktywne mimo struktury OR],
) <rys-zad2-c>

= Zadanie 3 — sterowanie wentylatorem

== Opis sygnałów

$T$ oznacza przekroczenie temperatury, $H$ przekroczenie wilgotności, $A$
ręczne uruchomienie, $C$ poprawne zasilanie, a $W$ sterowanie wentylatorem.
Wentylator może zostać uruchomiony automatycznie po jednoczesnym przekroczeniu
temperatury i wilgotności albo ręcznie, ale tylko przy poprawnym zasilaniu.
Docelowa funkcja (po minimalizacji) ma postać
$W = ((T and H) or A) and C$.

== Tablica prawdy

Układ ma cztery wejścia, dlatego wymaga sprawdzenia $2^4 = 16$ kombinacji
(Tabela #odnosnik(<tab-zad3>)).

#tabela(
  [Tablica prawdy dla $W = ((T and H) or A) and C$],
  table(
    columns: 5,
    inset: 5pt,
    stroke: 0.5pt,
    align: center,
    [*$T$*], [*$H$*], [*$A$*], [*$C$*], [*$W$*],
    [0], [0], [0], [0], [0],
    [0], [0], [0], [1], [0],
    [0], [0], [1], [0], [0],
    [0], [0], [1], [1], [1],
    [0], [1], [0], [0], [0],
    [0], [1], [0], [1], [0],
    [0], [1], [1], [0], [0],
    [0], [1], [1], [1], [1],
    [1], [0], [0], [0], [0],
    [1], [0], [0], [1], [0],
    [1], [0], [1], [0], [0],
    [1], [0], [1], [1], [1],
    [1], [1], [0], [0], [0],
    [1], [1], [0], [1], [1],
    [1], [1], [1], [0], [0],
    [1], [1], [1], [1], [1],
  ),
) <tab-zad3>

== Funkcja kanoniczna i minimalizacja

$W = 1$ dla kombinacji nr 3, 7, 11, 13 i 15:

$ W = sum m(3, 7, 11, 13, 15) $

Pełna funkcja:

$ W &= (not T and not H and A and C) \
    & or (not T and H and A and C) \
    & or (T and not H and A and C) \
    & or (T and H and not A and C) \
    & or (T and H and A and C) $

Na mapie Karnaugha (#odnosnik(<rys-kmap-zad3>)):
- czwórka przy $A = C = 1$ (kombinacje 3, 7, 11, 15) → $A and C$,
- para przy $T = H = C = 1$ (kombinacje 13, 15) → $T and H and C$.

#rysunek(
  karnaugh(
    ("t", "h", "a", "c"),
    (
      0, 0, 0, 1,
      0, 0, 0, 1,
      0, 0, 0, 1,
      0, 1, 0, 1,
    ),
    var-disp: ($T$, $H$, $A$, $C$),
    terms: ("a & c", "t & h & c"),
    grid-size: 0.95cm,
  ),
  [Mapa Karnaugha zadania 3 — grupy $A and C$ oraz $T and H and C$],
) <rys-kmap-zad3>

Po uproszczeniu (wspólne $C$ można wyłączyć przed nawias):

$ W &= (A and C) or (T and H and C) \
    &= C and (A or (T and H)) \
    &= ((T and H) or A) and C $

== Schemat logiczny

#rysunek(
  schemat-zap-zad3,
  [Schemat logiczny funkcji $W = ((T and H) or A) and C$],
) <rys-zap-zad3>

== Implementacja i test stanowiskowy

W LD zrealizowano równoległe połączenie gałęzi $T$–$H$ (szeregowo) z gałęzią
$A$, a następnie szeregowo styk $C$ i cewkę $W$ (`Q1`).


#zrzut(
  "/assets/zad3/0schemat.png",
  [Program LD zadania 3 — sterowanie wentylatorem],
) <rys-ld-zad3>

#zrzut(
  "/assets/zad3/1THC-wlaczone.png",
  [Zadanie 3: $T = H = C = 1$, $A = 0$ — wentylator włączony automatycznie],
) <rys-zad3-thc>


Przy $T = H = C = 1$ i $A = 0$ wyjście $W$ było aktywne. Ręczne uruchomienie
wymaga aktywnego $A$ oraz poprawnego zasilania $C$.

#zrzut(
  "/assets/zad3/AC-wlaczone.png",
  [Zadanie 3: ręczne uruchomienie z poprawnym zasilaniem ($A$ i $C$ aktywne)],
) <rys-zad3-ac>

#zrzut(
  "/assets/zad3/TC-wylaczona-zarowka.png",
  [Zadanie 3: $T = C = 1$ przy $H = A = 0$ — wyjście wyłączone (brak $H$ i $A$)],
) <rys-zad3-tc>


Przy samym $T$ i $C$ bez $H$ oraz bez $A$ wyjście pozostawało wyłączone, co
potwierdza konieczność koniunkcji $T and H$ w ścieżce automatycznej.

#zrzut(
  "/assets/zad3/HC-wylaczona-zarowka.png",
  [Zadanie 3: przypadek z wyłączoną żarówką Q1 (warunek $W$ niespełniony)],
) <rys-zad3-hc>

= Dokumentacja wyników

== Tabela wyników testów

Tabela #odnosnik(<tab-testy>) zbiera udokumentowane zrzutami przypadki testowe.
Kolumna „Wynik” oznacza zgodność stanu wyjścia z tablicą prawdy.

#tabela(
  [Udokumentowane testy symulacyjne LOGO! Soft Comfort],
  table(
    columns: (0.8cm, 2.4cm, 2.6cm, 1.8cm, 1.8cm, 1fr),
    inset: 5pt,
    stroke: 0.5pt,
    [*Lp.*], [*Wejścia*], [*Oczekiwane*], [*PLC*], [*Wynik*], [*Uwagi / zrzut*],
    [1], [$A B C = 000$], [$Y = 0$], [0], [OK], [#odnosnik(<rys-zad1-000>)],
    [2], [$A B C = 101$], [$Y = 1$], [1], [OK], [#odnosnik(<rys-zad1-101>)],
    [3], [$A B C = 110$], [$Y = 1$], [1], [OK], [#odnosnik(<rys-zad1-110>)],
    [4], [$B = 1$, $C = 0$], [$Y = 1$], [1], [OK], [zad. 2, #odnosnik(<rys-zad2-b>)],
    [5], [$C = 1$ (bez A/B)], [$Y = 0$], [0], [OK], [zad. 2, #odnosnik(<rys-zad2-c>)],
    [6], [$T H A C = 1101$], [$W = 1$], [1], [OK], [#odnosnik(<rys-zad3-thc>)],
    [7], [$T H A C = 1001$], [$W = 0$], [0], [OK], [#odnosnik(<rys-zad3-tc>)],
  ),
) <tab-testy>

Pozostałe kombinacje wynikają z tablic prawdy (Tabele #odnosnik(<tab-zad1>),
#odnosnik(<tab-zad2>) i #odnosnik(<tab-zad3>)) i są jednoznacznie określone
przez zaimplementowane funkcje LD.

== Wykryte błędy i sposób ich usunięcia

Podczas testów udokumentowanych zrzutami nie stwierdzono niezgodności między
tablicą prawdy a zachowaniem programu w LOGO! Soft Comfort. Szczególną uwagę
zwrócono na poprawne użycie styku NC w zadaniu 2 (negacja $C$) oraz na
warunek zasilania $C$ w zadaniu 3, bez którego wentylator nie uruchamia się
nawet przy aktywnym $T$ i $H$ albo przy sygnale ręcznym $A$.

== Wnioski

W ramach ćwiczenia przeprowadzono analizę i syntezę układów sterowania
kombinacyjnego oraz zaimplementowano opracowane algorytmy w środowisku
Siemens LOGO! Soft Comfort (język LD). Działanie programów potwierdzono zrzutami stanów symulacji
dla reprezentatywnych kombinacji wejść.

Testy wykazały zgodność działania z tablicami prawdy: w zadaniu 1 wyjście
aktywuje się przez $A and B$ albo przez $C$; w zadaniu 2 negacja $C$ blokuje
wyjście niezależnie od $A$ i $B$; w zadaniu 3 wentylator włącza się przy
$T and H$ lub przy $A$, ale wyłącznie gdy $C = 1$. Ćwiczenie pozwoliło
praktycznie przećwiczyć pełny cykl: od funkcji logicznej, przez LD, do
weryfikacji w symulacji LOGO!.

#bibliografia(plik: "/literatura.bib", wlaczony: false)
#spis-rysunkow(wlaczony: false)
#spis-tabel(wlaczony: false)
#spis-listingow(wlaczony: false)
