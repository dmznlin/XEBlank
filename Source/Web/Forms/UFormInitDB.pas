{*******************************************************************************
  ����: dmzn@163.com 2021-04-28
  ����: ��ʼ�����ݿ�
*******************************************************************************}
unit UFormInitDB;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms,
  UFormBase, uniGUIBaseClasses, uniGUIClasses, uniPanel, uniMemo, uniMultiItem,
  uniComboBox, uniLabel, uniButton;

type
  TfFormInitDB = class(TfFormBase)
    UniLabel1: TUniLabel;
    EditDB: TUniComboBox;
    EditLog: TUniMemo;
    BtnStart: TUniButton;
    procedure UniFormCreate(Sender: TObject);
    procedure BtnStartClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  uniGUIVars, MainModule, ULibFun, UDBManager;

const
  sTag = ' ::: ';

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
    UniMainModule.ShowMsg('��ѡ�����ݿ�');
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
  RegisterClass(TfFormInitDB);
end.
