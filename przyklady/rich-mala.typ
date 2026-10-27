// Strona tytułowa „rich”. Przedmiot małymi literami.
#import "/szablon/template.typ": praca

#show: praca.with(
  tytul: [Przykład strony rich],
  przedmiot: [ZESPOŁOWE PRZEDSIĘWZIĘCIE INŻYNIERSKIE],
  autorzy: ("Anna Nowak", "Jan Kowalski"),
  prowadzacy: [mgr inż. Jan Kowalski],
  strona-tytulowa: "rich",
  przedmiot-zapis: "mala",
)
