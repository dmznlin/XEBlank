{*******************************************************************************
  ����: dmzn@163.com 2021-08-10
  ����: �û�����
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
    FFormat   := '�ϼ�:�� 0 ��';
    FKind     := fkCount;
    FPosition := fpAll;
  end; //��չ�ֵ���
end;

class function TfFrameUsers.DescMe: TfFrameDesc;
begin
  Result := inherited DescMe;
  Result.FDesc := 'ϵͳ�û�����';
  Result.FDataDict.FTables := TDBCommand.sTable_Users;
end;

initialization
  TWebSystem.AddFrame(TfFrameUsers);
  gDataDictManager.AddDictBuilder(DictBuilder);
end.
