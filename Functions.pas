unit functions;

interface

uses
  ID3V1,
  ID3V2,
  MpegAudio,
  IniFiles,
  Classes,
  SysUtils,
  windows;

type
  PluginSettings = record
    UseMulti: boolean;
    Mp3Enable: boolean;
    mp3ttbused: string;
    Mp3id3v2: boolean;
    Format: string;
    ConvertSpaces: boolean;
    StoredTTB: string;
  end;

Function rus2lat(text: string): string; inline;
Function lat2rus(text: string): string; inline;
Function translit(text: string): string; inline;
Function lat2rusF(text: string): string; inline;
Function TranslitUser(text: string; TranslitTable: string; UseStoredTTB: Boolean): string; inline;
Function SymbolsReplace(text: string; SymbolsTable: String): string; inline;
Function SymTranslit(text: string; SymbolsTable: string; UseStoredTTB: Boolean): string; inline;
Function  TagRus2Lat(FileNAme: string; SymbolsTable: String): string;

var
  settings: PluginSettings;
  AStoredTTB: TMemIniFile;

implementation

Function lat2rus(text: string): string;
var
  i: integer;
Begin
  result := '';
  for i := 1 to length(text) do
  begin
    if text[i] = ' ' then
    begin
      if settings.ConvertSpaces then
        result := result + '_'
      else
        result := result + ' ';
      Continue;
    end;
    if text[i] = 'Q' then
    begin
      result := result + 'К';
      Continue;
    end;
    if text[i] = 'W' then
    begin
      result := result + 'В';
      Continue;
    end;
    if text[i] = 'E' then
    begin
      result := result + 'Е';
      Continue;
    end;
    if text[i] = 'R' then
    begin
      result := result + 'Р';
      Continue;
    end;
    if text[i] = 'T' then
    begin
      result := result + 'Т';
      Continue;
    end;
    if text[i] = 'Y' then
    begin
      result := result + 'И';
      Continue;
    end;
    if text[i] = 'U' then
    begin
      result := result + 'У';
      Continue;
    end;
    if text[i] = 'I' then
    begin
      result := result + 'И';
      Continue;
    end;
    if text[i] = 'O' then
    begin
      result := result + 'О';
      Continue;
    end;
    if text[i] = 'P' then
    begin
      result := result + 'П';
      Continue;
    end;
    if text[i] = 'A' then
    begin
      result := result + 'А';
      Continue;
    end;
    if text[i] = 'S' then
    begin
      result := result + 'С';
      Continue;
    end;
    if text[i] = 'D' then
    begin
      result := result + 'Д';
      Continue;
    end;
    if text[i] = 'F' then
    begin
      result := result + 'Ф';
      Continue;
    end;
    if text[i] = 'G' then
    begin
      result := result + 'Г';
      Continue;
    end;
    if text[i] = 'H' then
    begin
      result := result + 'Х';
      Continue;
    end;
    if text[i] = 'J' then
    begin
      result := result + 'Дж';
      Continue;
    end;
    if text[i] = 'K' then
    begin
      result := result + 'К';
      Continue;
    end;
    if text[i] = 'L' then
    begin
      result := result + 'Л';
      Continue;
    end;
    if text[i] = 'Z' then
    begin
      result := result + 'З';
      Continue;
    end;
    if text[i] = 'X' then
    begin
      result := result + 'Кс';
      Continue;
    end;
    if text[i] = 'C' then
    begin
      result := result + 'К';
      Continue;
    end;
    if text[i] = 'V' then
    begin
      result := result + 'В';
      Continue;
    end;
    if text[i] = 'B' then
    begin
      result := result + 'Б';
      Continue;
    end;
    if text[i] = 'N' then
    begin
      result := result + 'Н';
      Continue;
    end;
    if text[i] = 'M' then
    begin
      result := result + 'М';
      Continue;
    end;
    if text[i] = 'q' then
    begin
      result := result + 'к';
      Continue;
    end;
    if text[i] = 'w' then
    begin
      result := result + 'в';
      Continue;
    end;
    if text[i] = 'e' then
    begin
      result := result + 'е';
      Continue;
    end;
    if text[i] = 'r' then
    begin
      result := result + 'р';
      Continue;
    end;
    if text[i] = 't' then
    begin
      result := result + 'т';
      Continue;
    end;
    if text[i] = 'y' then
    begin
      result := result + 'и';
      Continue;
    end;
    if text[i] = 'u' then
    begin
      result := result + 'у';
      Continue;
    end;
    if text[i] = 'i' then
    begin
      result := result + 'и';
      Continue;
    end;
    if text[i] = 'o' then
    begin
      result := result + 'о';
      Continue;
    end;
    if text[i] = 'p' then
    begin
      result := result + 'п';
      Continue;
    end;
    if text[i] = 'a' then
    begin
      result := result + 'а';
      Continue;
    end;
    if text[i] = 's' then
    begin
      result := result + 'с';
      Continue;
    end;
    if text[i] = 'd' then
    begin
      result := result + 'д';
      Continue;
    end;
    if text[i] = 'f' then
    begin
      result := result + 'ф';
      Continue;
    end;
    if text[i] = 'g' then
    begin
      result := result + 'г';
      Continue;
    end;
    if text[i] = 'h' then
    begin
      result := result + 'х';
      Continue;
    end;
    if text[i] = 'j' then
    begin
      result := result + 'дж';
      Continue;
    end;
    if text[i] = 'k' then
    begin
      result := result + 'к';
      Continue;
    end;
    if text[i] = 'l' then
    begin
      result := result + 'л';
      Continue;
    end;
    if text[i] = 'z' then
    begin
      result := result + 'з';
      Continue;
    end;
    if text[i] = 'x' then
    begin
      result := result + 'х';
      Continue;
    end;
    if text[i] = 'c' then
    begin
      result := result + 'к';
      Continue;
    end;
    if text[i] = 'v' then
    begin
      result := result + 'в';
      Continue;
    end;
    if text[i] = 'b' then
    begin
      result := result + 'б';
      Continue;
    end;
    if text[i] = 'n' then
    begin
      result := result + 'н';
      Continue;
    end;
    if text[i] = 'm' then
    begin
      result := result + 'м';
      Continue;
    end;
    result := result + text[i];
  end;
