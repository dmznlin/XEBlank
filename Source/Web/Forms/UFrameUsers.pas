{*******************************************************************************
  作者: dmzn@163.com 2021-08-10
  描述: 用户管理
*******************************************************************************}
unit UFrameUsers;

interface

uses
  System.SysUtils, System.Variants, System.Classes, UFrameNormal, UFrameBase,
  Datasnap.DBClient, uniToolBar, uniPanel, uniGUIClasses, uniBasicGrid,
  uniDBGrid, Vcl.Controls, Vcl.Forms, uniGUIBaseClasses, Data.DB, kbmMemTable;

type
  TfFrameUsers = class(TfFrameNormal)
  private
    { Private declarations }
  public
    { Public declarations }
    class function DescMe: TfFrameDesc; override;
  end;

implementation

{$R *.dfm}
uses
  UManagerGroup, UMgrDataDict, UDBFun, USysBusiness, USysDB;

procedure DictBuilder(const nList: TList);
var nEty: PDictEntity;
begin
  with TfFrameUsers.DescMe do
    nEty := gDataDictManager.AddEntity(FDataDict.FEntity, FDesc, nList);
  //xxxxx

  with nEty.ByField('R_ID').FFooter do
  begin
    FFormat   := '合计:共 0 条';
    FKind     := fkCount;
    FPosition := fpAll;
  end; //扩展字典项
end;

class function TfFrameUsers.DescMe: TfFrameDesc;
begin
  Result := inherited DescMe;
  Result.FDesc := '系统用户管理';
  Result.FDataDict.FTables := TDBCommand.sTable_Users;
end;

initialization
  TWebSystem.AddFrame(TfFrameUsers);
  gDataDictManager.AddDictBuilder(DictBuilder);
end.
