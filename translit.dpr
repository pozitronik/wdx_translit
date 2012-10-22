program translit;

uses
  SysUtils,
  Windows;

{$R *.res}

type
  TTranslitFile = Function(InputFile, OutputFile, CodeTable: PChar)
    : integer; stdcall;

var
  FROMFILE, TOFILE, CodeTable: string;
  x: PChar;
  location: shortstring;
  LibHWND: HWND;
  TTF: TTranslitFile;
  ListEncode: Boolean;
  List: textFile;
  listitem: string;

begin
  GetMem(x, max_path);
  GetModuleFilename(hInstance, x, max_path);
  location := x;
  FreeMem(x);
  FROMFILE := Paramstr(1);
  TOFILE := Paramstr(2);
  CodeTable := Paramstr(3);
  if (LowerCase(FROMFILE) = '-l') and (fileexists(TOFILE)) then // %L
  begin
    ListEncode := true;
  end
  else if (CodeTable = '') and (fileexists(TOFILE)) then
  begin
    CodeTable := TOFILE;
    TOFILE := FROMFILE + '.out';
  end
  else if (FROMFILE = '') or (FROMFILE = '?') then
  begin
    MessageBox(GetForegroundWindow, 'Usage:' + #10 + #10 +
      'translit.exe fromfile tofile codetable' + #10 + 'or:' + #10 +
      'translit.exe fromfile codetable' + #10 + 'or' + #10 +
      'translit.exe -l filelist codetable' + #10 + #10 +
      'Sample: translit.exe "c:\text_file.txt" "c:\transliterated_text_file.txt" "c:\total\plugins\wdx\translit\Rus2Lat (RINT).ttb"',
      'Usage', mb_ok + mb_IconInformation);
    halt;
  end;

  if not ListEncode then
  begin
    try
      if (not fileexists(FROMFILE)) and (FROMFILE[2] <> ':') then
      begin
        FROMFILE := extractfilepath(location) + FROMFILE;
      end;
    except
      MessageBox(GetForegroundWindow,
        PChar('Input file ' + FROMFILE + ' not found'), 'Error',
        mb_ok + mb_IconInformation);
      halt;
    end;

    if not fileexists(FROMFILE) then
    begin
      MessageBox(GetForegroundWindow,
        PChar('Input file ' + FROMFILE + ' not found'), 'Error',
        mb_ok + mb_IconInformation);
      halt;
    end;

    try
      if (not fileexists(CodeTable)) and (CodeTable[2] <> ':') then
      begin
        CodeTable := extractfilepath(location) + CodeTable;
      end;
    except
      MessageBox(GetForegroundWindow,
        PChar('Table file ' + CodeTable + ' not found'), 'Error',
        mb_ok + mb_IconInformation);
      halt;
    end;

    if not fileexists(CodeTable) then
    begin
      MessageBox(GetForegroundWindow,
        PChar('Table file ' + CodeTable + ' not found'), 'Error',
        mb_ok + mb_IconInformation);
      halt;
    end;
  end;

  if not fileexists(extractfilepath(location) + 'wdx_translit.wdx') then
  begin
    MessageBox(GetForegroundWindow,
      PChar('Transliteration plugin wdx_translit.wdx not found'), 'Error',
      mb_ok + mb_IconInformation);
    halt;
  end
  else
  begin
    LibHWND := LoadLibrary(PChar(extractfilepath(location) +
      'wdx_translit.wdx'));
    if LibHWND = 0 then
    begin
      MessageBox(GetForegroundWindow, PChar('Loading plugin error'), 'Error',
        mb_ok + mb_IconInformation);
      halt;
    end;
    @TTF := GetProcAddress(LibHWND, 'TranslitFile');
    if @TTF = NIL then
    begin
      MessageBox(GetForegroundWindow,
        PChar('Old or unsupported wdx_translit.wdx version'), 'Error',
        mb_ok + mb_IconInformation);
      halt;
    end;
    if not ListEncode then
      TTF(PChar(FROMFILE), PChar(TOFILE), PChar(CodeTable))
    else
    begin
      Assignfile(List, TOFILE);
      reset(List);
      While not eof(List) do
      begin
        readln(List, listitem);
        TTF(PChar(listitem), PChar(listitem + '.out'), PChar(CodeTable));
      end;
    end;
  end;
  FreeLibrary(LibHWND);

end.
