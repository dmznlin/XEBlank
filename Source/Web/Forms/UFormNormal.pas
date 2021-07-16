{*******************************************************************************
  ����: dmzn@163.com 2021-04-27
  ����: �Ի���ʽ�������
*******************************************************************************}
unit UFormNormal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, UFormBase, uniButton,
  uniBitBtn, UniFSButton, System.Classes, Vcl.Controls, Vcl.Forms,
  uniGUIBaseClasses, uniGUIClasses, uniPanel;

type
  TfFormNormal = class(TfFormBase)
    BtnExit: TUniFSButton;
    BtnOK: TUniFSButton;
    procedure BtnOKClick(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
  protected
    { Protected declarations }
    FConnID: string;
    {*���ݱ�ʶ*}
    procedure OnCreateForm(Sender: TObject); override;
    {*���෽��*}
    procedure GetSaveSQLList(const nList: TStrings); virtual;
    {*дSQL�б�*}
    procedure AfterSaveData(var nDefault: Boolean); virtual;
    {*��������*}
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  MainModule, UManagerGroup, ULibFun;

procedure TfFormNormal.OnCreateForm(Sender: TObject);
begin
  inherited;
  FConnID := '';
end;

//Desc: д����SQL�б�
procedure TfFormNormal.GetSaveSQLList(const nList: TStrings);
begin
  nList.Clear;
end;

//Desc: �����������
procedure TfFormNormal.AfterSaveData(var nDefault: Boolean);
begin

end;

procedure TfFormNormal.BtnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfFormNormal.BtnOKClick(Sender: TObject);
var nBool: Boolean;
    nList: TStrings;
begin
  if not IsDataValid then Exit;

  nList := nil;
  try
    nList := gMG.FObjectPool.Lock(TStrings) as TStrings;
    GetSaveSQLList(nList);

    if nList.Count > 0 then
      //DBExecute(nList, nil, FDBType);
    gMG.FObjectPool.Release(nList);

    nList := nil;
    nBool := True;
    AfterSaveData(nBool);

    if nBool then
    begin
      ModalResult := mrOK;
      ShowMessage('�ѱ���ɹ�');
    end;
  except
    on nErr: Exception do
    begin
      gMG.FObjectPool.Release(nList);
      ShowMessage('����ʧ��: ' + nErr.Message);
    end;
  end;
end;

end.
