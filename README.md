# Sprawozdanie w Typst

Szablon sprawozdania na Wydziale Nauk Inżynieryjnych Akademii Nauk Stosowanych w Nowym Sączu. Strona tytułowa jest krótka, marginesy równe po 2,5 cm, a numer strony jest samą liczbą. Są rozdziały, literatura numeryczna oraz spisy rysunków, tabel i listingów.

Czcionka tekstu to Times New Roman, a gdy jej nie ma — Liberation Sans. Kod w bloku jest Liberation Mono.

## Gdzie co zmienić

Dane projektu są w `main.typ`.

- W `main.typ` podaje się tylko to, co różni się od domyślnych: zwykle tytuł, przedmiot, autorów i prowadzącego. Uczelnia, wydział, katedra i `dokument` („SPRAWOZDANIE”) są w szablonie. Nagłówek bierze nazwę uczelni. Stopka składa się z `dokument` i przedmiotu. Wyłącza ją `stopka: false`. Inny napis podaje się argumentem `dokument`. Strona tytułowa `"rich"` jest domyślna. `"prosty"` składa tabelę z tych samych pól; uczelnia i wydział są osobno. `przedmiot-zapis: "pierwsza"` pisze przedmiot z wielką pierwszą literą, a `"mala"` małymi literami. Przykłady stron są w `przyklady/`. Tytuł, autorzy i przedmiot są też metadanymi PDF.
- Autorzy to lista napisów; puste wpisy są pomijane. `rok: auto` wstawia bieżący rok.
- Słownik `knobs` ustawia stronnicowanie, kolor hiperłączy, tekst i blok kodu. Podaj tylko pola, które zmieniasz. `stronnicowanie: "prosty"` daje sam numer strony, a `"n-z-n"` zapis „2 z 13”. `kolor-linku: none` zostawia łącza w kolorze tekstu. W `knobs.tekst` są `rozmiar` (12 pt), `interlinia` (ułamek rozmiaru, domyślnie 0,57), `czcionka`, `czcionka-kodu` i `kolor-kodu`. W `knobs.kod` są `numeracja`, `ramka`, `kolor-ramki`, `zalacznik` oraz kolory tła, tekstu, numerów linii, słów kluczowych, komentarzy i napisów.
- Pojedynczy listing może to nadpisać: `numeracja: false` albo `kolory: (tlo: rgb("#eeeeee"))`. Plik źródłowy dołącza się do PDF przez `zalacznik: true` albo `knobs.kod.zalacznik: true`. Domyślnie jest wyłączone. Osobny plik dołącza `#zalacz("/kod/plik.cpp")`.

Treść rozdziałów pisze się w `main.typ`, za spisem treści i przed bibliografią. Bibliografia domyślnie jest w `literatura.bib`. Inną ścieżkę podaje się tak: `#bibliografia(plik: "/inna/literatura.bib")`. Pozycja wchodzi do dokumentu tylko wtedy, gdy tekst ją cytuje (`#cite(<klucz>)`). Spis treści, literatura oraz spisy rysunków, tabel i listingów wywołuje się osobno. Każdy pomija się argumentem `wlaczony: false`. Pliki z kodem trzymaj w `kod/`. Rysunki trzymaj w `assets/<rozdzial>/`. Części składu są w `szablon/czesci/`: `wspolne.typ` (czcionki i knobs), `strona.typ` (strona tytułowa, nagłówek, stopka), `kod.typ` (blok kodu), `obiekty.typ` (rysunek, tabela, listing, odsyłacz), `spisy.typ` (spisy i literatura), `praca.typ` (marginesy i reguły dokumentu).

W rozdziale:

```typst
#import "/szablon/template.typ": rysunek, tabela, listing, odnosnik

#rysunek(image("/assets/01-wymagania/nazwa.png", width: 12cm), [Opis rysunku]) <id-rysunku>
#odnosnik(<id-rysunku>)

#tabela([Opis tabeli], table(columns: 2, [A], [B])) <id-tabeli>
Tabela #odnosnik(<id-tabeli>)

#listing([Opis], ```cpp
int main() { return 0; }
```, jezyk: "cpp") <id-kodu>

#listing([Opis pliku], plik: "/kod/main.cpp", jezyk: "cpp") <id-pliku>
Kod #odnosnik(<id-pliku>)
```

`odnosnik` przy rysunku dopisuje „Rysunek”, przy tabeli i listingu zostawia numer i stronę. Ścieżka w `plik` i w `image` zaczyna się od ukośnika i jest liczona od katalogu głównego projektu.

## Codespace

1. Na GitHubie otwórz repozytorium, wybierz „Code”, potem „Create Codespace on main”.
2. Środowisko buduje się z `.devcontainer`. Obraz ma program `typst`. W edytorze są rozszerzenia Tinymist i Typst LSP, więc plik `main.typ` ma podgląd składni.
3. Wynikiem kompilacji jest `main.pdf`.

## Zadania edytora

W Codespace oraz lokalnie w VS Code i Cursor skrót `Ctrl+Shift+B` otwiera zadania z `.vscode/tasks.json`:

- „compile PDF with typst” kompiluje `main.typ` zainstalowanym programem `typst`,
- „cleanup ” usuwa `main.pdf`,
- „compile PDF with typst - docker” kompiluje dokument obrazem Dockera, bez lokalnego pakietu.

## Kompilacja lokalna

Zainstaluj pakiet `typst`, wejdź do katalogu projektu i uruchom:

```bash
typst compile main.typ
```

To samo polecenie wykonuje zadanie „compile PDF with typst”.

## Kompilacja przez Dockera

Gdy pakietu `typst` nie ma w systemie:

```bash
docker run --rm -v "$(pwd):/data" -w /data ghcr.io/typst/typst compile main.typ
```

To samo polecenie wykonuje zadanie „compile PDF with typst - docker”.

## Wydanie na GitHubie

Plik `.github/workflows/compile-to-pdf.yaml` uruchamia się po wypchnięciu tagu gita, którego nazwa zaczyna się od `v`, na przykład `v1.0.0`. Akcja kompiluje `main.typ` oraz każdy plik z `przyklady/` (z katalogiem głównym projektu jako `--root`) i tworzy wydanie (release) z tymi plikami PDF. Nazwa wydania jest nazwą tagu.

```bash
git tag v1.0.0
git push origin v1.0.0
```

Tag bez prefiksu `v` tej akcji nie uruchamia. Zwykły push commita też nie. Tag musi wskazywać commit, który jest na gałęzi `main`. Tag z innej gałęzi kończy akcję błędem i kompilacja się nie uruchamia.

## Licencja

Kod szablonu i ta dokumentacja są na licencji MIT (`LICENSE`). Zasady zmian są w `CONTRIBUTING.md`.
