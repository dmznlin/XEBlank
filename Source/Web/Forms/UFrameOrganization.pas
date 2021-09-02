{*******************************************************************************
  作者: dmzn@163.com 2021-08-24
  描述: 组织架构
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
    FFormat   := '合计:共 0 条';
    FKind     := fkCount;
    FPosition := fpAll;
  end; //扩展字典项
end;

class function TfFrameOrganization.DescMe: TfFrameDesc;
begin
  Result := inherited DescMe;
  Result.FDesc := '单位组织架构';
  Result.FDataDict.FTables := sTable_Organization;

  Result.FDataDict.
    AddMemo('所有查询字段需添加"t."前缀').
    AddMemo('字段 O_PName 内部名称为 a.O_Name');
  //添加备注
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
