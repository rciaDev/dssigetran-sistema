unit MsMultipartParser; 
 
interface 
 
uses 
  Windows, Messages, SysUtils, Classes, HTTPApp, Contnrs; 
 
type 
  EClientConnectionDropped = class(Exception); 
  { Single HTTP File Object } 
  THTTPFile = class(TObject) 
  private 
    FFieldName: string; 
    FContentType: string; 
    FFileName: string; 
    FFileData: TStream; 
    procedure SetFileData(const Value: TStream); 
  public 
    constructor Create; 
    destructor Destroy;override; 
    procedure SaveToFile(SaveAsFile: string); 
    procedure SaveToStream(Stream: TStream); 
    property FieldName: string read FFieldName write FFieldName; 
    property ContentType: string read FContentType write FContentType; 
    property FileName: string read FFileName write FFileName; 
    property FileData: TStream read FFileData write SetFileData; 
  end; 
  { List Of HTTPFile Objects } 
  THTTPFiles = class(TObject) 
  private 
    FFileList: TList; 
    function GetCount: Integer; 
  protected 
    function GetItem(Index: Integer): THTTPFile; 
    procedure SetItem(Index: Integer; AObject: THTTPFile); 
  public 
    constructor Create; 
    destructor Destroy; override; 
    procedure Clear; 
    function Add(AObject: THTTPFile): Integer; 
    property Count: Integer read GetCount; 
    property Items[Index: Integer]: THTTPFile read GetItem write SetItem; default; 
  end; 
  { TMsMultipartFormParser } 
  TMsMultipartFormParser = class(TObject) 
  private 
    FHTTPFiles: THTTPFiles; 
    FContentFields: TStrings; 
  public 
    constructor	Create; 
    destructor Destroy;override; 
    procedure Clear; 
    procedure Parse(Request: TWebRequest); 
    property Files: THTTPFiles read FHTTPFiles; 
    property ContentFields: TStrings read FContentFields; 
  end; 
 
implementation 
 
{ THTTPFile } 
 
constructor THTTPFile.Create; 
begin 
  inherited; 
  FFileData := TMemoryStream.Create; 
end; 
 
destructor THTTPFile.Destroy; 
begin 
  FFileData.Free; 
  inherited; 
end; 
 
procedure THTTPFile.SaveToFile(SaveAsFile: string); 
begin 
  TMemoryStream(FFileData).SaveToFile(SaveAsFile); 
end; 
 
procedure THTTPFile.SaveToStream(Stream: TStream); 
begin 
  FileData.Position := 0; 
  TMemoryStream(FileData).SaveToStream(Stream); 
  Stream.Position := 0; 
end; 
 
procedure THTTPFile.SetFileData(const Value: TStream); 
begin 
  TMemoryStream(FFileData).Clear; 
  if Value <> nil then 
  begin 
    Value.Position := 0; 
    FFileData.CopyFrom(Value, Value.Size); 
  end; 
end; 
 
{ THTTPFiles } 
 
function THTTPFiles.Add(AObject: THTTPFile): Integer; 
begin 
  Result := FFileList.Add(AObject); 
end; 
 
procedure THTTPFiles.Clear; 
var 
  i: Integer; 
begin 
  for i := 0 to Pred(Count) do 
    GetItem(i).Free; 
  FFileList.Clear; 
end; 
 
constructor THTTPFiles.Create; 
begin 
  FFileList := TList.Create; 
end; 
 
destructor THTTPFiles.Destroy; 
begin 
  Clear; 
  FFileList.Free; 
  inherited; 
end; 
 
function THTTPFiles.GetCount: Integer; 
begin 
  Result := FFileList.Count; 
end; 
 
function THTTPFiles.GetItem(Index: Integer): THTTPFile; 
begin 
  Result :=  THTTPFile(FFileList[Index]); 
end; 
 
procedure THTTPFiles.SetItem(Index: Integer; AObject: THTTPFile); 
var 
  Obj: TObject; 
begin 
  Obj := TObject(FFileList[Index]); 
  FFileList[Index] := AObject; 
  if Obj <> nil then 
    TObject(Obj).Free; 
end; 
 
{ TMsMultipartFormParser } 
 
procedure TMsMultipartFormParser.Clear; 
begin 
  ContentFields.Clear; 
  Files.Clear; 
end; 
 
constructor TMsMultipartFormParser.Create; 
begin 
  inherited; 
  FHTTPFiles := THTTPFiles.Create; 
  FContentFields := TStringList.Create; 
end; 
 
destructor TMsMultipartFormParser.Destroy; 
begin 
  FHTTPFiles.Free; 
  FContentFields.Free; 
  inherited; 
end; 
 
