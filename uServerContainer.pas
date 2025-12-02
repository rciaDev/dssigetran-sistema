unit uServerContainer;

interface

uses System.SysUtils, System.Classes,Datasnap.DSServer, Datasnap.DSCommonServer,
  Datasnap.DSAuth,Generics.Collections,Data.SqlExpr,Datasnap.DSSession,uFrm,
  IPPeerServer, Datasnap.DSTCPServerTransport;

type
  TServerContainer1 = class(TDataModule)
    DSServer1: TDSServer;
    DSServerClass1: TDSServerClass;
    DSTCPServerTransport1: TDSTCPServerTransport;
    procedure DSServerClass1GetClass(DSServerClass: TDSServerClass;
      var PersistentClass: TPersistentClass);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetConnection : TSQLConnection;
    function GetCntGSMarket: TSQLConnection;
    procedure FormatConnection(cnDB:TSQLConnection);
  end;

var
  ServerContainer1 : TServerContainer1;
  ListofConnection : TDictionary<integer, TSQLConnection>;
  ListofCntGsmarket: TDictionary<integer, TSQLConnection>;


function DSServer: TDSServer;

implementation


{$R *.dfm}

uses Winapi.Windows, uServerMethods;

var
  FModule: TComponent;
  FDSServer: TDSServer;

function DSServer: TDSServer;
begin
  Result := FDSServer;
end;

constructor TServerContainer1.Create(AOwner: TComponent);
begin
  inherited;
  FDSServer := DSServer1;
end;

procedure TServerContainer1.DataModuleCreate(Sender: TObject);
begin
   ListofConnection := TDictionary<integer, TSQLConnection>.Create;
   ListofCntGsmarket:= TDictionary<integer, TSQLConnection>.Create;
end;

destructor TServerContainer1.Destroy;
begin
  inherited;
  FDSServer := nil;
end;

procedure TServerContainer1.DSServerClass1GetClass(
  DSServerClass: TDSServerClass; var PersistentClass: TPersistentClass);
begin
  PersistentClass := uServerMethods.servicos;
//  PersistentClass := uServerMethods.TServerMethods1;
end;

procedure TServerContainer1.FormatConnection(cnDB: TSQLConnection);
begin
  if ListofConnection.ContainsKey(TDSSessionManager.GetThreadSession.Id) then
//     Result := ListofConnection[TDSSessionManager.GetThreadSession.Id]
  else
  begin
//    cnDB := TSQLConnection.Create(nil);
    cnDB.Params.Clear;
    cnDB.DriverName := 'Firebird';
    cnDB.ConnectionName := 'FBConnection';
    cnDB.Params.Values['Database']  := frmPrin.dbBan;
    cnDB.Params.Values['User_Name'] := frmPrin.dbUsu;
    cnDB.Params.Values['Password']  := frmPrin.dbSen;
    cnDB.LoginPrompt := False;

    //dbconn.LoadParamsOnConnect := true;
    //dbconn.ConnectionName := 'DS Employee';

    ListofConnection.Add(TDSSessionManager.GetThreadSession.Id, cnDB);
  end;
end;

function TServerContainer1.GetConnection: TSQLConnection;
var dbconn : TSQLConnection;
begin
  if ListofConnection.ContainsKey(TDSSessionManager.GetThreadSession.Id) then
     Result := ListofConnection[TDSSessionManager.GetThreadSession.Id]
  else
  begin
    dbconn := TSQLConnection.Create(nil);
    dbconn.Params.Clear;
    dbconn.DriverName := 'Firebird';
    dbconn.ConnectionName := 'FBConnection';
    dbconn.Params.Values['Database']  := frmPrin.dbBan;
    dbconn.Params.Values['User_Name'] := frmPrin.dbUsu;
    dbconn.Params.Values['Password']  := frmPrin.dbSen;
    dbconn.LoginPrompt := False;

    //dbconn.LoadParamsOnConnect := true;
    //dbconn.ConnectionName := 'DS Employee';

    ListofConnection.Add(TDSSessionManager.GetThreadSession.Id, dbconn);
    Result := dbconn;
  end;
end;



function TServerContainer1.GetCntGSMarket: TSQLConnection;
var dbcn : TSQLConnection;
begin
  if ListofCntGsmarket.ContainsKey(TDSSessionManager.GetThreadSession.Id) then
     Result := ListofCntGsmarket[TDSSessionManager.GetThreadSession.Id]
  else begin
    dbcn := TSQLConnection.Create(nil);
    dbcn.Params.Clear;
    dbcn.DriverName := 'Firebird';
    dbcn.ConnectionName := 'FBConnection';
    dbcn.Params.Values['Database']  := frmPrin.dbGsm;
    dbcn.Params.Values['User_Name'] := frmPrin.dbUsu;
    dbcn.Params.Values['Password']  := frmPrin.dbSen;
    dbcn.LoginPrompt := False;

    //dbconn.LoadParamsOnConnect := true;
    //dbconn.ConnectionName := 'DS Employee';

    ListofCntGsmarket.Add(TDSSessionManager.GetThreadSession.Id, dbcn);
    Result := dbcn;
  end;

end;

initialization
  FModule := TServerContainer1.Create(nil);
finalization
  FModule.Free;
end.

