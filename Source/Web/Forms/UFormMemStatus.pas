{*******************************************************************************
  作者: dmzn@163.com 2021-05-31
  描述: 管理器运行状态
*******************************************************************************}
unit UFormMemStatus;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, UFormBase,
  uniButton, uniGUIClasses, uniMemo, uniGUIBaseClasses, uniPanel;

type
  TfFormMemStatus = class(TfFormBase)
    EditLog: TUniMemo;
    BtnRefresh: TUniButton;
    procedure BtnRefreshClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function ConfigMe: TfFormConfig; override;
    procedure OnCreateForm(Sender: TObject); override;
    procedure OnDestroyForm(Sender: TObject); override;
  end;

implementation

{$R *.dfm}

uses
  uniGUIVars, UManagerGroup, USysBusiness;

class function TfFormMemStatus.ConfigMe: TfFormConfig;
begin
  Result := inherited ConfigMe();
  Result.FVerifyAdmin := True;
  Result.FDesc := '查看内存对象状态';
end;

procedure TfFormMemStatus.OnCreateForm(Sender: TObject);
begin
  inherited;
  TWebSystem.LoadFormConfig(Self);
end;

procedure TfFormMemStatus.OnDestroyForm(Sender: TObject);
begin
  TWebSystem.SaveFormConfig(Self);
  inherited;
end;

procedure TfFormMemStatus.BtnRefreshClick(Sender: TObject);
begin
  try
    BtnRefresh.Enabled := False;
    gMG.GetManagersStatus(EditLog.Lines);
  finally
    BtnRefresh.Enabled := True;
  end;
end;

initialization
  TWebSystem.AddForm(TfFormMemStatus);
end.
