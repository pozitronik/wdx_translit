library wdx_translit;

uses
  SysUtils,
  windows,
  IniFiles,
  Functions,
  Classes,
  contplug;
{$R *.res}
{$E wdx}

var
  PluginPath: string;
  Gsr: TSearchrec;
  // GSearchNum:byte;
  ColumnNames: TStrings;

  SetF: TIniFile;

Function FindFirstNextClose(var sr: TSearchrec; searchnum: Integer): boolean;
var
  FindNum: Integer;
begin
  FindNum := 0;
  result := true;
  if searchnum = 0 then
  begin
    // first ttb file
    if FindFirst(IncludeTrailingPathDelimiter(extractfiledir(PluginPath))
        + '*.ttb', faAnyFile, sr) <> 0 then
    begin
      // no ttb files found
      result := false;
      SysUtils.FindClose(sr);
    end;
  end
  else
  begin
    // some else ttb files
    FindFirst(IncludeTrailingPathDelimiter(extractfiledir(PluginPath)) + '*.ttb',
      faAnyFile, sr);
    while FindNum <> searchnum do
    begin
      if FindNext(sr) = 0 then
      begin
        inc(FindNum);
      end
      else
      begin
        result := false;
        break;
      end;
    end;
    SysUtils.FindClose(sr);
    //
  end;
end;

{ ------------------------------------------------------------------------------ }
procedure ContentGetDetectString(DetectString: PAnsiChar; maxlen: Integer); stdcall;
Begin
End;

{ ------------------------------------------------------------------------------ }
function ContentGetSupportedField(FieldIndex: integer; FieldName, Units: PAnsiChar; MaxLen: integer): integer; stdcall;
Begin
  Case FieldIndex of
    0:
      Begin
        StrLCopy(FieldName, '(INT) Rus2lat', maxlen - 1);
        result := ft_stringW;
      End;
    1:
      Begin
        StrLCopy(FieldName, '(INT) Lat2rus', maxlen - 1);
        result := ft_stringW;
      End;
    2:
      Begin
        StrLCopy(FieldName, '(INT) Translit', maxlen - 1);
        result := ft_stringW;
      end;
    3:
      Begin
        StrLCopy(FieldName, '(INT) Fonetics', maxlen - 1);
        result := ft_stringW;
      end;
    4:
      Begin
        StrLCopy(FieldName, '(INT) MP3 ID3 Tag Rus2Lat', maxlen - 1);
        result := ft_stringW;
      end;
    5:
      Begin
        StrLCopy(FieldName, 'FILE TRANSLITERATION', maxlen - 1);
        result := ft_stringW;
      end;
  else
    result := 0;

    begin
      if FindFirstNextClose(Gsr, FieldIndex - 6) then
      begin
        StrLCopy(FieldName, PAnsiChar(AnsiString('(USR) ' + ChangeFileExt(Gsr.Name, ''))),
          maxlen - 1);
        ColumnNames.Add(Gsr.Name);
        result := ft_stringW;
      end
      else
        result := 0;
    end;

  end;

  strcopy(Units, '');
End;

function ContentGetValueW(FileName: PWideChar; FieldIndex, UnitIndex: integer; FieldValue: PByte; MaxLen, Flags: integer): integer; stdcall;
var
  reslt: string;
  UseStoredTTB: Boolean;
Begin
  if not directoryexists(FileName) then
    reslt := ChangeFileExt(ExtractFileName(FileName), '')
  else
    reslt := ExtractFileName(FileName);

  case FieldIndex of
    0:
      Begin
        StrLCopy(PWideChar(FieldValue), PWideChar(rus2lat(reslt)), maxlen div 2 - 1);
      End;
    1:
      Begin
        StrLCopy(PWideChar(FieldValue), PWideChar(lat2rus(reslt)), maxlen div 2 - 1);
      End;
    2:
      Begin
        StrLCopy(PWideChar(FieldValue), PWideChar(translit(reslt)), maxlen div 2 - 1);
      End;
    3:
      Begin
        StrLCopy(PWideChar(FieldValue), PWideChar(lat2RusF(reslt)), maxlen div 2 - 1);
      End;
    4:
      Begin
        if (Lowercase(ExtractFileExt(FileName)) <> '.mp3') and settings.Mp3Enable
        then
          StrLCopy(PWideChar(FieldValue), PWideChar(''), maxlen div 2 - 1)
      else
        StrLCopy(PWideChar(FieldValue),
          PWideChar(TagRus2Lat(FileName, settings.mp3ttbused)),
          maxlen div 2 - 1);
  End;
5:
      Begin
        StrLCopy(PWideChar(FieldValue), PWideChar('<ONLY FOR CHANGE ATTRIBUTES>'), maxlen div 2 - 1);
      End;
  else
    if settings.UseMulti then
    begin
      UseStoredTTB := AnsiSameText(ColumnNames.Strings[FieldIndex - 6],
        settings.StoredTTB);
      StrLCopy(PWideChar(FieldValue),
        PWideChar(SymTranslit(reslt,
        IncludeTrailingPathDelimiter(ExtractFilePath(PluginPath)) +
        ColumnNames.Strings[FieldIndex - 6], UseStoredTTB)), maxlen div 2 - 1)
    end
    else
    begin
      UseStoredTTB := AnsiSameText(ColumnNames.Strings[FieldIndex - 6],
        settings.StoredTTB);
      StrLCopy(PWideChar(FieldValue),
        PWideChar(TranslitUser(reslt,
        IncludeTrailingPathDelimiter(ExtractFilePath(PluginPath)) +
        ColumnNames.Strings[FieldIndex - 6], UseStoredTTB)), maxlen div 2 - 1);
    end;
  end;
  result := ft_stringw;
