{*******************************************************************************
  ����: dmzn@163.com 2021-06-03
  ����: �ṩ���ݱ��͹�����
*******************************************************************************}
unit UFrameNormal;

interface

uses
  SysUtils, Classes, Graphics, Controls, UFrameBase, MainModule, uniGUITypes,
  uniGUIAbstractClasses, Data.DB, System.IniFiles, UMgrDataDict, kbmMemTable,
  uniPageControl, UGridHelper, uniToolBar, uniPanel, uniGUIClasses,
  uniBasicGrid, uniDBGrid, Vcl.Forms, uniGUIBaseClasses;

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
    procedure BtnExitClick(Sender: TObject);
    procedure BtnRefreshClick(Sender: TObject);
    procedure BtnExportClick(Sender: TObject);
  private
    { Private declarations }
  protected
    { Protected declarations }
    FWhere: string;
    {*��������*}
    FDataDict: TDictEntity;
    {*�����ֵ�*}
    FActiveColumn: TUniBaseDBGridColumn;
    {*��ǰ���*}
    procedure OnShowFrame(Sender: TObject); override;
    procedure DoFrameConfig(nIni: TIniFile; const nLoad: Boolean); override;
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
    procedure OnFilterData(const nData: PBindData; const nFilterString: string;
      const nClearFilter: Boolean); virtual;
    {*���ݲ�ѯ*}
  public
    { Public declarations }
    class function DescMe: TfFrameDesc; override;
    {*��������*}
  end;

implementation

{$R *.dfm}
uses
  UManagerGroup, ULibFun, UDBManager, USysBusiness, USysConst;

class function TfFrameNormal.DescMe: TfFrameDesc;
begin
  Result := inherited DescMe;
  Result.FUserConfig := True;
end;

procedure TfFrameNormal.DoFrameConfig(nIni: TIniFile; const nLoad: Boolean);
begin
  if nLoad then
  begin
    FWhere := '';
    FActiveColumn := nil;
    //init

    with DescMe.FDataDict,gDataDictManager do
    begin
      if FEntity = '' then
           FDataDict.Init(False)
      else GetEntity(FEntity, UniMainModule.FUser.FLangID, @FDataDict);
    end;

    OnLoadGridConfig(nIni);
    //�����û�����
  end else
  begin
    OnSaveGridConfig(nIni);
    //�����û�����
    if MTable1.Active then
      MTable1.Close;
    //������ݼ�
  end;
end;

//Desc: �ӳټ�������
procedure TfFrameNormal.OnShowFrame(Sender: TObject);
var nBind: PBindData;
begin
  nBind := TGridHelper.GetBindData(DBGridMain);
  if Assigned(nBind) then
  begin
    nBind.SetAllFilterDefaultText();
    FWhere := nBind.FilterString();
  end;

  InitFormData(FWhere);
  //��ʼ������
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
  FDataDict.FMemo := DescMe.FDataDict.MemoToHTML();
  //�ֵ�������Ϣ,���ڸ����༭�ֵ�����

  with TGridHelper.BindData(DBGridMain)^ do
  begin
    FParentControl := Self;
    FFilterEvent := OnFilterData;
    FEntity := @FDataDict;
    FMemTable := MTable1;
    BuildColumnMenu(UniMainModule.SmallImages);
  end; //�󶨱�����ݺͲ˵�

  TGridHelper.BindData(MTable1).FEntity := @FDataDict;
  //������
  TGridHelper.BuildDBGridColumn(@FDataDict, DBGridMain, FilterColumnField());
  //������ͷ
  TGridHelper.UserDefineGrid(ClassName, DBGridMain, True, nIni);
  //�����Զ����ͷ
end;

//Desc: ����������
procedure TfFrameNormal.OnSaveGridConfig(const nIni: TIniFile);
begin
  TGridHelper.UserDefineGrid(ClassName, DBGridMain, False, nIni);
  //�����Զ����ͷ
  TGridHelper.UnbindData(MTable1);
  TGridHelper.UnbindData(DBGridMain);
  //����ֵ�
end;

//Desc: ������������SQL���
function TfFrameNormal.InitFormDataSQL(const nWhere: string): string;
begin
  Result := 'Select * From ' + DescMe.FDataDict.FTables;
  if nWhere <> '' then
    Result := Result + ' Where ' + nWhere;
  //xxxxx
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

    TGridHelper.SetBindFilterWhere(DBGridMain, nWhere);
    //��¼��ѯ����

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

//Date: 2021-08-02
//Parm: ��������;��ѯ����;�Ƿ����
//Desc: ִ�б��Ĳ�ѯ����
procedure TfFrameNormal.OnFilterData(const nData: PBindData;
  const nFilterString: string; const nClearFilter: Boolean);
begin
  if nFilterString = '' then
       FWhere := nData.FilterString
  else FWhere := nFilterString;
  InitFormData(FWhere);
end;

//------------------------------------------------------------------------------
//Desc: �ر�
procedure TfFrameNormal.BtnExitClick(Sender: TObject);
var nSheet: TUniTabSheet;
begin
  nSheet := Parent as TUniTabSheet;
  nSheet.Close;
end;

//Desc: ˢ��
procedure TfFrameNormal.BtnRefreshClick(Sender: TObject);
var nBind: PBindData;
begin
  nBind := TGridHelper.GetBindData(DBGridMain);
  if Assigned(nBind) then
       FWhere := nBind.FilterString
  else FWhere := '';
  InitFormData(FWhere);
end;

//Desc: ����
procedure TfFrameNormal.BtnExportClick(Sender: TObject);
var nStr,nFile: string;
begin
  if (not MTable1.Active) or (MTable1.RecordCount < 1) then
  begin
    UniMainModule.ShowMsg('û����Ҫ����������', True);
    Exit;
  end;

  nStr := '�Ƿ�Ҫ������ǰ����ڵ�����?';
  UniMainModule.QueryDlg(nStr,
    procedure(const nType: TButtonClickType)
    begin
      if nType <> ctYes then Exit;
      nFile := TWebSystem.UserFile(ufExportXLS, False);

      if FileExists(nFile) then
        DeleteFile(nFile);
      //xxxxx

      nStr := TGridHelper.GridExportExcel(DBGridMain, nFile);
      if nStr = '' then
      begin
        UniSession.SendFile(nFile);
        //send file
      end else UniMainModule.ShowMsg(nStr, True);
    end);
  //xxxxx
end;

end.
