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
  protected
    { Protected declarations }
    FConnID: string;
    {*数据标识*}
    procedure OnCreateForm(Sender: TObject); override;
    {*基类方法*}
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; virtual;
    function IsDataValid: Boolean; virtual;
    {*验证数据*}
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

//Desc: 验证Sender的数据是否正确,返回提示内容
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

//Desc: 写数据SQL列表
procedure TfFormNormal.GetSaveSQLList(const nList: TStrings);
begin
  nList.Clear;
end;

//Desc: 保存后续动作
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
