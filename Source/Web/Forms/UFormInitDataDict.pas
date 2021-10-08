{*******************************************************************************
  作者: dmzn@163.com 2021-06-28
  描述: 初始化数据字典
*******************************************************************************}
unit UFormInitDataDict;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms,
  UFormBase, uniButton, uniGUIClasses, uniMemo, uniGUIBaseClasses, uniPanel,
  uniMultiItem, uniComboBox;

type
  TfFormInitDataDict = class(TfFormBase)
    EditLog: TUniMemo;
    EditLang: TUniComboBox;
    BtnStart: TUniButton;
    procedure BtnStartClick(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function ConfigMe: TfFormConfig; override;
  end;

implementation

{$R *.dfm}

uses
  uniGUIVars, MainModule, UManagerGroup, UDBManager, UMgrDataDict,
  ULibFun, USysBusiness;

const
  sTag = ' ::: ';

procedure BuildeDictWidthTable(const nList: TList);
var nIdx,nID,nIF: Integer;
    nDBList: TList;
    nDBTable: PDBTable;
    nEntity: PDictEntity;
    nTables,nFields: TStrings;
begin
  nDBList := nil;
  nTables := nil;
  nFields := nil;
  try
    nTables := gMG.FObjectPool.Lock(TStrings) as TStrings;
    nFields := gMG.FObjectPool.Lock(TStrings) as TStrings;
    //get list
    
    nDBList := gMG.FObjectPool.Lock(TList) as TList;    
    gDBManager.GetTables(nDBList);
    //get tables
    
    for nIdx := Low(TWebSystem.Frames) to High(TWebSystem.Frames) do
    with TWebSystem.Frames[nIdx].ConfigMe do
    begin
      if (FDataDict.FEntity = '') or (FDataDict.FTables = '') then Continue;
      //no entity or tables
      nEntity := gDataDictManager.AddEntity(FDataDict.FEntity, FDesc, nList);
      //new entity
    
      TStringHelper.Split(FDataDict.FTables, nTables, ',');
      if FDataDict.FFields = '' then
           nFields.Clear
      else TStringHelper.Split(FDataDict.FFields, nFields, ',');

      for nID := nDBList.Count-1 downto 0 do
      begin
        nDBTable := nDBList[nID];
        if nTables.IndexOf(nDBTable.FName) < 0 then Continue;
        //not match table
        
        for nIF := Low(nDBtable.FFields) to High(nDBtable.FFields) do
        with nDBtable.FFields[nIF] do
        begin
          if nFields.Count > 0 then
          begin
            if (FDataDict.FExclude and (nFields.IndexOf(FName) < 0)) or
               (not FDataDict.FExclude and (nFields.IndexOf(FName) >= 0)) then
              nEntity.AddDict(FName, FMemo);
            //new item            
          end else
          begin
            nEntity.AddDict(FName, FMemo);
            //new item
          end;
        end;
      end;
    end;
  finally
    gMG.FObjectPool.Release(nTables);
    gMG.FObjectPool.Release(nFields);
    //relase list
    gDBManager.ClearTables(nDBList, False);
    gMG.FObjectPool.Release(nDBList);
    //release tables
  end;    
end;

class function TfFormInitDataDict.ConfigMe: TfFormConfig;
begin
  Result := inherited ConfigMe();
  Result.FVerifyAdmin := True;
  Result.FDesc := '初始化数据字典';
end;

procedure TfFormInitDataDict.UniFormCreate(Sender: TObject);
var nIdx: Integer;
begin
  with EditLang, gMG.FMenuManager do
  try
    Items.BeginUpdate;
    Items.Clear;

    for nIdx := Low(MultiLanguage) to High(MultiLanguage) do
     with MultiLanguage[nIdx] do
      Items.Add(FID + sTag + FName);
    //xxxxx

    if Items.Count > 0 then
      EditLang.ItemIndex := 0;
    //xxxxx              
  finally
    Items.EndUpdate;
  end;  
end;

procedure TfFormInitDataDict.BtnStartClick(Sender: TObject);
var nStr: string;
begin
  if EditLang.ItemIndex < 0 then
  begin
    UniMainModule.ShowMsg('请选择字典语言');
    Exit;
  end;
  
  BtnStart.Enabled := False;
  try
    nStr := Copy(EditLang.Text, 1, Pos(sTag, EditLang.Text) - 1);
    gDataDictManager.InitDictData(nStr, EditLog.Lines);
  finally
    BtnStart.Enabled := True;
  end;
end;

initialization
  TWebSystem.AddForm(TfFormInitDataDict);
  gDataDictManager.AddDictBuilder(BuildeDictWidthTable, 0);
end.
