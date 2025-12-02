unit uFretes;

interface
Uses System.SysUtils,System.Classes,Data.DB, Data.SqlExpr, math,Datasnap.DSSession,MSHTML,ActiveX,FMX.Graphics,
 Soap.EncdDecd,System.JSON, uFreteJSON,System.StrUtils,ACBrNFe;

type
  TFretes = class
  private
    { private declarations }

  protected
    { protected declarations }
  public
    { public declarations }
    function GetSql():String;
    function Registra(oReq:TJSONObject;qUSU:TSQLQuery;cDB:TSQLConnection):String;
    function ChecaCamposObrigatorios(oFrete: TFreteJSON):Boolean;
    function SaldoFrete(oReq:TJSONObject): Double;
    function ValidaLimiteCampos(oFrete:TFreteJSON):String;
    function ImportarNFeXML(cXml: String;qUSU:TSQLQuery;cDB:TSQLConnection): String;

    function ChavesNFeOk(oFrete:TFreteJSON):Boolean;
    procedure GravaNotas(oFrete:TFreteJSON;qAUX:TSQLQuery);
    procedure GravaVei(oFrete:TFreteJSON;qAUX:TSQLQuery);
    procedure CadastraEmitente(qREG:TSQLQuery;ACBRNFe1:TACBRNFe);
    procedure CadastraDestinatario(qREG:TSQLQuery;ACBRNFe1:TACBRNFe);
    procedure CadastraProduto(qREG:TSQLQuery;ACBRNFe1:TACBRNFe);

    procedure CadastraOrigem(qREG:TSQLQuery;ACBRNFe1:TACBRNFe);
    procedure CadastraDestino(qREG:TSQLQuery;ACBRNFe1:TACBRNFe);

    function PeriodoFechado(dReg:TDate):Boolean;
    function TrataTipoProduto(cTip:string):String;
  published

  end;

  var
     sql : String;
     dFechada : TDateTime;
implementation

uses uWMSite, uFrm;

{ TFretes }


function TFretes.GetSql: String;
begin
    result := sql;
end;


function TFretes.Registra(oReq: TJSONObject; qUSU: TSQLQuery; cDB:TSQLConnection): String;
var
   cFreUnid   : String;
   cAux,cData : String;
   cUsuAlt    : String;
   cPlataforma: String;
   cStatus    : String;
   dPisEmp,dCofinsEmp : Double;
   dPis,dCofins,dIcms : Double;
   qAUX : TSQLQuery;
   qREG : TSQLQuery;
   TD   : TTransactionDesc;
   oFrete : TFreteJSON;
   dDataJSON : TDateTime;
begin
   qREG := TSQLQuery.Create(Nil);
   qAUX := TSQLQuery.Create(Nil);

   qREG.SQLConnection := cDB;
   qAUX.SQLConnection := cDB;

   TD.TransactionID   := TDSSessionManager.GetThreadSession.Id;
   TD.IsolationLevel  := xilREADCOMMITTED;
   cDB.StartTransaction(TD);

   oFrete := TFreteJSON.Create;
   try
      try
         oFrete.AsJSON := oReq.ToString;
         if(not ChecaCamposObrigatorios(oFrete))then begin
            Result := '{"erro":1,"mensagem":"Favor preencher todos os campos obrigatórios"}';
            exit;
         end;

         cAux := ValidaLimiteCampos(oFrete);
         if(cAux <> '') then begin
            Result := '{"erro":1,"mensagem":"Os campos '+cAux+' estão com tamanho maior que permitido"}';
            Exit;
         end;

         if not VerificaLimiteEmissoes(qUSU) then begin
            Result := MensagemErroLimite();
            Exit;
         end;

         if (oFrete.RemetenteTipo = '') then begin
            Result := '{"erro":1,"mensagem":"Remetente não informado"}';
            Exit;
         end;

         if (oFrete.DestinatarioTipo = '') then begin
            Result := '{"erro":1,"mensagem":"Destinatário não informado"}';
            Exit;
         end;

         if (SaldoFrete(oReq) < 0.00) then begin
            Result := '{"erro":1,"mensagem":"Valor do frete inválido"}';
            Exit;
         end;

         if(oFrete.TipoCte = '0') and (oFrete.Quantidade <= 0) and (oFrete.ValorFreteMotorista <> 0)then begin
            Result := '{"erro":1,"mensagem":"Quantidade ou valor inválido"}';
            Exit;
         end;

         if(oFrete.TipoCte = '0') and ((oFrete.ValorMercadoria <= 0.00) and (oFrete.ValorFreteMotorista <> 0.0))then begin
            Result := '{"erro":1,"mensagem":"Valor da mercadoria inválido"}';
            Exit;
         end;

         if(NumeroInicio(oFrete.Motorista) = '') and (oFrete.TipoCte <> '1') and (oFrete.TipoCte <> '0') then begin
            Result := '{"erro":1,"mensagem":"Motorista inválido"}';
            Exit;
         end;

         qAUX.SQL.Text := 'SELECT CODIGO,UNIDADE FROM PRODUTOS WHERE CODIGO=0'+NumeroInicio(oFrete.Mercadoria);
         sql := qAUX.SQL.Text;
         qAUX.Open;
         if(oFrete.TipoCte = '0') and (qAUX.FieldByName('CODIGO').AsInteger = 0) then begin
            Result := '{"erro":1,"mensagem":"Produto inválido"}';
            Exit;
         end;

         cFreUnid := qAUX.FieldByName('UNIDADE').AsString;

         if Trim(oFrete.TipoServico) = '' then begin
            Result := '{"erro":1,"mensagem":"Tipo de serviço inválido"}';
            Exit;
         end;

         oFrete.Placa := UpperCase(oFrete.Placa);
         qAUX.SQL.Text :=  'SELECT COALESCE(FROTA,''0'') AS FROTA FROM VEICULO WHERE PLACA='+QuotedStr(oFrete.Placa);
         sql := qAUX.SQL.Text;
         qAUX.Open;
         if (oFrete.ValorFreteMotorista < 0.00) and (qAUX.FieldByName('FROTA').ASString = '0') then begin
            Result := '{"erro":1,"mensagem":"Sem valor de frete para o motorista"}';
            Exit;
         end;

         qAUX.SQL.Text :=  'SELECT CODIGO FROM VEICULO WHERE PLACA='+QuotedStr(oFrete.Placa);
         sql := qAUX.SQL.Text;
         qAUX.Open;
         if (qAUX.Eof)then begin
            Result := '{"erro":1,"mensagem":"Veiculo inválido"}';
            Exit;
         end;

         oFrete.Placa := qAUX.FieldByName('CODIGO').AsString+' '+oFrete.Placa;

         if(oFrete.Notas[0].Tipo = '0') and (oFrete.Notas[0].Numero = '') then begin
            Result := '{"erro":1,"mensagem":"Nota fiscal inválida"}';
            Exit;
         end;

         if (oFrete.Notas[0].Tipo = '0') and not(ChavesNFeOk(oFrete)) then begin
            Result := '{"erro":1,"mensagem":"Existe chaves em duplicidade!"}';
            exit;
         end;

         if(oFrete.TomadorTipo = 'C')then begin
            qAUX.Close;
            qAUX.SQL.Text := 'SELECT CODIGO FROM CLIENTES WHERE CODIGO=0'+NumeroInicio(oFrete.Tomador);
            sql := qAUX.SQL.Text;
            qAUX.Open;

            if qAUX.Eof then begin
               Result := '{"erro":1,"mensagem":"Tomador inválido!"}';
               exit;
            end;
         end;

         if(oFrete.Remetente <> '') and (oFrete.RemetenteTipo = 'C')then begin
            qAUX.Close;
            qAUX.SQL.Text := 'SELECT CODIGO FROM CLIENTES WHERE CODIGO=0'+NumeroInicio(oFrete.Remetente);
            sql := qAUX.SQL.Text;
            qAUX.Open;

            if qAUX.Eof then begin
               Result := '{"erro":1,"mensagem":"Remetente inválido!"}';
               exit;
            end;
         end;

         if(oFrete.Remetente <> '')and(oFrete.RemetenteTipo = 'F')then begin
            qAUX.Close;
            qAUX.SQL.Text := 'SELECT CODIGO FROM FORNECEDORES WHERE CODIGO=0'+NumeroInicio(oFrete.Remetente);
            sql := qAUX.SQL.Text;
            qAUX.Open;

            if qAUX.Eof then begin
               Result := '{"erro":1,"mensagem":"Remetente inválido!"}';
               exit;
            end;
         end;

         if(oFrete.Destinatario <> '')and(oFrete.DestinatarioTipo = 'C')then begin
            qAUX.Close;
            qAUX.SQL.Text := 'SELECT CODIGO FROM CLIENTES WHERE CODIGO=0'+NumeroInicio(oFrete.Destinatario);
            sql := qAUX.SQL.Text;
            qAUX.Open;

            if qAUX.Eof then begin
               Result := '{"erro":1,"mensagem":"Destinatário inválido!"}';
               exit;
            end;
         end;

         if(oFrete.Destinatario <> '')and(oFrete.DestinatarioTipo = 'F')then begin
            qAUX.Close;
            qAUX.SQL.Text := 'SELECT CODIGO FROM FORNECEDORES WHERE CODIGO=0'+NumeroInicio(oFrete.Destinatario);
            sql := qAUX.SQL.Text;
            qAUX.Open;

            if qAUX.Eof then begin
               Result := '{"erro":1,"mensagem":"Destinatário inválido!"}';
               exit;
            end;
         end;