End;

Function rus2lat(text: string): string;
var
  i: integer;
Begin
  for i := 1 to length(text) do
  begin
    if text[i] = ' ' then
    begin
      if settings.ConvertSpaces then
        result := result + '_'
      else
        result := result + ' ';
      Continue;
    end;
    if text[i] = 'Ё' then
    begin
      result := result + 'Yo';
      Continue;
    end;
    if text[i] = 'Й' then
    begin
      result := result + 'Y';
      Continue;
    end;
    if text[i] = 'Ц' then
    begin
      result := result + 'Z';
      Continue;
    end;
    if text[i] = 'У' then
    begin
      result := result + 'U';
      Continue;
    end;
    if text[i] = 'К' then
    begin
      result := result + 'K';
      Continue;
    end;
    if text[i] = 'Е' then
    begin
      result := result + 'E';
      Continue;
    end;
    if text[i] = 'Н' then
    begin
      result := result + 'N';
      Continue;
    end;
    if text[i] = 'Г' then
    begin
      result := result + 'G';
      Continue;
    end;
    if text[i] = 'Ш' then
    begin
      result := result + 'Sh';
      Continue;
    end;
    if text[i] = 'Щ' then
    begin
      result := result + 'Shz';
      Continue;
    end;
    if text[i] = 'З' then
    begin
      result := result + 'Z';
      Continue;
    end;
    if text[i] = 'Х' then
    begin
      result := result + 'H';
      Continue;
    end;
    if text[i] = 'Ъ' then
    begin
      result := result + '`';
      Continue;
    end;
    if text[i] = 'Ф' then
    begin
      result := result + 'F';
      Continue;
    end;
    if text[i] = 'Ы' then
    begin
      result := result + 'I';
      Continue;
    end;
    if text[i] = 'В' then
    begin
      result := result + 'V';
      Continue;
    end;
    if text[i] = 'А' then
    begin
      result := result + 'A';
      Continue;
    end;
    if text[i] = 'П' then
    begin
      result := result + 'P';
      Continue;
    end;
    if text[i] = 'Р' then
    begin
      result := result + 'R';
      Continue;
    end;
    if text[i] = 'О' then
    begin
      result := result + 'O';
      Continue;
    end;
    if text[i] = 'Л' then
    begin
      result := result + 'L';
      Continue;
    end;
    if text[i] = 'Д' then
    begin
      result := result + 'D';
      Continue;
    end;
    if text[i] = 'Ж' then
    begin
      result := result + 'Jz';
      Continue;
    end;
    if text[i] = 'Э' then
    begin
      result := result + 'E';
      Continue;
    end;
    if text[i] = 'Я' then
    begin
      result := result + 'Ya';
      Continue;
    end;
    if text[i] = 'Ч' then
    begin
      result := result + 'Ch';
      Continue;
    end;
    if text[i] = 'С' then
    begin
      result := result + 'S';
      Continue;
    end;
    if text[i] = 'М' then
    begin
      result := result + 'M';
      Continue;
    end;
    if text[i] = 'И' then
    begin
      result := result + 'I';
      Continue;
    end;
    if text[i] = 'Т' then
    begin
      result := result + 'T';
      Continue;
    end;
    if text[i] = 'Ь' then
    begin
      result := result + '''';
      Continue;
    end;
    if text[i] = 'Б' then
    begin
      result := result + 'B';
      Continue;
    end;
    if text[i] = 'Ю' then
    begin
      result := result + 'Yu';
      Continue;
    end;
    if text[i] = 'ё' then
    begin
      result := result + 'yo';
      Continue;
    end;
    if text[i] = 'й' then
    begin
      result := result + 'y';
      Continue;
    end;
    if text[i] = 'ц' then
    begin
      result := result + 'z';
      Continue;
    end;
    if text[i] = 'у' then
    begin
      result := result + 'u';
      Continue;
    end;
    if text[i] = 'к' then
    begin
      result := result + 'k';
      Continue;
    end;
    if text[i] = 'е' then
    begin
      result := result + 'e';
      Continue;
    end;
    if text[i] = 'н' then
    begin
      result := result + 'n';
      Continue;
    end;
    if text[i] = 'г' then
    begin
      result := result + 'g';
      Continue;
    end;
    if text[i] = 'ш' then
    begin
      result := result + 'sh';
      Continue;
    end;
    if text[i] = 'щ' then
    begin
      result := result + 'shz';
      Continue;
    end;
    if text[i] = 'з' then
    begin
      result := result + 'z';
      Continue;
    end;
    if text[i] = 'х' then
    begin
      result := result + 'h';
      Continue;
    end;
    if text[i] = 'ъ' then
    begin
      result := result + '`';
      Continue;
    end;
    if text[i] = 'ф' then
    begin
      result := result + 'f';
      Continue;
    end;
    if text[i] = 'ы' then
    begin
      result := result + 'i';
      Continue;
    end;
    if text[i] = 'в' then
    begin
      result := result + 'v';
      Continue;
    end;
    if text[i] = 'а' then
    begin
      result := result + 'a';
      Continue;
    end;
    if text[i] = 'п' then
    begin
      result := result + 'p';
      Continue;
    end;
    if text[i] = 'р' then
    begin
      result := result + 'r';
      Continue;
    end;
    if text[i] = 'о' then
    begin
      result := result + 'o';
      Continue;
    end;
    if text[i] = 'л' then
    begin
      result := result + 'l';
      Continue;
    end;
    if text[i] = 'д' then
    begin
      result := result + 'd';
      Continue;
    end;
    if text[i] = 'ж' then
    begin
      result := result + 'jz';
      Continue;
    end;
    if text[i] = 'э' then
    begin
      result := result + 'e';
      Continue;
    end;
    if text[i] = 'я' then
    begin
      result := result + 'ya';
      Continue;
    end;
    if text[i] = 'ч' then
    begin
      result := result + 'ch';
      Continue;
    end;
    if text[i] = 'с' then
    begin
      result := result + 's';
      Continue;
    end;
    if text[i] = 'м' then
    begin
      result := result + 'm';
      Continue;
    end;
    if text[i] = 'и' then
    begin
      result := result + 'i';
      Continue;
    end;
    if text[i] = 'т' then
    begin
      result := result + 't';
      Continue;
    end;
    if text[i] = 'ь' then
    begin
      result := result + '''';
      Continue;
    end;
    if text[i] = 'б' then
    begin
      result := result + 'b';
      Continue;
    end;
    if text[i] = 'ю' then
    begin
      result := result + 'yu';
      Continue;
    end;
    result := result + text[i];
  end;
