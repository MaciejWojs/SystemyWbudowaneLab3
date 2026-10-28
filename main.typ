// Sprawozdanie — plik główny.
// Kompilacja: typst compile main.typ

#import "@preview/zap:0.6.0"

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
wejść przełącznikami oraz obserwację stanu wyjścia (żarówka `Q1`). Podstawy
programowania sterowników PLC opisano m.in. w #cite(<kwasniewski2008>).

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
normalnie zamkniętemu (NC) #cite(<flaga2010>) #cite(<legierski>).

= Funkcje logiczne

W ćwiczeniu zaimplementowano następujące funkcje (operator $dot$ oznacza AND,
$+$ oznacza OR, a $not$ — negację):

- zadanie 1: $Y = A dot B + C$,
- zadanie 2: $Y = (A + B) dot not C$,
- zadanie 3: $W = ((T and H) or A) and C$.

= Zadanie 1 — $Y = A dot B + C$

== Określenie kombinacji wejść

Układ ma trzy wejścia, dlatego należy sprawdzić $2^3 = 8$ kombinacji wartości
$A$, $B$ i $C$. Wyjście $Y$ jest aktywne, gdy jednocześnie aktywne są $A$ i $B$
albo aktywne jest $C$.

== Tablica prawdy

Tablica #odnosnik(<tab-zad1>) zawiera wszystkie kombinacje wejść oraz wartość
funkcji $Y = A dot B + C$.

#tabela(
  [Tablica prawdy dla $Y = A dot B + C$],
  tablica-prawdy-3((a, b, c) => {
    if (a == 1 and b == 1) or c == 1 { 1 } else { 0 }
  }),
) <tab-zad1>

== Schemat logiczny

Schemat bramkowy dla zadania 1 przedstawia #odnosnik(<rys-zap-zad1>):
bramka AND łączy $A$ i $B$, a bramka OR sumuje wynik z sygnałem $C$.

#rysunek(
  schemat-zap-zad1,
  [Schemat logiczny funkcji $Y = A dot B + C$ (biblioteka Zap)],
) <rys-zap-zad1>

== Implementacja w PLC i test sprzętowy

Funkcję zrealizowano w LD jako dwie równoległe gałęzie: szeregowe styki
`I1` (A) i `I2` (B) oraz równoległy styk `I3` (C), z cewką wyjściową `Q1`.
Schemat programu LD pokazuje #odnosnik(<rys-ld-zad1>).

#rysunek(
  image("/assets/zad1/0schemat.png", width: 10cm),
  [Program LD zadania 1 w LOGO! Soft Comfort],
) <rys-ld-zad1>

Wybrane stany symulacji udokumentowano na #odnosnik(<rys-zad1-000>),
#odnosnik(<rys-zad1-101>) i #odnosnik(<rys-zad1-110>).

#rysunek(
  image("/assets/zad1/1wszystkieWylaczone.png", width: 9cm),
  [Zadanie 1: wszystkie wejścia wyłączone ($A B C = 000$), $Y = 0$],
) <rys-zad1-000>

#rysunek(
  image("/assets/zad1/2AiC-wlaczone-zalezy-od-c.png", width: 9cm),
  [Zadanie 1: $A = 1$, $C = 1$, $B = 0$ — wyjście aktywne dzięki gałęzi $C$],
) <rys-zad1-101>

#rysunek(
  image("/assets/zad1/3AiB-C-wylaczone.png", width: 9cm),
  [Zadanie 1: $A = 1$, $B = 1$, $C = 0$ — wyjście aktywne dzięki $A dot B$],
) <rys-zad1-110>

= Zadanie 2 — $Y = (A + B) dot not C$

== Synteza układu

Układ składa się z bramki OR dla sygnałów $A$ i $B$, negacji sygnału $C$ oraz
bramki AND łączącej oba wyniki (#odnosnik(<rys-zap-zad2>)). Wyjście jest
aktywne, gdy co najmniej jedno z wejść $A$ lub $B$ jest równe 1 oraz jednocześnie
$C = 0$.

#rysunek(
  schemat-zap-zad2,
  [Schemat logiczny funkcji $Y = (A + B) dot not C$ (biblioteka Zap)],
) <rys-zap-zad2>

== Tablica prawdy

#tabela(
  [Tablica prawdy dla $Y = (A + B) dot not C$],
  tablica-prawdy-3((a, b, c) => {
    if (a == 1 or b == 1) and c == 0 { 1 } else { 0 }
  }),
) <tab-zad2>

== Implementacja algorytmu w PLC

W LD sygnały $A$ (`I1`) i $B$ (`I2`) połączono równolegle (OR), a następnie
szeregowo ze stykiem NC na `I3` (NOT $C$). Cewka `Q1` realizuje wyjście $Y$.
Schemat programu przedstawia #odnosnik(<rys-ld-zad2>).

#rysunek(
  image("/assets/zad2/0schemat.png", width: 11cm),
  [Program LD zadania 2 — styki równoległe A/B oraz NC dla C],
) <rys-ld-zad2>

== Testy kombinacji wejściowych

#rysunek(
  image("/assets/zad2/1A-wlaczone-C-wylaczone.png", width: 9cm),
  [Zadanie 2: kombinacja z włączonym $A$ i wyłączonym $C$],
) <rys-zad2-a>