//         qAUX.Close;
//            qAUX.SQL.Text := 'SELECT CODIGO, STATUS '+
//            'FROM FRETES '+
//            'WHERE REMETENTE=0'+NumeroInicio(oFrete.Remetente)+' '+
//            'AND CODIGO<>0'+oFrete.Codigo+' '+
//            'AND DOCTIPO='+QuotedStr(oFrete.Notas[0].Tipo)+' '+
//            'AND TIPO<>''1'' '+
//            'AND DOCNUMERO='+QuotedStr(oFrete.Notas[0].Numero);
//            sql := qAUX.SQL.Text;
//            qAUX.Open;
//
//         if(qAUX.FieldByName('STATUS').AsString = 'C')then begin
//            Result := '{"erro":1,"mensagem":"Conhecimento já foi cancelado."}';
//            exit;
//         end;

         if(oFrete.TipoCte = '0') then begin
            // verifica se ja existe o ctrc
            qAUX.Close;
            qAUX.SQL.Text := 'SELECT CTRC FROM FRETES WHERE CTRC=0'+oFrete.Ctr+' AND '+
            'CODIGO<>0'+oFrete.Codigo+' AND '+
            'SERIE='+QuotedStr(oFrete.Serie)+' AND STATUS<>''C'' ';
            sql := qAUX.SQL.Text;
            qAUX.Open;

            if(qAUX.FieldByName('CTRC').AsString = oFrete.Ctr)then begin
               Result := '{"erro":1,"mensagem":"Este conhecimento ja foi digitado!"}';
               exit;
            end;

            // verifica se ja existe o ctrc
            qAUX.Close;
            qAUX.SQL.Text := 'SELECT CODIGO '+
            'FROM FRETES '+
            'WHERE REMETENTE=0'+NumeroInicio(oFrete.Remetente)+' '+
            'AND CODIGO<>0'+oFrete.Codigo+' '+
            'AND DOCTIPO='+QuotedStr(oFrete.Notas[0].Tipo)+' '+
            'AND TIPO<>''1'' '+
            'AND STATUS<>''C'' AND DOCNUMERO='+QuotedStr(oFrete.Notas[0].Numero);
            sql := qAUX.SQL.Text;
            qAUX.Open;


            if(qAUX.FieldByName('CODIGO').AsString <> '')then begin
               Result := '{"erro":1,"mensagem":"Já foi digitado conhecimento para esta '+oFrete.Notas[0].Tipo+'!"}';
               exit;
            end;



         end;

         // nuCFOP := tREGCFOP.AsInteger;

         qAUX.SQL.Text := 'SELECT FECHADO,CURRENT_TIMESTAMP AS DATA FROM PARAMETROS WHERE EMPRESA=1';
         qAUX.Open;

         dFechada := qAUX.FieldByName('FECHADO').AsDateTime;

         if(oFrete.Codigo <> '0')then begin
            qAUX.SQL.Text := 'SELECT DATA FROM FRETES WHERE CODIGO=0'+oFrete.Codigo;
            qAUX.Open;
         end;

         if (qAUX.FieldByName('DATA').AsDateTime <= dFechada) then begin
            Result := '{"erro":1,"mensagem":"Não pode ser excluido ou modificado. Lançamento dentro do período contábil já encerrado !"}';
            exit;
         end;


         // se esta alterando, nao etava cancelado e agora esta, verifica se existem faturamento
         // se existir nao pode aceitar
         // cFase:='Ja Faturados'; //SalvaFase(cFase);

         cData   := QuotedStr(FormatDateTime('dd.mm.yyyy hh:MM:ss', qAUX.FieldByName('DATA').AsDateTime));
         if qAUX.FieldByName('DATA').AsDateTime > Now then
            cData   := QuotedStr(FormatDateTime('dd.mm.yyyy hh:MM:ss', Now));
         cStatus := 'N';
         cUsuAlt := 'NULL';
         if(oFrete.Codigo <> '0') then begin
            qAUX.Close;
            qAUX.SQL.Text := 'SELECT DATA,STATUS,COALESCE(PLATAFORMA,''0'') AS PLATAFORMA '+
            'FROM FRETES '+
            'WHERE CODIGO=0'+oFrete.Codigo;
            sql := qAUX.SQL.Text;
            qAUX.Open;

            cData   := QuotedStr(FormatDateTime('dd.mm.yyyy hh:MM:ss',qAUX.FieldByName('DATA').AsDateTime));
            cUsuAlt := qUSU.FieldByName('CODIGO').AsString;

            oFrete.Plataforma := qAUX.FieldByName('PLATAFORMA').AsString;
            cStatus := qAUX.FieldByName('STATUS').AsString;

            if(qAUX.FieldByName('STATUS').AsString = 'C')then begin
               qAUX.Close;
               qAUX.SQL.Text := 'SELECT FRETE FROM FATDES WHERE FRETE=0'+oFrete.Codigo+' AND TIPO=''SD'' ';
               sql := qAUX.SQL.Text;
               qAUX.Open;

               if(qAUX.FieldByName('FRETE').AsString = oFrete.Codigo) then begin
                  Result := '{"erro":1,"mensagem":"Conhecimento ja faturado para recebimento!"}';
                  exit;
               end;

               qAUX.Close;
               qAUX.SQL.Text := 'SELECT FRETE FROM FATDES WHERE FRETE=0'+oFrete.Codigo+' AND TIPO=''SD'' ';
               sql := qAUX.SQL.Text;
               qAUX.Open;

               if(qAUX.FieldByName('FRETE').AsString = oFrete.Codigo) then begin
                  Result := '{"erro":1,"mensagem":"Conhecimento ja faturado para pagamento!"}';
                  exit;
               end;

               {
               REMOVIDO TEMPORARIAMENTE POIS NAO SEI O QUE PODE SER

               if (not(gbEmpresa.Enabled) or not(gbMotorista.Enabled)) and
                  (tbViag.Enabled) and (tbComp.Enabled) and (tbFech.enabled) then begin
                  ShowMessage('Operação não permitida. Este conhecimento ja foi faturado.');
                  exit;
               end;
               // se tiver contrato REPOM, tenta cancelar o contrato
               if (SQLInteger('SELECT CODIGO FROM FRETESREPOM WHERE CODIGO=0'+tREGCODIGO.AsString)<>0) and
                  not(frmRepom.CancelaContrato()) then
                  exit;


               // se tiver chave do cte, tenta cancelar, senao sai.
               if (tREGCHAVECTE.AsString<>'') and (tREGMODELO.AsString='CTe') and not(frmCte.Cancelamento()) then
                  exit;
               }
            end;
         end;

         if oFrete.Codigo = '0' then begin
            qAUX.Close;
            qAUX.SQL.Text := 'SELECT COALESCE(MAX(CODIGO),0)+1 AS CODIGO FROM FRETES';
            qAUX.Open;

            oFrete.Codigo := qAUX.FieldByName('CODIGO').AsString;
         end;

         qAUX.Close;
         qAUX.SQL.Text := 'SELECT FIRST 1 COALESCE(PERPIS,0.00) AS PERPIS,'+
         'COALESCE(COFINS,0.00) AS COFINS '+
         'FROM EMPRESA';
         sql := qAUX.SQL.Text;
         qAUX.Open;

         dPisEmp    := qAUX.FieldByName('PERPIS').AsFloat;
         dCofinsEmp := qAUX.FieldByName('COFINS').AsFloat;
         dPis       := (oFrete.ValorTotalEmpresa * dPisEmp)/100;
         dCofins    := (oFrete.ValorTotalEmpresa * dCofinsEmp)/100;

         qAUX.Close;
         qAUX.SQL.Text := 'SELECT PAGAICMS FROM PRODUTOS WHERE CODIGO=0'+NumeroInicio(oFrete.Mercadoria);
         sql := qAUX.SQL.Text;
         qAUX.Open;

         dIcms := 0.00;
         if(qAUX.FieldByName('PAGAICMS').AsString = 'S')then
            dIcms := oFrete.VrIcms;



         qREG.Close;
         qREG.SQL.Clear;
         qREG.SQL.Add('UPDATE OR INSERT INTO FRETES (');
         qREG.SQL.Add('CODIGO,CTRC,STATUS,DATA,');
         qREG.SQL.Add('USUINC,CFOP,ORIGEM,DESTINO,');
         qREG.SQL.Add('REMETENTE,REMQUEM,DESTINATARIO,DESQUEM,');
         qREG.SQL.Add('TOMADOR,APAGAR,PRODUTO,QUANTIDADE,VRMERCADORIA,');
         qREG.SQL.Add('ESPECIE,TOLPERC,TOLQUAN,');
         qREG.SQL.Add('DIASENTREGA,FRETE,UNIDADE,SECCAT,PEDAGIO,');
         qREG.SQL.Add('OUTROS,VALOR,TOLPERC1,TOLQUAN1,');
         qREG.SQL.Add('FRETE1,SEGURO1,');
         qREG.SQL.Add('IRRF1,INSS,SEST,ADIANTAMENTO1,DESCONTOS1,');
         qREG.SQL.Add('ICMS1,CLASSIFICACAO1,ESTADIA,OUTROS1,VALOR1,');
         qREG.SQL.Add('VALOADIANT,PERCADIANT,CST,ALIQUOTA,BASE,BASERED,');
         qREG.SQL.Add('ICMS,VEICULO,PROPRIETARIO,MOTORISTA,DOCTIPO,DOCSERIE,');
         qREG.SQL.Add('DOCNUMERO,DOCDATA,OBS1,EFRETE,');
         qREG.SQL.Add('PIS,COFINS,PIS_P,COFINS_P,SEGURO,');
         qREG.SQL.Add('SERIE,SERIECT,MODELO,PEDAGIO1,EMPRESA,PEDAGIOPPT,');
         qREG.SQL.Add('ICMSEMP,TIPO,TIPOCHV,VALORREC,');
         qREG.SQL.Add('TIPOSRV,DISTANCIA,VALORMIN,VALORMAX,');
         qREG.SQL.Add('ESTADIATOL,ESTADIAVRH,PESODESCONTO,VALORAJUSTE,');
         qREG.SQL.Add('PESOCHEGADA,PESOCHEG_R,PGVISTA,PROTOCOLO,ESTADIAREC,PLATAFORMA,SITUACAO');
         qREG.SQL.Add(') VALUES (');
         qREG.SQL.Add('0'+soNumero(oFrete.Codigo)+','+SoNumero(oFrete.Ctr)+',');
         qREG.SQL.Add(QuotedStr(cStatus)+','+cData+',0'+qUSU.FieldByName('CODIGO').AsString+',');
         qREG.SQL.Add(NumeroInicio(oFrete.Cfop)+','+iif(NumeroInicio(oFrete.Origem) = '','NULL',NumeroInicio(oFrete.Origem))+',');
         qREG.SQL.Add(iif(NumeroInicio(oFrete.Destino) = '','NULL',NumeroInicio(oFrete.Destino))+',');
         qREG.SQL.Add('0'+NumeroInicio(oFrete.Remetente)+','+QuotedStr(oFrete.RemetenteTipo)+',');
         qREG.SQL.Add('0'+NumeroInicio(oFrete.Destinatario)+','+QuotedStr(oFrete.DestinatarioTipo)+',');
         qREG.SQL.Add('0'+NumeroInicio(oFrete.Tomador)+',0'+SoNumero(oFrete.FormaPagamento)+',');
         qREG.SQL.Add('0'+NumeroInicio(oFrete.Mercadoria)+',0'+IntToStr(oFrete.Quantidade)+',');
         qREG.SQL.Add(ValorSQL(FloatToStr(oFrete.ValorMercadoria))+','+QuotedStr(oFrete.EspecieMercadoria)+',');
         qREG.SQL.Add(ValorSQL(FloatToStr(oFrete.ToleranciaMotorista))+','+ValorSQL(FloatToStr(oFrete.ToleranciaMotorista * oFrete.Quantidade /100))+',');
         qREG.SQL.Add(oFrete.Notas[0].DiasEntrega+','+ValorSQL(FloatToStr(oFrete.ValorFretePptEmpresa))+',');
         qREG.SQL.Add(QuotedStr(cFreUnid)+','+ValorSQL(FloatToStr(oFrete.DescontosEmpresa))+',');
         qREG.SQL.Add(ValorSQL(FloatToStr(oFrete.PedagioEmpresa))+','+ValorSQL(FloatToStr(0.00))+',');
         qREG.SQL.Add(ValorSQL(FloatToStr(oFrete.ValorTotalEmpresa))+','+ValorSQL(FloatToStr(oFrete.ToleranciaMotorista))+',');
         qREG.SQL.Add(ValorSQL(FloatToStr(oFrete.ToleranciaMotorista * oFrete.Quantidade /100))+',');
         qREG.SQL.Add(ValorSQL(FloatToStr(oFrete.ValorFreteMotoristaPpt))+','+ValorSQL(FloatToStr(oFrete.SeguroMotorista))+',');
         qREG.SQL.Add(ValorSQL(FloatToStr(oFrete.IrrfMotorista))+','+ValorSQL(FloatToStr(oFrete.Inss))+',');
         qREG.SQL.Add(ValorSQL(FloatToStr(oFrete.Sest))+','+ValorSQL(FloatToStr(oFrete.Adiantamento))+',');
         qREG.SQL.Add(ValorSQL(FloatToStr(oFrete.DescontosAdicionaisMercadoria))+','+ValorSQL(FloatToStr(oFrete.IcmsMotorista))+',');
         qREG.SQL.Add(ValorSQL(FloatToStr(0.00))+','+ValorSQL(FloatToStr(oFrete.Estadia))+',');
         qREG.SQL.Add(ValorSQL(FloatToStr(oFrete.OutrosValoresMotorista))+','+ValorSQL(FloatToStr(oFrete.ValorFreteMotorista))+',');
         qREG.SQL.Add(ValorSQL(FloatToStr(oFrete.Adiantamento))+','+ValorSQL(FloatToStr(oFrete.PorcentagemAdiantamento))+',');
         qREG.SQL.Add(QuotedStr(oFrete.Cst)+','+ValorSQL(FloatToStr(oFrete.Aliquota))+',');
         qREG.SQL.Add(ValorSQL(FloatToStr(oFrete.BaseIcms))+','+ValorSQL(FloatToStr(oFrete.BaseReducao))+',');
         qREG.SQL.Add(ValorSQL(FloatToStr(oFrete.VrIcms))+',0'+NumeroInicio(oFrete.Placa)+',');
         qREG.SQL.Add('0'+NumeroInicio(oFrete.Proprietario)+',0'+NumeroInicio(oFrete.Motorista)+',');
         qREG.SQL.Add(QuotedStr(oFrete.Notas[0].Tipo)+','+QuotedStr(Copy(oFrete.Notas[0].Serie,1,5))+',');
         qREG.SQL.Add(QuotedStr(oFrete.Notas[0].Numero)+','+QuotedStr(FormatDateTime('dd.mm.yyyy',StrToDate(oFrete.Notas[0].Data)))+',');
         qREG.SQL.Add(QuotedStr(oFrete.Obs)+',''0'',');
