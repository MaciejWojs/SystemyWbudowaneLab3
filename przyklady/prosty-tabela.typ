// Własny układ tabeli. Uczelnia i wydział zostają osobnymi komórkami.
#import "/szablon/template.typ": praca

#show: praca.with(
  tytul: [Przykład własnej tabeli],
  przedmiot: [ZESPOŁOWE PRZEDSIĘWZIĘCIE INŻYNIERSKIE],
  autorzy: ("Anna Nowak", "Jan Kowalski"),
  prowadzacy: [mgr inż. Jan Kowalski],
  strona-tytulowa: "prosty",
  przedmiot-zapis: "mala",
  tabela-tytulowa: dane => table(
    columns: (4.5cm, 1fr),
    align: (right + horizon, left + horizon),
    inset: (x: 8pt, y: 6pt),
    stroke: 0.5pt,
    [*Uczelnia*], dane.uczelnia,
    [*Wydział*], dane.wydzial,
    [*Przedmiot*], dane.przedmiot,
    [*Tytuł*], dane.tytul,
    [*Autorzy*], dane.autorzy,
  ),
)
