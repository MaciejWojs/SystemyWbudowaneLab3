// Strona tytułowa „prosty”. Uczelnia i wydział są osobnymi wierszami.
#import "/szablon/template.typ": praca

#show: praca.with(
  tytul: [Przykład strony prostej],
  przedmiot: [ZESPOŁOWE PRZEDSIĘWZIĘCIE INŻYNIERSKIE],
  autorzy: ("Anna Nowak", "Jan Kowalski"),
  prowadzacy: [mgr inż. Jan Kowalski],
  strona-tytulowa: "prosty",
  przedmiot-zapis: "pierwsza",
  tabela-tytulowa: (
    ([Uczelnia], "uczelnia"),
    ([Wydział], "wydzial"),
    ([Katedra], "katedra"),
    ([Przedmiot], "przedmiot"),
    ([Tytuł], "tytul"),
    ([Autorzy], "autorzy"),
    ([Prowadzący], "prowadzacy"),
  ),
)