//         qREG.SQL.Add(QuotedStr(oFrete.Obs)+',''0'','+QuotedStr(UpperCase(oFrete.UfEmissao))+','+QuotedStr(UpperCase(oFrete.CidadeEmissao))+',');
         qREG.SQL.Add(ValorSQL(FloatToStr(dPis))+','+ValorSQL(FloatToStr(dCofins))+',');
         qREG.SQL.Add(ValorSQL(FloatToStr(dPisEmp))+','+ValorSQL(FloatToStr(dCofinsEmp))+',');
         qREG.SQL.Add(ValorSQL(FloatToStr(oFrete.SeguroEmpresa))+','+QuotedStr('001')+',');
         qREG.SQL.Add(QuotedStr(oFrete.Serie)+','+QuotedStr(oFrete.Modelo)+',');
         qREG.SQL.Add(ValorSQL(FloatToStr(oFrete.PedagioMotorista))+','+ValorSQL(FloatToStr(1))+',');
         qREG.SQL.Add(ValorSQL(FloatToStr(oFrete.PedagioPpt))+','+ValorSQL(FloatToStr(dIcms))+',');
         qREG.SQL.Add(QuotedStr(oFrete.TipoCte)+','+QuotedStr(SoNumero(oFrete.Chave))+',');
         qREG.SQL.Add(ValorSQL(FloatToStr(oFrete.ValorTotalEmpresa))+',');
         qREG.SQL.Add(QuotedStr(oFrete.TipoServico)+',0'+IntToStr(oFrete.Distancia)+',0,99999,');
         qREG.SQL.Add('0,0,0,0,');
         qREG.SQL.Add('0,0,0,0,''N'',0'+soNumero(oFrete.Plataforma)+',''P'')');

         qREG.SQL.Add('RETURNING CODIGO');
         sql := qREG.SQL.Text;
//         qREG.SQL.SaveToFile('LIXO.TXT');
         qREG.Open;

         oFrete.Codigo := qREG.FieldByName('CODIGO').AsString;

         GravaVei(oFrete,qAUX);

         GravaNotas(oFrete,qAUX);

         if cDB.InTransaction then
            cDB.Commit(TD);

         Commita(qREG);

         Result := '{"erro":0,"mensagem":"Registro incluído com sucesso!","codigo":"'+oFrete.Codigo+'"}';
      except on E: Exception do begin
         if cDB.InTransaction then
            cDB.Rollback(TD);

         GravaLog('Erro ao Gravar Conhecimento Erro:'+e.Message+' SQL:'+sql);

         Result := MensagemErroServer();
      end;
      end;
   finally
      FreeAndNil(qAUX);
      FreeAndNil(qREG);
      FreeAndNil(oFrete);
   end;
end;


function TFretes.ChecaCamposObrigatorios(oFrete: TFreteJSON): Boolean;
begin
   result := false;

   if(oFrete.Codigo <> '') and (oFrete.Ctr <> '') and (oFrete.Modelo <> '') and
     (oFrete.Tomador <> '') and (oFrete.Remetente <> '') and (oFrete.Destinatario <> '') and
     (oFrete.Cfop <> '') and (oFrete.TipoCte <> '') and
     (oFrete.Mercadoria <> '') and (oFrete.Quantidade <> 0) and (oFrete.ValorMercadoria <> 0) and
     (oFrete.Motorista <> '') and (oFrete.Proprietario <> '') and (oFrete.Placa <> '') and
     (oFrete.Cst <> '') and (oFrete.Notas[0].Tipo <> '')and (oFrete.Notas[0].Serie <> '') and
     (oFrete.Notas[0].Numero <> '') and (oFrete.Notas[0].Data <> '') and (oFrete.Notas[0].DiasEntrega <> '') and
     (oFrete.Notas[0].Mercadoria <> '')then
        result := true;
end;


function TFretes.SaldoFrete(oReq:TJSONObject): Double;
var
   nVlr : Double;
