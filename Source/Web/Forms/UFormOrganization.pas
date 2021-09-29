{*******************************************************************************
  作者: dmzn@163.com 2021-09-29
  描述: 组织结构信息
*******************************************************************************}
unit UFormOrganization;

interface

uses
  System.SysUtils, UFormNormal, UFormBase, System.IniFiles, ULibFun, Data.DB,
  uniGUITypes, uniCheckBox, uniGUIClasses, uniDateTimePicker, uniPanel,
  System.Classes, Vcl.Controls, Vcl.Forms, uniGUIBaseClasses, uniButton,
  uniBitBtn, UniFSButton, uniPageControl, uniEdit, uniMultiItem, uniComboBox;

type
  TfFormOrganization = class(TfFormNormal)
    wPage: TUniPageControl;
    Sheet1: TUniTabSheet;
    Sheet2: TUniTabSheet;
    Sheet3: TUniTabSheet;
    Sheet4: TUniTabSheet;
    EditType: TUniComboBox;
    EditName: TUniEdit;
    EditValid: TUniDateTimePicker;
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function DescMe: TfFormDesc; override;
    procedure OnCreateForm(Sender: TObject); override;
    function SetData(const nData: PCommandParam): Boolean; override;
  end;

implementation

{$R *.dfm}

uses
  UManagerGroup, MainModule, USysBusiness, USysConst;

const
  sTypes: array[TApplicationHelper.TOrganizationStructure] of string =
    ('集团', '区域', '工厂');
  //type define

class function TfFormOrganization.DescMe: TfFormDesc;
begin
  Result := inherited DescMe();
  Result.FDesc := '组织结构信息';
end;

procedure TfFormOrganization.OnCreateForm(Sender: TObject);
var nIdx: TApplicationHelper.TOrganizationStructure;
begin
  with EditType do
  try
    Items.BeginUpdate;
    Items.Clear;

    for nIdx := Low(sTypes) to High(sTypes) do
      Items.Add(sTypes[nIdx]);
    //xxxxx
  finally
    Items.EndUpdate;
  end;

  EditValid.DateTime := TDateTimeHelper.Str2Date('2099-12-31');
  //max valid
end;

function TfFormOrganization.SetData(const nData: PCommandParam): Boolean;
var nType: TFieldType;
    nBegin,nEnd: TDateTime;
begin
  Result := inherited SetData(nData);
  if nData.Command <> cCmd_EditData then Exit;

end;

procedure TfFormOrganization.BtnOKClick(Sender: TObject);
begin

  ModalResult := mrOk;
end;

initialization
  TWebSystem.AddForm(TfFormOrganization);
end.