#rysunek(
  image("/assets/zad2/2B-wlaczone-C-wylaczone.png", width: 9cm),
  [Zadanie 2: $B = 1$, $C = 0$ — wyjście $Y$ aktywne],
) <rys-zad2-b>

#rysunek(
  image("/assets/zad2/3AiB-C-wlaczone.png", width: 9cm),
  [Zadanie 2: przy $C = 1$ wyjście pozostaje nieaktywne mimo struktury OR],
) <rys-zad2-c>

Dla $B = 1$ i $C = 0$ obserwowano $Y = 1$ (#odnosnik(<rys-zad2-b>)), a przy
$C = 1$ wyjście było wyłączone (#odnosnik(<rys-zad2-c>)), zgodnie z
Tabelą #odnosnik(<tab-zad2>).

= Zadanie 3 — sterowanie wentylatorem

== Opis sygnałów

$T$ oznacza przekroczenie temperatury, $H$ przekroczenie wilgotności, $A$
ręczne uruchomienie, $C$ poprawne zasilanie, a $W$ sterowanie wentylatorem.
Wentylator może zostać uruchomiony automatycznie po jednoczesnym przekroczeniu
temperatury i wilgotności albo ręcznie, ale tylko przy poprawnym zasilaniu:
$W = ((T and H) or A) and C$.

== Schemat logiczny

#rysunek(
  schemat-zap-zad3,
  [Schemat logiczny funkcji $W = ((T and H) or A) and C$ (biblioteka Zap)],
) <rys-zap-zad3>

== Tablica prawdy

Układ ma cztery wejścia, dlatego wymaga sprawdzenia $2^4 = 16$ kombinacji.
Wartości $W$ w Tabeli #odnosnik(<tab-zad3>) wynikają bezpośrednio z funkcji
logicznej.

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

== Implementacja i test stanowiskowy

W LD zrealizowano równoległe połączenie gałęzi $T$-$H$ (szeregowo) z gałęzią
$A$, a następnie szeregowo styk $C$ i cewkę $W$ (`Q1`), jak na
#odnosnik(<rys-ld-zad3>).

#rysunek(
  image("/assets/zad3/0schemat.png", width: 11cm),
  [Program LD zadania 3 — sterowanie wentylatorem],
) <rys-ld-zad3>

#rysunek(
  image("/assets/zad3/1THC-wlaczone.png", width: 11cm),
  [Zadanie 3: $T = H = C = 1$, $A = 0$ — wentylator włączony automatycznie],
) <rys-zad3-thc>

#rysunek(
  image("/assets/zad3/AC-wlaczone.png", width: 11cm),
  [Zadanie 3: ręczne uruchomienie z poprawnym zasilaniem ($A$ i $C$ aktywne)],
) <rys-zad3-ac>

#rysunek(
  image("/assets/zad3/TC-wylaczona-zarowka.png", width: 11cm),
  [Zadanie 3: $T = C = 1$ przy $H = A = 0$ — wyjście wyłączone (brak $H$ i $A$)],
) <rys-zad3-tc>

#rysunek(
  image("/assets/zad3/HC-wylaczona-zarowka.png", width: 11cm),
  [Zadanie 3: przypadek z wyłączoną żarówką Q1 (warunek $W$ niespełniony)],
) <rys-zad3-hc>

Przy $T = H = C = 1$ i $A = 0$ wyjście $W$ było aktywne
(#odnosnik(<rys-zad3-thc>)). Przy samym $T$ i $C$ bez $H$ oraz bez $A$
wyjście pozostawało wyłączone (#odnosnik(<rys-zad3-tc>)), co potwierdza
konieczność koniunkcji $T and H$ w ścieżce automatycznej.

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
#import "@preview/zap:0.6.0"
Podczas testów udokumentowanych zrzutami nie stwierdzono niezgodności między
tablicą prawdy a zachowaniem programu w LOGO! Soft Comfort. Szczególną uwagę
zwrócono na poprawne użycie styku NC w zadaniu 2 (negacja $C$) oraz na
warunek zasilania $C$ w zadaniu 3, bez którego wentylator nie uruchamia się
nawet przy aktywnym $T$ i $H$ albo przy sygnale ręcznym $A$.

== Wnioski

W ramach ćwiczenia przeprowadzono analizę i syntezę układów sterowania
kombinacyjnego oraz zaimplementowano opracowane algorytmy w środowisku
Siemens LOGO! Soft Comfort (język LD). Schematy bramkowe sporządzono za pomocą
biblioteki Zap, a działanie programów potwierdzono zrzutami stanów symulacji
dla reprezentatywnych kombinacji wejść.

Testy wykazały zgodność działania z tablicami prawdy: w zadaniu 1 wyjście
aktywuje się przez $A dot B$ albo przez $C$; w zadaniu 2 negacja $C$ blokuje
wyjście niezależnie od $A$ i $B$; w zadaniu 3 wentylator włącza się przy
$(T and H)$ lub przy $A$, ale wyłącznie gdy $C = 1$. Ćwiczenie pozwoliło
praktycznie przećwiczyć pełny cykl: od funkcji logicznej, przez LD, do
weryfikacji w symulacji LOGO!.

#bibliografia(plik: "/literatura.bib", wlaczony: false)
#spis-rysunkow()
#spis-tabel()
#spis-listingow(wlaczony: false)