begin
   nVlr := oReq.GetValue<Double>('valor_frete_motorista');
   nVlr := nVlr - oReq.GetValue<Double>('seguro_motorista');
   nVlr := nVlr - oReq.GetValue<Double>('irrf_motorista');
   nVlr := nVlr - oReq.GetValue<Double>('sest');
   nVlr := nVlr - oReq.GetValue<Double>('inss');
   nVlr := nVlr + oReq.GetValue<Double>('descontos_adicionais_mercadoria');
   nVlr := nVlr + oReq.GetValue<Double>('icms_motorista');
   nVlr := nVlr + 0;
   nVlr := nVlr + oReq.GetValue<Double>('estadia');
   nVlr := nVlr + oReq.GetValue<Double>('pedagio_motorista');
   nVlr := nVlr - oReq.GetValue<Double>('outros_valores_motorista');

   if (oReq.GetValue<Double>('adiantamento') > nVlr) and (RoundTo(nVlr,-2)>0.00) then begin
      oReq.RemovePair('adiantamento');
      oReq.AddPair('adiantamento', TJSONNumber.Create(nVlr));
   end;

   nVlr   := nVlr - oReq.GetValue<Double>('adiantamento');
   result := nVlr;
end;

function TFretes.TrataTipoProduto(cTip: string): String;
begin
   if Pos('TO',cTip) <> 0 then
      result := 'TON'
   else if Pos('CX',cTip) <> 0 then
      result := 'CX'
   else if Pos('SC',cTip) <> 0 then
      result := 'SC'
   else if Pos('LT',cTip) <> 0 then
      result := 'LTS'
end;

function TFretes.ValidaLimiteCampos(oFrete: TFreteJSON): String;
var cCamp : String;
begin
   cCamp := '';

   if(Length(oFrete.RemetenteTipo) > 1)then
      cCamp := ' Tipo do remetente ';
   if(Length(oFrete.DestinatarioTipo) > 1)then
      cCamp := cCamp + ' Tipo do destinatário ';
   if(Length(oFrete.TomadorTipo) > 1)then
      cCamp := cCamp + ' Tipo do tomador ';
   if(Length(NumeroInicio(oFrete.Cst)) > 3)then
      cCamp := cCamp + ' CST ';
   if(Length(oFrete.Notas[0].Tipo) > 3)then
      cCamp := cCamp + ' Tipo da Nota ';
   if(Length(oFrete.Notas[0].Serie) > 5)then
      cCamp := cCamp + ' Série da Nota ';
   if(Length(oFrete.Notas[0].Numero) > 15)then
      cCamp := cCamp + ' Número da Nota ';
   if(Length(oFrete.Obs) > 150)then
      cCamp := cCamp + ' Observação ';
//   if(Length(oFrete.UfEmissao) > 2)then
//      cCamp := cCamp + ' UF Emissão ';
//   if(Length(oFrete.CidadeEmissao) > 40)then
//      cCamp := cCamp + ' Cidade Emissão ';
   if(Length(oFrete.Modelo) > 5)then
      cCamp := cCamp + ' Modelo ';
   if(Length(oFrete.TipoCte) > 1)then
      cCamp := cCamp + ' Tipo ';

   Result := cCamp;
end;

procedure TFretes.GravaNotas(oFrete: TFreteJSON;qAUX:TSQLQuery);
var
   nF : Integer;
begin
   qAUX.SQL.Text := 'DELETE FROM FRETENOTAS WHERE CODIGO='+oFrete.Codigo;
   qAUX.ExecSQL(False);

   nF := 0;
   while nF < oFrete.Notas.Count do begin
      qAUX.SQL.Clear;
      qAUX.SQL.Add('UPDATE OR INSERT INTO FRETENOTAS(');
      qAUX.SQL.Add('CODIGO,ITEM,TIPO,SERIE,NUMERO,DATA,');
      qAUX.SQL.Add('CODPRO,PRODUTO,QUANTIDADE,UNIDADE,');
      qAUX.SQL.Add('VRUNITARIO,VRMERCADORIA,FRETEUNITARIO,CHAVE)');
      qAUX.SQL.Add('VALUES(');
      qAUX.SQL.Add('0'+oFrete.Codigo+',(SELECT COALESCE(MAX(ITEM),0)+1 FROM FRETENOTAS WHERE CODIGO=0'+oFrete.Codigo+'),');
      qAUX.SQL.Add(QuotedStr(UpperCase(oFrete.Notas[nF].Tipo))+','+QuotedStr(oFrete.Notas[nF].Serie)+',');
      qAUX.SQL.Add('0'+soNumero(oFrete.Notas[nF].Numero)+','+QuotedStr(FormatDateTime('dd.mm.yyyy',StrToDate(oFrete.Notas[nF].Data)))+',');
      qAUX.SQL.Add('0'+NumeroInicio(oFrete.Notas[nF].Mercadoria)+',');
      qAUX.SQL.Add(QuotedStr(Copy(oFrete.Notas[nF].Mercadoria,Pos(' ',oFrete.Notas[nF].Mercadoria)+1,Length(oFrete.Notas[nF].Mercadoria)))+',');
      qAUX.SQL.Add('0'+IntToStr(oFrete.Notas[nF].Quantidade)+','+QuotedStr(UpperCase(oFrete.Notas[nF].Unidade))+',');
      qAUX.SQL.Add(ValorSQL(FloatToStr(oFrete.Notas[nF].ValorUnitario))+','+ValorSQL(FloatToStr(oFrete.Notas[nF].ValorMercadoria))+',');
      qAUX.SQL.Add(ValorSQL(FloatToStr(oFrete.ValorFreteMotorista/oFrete.Quantidade))+',');
      qAUX.SQL.Add(QuotedStr(SoNumero(oFrete.Notas[nF].Chave))+')');
      sql := qAUX.SQL.Text;
      qAUX.ExecSQL(False);

      inc(nF);
   end;

   // tem que gravar os dados digitados aqui.
   {if (tNFNUMERO.AsInteger=0) or (tNF.RecordCount<=1) then begin
      tNFITEM.Value       := 1;
      tNFTIPO.Value       := tREGDOCTIPO.AsString;
      tNFSERIE.Value      := tREGDOCSERIE.AsString;
      tNFNUMERO.AsInteger := StrtonumI(tREGDOCNUMERO.AsString);
      tNFDATA.AsDateTime  := tREGDOCDATA.AsDateTime;
      tNFCODPRO.AsInteger  := StrToNumI(NumeroInicio(edPro.Text));
      tNFPRODUTO.Value    := Copy(edPro.Text,pos(' ',edPro.TExt)+1,length(edPro.Text));
      tNFQUANTIDADE.AsFloat := tREGQUANTIDADE.AsFloat;
      tNFVRUNITARIO.AsFloat := Divide(tREGVRMERCADORIA.AsFloat,tREGQUANTIDADE.AsFloat);
      tNFVRMERCADORIA.AsFloat:= tREGVRMERCADORIA.AsFloat;
      tNFFRETEUNITARIO.AsFloat:= Divide(tREGVALOR1.AsFloat,tREGQUANTIDADE.AsFloat);
   end;
   tNF.Post;
   }
end;
function TFretes.PeriodoFechado(dReg: TDate): Boolean;
begin
   result := dReg <= dFechada;
end;


function TFretes.ChavesNFeOk(oFrete: TFreteJSON): Boolean;
var
   nF : Integer;
   nI : Integer;
begin
   nF := 0;
   for nF := 0 to oFrete.Notas.Count do  begin
      for nI := 0 to oFrete.Notas.Count do  begin
         if(nI <> nF) and (oFrete.Notas[nI].Chave <> '') and (oFrete.Notas[nI].Chave = oFrete.Notas[nF].Chave)then begin
            result := false;
            Exit;
         end;
      end;
   end;

end;



procedure TFretes.GravaVei(oFrete:TFreteJSON;qAUX:TSQLQuery);
var
  a :Integer;
  qREG : TSQLQuery;
begin
   qREG := tSQLQuery.Create(Nil);
   qREG.SQLConnection := qAUX.SQLConnection;
   try
      qAUX.Close;
      qAUX.SQL.Clear;
      qAUX.SQL.Add('SELECT P.CODIGO,O.NOME AS ORIGEM,D.NOME AS DESTINO,MT.NOME AS MT_NOME,MT.CPF AS MT_CPF,');
      qAUX.SQL.Add('MT.CIDADE AS MT_CIDADE,MT.UF AS MT_ESTADO,PT.NOME AS PT_NOME,PT.CNPJ AS PT_CPF,');
      qAUX.SQL.Add('PT.CIDADE AS PT_CIDADE,PT.UF AS PT_ESTADO,V.PLACA AS V_PLACA,MC.NOME AS V_MARCA,');
      qAUX.SQL.Add('V.MODELO AS V_MODELO,V.PLACACID AS V_CIDADE,V.PLACAUF AS V_ESTADO,');
      qAUX.SQL.Add('V.CAR1PLACA AS C1_PLACA,M1.NOME AS C1_MARCA,V.CAR1MODELO AS C1_MODELO,V.CAR1PLACACID AS C1_CIDADE,V.PLACAUF AS C1_ESTADO,');
      qAUX.SQL.Add('V.CAR2PLACA AS C2_PLACA,M2.NOME AS C2_MARCA,V.CAR2MODELO AS C2_MODELO,V.CAR2PLACACID AS C2_CIDADE,V.PLACAUF AS C2_ESTADO,');
      qAUX.SQL.Add('V.CAR3PLACA AS C3_PLACA,M3.NOME AS C3_MARCA,V.CAR3MODELO AS C3_MODELO,V.CAR3PLACACID AS C3_CIDADE,V.PLACAUF AS C3_ESTADO,');
      qAUX.SQL.Add('FV.RECICMS');
      qAUX.SQL.Add('FROM FRETES P');
      qAUX.SQL.Add('LEFT JOIN FRETESVEI FV ON FV.CODIGO=P.CODIGO');
      qAUX.SQL.Add('LEFT JOIN ORIGENS O ON O.CODIGO=P.ORIGEM');
      qAUX.SQL.Add('LEFT JOIN DESTINOS D ON D.CODIGO=P.DESTINO');
      qAUX.SQL.Add('LEFT JOIN MOTORISTAS MT ON MT.CODIGO=P.MOTORISTA');
      qAUX.SQL.Add('LEFT JOIN PROPRIETARIOS PT ON PT.CODIGO=P.PROPRIETARIO');
      qAUX.SQL.Add('LEFT JOIN VEICULO V ON V.CODIGO=P.VEICULO');
      qAUX.SQL.Add('LEFT JOIN TAB_MARCAS MC ON MC.CODIGO=V.MARCA');
      qAUX.SQL.Add('LEFT JOIN TAB_MARCAS M1 ON M1.CODIGO=V.CAR1MARCA');
      qAUX.SQL.Add('LEFT JOIN TAB_MARCAS M2 ON M2.CODIGO=V.CAR2MARCA');
      qAUX.SQL.Add('LEFT JOIN TAB_MARCAS M3 ON M3.CODIGO=V.CAR3MARCA');
      qAUX.SQL.Add('WHERE P.CODIGO=0'+oFrete.Codigo);
      qAUX.Open;