End;

Function translit(text: string): string;
var
  i: integer;
Begin
  result := '';
  for i := 1 to length(text) do
  begin
    if text[i] = ' ' then
    begin
      if settings.ConvertSpaces then
        result := result + '_'
      else
        result := result + ' ';
      Continue;
    end;
    if text[i] = 'Й' then
    begin
      result := result + 'U';
      Continue;
    end;
    if text[i] = 'Ц' then
    begin
      result := result + 'U,';
      Continue;
    end;
    if text[i] = 'У' then
    begin
      result := result + 'Y';
      Continue;
    end;
    if text[i] = 'К' then
    begin
      result := result + 'K';
      Continue;
    end;
    if text[i] = 'Е' then
    begin
      result := result + 'E';
      Continue;
    end;
    if text[i] = 'Н' then
    begin
      result := result + 'H';
      Continue;
    end;
    if text[i] = 'Г' then
    begin
      result := result + 'I`';
      Continue;
    end;
    if text[i] = 'Ш' then
    begin
      result := result + 'III';
      Continue;
    end;
    if text[i] = 'Щ' then
    begin
      result := result + 'III,';
      Continue;
    end;
    if text[i] = 'З' then
    begin
      result := result + '3';
      Continue;
    end;
    if text[i] = 'Х' then
    begin
      result := result + 'X';
      Continue;
    end;
    if text[i] = 'Ъ' then
    begin
      result := result + '''b';
      Continue;
    end;
    if text[i] = 'Ф' then
    begin
      result := result + 'oIo';
      Continue;
    end;
    if text[i] = 'Ы' then
    begin
      result := result + 'bI';
      Continue;
    end;
    if text[i] = 'В' then
    begin
      result := result + 'B';
      Continue;
    end;
    if text[i] = 'А' then
    begin
      result := result + 'A';
      Continue;
    end;
    if text[i] = 'П' then
    begin
      result := result + 'I7';
      Continue;
    end;
    if text[i] = 'Р' then
    begin
      result := result + 'p';
      Continue;
    end;
    if text[i] = 'О' then
    begin
      result := result + 'O';
      Continue;
    end;
    if text[i] = 'Л' then
    begin
      result := result + 'JI';
      Continue;
    end;
    if text[i] = 'Д' then
    begin
      result := result + 'D';
      Continue;
    end;
    if text[i] = 'Ж' then
    begin
      result := result + '>I<';
      Continue;
    end;
    if text[i] = 'Э' then
    begin
      result := result + '3';
      Continue;
    end;
    if text[i] = 'Я' then
    begin
      result := result + '&I';
      Continue;
    end;
    if text[i] = 'Ч' then
    begin
      result := result + '4';
      Continue;
    end;
    if text[i] = 'С' then
    begin
      result := result + 'C';
      Continue;
    end;
    if text[i] = 'М' then
    begin
      result := result + 'M';
      Continue;
    end;
    if text[i] = 'И' then
    begin
      result := result + 'U';
      Continue;
    end;
    if text[i] = 'Т' then
    begin
      result := result + 'T';
      Continue;
    end;
    if text[i] = 'Ь' then
    begin
      result := result + 'b';
      Continue;
    end;
    if text[i] = 'Б' then
    begin
      result := result + '6';
      Continue;
    end;
    if text[i] = 'Ю' then
    begin
      result := result + 'I0';
      Continue;
    end;
    if text[i] = 'й' then
    begin
      result := result + 'u';
      Continue;
    end;
    if text[i] = 'ц' then
    begin
      result := result + 'u,';
      Continue;
    end;
    if text[i] = 'у' then
    begin
      result := result + 'y';
      Continue;
    end;
    if text[i] = 'к' then
    begin
      result := result + 'k';
      Continue;
    end;
    if text[i] = 'е' then
    begin
      result := result + 'e';
      Continue;
    end;
    if text[i] = 'н' then
    begin
      result := result + 'H';
      Continue;
    end;
    if text[i] = 'г' then
    begin
      result := result + 'I`';
      Continue;
    end;
    if text[i] = 'ш' then
    begin
      result := result + 'iii';
      Continue;
    end;
    if text[i] = 'щ' then
    begin
      result := result + 'iii,';
      Continue;
    end;
    if text[i] = 'з' then
    begin
      result := result + '3';
      Continue;
    end;
    if text[i] = 'х' then
    begin
      result := result + 'x';
      Continue;
    end;
    if text[i] = 'ъ' then
    begin
      result := result + '`b';
      Continue;
    end;
    if text[i] = 'ф' then
    begin
      result := result + 'oIo';
      Continue;
    end;
    if text[i] = 'ы' then
    begin
      result := result + 'bI';
      Continue;
    end;
    if text[i] = 'в' then
    begin
      result := result + 'B';
      Continue;
    end;
    if text[i] = 'а' then
    begin
      result := result + 'a';
      Continue;
    end;
    if text[i] = 'п' then
    begin
      result := result + 'I7';
      Continue;
    end;
    if text[i] = 'р' then
    begin
      result := result + 'p';
      Continue;
    end;
    if text[i] = 'о' then
    begin
      result := result + 'o';
      Continue;
    end;
    if text[i] = 'л' then
    begin
      result := result + 'JI';
      Continue;
    end;
    if text[i] = 'д' then
    begin
      result := result + 'd';
      Continue;
    end;
    if text[i] = 'ж' then
    begin
      result := result + '>i<';
      Continue;
    end;
    if text[i] = 'э' then
    begin
      result := result + '3';
      Continue;
    end;
    if text[i] = 'я' then
    begin
      result := result + '&i';
      Continue;
    end;
    if text[i] = 'ч' then
    begin
      result := result + '4';
      Continue;
    end;
    if text[i] = 'с' then
    begin
      result := result + 'c';
      Continue;
    end;
    if text[i] = 'м' then
    begin
      result := result + 'm';
      Continue;
    end;
    if text[i] = 'и' then
    begin
      result := result + 'u';
      Continue;
    end;
    if text[i] = 'т' then
    begin
      result := result + 'T';
      Continue;
    end;
    if text[i] = 'ь' then
    begin
      result := result + 'b';
      Continue;
    end;
    if text[i] = 'б' then
    begin
      result := result + '6';
      Continue;
    end;
    if text[i] = 'ю' then
    begin
      result := result + 'I0';
      Continue;
    end;
    result := result + text[i];
  end;
End;

Function lat2rusF(text: string): string;
var
  i: integer;
  tmp: string;
Begin
  result := '';
  text := lowercase(text);
  i := 0;
  while i < length(text) do
  begin
    if copy(text, i + 1, 5) = 'nctio' then
    begin
      result := result + 'нкше';
      i := i + 5;
      Continue;
    end;
    if copy(text, i + 1, 5) = 'ation' then
    begin
      result := result + 'эйшен';
      i := i + 5;
      Continue;
    end;
    if copy(text, i + 1, 2) = 'ty' then
    begin
      result := result + 'тай';
      i := i + 2;
      Continue;
    end;
    if copy(text, i + 1, 2) = 'ct' then
    begin
      result := result + 'кт';
      i := i + 2;
      Continue;
    end;
    if copy(text, i + 1, 2) = 'cs' then
    begin
      result := result + 'кс';
      i := i + 2;
      Continue;
    end;
    if copy(text, i + 1, 2) = 'eu' then
    begin
      result := result + 'ев';
      i := i + 2;
      Continue;
    end;
    if copy(text, i + 1, 2) = 'me' then
    begin
      result := result + 'ми';
      i := i + 2;
      Continue;
    end;
    if copy(text, i + 1, 3) = 'les' then
    begin
      result := result + 'лс';
      i := i + 3;
      Continue;
    end;
    if copy(text, i + 1, 2) = 'ha' then
    begin
      result := result + 'ха';
      i := i + 2;
      Continue;
    end;
    if copy(text, i + 1, 2) = 'hi' then
    begin
      result := result + 'хай';
      i := i + 3;
      Continue;
    end;
    if copy(text, i + 1, 3) = 'hoy' then
    begin
      result := result + 'хой';
      i := i + 3;
      Continue;
    end;
    if copy(text, i + 1, 2) = 'ho' then
    begin
      result := result + 'хо';
      i := i + 2;
      Continue;
    end;
    if copy(text, i + 1, 2) = 'hu' then
    begin
      result := result + 'ху';
      i := i + 2;
      Continue;
    end;
    if copy(text, i + 1, 2) = 'hy' then
    begin
      result := result + 'хи';
      i := i + 2;
      Continue;
    end;
    if copy(text, i + 1, 2) = 'sh' then
    begin
      result := result + 'ш';
      i := i + 2;
      Continue;
    end;
    if copy(text, i + 1, 2) = 'ch' then
    begin
      result := result + 'ч';
      i := i + 2;
      Continue;
    end;
    if copy(text, i + 1, 3) = 'sch' then
    begin
      result := result + 'щ';
      i := i + 3;
      Continue;
    end;
    if copy(text, i + 1, 3) = 'nes' then
    begin
      result := result + 'нс';
      i := i + 3;
      Continue;
    end;
    if copy(text, i + 1, 3) = 'exa' then
    begin
      result := result + 'екз';
      i := i + 3;
      Continue;
    end;
    if copy(text, i + 1, 3) = 'rce' then
    begin
      result := result + 'рс';
      i := i + 3;
      Continue;
    end;
    if copy(text, i + 1, 2) = 'ea' then
    begin
      result := result + 'и';
      i := i + 2;
      Continue;
    end;
    if copy(text, i + 1, 2) = 'il' then
    begin
      result := result + 'айл';
      i := i + 2;
      Continue;
    end;
    if copy(text, i + 1, 2) = 'ge' then
    begin
      result := result + 'дже';
      i := i + 2;
      Continue;
    end;
    if copy(text, i + 1, 2) = 'ow' then
    begin
      result := result + 'ау';
      i := i + 2;
      Continue;
    end;
    if copy(text, i + 1, 3) = 'mes' then
    begin
      result := result + 'мз';
      i := i + 3;
      Continue;
    end;
    if copy(text, i + 1, 3) = 'lib' then
    begin
      result := result + 'лайб';
      i := i + 3;
      Continue;
    end;
    if copy(text, i + 1, 3) = 'new' then
    begin
      result := result + 'нью';
      i := i + 3;
      Continue;
    end;
    if copy(text, i + 1, 2) = 'sm' then
    begin
      result := result + 'зм';
      i := i + 2;
      Continue;
    end;
    if copy(text, i + 1, 2) = 'oy' then
    begin
      result := result + 'ой';
      i := i + 2;
      Continue;
    end;
    if copy(text, i + 1, 2) = 'th' then
    begin
      result := result + 'з';
      i := i + 2;
      Continue;
    end;
    if copy(text, i + 1, 2) = 'ph' then
    begin
      result := result + 'ф';
      i := i + 2;
      Continue;
    end;
    if copy(text, i + 1, 2) = 'im' then
    begin
      result := result + 'айм';
      i := i + 2;
      Continue;
    end;
    if copy(text, i + 1, 2) = 'gh' then
    begin
      result := result + '';
      i := i + 2;
      Continue;
    end;
    if copy(text, i + 1, 3) = 'tle' then
    begin
      result := result + 'тл';
      i := i + 3;
      Continue;
    end;
    if copy(text, i + 1, 2) = 'gi' then
    begin
      result := result + 'джи';
      i := i + 2;
      Continue;
    end;
    if copy(text, i + 1, 2) = 'ly' then
    begin
      result := result + 'лай';
      i := i + 2;
      Continue;
    end;
    if copy(text, i + 1, 2) = 'oo' then
    begin
      result := result + 'у';
      i := i + 2;
      Continue;
    end;
    if copy(text, i + 1, 2) = 'mu' then
    begin
      result := result + 'мью';
      i := i + 2;
      Continue;
    end;
    if copy(text, i + 1, 3) = 'all' then
    begin
      result := result + 'олл';
      i := i + 3;
      Continue;
    end;
    if copy(text, i + 1, 3) = 'iew' then
    begin
      result := result + '''юв';
      i := i + 3;
      Continue;
    end;
    if copy(text, i + 1, 3) = 'ake' then
    begin
      result := result + 'айк';
      i := i + 3;
      Continue;
    end;
    if copy(text, i + 1, 2) = 'ee' then
    begin
      result := result + 'и';
      i := i + 2;
      Continue;
    end;
    if copy(text, i + 1, 3) = 'ace' then
    begin
      result := result + 'эйс';
      i := i + 3;
      Continue;
    end;
    if copy(text, i + 1, 3) = 'new' then
    begin
      result := result + 'нью';
      i := i + 3;
      Continue;
    end;
    if copy(text, i + 1, 2) = 'ck' then
    begin
      result := result + 'к';
      i := i + 2;
      Continue;
    end;
    if copy(text, i + 1, 2) = 'hu' then
    begin
      result := result + 'хью';
      i := i + 2;
      Continue;
    end;
    if (copy(text, i + 1, 2) = 'i ') { or (copy (text,i+1,2) = 'i') } then
    begin
      result := result + 'ай ';
      i := i + 2;
      Continue;
    end;
    tmp := copy(text, i + 1, 2);
    if (copy(text, i + 1, 2) = 'e ') { or (copy (text,i+1,2) = 'е') } then
    begin
      result := result + ' ';
      i := i + 2;
      Continue;
    end;
    tmp := copy(text, i + 1, 3);
    if (copy(text, i + 1, 3) = 'mе ') { or (copy (text,i+1,3) = 'mе') } then
    begin
      result := result + 'айм';
      i := i + 3;
      Continue;
    end;
    if (copy(text, i + 1, 2) = 'nе ') { or (copy (text,i+1,3) = 'nе') } then
    begin
      result := result + 'айн';
      i := i + 3;
      Continue;
    end;

    if (copy(text, i + 1, 2) = 'gg') then
    begin
      result := result + 'гг';
      i := i + 2;
      Continue;
    end;
    if (copy(text, i + 1, 3) = 'cut') then
    begin
      result := result + 'кат';
      i := i + 3;
      Continue;
    end;
    if (copy(text, i + 1, 2) = 'li') then
    begin
      result := result + 'лай';
      i := i + 2;
      Continue;
    end;

    inc(i);
    if text[i] = 'q' then
    begin
      result := result + 'к';
      Continue;
    end;
    if text[i] = 'w' then
    begin
      result := result + 'в';
      Continue;
    end;
    if text[i] = 'e' then
    begin
      result := result + 'е';
      Continue;
    end;
    if text[i] = 'r' then
    begin
      result := result + 'р';
      Continue;
    end;
    if text[i] = 't' then
    begin
      result := result + 'т';
      Continue;
    end;
    if text[i] = 'y' then
    begin
      result := result + 'и';
      Continue;
    end;
    if text[i] = 'u' then
    begin
      result := result + 'у';
      Continue;
    end;
    if text[i] = 'i' then
    begin
      result := result + 'и';
      Continue;
    end;
    if text[i] = 'o' then
    begin
      result := result + 'о';
      Continue;
    end;
    if text[i] = 'p' then
    begin
      result := result + 'п';
      Continue;
    end;
    if text[i] = 'a' then
    begin
      result := result + 'а';
      Continue;
    end;
    if text[i] = 's' then
    begin
      result := result + 'с';
      Continue;
    end;
    if text[i] = 'd' then
    begin
      result := result + 'д';
      Continue;
    end;
    if text[i] = 'f' then
    begin
      result := result + 'ф';
      Continue;
    end;
    if text[i] = 'g' then
    begin
      result := result + 'г';
      Continue;
    end;
    if text[i] = 'h' then
    begin
      result := result + '';
      Continue;
    end;
    if text[i] = 'j' then
    begin
      result := result + 'дж';
      Continue;
    end;
    if text[i] = 'k' then
    begin
      result := result + 'к';
      Continue;
    end;
    if text[i] = 'l' then
    begin
      result := result + 'л';
      Continue;
    end;
    if text[i] = 'z' then
    begin
      result := result + 'з';
      Continue;
    end;
    if text[i] = 'x' then
    begin
      result := result + 'х';
      Continue;
    end;
    if text[i] = 'c' then
    begin
      result := result + 'к';
      Continue;
    end;
    if text[i] = 'v' then
    begin
      result := result + 'в';
      Continue;
    end;
    if text[i] = 'b' then
    begin
      result := result + 'б';
      Continue;
    end;
    if text[i] = 'n' then
    begin
      result := result + 'н';
      Continue;
    end;
    if text[i] = 'm' then
    begin
      result := result + 'м';
      Continue;
    end;
    result := result + text[i];
  end;
