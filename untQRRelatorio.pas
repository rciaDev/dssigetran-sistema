unit untQRRelatorio;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, QuickRpt, QRCtrls, Vcl.Imaging.pngimage, Data.DB,
  Datasnap.DBClient,System.StrUtils;

type
  TQRRelatorio = class(TQuickRep)
    TitleBand1: TQRBand;
    ColumnHeaderBand1: TQRBand;
    DetailBand1: TQRBand;
    SummaryBand1: TQRBand;
    QRLabel1: TQRLabel;
    QRExpr1: TQRExpr;
    PageFooterBand1: TQRBand;
    qrTitulo: TQRLabel;
    qrLOGOREL: TQRImage;
    QRSysData3: TQRSysData;
    QRSysData4: TQRSysData;
    GroupBand: TQRGroup;
    lbGroup: TQRLabel;
    tGER: TClientDataSet;
    lSomatoria: TQRLabel;
  private
  public
     sSomatoria:string;
  end;

var
  QRRelatorio: TQRRelatorio;

implementation

{$R *.DFM}


end.



