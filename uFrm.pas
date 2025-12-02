unit uFrm;

interface

uses
  Winapi.Messages, System.SysUtils, System.Variants,IniFiles,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.AppEvnts, Vcl.StdCtrls, IdHTTPWebBrokerBridge, Web.HTTPApp,
  Soap.InvokeRegistry, Soap.Rio, Soap.SOAPHTTPClient, Data.DB, Data.SqlExpr,
  Maskutils, Vcl.ExtCtrls,System.NetEncoding,jpeg, Vcl.Menus, Data.FMTBcd,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  IdCustomTCPServer, IdTCPServer,IdContext, IdServerIOHandler, IdSSL,
  IdSSLOpenSSL,IdSSLOpenSSLHeaders, ACBrBase, ACBrDFe, ACBrCTe, IPPeerServer,
  Datasnap.DSCommonServer, Datasnap.DSHTTP,System.JSON,IdIOHandler,
  IdIOHandlerStack,  REST.JSON;

type
  TfrmPrin = class(TForm)
    bIni: TButton;
    bPare: TButton;
    EditPort: TEdit;
    Label1: TLabel;
    ApplicationEvents1: TApplicationEvents;
    pnlJS: TPanel;
    pnlBancos: TPanel;
    chkAtualizaBancos: TCheckBox;
    TAtualizaDB: TTimer;
    chkCrm: TCheckBox;
    PopupMenu2: TPopupMenu;
    At1: TMenuItem;
    TMensagem: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure bIniClick(Sender: TObject);
    procedure bPareClick(Sender: TObject);
    procedure GravaLog(cErro:String);
    procedure ButtonOpenBrowserClick(Sender: TObject);
    procedure AtualizarJS1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DoParseAuthentication(AContext: TIdContext; const AAuthType, AAuthData: String; var VUsername, VPassword: String; var VHandled: Boolean);
    procedure OnGetSSLPassword(var APassword: String);
    procedure TAtualizaDBTimer(Sender: TObject);
    procedure AtualizaBancos();
    procedure EnviaMensagens();
    procedure AtualizaBancoCliente(qCLI:TSQLQuery);
    procedure CriaPastasCliente(qCLI:TSQLQuery);
    procedure AtualizaBaseLimpa();
    procedure ConfiguraConexaoBaseNova(cCam,cUsu,cSen: String;cDB:TSQLConnection);
    function ScriptBase(qAUX:TSQLQuery):TStringList;
    function ExtractFilePathFromStr(const inputStr: string): string;
    procedure EditPortExit(Sender: TObject);
    procedure chkAtualizaBancosClick(Sender: TObject);
    procedure chkCrmClick(Sender: TObject);

    function GeraProcedureTiraAcentos():String;
    procedure At1Click(Sender: TObject);
    procedure TMensagemTimer(Sender: TObject);

  private
    FServer: TIdHTTPWebBrokerBridge;
    procedure StartServer;
    { Private declarations }
  public
    { Public declarations }
    dbBan,dbGsm,dbUsu,dbSen,sEmp,sPort:String;
    cUrlCRM     : String;
    sAtualizaDB : String;
    CERT_PATH   : String;


  end;

  function SoNumero(sNum:String):String;
  function FormataCPFCNPJ(vr:String):String;
  function ConverteBase64(sFileName:string):String;
  function SQLString(cSQL:String;qSTRING:TSQLQuery):String;
  function IsTokenValid(sToken:String):Boolean;
  function iif(lCond: Boolean; cStr1, cStr2: String): String;

  procedure GravaIni(Sec,Cam,Dado : String);


var
  frmPrin: TfrmPrin;
  setPar: TFormatSettings;
  sAtualizaCRM: String;

  const
    TOKEN_META = 'EAAI8tVOUlDQBABZB8bQcgiiQcGpb06ZB2YdmGimzXbkxnyUk8qIa7rMUpbEsABZA4MTcNxiWFr9YXgp2BnS7aE1m8aohrVwQJdwlC0gCZBrCz3YizcU7B45ICGW27DndTJm49U5ZAifKbDZC4PArYkCYheTDuZA2dzU0OdpYApC2eO1G2koV9jY';
    ID_META = '106059639186918';



implementation

{$R *.dfm}

uses
  WinApi.Windows, Winapi.ShellApi, Datasnap.DSSession, uReceitaWs;

procedure TfrmPrin.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
begin
  bIni.Enabled := not FServer.Active;
  bPare.Enabled := FServer.Active;
  EditPort.Enabled := not FServer.Active;
end;
function ConverteBase64(sFileName:string):String;
var
  sResult:String;
  iStream,oStream:TStream;
  sFile:String;
  sStrList:TStringList;
begin
  iStream := TFileStream.Create(sFileName, fmOpenRead);
  sStrList := TStringList.Create;
  try
    sFile:=FormatDateTime('ddmmyyy',now);
    oStream := TFileStream.Create(sFile, fmCreate);
    try
      TNetEncoding.Base64.Encode(iStream,oStream);
    finally
      oStream.Free;
    end;
    sStrList.LoadFromFile(sFile);
    Result:=sStrList.Text;

  finally
    iStream.Free;
    DeleteFile(PChar(sFile));
  end;

