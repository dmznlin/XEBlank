{*******************************************************************************
  作者: dmzn@163.com 2021-08-24
  描述: 组织架构
*******************************************************************************}
unit UFrameOrganization;

interface

uses
  System.SysUtils, System.Variants, System.Classes, UFrameNormal, UFrameBase,
  Datasnap.DBClient, uniToolBar, uniPanel, uniGUIClasses, uniBasicGrid,
  uniDBGrid, Vcl.Controls, Vcl.Forms, uniGUIBaseClasses, Data.DB, kbmMemTable;

type
  TfFrameOrganization = class(TfFrameNormal)
  private
    { Private declarations }
  public
    { Public declarations }
    class function DescMe: TfFrameDesc; override;
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
  Result.FDesc := '系统操作日志';
  Result.FDataDict.FTables := sTable_SysLog;
end;

initialization
  TWebSystem.AddFrame(TfFrameOrganization);
  gDataDictManager.AddDictBuilder(DictBuilder);
end.
