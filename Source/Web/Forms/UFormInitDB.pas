{*******************************************************************************
  作者: dmzn@163.com 2021-04-28
  描述: 初始化数据库
*******************************************************************************}
unit UFormInitDB;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms,
  UFormBase, uniGUIBaseClasses, uniGUIClasses, uniPanel, uniMemo, uniMultiItem,
  uniComboBox, uniLabel, uniButton;

type
  TfFormInitDB = class(TfFormBase)
    EditDB: TUniComboBox;
    EditLog: TUniMemo;
    BtnStart: TUniButton;
    procedure UniFormCreate(Sender: TObject);
    procedure BtnStartClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function ConfigMe: TfFormConfig; override;
  end;

implementation

{$R *.dfm}

uses
  uniGUIVars, MainModule, ULibFun, UDBManager, USysBusiness;

const
  sTag = ' ::: ';

class function TfFormInitDB.ConfigMe: TfFormConfig;
begin
  Result := inherited ConfigMe();
  Result.FVerifyAdmin := True;
  Result.FDesc := '初始化数据库';
end;

procedure TfFormInitDB.UniFormCreate(Sender: TObject);
var nDB: TDBConnConfig;
begin
  EditDB.Items.Clear;
  for nDB in gDBManager.DBList.Values do
    EditDB.Items.Add(nDB.FID + sTag + nDB.FName);
  //xxxxx

  if EditDB.Items.Count > 0 then
    EditDB.ItemIndex := 0;
  //xxxxx
end;

procedure TfFormInitDB.BtnStartClick(Sender: TObject);
var nStr: string;
begin
  if EditDB.ItemIndex < 0 then
  begin
    UniMainModule.ShowMsg('请选择数据库');
    Exit;
  end;

  try
    BtnStart.Enabled := False;
    nStr := Copy(EditDB.Text, 1, Pos(sTag, EditDB.Text) - 1);
    gDBManager.InitDB(nStr, EditLog.Lines);
  finally
    BtnStart.Enabled := True;
  end;
end;

initialization
  TWebSystem.AddForm(TfFormInitDB);
end.
