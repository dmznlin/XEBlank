{*******************************************************************************
  作者: dmzn@163.com 2021-04-27
  描述: 对话框式窗体基类
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
    {*数据标识*}
    procedure OnCreateForm(Sender: TObject); override;
    {*基类方法*}
    procedure GetSaveSQLList(const nList: TStrings); virtual;
    {*写SQL列表*}
    procedure AfterSaveData(var nDefault: Boolean); virtual;
    {*后续动作*}
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

//Desc: 写数据SQL列表
procedure TfFormNormal.GetSaveSQLList(const nList: TStrings);
begin
  nList.Clear;
end;

//Desc: 保存后续动作
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
      ShowMessage('已保存成功');
    end;
  except
    on nErr: Exception do
    begin
      gMG.FObjectPool.Release(nList);
      ShowMessage('保存失败: ' + nErr.Message);
    end;
  end;
end;

end.