procedure TMsMultipartFormParser.Parse(Request : TWebRequest); 
const 
  HeaderTerminator = #13#10#13#10; 
  LnHeaderTerminator = Length(HeaderTerminator); 
var 
  ContentStream: TMemoryStream;
  HTTPFile: THTTPFile; 
  TotalBytes: LongInt; 
  BytesRead: Longint; 
  HeaderInfoLn: Longint;
  ChunkSize: Longint; 
  Buffer: array of Byte; 
  HeaderInfo: string; 
  FieldNameInHeader: string; 
  ContentType: string; 
  FileNameInHeader: string; 
  HeaderDataTerminator: string; 
  sBuffer: AnsiString;
  sValue: AnsiString;
begin
  ContentStream := TMemoryStream.Create; 
  try 
    BytesRead := Length(Request.Content);
    ContentStream.Write(Request.Content[1], BytesRead); 
    TotalBytes := Request.ContentLength; 
    ContentStream.Size := TotalBytes; 
    if BytesRead < TotalBytes then 
    begin 
      SetLength(Buffer, TotalBytes - BytesRead); 
      repeat 
        ChunkSize := Request.ReadClient(Buffer[0], TotalBytes - BytesRead); 
        if ChunkSize <= 0 then Break; 
        ContentStream.Write(Buffer[0], ChunkSize); 
        Inc(BytesRead, ChunkSize); 
      until (TotalBytes = BytesRead); 
    end; 
 
    if TotalBytes - BytesRead > 0 then 
      raise EClientConnectionDropped.Create('Client Dropped Connection.'#13#10 + 
        'Total Bytes indicated by Header: ' + IntToStr(TotalBytes) + #13#10 + 
        'Total Bytes Read: ' + IntToStr(BytesRead)); 
 
    ContentStream.Position := 0;
    SetLength(sBuffer, ContentStream.Size);
    ContentStream.Read(Pointer(sBuffer)^, ContentStream.Size);
  finally
    ContentStream.Free;
  end;

  while Length(sBuffer) <> 0 do begin
    { Extract the Header from the ContentStream. There can be multiple "Headers"
      if multiple files are being uploaded or there are additonal form fields }
    BytesRead := Pos(HeaderTerminator, sBuffer) -1;
    if BytesRead = -1 then Break;
    HeaderInfo := LowerCase(Copy(sBuffer, 1, BytesRead));
    HeaderInfoLn := Length(HeaderInfo);
    Delete(sBuffer, 1, BytesRead + LnHeaderTerminator);

    FieldNameInHeader := '';
    ContentType := '';
    FileNameInHeader := '';
    { FieldNameInHeader }
    if (Pos('name="', HeaderInfo) > 0) then
    begin
      FieldNameInHeader := Copy(HeaderInfo, Pos('name="', HeaderInfo) + 6,
        HeaderInfoLn);
      Delete(FieldNameInHeader, Pos('"', FieldNameInHeader), Length(FieldNameInHeader));
    end;
    { ContentType }
    if (Pos('content-type: ', HeaderInfo) > 0) then
    begin
      ContentType := Copy(HeaderInfo, Pos('content-type: ', HeaderInfo) + 14,
        HeaderInfoLn);
    end;

    { FileNameInHeader }
    if (Pos('filename="', HeaderInfo) > 0) then
    begin
      FileNameInHeader := Copy(HeaderInfo, Pos('filename="', HeaderInfo) + 10,
        HeaderInfoLn);
      Delete(FileNameInHeader, pos('"', FileNameInHeader), Length(FileNameInHeader));
      FileNameInHeader := ExtractFileName(FileNameInHeader);
    end;

    { Set the HeaderDataTermininator if required }
    if (HeaderDataTerminator = '') then
      HeaderDataTerminator := #13#10 + Copy(HeaderInfo, 1, Pos(#13#10, HeaderInfo) -1);

    { Extract the data and put it in sBuffer }
    BytesRead := Pos(HeaderDataTerminator, sBuffer) -1;
    sValue := Copy(sBuffer, 1, BytesRead);
    Delete(sBuffer, 1, BytesRead + Length(HeaderDataTerminator));
    sValue := sBuffer;
    { sBuffer now contains the actual data }

    if (ContentType <> '') and (sValue <> '') then
    begin
      HTTPFile := THTTPFile.Create;
      with HTTPFile do
      begin
        FileData.Write(Pointer(sValue)^, Length(sValue));
        FileData.Position := 0;
        ContentType := ContentType;
        FieldName := FieldNameInHeader;
        FileName := FileNameInHeader;
        Files.Add(HTTPFile);
      end;
    end 
    else { Then this must be additional fields of the form } 
      ContentFields.Add(FieldNameInHeader + '=' + sValue); 
  end; { while Length(sBuffer) <> 0 do } 
end; 
 
end. 