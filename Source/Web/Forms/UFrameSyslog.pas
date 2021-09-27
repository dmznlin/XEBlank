{*******************************************************************************
  ����: dmzn@163.com 2021-06-28
  ����: ϵͳ������־
*******************************************************************************}
unit UFrameSyslog;

interface

uses
  System.SysUtils, System.Variants, System.Classes, UFrameNormal, UFrameBase,
  Datasnap.DBClient, uniToolBar, uniPanel, uniGUIClasses, uniBasicGrid,
  uniDBGrid, Vcl.Controls, Vcl.Forms, uniGUIBaseClasses, Data.DB, kbmMemTable;

type
  TfFrameSyslog = class(TfFrameNormal)
  private
    { Private declarations }
  public
    { Public declarations }
    class function ConfigMe: TfFrameConfig; override;
  end;

implementation

{$R *.dfm}
uses
  UManagerGroup, UMgrDataDict, USysBusiness, USysDB;

procedure DictBuilder(const nList: TList);
var nEty: PDictEntity;
begin
  with TfFrameSyslog.ConfigMe do
    nEty := gDataDictManager.AddEntity(FDataDict.FEntity, FDesc, nList);
  //xxxxx

  with nEty.ByField('R_ID').FFooter do
  begin
    FFormat   := '�ϼ�:�� 0 ��';
    FKind     := fkCount;
    FPosition := fpAll;
  end; //��չ�ֵ���
end;

class function TfFrameSyslog.ConfigMe: TfFrameConfig;
begin
  Result := inherited ConfigMe;
  Result.FDesc := 'ϵͳ������־';
  Result.FDataDict.FTables := sTable_SysLog;
end;

initialization
  TWebSystem.AddFrame(TfFrameSyslog);
  gDataDictManager.AddDictBuilder(DictBuilder);
end.