End;

Function TranslitUser(text: string; TranslitTable: string; UseStoredTTB: Boolean): string;
var
  TTable: TMemIniFile;
  i: integer;
  temp: string;
begin
  result := '';
  if UseStoredTTB then
    TTable := AStoredTTB
  else
    TTable := TMemIniFile.Create(TranslitTable);
  try
    for i := 1 to length(text) do
    Begin
      temp := TTable.ReadString('Translit', text[i], '');

      if (text[i] = ' ') and settings.ConvertSpaces then
        temp := '_';

      if temp = '' then
        temp := text[i];
      result := result + temp;
    end;
  finally
    if not UseStoredTTB then
      TTable.free;
  end;
end;

Function SymbolsReplace(text: string; SymbolsTable: String): string;
var
  TTable: TMemIniFile;
  i: integer;
  temp: string;
Begin
  result := '';
  TTable := TMemIniFile.Create(SymbolsTable);
  try
    temp := TTable.ReadString('Translit', text, '');
    if temp = '' then
      temp := text[i];
    result := result + temp;
  finally
    TTable.free;
  end;
End;

Function SymTranslit(text: string; SymbolsTable: string; UseStoredTTB: Boolean): string;
var
  TTable: TMemIniFile;
  x, x2: integer;
  i: integer;
  text2, temp: string;
  s, ExList: TStringList;
  { Function Exc (what:string):boolean;
    var
    xx:integer;
    c:string;
    begin
    result:= false;
    for xx:=0 to ExList.Count-1 do
    begin
    c:=copy (ExList.Strings [xx],1,pos ('=',ExList.Strings [xx])-1);
    if c=what then
    begin
    result:=true;
    break;
    end;
    end;
    end; }