//      if(NumeroInicio(oFrete.Origem) <> '')then
//         oFrete.Origem := Trim(Copy(oFrete.Origem,Pos(' ',oFrete.Origem)+1,100));
//      if(NumeroInicio(oFrete.Destino) <> '')then
//         oFrete.Origem := Trim(Copy(oFrete.Origem,Pos(' ',oFrete.Destino)+1,100));

      qREG.Close;
      qREG.SQL.Clear;
      qREG.SQL.Add('UPDATE OR INSERT INTO FRETESVEI (');
      qREG.SQL.Add('CODIGO,ORIGEM,DESTINO,MT_NOME,MT_CPF,');
      qREG.SQL.Add('MT_CIDADE,MT_ESTADO,PT_NOME,PT_CPF,');
      qREG.SQL.Add('PT_CIDADE,PT_ESTADO,V_PLACA,V_MARCA,V_MODELO,');
      qREG.SQL.Add('V_CIDADE,V_ESTADO,C1_PLACA,C1_MARCA,C1_MODELO,');
      qREG.SQL.Add('C1_CIDADE,C1_ESTADO,C2_PLACA,C2_MARCA,C2_MODELO,');
      qREG.SQL.Add('C2_CIDADE,C2_ESTADO,C3_PLACA,C3_MARCA,C3_MODELO,');
      qREG.SQL.Add('C3_CIDADE,C3_ESTADO,RECICMS)');
      qREG.SQL.Add('VALUES (0'+oFrete.Codigo+','+QuotedStr(UpperCase(oFrete.Origem))+',');
      qREG.SQL.Add(QuotedStr(UpperCase(oFrete.Destino))+',');
      qREG.SQL.Add(QuotedStr(qAUX.FieldByName('MT_NOME').AsString)+','+QuotedStr(qAUX.FieldByName('MT_CPF').ASString)+',');
      qREG.SQL.Add(QuotedStr(qAUX.FieldByName('MT_CIDADE').AsString)+','+QuotedStr(qAUX.FieldByName('MT_ESTADO').AsString)+',');

      qREG.SQL.Add(QuotedStr(qAUX.FieldByName('PT_NOME').AsString)+','+QuotedStr(qAUX.FieldByName('PT_CPF').ASString)+',');
      qREG.SQL.Add(QuotedStr(qAUX.FieldByName('PT_CIDADE').AsString)+','+QuotedStr(qAUX.FieldByName('PT_ESTADO').ASString)+',');

      qREG.SQL.Add(QuotedStr(qAUX.FieldByName('V_PLACA').AsString)+','+QuotedStr(qAUX.FieldByName('V_MARCA').ASString)+',');
      qREG.SQL.Add(QuotedStr(qAUX.FieldByName('V_MODELO').AsString)+','+QuotedStr(qAUX.FieldByName('V_CIDADE').ASString)+',');
      qREG.SQL.Add(QuotedStr(qAUX.FieldByName('V_ESTADO').AsString)+','+QuotedStr(qAUX.FieldByName('C1_PLACA').ASString)+',');
      qREG.SQL.Add(QuotedStr(qAUX.FieldByName('C1_MARCA').AsString)+',');
      qREG.SQL.Add(QuotedStr(qAUX.FieldByName('C1_MODELO').AsString)+','+QuotedStr(qAUX.FieldByName('C1_CIDADE').ASString)+',');
      qREG.SQL.Add(QuotedStr(qAUX.FieldByName('C1_ESTADO').AsString)+','+QuotedStr(qAUX.FieldByName('C2_PLACA').ASString)+',');
      qREG.SQL.Add(QuotedStr(qAUX.FieldByName('C2_MARCA').AsString)+','+QuotedStr(qAUX.FieldByName('C2_MODELO').ASString)+',');
      qREG.SQL.Add(QuotedStr(qAUX.FieldByName('C2_CIDADE').AsString)+','+QuotedStr(qAUX.FieldByName('C2_ESTADO').ASString)+',');
      qREG.SQL.Add(QuotedStr(qAUX.FieldByName('C3_PLACA').AsString)+','+QuotedStr(qAUX.FieldByName('C3_MARCA').AsString)+',');
      qREG.SQL.Add(QuotedStr(qAUX.FieldByName('C3_MODELO').AsString)+','+QuotedStr(qAUX.FieldByName('C3_CIDADE').AsString)+',');
      qREG.SQL.Add(QuotedStr(qAUX.FieldByName('C3_ESTADO').AsString)+',');
      qREG.SQL.Add(QuotedStr('N')+')');
      sql := qREG.SQL.Text;
      qREG.ExecSQL(false);
   finally
      FreeAndNil(qREG);
   end;
end;

function TFretes.ImportarNFeXML(cXml: String;qUSU:TSQLQuery;cDB:TSQLConnection): String;
var
   cNome : String;
   cCod  : String;
   cProd : String;
   cDestinatario : String;
   cTomador,cDescontaQuebra,cAverbar: String;
   sqlCampo, sqlValor               : String;
   cOrigem, cDestino : String;

   nQuan : Double;

   oResp  : TJSONObject;
   oCon   : TJSONObject;
   aNotas : TJSONArray;
   oNota  : TJSONObject;

   qREG   : TSQLQuery;
   qAUX   : TSQLQuery;
   ACBRNFe1 : TACBrNFe;

   TD   : TTransactionDesc;
