{*******************************************************************************
  ����: dmzn@163.com 2021-05-27
  ����: �༭ϵͳ�˵���
*******************************************************************************}
unit UFormEditSysMenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, UFormNormal, UFormBase,
  MainModule, uniMultiItem, uniComboBox, uniGUIClasses, uniEdit, uniPanel,
  System.Classes, Vcl.Controls, Vcl.Forms, uniGUIBaseClasses, uniButton,
  uniBitBtn, UniFSButton;

type
  TfFormEditSysMenu = class(TfFormNormal)
    UniEdit1: TUniEdit;
    UniComboBox1: TUniComboBox;
  private
    { Private declarations }
  public
    { Public declarations }
    class function DescMe: TfFormDesc; override;
    function SetData(const nData: PFormCommandParam): Boolean; override;
  end;

implementation

{$R *.dfm}

uses
  uniGUIVars, UManagerGroup, USysBusiness;

class function TfFormEditSysMenu.DescMe: TfFormDesc;
begin
  Result := inherited DescMe();
  Result.FDesc := '�༭ϵͳ�˵���';
end;

function TfFormEditSysMenu.SetData(const nData: PFormCommandParam): Boolean;
begin
  Result := inherited SetData(nData);

end;

initialization
  TWebSystem.AddForm(TfFormEditSysMenu);
end.
