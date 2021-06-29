{*******************************************************************************
  ����: dmzn@163.com 2021-06-03
  ����: �ṩ���ݱ��͹�����
*******************************************************************************}
unit UFrameNormal;

interface

uses
  SysUtils, Classes, Graphics, Controls, UFrameBase, MainModule, uniGUITypes,
  uniGUIAbstractClasses, Data.DB, System.IniFiles, Datasnap.DBClient,
  UMgrDataDict, uniToolBar, uniPanel, uniGUIClasses, uniBasicGrid, uniDBGrid,
  Vcl.Forms, uniGUIBaseClasses;

type
  TfFrameNormal = class(TfFrameBase)
    DataSource1: TDataSource;
    ClientDS: TClientDataSet;
    DBGridMain: TUniDBGrid;
    PanelQuick: TUniSimplePanel;
    UniToolBar1: TUniToolBar;
    BtnAdd: TUniToolButton;
    BtnEdit: TUniToolButton;
    BtnDel: TUniToolButton;
    BtnS1: TUniToolButton;
    BtnRefresh: TUniToolButton;
    BtnS2: TUniToolButton;
    BtnPrint: TUniToolButton;
    BtnPreview: TUniToolButton;
    BtnExport: TUniToolButton;
    BtnS3: TUniToolButton;
    BtnExit: TUniToolButton;
  private
    { Private declarations }
  protected
    { Protected declarations }
    FDataDict: TDictEntity;
    {*�����ֵ�*}
    procedure OnCreateFrame(const nIni: TIniFile); override;
    procedure OnDestroyFrame(const nIni: TIniFile); override;
    {*�����ͷ�*}
    function FilterColumnField: string; virtual;
    procedure OnLoadGridConfig(const nIni: TIniFile); virtual;
    procedure OnSaveGridConfig(const nIni: TIniFile); virtual;
    {*�������*}
  public
    { Public declarations }
    class function DescMe: TfFrameDesc; override;
    {*��������*}
  end;

implementation

{$R *.dfm}
uses
  UManagerGroup, USysBusiness;

class function TfFrameNormal.DescMe: TfFrameDesc;
begin
  Result := inherited DescMe;
  Result.FUserConfig := True;
end;

procedure TfFrameNormal.OnCreateFrame(const nIni: TIniFile);
begin
  with DescMe.FDataDict,gDataDictManager do
  begin
    if FEntity = '' then
         InitDict(@FDataDict, False)
    else GetEntity(FEntity, UniMainModule.FUser.FLangID, @FDataDict);
  end;

  OnLoadGridConfig(nIni);
  //�����û�����
end;

procedure TfFrameNormal.OnDestroyFrame(const nIni: TIniFile);
begin
  OnSaveGridConfig(nIni);
  //�����û�����
end;

//Desc: ���˲���ʾ�ֶ�
function TfFrameNormal.FilterColumnField: string;
begin
  Result := '';
end;

//Desc: �������
procedure TfFrameNormal.OnLoadGridConfig(const nIni: TIniFile);
begin
  if FDataDict.FEntity = '' then Exit;
  //û���ֵ�����

  TGridHelper.BindEntity(ClientDS, @FDataDict);
  TGridHelper.BindEntity(DBGridMain, @FDataDict);
  //�������ֵ�

  TGridHelper.BuildDBGridColumn(@FDataDict, DBGridMain, FilterColumnField());
  //������ͷ
  TGridHelper.UserDefineGrid(ClassName, DBGridMain, True, nIni);
  //�����Զ����ͷ
end;

//Desc: ����������
procedure TfFrameNormal.OnSaveGridConfig(const nIni: TIniFile);
begin
  TGridHelper.UnbindEntity(ClientDS);
  TGridHelper.UnbindEntity(DBGridMain);
  //����ֵ�
  TGridHelper.UserDefineGrid(ClassName, DBGridMain, False, nIni);
  //�����Զ����ͷ
end;

end.
