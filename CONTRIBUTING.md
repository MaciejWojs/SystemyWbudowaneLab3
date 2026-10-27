# Współtworzenie

Szablon jest na licencji MIT, opisanej w pliku `LICENSE`. Zmiana wysłana do tego repozytorium jest udostępniana na tej samej licencji.

Sprawozdanie napisane na tym szablonie nie musi być na licencji MIT. Licencja dotyczy kodu szablonu i jego dokumentacji.

## Zgłoszenie

Błąd składu, brakującą opcję albo propozycję opisz w zgłoszeniu (issue). Podaj, co widać w PDF, którego pliku to dotyczy i jakiej wersji `typst` używasz.

## Zmiana

1. Zrób gałąź od aktualnego `main`.
2. Skład zmieniaj w `szablon/czesci/`. Wejście dla dokumentu to `szablon/template.typ`.
3. W `main.typ` zostaw tylko to, co różni się od domyślnych argumentów `praca`.
4. Nowy wariant strony tytułowej dodaj jako osobny plik w `przyklady/`.
5. Przed wysłaniem skompiluj dokument i przykłady:

```bash
typst compile main.typ
typst compile --root . przyklady/rich.typ
```

To samo dla pozostałych plików `przyklady/*.typ`. Nie dodawaj plików PDF do commita.

6. Otwórz pull request z opisem, co się zmienia i jak to sprawdzić.

Tag `v*` uruchamia `.github/workflows/compile-to-pdf.yaml` tylko wtedy, gdy wskazuje commit z gałęzi `main`. Tag z innej gałęzi kończy akcję błędem i kompilacja się nie uruchamia. Zwykły push gałęzi tej akcji nie uruchamia. Nie wypychaj tagu wydania razem ze zwykłą poprawką.

## Treść tutorialu

Tekst w `main.typ` i `README.md` jest po polsku, bezosobowo. Skrót rozwija się przy pierwszym użyciu. Nie dopisuj źródeł ani wyników, których nie ma w repozytorium.