Begin
  i := 0;
  s := TStringList.Create;
  try
    ExList := TStringList.Create;
    try
      result := '';
      if UseStoredTTB then
        TTable := AStoredTTB
      else
        TTable := TMemIniFile.Create(SymbolsTable);
      try
        TTable.ReadSection('Symbols', s);
        text2 := text;
        TTable.ReadSection('Exceptions', ExList);
        while i < length(text2) do
        begin
          temp := '';
          for x := 0 to s.Count - 1 do
          // begin
          { if (x=ExList.Count) then break;
            temp:=copy (text2,i+1,length (ExList.Strings [x]));
            if (ExList.Strings [x]=copy (text2,i+1,length (ExList.Strings [x]))) then
            begin
            result:=result+temp;
            i:=i+length (ExList.Strings [x]);
            break;
            end;
            end; }
          // ---------------------
          // if x>ExList.count-1 then
          begin
            temp := copy(text2, i + 1, length(s.Strings[x]));
            if s.Strings[x] = copy(text2, i + 1, length(s.Strings[x])) then
            begin
              temp := s.Strings[x];
              result := result + TTable.ReadString('Symbols', temp, '');
              i := i + length(s.Strings[x]);
              break;
            end;
          end;
          // ---------------------
          if x > s.Count - 1 then
          begin
            temp := TTable.ReadString('Translit', text2[i + 1], '');
            if temp = '' then
              temp := text2[i + 1];
            if temp = '^E' then
              temp := '';
            if text2[i + 1] <> lowercase(text)[i + 1] then
              temp := UpperCase(temp);
            result := result + temp;
            inc(i);
          end;
        end;
      finally
        if not UseStoredTTB then
          TTable.free;
      end
    finally
      s.free;
    end;
  finally
    ExList.free;
  end;
