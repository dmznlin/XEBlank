{*******************************************************************************
  作者: dmzn@163.com 2021-06-04
  描述: 切换语言
*******************************************************************************}
unit UFormSwitchLang;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, UFormNormal, UFormBase,
  uniRadioGroup, uniPanel, System.Classes, Vcl.Controls, Vcl.Forms,
  uniGUIBaseClasses, uniButton, uniBitBtn, UniFSButton, uniGUIClasses;

type
  TfFormSwitchLang = class(TfFormNormal)
    GroupLang: TUniRadioGroup;
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function ConfigMe: TfFormConfig; override;
    procedure OnCreateForm(Sender: TObject); override;
  end;

implementation

{$R *.dfm}

uses
  UManagerGroup, UDBFun, MainModule, USysBusiness;

class function TfFormSwitchLang.ConfigMe: TfFormConfig;
begin
  Result := inherited ConfigMe();
  Result.FDesc := '切换系统语言标识';
end;

procedure TfFormSwitchLang.OnCreateForm(Sender: TObject);
var nIdx: Integer;
begin
  inherited;
  with GroupLang, gMG.FMenuManager do
  try
    Items.BeginUpdate;
    Items.Clear;

    for nIdx := Low(MultiLanguage) to High(MultiLanguage) do
    with MultiLanguage[nIdx] do
    begin
      Items.Add(Format('%s(%s)', [FName, FID]));
      if FID = UniMainModule.FUser.FLangID then
        GroupLang.ItemIndex := nIdx;
      //xxxxx
    end;
  finally
    Items.EndUpdate;
  end;
end;

procedure TfFormSwitchLang.BtnOKClick(Sender: TObject);
var nStr: string;
begin
  if GroupLang.ItemIndex < 0 then
  begin
    UniMainModule.ShowMsg('请选择语言标识', True);
    Exit;
  end;

  nStr := 'Update %s Set U_Lang=''%s'' Where R_ID=%s';
  nStr := Format(nStr, [TDBCommand.sTable_Users,
          gMG.FMenuManager.MultiLanguage[GroupLang.ItemIndex].FID,
          UniMainModule.FUser.FRecordID]);
  gMG.FDBManager.DBExecute(nStr);

  ModalResult := mrOk;
  UniMainModule.ShowMsg('切换成功,重启后生效');
end;

initialization
  TWebSystem.AddForm(TfFormSwitchLang);
end.