begin
   qREG := TSQLQuery.Create(Nil);
   qAUX := TSQLQuery.Create(Nil);

   qAUX.SQLConnection := cDB;
   qREG.SQLConnection := cDB;

   ACBRNFe1 := TACBrNFe.Create(Nil);

   TD.TransactionID   := TDSSessionManager.GetThreadSession.Id;
   TD.IsolationLevel  := xilREADCOMMITTED;
   cDB.StartTransaction(TD);

   oResp := TJSONObject.Create;
   try
      try
         ACBRNFe1.NotasFiscais.LoadFromString(cXml);

         if(ACBrNFe1.NotasFiscais.Count = 0)then begin
            Result := '{"erro":1,"mensagem":"XML inválido"}';
            exit;
         end;

         // cadastra o tomador
         CadastraEmitente(qREG,ACBRNFe1);
         cTomador := qREG.FieldByName('CODIGO').AsString;

         // cadastra como origem
         CadastraOrigem(qREG,ACBRNFe1);
         cOrigem := qREG.FieldByName('CODIGO').AsString;

         // cadastra o destinatario
         CadastraDestinatario(qREG,ACBRNFe1);
         cDestinatario := qREG.FieldByName('CODIGO').AsString;

         // cadastra como destino
         CadastraDestino(qREG,ACBRNFe1);
         cDestino := qREG.FieldByName('CODIGO').AsString;

         oResp.AddPair('ctr',IntToStr(ACBrNFe1.NotasFiscais.Items[0].NFe.Ide.nNF));
         oResp.AddPair('serie',IntToStr(ACBrNFe1.NotasFiscais.Items[0].NFe.Ide.serie));
         oResp.AddPair('modelo','CTe');
         oResp.AddPair('tomador',cTomador+' '+ACBrNFe1.NotasFiscais.Items[0].NFe.Emit.xNome);
         oResp.AddPair('cnpj_tomador',FormataCPFCNPJ(ACBRNFe1.NotasFiscais.Items[0].NFe.Emit.CNPJCPF));
         oResp.AddPair('cidade_tomador',UpperCase(ACBrNFe1.NotasFiscais.Items[0].NFe.Emit.EnderEmit.xMun+' '+ACBrNFe1.NotasFiscais.Items[0].NFe.Emit.EnderEmit.UF));
         oResp.AddPair('tomador_tipo','C');

         oResp.AddPair('remetente',cTomador+' '+ACBrNFe1.NotasFiscais.Items[0].NFe.Emit.xNome);
         oResp.AddPair('cnpj_remetente',FormataCPFCNPJ(ACBRNFe1.NotasFiscais.Items[0].NFe.Emit.CNPJCPF));
         oResp.AddPair('cidade_remetente',UpperCase(ACBrNFe1.NotasFiscais.Items[0].NFe.Emit.EnderEmit.xMun+' '+ACBrNFe1.NotasFiscais.Items[0].NFe.Emit.EnderEmit.UF));
         oResp.AddPair('remetente_tipo','C');
         oResp.AddPair('uf_remetente',UpperCase(ACBrNFe1.NotasFiscais.Items[0].NFe.Emit.EnderEmit.UF));

         oResp.AddPair('destinatario',cDestinatario+' '+ACBrNFe1.NotasFiscais.Items[0].NFe.Dest.xNome);
         oResp.AddPair('destinatario_tipo','F');
         oResp.AddPair('cnpj_destinatario',FormataCPFCNPJ(ACBRNFe1.NotasFiscais.Items[0].NFe.Dest.CNPJCPF));
         oResp.AddPair('cidade_destinatario',UpperCase(ACBrNFe1.NotasFiscais.Items[0].NFe.Dest.EnderDest.xMun+' '+ACBrNFe1.NotasFiscais.Items[0].NFe.Dest.EnderDest.UF));
         oResp.AddPair('uf_destinatario',UpperCase(ACBrNFe1.NotasFiscais.Items[0].NFe.Dest.EnderDest.UF));

         // ACBrNFe1.NotasFiscais.Items[0].NFe.Emit.EnderEmit.xMun+' '+ACBrNFe1.NotasFiscais.Items[0].NFe.Emit.EnderEmit.UF)
         // UpperCase(ACBrNFe1.NotasFiscais.Items[0].NFe.Dest.EnderDest.xMun+' '+ACBrNFe1.NotasFiscais.Items[0].NFe.Dest.EnderDest.UF)

         cOrigem  := cOrigem + ' ' + UpperCase(ACBrNFe1.NotasFiscais.Items[0].NFe.Emit.xNome);
         cDestino := cDestino + ' ' + UpperCase(ACBrNFe1.NotasFiscais.Items[0].NFe.Dest.xNome);

         oResp.AddPair('origem',cOrigem);
         oResp.AddPair('destino',cDestino);

         if(qUSU.FieldByName('ESTADOE').AsString <> ACBrNFe1.NotasFiscais.Items[0].NFe.Dest.EnderDest.UF)then
            oResp.AddPair('cfop','6353')
         else
            oResp.AddPair('cfop','5353');

         oResp.AddPair('tipo_cte','0');

         qREG.Close;
         qREG.SQL.Text := 'SELECT CODIGO,NOME,CARACTERISTICA,CSTB,COALESCE(FRETEUNID,''TON'') AS FRETEUNID,'+
         'TOLPERC AS TOLERANCIA,CSTA||CSTB AS CST,ALIQUOTA,BASERED,OBSCTE,DIGITATOL '+
         'FROM PRODUTOS '+
         'WHERE (SELECT RESULTADO FROM EXTRAI_NUMERO(NCM))='+QuotedStr(SoNumero(ACBrNFe1.NotasFiscais.Items[0].NFe.Det[0].Prod.NCM));
         sql := qREG.SQL.Text;
         qREG.Open;

         if(qREG.Eof)then
            CadastraProduto(qREG,ACBRNFe1);

         nQuan := (ACBrNFe1.NotasFiscais.Items[0].NFe.Det[0].Prod.qCom);
         if(UpperCase(Copy(ACBrNFe1.NotasFiscais.Items[0].NFe.Det[0].Prod.uCom,1,1)) = 'T')then
            nQuan := nQuan * 1000;

         oResp.AddPair('mercadoria',qREG.FieldByName('CODIGO').ASString+' '+qREG.FieldByName('NOME').ASString);
         oResp.AddPair('quantidade',FloatTOStr(nQuan));
         oResp.AddPair('valor_mercadoria',FormatFloat(',#0.00',ACBrNFe1.NotasFiscais.Items[0].NFe.Det[0].Prod.vProd));
         oResp.AddPair('especie_mercadoria',qREG.FieldByName('CARACTERISTICA').ASString);
         oResp.AddPair('unidade_mercadoria',qREG.FieldByName('FRETEUNID').ASString);
         oResp.AddPair('tolerancia',FormatFloat(',#0.00',qREG.FieldByName('TOLERANCIA').AsFloat));
         oResp.AddPair('cst',iif(qREG.FieldByName('CST').AsString.Length = 3, Copy(qREG.FieldByName('CST').AsString,2,3), qREG.FieldByName('CST').AsString));
         oResp.AddPair('aliquota',FormatFloat(',#0.00',qREG.FieldByName('ALIQUOTA').AsFloat));
         oResp.AddPair('reducao_base',FormatFloat(',#0.00',qREG.FieldByName('BASERED').AsFloat));
         oResp.AddPair('digital_tolerancia',qREG.FieldByName('DIGITATOL').ASString);
         oResp.AddPair('obs',RemoveQuebrasDeTexto(qREG.FieldByName('OBSCTE').ASString));
         oResp.AddPair('condicao_pagamento','0');

         qREG.Close;
         qREG.SQL.Text := 'SELECT V.CODIGO,V.PLACA,V.CAR1PLACA,'+
         'M.CODIGO AS CODIGOM,M.NOME AS NOMEM,M.CPF AS CPFM,M.CIDADE||'' ''||M.UF AS CIDADEM,'+
         'P.CODIGO AS CODIGOP,P.CNPJ AS CNPJP,P.NOME AS NOMEP,P.CIDADE||'' ''||P.UF AS CIDADEP '+
         'FROM VEICULO V '+
         'LEFT JOIN MOTORISTAS M ON M.CODIGO=V.MOTORISTA '+
         'LEFT JOIN PROPRIETARIOS P ON P.CODIGO=V.PROPRIETARIO '+
         'WHERE PLACA='+QuotedStr(FormataPlaca(ACBrNFe1.NotasFiscais.Items[0].NFe.Transp.veicTransp.placa));
         sql := qREG.SQL.Text;
         qREG.Open;

         if not (qREG.Eof)then begin
            // Result := '{"erro":1,"mensagem":"Veículo não cadastrado. Favor cadastrar veículo com placa : '+ACBrNFe1.NotasFiscais.Items[0].NFe.Transp.veicTransp.placa+'"}';
            // exit;

            oResp.AddPair('placa',FormataPlaca(ACBrNFe1.NotasFiscais.Items[0].NFe.Transp.veicTransp.placa));
            oResp.AddPair('motorista',qREG.FieldByName('CODIGOM').AsString+' '+qREG.FieldByName('NOMEM').AsString);
            oResp.AddPair('cpf_motorista',FormataCPFCNPJ(qREG.FieldByName('CPFM').AsString));
            oResp.AddPair('cidade_motorista',qREG.FieldByName('CIDADEM').AsString);

            oResp.AddPair('proprietario',qREG.FieldByName('CODIGOP').AsString+' '+qREG.FieldByName('NOMEP').AsString);
            oResp.AddPair('cpf_proprietario',FormataCPFCNPJ(qREG.FieldByName('CNPJP').AsString));
            oResp.AddPair('cidade_proprietario',qREG.FieldByName('CIDADEP').AsString);
         end;

         aNotas := TJSONArray.Create;
         oNota  := TJSONObject.Create;

         oNota.AddPair('item',TJSONNumber.Create(0));
         oNota.AddPair('tipo','NFe');
         oNota.AddPair('serie', IntToStr(ACBrNFe1.NotasFiscais.Items[0].NFe.Ide.serie));
         oNota.AddPair('numero',IntToStr(ACBrNFe1.NotasFiscais.Items[0].NFe.Ide.nNF));
         oNota.AddPair('data',FormatDateTime('yyyy-mm-dd',ACBrNFe1.NotasFiscais.Items[0].NFe.Ide.dEmi));
         oNota.AddPair('dias_entrega','2');
         oNota.AddPair('chave',SoNumero(ACBrNFe1.NotasFiscais.Items[0].NFe.infNFe.ID));
         oNota.AddPair('mercadoria',oResp.GetValue('mercadoria').Value);
         oNota.AddPair('quantidade',oResp.GetValue('quantidade').Value);
         oNota.AddPair('unidade',oResp.GetValue('unidade_mercadoria').Value);
         oNota.AddPair('valor_unitario',FormatFloat(',#0.00',(ACBrNFe1.NotasFiscais.Items[0].NFe.Det[0].Prod.vProd / nQuan)));
         oNota.AddPair('valor_mercadoria',FormatFloat(',#0.00',ACBrNFe1.NotasFiscais.Items[0].NFe.Det[0].Prod.vProd));

         aNotas.Add(oNota);

         oResp.AddPair('notas',aNotas);

         // oResp.AddPair('conhecimento',oResp);
         // oResp.AddPair('notas',aNotas);

         if cDB.InTransaction then
            cDB.Commit(TD);

         Commita(qREG);

         Result := oResp.ToString;
      except on E: Exception do begin
         if cDB.InTransaction then
            cDB.Rollback(TD);

         GravaLog('Erro ao importar XML:'+e.Message+sLineBreak+'SQL:'+sql);

         Result := TrataExecept(e.Message);
      end;
      end;
   finally
      oResp.DisposeOf;
      FreeAndNil(ACBRNFe1);
      FreeAndNil(qREG);
      FreeAndNil(qAUX);
   end;
end;



procedure TFretes.CadastraEmitente(qREG: TSQLQuery; ACBRNFe1: TACBRNFe);
var
   cCod : String;
   cDescontaQuebra : String;
   cAverbar        : String;
   sqlCampo        : String;
   sqlValor        : String;
   qAUX : TSQLQuery;
