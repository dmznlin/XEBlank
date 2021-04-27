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
  protected
    { Protected declarations }
    FConnID: string;
    {*���ݱ�ʶ*}
    procedure OnCreateForm(Sender: TObject); override;
    {*���෽��*}
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; virtual;
    function IsDataValid: Boolean; virtual;
    {*��֤����*}
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

//Desc: ��֤Sender�������Ƿ���ȷ,������ʾ����
function TfFormNormal.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
begin
  nHint := '';
  Result := True;
end;

function TfFormNormal.IsDataValid: Boolean;
var nStr: string;
    nList: TList;
    nObj: TObject;
    i,nLen: integer;
begin
  nList := nil;
  try
    Result := True;
    nList := gMG.FObjectPool.Lock(TList) as TList;
    TApplicationHelper.EnumSubCtrlList(Self, nList);

    nLen := nList.Count - 1;
    for i:=0 to nLen do
    begin
      nObj := TObject(nList[i]);
      if not OnVerifyCtrl(nObj, nStr) then
      begin
        if nObj is TWinControl then
          TWinControl(nObj).SetFocus;
        //xxxxx

        if nStr <> '' then
          UniMainModule.ShowMsg(nStr);
        //xxxxx

        Result := False;
        Exit;
      end;
    end;
  finally
    gMG.FObjectPool.Release(nList);
  end;
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
