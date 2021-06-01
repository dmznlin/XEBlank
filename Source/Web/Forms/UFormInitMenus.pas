{*******************************************************************************
  作者: dmzn@163.com 2021-04-28
  描述: 初始化系统菜单项
*******************************************************************************}
unit UFormInitMenus;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms,
  UFormBase, uniButton, uniGUIClasses, uniMemo, uniGUIBaseClasses, uniPanel;

type
  TfFormInitMenus = class(TfFormBase)
    EditLog: TUniMemo;
    BtnStart: TUniButton;
    procedure BtnStartClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function DescMe: TfFormDesc; override;
  end;

implementation

{$R *.dfm}

uses
  uniGUIVars, UManagerGroup, USysBusiness;

class function TfFormInitMenus.DescMe: TfFormDesc;
begin
  Result := inherited DescMe();
  Result.FVerifyAdmin := True;
  Result.FDesc := '初始化系统菜单';
end;

procedure TfFormInitMenus.BtnStartClick(Sender: TObject);
begin
  try
    BtnStart.Enabled := False;
    gMG.FMenuManager.InitMenus(EditLog.Lines);
  finally
    BtnStart.Enabled := True;
  end;
end;

initialization
  TWebSystem.AddForm(TfFormInitMenus);
end.
