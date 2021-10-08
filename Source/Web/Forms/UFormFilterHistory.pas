{*******************************************************************************
  作者: dmzn@163.com 2021-08-13
  描述: 查询条件历史记录
*******************************************************************************}
unit UFormFilterHistory;

interface

uses
  System.SysUtils, UFormNormal, UFormBase, System.IniFiles, ULibFun,
  uniGUIClasses, uniMemo, uniHTMLMemo, uniPanel, System.Classes, Vcl.Controls,
  Vcl.Forms, uniGUIBaseClasses, uniButton, uniBitBtn, UniFSButton, uniSplitter,
  uniMultiItem, uniListBox, uniEdit;

type
  TfFormFilterHistory = class(TfFormNormal)
    Splitter1: TUniSplitter;
    Memo1: TUniMemo;
    PanelL: TUniSimplePanel;
    List1: TUniListBox;
    PanelB: TUniSimplePanel;
    BtnAdd: TUniButton;
    BtnDel: TUniButton;
    EditName: TUniEdit;
    procedure BtnAddClick(Sender: TObject);
    procedure List1Click(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    FChanged: Boolean;
    FFilterList: TStrings;
    procedure FilterHistory(const nForm,nCtrl: string; const nLoad: Boolean;
      nIni: TIniFile = nil);
    {*过滤条件*}
    procedure RefreshFilterList();
    {*刷新界面*}
  public
    { Public declarations }
    class function ConfigMe: TfFormConfig; override;
    function SetData(const nData: PCommandParam): Boolean; override;
    procedure DoFormConfig(nIni: TIniFile; const nLoad: Boolean); override;
  end;

implementation

{$R *.dfm}

uses
  UManagerGroup, MainModule, USysBusiness, USysConst;

class function TfFormFilterHistory.ConfigMe: TfFormConfig;
begin
  Result := inherited ConfigMe();
  Result.FUserConfig := True;
  Result.FDesc := '查询条件历史记录';
end;

procedure TfFormFilterHistory.DoFormConfig(nIni: TIniFile; const nLoad: Boolean);
var nInt: Integer;
begin
  if nLoad then
  begin
    FChanged := False;
    FFilterList := TStringList.Create;
    Memo1.ReadOnly := not UniMainModule.FUser.FIsAdmin; //管理员可修改

    TWebSystem.LoadFormConfig(Self, nIni);
    nInt := nIni.ReadInteger(Name, 'PanelWidth', 0);
    if nInt > 120 then
      PanelL.Width := nInt;
    //xxxxx
  end else
  begin
    if FChanged and FParam.IsValid(ptStr, 2) then
      FilterHistory(FParam.Str[0], FParam.Str[1], False, nIni);
    FreeAndNil(FFilterList);

    TWebSystem.SaveFormConfig(Self, nIni);
    nIni.WriteInteger(Name, 'PanelWidth', PanelL.Width);
  end;
end;

//Date: 2021-08-13
//Parm: 窗体名称;组件名称;是否加载
//Desc: 读取 or 保存nForm.nCtrl组件的查询历史记录
procedure TfFormFilterHistory.FilterHistory(const nForm, nCtrl: string;
  const nLoad: Boolean; nIni: TIniFile);
var nStr: string;
    nBool: Boolean;
begin
  nBool := Assigned(nIni);
  try
    if not nBool then
      nIni := TWebSystem.UserConfigFile();
    //new ini

    if nLoad then
    begin
      nStr := nIni.ReadString(nForm, nCtrl + '_GridFilterHistory', '');
      if nStr <> '' then
      begin
        FFilterList.Text := TEncodeHelper.DecodeBase64(nStr);
        RefreshFilterList();
      end;
    end else
    begin
      nStr := TEncodeHelper.EncodeBase64(FFilterList.Text);
      nIni.WriteString(nForm, nCtrl + '_GridFilterHistory', nStr);
    end;
  finally
    if not nBool then
      nIni.Free;
    //xxxxx
  end;
end;

//Date: 2021-08-13
//Desc: 加载历史记录到界面
procedure TfFormFilterHistory.RefreshFilterList;
var nIdx,nInt: Integer;
begin
  with List1 do
  try
    nInt := ItemIndex;
    Items.BeginUpdate;
    Items.Clear;

    for nIdx := 0 to FFilterList.Count-1 do
      Items.Add(FFilterList.Names[nIdx]);
    //xxxxx

    if Items.Count > 0 then
    begin
      if nInt < 0 then
        nInt := 0
      else
      if nInt >= Items.Count then
        nInt := Items.Count - 1;
      //xxxxx

      ItemIndex := nInt;
      //new index
    end;
  finally
    Items.EndUpdate;
  end;
end;

function TfFormFilterHistory.SetData(const nData: PCommandParam): Boolean;
begin
  Result := inherited SetData(nData);
  if (nData.Command = cCmd_AddData) and nData.IsValid(ptStr, 3) then
  begin
    Caption := '查询条件 - 保存';
    BtnOK.Enabled := False;
    Memo1.Text := nData.Str[2];
    FilterHistory(nData.Str[0], nData.Str[1], True);
  end;

  if (nData.Command = cCmd_GetData) and nData.IsValid(ptStr, 2) then
  begin
    Caption := '查询条件 - 加载';
    FilterHistory(nData.Str[0], nData.Str[1], True);
  end;
end;

procedure TfFormFilterHistory.BtnAddClick(Sender: TObject);
var nStr,nMemo: string;
begin
  nStr := Trim(EditName.Text);
  if (nStr = '') or (Pos('=', nStr) > 0) then
  begin
    UniMainModule.ShowMsg('请填写名称');
    Exit;
  end;

  if ((List1.ItemIndex < 0) or (List1.Items[List1.ItemIndex] <> nStr)) and
      (FFilterList.IndexOfName(nStr) >= 0) then
  begin
    UniMainModule.ShowMsg('该名称已存在');
    Exit;
  end;

  nMemo := Trim(Memo1.Text);
  if nMemo = '' then
  begin
    UniMainModule.ShowMsg('查询条件为空');
    Exit;
  end;

  FFilterList.Values[nStr] := TEncodeHelper.EncodeBase64(nMemo);
  //add data
  FChanged := True;
  RefreshFilterList();
  UniMainModule.ShowMsg('更新成功');
end;

procedure TfFormFilterHistory.BtnDelClick(Sender: TObject);
var nStr: string;
begin
  if List1.ItemIndex >= 0 then
  begin
    nStr := List1.Items[List1.ItemIndex];
    FFilterList.Delete(FFilterList.IndexOfName(nStr));
    //remove data

    FChanged := True;
    RefreshFilterList();
  end;
end;

procedure TfFormFilterHistory.List1Click(Sender: TObject);
begin
  if List1.ItemIndex >= 0 then
  begin
    EditName.Text := List1.Items[List1.ItemIndex];
    Memo1.Text := TEncodeHelper.DecodeBase64(FFilterList.Values[EditName.Text]);
  end;
end;

procedure TfFormFilterHistory.BtnOKClick(Sender: TObject);
var nStr: string;
begin
  nStr := Trim(Memo1.Text);
  if nStr = '' then
  begin
    UniMainModule.ShowMsg('请选择有效的查询条件');
    Exit;
  end;

  FParam.Init(cCmd_ModalResult).AddS(nStr);
  ModalResult := mrOk;
end;

initialization
  TWebSystem.AddForm(TfFormFilterHistory);
end.