begin
   qAUX := TSQLQUery.Create(nil);
   qAUX.SQLConnection := qREG.SQLConnection;
   try
      qAUX.Close;
      qAUX.SQL.Text := 'SELECT CODIGO,DESC_QUEBRA,AVERBAR '+
      'FROM CLIENTES ' +
      'WHERE CNPJ='+QuotedStr(FormataCPFCNPJ(ACBRNFe1.NotasFiscais.Items[0].NFe.Emit.CNPJCPF));
      sql := qAUX.SQL.Text;
      qAUX.Open;

      cCod := '(SELECT COALESCE(MAX(CODIGO),0)+1 FROM CLIENTES)';

      cDescontaQuebra := 'N';
      cAverbar        := 'S';
      sqlCampo := ',DATA,DATAATUALIZ';
      sqlValor := ',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP';
      if not(qAUX.Eof) then begin
         cCod := qAUX.FieldByName('CODIGO').AsString;

         cDescontaQuebra := qAUX.FieldByName('DESC_QUEBRA').AsString;
         cAverbar        := qAUX.FieldByName('AVERBAR').AsString;

         sqlCampo        := ',DATAATUALIZ';
         sqlValor        := ',CURRENT_TIMESTAMP';
      end;

      qREG.Close;
      qREG.SQL.Clear;
      qREG.SQL.Add('UPDATE OR INSERT INTO CLIENTES');
      qREG.SQL.Add('(CODIGO,TIPO,NOME,FANTASIA,ENDERECO,NUMERO,BAIRRO,CEP,CIDADE,UF,CNPJ,IE,');
      qREG.SQL.Add('DESC_QUEBRA,AVERBAR,INATIVO,LIMITE,CODPAIS,BLOQUEADO'+sqlCampo+')');
      qREG.SQL.Add('VALUES('+cCod+',');
      qREG.SQL.Add(QuotedSan(iif(Length(soNumero(ACBRNFe1.NotasFiscais.Items[0].NFe.Emit.CNPJCPF)) = 11,'F','J'))+',');
      qREG.SQL.Add(QuotedSan(ACBrNFe1.NotasFiscais.Items[0].NFe.Emit.xNome)+',');
      qREG.SQL.Add(QuotedSan(ACBrNFe1.NotasFiscais.Items[0].NFe.Emit.xFant)+','+QuotedSan(ACBrNFe1.NotasFiscais.Items[0].NFe.Emit.EnderEmit.xLgr)+',');
      qREG.SQL.Add(TrataNumStr('0'+ACBrNFe1.NotasFiscais.Items[0].NFe.Emit.EnderEmit.nro)+','+QuotedSan(ACBrNFe1.NotasFiscais.Items[0].NFe.Emit.EnderEmit.xBairro)+',');
      qREG.SQL.Add(QuotedStr(FormataCep(IntToStr(ACBrNFe1.NotasFiscais.Items[0].NFe.Emit.EnderEmit.CEP)))+','+QuotedSan(ACBrNFe1.NotasFiscais.Items[0].NFe.Emit.EnderEmit.xMun)+',');
      qREG.SQL.Add(QuotedStr(ACBrNFe1.NotasFiscais.Items[0].NFe.Emit.EnderEmit.UF)+','+QuotedStr(FormataCPFCNPJ(ACBRNFe1.NotasFiscais.Items[0].NFe.Emit.CNPJCPF))+',');
      qREG.SQL.Add(QuotedStr(ACBRNFe1.NotasFiscais.Items[0].NFe.Emit.IE)+','+QuotedStr(cDescontaQuebra)+',');
      qREG.SQL.Add(QuotedStr(cAverbar)+','+QuotedStr('N')+',');
      qREG.SQL.Add('0,'+QuotedStr('1058')+','+QuotedStr('N'));
      qREG.SQL.Add(sqlValor);
      qREG.SQL.Add(') RETURNING CODIGO');
      sql := qREG.SQL.Text;
      qREG.Open;
   finally
      FreeAndNil(qAUX);
   end;
end;



procedure TFretes.CadastraDestinatario(qREG: TSQLQuery; ACBRNFe1: TACBRNFe);
var
   cCod : String;
   cDescontaQuebra : String;
   cAverbar        : String;
   sqlCampo        : String;
   sqlValor        : String;
   qAUX : TSQLQuery;
begin
   qAUX := TSQLQUery.Create(nil);
   qAUX.SQLConnection := qREG.SQLConnection;
   try
      qAUX.Close;
      qAUX.SQL.Text := 'SELECT CODIGO '+
      'FROM FORNECEDORES ' +
      'WHERE CNPJ='+QuotedStr(FormataCPFCNPJ(ACBRNFe1.NotasFiscais.Items[0].NFe.Dest.CNPJCPF));
      sql := qAUX.SQL.Text;
      qAUX.Open;

      cCod := '(SELECT COALESCE(MAX(CODIGO),0)+1 FROM FORNECEDORES)';

      cDescontaQuebra := 'N';
      cAverbar        := 'S';
      sqlCampo := ',DATA,DATAATUALIZ';
      sqlValor := ',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP';
      if not(qAUX.Eof) then begin
         cCod := qAUX.FieldByName('CODIGO').AsString;

         sqlCampo        := ',DATAATUALIZ';
         sqlValor        := ',CURRENT_TIMESTAMP';
      end;

      qREG.Close;
      qREG.SQL.Clear;
      qREG.SQL.Add('UPDATE OR INSERT INTO FORNECEDORES');
      qREG.SQL.Add('(CODIGO,TIPO,NOME,FANTASIA,ENDERECO,NUMERO,BAIRRO,CEP,CIDADE,UF,CNPJ,IE,');
      qREG.SQL.Add('INATIVO,LIMITE,CODPAIS,BLOQUEADO'+sqlCampo+')');
      qREG.SQL.Add('VALUES('+cCod+',');
      qREG.SQL.Add(QuotedSan(iif(Length(soNumero(ACBRNFe1.NotasFiscais.Items[0].NFe.Dest.CNPJCPF)) = 11,'F','J'))+',');
      qREG.SQL.Add(QuotedSan(ACBrNFe1.NotasFiscais.Items[0].NFe.Dest.xNome)+',');
      qREG.SQL.Add(QuotedSan(ACBrNFe1.NotasFiscais.Items[0].NFe.Dest.xNome)+','+QuotedSan(ACBrNFe1.NotasFiscais.Items[0].NFe.Dest.EnderDest.xLgr)+',');
      qREG.SQL.Add(TrataNumStr('0'+ACBrNFe1.NotasFiscais.Items[0].NFe.Dest.EnderDest.nro)+','+QuotedSan(ACBrNFe1.NotasFiscais.Items[0].NFe.Dest.EnderDest.xBairro)+',');
      qREG.SQL.Add(QuotedStr(FormataCep(IntToStr(ACBrNFe1.NotasFiscais.Items[0].NFe.Dest.EnderDest.CEP)))+','+QuotedSan(ACBrNFe1.NotasFiscais.Items[0].NFe.Dest.EnderDest.xMun)+',');
      qREG.SQL.Add(QuotedStr(ACBrNFe1.NotasFiscais.Items[0].NFe.Dest.EnderDest.UF)+','+QuotedStr(FormataCPFCNPJ(ACBRNFe1.NotasFiscais.Items[0].NFe.Dest.CNPJCPF))+',');
      qREG.SQL.Add(QuotedStr(ACBRNFe1.NotasFiscais.Items[0].NFe.Dest.IE)+','+QuotedStr('N')+',');
      qREG.SQL.Add('0,'+QuotedStr('1058')+','+QuotedStr('N'));
      qREG.SQL.Add(sqlValor);
      qREG.SQL.Add(') RETURNING CODIGO');
      sql := qREG.SQL.Text;
      qREG.Open;
   finally
      FreeAndNil(qAUX);
   end;

end;

procedure TFretes.CadastraProduto(qREG: TSQLQuery; ACBRNFe1: TACBRNFe);
var
   cCod : String;
   cDescontaQuebra : String;
   cAverbar        : String;
   sqlCampo        : String;
   sqlValor        : String;
   qAUX : TSQLQuery;
begin
   qAUX := TSQLQUery.Create(nil);
   qAUX.SQLConnection := qREG.SQLConnection;
   try
      cCod := '(SELECT COALESCE(MAX(CODIGO),0)+1 FROM PRODUTOS)';

      cDescontaQuebra := 'N';
      cAverbar        := 'S';
      sqlCampo := ',DATA,DATAATUALIZ';
      sqlValor := ',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP';
      if not(qAUX.Eof) then begin
         cCod := qAUX.FieldByName('CODIGO').AsString;

         sqlCampo        := ',DATAATUALIZ';
         sqlValor        := ',CURRENT_TIMESTAMP';
      end;

      qREG.Close;
      qREG.SQL.Clear;
      qREG.SQL.Add('UPDATE OR INSERT INTO PRODUTOS(');
      qREG.SQL.Add('CODIGO,NCM,NOME,UNIDADE,VOLUME,');
      qREG.SQL.Add('QUANTIDADE,VRPRODUTO,ESPECIE,');
      qREG.SQL.Add('FRETE,FRETEUNID,CSTA,CSTB,');
      qREG.SQL.Add('ALIQUOTA,BASERED,TOLPERC,PAGAICMS,DIGITAPESO,');
      qREG.SQL.Add('OBSCTE,DIGITATOL,TIPOCARGA,EAN)');
      qREG.SQL.Add('VALUES('+cCod+','+QuotedStr(ACBrNFe1.NotasFiscais.Items[0].NFe.Det.Items[0].Prod.NCM)+',');
      qREG.SQL.Add(QuotedStr(ACBrNFe1.NotasFiscais.Items[0].NFe.Det.Items[0].Prod.xProd)+',');
      qREG.SQL.Add(QuotedStr(ACBrNFe1.NotasFiscais.Items[0].NFe.Det.Items[0].Prod.uCom)+',');
      qREG.SQL.Add('NULL,NULL,');
      qREG.SQL.Add(ValorSQL(FloatToStr(ACBrNFe1.NotasFiscais.Items[0].NFe.Det.Items[0].Prod.vUnCom))+',');
      qREG.SQL.Add(QuotedStr(ACBrNFe1.NotasFiscais.Items[0].NFe.Transp.Vol[0].esp)+',');
      qREG.SQL.Add(ValorSQL(FloatToStr(ACBrNFe1.NotasFiscais.Items[0].NFe.Det.Items[0].Prod.vUnCom))+','); // unidade de valor
      qREG.SQL.Add(QuotedStr(TrataTipoProduto(ACBrNFe1.NotasFiscais.Items[0].NFe.Det.Items[0].Prod.uCom))+','); // FRETEUNID
      qREG.SQL.Add(QuotedStr('')+','); //CSTA
      qREG.SQL.Add(QuotedStr('')+','); //CSTB
      qREG.SQL.Add('0.00,'); //ALIQUITOTA
      qREG.SQL.Add('0.00,'); //BASRED
      qREG.SQL.Add('0,'); //TOLPERC
      qREG.SQL.Add('NULL,'); //PAGAICMS
      qREG.SQL.Add('NULL,'); //DIGITAPESO
      qREG.SQL.Add('NULL,'); //OBSCTE
      qREG.SQL.Add('NULL,'); //DIGITATOL
      qREG.SQL.Add('NULL,'); //TIPOCARGA
      qREG.SQL.Add(QuotedStr(ACBrNFe1.NotasFiscais.Items[0].NFe.Det.Items[0].Prod.cEAN)+')');
      qREG.SQL.Add('RETURNING CODIGO'); //TIPOCARGA
      sql := qREG.SQL.Text;
      qREG.Open;

      cCod := qREG.FieldByName('CODIGO').AsString;

      qREG.Close;
      qREG.SQL.Text := 'SELECT CODIGO,NOME,CARACTERISTICA,CSTB,COALESCE(FRETEUNID,''TON'') AS FRETEUNID,'+
      'TOLPERC AS TOLERANCIA,CSTA||CSTB AS CST,ALIQUOTA,BASERED,OBSCTE,DIGITATOL '+
      'FROM PRODUTOS '+
      'WHERE CODIGO=0'+cCod;
      sql := qREG.SQL.Text;
      qREG.Open;
   finally
      FreeAndNil(qAUX);
   end;

