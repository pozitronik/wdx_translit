{ *************************************************************************** }
{                                                                             }
{ Audio Tools Library (Freeware)                                              }
{ Class TID3v2 - for manipulating with ID3v2 tags                             }
{                                                                             }
{ Copyright (c) 2001,2002 by Jurgen Faul                                      }
{ E-mail: jfaul@gmx.de                                                        }
{ http://jfaul.de/atl                                                         }
{                                                                             }
{ Version 1.7 (2 October 2002)                                                }
{   - Added property TrackAnsiString                                              }
{                                                                             }
{ Version 1.6 (29 July 2002)                                                  }
{   - Reading support for Unicode                                             }
{   - Removed limitation for the track number                                 }
{                                                                             }
{ Version 1.5 (23 May 2002)                                                   }
{   - Support for padding                                                     }
{                                                                             }
{ Version 1.4 (24 March 2002)                                                 }
{   - Reading support for ID3v2.2.x & ID3v2.4.x tags                          }
{                                                                             }
{ Version 1.3 (16 February 2002)                                              }
{   - Fixed bug with property Comment                                         }
{   - Added info: composer, encoder, copyright, language, link                }
{                                                                             }
{ Version 1.2 (17 October 2001)                                               }
{   - Writing support for ID3v2.3.x tags                                      }
{   - Fixed bug with track number detection                                   }
{   - Fixed bug with tag reading                                              }
{                                                                             }
{ Version 1.1 (31 August 2001)                                                }
{   - Added public procedure ResetData                                        }
{                                                                             }
{ Version 1.0 (14 August 2001)                                                }
{   - Reading support for ID3v2.3.x tags                                      }
{   - Tag info: title, artist, album, track, year, genre, comment             }
{                                                                             }
{ *************************************************************************** }

unit ID3v2;

interface

uses
  Classes, SysUtils;

const
  TAG_VERSION_2_2 = 2;                               { Code for ID3v2.2.x tag }
  TAG_VERSION_2_3 = 3;                               { Code for ID3v2.3.x tag }
  TAG_VERSION_2_4 = 4;                               { Code for ID3v2.4.x tag }

type
  { Class TID3v2 }
  TID3v2 = class(TObject)
    private
      { Private declarations }
      FExists: Boolean;
      FVersionID: Byte;
      FSize: Integer;
      FTitle: AnsiString;
      FArtist: AnsiString;
      FAlbum: AnsiString;
      FTrack: Word;
      FTrackAnsiString: AnsiString;
      FYear: AnsiString;
      FGenre: AnsiString;
      FComment: AnsiString;
      FComposer: AnsiString;
      FEncoder: AnsiString;
      FCopyright: AnsiString;
      FLanguage: AnsiString;
      FLink: AnsiString;
      procedure FSetTitle(const NewTitle: AnsiString);
      procedure FSetArtist(const NewArtist: AnsiString);
      procedure FSetAlbum(const NewAlbum: AnsiString);
      procedure FSetTrack(const NewTrack: Word);
      procedure FSetYear(const NewYear: AnsiString);
      procedure FSetGenre(const NewGenre: AnsiString);
      procedure FSetComment(const NewComment: AnsiString);
      procedure FSetComposer(const NewComposer: AnsiString);
      procedure FSetEncoder(const NewEncoder: AnsiString);
      procedure FSetCopyright(const NewCopyright: AnsiString);
      procedure FSetLanguage(const NewLanguage: AnsiString);
      procedure FSetLink(const NewLink: AnsiString);
    public
      { Public declarations }
      constructor Create;                                     { Create object }
      procedure ResetData;                                   { Reset all data }
      function ReadFromFile(const FileName: WideString): Boolean;      { Load tag }
      function SaveToFile(const FileName: WideString): Boolean;        { Save tag }
      function RemoveFromFile(const FileName: WideString): Boolean;  { Delete tag }
      property Exists: Boolean read FExists;              { True if tag found }
      property VersionID: Byte read FVersionID;                { Version code }
      property Size: Integer read FSize;                     { Total tag size }
      property Title: AnsiString read FTitle write FSetTitle;        { Song title }
      property Artist: AnsiString read FArtist write FSetArtist;    { Artist name }
      property Album: AnsiString read FAlbum write FSetAlbum;       { Album title }
      property Track: Word read FTrack write FSetTrack;        { Track number }
      property TrackAnsiString: AnsiString read FTrackAnsiString; { Track number (AnsiString) }
      property Year: AnsiString read FYear write FSetYear;         { Release year }
      property Genre: AnsiString read FGenre write FSetGenre;        { Genre name }
      property Comment: AnsiString read FComment write FSetComment;     { Comment }
      property Composer: AnsiString read FComposer write FSetComposer; { Composer }
      property Encoder: AnsiString read FEncoder write FSetEncoder;     { Encoder }
      property Copyright: AnsiString read FCopyright write FSetCopyright;   { (c) }
      property Language: AnsiString read FLanguage write FSetLanguage; { Language }
      property Link: AnsiString read FLink write FSetLink;             { URL link }
  end;

implementation

const
  { ID3v2 tag ID }
  ID3V2_ID = 'ID3';

  { Max. number of supported tag frames }
  ID3V2_FRAME_COUNT = 16;

  { Names of supported tag frames (ID3v2.3.x & ID3v2.4.x) }
  ID3V2_FRAME_NEW: array [1..ID3V2_FRAME_COUNT] of AnsiString =
    ('TIT2', 'TPE1', 'TALB', 'TRCK', 'TYER', 'TCON', 'COMM', 'TCOM', 'TENC',
     'TCOP', 'TLAN', 'WXXX', 'TDRC', 'TOPE', 'TIT1', 'TOAL');

  { Names of supported tag frames (ID3v2.2.x) }
  ID3V2_FRAME_OLD: array [1..ID3V2_FRAME_COUNT] of AnsiString =
    ('TT2', 'TP1', 'TAL', 'TRK', 'TYE', 'TCO', 'COM', 'TCM', 'TEN',
     'TCR', 'TLA', 'WXX', 'TOR', 'TOA', 'TT1', 'TOT');

  { Max. tag size for saving }
  ID3V2_MAX_SIZE = 4096;

  { Unicode ID }
  UNICODE_ID = #1;

type
  { Frame header (ID3v2.3.x & ID3v2.4.x) }
  FrameHeaderNew = record
    ID: array [1..4] of AnsiChar;                                      { Frame ID }
    Size: Integer;                                    { Size excluding header }
    Flags: Word;                                                      { Flags }
  end;

  { Frame header (ID3v2.2.x) }
  FrameHeaderOld = record
    ID: array [1..3] of AnsiChar;                                      { Frame ID }
    Size: array [1..3] of Byte;                       { Size excluding header }
  end;

  { ID3v2 header data - for internal use }
  TagInfo = record
    { Real structure of ID3v2 header }
    ID: array [1..3] of AnsiChar;                                  { Always "ID3" }
    Version: Byte;                                           { Version number }
    Revision: Byte;                                         { Revision number }
    Flags: Byte;                                               { Flags of tag }
    Size: array [1..4] of Byte;                   { Tag size excluding header }
    { Extended data }
    FileSize: Integer;                                    { File size (bytes) }
    Frame: array [1..ID3V2_FRAME_COUNT] of AnsiString;  { Information from frames }
    NeedRewrite: Boolean;                           { Tag should be rewritten }
    PaddingSize: Integer;                              { Padding size (bytes) }
  end;

{ ********************* Auxiliary functions & procedures ******************** }

function ReadHeader(const FileName: WideString; var Tag: TagInfo): Boolean;
var
  SourceFile: file;
  Transferred: Integer;
begin
  try
    Result := true;
    { Set read-access and open file }
    AssignFile(SourceFile, FileName);
    FileMode := 0;
    Reset(SourceFile, 1);
    { Read header and get file size }
    BlockRead(SourceFile, Tag, 10, Transferred);
    Tag.FileSize := FileSize(SourceFile);
    CloseFile(SourceFile);
    { if transfer is not complete }
    if Transferred < 10 then Result := false;
  except
    { Error }
    Result := false;
  end;
end;

{ --------------------------------------------------------------------------- }

function GetTagSize(const Tag: TagInfo): Integer;
begin
  { Get total tag size }
  Result :=
    Tag.Size[1] * $200000 +
    Tag.Size[2] * $4000 +
    Tag.Size[3] * $80 +
    Tag.Size[4] + 10;
  if Tag.Flags and $10 = $10 then Inc(Result, 10);
  if Result > Tag.FileSize then Result := 0;
end;

{ --------------------------------------------------------------------------- }

procedure SetTagItem(const ID, Data: AnsiString; var Tag: TagInfo);
var
  Iterator: Byte;
  FrameID: AnsiString;
begin
  { Set tag item if supported frame found }
  for Iterator := 1 to ID3V2_FRAME_COUNT do
  begin
    if Tag.Version > TAG_VERSION_2_2 then
      FrameID := ID3V2_FRAME_NEW[Iterator]
    else
      FrameID := ID3V2_FRAME_OLD[Iterator];
    if (FrameID = ID) and (Data[1] <= UNICODE_ID) then
      Tag.Frame[Iterator] := Data;
  end;
end;

{ --------------------------------------------------------------------------- }

function Swap32(const Figure: Integer): Integer;
var
  ByteArray: array [1..4] of Byte absolute Figure;
begin
  { Swap 4 bytes }
  Result :=
    ByteArray[1] * $1000000 +
    ByteArray[2] * $10000 +
    ByteArray[3] * $100 +
    ByteArray[4];
end;

{ --------------------------------------------------------------------------- }

procedure ReadFramesNew(const FileName: WideString; var Tag: TagInfo);
var
  SourceFile: file;
  Frame: FrameHeaderNew;
  Data: array [1..500] of AnsiChar;
  DataPosition, DataSize: Integer;
begin
  { Get information from frames (ID3v2.3.x & ID3v2.4.x) }
  try
    { Set read-access, open file }
    AssignFile(SourceFile, FileName);
    FileMode := 0;
    Reset(SourceFile, 1);
    Seek(SourceFile, 10);
    while (FilePos(SourceFile) < GetTagSize(Tag)) and (not EOF(SourceFile)) do
    begin
      FillChar(Data, SizeOf(Data), 0);
      { Read frame header and check frame ID }
      BlockRead(SourceFile, Frame, 10);
      if not (Frame.ID[1] in ['A'..'Z']) then break;
      { Note data position and determine significant data size }
      DataPosition := FilePos(SourceFile);
      if Swap32(Frame.Size) > SizeOf(Data) then DataSize := SizeOf(Data)
      else DataSize := Swap32(Frame.Size);
      { Read frame data and set tag item if frame supported }
      BlockRead(SourceFile, Data, DataSize);
      if Frame.Flags and $8000 <> $8000 then SetTagItem(Frame.ID, Data, Tag);
      Seek(SourceFile, DataPosition + Swap32(Frame.Size));
    end;
    CloseFile(SourceFile);
  except
  end;
end;

{ --------------------------------------------------------------------------- }

procedure ReadFramesOld(const FileName: WideString; var Tag: TagInfo);
var
  SourceFile: file;
  Frame: FrameHeaderOld;
  Data: array [1..500] of AnsiChar;
  DataPosition, FrameSize, DataSize: Integer;
begin
  { Get information from frames (ID3v2.2.x) }
  try
    { Set read-access, open file }
    AssignFile(SourceFile, FileName);
    FileMode := 0;
    Reset(SourceFile, 1);
    Seek(SourceFile, 10);
    while (FilePos(SourceFile) < GetTagSize(Tag)) and (not EOF(SourceFile)) do
    begin
      FillChar(Data, SizeOf(Data), 0);
      { Read frame header and check frame ID }
      BlockRead(SourceFile, Frame, 6);
      if not (Frame.ID[1] in ['A'..'Z']) then break;
      { Note data position and determine significant data size }
      DataPosition := FilePos(SourceFile);
      FrameSize := Frame.Size[1] shl 16 + Frame.Size[2] shl 8 + Frame.Size[3];
      if FrameSize > SizeOf(Data) then DataSize := SizeOf(Data)
      else DataSize := FrameSize;
      { Read frame data and set tag item if frame supported }
      BlockRead(SourceFile, Data, DataSize);
      SetTagItem(Frame.ID, Data, Tag);
      Seek(SourceFile, DataPosition + FrameSize);
    end;
    CloseFile(SourceFile);
  except
  end;
end;

{ --------------------------------------------------------------------------- }

function GetANSI(const Source: AnsiString): AnsiString;
var
  Index: Integer;
  FirstByte, SecondByte: Byte;
  UnicodeAnsiChar: WideChar;
begin
  { Convert AnsiString from unicode if needed and trim spaces }
  if (Length(Source) > 0) and (Source[1] = UNICODE_ID) then
  begin
    Result := '';
    for Index := 1 to ((Length(Source) - 1) div 2) do
    begin
      FirstByte := Ord(Source[Index * 2]);
      SecondByte := Ord(Source[Index * 2 + 1]);
      UnicodeAnsiChar := WideChar(FirstByte or (SecondByte shl 8));
      if UnicodeAnsiChar = #0 then break;
      if FirstByte < $FF then Result := Result + UnicodeAnsiChar;
    end;
    Result := Trim(Result);
  end
  else
    Result := Trim(Source);
end;

{ --------------------------------------------------------------------------- }

function GetContent(const Content1, Content2: AnsiString): AnsiString;
begin
  { Get content preferring the first content }
  Result := GetANSI(Content1);
  if Result = '' then Result := GetANSI(Content2);
end;

{ --------------------------------------------------------------------------- }

function ExtractTrack(const TrackAnsiString: AnsiString): Word;
var
  Track: AnsiString;
  Index, Value, Code: Integer;
begin
  { Extract track from AnsiString }
  Track := GetANSI(TrackAnsiString);
  Index := Pos('/', Track);
  if Index = 0 then Val(Track, Value, Code)
  else Val(Copy(Track, 1, Index - 1), Value, Code);
  if Code = 0 then Result := Value
  else Result := 0;
end;

{ --------------------------------------------------------------------------- }

function ExtractYear(const YearAnsiString, DateAnsiString: AnsiString): AnsiString;
begin
  { Extract year from AnsiStrings }
  Result := GetANSI(YearAnsiString);
  if Result = '' then Result := Copy(GetANSI(DateAnsiString), 1, 4);
end;

{ --------------------------------------------------------------------------- }

function ExtractGenre(const GenreAnsiString: AnsiString): AnsiString;
begin
  { Extract genre from AnsiString }
  Result := GetANSI(GenreAnsiString);
  if Pos(')', Result) > 0 then Delete(Result, 1, LastDelimiter(')', Result));
end;

{ --------------------------------------------------------------------------- }

function ExtractText(const SourceAnsiString: AnsiString; LanguageID: Boolean): AnsiString;
var
  Source, Separator: AnsiString;
  EncodingID: AnsiChar;
begin
  { Extract significant text data from a complex field }
  Source := SourceAnsiString;
  Result := '';
  if Length(Source) > 0 then
  begin
    EncodingID := Source[1];
    if EncodingID = UNICODE_ID then Separator := #0#0
    else Separator := #0;
    if LanguageID then  Delete(Source, 1, 4)
    else Delete(Source, 1, 1);
    Delete(Source, 1, Pos(Separator, Source) + Length(Separator) - 1);
    Result := GetANSI(EncodingID + Source);
  end;
end;

{ --------------------------------------------------------------------------- }

procedure BuildHeader(var Tag: TagInfo);
var
  Iterator, TagSize: Integer;
begin
  { Calculate new tag size (without padding) }
  TagSize := 10;
  for Iterator := 1 to ID3V2_FRAME_COUNT do
    if Tag.Frame[Iterator] <> '' then
      Inc(TagSize, Length(Tag.Frame[Iterator]) + 11);
  { Check for ability to change existing tag }
  Tag.NeedRewrite :=
    (Tag.ID <> ID3V2_ID) or
    (GetTagSize(Tag) < TagSize) or
    (GetTagSize(Tag) > ID3V2_MAX_SIZE);
  { Calculate padding size and set padded tag size }
  if Tag.NeedRewrite then Tag.PaddingSize := ID3V2_MAX_SIZE - TagSize
  else Tag.PaddingSize := GetTagSize(Tag) - TagSize;
  if Tag.PaddingSize > 0 then Inc(TagSize, Tag.PaddingSize);
  { Build tag header }
  Tag.ID := ID3V2_ID;
  Tag.Version := TAG_VERSION_2_3;
  Tag.Revision := 0;
  Tag.Flags := 0;
  { Convert tag size }
  for Iterator := 1 to 4 do
    Tag.Size[Iterator] := ((TagSize - 10) shr ((4 - Iterator) * 7)) and $7F;
end;

{ --------------------------------------------------------------------------- }

function ReplaceTag(const FileName: WideString; TagData: TStream): Boolean;
var
  Destination: TFileStream;
begin
  { Replace old tag with new tag data }
  Result := false;
  if (not FileExists(FileName)) or (FileSetAttr(FileName, 0) <> 0) then exit;
  try
    TagData.Position := 0;
    Destination := TFileStream.Create(FileName, fmOpenReadWrite);
    Destination.CopyFrom(TagData, TagData.Size);
    Destination.Free;
    Result := true;
  except
    { Access error }
  end;
end;

{ --------------------------------------------------------------------------- }

function RebuildFile(const FileName: WideString; TagData: TStream): Boolean;
var
  Tag: TagInfo;
  Source, Destination: TFileStream;
  BufferName: WideString;
begin
  { Rebuild file with old file data and new tag data (optional) }
  Result := false;
  if (not FileExists(FileName)) or (FileSetAttr(FileName, 0) <> 0) then exit;
  if not ReadHeader(FileName, Tag) then exit;
  if (TagData = nil) and (Tag.ID <> ID3V2_ID) then exit;
  try
    { Create file streams }
    BufferName := FileName + '~';
    Source := TFileStream.Create(FileName, fmOpenRead);
    Destination := TFileStream.Create(BufferName, fmCreate);
    { Copy data blocks }
    if Tag.ID = ID3V2_ID then Source.Seek(GetTagSize(Tag), soFromBeginning);
    if TagData <> nil then Destination.CopyFrom(TagData, 0);
    Destination.CopyFrom(Source, Source.Size - Source.Position);
    { Free resources }
    Source.Free;
    Destination.Free;
    { Replace old file and delete temporary file }
    if (DeleteFile(FileName)) and (RenameFile(BufferName, FileName)) then
      Result := true
    else
      raise Exception.Create('');
  except
    { Access error }
    if FileExists(BufferName) then DeleteFile(BufferName);
  end;
end;

{ --------------------------------------------------------------------------- }

function SaveTag(const FileName: WideString; Tag: TagInfo): Boolean;
var
  TagData: TStringStream;
  Iterator, FrameSize: Integer;
  Padding: array [1..ID3V2_MAX_SIZE] of Byte;
begin
  { Build and write tag header and frames to stream }
  TagData := TStringStream.Create('', TEncoding.ANSI);
  BuildHeader(Tag);
  TagData.Write(Tag, 10);
  for Iterator := 1 to ID3V2_FRAME_COUNT do
    if Tag.Frame[Iterator] <> '' then
    begin
      TagData.WriteString(ID3V2_FRAME_NEW[Iterator]);
      FrameSize := Swap32(Length(Tag.Frame[Iterator]) + 1);
      TagData.Write(FrameSize, SizeOf(FrameSize));
      TagData.WriteString(#0#0#0 + Tag.Frame[Iterator]);
    end;
  { Add padding }
  FillChar(Padding, SizeOf(Padding), 0);
  if Tag.PaddingSize > 0 then TagData.Write(Padding, Tag.PaddingSize);
  { Rebuild file or replace tag with new tag data }
  if Tag.NeedRewrite then Result := RebuildFile(FileName, TagData)
  else Result := ReplaceTag(FileName, TagData);
  TagData.Free;
end;

{ ********************** Private functions & procedures ********************* }

procedure TID3v2.FSetTitle(const NewTitle: AnsiString);
begin
  { Set song title }
  FTitle := Trim(NewTitle);
end;

{ --------------------------------------------------------------------------- }

procedure TID3v2.FSetArtist(const NewArtist: AnsiString);
begin
  { Set artist name }
  FArtist := Trim(NewArtist);
end;

{ --------------------------------------------------------------------------- }

procedure TID3v2.FSetAlbum(const NewAlbum: AnsiString);
begin
  { Set album title }
  FAlbum := Trim(NewAlbum);
end;

{ --------------------------------------------------------------------------- }

procedure TID3v2.FSetTrack(const NewTrack: Word);
begin
  { Set track number }
  FTrack := NewTrack;
end;

{ --------------------------------------------------------------------------- }

procedure TID3v2.FSetYear(const NewYear: AnsiString);
begin
  { Set release year }
  FYear := Trim(NewYear);
end;

{ --------------------------------------------------------------------------- }

procedure TID3v2.FSetGenre(const NewGenre: AnsiString);
begin
  { Set genre name }
  FGenre := Trim(NewGenre);
end;

{ --------------------------------------------------------------------------- }

procedure TID3v2.FSetComment(const NewComment: AnsiString);
begin
  { Set comment }
  FComment := Trim(NewComment);
end;

{ --------------------------------------------------------------------------- }

procedure TID3v2.FSetComposer(const NewComposer: AnsiString);
begin
  { Set composer name }
  FComposer := Trim(NewComposer);
end;

{ --------------------------------------------------------------------------- }

procedure TID3v2.FSetEncoder(const NewEncoder: AnsiString);
begin
  { Set encoder name }
  FEncoder := Trim(NewEncoder);
end;

{ --------------------------------------------------------------------------- }

procedure TID3v2.FSetCopyright(const NewCopyright: AnsiString);
begin
  { Set copyright information }
  FCopyright := Trim(NewCopyright);
end;

{ --------------------------------------------------------------------------- }

procedure TID3v2.FSetLanguage(const NewLanguage: AnsiString);
begin
  { Set language }
  FLanguage := Trim(NewLanguage);
end;

{ --------------------------------------------------------------------------- }

procedure TID3v2.FSetLink(const NewLink: AnsiString);
begin
  { Set URL link }
  FLink := Trim(NewLink);
end;

{ ********************** Public functions & procedures ********************** }

constructor TID3v2.Create;
begin
  { Create object }
  inherited;
  ResetData;
end;

{ --------------------------------------------------------------------------- }

procedure TID3v2.ResetData;
begin
  { Reset all variables }
  FExists := false;
  FVersionID := 0;
  FSize := 0;
  FTitle := '';
  FArtist := '';
  FAlbum := '';
  FTrack := 0;
  FTrackAnsiString := '';
  FYear := '';
  FGenre := '';
  FComment := '';
  FComposer := '';
  FEncoder := '';
  FCopyright := '';
  FLanguage := '';
  FLink := '';
end;

{ --------------------------------------------------------------------------- }

function TID3v2.ReadFromFile(const FileName: WideString): Boolean;
var
  Tag: TagInfo;
begin
  { Reset data and load header from file to variable }
  ResetData;
  Result := ReadHeader(FileName, Tag);
  { Process data if loaded and header valid }
  if (Result) and (Tag.ID = ID3V2_ID) then
  begin
    FExists := true;
    { Fill properties with header data }
    FVersionID := Tag.Version;
    FSize := GetTagSize(Tag);
    { Get information from frames if version supported }
    if (FVersionID in [TAG_VERSION_2_2..TAG_VERSION_2_4]) and (FSize > 0) then
    begin
      if FVersionID > TAG_VERSION_2_2 then ReadFramesNew(FileName, Tag)
      else ReadFramesOld(FileName, Tag);
      FTitle := GetContent(Tag.Frame[1], Tag.Frame[15]);
      FArtist := GetContent(Tag.Frame[2], Tag.Frame[14]);
      FAlbum := GetContent(Tag.Frame[3], Tag.Frame[16]);
      FTrack := ExtractTrack(Tag.Frame[4]);
      FTrackAnsiString := GetANSI(Tag.Frame[4]);
      FYear := ExtractYear(Tag.Frame[5], Tag.Frame[13]);
      FGenre := ExtractGenre(Tag.Frame[6]);
      FComment := ExtractText(Tag.Frame[7], true);
      FComposer := GetANSI(Tag.Frame[8]);
      FEncoder := GetANSI(Tag.Frame[9]);
      FCopyright := GetANSI(Tag.Frame[10]);
      FLanguage := GetANSI(Tag.Frame[11]);
      FLink := ExtractText(Tag.Frame[12], false);
    end;
  end;
end;

{ --------------------------------------------------------------------------- }

function TID3v2.SaveToFile(const FileName: WideString): Boolean;
var
  Tag: TagInfo;
begin
  { Check for existing tag }
  FillChar(Tag, SizeOf(Tag), 0);
  ReadHeader(FileName, Tag);
  { Prepare tag data and save to file }
  Tag.Frame[1] := FTitle;
  Tag.Frame[2] := FArtist;
  Tag.Frame[3] := FAlbum;
  if FTrack > 0 then Tag.Frame[4] := IntToStr(FTrack);
  Tag.Frame[5] := FYear;
  Tag.Frame[6] := FGenre;
  if FComment <> '' then Tag.Frame[7] := 'eng' + #0 + FComment;
  Tag.Frame[8] := FComposer;
  Tag.Frame[9] := FEncoder;
  Tag.Frame[10] := FCopyright;
  Tag.Frame[11] := FLanguage;
  if FLink <> '' then Tag.Frame[12] := #0 + FLink;
  Result := SaveTag(FileName, Tag);
end;

{ --------------------------------------------------------------------------- }

function TID3v2.RemoveFromFile(const FileName: WideString): Boolean;
begin
  { Remove tag from file }
  Result := RebuildFile(FileName, nil);
end;

end.
