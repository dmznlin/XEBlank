{*******************************************************************************
  作者: dmzn@163.com 2021-08-06
  描述: 文本编辑器
*******************************************************************************}
unit UFormMemo;

interface

uses
  System.SysUtils, UFormNormal, UFormBase, System.IniFiles, ULibFun,
  uniGUIClasses, uniMemo, uniHTMLMemo, uniPanel, System.Classes, Vcl.Controls,
  Vcl.Forms, uniGUIBaseClasses, uniButton, uniBitBtn, UniFSButton;

type
  TfFormMemo = class(TfFormNormal)
    Memo1: TUniHTMLMemo;
  private
    { Private declarations }
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

class function TfFormMemo.ConfigMe: TfFormConfig;
begin
  Result := inherited ConfigMe();
  Result.FUserConfig := True;
  Result.FDesc := '文本编辑器';
end;

procedure TfFormMemo.DoFormConfig(nIni: TIniFile; const nLoad: Boolean);
begin
  if nLoad then
  begin
    TWebSystem.LoadFormConfig(Self, nIni);
  end else
  begin
    TWebSystem.SaveFormConfig(Self, nIni);
  end;
end;

function TfFormMemo.SetData(const nData: PCommandParam): Boolean;
begin
  Result := inherited SetData(nData);
  if (nData.Command = cCmd_ViewData) and nData.IsValid(ptStr, 2) then
  begin
    BtnOK.Enabled := False;
    Memo1.Text := nData.Str[0];
    Caption := nData.Str[1];
  end;

  if (nData.Command = cCmd_ViewFile) and nData.IsValid(ptStr, 2) then
  begin
    BtnOK.Enabled := False;
    Memo1.Lines.LoadFromFile(nData.Str[0]);
    Caption := nData.Str[1];
  end;
end;

initialization
  TWebSystem.AddForm(TfFormMemo);
end.