end;
{ ------------------------------------------------------------------------------ }
function ContentGetValue(FileName: PAnsiChar; FieldIndex, UnitIndex: Integer;
  FieldValue: pbyte; maxlen, flags: Integer): Integer; stdcall;
begin
  Result := ContentGetValueW(PWideChar(FileName), FieldIndex, UnitIndex, FieldValue, maxlen, flags);
End;

{ ------------------------------------------------------------------------------ }
procedure ContentSetDefaultParams(dps: pContentDefaultParamStruct); stdcall;
Begin
  dps.PluginInterfaceVersionLow := 5;
  dps.PluginInterfaceVersionHi := 1;
End;
(* {------------------------------------------------------------------------------}
  function ContentGetDefaultSortOrder(FieldIndex:integer):integer; stdcall;
  Begin
  End;
  {------------------------------------------------------------------------------} *)

function TranslitFile(InputFile, OutputFile, CodeTable: pchar): Integer;
  stdcall;
var
  f1, f2: Text;
  buf, buf2: String;
Begin
  AssignFile(f1, strpas(InputFile));
  reset(f1);
  AssignFile(f2, strpas(OutputFile));
  rewrite(f2);
  reset(f2);
  append(f2);
  while not EOF(f1) do
  begin
    ReadLn(f1, buf);
    if length(buf) > 256 then
    begin
      while length(buf) > 256 do
      begin
        buf2 := copy(buf, 0, 255);
        buf := copy(buf, 256, length(buf) - 1);
        if settings.UseMulti then
        begin
          buf2 := SymTranslit(buf2, strpas(CodeTable), False)
        end
        else
        begin
          buf2 := TranslitUser(buf2, strpas(CodeTable), False);
        end;
        write(f2, buf2);
      end;
    end; // else
    // begin
    if settings.UseMulti then
    begin
      buf := SymTranslit(buf, strpas(CodeTable), False)
    end
    else
    begin
      buf := TranslitUser(buf, strpas(CodeTable), False);
    end;
    writeln(f2, buf);
    // end;
  End;
  CloseFile(f1);
  CloseFile(f2);
end;

function ContentGetSupportedFieldFlags(FieldIndex: Integer): Integer; stdcall;
Begin
  result := 0;
  if FieldIndex = -1 then
    result := contflags_edit + contflags_substmask;
  if FieldIndex = 5 then
    result := contflags_edit + contflags_fieldedit;
end;

function ContentSetValue(FileName: pchar;
  FieldIndex, UnitIndex, FieldType: Integer; FieldValue: pbyte;
  flags: Integer): Integer; stdcall;
Begin
  Result := ft_NotSupported;
  MessageBox(hInstance, FileName, '', 0);
End;

function ContentEditValue(handle: thandle;
  FieldIndex, UnitIndex, FieldType: Integer; FieldValue: pchar;
  maxlen: Integer; flags: Integer; langidentifier: pchar): Integer;
  stdcall;
Begin
  Result := ft_NotSupported;
End;

{ ------------------------------------------------------------------------------ }
exports
  ContentGetDetectString,
  ContentGetSupportedField,
  ContentGetValue,
  ContentGetValueW,
  TranslitFile,
  ContentSetDefaultParams,
  ContentGetSupportedFieldFlags,
  ContentSetValue,
  // ContentSendStateInformation,
  ContentEditValue;
{ ContentGetDefaultSortOrder; }

procedure InitPlug(Z: integer);
begin
  case Z of
    DLL_PROCESS_ATTACH:
      begin
        PluginPath := GetModuleName(hInstance);

        ColumnNames := TStringList.Create;
        SetF := TIniFile.Create
          (IncludeTrailingPathDelimiter(ExtractFilePath(PluginPath)) +
          'wdx_translit.ini');
        try
          settings.UseMulti := SetF.ReadBool('Main', 'UseMulti', true);
          settings.ConvertSpaces := SetF.ReadBool('Main',
            'ConvertSpaces', false);
          settings.Mp3Enable := SetF.ReadBool('mp3', 'Enable', true);
          settings.mp3ttbused := IncludeTrailingPathDelimiter
            (ExtractFilePath(PluginPath)) + SetF.ReadString('Mp3',
            'ttbused', '');
          if not fileexists(settings.mp3ttbused) then
            settings.mp3ttbused := '';
          settings.Mp3Id3v2 := SetF.ReadBool('Mp3', 'id3v2', true);
          settings.Format := SetF.ReadString('Mp3', 'format',
            '%artist% - %title%');
          settings.StoredTTB := SetF.ReadString('Main', 'StoredTTB', '');
        finally
          SetF.Free;
        end;

        if FileExists(IncludeTrailingPathDelimiter(ExtractFilePath(PluginPath))
          + settings.StoredTTB) then
        begin
          AStoredTTB := TMemIniFile.Create(IncludeTrailingPathDelimiter
            (ExtractFilePath(PluginPath)) + settings.StoredTTB);
        end else begin
          AStoredTTB := nil;
          settings.StoredTTB := '';
        end;
      end;
    DLL_PROCESS_DETACH:
      begin
        FreeAndNil(AStoredTTB);
        ColumnNames.Free;
      end;
  end; // case
end;

begin
  DllProc := @InitPlug;
  InitPlug(DLL_PROCESS_ATTACH);
end.