end;
//procedure TfrmPrin.Button1Click(Sender: TObject);
//var
//  cFile:String;
//  cName:String;
//  cBase64:string;
//begin
//   cFile  :='D:/Apache2.4/htdocs/doc/202107/ARQ03969457.210704093051.000_DOC-2.pdf';
//   cName  :=ExtractFileName(cFile);
//   cBase64:=ConverteBase64(cFile);
//   Memo2.Text:=cBase64;
//
//end;

procedure TfrmPrin.ButtonOpenBrowserClick(Sender: TObject);
var
  LURL: string;
begin
  StartServer;
  LURL := Format('http://localhost:%s', [EditPort.Text]);
  ShellExecute(0,
        nil,
        PChar(LURL), nil, nil, SW_SHOWNOACTIVATE);
end;


procedure TfrmPrin.chkAtualizaBancosClick(Sender: TObject);
begin

   GravaIni('Sistema','AtualizaBancos', iif(chkAtualizaBancos.Checked,'S','N'));
end;

procedure TfrmPrin.chkCrmClick(Sender: TObject);
begin
   GravaIni('Sistema','AtualizaCRM', iif(chkCrm.Checked,'S','N'));
end;

procedure ConfConexao(cn: TSQLConnection);
begin
   cn.LoadParamsOnConnect:=false;
   cn.ConnectionName:= 'FBConnection';
   cn.DriverName    := 'Firebird';
   cn.LibraryName   := 'dbxfb.dll';
   cn.VendorLib     := 'fbclient.dll';
   cn.Params.Values['Database']  := frmPrin.dbBan;
   cn.Params.Values['User_Name'] := frmPrin.dbUsu;
   cn.Params.Values['Password']  := frmPrin.dbSen;
   cn.Params.Values['IsolationLevel']  := 'ReadCommited';
   cn.LoginPrompt := False;
end;


procedure TfrmPrin.bIniClick(Sender: TObject);
begin
  StartServer;
end;

procedure TerminateThreads;
begin
  if TDSSessionManager.Instance <> nil then
    TDSSessionManager.Instance.TerminateAllSessions;
end;

procedure TfrmPrin.bPareClick(Sender: TObject);
begin
  TerminateThreads;
  FServer.Active := False;
  FServer.Bindings.Clear;   
end;

procedure GravaIni(Sec,Cam,Dado : String);
var Ini: TIniFile;
begin
   Ini := TIniFile.Create(ExtractFilePath(ParamStr(0))+'dsSigetran.ini');
   try
      Ini.WriteString(Sec,Cam,Dado);
   finally
      Ini.Free;
   end;
end;

function iif(lCond: Boolean; cStr1, cStr2: String): String;
Begin
   if lCond then
      result := cStr1
   Else
      result := cStr2;
end;

procedure TfrmPrin.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
  LIOHandleSSL: TIdServerIOHandlerSSLOpenSSL;
begin
   CERT_PATH    := ExtractFilePath(ParamStr(0))+'ssl\';
   LIOHandleSSL := TIdServerIOHandlerSSLOpenSSL.Create(Self);
   try
      try
         FServer      := TIdHTTPWebBrokerBridge.Create(Self);
         FServer.OnParseAuthentication := DoParseAuthentication;
