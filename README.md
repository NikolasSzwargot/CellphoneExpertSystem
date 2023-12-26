# Cellphone-Expert-System
5th Semester AI project. An expert system used to determine if user should by his kid a cellphone.

## Authors

Lena Woźniak 151904

Nikolas Szwargot 151735

# Launch and Installation

## Jar executable

Z zakładki releases na Githubie należy pobrać z najnowszego wydania paczke CellphoneExpertSystem.zip i wypakować całą zawartość do jednego folderu

Po wypakowaniu paczki należy uruchomić wiersz polecenia w folderze z plikami programu, wpisać i uruchomić polecenie:

```
java -jar %ŚcieżkaDoPliku%\CellphoneExpertSystem-main.jar
```

### UWAGA

W przypadku linkageError, należy zainstalować nową wersje Javy.

## IntelliJ

1) W przypadku chęci uruchomienia projektu w środowisku IntelliJ, należy pobrać projekt z githuba (najlepiej "<> Code" -> "Download ZIP")
2) Rozpakować projekt
3) Z paczki w Releases plik CLIPSJNI.dll przenieść do folderu C:\Windows
4) Uruchomić program IntelliJ IDEA i otworzyć w nim folder z projektem
5) Ustawić SDK, poprzez kliknięcie odnośnika w powiadomieniu nad wyświetlanym plikiem, lub też w "File" -> "Project Structure" i w zakładkach Project i Modules ustawić poprawne SDK. minimum 11
6) W "File" -> "Project Structure" -> "Modules" zaznaczyć biblioteke CLIPSJNI i kliknąć apply.
7) Wybrać klasę Phone z eksploratora projektu znajdującego się po lewej
8) Ustawić konfigurację kompilacji na "Current File" i kliknąć ikonkę "Zielonej strzałki" (run 'phone.java')
