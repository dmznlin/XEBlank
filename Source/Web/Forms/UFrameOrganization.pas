{*******************************************************************************
  ����: dmzn@163.com 2021-08-24
  ����: ��֯�ܹ�
*******************************************************************************}
unit UFrameOrganization;

interface

uses
  System.SysUtils, System.Variants, System.Classes, System.IniFiles,
  UFrameNormal, UFrameBase, uniGUITypes, uniSplitter, uniTreeView, Data.DB,
  kbmMemTable, uniToolBar, uniPanel, uniGUIClasses, uniBasicGrid, uniDBGrid,
  Vcl.Controls, Vcl.Forms, uniGUIBaseClasses;

type
  TfFrameOrganization = class(TfFrameNormal)
    TreeUnits: TUniTreeView;
    Splitter1: TUniSplitter;
  private
    { Private declarations }
  public
    { Public declarations }
    class function DescMe: TfFrameDesc; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    procedure DoFrameConfig(nIni: TIniFile; const nLoad: Boolean); override;
  end;

implementation

{$R *.dfm}
uses
  UManagerGroup, UMgrDataDict, USysBusiness, USysDB;

procedure DictBuilder(const nList: TList);
var nEty: PDictEntity;
begin
  with TfFrameOrganization.DescMe do
    nEty := gDataDictManager.AddEntity(FDataDict.FEntity, FDesc, nList);
  //xxxxx

  with nEty.ByField('R_ID').FFooter do
  begin
    FFormat   := '�ϼ�:�� 0 ��';
    FKind     := fkCount;
    FPosition := fpAll;
  end; //��չ�ֵ���
end;

class function TfFrameOrganization.DescMe: TfFrameDesc;
begin
  Result := inherited DescMe;
  Result.FDesc := '��λ��֯�ܹ�';
  Result.FDataDict.FTables := sTable_Organization;

  Result.FDataDict.
    AddMemo('���в�ѯ�ֶ������"t."ǰ׺').
    AddMemo('�ֶ� O_PName �ڲ�����Ϊ a.O_Name');
  //��ӱ�ע
end;

procedure TfFrameOrganization.DoFrameConfig(nIni: TIniFile;
  const nLoad: Boolean);
var nInt: Integer;
begin
  inherited DoFrameConfig(nIni, nLoad);
  //do parent

  if nLoad then
  begin
    TreeUnits.BorderStyle := ubsNone;
    with Splitter1.JSInterface do
    begin
      JSConfig('border', [true]);
      JSConfig('bodyBorder', [True]);
      //enable border

      JSCall('addCls', ['x-panel-border-leftright']);
      JSCall('setStyle', ['border-style', 'none solid none dashed']);
      //border style
    end;

    nInt := nIni.ReadInteger(Name, 'TreeWidth', 0);
    if nInt > 135 then
      TreeUnits.Width := nInt;
    //xxxxx
  end else
  begin
    nIni.WriteInteger(Name, 'TreeWidth', TreeUnits.Width);
  end;
end;

function TfFrameOrganization.InitFormDataSQL(const nWhere: string): string;
begin
  Result := 'Select t.*,a.O_Name as O_PName From %s t ' +
            'Left Join %s a On t.O_Parent=a.O_ID';
  Result := Format(Result, [sTable_Organization, sTable_Organization]);

  if nWhere <> '' then
    Result := Result + ' Where ' + nWhere;
  //xxxxx
end;

initialization
  TWebSystem.AddFrame(TfFrameOrganization);
  gDataDictManager.AddDictBuilder(DictBuilder);
end.