//
//         if(not FileExists('\Projetos\dsSigetran\dsSigetran.dproj'))then begin
//            LIOHandleSSL.SSLOptions.CertFile := CERT_PATH + 'certificate.crt';
//            LIOHandleSSL.SSLOptions.RootCertFile := CERT_PATH + 'ca_bundle.ca';
//            LIOHandleSSL.SSLOptions.KeyFile := CERT_PATH + 'private.key';
//
//            IdOpenSSLSetLibPath(ExtractFilePath(ParamStr(0)));
//
//            // sslvTLSv1_2
//            LIOHandleSSL.SSLOptions.Method      := sslvTLSv1_2;
//            LIOHandleSSL.SSLOptions.SSLVersions := [sslvTLSv1_2];
//            LIOHandleSSL.SSLOptions.Mode := sslmUnassigned;
//            LIOHandleSSL.SSLOptions.CipherList  := 'HIGH:!SSLv2:!aNULL:!eNULL:!3DES';
//            LIOHandleSSL.SSLOptions.VerifyMode  := [];
//            LIOHandleSSL.SSLOptions.VerifyDepth := 0;
//
//            FServer.IOHandler := LIOHandleSSL;
//         end;


         if(not DirectoryExists('.\clientes\CTe\'))then
            ForceDirectories('.\clientes\CTe\');
         if(not DirectoryExists('.\clientes\MDFe\'))then
            ForceDirectories('.\clientes\MDFe\');

         Ini   := TIniFile.Create(ExtractFilePath(ParamStr(0))+'dsSigetran.ini');
         dbBan := Ini.ReadString('Sistema', 'Banco',   dbBan);
         dbUsu := Ini.ReadString('Sistema', 'Usuario', dbUsu);
         dbSen := Ini.ReadString('Sistema', 'Password',dbSen);
         sEmp  := Ini.ReadString('Sistema', 'Empresa',  sEmp);
         sPort := Ini.ReadString('Sistema', 'Porta',   '8086');
         cUrlCRM       := Ini.ReadString('Sistema', 'URL_CRM', cUrlCRM);
         sAtualizaDB   := Ini.ReadString('Sistema', 'AtualizaBancos', sAtualizaDB);
         sAtualizaCRM  := Ini.ReadString('Sistema', 'AtualizaCRM', sAtualizaCRM);
         EditPort.Text := sPort;
         chkAtualizaBancos.Checked := false;

         if(sAtualizaDB = 'S')then
            chkAtualizaBancos.Checked := true;

         bIni.Click;
      except
         on E: EIdOSSLCouldNotLoadSSLLibrary do begin
            GravaLog('Erro EIdOSSLCouldNotLoadSSLLibrary:'+sLineBreak+
                     'Vers�o OpenSSL:'+OpenSSLVersion()+sLineBreak+'' +
                     'Erro:'+WhichFailedToLoad());
            ShowMessage(e.Message);
         end;

         on E: Exception do begin
            GravaLog('Erro aon inicializar dsSigetran erro:'+e.Message);
         end;
      end;
   finally
      Ini.Free;
      //OHandleSSL.Free;
   end;

   setPar.DateSeparator := '/';
   setPar.ShortDateFormat := 'dd/mm/yy';
   setPar.DecimalSeparator := ',';
   setPar.ThousandSeparator := '.';
   setPar.TimeSeparator := ':';
end;


procedure TfrmPrin.OnGetSSLPassword(var APassword: String);
begin
  APassword := '';
end;

function IsTokenValid(sToken:String):Boolean;
begin
  result := true;
end;
procedure TfrmPrin.DoParseAuthentication(AContext: TIdContext; const AAuthType, AAuthData: String; var VUsername, VPassword: String; var VHandled: Boolean);
begin
    VHandled := AAuthType.Equals('Bearer') and IsTokenValid(AAuthData);
end;


procedure TfrmPrin.FormShow(Sender: TObject);
begin
   pnlJS.Visible  := false;
   frmPrin.Width  := 370;
   frmPrin.Height := 210;
end;

function TfrmPrin.GeraProcedureTiraAcentos: String;
begin
   Result := 'CREATE OR alter procedure TIRA_ACENTOS (DADO varchar(512) = '''') '+
   'returns ( '+
   '    RETORNO varchar(512)) '+
   'as '+
   'declare variable COM_ACENTO varchar(40) = ''������������������������������''; '+
   'declare variable SEM_ACENTO varchar(40) = ''aaeouaoaeioucuAAEOUAOAEIOUCUNn''; '+
   'declare variable LETRA varchar(1) = ''''; '+
   'begin '+
   '   RETORNO = ''''; '+
   '   While (DADO<>'''') do '+
   '   begin '+
   '      Select case substring(:DADO from 1 for 1) '+
   '            when ''�'' then '+
   '                 ''a'' '+
   '            when ''�'' then '+
   '                 ''a'' '+
   '            when ''�'' then '+
   '                 ''a'' '+
   '            when ''�'' then '+
   '                 ''a'' '+
   '            when ''�'' then '+
   '                 ''A'' '+
   '            when ''�'' then '+
   '                 ''A'' '+
   '            when ''�'' then '+
   '                 ''A'' '+
   '            when ''�'' then '+
   '                 ''e'' '+
   '            when ''�'' then '+
   '                 ''e'' '+
   '            when ''�'' then '+
   '                 ''e'' '+
   '            when ''�'' then '+
   '                 ''E'' '+
   '            when ''�'' then '+
   '                 ''o'' '+
   '            when ''�'' then '+
   '                 ''o'' '+
   '            when ''�'' then '+
   '                 ''o'' '+
   '            when ''�'' then '+
   '                 ''O'' '+
   '            when ''�'' then '+
   '                 ''O'' '+
   '            when ''�'' then '+
   '                 ''O'' '+
   '            when ''�'' then '+
   '                 ''u'' '+
   '            when ''�'' then '+
   '                 ''u'' '+
   '            when ''�'' then '+
   '                 ''u'' '+
   '            when ''�'' then '+
   '                 ''U'' '+
   '            when ''�'' then '+
   '                 ''U'' '+
   '            when ''�'' then '+
   '                 ''U'' '+
   '            when ''�'' then '+
   '                 ''i'' '+
   '            when ''�'' then '+
   '                 ''I'' '+
   '            when ''�'' then '+
   '                 ''c'' '+
   '            when ''�'' then '+
   '                 ''C'' '+
   '            when ''�'' then '+
   '                 ''n'' '+
   '            when ''�'' then '+
   '                 ''N'' '+
   '            else '+
   '               substring(:DADO from 1 for 1) '+
   '            end '+
   '      from rdb$database into :LETRA; '+
   ' '+
   '      RETORNO = RETORNO || LETRA; '+
   ' '+
   '      DADO  = substring(DADO from 2 for 512); '+
   '   end '+
   'end ';
//   'GRANT EXECUTE ON PROCEDURE TIRA_ACENTOS TO SYSDBA; ';
end;

procedure TfrmPrin.GravaLog(cErro: String);
var Log: textFile;
begin
   AssignFile(Log, 'dsError.log');
   try
      if not(FileExists('dsError.log')) then
         Rewrite(Log)
      else
         Append(Log);
      Writeln(Log, FormatDateTime('dd/mm/yyyy hh:MM:ss',now)+' '+cErro);
   finally
      CloseFile(Log);
   end;
end;

function SoNumero(sNum: String): String;
var
  sV : String;
  nL : Integer;
begin
    sV := '';
    For nL := 1 to Length(sNum) do
       if Pos(Copy(sNum,nL,1),'0123456789')<>0 then
          sV := sV + Copy(sNum,nL,1);
    result := sV;
end;
function FormataCPFCNPJ(vr: String): String;
begin
   result:=SoNumero(vr);
   if trim(vr)='' then
      exit;
   if length(result)=11 then
      result := FormatMaskText('000.000.000-00;0;*',result)
   else
      result:=FormatMaskText('00.000.000/0000-00;0;*',result);
end;




procedure TfrmPrin.StartServer;
begin
  if not FServer.Active then begin
    FServer.Bindings.Clear;
    FServer.DefaultPort := StrToInt(iif(EditPort.Text = '','8082',EditPort.Text));
    FServer.Active := True;
  end;
end;

procedure TfrmPrin.TAtualizaDBTimer(Sender: TObject);
var
  ThreadDB : TThread;
begin
   if(sAtualizaDB <> 'S')then
      Exit;

   ThreadDB := TThread.CreateAnonymousThread(
   procedure
   begin
      TThread.Synchronize(TThread.CurrentThread,
      procedure
      begin
         TAtualizaDB.Enabled := false;

         pnlBancos.Top     := 16;
         pnlBancos.Left    := 60;
         pnlBancos.Visible := true;
      end);

      AtualizaBancos;
   end);
   ThreadDB.Start;
end;



procedure TfrmPrin.AtualizaBancos;
var
   sql  : String;
   qREG : TSQLQuery;
   qAUX : TSQLQuery;
   cDB  : TSQLConnection;
begin
   qREG := TSQLQuery.Create(Nil);
   qAUX := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(nil);

   ConfConexao(cDB);

   qREG.SQLConnection := cDB;
   try
      try
         qREG.Close;
         qREG.SQL.Text := 'SELECT * FROM EMPRESAS';
         sql := qREG.SQL.Text;
         qREG.Open;

         AtualizaBaseLimpa;
         while not(qREG.Eof) do begin
            try
               AtualizaBancoCliente(qREG);
               CriaPastasCliente(qREG);
            except on E: Exception do
               GravaLog('Erro ao tentar atualizar bancos de dados cliente '+qREG.FieldByName('CNPJ').AsString);
            end;

            qREG.Next;
         end;

      except on E: Exception do begin
         ShowMessage('N�o foi poss�vel atualizar base de dados !'+#13+e.Message);
         GravaLog('Erro ao tentar atualizar bancos de dados #Erro:'+e.Message+' sql:'+sql);
      end;
      end;
   finally
      pnlBancos.Visible := False;
      FreeAndNil(qAUX);
      FreeAndNil(qREG);
      FreeAndNil(cDB);
   end;
end;



procedure TfrmPrin.AtualizaBancoCliente(qCLI: TSQLQuery);
var
   bPen  : Boolean;
   nI    : Integer;
   lsSql : TStringList;
   qAUX  : TSQLQuery;
   cDB   : TSQLConnection;
begin
   cDB  := TSQLConnection.Create(Nil);
   qAUX := TSQLQuery.Create(Nil);
   qAUX.ParamCheck := False;

   if (Pos('10.1.1.11',qCLI.FieldByName('BANCO').AsString) = 0) and
      (not FileExists(ExtractFilePathFromStr(qCLI.FieldByName('BANCO').AsString))) then
      exit;

   ConfiguraConexaoBaseNova(
   qCLI.FieldByName('BANCO').AsString,
   qCLI.FieldByName('USUARIO').AsString,
   qCLI.FieldByName('SENHA').AsString,
   cDB);

   qAUX.SQLConnection := cDB;

   lsSql := TStringList.Create;
   try
      lsSql := ScriptBase(qAUX);

      bPen := false;
      if lsSql.Count>0 then begin
         try // except
            for nI := 0 to lsSql.Count-1 do begin
               if(Pos('PEN.CONFIG',lsSql[ni]) <> 0)then begin
                  bPen := true;
                  Continue;
               end;

               qAUX.Close;
               qAUX.SQL.Clear;
               qAUX.SQL.add(lsSql[ni]);
               qAUX.SQL.SaveToFile('SQLAtualiza.txt');
               qAUX.ExecSQL(False);
            end;

            if(bPen)then
               ShowMessage('Cliente pendente de configura��o:'+qCLI.FieldByName('CNPJ').AsString)
            else
               GravaLog('Base '+qCLI.FieldByName('CNPJ').AsString+' atualizada com sucesso!');
         except on e:exception do
            ShowMessage('N�o foi poss�vel atualizar base de dados !'+#13+e.Message);
         end;
      end;
   finally
      FreeAndNil(lsSql);
      FreeAndNil(qAUX);
      FreeAndNil(cDB);
   end;
end;



procedure TfrmPrin.ConfiguraConexaoBaseNova(cCam,cUsu,cSen: String;
  cDB: TSQLConnection);
var
   cBase : String;
begin
   cDB.LoadParamsOnConnect := false;
   cDB.ConnectionName      := 'FBConnection';
   cDB.DriverName          := 'Firebird';
   cDB.LibraryName         := 'dbxfb.dll';
   cDB.VendorLib           := 'fbclient.dll';
   cDB.Params.Values['Database']  := cCam;
   cDB.Params.Values['User_Name'] := cUsu;
   cDB.Params.Values['Password']  := cSen;
   cDB.Params.Values['IsolationLevel'] := 'ReadCommited';
   cDB.LoginPrompt := False;
end;



function SQLString(cSQL:String;qSTRING:TSQLQuery):String;
begin
   qSTRING.SQL.Clear;
   qSTRING.SQL.Add(cSQL);
   qSTRING.OPen;
   result := qSTRING.Fields[0].AsString;
end;

   procedure TfrmPrin.AtualizarJS1Click(Sender: TObject);
begin
   Application.ProcessMessages;
   try
      pnlJS.Top    := 41;
      pnlJS.Left   := 88;
      pnlJS.Visible:=true;

      try
//         Memo1.Lines.LoadFromFile('D:/swin/dsSisap/apop/assets/js/funcoesRestrito.js');
         ShowMessage('Pensando numa forma de resolver');
      except on E: Exception do
         GravaLog('ERRO AO ABRIR FUNCOESRESTRITO.JS');
      end;
   finally
      pnlJS.Visible:=false;
      Application.ProcessMessages;
      Application.BringToFront;
   end;

end;

procedure TfrmPrin.AtualizaBaseLimpa;
var
   bPen  : Boolean;
   nI    : Integer;
   lsSql : TStringList;
   qAUX  : TSQLQuery;
   cDB   : TSQLConnection;
begin
   cDB  := TSQLConnection.Create(Nil);
   qAUX := TSQLQuery.Create(Nil);

   GravaLog(ExtractFilePath(ParamStr(0)));

   ConfiguraConexaoBaseNova(
   '127.0.0.1:'+ExtractFilePath(ParamStr(0))+'/bases/base_limpa.fdb',
   'SYSDBA',
   'hsrsuper',
   cDB);

   qAUX.SQLConnection := cDB;

   lsSql := TStringList.Create;
   try
      lsSql := ScriptBase(qAUX);

      bPen := false;
      if lsSql.Count > 0 then begin
         try
            for nI := 0 to lsSql.Count-1 do begin
               if(Pos('PEN.CONFIG',lsSql[ni]) <> 0)then begin
                  bPen := true;
                  Continue;
               end;

               qAUX.Close;
               qAUX.SQL.Clear;
               qAUX.SQL.add(lsSql[ni]);
               // qAUX.SQL.SaveToFile('SQLAtualiza.txt');
               qAUX.ExecSQL(False);
            end;

            if(bPen)then
               ShowMessage('Base Limpa pendente de atualiza��o')
            else
               GravaLog('Base Limpa atualizada com sucesso!');

         except on e:exception do
            ShowMessage('N�o foi poss�vel atualizar base de dados !'+#13+e.Message);
         end;
      end;
   finally
      FreeAndNil(lsSql);
      FreeAndNil(qAUX);
      FreeAndNil(cDB);
   end;
end;


function TfrmPrin.ScriptBase(qAUX: TSQLQuery): TStringList;
var
   cAux:String;
begin
   Result := TStringList.Create;

   if SQLString('SELECT RDB$FIELD_NAME from rdb$relation_fields where rdb$relation_name=''PARAMETROS'' '+
                'AND RDB$FIELD_NAME=''APROMSNET_CNPJ'' ',qAUX)='' then
      Result.Add('ALTER TABLE PARAMETROS ADD APROMSNET_CNPJ VARCHAR(18)');
   if SQLString('SELECT RDB$FIELD_NAME from rdb$relation_fields where rdb$relation_name=''EMPRESA'' '+
                'AND RDB$FIELD_NAME=''REGIME'' ',qAUX)='' then
      Result.Add('ALTER TABLE EMPRESA ADD REGIME CHAR(1)');

   if SQLString('SELECT RDB$FIELD_NAME from rdb$relation_fields where rdb$relation_name=''EMPRESA'' '+
                'AND RDB$FIELD_NAME=''TPTRANSP'' ',qAUX)='' then
      Result.Add('ALTER TABLE EMPRESA ADD TPTRANSP SMALLINT');

   if SQLString('SELECT RDB$FIELD_NAME from rdb$relation_fields where rdb$relation_name=''PARAMETROS'' '+
                'AND RDB$FIELD_NAME=''APROMSNET_CHAVE'' ',qAUX)='' then
      Result.Add('ALTER TABLE PARAMETROS ADD APROMSNET_CHAVE VARCHAR(50)');

   if SQLString('SELECT RDB$FIELD_NAME from rdb$relation_fields where rdb$relation_name=''PARAMETROS'' '+
                'AND RDB$FIELD_NAME=''APROMSNET_AMBIENTE'' ',qAUX)='' then
      Result.Add('ALTER TABLE PARAMETROS ADD APROMSNET_AMBIENTE CHAR(1)');

   if SQLString('SELECT RDB$FIELD_NAME from rdb$relation_fields where rdb$relation_name=''PARAMETROS'' '+
                'AND RDB$FIELD_NAME=''CERTIFICADO_CAMINHO'' ',qAUX)='' then
      Result.Add('ALTER TABLE PARAMETROS ADD CERTIFICADO_CAMINHO VARCHAR(250)');

   if SQLString('SELECT RDB$FIELD_NAME from rdb$relation_fields where rdb$relation_name=''PARAMETROS'' '+
                'AND RDB$FIELD_NAME=''CERTIFICADO_SENHA'' ',qAUX)='' then
      Result.Add('ALTER TABLE PARAMETROS ADD CERTIFICADO_SENHA VARCHAR(30)');

   if SQLString('SELECT RDB$FIELD_NAME from rdb$relation_fields where rdb$relation_name=''USUARIOS'' AND RDB$FIELD_NAME=''TOKEN'' ',qAUX)<>'' then
      Result.Add('ALTER TABLE USUARIOS ALTER COLUMN TOKEN TYPE VARCHAR (32) CHARACTER SET WIN1252');

   if SQLString('SELECT RDB$FIELD_NAME from rdb$relation_fields where rdb$relation_name=''USUARIOS'' AND RDB$FIELD_NAME=''TOKEN'' ',qAUX)='' then
      Result.Add('ALTER TABLE USUARIOS ADD TOKEN VARCHAR(32)');

   if SQLString('SELECT RDB$FIELD_NAME from rdb$relation_fields where rdb$relation_name=''FRETESVEI'' AND RDB$FIELD_NAME=''PT_CPF'' ',qAUX)<>'' then
      Result.Add('ALTER TABLE FRETESVEI ALTER COLUMN PT_CPF TYPE VARCHAR (18) CHARACTER SET WIN1252');

   if SQLString('SELECT DISTINCT S.RDB$INDEX_NAME FROM RDB$INDICES R '+
                'LEFT JOIN RDB$INDEX_SEGMENTS S ON S.RDB$INDEX_NAME=R.RDB$INDEX_NAME '+
                'WHERE R.RDB$RELATION_NAME=''FRETES'' AND S.RDB$INDEX_NAME=''IDX_DATA'' ',qAUX)='' then
      Result.Add('CREATE INDEX IDX_DATA ON FRETES (DATA)');

   if SQLString('SELECT DISTINCT S.RDB$INDEX_NAME FROM RDB$INDICES R '+
                'LEFT JOIN RDB$INDEX_SEGMENTS S ON S.RDB$INDEX_NAME=R.RDB$INDEX_NAME '+
                'WHERE R.RDB$RELATION_NAME=''FRETESMDF'' AND S.RDB$INDEX_NAME=''FRETESMDF_IDX1'' ',qAUX)='' then
      Result.Add('CREATE INDEX FRETESMDF_IDX1 ON FRETESMDF (DATA)');

   if SQLString('SELECT RDB$FIELD_NAME from rdb$relation_fields where rdb$relation_name=''FRETES'' '+
                'AND RDB$FIELD_NAME=''PLATAFORMA'' ',qAUX)='' then
      Result.Add('ALTER TABLE FRETES ADD PLATAFORMA SMALLINT');
   if SQLString('SELECT RDB$FIELD_NAME from rdb$relation_fields where rdb$relation_name=''FRETES'' AND RDB$FIELD_NAME=''VERSAO'' ',qAUX)<>'' then
      Result.Add('ALTER TABLE FRETES ALTER COLUMN VERSAO TYPE VARCHAR (10) CHARACTER SET WIN1252');

   if SQLString('SELECT RDB$FIELD_NAME from rdb$relation_fields where rdb$relation_name=''FRETES'' '+
                'AND RDB$FIELD_NAME=''ULT_DOWNLOAD_PDF'' ',qAUX)='' then
      Result.Add('ALTER TABLE FRETES ADD ULT_DOWNLOAD_PDF TIMESTAMP');

   if SQLString('SELECT RDB$FIELD_NAME from rdb$relation_fields where rdb$relation_name=''FRETESMDF'' '+
                'AND RDB$FIELD_NAME=''ULT_DOWNLOAD_PDF'' ',qAUX)='' then
      Result.Add('ALTER TABLE FRETESMDF ADD ULT_DOWNLOAD_PDF TIMESTAMP');

   if SQLString('SELECT RDB$FIELD_NAME from rdb$relation_fields where rdb$relation_name=''PROPRIETARIOS'' '+
                'AND RDB$FIELD_NAME=''RB1_NOME'' ',qAUX)='' then
      Result.Add('UPDATE RDB$FIELDS set RDB$FIELD_LENGTH = 50,RDB$CHARACTER_LENGTH = 50 where RDB$FIELD_NAME = ''RDB$299''');

   if SQLString('SELECT RDB$FIELD_NAME from rdb$relation_fields where rdb$relation_name=''PROPRIETARIOS'' AND RDB$FIELD_NAME=''RB1_NOME'' ',qAUX)<>'' then
      Result.Add('ALTER TABLE PROPRIETARIOS ALTER COLUMN RB1_NOME TYPE VARCHAR (100) CHARACTER SET WIN1252');

   if SQLString('SELECT RDB$FIELD_NAME from rdb$relation_fields where rdb$relation_name=''EMPRESA'' '+
                'AND RDB$FIELD_NAME=''CODIGO_CRM'' ',qAUX)='' then
      Result.Add('ALTER TABLE EMPRESA ADD CODIGO_CRM INTEGER');

   if SQLString('SELECT RDB$FIELD_NAME from rdb$relation_fields where rdb$relation_name=''EMPRESA'' '+
                'AND RDB$FIELD_NAME=''ULTIMA_ATUALIZACAO_CRM'' ',qAUX)='' then
      Result.Add('ALTER TABLE EMPRESA ADD ULTIMA_ATUALIZACAO_CRM TIMESTAMP');
   if SQLString('SELECT RDB$FIELD_NAME from rdb$relation_fields where rdb$relation_name=''USUARIOS'' '+
                'AND RDB$FIELD_NAME=''TOKEN_ALTERACAO_SENHA'' ',qAUX)='' then
      Result.Add('ALTER TABLE USUARIOS ADD TOKEN_ALTERACAO_SENHA VARCHAR(32) CHARACTER SET WIN1252');

   if SQLString('SELECT RDB$FIELD_NAME from rdb$relation_fields where rdb$relation_name=''CONFIG'' '+
                'AND RDB$FIELD_NAME=''CODIGO'' ',qAUX)='' then begin
      Result.Add('ALTER TABLE CONFIG ADD CODIGO SMALLINT DEFAULT 1 NOT NULL ');
      // Result.Add('UPDATE CONFIG SET CODIGO=1');
      Result.Add('ALTER TABLE CONFIG ADD CONSTRAINT PK_CONFIG PRIMARY KEY (CODIGO)');
   end;

   if SQLString('SELECT RDB$FIELD_NAME from rdb$relation_fields where rdb$relation_name=''PARAMETROS'' '+
                'AND RDB$FIELD_NAME=''PASTAXML'' ',qAUX)='' then
      Result.Add('ALTER TABLE PARAMETROS ADD PASTAXML VARCHAR(60) CHARACTER SET WIN1252 COLLATE WIN1252');

   // if SQLString('SELECT RDB$FIELD_NAME from rdb$relation_fields where rdb$relation_name=''FRETES'' '+
   //              'AND RDB$FIELD_NAME=''STATUS_SEFAZ'' ',qAUX)<>'' then
   //    Result.Add('ALTER TABLE "FRETES" DROP "STATUS_SEFAZ"');

   if SQLString('SELECT RDB$FIELD_NAME from rdb$relation_fields where rdb$relation_name=''FRETES'' '+
                'AND RDB$FIELD_NAME=''STATUS_SEFAZ'' ',qAUX)='' then
      Result.Add('ALTER TABLE FRETES ADD STATUS_SEFAZ SMALLINT');

   if SQLString('SELECT RDB$FIELD_NAME from rdb$relation_fields where rdb$relation_name=''FRETESMDF'' '+
                'AND RDB$FIELD_NAME=''STATUS_SEFAZ'' ',qAUX)='' then
      Result.Add('ALTER TABLE FRETESMDF ADD STATUS_SEFAZ SMALLINT');

   if SQLString('SELECT RDB$FIELD_NAME from rdb$relation_fields where rdb$relation_name=''FRETESMDF'' '+
                'AND RDB$FIELD_NAME=''PROTOCOLO_ENVIO'' ',qAUX)='' then
      Result.Add('ALTER TABLE FRETESMDF ADD PROTOCOLO_ENVIO VARCHAR(15)');

   if SQLString('SELECT RDB$FIELD_NAME from rdb$relation_fields where rdb$relation_name=''FRETES'' '+
                'AND RDB$FIELD_NAME=''SITUACAO'' ',qAUX)='' then
      Result.Add('ALTER TABLE FRETES ADD SITUACAO CHAR(1)');
// if SQLString('SELECT RDB$FIELD_NAME from rdb$relation_fields where rdb$relation_name=''EMPRESA'' '+
   //             'AND RDB$FIELD_NAME=''TELEFONE'' ',qAUX)<>'' then
   //   Result.Add('ALTER TABLE EMPRESA ALTER COLUMN TELEFONE TYPE VARCHAR (14) CHARACTER SET WIN1252');

   // configura��es especiais
   if SQLString('SELECT RDB$PROCEDURE_NAME FROM RDB$PROCEDURES WHERE RDB$PROCEDURE_NAME = ''EXTRAI_NUMERO'' ',qAUX) = '' then begin
      cAux := 'CREATE OR ALTER PROCEDURE EXTRAI_NUMERO ( '+
      '    TEXTO VARCHAR(100)) '+
      'RETURNS ( '+
      '    RESULTADO VARCHAR(100)) '+
      'AS '+
      'DECLARE VARIABLE INDICE INTEGER; '+
      'DECLARE VARIABLE CARACTER CHAR(1); '+
      'BEGIN '+
      '  IF (TEXTO IS NULL) THEN '+
      '    RESULTADO = NULL; '+
      '  ELSE BEGIN '+
      '    RESULTADO = ''''; '+
      '    INDICE = 1; '+
      '    WHILE (INDICE <= CHAR_LENGTH(TEXTO)) DO BEGIN '+
      '      CARACTER = CAST(SUBSTRING(TEXTO FROM INDICE FOR 1) AS CHAR(1)); '+
      '      IF (CARACTER BETWEEN ''0'' AND ''9'') THEN '+
      '         RESULTADO = RESULTADO || CARACTER; '+
      '      INDICE = INDICE + 1; '+
      '    END '+
      '  END '+
      '  SUSPEND; '+
      'END';

      Result.Add(cAux);
   end;

   if SQLString('SELECT RDB$PROCEDURE_NAME FROM RDB$PROCEDURES WHERE RDB$PROCEDURE_NAME = ''TIRA_ACENTOS'' ',qAUX) = '' then
      Result.Add('PEN.CONFIG');

   if SQLString('SELECT RDB$FIELD_NAME from rdb$relation_fields where rdb$relation_name=''FRETES'' '+
                'AND RDB$FIELD_NAME=''SITUACAO'' ',qAUX)='' then
//     if True then
//     ALTER TABLE FRETES ADD TIMEZONE VARCHAR(5)


end;
procedure TfrmPrin.EditPortExit(Sender: TObject);
begin
  GravaIni('Sistema','Porta', EditPort.Text);
end;


function TfrmPrin.ExtractFilePathFromStr(const inputStr: string): string;
var
  separatorPos: Integer;
begin
  separatorPos := Pos(':', inputStr);

  if separatorPos > 0 then
    Result := Copy(inputStr, separatorPos + 1, MaxInt)
  else
    Result := '';
end;

procedure TfrmPrin.CriaPastasCliente(qCLI: TSQLQuery);
begin
  try
     if(not DirectoryExists('.\clientes\CTe\'+soNumero(qCLI.FieldByName('CNPJ').AsString))) then
        ForceDirectories('.\clientes\CTe\'+soNumero(qCLI.FieldByName('CNPJ').AsString));
     if(not DirectoryExists('.\clientes\CTe\'+soNumero(qCLI.FieldByName('CNPJ').AsString)+'\PDFs\')) then
        ForceDirectories('.\clientes\CTe\'+soNumero(qCLI.FieldByName('CNPJ').AsString)+'\PDFs\');
     if(not DirectoryExists('.\clientes\MDFe\'+soNumero(qCLI.FieldByName('CNPJ').AsString))) then
        ForceDirectories('.\clientes\MDFe\'+soNumero(qCLI.FieldByName('CNPJ').AsString));
     // if(not DirectoryExists('.\clientes\MDFe\'+soNumero(qCLI.FieldByName('CNPJ').AsString)+'\PDFs\')) then
     //   ForceDirectories('.\clientes\MDFe\'+soNumero(qCLI.FieldByName('CNPJ').AsString)+'\PDFs\');
  except on E: Exception do
  end;
end;

procedure TfrmPrin.At1Click(Sender: TObject);
var
   ThreadDB : TThread;
begin
   if(sAtualizaDB <> 'S')then
      Exit;

   ThreadDB := TThread.CreateAnonymousThread(
   procedure
   begin
      TThread.Synchronize(TThread.CurrentThread,
      procedure
      begin
         TAtualizaDB.Enabled := false;

         pnlBancos.Top     := 16;
         pnlBancos.Left    := 60;
         pnlBancos.Visible := true;
      end);

      AtualizaBancos;
   end);
   ThreadDB.Start;
end;

procedure TfrmPrin.TMensagemTimer(Sender: TObject);
var
   ThreadDB : TThread;
begin
   ThreadDB := TThread.CreateAnonymousThread(
   procedure
   begin
      TThread.Synchronize(TThread.CurrentThread,
      procedure
      begin
         TMensagem.Enabled := false;
      end);

      EnviaMensagens;
   end);
   ThreadDB.Start;
end;

procedure TfrmPrin.EnviaMensagens;
var
   sql  : String;

   oText  : TJSONObject;
   oSend  : TJSONObject;
   oResp  : String;
   sSend  : TStringStream;
   IdHTTP : TIDHTTP;

   qAUX : TSQLQuery;
   qREG : TSQLQuery;
   cDB  : TSQLConnection;
begin
   qREG := TSQLQuery.Create(Nil);
   qAUX := TSQLQuery.Create(Nil);
   cDB  := TSQLConnection.Create(nil);

   ConfConexao(cDB);

   qREG.SQLConnection := cDB;
   qAUX.SQLConnection := cDB;

   IdHTTP := TIDHTTP.Create(Nil);
   oSend  := TJSONObject.Create;
   try
      try
         qREG.Close;
         qREG.SQL.Text := 'SELECT * FROM EMPRESAS WHERE CODIGO>(SELECT COALESCE(P.ULTIMO_ALERTA_CADASTRO,0) FROM PARAMETROS P) ORDER BY CODIGO';
         sql := qREG.SQL.Text;
         qREG.Open;

         oSend.AddPair('messaging_product','whatsapp');
         oSend.AddPair('to','67981825843');

         oText := TJSONObject.Create;
         oText.AddPair('body','Ol� houve +1 cliente cadastrado no sigetran');
         oSend.AddPair('text',oText);

         while not(qREG.Eof) do begin
            sSend :=  TStringStream.Create(oSend.ToString, TEncoding.UTF8);

            try
               IdHTTP.IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(IdHTTP);
               TIdSSLIOHandlerSocketOpenSSL(IdHTTP.IOHandler).SSLOptions.Method := sslvTLSv1_2;

               IdHTTP.Request.CustomHeaders.FoldLines := False;
               IdHTTP.Request.CustomHeaders.Add('Authorization:Bearer ' + TOKEN_META);
               IdHTTP.Request.ContentType := 'application/json';
               IdHTTP.Request.CharSet     := 'utf-8';

               oResp := IdHttp.Post('https://graph.facebook.com/v17.0/'+ID_META+'/messages?access_token='+TOKEN_META,sSend);    //mudar URL aqui
            except on E: Exception do begin
               GravaLog('Erro ao enviar mensagem erro:'+E.Message);
            end;
            end;

            qAUX.Close;
            qAUX.SQL.Text := 'UPDATE PARAMETROS SET ULTIMO_ALERTA_CADASTRO=0'+qREG.FieldByName('CODIGO').AsString;
            sql := qAUX.SQL.Text;
            qAUX.ExecSQL(False);

            qREG.Next;
         end;

      except on E: Exception do begin
         GravaLog('Erro ao tentar enviar mensagem #Erro:'+e.Message+' sql:'+sql);
      end;
      end;
   finally
      FreeAndNil(qAUX);
      FreeAndNil(qREG);
      FreeAndNil(cDB);
      FreeAndNil(IdHTTP);

      oSend.DisposeOf;

      TMensagem.Enabled := true;
      TMensagem.Interval := 900000;
   end;
end;


end.

