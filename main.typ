// Sprawozdanie — plik główny.
// Kompilacja: typst compile main.typ


#import "@preview/zap:0.6.0"

#import "szablon/template.typ": (
  bibliografia, praca, spis-tresci, spis-rysunkow, spis-tabel, spis-listingow,
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
    ..komorki,
  )
}

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

Tematem ćwiczenia jest projektowanie, implementacja i testowanie kombinacyjnych
układów logicznych w sterowniku PLC. Celem jest przełożenie funkcji logicznych
na tablice prawdy, schematy logiczne oraz program PLC, a następnie sprawdzenie
ich działania na stanowisku laboratoryjnym.

= Wykorzystany sterownik PLC

Należy podać producenta, model sterownika, wersję oprogramowania oraz
konfigurację stanowiska laboratoryjnego.

= Wykaz wejść i wyjść

#table(
  columns: (1.2cm, 2.2cm, 2.3cm, 1fr),
  inset: 6pt,
  stroke: 0.5pt,
  [*Symbol*], [*Adres*], [*Typ*], [*Opis*],
  [A], [Uzupełnić], [wejście], [Sygnał wejściowy A],
  [B], [Uzupełnić], [wejście], [Sygnał wejściowy B],
  [C], [Uzupełnić], [wejście], [Sygnał wejściowy C / zasilanie],
  [T], [Uzupełnić], [wejście], [Przekroczenie temperatury],
  [H], [Uzupełnić], [wejście], [Przekroczenie wilgotności],
  [A ręczne], [Uzupełnić], [wejście], [Ręczne uruchomienie wentylatora],
  [Y], [Uzupełnić], [wyjście], [Wyjście funkcji logicznej],
  [W], [Uzupełnić], [wyjście], [Sterowanie wentylatorem],
)

= Algorytm sterowania kombinacyjnego

Układ nie posiada pamięci ani stanu wewnętrznego. Wartość każdego wyjścia
wynika wyłącznie z bieżących wartości wejść. Należy opisać sposób przetwarzania
sygnałów oraz przedstawić schemat blokowy lub schemat logiczny układu.

= Funkcje logiczne

W ćwiczeniu analizowane są następujące funkcje:

- $Y = A dot B + C$,
- $Y = (A + B) dot not C$,
- $W = ((T and H) or A) dot C$.

W zapisie funkcji należy jednoznacznie opisać znaczenie operatorów oraz
przyporządkowanie sygnałów do wejść i wyjść sterownika.

= Zadania do wykonania

== Zadanie 1 — $Y = A dot B + C$

=== Określenie kombinacji wejść

Układ ma trzy wejścia, dlatego należy sprawdzić $2^3 = 8$ kombinacji wartości
$A$, $B$ i $C$.

=== Tablica prawdy

#tablica-prawdy-3((a, b, c) => {
  if (a == 1 and b == 1) or c == 1 { 1 } else { 0 }
})

=== Schemat logiczny

Należy przedstawić schemat z bramką AND dla $A$ i $B$, bramką OR oraz
bezpośrednim doprowadzeniem sygnału $C$ do bramki OR.

=== Implementacja w PLC i test sprzętowy

Należy opisać użyty język programowania PLC, przypisanie adresów oraz sposób
wykonania testu. Program powinien zostać sprawdzony dla wszystkich ośmiu
kombinacji wejściowych.

== Zadanie 2 — $Y = (A + B) dot not C$

=== Synteza układu

Układ składa się z bramki OR dla sygnałów $A$ i $B$, negacji sygnału $C$ oraz
bramki AND łączącej oba wyniki.

=== Tablica prawdy

#tablica-prawdy-3((a, b, c) => {
  if (a == 1 or b == 1) and c == 0 { 1 } else { 0 }
})

=== Implementacja algorytmu w PLC

Należy wkleić schemat programu PLC lub listing oraz opisać zastosowane
operacje logiczne.

=== Testy kombinacji wejściowych

Należy wykonać test dla wszystkich ośmiu kombinacji i porównać stan wyjścia
z wartością wynikającą z tablicy prawdy.

== Zadanie 3 — sterowanie wentylatorem

=== Opis sygnałów

$T$ oznacza przekroczenie temperatury, $H$ przekroczenie wilgotności, $A$
ręczne uruchomienie, $C$ poprawne zasilanie, a $W$ sterowanie wentylatorem.
Wentylator może zostać uruchomiony automatycznie po jednoczesnym przekroczeniu
temperatury i wilgotności albo ręcznie, ale tylko przy poprawnym zasilaniu.

=== Tablica prawdy

Układ ma cztery wejścia, dlatego wymaga sprawdzenia $2^4 = 16$ kombinacji.

#table(
  columns: (1fr, 1fr, 1fr, 1fr, 1fr),
  inset: 6pt,
  stroke: 0.5pt,
  [*$T$*], [*$H$*], [*$A$*], [*$C$*], [*$W$*],
  [0], [0], [0], [0], [Uzupełnić],
  [0], [0], [0], [1], [Uzupełnić],
  [0], [0], [1], [0], [Uzupełnić],
  [0], [0], [1], [1], [Uzupełnić],
  [0], [1], [0], [0], [Uzupełnić],
  [0], [1], [0], [1], [Uzupełnić],
  [0], [1], [1], [0], [Uzupełnić],
  [0], [1], [1], [1], [Uzupełnić],
  [1], [0], [0], [0], [Uzupełnić],
  [1], [0], [0], [1], [Uzupełnić],
  [1], [0], [1], [0], [Uzupełnić],
  [1], [0], [1], [1], [Uzupełnić],
  [1], [1], [0], [0], [Uzupełnić],
  [1], [1], [0], [1], [Uzupełnić],
  [1], [1], [1], [0], [Uzupełnić],
  [1], [1], [1], [1], [Uzupełnić],
)

=== Implementacja i test stanowiskowy

Należy przedstawić schemat programu PLC, opisać warunki uruchomienia
wentylatora oraz udokumentować test na stanowisku laboratoryjnym.

= Dokumentacja wyników

== Tabela wyników testów sprzętowych

#table(
  columns: (1.1cm, 2.2cm, 2.2cm, 2.2cm, 2.2cm, 1fr),
  inset: 5pt,
  stroke: 0.5pt,
  [*Lp.*], [*Wejścia*], [*Wynik oczekiwany*], [*Wynik PLC*], [*Wynik sprzętowy*], [*Uwagi*],
  [1], [Uzupełnić], [Uzupełnić], [Uzupełnić], [Uzupełnić], [Uzupełnić],
  [2], [Uzupełnić], [Uzupełnić], [Uzupełnić], [Uzupełnić], [Uzupełnić],
  [3], [Uzupełnić], [Uzupełnić], [Uzupełnić], [Uzupełnić], [Uzupełnić],
)

== Wykryte błędy i sposób ich usunięcia

Należy opisać każdy wykryty błąd, jego przyczynę, sposób poprawy programu lub
połączeń oraz wynik testu po usunięciu problemu. Jeżeli błędów nie wykryto,
należy to wyraźnie zaznaczyć.

== Wnioski

Należy ocenić zgodność tablic prawdy, schematów logicznych, programu PLC
i wyników testów sprzętowych oraz wskazać najważniejsze obserwacje z ćwiczenia.

#bibliografia(plik: "/literatura.bib", wlaczony: false)
#spis-rysunkow(wlaczony: false)
#spis-tabel(wlaczony: false)
#spis-listingow(wlaczony: false)
