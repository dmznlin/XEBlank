{*******************************************************************************
  ����: dmzn@163.com 2021-09-29
  ����: ��֯�ṹ��Ϣ
*******************************************************************************}
unit UFormOrganization;

interface

uses
  System.SysUtils, UFormNormal, UFormBase, System.IniFiles, ULibFun, Data.DB,
  MainModule, uniGUITypes, Vcl.Menus, uniMainMenu, uniBasicGrid, uniStringGrid,
  uniMemo, uniDateTimePicker, uniEdit, uniGUIClasses, uniMultiItem, uniComboBox,
  uniPanel, uniPageControl, System.Classes, Vcl.Controls, Vcl.Forms,
  uniGUIBaseClasses, uniButton, uniBitBtn, UniFSButton;

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
    EditParent: TUniEdit;
    EditPName: TUniEdit;
    EditCode: TUniEdit;
    EditPAddr: TUniMemo;
    GridPost: TUniStringGrid;
    PMenu1: TUniPopupMenu;
    N1: TUniMenuItem;
    N2: TUniMenuItem;
    N3: TUniMenuItem;
    N4: TUniMenuItem;
    EditMName: TUniEdit;
    EditMPhone: TUniEdit;
    EditMMail: TUniMemo;
    GridMail: TUniStringGrid;
    procedure BtnOKClick(Sender: TObject);
    procedure GridPostMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N4Click(Sender: TObject);
  private
    { Private declarations }
    procedure AddTypes(nTypes: TApplicationHelper.TOrganizationStructures;
      const nParent: TApplicationHelper.TOrganizationStructure);
    //�����֯����
  public
    { Public declarations }
    class function ConfigMe: TfFormConfig; override;
    procedure DoFormConfig(nIni: TIniFile; const nLoad: Boolean); override;
    function SetData(const nData: PCommandParam): Boolean; override;
  end;

implementation

{$R *.dfm}

uses
  UManagerGroup, USysBusiness, UGridHelper, UGlobalConst, USysConst;

class function TfFormOrganization.ConfigMe: TfFormConfig;
begin
  Result := inherited ConfigMe();
  Result.FUserConfig := True;
  Result.FDesc := '��֯�ṹ��Ϣ';
end;

procedure TfFormOrganization.DoFormConfig(nIni: TIniFile; const nLoad: Boolean);
begin
  if nLoad then
  begin
    BtnOK.Enabled := False;
    wPage.ActivePageIndex := 0;
    EditValid.DateTime := TDateTimeHelper.Str2Date('2099-12-31');

    with EditPAddr.JSInterface do
    begin
      JSConfig('maxLength', '320');
      JSConfig('enforceMaxLength', 'true');
    end;

    with EditMMail.JSInterface do
    begin
      JSConfig('maxLength', '320');
      JSConfig('enforceMaxLength', 'true');
    end;
  end;

  TGridHelper.UserDefineStringGrid(Name, GridPost, nLoad, nIni);
  TGridHelper.UserDefineStringGrid(Name, GridMail, nLoad, nIni);
end;

function TfFormOrganization.SetData(const nData: PCommandParam): Boolean;
var nPNode: POrganizationItem;
begin
  Result := inherited SetData(nData);
  if nData.Command = cCmd_AddData then
  begin
    Caption := '���';
    if nData.IsValid(ptPtr) then
    begin
      nPNode := nData.Ptr[0];
      if Assigned(nPNode) then
      begin
        AddTypes([], nPNode.FType);
        EditParent.Text := sOrganizationNames[nPNode.FType] + ' ' + nPNode.FName;
      end else
      begin
        AddTypes([osGroup], osGroup);
        EditParent.Text := sOrganizationNames[osGroup] + '�б�';
      end;
    end;
  end;
end;

//Date: 2021-10-08
//Parm: ���������;������
//Desc: ���б������֯����
procedure TfFormOrganization.AddTypes(
  nTypes: TApplicationHelper.TOrganizationStructures;
  const nParent: TApplicationHelper.TOrganizationStructure);
begin
  with EditType do
  try
    Items.BeginUpdate;
    Items.Clear;

    if nTypes = [] then
    begin
      case nParent of
       osGroup   : nTypes := [osArea];      //�����¼�: ����
       osArea    : nTypes := [osFactory];   //�����¼�: ����
       osFactory : nTypes := [];            //�����¼�: ��
      end;
    end;

    if osGroup in nTypes then Items.Add(sOrganizationNames[osGroup]);
    if osArea in nTypes then Items.Add(sOrganizationNames[osArea]);
    if osFactory in nTypes then Items.Add(sOrganizationNames[osFactory]);

    if Items.Count > 0 then
      ItemIndex := 0; //first default
    BtnOK.Enabled := Items.Count > 0;
  finally
    Items.EndUpdate;
  end;
end;

procedure TfFormOrganization.GridPostMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    PMenu1.Popup(X, Y, Sender);
  //xxxxx
end;

//Desc: ��������
procedure TfFormOrganization.N4Click(Sender: TObject);
var nIdx: Integer;
begin
  with wPage.ActivePage do
  begin
    for nIdx := ControlCount - 1 downto 0 do
    begin
      if Controls[nIdx] is TUniEdit then
        (Controls[nIdx] as TUniEdit).Text := '';
      //xxxxx

      if Controls[nIdx] is TUniMemo then
        (Controls[nIdx] as TUniMemo).Clear;
      //xxxxx
    end;
  end;
end;

procedure TfFormOrganization.BtnOKClick(Sender: TObject);
begin

  ModalResult := mrOk;
end;

initialization
  TWebSystem.AddForm(TfFormOrganization);
end.