end;

procedure TFretes.CadastraOrigem(qREG: TSQLQuery; ACBRNFe1: TACBRNFe);
var
   cCod : String;
   sqlCampo        : String;
   sqlValor        : String;
   qAUX : TSQLQuery;
begin
   qAUX := TSQLQUery.Create(nil);
   qAUX.SQLConnection := qREG.SQLConnection;
   try
      qAUX.Close;
      qAUX.SQL.Text := 'SELECT CODIGO '+
      'FROM ORIGENS ' +
      'WHERE CNPJ='+QuotedStr(FormataCPFCNPJ(ACBRNFe1.NotasFiscais.Items[0].NFe.Emit.CNPJCPF));
      sql := qAUX.SQL.Text;
      qAUX.Open;

      cCod := '(SELECT COALESCE(MAX(CODIGO),0)+1 FROM ORIGENS)';

      sqlCampo := ',DATA,DATAATUALIZ';
      sqlValor := ',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP';
      if not(qAUX.Eof) then begin
         cCod := qAUX.FieldByName('CODIGO').AsString;

         sqlCampo        := ',DATAATUALIZ';
         sqlValor        := ',CURRENT_TIMESTAMP';
      end;

      qREG.Close;
      qREG.SQL.Clear;
      qREG.SQL.Add('UPDATE OR INSERT INTO ORIGENS');
      qREG.SQL.Add('(CODIGO,NOME,ENDERECO,NUMERO,BAIRRO,CEP,CIDADE,UF,CELULAR,IE,CNPJ,TIPO,');
      qREG.SQL.Add('INATIVO'+sqlCampo+')');
      qREG.SQL.Add('VALUES('+cCod+',');
      qREG.SQL.Add(QuotedSan(ACBrNFe1.NotasFiscais.Items[0].NFe.Emit.xNome)+','); // nome
      qREG.SQL.Add(QuotedSan(ACBrNFe1.NotasFiscais.Items[0].NFe.Emit.EnderEmit.xLgr)+','); // endereco
      qREG.SQL.Add(TrataNumStr('0'+ACBrNFe1.NotasFiscais.Items[0].NFe.Emit.EnderEmit.nro)+','); // numbero
      qREG.SQL.Add(QuotedSan(ACBrNFe1.NotasFiscais.Items[0].NFe.Emit.EnderEmit.xBairro)+','); // bairro
      qREG.SQL.Add(QuotedStr(FormataCep(IntToStr(ACBrNFe1.NotasFiscais.Items[0].NFe.Emit.EnderEmit.CEP)))+','); // CEP
      qREG.SQL.Add(QuotedSan(ACBrNFe1.NotasFiscais.Items[0].NFe.Emit.EnderEmit.xMun)+',');// cidade
      qREG.SQL.Add(QuotedStr(ACBrNFe1.NotasFiscais.Items[0].NFe.Emit.EnderEmit.UF)+','); // uf
      qREG.SQL.Add(QuotedStr(ACBrNFe1.NotasFiscais.Items[0].NFe.Emit.EnderEmit.fone)+','); // celular
      qREG.SQL.Add(QuotedStr(ACBRNFe1.NotasFiscais.Items[0].NFe.Emit.IE)+','); // ie
      qREG.SQL.Add(QuotedStr(FormataCPFCNPJ(ACBRNFe1.NotasFiscais.Items[0].NFe.Emit.CNPJCPF))+','); // cpf cnpj
      qREG.SQL.Add(QuotedSan(iif(Length(soNumero(ACBRNFe1.NotasFiscais.Items[0].NFe.Emit.CNPJCPF)) = 11,'F','J'))+','); // tipo
      qREG.SQL.Add(QuotedStr('N')); // inativo
      qREG.SQL.Add(sqlValor);
      qREG.SQL.Add(') RETURNING CODIGO');
      sql := qREG.SQL.Text;
      qREG.Open;
   finally
      FreeAndNil(qAUX);
   end;
end;

procedure TFretes.CadastraDestino(qREG: TSQLQuery; ACBRNFe1: TACBRNFe);
var
   cCod : String;
   sqlCampo        : String;
   sqlValor        : String;
   qAUX : TSQLQuery;
begin
   qAUX := TSQLQUery.Create(nil);
   qAUX.SQLConnection := qREG.SQLConnection;
   try
      qAUX.Close;
      qAUX.SQL.Text := 'SELECT CODIGO '+
      'FROM DESTINOS ' +
      'WHERE CNPJ='+QuotedStr(FormataCPFCNPJ(ACBRNFe1.NotasFiscais.Items[0].NFe.Dest.CNPJCPF));
      sql := qAUX.SQL.Text;
      qAUX.Open;

      cCod := '(SELECT COALESCE(MAX(CODIGO),0)+1 FROM DESTINOS)';

      sqlCampo := ',DATA,DATAATUALIZ';
      sqlValor := ',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP';
      if not(qAUX.Eof) then begin
         cCod := qAUX.FieldByName('CODIGO').AsString;

         sqlCampo        := ',DATAATUALIZ';
         sqlValor        := ',CURRENT_TIMESTAMP';
      end;

      qREG.Close;
      qREG.SQL.Clear;
      qREG.SQL.Add('UPDATE OR INSERT INTO DESTINOS');
      qREG.SQL.Add('(CODIGO,NOME,ENDERECO,NUMERO,BAIRRO,CEP,CIDADE,UF,CELULAR,IE,CNPJ,TIPO,');
      qREG.SQL.Add('INATIVO'+sqlCampo+')');
      qREG.SQL.Add('VALUES('+cCod+',');
      qREG.SQL.Add(QuotedSan(ACBrNFe1.NotasFiscais.Items[0].NFe.Dest.xNome)+','); // nome
      qREG.SQL.Add(QuotedSan(ACBrNFe1.NotasFiscais.Items[0].NFe.Dest.EnderDest.xLgr)+','); // endereco
      qREG.SQL.Add(TrataNumStr('0'+ACBrNFe1.NotasFiscais.Items[0].NFe.Dest.EnderDest.nro)+','); // numbero
      qREG.SQL.Add(QuotedSan(ACBrNFe1.NotasFiscais.Items[0].NFe.Dest.EnderDest.xBairro)+','); // bairro
      qREG.SQL.Add(QuotedStr(FormataCep(IntToStr(ACBrNFe1.NotasFiscais.Items[0].NFe.Dest.EnderDest.CEP)))+','); // CEP
      qREG.SQL.Add(QuotedSan(ACBrNFe1.NotasFiscais.Items[0].NFe.Dest.EnderDest.xMun)+',');// cidade
      qREG.SQL.Add(QuotedStr(ACBrNFe1.NotasFiscais.Items[0].NFe.Dest.EnderDest.UF)+','); // uf
      qREG.SQL.Add(QuotedStr(Copy(ACBrNFe1.NotasFiscais.Items[0].NFe.Dest.EnderDest.fone,1,13))+','); // celular
      qREG.SQL.Add(QuotedStr(ACBRNFe1.NotasFiscais.Items[0].NFe.Dest.IE)+','); // ie
      qREG.SQL.Add(QuotedStr(FormataCPFCNPJ(ACBRNFe1.NotasFiscais.Items[0].NFe.Dest.CNPJCPF))+','); // cpf cnpj
      qREG.SQL.Add(QuotedSan(iif(Length(soNumero(ACBRNFe1.NotasFiscais.Items[0].NFe.Dest.CNPJCPF)) = 11,'F','J'))+','); // tipo
      qREG.SQL.Add(QuotedStr('N')); // inativo
      qREG.SQL.Add(sqlValor);
      qREG.SQL.Add(') RETURNING CODIGO');
      sql := qREG.SQL.Text;
      qREG.Open;
   finally
      FreeAndNil(qAUX);
   end;
end;


end.