End;

Function ReplaceConst(constant: string; Tag1: TID3v1; tag2: TID3v2): string;
Begin
  constant := lowercase(constant);
  if settings.Mp3id3v2 then
  begin
    if constant = '%artist%' then
    begin
      if tag2.Exists then
        result := tag2.Artist
      else
        result := Tag1.Artist;
      exit;
    end;
    if constant = '%album%' then
    begin
      if tag2.Exists then
        result := tag2.Album
      else
        result := Tag1.Album;
      exit;
    end;
    if constant = '%title%' then
    begin
      if tag2.Exists then
        result := tag2.Title
      else
        result := Tag1.Title;
      exit;
    end;
    if constant = '%tracknumber%' then
    begin
      if tag2.Exists then
        result := inttostr(tag2.Track)
      else
        result := inttostr(Tag1.Track);
      exit;
    end;
    if constant = '%year%' then
    begin
      if tag2.Exists then
        result := tag2.Year
      else
        result := Tag1.Year;
      exit;
    end;
    if constant = '%genre%' then
    begin
      if tag2.Exists then
        result := tag2.Genre
      else
        result := Tag1.Genre;
      exit;
    end;
    if constant = '%comment%' then
    begin
      if tag2.Exists then
        result := tag2.Comment
      else
        result := Tag1.Comment;
      exit;
    end;
  end
  else
  begin
    if constant = '%artist%' then
    begin
      if Tag1.Exists then
        result := Tag1.Artist
      else
        result := tag2.Artist;
      exit;
    end;
    if constant = '%album%' then
    begin
      if Tag1.Exists then
        result := Tag1.Album
      else
        result := tag2.Album;
      exit;
    end;
    if constant = '%title%' then
    begin
      if Tag1.Exists then
        result := Tag1.Title
      else
        result := tag2.Title;
      exit;
    end;
    if constant = '%tracknumber%' then
    begin
      if Tag1.Exists then
        result := inttostr(Tag1.Track)
      else
        result := inttostr(tag2.Track);
      exit;
    end;
    if constant = '%year%' then
    begin
      if Tag1.Exists then
        result := Tag1.Year
      else
        result := tag2.Year;
      exit;
    end;
    if constant = '%genre%' then
    begin
      if Tag1.Exists then
        result := Tag1.Genre
      else
        result := tag2.Genre;
      exit;
    end;
    if constant = '%comment%' then
    begin
      if Tag1.Exists then
        result := Tag1.Comment
      else
        result := tag2.Comment;
      exit;
    end;
  end;
