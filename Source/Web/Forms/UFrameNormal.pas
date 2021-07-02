{*******************************************************************************
  ����: dmzn@163.com 2021-06-03
  ����: �ṩ���ݱ��͹�����
*******************************************************************************}
unit UFrameNormal;

interface

uses
  SysUtils, Classes, Graphics, Controls, UFrameBase, MainModule, uniGUITypes,
  uniGUIAbstractClasses, Data.DB, System.IniFiles, UMgrDataDict, kbmMemTable,
  uniToolBar, uniPanel, uniGUIClasses, uniBasicGrid, uniDBGrid, Vcl.Forms,
  uniGUIBaseClasses, Vcl.Menus, uniMainMenu;

type
  TfFrameNormal = class(TfFrameBase)
    DataSource1: TDataSource;
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
    MTable1: TkbmMemTable;
    HMenu1: TUniPopupMenu;
    MenuGridAdjust: TUniMenuItem;
    MenuEditDict: TUniMenuItem;
    procedure DBGridMainAjaxEvent(Sender: TComponent; EventName: string;
      Params: TUniStrings);
    procedure MenuGridAdjustClick(Sender: TObject);
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
    procedure OnInitFormData(const nWhere: string; const nQuery: TDataset;
    var nHasDone: Boolean); virtual;
    procedure InitFormData(const nWhere: string = '';
      const nQuery: TDataset = nil); virtual;
    function InitFormDataSQL(const nWhere: string): string; virtual;
    procedure AfterInitFormData; virtual;
    {*��������*}
  public
    { Public declarations }
    class function DescMe: TfFrameDesc; override;
    {*��������*}
  end;

implementation

{$R *.dfm}
uses
  UManagerGroup, ULibFun, UDBManager, USysBusiness;

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
  InitFormData;
  //��ʼ������
end;

procedure TfFrameNormal.OnDestroyFrame(const nIni: TIniFile);
begin
  OnSaveGridConfig(nIni);
  //�����û�����
  if MTable1.Active then
    MTable1.Close;
  //������ݼ�
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

  TGridHelper.BindEntity(MTable1, @FDataDict);
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
  TGridHelper.UnbindEntity(MTable1);
  TGridHelper.UnbindEntity(DBGridMain);
  //����ֵ�
  TGridHelper.UserDefineGrid(ClassName, DBGridMain, False, nIni);
  //�����Զ����ͷ
end;

//Desc: ������������SQL���
function TfFrameNormal.InitFormDataSQL(const nWhere: string): string;
begin
  Result := 'Select * From ' + DescMe.FDataDict.FTables;
end;

//Date: 2021-06-30
//Parm: ��ѯ����;��ѯ����;�Ƿ����
//Desc: ִ��Ĭ�ϵ����ݲ�ѯ
procedure TfFrameNormal.OnInitFormData(const nWhere: string;
  const nQuery: TDataset; var nHasDone: Boolean);
begin

end;

//Desc: �����������
procedure TfFrameNormal.InitFormData(const nWhere: string;
  const nQuery: TDataset);
var nStr: string;
    nC: TDataset;
    nBool: Boolean;
begin
  nC := nil;
  try
    if Assigned(nQuery) then
         nC := nQuery
    else nC := gDBManager.LockDBQuery(DescMe.FDBConn);

    nBool := False;
    OnInitFormData(nWhere, nC, nBool);
    if nBool then Exit;

    nStr := InitFormDataSQL(nWhere);
    if nStr = '' then Exit;

    gDBManager.DBQuery(nStr, nC);
    //db query
    MTable1.LoadFromDataSet(nC, [mtcpoStructure]);
    //ת�����ݼ�

    TGridHelper.BuidDataSetSortIndex(MTable1);
    //��������
    TGridHelper.SetGridColumnFormat(@FDataDict, MTable1);
    //�и�ʽ��
  finally
    if not Assigned(nQuery) then
      gDBManager.ReleaseDBQuery(nC);
    AfterInitFormData;
  end
end;

//Desc: ���������
procedure TfFrameNormal.AfterInitFormData;
begin
  //null
end;

//------------------------------------------------------------------------------
//Desc: �������¼�
procedure TfFrameNormal.DBGridMainAjaxEvent(Sender: TComponent;
  EventName: string; Params: TUniStrings);
var nSA: TStringHelper.TStringArray;
begin
  if EventName = TGridHelper.sEvent_DBGridHeaderPopmenu then
  begin
    if TStringHelper.SplitArray(Params.Values['xy'], nSA, ',', tpTrim, 2) then
    begin
      MenuGridAdjust.Checked := UniMainModule.FGridColumnAdjust;
      HMenu1.Popup(StrToInt(nSA[0]), StrToInt(nSA[1]), UniMainModule.MainForm);
    end;
  end;
end;

//Desc: �����������Ⱥ�˳��
procedure TfFrameNormal.MenuGridAdjustClick(Sender: TObject);
begin
  with DBGridMain, UniMainModule do
  begin
    FGridColumnAdjust := not FGridColumnAdjust;
    if FGridColumnAdjust then
      ShowMsg('����ÿһ�п��Ե���λ�úͿ��', False, '���´���Ч');
    //xxxxx
  end;
end;

end.
