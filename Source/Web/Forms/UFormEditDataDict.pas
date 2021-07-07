{*******************************************************************************
  ×÷Õß: dmzn@163.com 2021-07-07
  ÃèÊö: ±à¼­Êý¾Ý×Öµä
*******************************************************************************}
unit UFormEditDataDict;

interface

uses
  System.SysUtils, System.Classes, UFormBase, ULibFun, uniGUIBaseClasses,
  uniGUIClasses, uniPanel, Vcl.Controls, Vcl.Forms, uniEdit, uniMultiItem,
  uniListBox;

type
  TfFormEditDataDict = class(TfFormBase)
    PanelL: TUniPanel;
    PanelW: TUniPanel;
    PanelT: TUniSimplePanel;
    UniEdit1: TUniEdit;
    UniListBox1: TUniListBox;
  private
    { Private declarations }
  public
    { Public declarations }
    class function DescMe: TfFormDesc; override;
    function SetData(const nData: PCommandParam): Boolean; override;
  end;

implementation

{$R *.dfm}
uses
  UMgrDataDict, USysBusiness;

class function TfFormEditDataDict.DescMe: TfFormDesc;
begin
  Result := inherited DescMe();
  Result.FVerifyAdmin := True;
  Result.FDesc := '±à¼­±í¸ñ×Öµä';
end;

function TfFormEditDataDict.SetData(const nData: PCommandParam): Boolean;
var nStr: string;
    nIdx: Integer;
begin
  Result := inherited SetData(nData);
  if not nData.IsValid then Exit;


end;

initialization
  TWebSystem.AddForm(TfFormEditDataDict);
end.