end;

function GetFormattedString(a: widestring; Tag1: TID3v1; tag2: TID3v2)
  : widestring;
var
  res, tmp, buf: string;
  i: integer;
  bufmode: boolean; // close/open
  // inbuf:boolean;
begin
  tmp := a;
  bufmode := false;
  // inbuf:=false;
  buf := '';
  res := '';
  for i := 1 to length(tmp) do
  begin
    if tmp[i] = '%' then
      bufmode := not bufmode;
    if bufmode then
      buf := buf + tmp[i]
    else
    begin
      if tmp[i] = '%' then
        buf := buf + '%'
      else
        res := res + tmp[i];
    end;
    if (tmp[i] = '%') and not bufmode then
    begin
      res := res + ReplaceConst(buf, Tag1, tag2);
      buf := '';
    end;
  end;
  result := res;
end;

Function TagRus2Lat(FileName: string; SymbolsTable: string): string;
var
  Tag1: TID3v1;
  tag2: TID3v2;
Begin
  Tag1 := TID3v1.Create;
  tag2 := TID3v2.Create;
  Tag1.ReadFromFile(FileNAme);
  tag2.ReadFromFile(FileNAme);
  if not(Tag1.Exists or tag2.Exists) then
  begin
    result := '';
    exit;
  end;
  result := GetFormattedString(settings.Format, Tag1, tag2);
  if SymbolsTable = '' then
    result := rus2lat(result)
  else
    result := TranslitUser(result, SymbolsTable, False);
End;

end.
