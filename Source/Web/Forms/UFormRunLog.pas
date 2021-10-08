{*******************************************************************************
  作者: dmzn@163.com 2021-05-31
  描述: 系统运行日志
*******************************************************************************}
unit UFormRunLog;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, UFormBase,
  uniButton, uniDateTimePicker, uniCheckBox, uniGUIClasses, uniMemo,
  uniGUIBaseClasses, uniPanel;

type
  TfFormRunLog = class(TfFormBase)
    EditLog: TUniMemo;
    CheckShow: TUniCheckBox;
    EditDate: TUniDateTimePicker;
    BtnLoad: TUniButton;
    CheckSimple: TUniCheckBox;
    procedure CheckShowChange(Sender: TObject);
    procedure BtnLoadClick(Sender: TObject);
  private
    { Private declarations }
    procedure OnEvent(const nEvent: string);
    {*记录日志*}
  public
    { Public declarations }
    class function ConfigMe: TfFormConfig; override;
    procedure OnCreateForm(Sender: TObject); override;
    procedure OnDestroyForm(Sender: TObject); override;
  end;

implementation

{$R *.dfm}

uses
  uniGUIVars, MainModule, UManagerGroup, USysBusiness;

class function TfFormRunLog.ConfigMe: TfFormConfig;
begin
  Result := inherited ConfigMe();
  Result.FVerifyAdmin := True;
  Result.FDesc := '查看实时运行日志';
end;

procedure TfFormRunLog.OnCreateForm(Sender: TObject);
begin
  inherited;
  EditDate.DateTime := Now();

  with TWebSystem, gMG.FLogManager do
  begin
    LoadFormConfig(Self);
    //xxxxx

    SyncLock;
    try
      SyncMainUI := False;
      SyncSimple := OnEvent;
    finally
      SyncUnlock;
    end;
  end;
end;

procedure TfFormRunLog.OnDestroyForm(Sender: TObject);
begin
  with TWebSystem, gMG.FLogManager do
  begin
    SaveFormConfig(Self);
    //xxxxx

    SyncLock;
    try
      SyncMainUI := False;
      SyncSimple := nil;
    finally
      SyncUnlock;
    end;
  end;
  inherited;
end;

procedure TfFormRunLog.OnEvent(const nEvent: string);
begin
  EditLog.Lines.Add(nEvent);
end;

procedure TfFormRunLog.CheckShowChange(Sender: TObject);
begin
  gMG.FLogManager.SyncMainUI := CheckShow.Checked;
end;

procedure TfFormRunLog.BtnLoadClick(Sender: TObject);
var nStr: string;
begin
  if CheckSimple.Checked then
       nStr :=gMG.FSimpleLogger.MakeFileName(EditDate.DateTime)
  else nStr :=gMG.FLogManager.MakeFileName(EditDate.DateTime);

  if FileExists(nStr) then
       EditLog.Lines.LoadFromFile(nStr)
  else UniMainModule.ShowMsg('日志不存在', True, EditDate.Text);
end;

initialization
  TWebSystem.AddForm(TfFormRunLog);
end.
