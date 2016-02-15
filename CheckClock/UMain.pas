unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, sStatusBar, StdCtrls, Buttons, sBitBtn, sLabel,
  cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, cxTextEdit, cxSpinEdit;

type
  TFMain = class(TForm)
    sb: TsStatusBar;
    btnCheckIn: TsBitBtn;
    btnCheck: TsBitBtn;
    lbl1: TsLabel;
    lbl2: TsLabel;
    grid: TcxGrid;
    View: TcxGridDBTableView;
    Level: TcxGridLevel;
    vwUserId: TcxGridDBColumn;
    vwNama: TcxGridDBColumn;
    vwKondisi: TcxGridDBColumn;
    procedure FormCreate(Sender: TObject);
    procedure btnCheckInClick(Sender: TObject);
    procedure btnCheckClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ViewCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

implementation

uses UDM, UCheckIO;

{$R *.dfm}

function program_versi:string;
var V1, V2, V3, V4: Word;
   VerInfoSize, VerValueSize, Dummy : DWORD;
   VerInfo : Pointer;
   VerValue : PVSFixedFileInfo;
begin
VerInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), Dummy);
GetMem(VerInfo, VerInfoSize);
GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo);
VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
With VerValue^ do
begin
  V1 := dwFileVersionMS shr 16;
  V2 := dwFileVersionMS and $FFFF;
  V3 := dwFileVersionLS shr 16;
  V4 := dwFileVersionLS and $FFFF;
end;
FreeMem(VerInfo, VerInfoSize);

Result := IntToStr(V1) + '.'
            + IntToStr(V2) + '.'
            + IntToStr(V3) + '.'
            + IntToStr(V4);
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
  sb.Panels[0].Text := program_versi;
  sb.Panels[1].Text := dm.xConn.DatabaseName + '@' +dm.xConn.Host;
end;

procedure TFMain.btnCheckInClick(Sender: TObject);
begin
  Application.CreateForm(TFChekIO,FChekIO);
  jenis := 'IN';
  FChekIO.ShowModal;
end;

procedure TFMain.btnCheckClick(Sender: TObject);
begin
  Application.CreateForm(TFChekIO,FChekIO);
  jenis := 'OUT';
  FChekIO.ShowModal;
end;

procedure TFMain.FormShow(Sender: TObject);
begin
  dm.refreshTable;
end;

procedure TFMain.ViewCustomDrawCell(Sender: TcxCustomGridTableView;
  ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
  var ADone: Boolean);
begin
  if (AViewInfo.Text = 'CHECKOUT') then
  begin
    ACanvas.Font.Color := clYellow;
    ACanvas.Brush.Color := clRed;
  end else
  if (AViewInfo.Text = 'CHECKIN') then
  begin
    ACanvas.Font.Color := clYellow;
    ACanvas.Brush.Color := clBlue;
  end;
end;

end.
