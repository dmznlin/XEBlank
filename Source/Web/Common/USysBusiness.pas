{*******************************************************************************
  作者: dmzn@163.com 2020-06-23
  描述: 业务定义单元
*******************************************************************************}
unit USysBusiness;

{$I Link.Inc}
interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections, System.SyncObjs,
  System.IniFiles, System.Variants, Data.DB, kbmMemTable,
  Vcl.Controls, Vcl.Forms, Vcl.Grids, Vcl.DBGrids, Vcl.Graphics,
  //----------------------------------------------------------------------------
  uniGUIAbstractClasses, uniGUITypes, uniGUIClasses, uniGUIBaseClasses,
  uniGUISessionManager, uniGUIApplication, uniTreeView, uniGUIForm, uniImage,
  uniDBGrid, uniStringGrid, uniComboBox, MainModule, UFormBase, UFrameBase,
  uniPageControl,
  //----------------------------------------------------------------------------
  UBaseObject, UManagerGroup, UMgrDataDict, UMenuManager, ULibFun,
  USysDB, USysConst, USysRemote;

type
  ///<summary>System Function: 系统级别的通用函数</summary>
  TWebSystem = class
  private
    class var
      FSyncLock: TCriticalSection;
      {*全局同步锁*}
  public
    type
      TUserFileType = (ufOPTCode);
      {*用户文件*}
    class var
      Forms: array of TfFormClass;
      {*窗体列表*}
      Frames: array of TfFrameClass;
      {*框架列表*}
  public
    class procedure Init(const nForce: Boolean = False); static;
    {*初始化*}
    class procedure Release; static;
    {*释放资源*}
    class procedure SyncLock; static;
    class procedure SyncUnlock; static;
    {*全局同步*}
    class procedure InitSystemEnvironment; static;
    {*初始化系统运行环境的变量*}
    class procedure LoadSysParameter(nIni: TIniFile = nil); static;
    {*载入系统配置参数*}
    class function SwtichPathDelim(const nPath: string;
      const nFrom: string = '\'; const nTo: string = '/'): string; static;
    {*切换路径分隔符*}
    class procedure AddForm(const nForm: TfFormClass); static;
    class procedure AddFrame(const nFrame: TfFrameClass); static;
    {*注册窗体类*}
    class function GetForm(const nClass: string;
      const nException: Boolean = False): TUniForm; static;
    {*获取窗体*}
    class procedure ShowModalForm(const nClass: string;
      const nParams: PFormCommandParam = nil;
      const nResult: TFormModalResult = nil); static;
    {*显示模式窗体*}
    class procedure ShowFrame(const nMenu: PMenuItem;
      const nParent: TUniPageControl; const nOnClose: TTabCloseEvent); static;
    {*显示Frame框架*}
    class procedure LoadFormConfig(const nForm: TfFormBase;
      const nIniF: TIniFile = nil); static;
    class procedure SaveFormConfig(const nForm: TfFormBase;
      const nIniF: TIniFile = nil); static;
    class function UserFile(const nType: TUserFileType;
      const nRelative: Boolean = True;
      const nForceRefresh: Boolean = False): string; static;
    class function UserConfigFile: TIniFile; static;
    {*用户私有文件*}
    class procedure SetImageData(const nParent: TUniContainer;
      const nImage: TUniImage; const nData: PImageData); static;
    {*设置图片数据*}
  end;

  TGridHelper = class
  private
    class var
      FSyncLock: TCriticalSection;
      {*全局同步锁*}
      FGridHelper: TGridHelper;
      {*对象实例*}
      FDictEntity: TDictionary<TObject, PDictEntity>;
      {*数据集和字典*}
  public
    const
      sEvent_DBGridHeaderPopmenu = 'DBGridHeaderPopmenu';
      sEvent_StrGridColumnResize = 'StringGridColResize';
      {*常量定义*}
  public
    class procedure Init(const nForce: Boolean = False); static;
    {*初始化*}
    class procedure Release; static;
    {*释放资源*}
    class function GetHelper: TGridHelper;
    {*获取实例*}
    class procedure SyncLock; static;
    class procedure SyncUnlock; static;
    {*全局同步*}
    class procedure BindEntity(const nObj: TObject; const nDE: PDictEntity); static;
    class procedure UnbindEntity(const nObj: TObject); static;
    {*绑定字典*}
    class procedure BuildDBGridColumn(const nEntity: PDictEntity;
      const nGrid: TUniDBGrid; const nFilter: string = ''); static;
    {*构建表格*}
    class procedure BuidDataSetSortIndex(const nMT: TkbmMemTable); static;
    {*排序索引*}
    class procedure SetGridColumnFormat(const nEntity: PDictEntity;
      const nMT: TkbmMemTable); static;
    {*格式化显示*}
    class procedure DoStringGridColumnResize(const nGrid: TObject;
      const nParam: TUniStrings); static;
    {*调整字段*}
    class procedure UserDefineGrid(const nForm: string; const nGrid: TUniDBGrid;
      const nLoad: Boolean; nIni: TIniFile = nil); static;
    class procedure UserDefineStringGrid(const nForm: string;
      const nGrid: TUniStringGrid;
      const nLoad: Boolean; nIni: TIniFile = nil); static;
    {*自定义表格*}
    class function GridExportExcel(const nGrid: TUniDBGrid;
      const nFile: string): string; static;
    {*导出数据*}
    procedure DoGridEvent(Sender: TComponent; nEventName: string;
      nParams: TUniStrings);
    {*处理事件*}
    procedure DoColumnFormat(Sender: TField; var nText: string;
      nDisplayText: Boolean);
    {*字段格式化*}
    procedure DoColumnSort(nCol: TUniDBGridColumn; nDirection: Boolean);
    {*字段排序*}
    procedure DoColumnSummary(nCol: TUniDBGridColumn; nValue: Variant);
    procedure DoColumnSummaryResult(nCol: TUniDBGridColumn;
      nValue: Variant; nAttribs: TUniCellAttribs; var nResult: string);
    {*字段合计*}
  end;

implementation

class procedure TWebSystem.Init(const nForce: Boolean);
begin
  if nForce or (not Assigned(FSyncLock)) then
    FSyncLock := TCriticalSection.Create;
  //xxxxx
end;

class procedure TWebSystem.Release;
begin
  FreeAndNil(FSyncLock);
end;

//Date: 2020-06-23
//Desc: 全局同步锁定
class procedure TWebSystem.SyncLock;
begin
  FSyncLock.Enter;
end;

//Date: 2020-06-23
//Desc: 全局同步锁定解除
class procedure TWebSystem.SyncUnlock;
begin
  FSyncLock.Leave;
end;

//---------------------------------- 配置运行环境 ------------------------------
//Date: 2020-06-23
//Desc: 初始化运行环境
class procedure TWebSystem.InitSystemEnvironment;
begin
  Randomize;
  gPath := TApplicationHelper.gPath;

  with FormatSettings do
  begin
    DateSeparator := '-';
    ShortDateFormat := 'yyyy-MM-dd';
  end;

  with TObjectStatusHelper do
  begin
    shData := 50;
    shTitle := 100;
  end;
end;

//Date: 2020-06-23
//Desc: 载入系统配置参数
class procedure TWebSystem.LoadSysParameter(nIni: TIniFile = nil);
const sMain = 'Config';
var nStr,nDir: string;
    nBool: Boolean;
    nSA,nSB: TStringHelper.TStringArray;

    //Desc: 解析nData中的图片数据
    procedure GetImage(var nImg: TImageData; nData: string);
    var nInt: Integer;
    begin
      nData := Trim(nData);
      if nData = '' then Exit;

      if not TStringHelper.SplitArray(nData, nSA, ',', tpTrim) then Exit;
      //img,w x h,positon
      nInt := Length(nSA);

      if nInt > 0 then
        nImg.FFile := nDir + nSA[0];
      //xxxxx

      if (nInt > 1) and TStringHelper.SplitArray(nSA[1],nSB,'x',tpTrim,2) then
      begin
        nImg.FWidth := StrToInt(nSB[0]);
        nImg.FHeight := StrToInt(nSB[1]);
      end;

      if nInt > 2 then
        nImg.FPosition := TStringHelper.Str2Enum<TImagePosition>(nSA[2]);
      //xxxxx
    end;
begin
  nBool := Assigned(nIni);
  if not nBool then
    nIni := TIniFile.Create(TApplicationHelper.gSysConfig);
  //xxxxx

  with gSystem, nIni do
  try
    FillChar(gSystem, SizeOf(TSystemParam), #0);
    TApplicationHelper.LoadParameters(gSystem.FMain, nIni, True);
    //load main config
  finally
    if not nBool then nIni.Free;
  end;

  nStr := gPath + sImageDir + 'images.ini';
  if FileExists(nStr) then
  begin
    nIni := TIniFile.Create(nStr);
    with gSystem.FImages, nIni do
    try
      nDir := SwtichPathDelim(sImageDir);
      FillChar(gSystem.FImages, SizeOf(TSystemImage), #0);

      GetImage(FBgLogin,    ReadString(sMain, 'BgLogin', ''));
      GetImage(FBgMain,     ReadString(sMain, 'BgMain', ''));
      GetImage(FImgLogo,    ReadString(sMain, 'ImgLogo', ''));
      GetImage(FImgKey,     ReadString(sMain, 'ImgKey', ''));
      GetImage(FImgMainTL,  ReadString(sMain, 'ImgMainTL', ''));
      GetImage(FImgMainTR,  ReadString(sMain, 'ImgMainTR', ''));
      GetImage(FImgWelcome, ReadString(sMain, 'ImgWelcome', ''));
    finally
      nIni.Free;
    end;
  end;
end;

//Date: 2021-04-16
//Parm: 文件路径;原、目标
//Desc: 将nPatn中的路径分隔符转为特定风格
class function TWebSystem.SwtichPathDelim(const nPath,nFrom,nTo: string): string;
begin
  Result := StringReplace(nPath, nFrom, nTo, [rfReplaceAll]);
end;

//Date: 2021-06-06
//Parm: 类型;相对路径;强制刷新
//Desc: 返回当前用户的nType文件路径
class function TWebSystem.UserFile(const nType: TUserFileType;
  const nRelative: Boolean; const nForceRefresh: Boolean): string;
begin
  with UniMainModule do
  begin
    case nType of
     ufOPTCode: //启用动态口令时生成的二维码
      Result := Format('%s_opt.bmp', [FUser.FUserID]);
     else
      begin
        Result := '';
        Exit;
      end;
    end;

    if nRelative then //前端相对路径
    begin
      Result := 'users/' + Result;
      if nForceRefresh then
        Result := Result + '?t=' + TDateTimeHelper.DateTimeSerial;
      //添加序列号改变图片链接,使前端刷新
    end else
    begin
      Result := gPath + 'users\' + Result;
    end;
  end;
end;

//Date: 2021-05-25
//Desc: 用户自定义配置文件
class function TWebSystem.UserConfigFile: TIniFile;
var nStr: string;
begin
  Result := nil;
  try
    nStr := gPath + 'users\';
    if not DirectoryExists(nStr) then
      ForceDirectories(nStr);
    //new folder

    nStr := nStr + UniMainModule.FUser.FUserID + '.ini';
    Result := TIniFile.Create(nStr);

    if not FileExists(nStr) then
    begin
      Result.WriteString('Config', 'Account', UniMainModule.FUser.FAccount);
      Result.WriteString('Config', 'UserName', UniMainModule.FUser.FUserName);
    end;
  except
    Result.Free;
  end;
end;

//Date: 2021-05-31
//Parm: 窗体
//Desc: 载入窗体信息
class procedure TWebSystem.LoadFormConfig(const nForm: TfFormBase;
  const nIniF: TIniFile);
var nIni: TIniFile;
    nValue,nMax: integer;
begin
  if Assigned(nIniF) then
       nIni := nIniF
  else nIni := UserConfigFile;

  try
    with nForm do
    begin
      nMax := High(integer);
      nValue := nIni.ReadInteger(Name, 'FormTop', nMax);

      if nValue < nMax then
      begin
        Top := nValue;
      end else
      begin
        if Position = TPosition.poDesigned then
          Position := TPosition.poScreenCenter;
        //初次加载时居中,避免设计时分辨率不同越界
      end;

      nValue := nIni.ReadInteger(Name, 'FormLeft', nMax);
      if nValue < nMax then Left := nValue;

      if BorderStyle = TFormBorderStyle.bsSizeable then
      begin
        nValue := nIni.ReadInteger(Name, 'FormWidth', nMax);
        if nValue < nMax then Width := nValue;

        nValue := nIni.ReadInteger(Name, 'FormHeight', nMax);
        if nValue < nMax then Height := nValue;
      end; //载入窗体位置和宽高

      if nIni.ReadBool(Name, 'Maximized', False) = True then
         WindowState := TWindowState.wsMaximized;
      //最大化状态
    end;
  finally
    if not Assigned(nIniF) then nIni.Free;
  end;

end;

//Date: 2021-05-31
//Parm: 窗体
//Desc: 保存窗体信息
class procedure TWebSystem.SaveFormConfig(const nForm: TfFormBase;
  const nIniF: TIniFile);
var nIni: TIniFile;
    nBool: Boolean;
begin
  nBool := False;
  nIni := nil;
  try
    if Assigned(nIniF) then
         nIni := nIniF
    else nIni := UserConfigFile;

    with nForm do
    begin
      nBool := WindowState = wsMaximized;
      if nBool then
        WindowState := wsNormal;
      //还原,记录正常位置宽高

      nIni.WriteInteger(Name, 'FormTop', Top);
      nIni.WriteInteger(Name, 'FormLeft', Left);
      nIni.WriteInteger(Name, 'FormWidth', Width);
      nIni.WriteInteger(Name, 'FormHeight', Height);
      nIni.WriteBool(Name, 'Maximized', nBool);
      //保存窗体位置和宽高
    end;
  finally
    if not Assigned(nIniF) then
      nIni.Free;
    //xxxxx

    if nBool then
      nForm.WindowState := wsMaximized;
    //xxxx
  end;
end;

//Date: 2021-05-27
//Parm: 父容器;图片;数据
//Desc: 依据nData设置nImage属性
class procedure TWebSystem.SetImageData(const nParent: TUniContainer;
  const nImage: TUniImage; const nData: PImageData);
begin
  with nImage do
  begin
    Url := nData.FFile;
    if nData.FWidth > 0 then Width := nData.FWidth;
    if nData.FHeight > 0 then Height := nData.FHeight;

    case nData.FPosition of
     ipTL, ipTM, ipTR: nParent.LayoutAttribs.Align := 'top';
     ipML, ipMM, ipMR: nParent.LayoutAttribs.Align := 'middle';
     ipBL, ipBM, ipBR: nParent.LayoutAttribs.Align := 'bottom';
    end;

    case gSystem.FImages.FImgWelcome.FPosition of
     ipTL, ipML, ipBL: nParent.LayoutAttribs.Pack := 'start';
     ipTM, ipMM, ipBM: nParent.LayoutAttribs.Pack := 'center';
     ipTR, ipMR, ipBR: nParent.LayoutAttribs.Pack := 'end';
    end;
  end;
end;

//---------------------------------- 窗体调用 ----------------------------------
//Date: 2021-05-06
//Parm: 窗体类
//Desc: 注册窗体类
class procedure TWebSystem.AddForm(const nForm: TfFormClass);
var nStr: string;
    nIdx: Integer;
begin
  for nIdx := Low(Forms) to High(Forms) do
  if Forms[nIdx] = nForm then
  begin
    nStr := Format('TSysFun.AddForm: %s Has Exists.', [nForm.ClassName]);
    gMG.WriteLog(TWebSystem, 'Web系统对象', nStr);
    raise Exception.Create(nStr);
  end;

  nIdx := Length(Forms);
  SetLength(Forms, nIdx + 1);
  Forms[nIdx] := nForm;

  RegisterClass(nForm);
  //new class
end;

//Date: 2021-06-28
//Parm: 框架类
//Desc: 注册框架类
class procedure TWebSystem.AddFrame(const nFrame: TfFrameClass);
var nStr: string;
    nIdx: Integer;
begin
  for nIdx := Low(Frames) to High(Frames) do
  if Frames[nIdx] = nFrame then
  begin
    nStr := Format('TSysFun.AddFrame: %s Has Exists.', [nFrame.ClassName]);
    gMG.WriteLog(TWebSystem, 'Web系统对象', nStr);
    raise Exception.Create(nStr);
  end;

  nIdx := Length(Frames);
  SetLength(Frames, nIdx + 1);
  Frames[nIdx] := nFrame;

  RegisterClass(nFrame);
  //new class
end;

//Date: 2021-04-26
//Parm: 窗体类名
//Desc: 获取nClass类的对象
class function TWebSystem.GetForm(const nClass: string;
  const nException: Boolean): TUniForm;
var nCls: TClass;
begin
  nCls := GetClass(nClass);
  if Assigned(nCls) then
       Result := TUniForm(UniMainModule.GetFormInstance(nCls))
  else Result := nil;

  if (not Assigned(Result)) and nException then
    UniMainModule.ShowMsg(Format('窗体类[ %s ]无效.', [nClass]), True);
  //xxxxx
end;

//Date: 2021-04-27
//Parm: 窗体类;输入参数;输出参数
//Desc: 显示类名为nClass的模式窗体
class procedure TWebSystem.ShowModalForm(const nClass: string;
  const nParams: PFormCommandParam; const nResult: TFormModalResult);
var nForm: TUniForm;
begin
  nForm := TWebSystem.GetForm(nClass);
  if (not Assigned(nForm)) or (not (nForm is TfFormBase)) then Exit;
  //invalid class

  with nForm as TfFormBase do
  begin
    if Assigned(nParams) then
      SetData(nParams);
    //xxxxx

    ShowModal(
      procedure(Sender: TComponent; nModalResult:Integer)
      var nData: TFormCommandParam;
      begin
        if Assigned(nResult) and GetData(nData) then
          nResult(nModalResult, @nData);
        //xxxxx
      end);
  end;
end;

//Date: 2021-06-28
//Parm: 菜单数据;父容器
//Desc: 依据nMenu在nParent上创建Frame框架
class procedure TWebSystem.ShowFrame(const nMenu: PMenuItem;
  const nParent: TUniPageControl; const nOnClose: TTabCloseEvent);
var nIdx: Integer;
    nNew: TfFrameBase;
    nFrame: TfFrameClass;
    nSheet: TUniTabSheet;
begin
  nFrame := TfFrameClass(GetClass(nMenu.FActionData));
  for nIdx := nParent.PageCount - 1 downto 0 do
  begin
    nSheet := nParent.Pages[nIdx];
    if not Assigned(nSheet.Data) then Continue;
    //no frame

    nNew := nSheet.Data;
    if nNew is nFrame then //exists
    begin
      nParent.ActivePage := nSheet;
      Exit;
    end;
  end;

  nSheet := TUniTabSheet.Create(nParent);
  with nSheet do
  begin
    Pagecontrol := nParent;
    Caption := nMenu.FTitle;
    Closable := True;

    if nMenu.FImgIndex >= 0 then
      ImageIndex := nMenu.FImgIndex;
    OnClose := nOnClose;
  end;

  nNew := nFrame.Create(nParent);
  nNew.Parent := nSheet;
  nNew.Align := alClient;
  nSheet.Data := nNew;

  nParent.ActivePage := nSheet;
  //active
end;

//------------------------------------------------------------------------------
class procedure TGridHelper.Init(const nForce: Boolean);
begin
  if nForce then
    FGridHelper := nil;
  //xxxxx

  if nForce or (not Assigned(FSyncLock)) then
    FSyncLock := TCriticalSection.Create;
  //xxxxx

  if nForce or (not Assigned(FDictEntity)) then
    FDictEntity := TDictionary<TObject, PDictEntity>.Create();
  //xxxxx
end;

class procedure TGridHelper.Release;
begin
  FreeAndNil(FGridHelper);
  FreeAndNil(FDictEntity);
  FreeAndNil(FSyncLock);
end;

//Date: 2021-06-25
//Desc: 获取实例
class function TGridHelper.GetHelper: TGridHelper;
begin
  if not Assigned(FGridHelper)  then
    FGridHelper := TGridHelper.Create;
  Result := FGridHelper;
end;

//Date: 2021-06-27
//Desc: 全局同步锁定
class procedure TGridHelper.SyncLock;
begin
  FSyncLock.Enter;
end;

//Date: 2021-06-27
//Desc: 全局同步锁定解除
class procedure TGridHelper.SyncUnlock;
begin
  FSyncLock.Leave;
end;

//Date: 2021-06-27
//Parm: 数据集;数据字典
//Desc: 绑定nDS的数据字典nDE
class procedure TGridHelper.BindEntity(const nObj: TObject;
  const nDE: PDictEntity);
begin
  SyncLock;
  try
    FDictEntity.AddOrSetValue(nObj, nDE);
    //bind
  finally
    SyncUnlock;
  end;
end;

//Date: 2021-06-27
//Parm: 数据集
//Desc: 解除nDS的数据字典
class procedure TGridHelper.UnbindEntity(const nObj: TObject);
begin
  SyncLock;
  try
    if FDictEntity.ContainsKey(nObj) then
      FDictEntity.Remove(nObj);
    //unbind
  finally
    SyncUnlock;
  end;
end;

//Date: 2021-06-25
//Parm: 数据字典;列表;排除字段
//Desc: 使用数据字典nEntity构建nGrid的表头
class procedure TGridHelper.BuildDBGridColumn(const nEntity: PDictEntity;
  const nGrid: TUniDBGrid; const nFilter: string);
var nStr: string;
    nIdx: Integer;
    nList: TStrings;
    nColumn: TUniBaseDBGridColumn;
begin
  nList := nil;
  with nGrid, TStringHelper do
  try
    Columns.BeginUpdate;
    Columns.Clear;
    //clear first

    BorderStyle := ubsDefault;
    LoadMask.Message := '加载数据';
    Options := [dgTitles, dgIndicator, dgColLines, dgRowLines, dgRowSelect];

    if UniMainModule.FGridColumnAdjust then
      Options := Options + [dgColumnResize, dgColumnMove];
    //选项控制

    ReadOnly := True;
    WebOptions.Paged := True;
    WebOptions.PageSize := 1000;

    nStr := 'headercontextmenu=function headercontextmenu(ct, column, e, t, eOpts)' +
      '{ajaxRequest($O, ''$E'', [''xy='' + e.getXY(),''col='' + column.dataIndex])}';
    //grid column popmenu

    nStr := MacroValue(nStr, [MI('$O', nGrid.JSName),
      MI('$E', sEvent_DBGridHeaderPopmenu)]);
    //xxxxx

    if nGrid.ClientEvents.ExtEvents.IndexOf(nStr) < 0 then
      nGrid.ClientEvents.ExtEvents.Add(nStr);
    //xxxxx

    if not Assigned(OnColumnSort) then
      OnColumnSort := GetHelper.DoColumnSort;
    if not Assigned(OnColumnSummary) then
      OnColumnSummary := GetHelper.DoColumnSummary;
    if not Assigned(OnColumnSummaryResult) then
      OnColumnSummaryResult := GetHelper.DoColumnSummaryResult;
    //xxxxx

    if nFilter <> '' then
    begin
      nList := gMG.FObjectPool.Lock(TStrings) as TStrings;
      TStringHelper.Split(nFilter, nList, ';', tpTrim);
    end;

    with Summary do
    begin
      Enabled := False;
      GrandTotal := False;
    end;

    for nIdx := Low(nEntity.FItems) to High(nEntity.FItems) do
    with nEntity.FItems[nIdx] do
    begin
      if not FVisible then Continue;

      if Assigned(nList) and (nList.IndexOf(FDBItem.FField) >= 0) then
        Continue;
      //字段被过滤,不予显示

      nColumn := Columns.Add;
      with nColumn do
      begin
        Tag := nIdx;
        Sortable := True;
        Alignment := FAlign;
        FieldName := FDBItem.FField;

        Title.Alignment := FAlign;
        Title.Caption := FTitle;
        Width := FWidth;

        if (FFooter.FKind = fkSum) or (FFooter.FKind = fkCount) then
        begin
          nColumn.ShowSummary := True;
          Summary.Enabled := True;
        end;
      end;
    end;
  finally
    nGrid.Columns.EndUpdate;
    gMG.FObjectPool.Release(nList);
  end;
end;

//Date: 2021-06-25
//Parm: 窗体名;表格;读取
//Desc: 读写nForm.nGrid的用户配置
class procedure TGridHelper.UserDefineGrid(const nForm: string;
  const nGrid: TUniDBGrid; const nLoad: Boolean; nIni: TIniFile);
var nStr: string;
    i,j,nCount: Integer;
    nBool: Boolean;
    nList: TStrings;
begin
  nBool := Assigned(nIni);
  nList := nil;
  //init

  with TStringHelper do
  try
    if not nBool then
      nIni := TWebSystem.UserConfigFile;
    //xxxxx

    nCount := nGrid.Columns.Count - 1;
    //column num

    if nLoad then
    begin
      nList := gMG.FObjectPool.Lock(TStrings) as TStrings;
      nStr := nIni.ReadString(nForm, 'GridIndex_' + nGrid.Name, '');
      if Split(nStr, nList, '', tpNo, nGrid.Columns.Count) then
      begin
        for i := 0 to nCount do
        begin
          if not IsNumber(nList[i], False) then Continue;
          //not valid

          for j := 0 to nCount do
          if nGrid.Columns[j].Tag = StrToInt(nList[i]) then
          begin
            nGrid.Columns[j].Index := i;
            Break;
          end;
        end;
      end;

      nStr := nIni.ReadString(nForm, 'GridWidth_' + nGrid.Name, '');
      if Split(nStr, nList, '', tpNo, nGrid.Columns.Count) then
      begin
        for i := 0 to nCount do
         if IsNumber(nList[i], False) then
          nGrid.Columns[i].Width := StrToInt(nList[i]);
        //apply width
      end;

      if not UniMainModule.FGridColumnAdjust then //调整时全部显示
      begin
        nStr := nIni.ReadString(nForm, 'GridVisible_' + nGrid.Name, '');
        if Split(nStr, nList, '', tpNo, nGrid.Columns.Count) then
        begin
          for i := 0 to nCount do
            nGrid.Columns[i].Visible := nList[i] = '1';
          //apply visible
        end;
      end;
    end else
    begin
      if UniMainModule.FGridColumnAdjust then //save manual adjust grid
      begin
        nStr := '';
        for i := 0 to nCount do
        begin
          nStr := nStr + IntToStr(nGrid.Columns[i].Tag);
          if i <> nCount then nStr := nStr + ';';
        end;
        nIni.WriteString(nForm, 'GridIndex_' + nGrid.Name, nStr);

        nStr := '';
        for i := 0 to nCount do
        begin
          nStr := nStr + IntToStr(nGrid.Columns[i].Width);
          if i <> nCount then nStr := nStr + ';';
        end;
        nIni.WriteString(nForm, 'GridWidth_' + nGrid.Name, nStr);
      end else
      begin
        nStr := '';
        for i := 0 to nCount do
        begin
          if nGrid.Columns[i].Visible then
               nStr := nStr + '1'
          else nStr := nStr + '0';
          if i <> nCount then nStr := nStr + ';';
        end;
        nIni.WriteString(nForm, 'GridVisible_' + nGrid.Name, nStr);
      end;
    end;
  finally
    gMG.FObjectPool.Release(nList);
    if not nBool then
      nIni.Free;
    //xxxxx
  end;
end;

//Date: 2021-06-25
//Parm: 窗体名;表格;读取
//Desc: 读写nForm.nGrid的用户配置
class procedure TGridHelper.UserDefineStringGrid(const nForm: string;
  const nGrid: TUniStringGrid; const nLoad: Boolean; nIni: TIniFile);
var nStr: string;
    nIdx,nCount: Integer;
    nBool: Boolean;
    nList: TStrings;
begin
  nBool := Assigned(nIni);
  nList := nil;
  //init

  with TStringHelper do
  try

    if not nBool then
      nIni := TWebSystem.UserConfigFile;
    //xxxxx

    nCount := nGrid.Columns.Count - 1;
    //column num

    if nLoad then
    begin
      nStr := 'columnresize=function columnresize(ct,column,width,eOpts){'+
        'ajaxRequest($O, ''$E'', [''idx=''+column.dataIndex,''w=''+width])}';
      //add resize event

      nStr := MacroValue(nStr, [MI('$O', nGrid.JSName),
        MI('$E', sEvent_StrGridColumnResize)]);
      //xxxx

      nIdx := nGrid.ClientEvents.ExtEvents.IndexOf(nStr);
      if UniMainModule.FGridColumnAdjust and (nIdx < 0) then
      begin
        nGrid.Options := nGrid.Options + [goColSizing];
        //添加可调列宽

        nGrid.ClientEvents.ExtEvents.Add(nStr);
        //添加事件监听

        if not Assigned(nGrid.OnAjaxEvent) then
          nGrid.OnAjaxEvent := GetHelper.DoGridEvent;
        //添加事件处理
      end else
      begin
        nGrid.Options := nGrid.Options - [goColSizing];
        //删除可调列宽

        if nIdx >= 0 then
          nGrid.ClientEvents.ExtEvents.Delete(nIdx);
        //xxxxx
      end;

      nList := gMG.FObjectPool.Lock(TStrings) as TStrings;
      nStr := nIni.ReadString(nForm, 'GridWidth_' + nGrid.Name, '');

      if Split(nStr, nList, '', tpNo, nGrid.Columns.Count) then
      begin
        for nIdx := 0 to nCount do
         if (nGrid.Columns[nIdx].Width>0) and IsNumber(nList[nIdx], False) then
          nGrid.Columns[nIdx].Width := StrToInt(nList[nIdx]);
        //apply width
      end;
    end else

    if UniMainModule.FGridColumnAdjust then
    begin
      nStr := '';
      for nIdx := 0 to nCount do
      begin
        nStr := nStr + IntToStr(nGrid.Columns[nIdx].Width);
        if nIdx <> nCount then nStr := nStr + ';';
      end;
      nIni.WriteString(nForm, 'GridWidth_' + nGrid.Name, nStr);
    end;
  finally
    gMG.FObjectPool.Release(nList);
    if not nBool then
      nIni.Free;
    //xxxxx
  end;
end;

//Date: 2021-06-27
//Parm: 表格;参数
//Desc: 用户调整列宽时触发,将用户调整的结果应用到nGrid
class procedure TGridHelper.DoStringGridColumnResize(const nGrid: TObject;
  const nParam: TUniStrings);
var nStr: string;
    nIdx,nW: Integer;
begin
  with TStringHelper,TUniStringGrid(nGrid) do
  begin
    nStr := nParam.Values['idx'];
    if IsNumber(nStr, False) then
         nIdx := StrToInt(nStr)
    else nIdx := -1;

    if (nIdx < 0) or (nIdx >= Columns.Count) then Exit;
    //out of range

    nStr := nParam.Values['w'];
    if IsNumber(nStr, False) then
         nW := StrToInt(nStr)
    else nW := -1;

    if nW < 0 then Exit;
    if nW > 320 then
      nW := 320;
    Columns[nIdx].Width := nW;
  end;
end;

//Date: 2021-06-25
//Desc: 处理表格事件
procedure TGridHelper.DoGridEvent(Sender: TComponent; nEventName: string;
  nParams: TUniStrings);
begin
  if nEventName = sEvent_StrGridColumnResize then
    DoStringGridColumnResize(Sender, nParams);
  //用户调整列宽
end;

//Date: 2021-06-25
//Parm: 数据字典;数据集;处理事件
//Desc: 设置nClientDS数据格式化
class procedure TGridHelper.SetGridColumnFormat(const nEntity: PDictEntity;
  const nMT: TkbmMemTable);
var nIdx: Integer;
    nField: TField;
begin
  for nIdx := Low(nEntity.FItems) to High(nEntity.FItems) do
  with nEntity.FItems[nIdx] do
  begin
    if FFormat.FStyle <> fsFixed then Continue;
    if Trim(FFormat.FData) = '' then Continue;

    nField := nMT.FindField(FDBItem.FField);
    if Assigned(nField) then
    begin
      nField.Tag := nIdx;
      nField.OnGetText := GetHelper.DoColumnFormat;
    end;
  end;
end;

//Date: 2021-06-25
//Parm: 字段;待显内容;当前显示
//Desc: 将数据格式化为显示内容
procedure TGridHelper.DoColumnFormat(Sender: TField; var nText: string;
  nDisplayText: Boolean);
var nStr: string;
    nIdx,nInt: Integer;
    nEntity: PDictEntity;
begin
  SyncLock;
  try
    if not FDictEntity.TryGetValue(Sender.DataSet, nEntity) then Exit;
    //no bind datadict

    with nEntity.FItems[Sender.Tag] do
    begin
      nStr := Trim(Sender.AsString) + '=';
      if nStr = '=' then Exit;

      nIdx := Pos(nStr, FFormat.FData);
      if nIdx < 1 then Exit;

      nInt := nIdx + Length(nStr);     //start
      nStr := Copy(FFormat.FData, nInt, Length(FFormat.FData) - nInt + 1);

      nInt := Pos(';', nStr);
      if nInt < 2 then
           nText := nStr
      else nText := Copy(nStr, 1, nInt - 1);
    end;
  finally
    SyncUnlock;
  end;
end;

//Date: 2021-06-24
//Parm: 数据集
//Desc: 构建nDS的排序索引
class procedure TGridHelper.BuidDataSetSortIndex(const nMT: TkbmMemTable);
var nStr: string;
    nIdx: Integer;
begin
  with nMT do
  begin
    for nIdx := FieldCount-1 downto 0 do
    begin
      nStr := Fields[nIdx].FieldName + '_asc';
      if IndexDefs.IndexOf(nStr) < 0 then
        AddIndex(nStr, Fields[nIdx].FieldName, []);
      //xxxxx

      nStr := Fields[nIdx].FieldName + '_des';
      if IndexDefs.IndexOf(nStr) < 0 then
        AddIndex(nStr, Fields[nIdx].FieldName, [ixDescending]);
      //xxxxx
    end;
  end;
end;

//Date: 2021-06-27
//Parm: 数据列;排序方式
//Desc: 按照nDirection对nCol排序
procedure TGridHelper.DoColumnSort(nCol: TUniDBGridColumn; nDirection: Boolean);
var nStr: string;
    nMT: TkbmMemTable;
begin
  if TUniDBGrid(nCol.Grid).DataSource.DataSet is TkbmMemTable then
       nMT := TUniDBGrid(nCol.Grid).DataSource.DataSet as TkbmMemTable
  else Exit;

  if nDirection then
       nStr := nCol.FieldName + '_asc'
  else nStr := nCol.FieldName + '_des';

  if nMT.IndexDefs.IndexOf(nStr) >= 0 then
    nMT.IndexName := nStr;
  //xxxxx
end;

//Date: 2021-06-27
//Parm: 数据列;合计值
//Desc: 对nCol执行合计
procedure TGridHelper.DoColumnSummary(nCol: TUniDBGridColumn; nValue: Variant);
var nEntity: PDictEntity;
begin
  SyncLock;
  try
    if not FDictEntity.TryGetValue(nCol.Grid, nEntity) then Exit;
    //no bind datadict

    with nEntity.FItems[nCol.Tag] do
    begin
      if FFooter.FKind = fkSum then //sum
      begin
        if nCol.AuxValue = NULL then
             nCol.AuxValue := nCol.Field.AsFloat
        else nCol.AuxValue := nCol.AuxValue + nCol.Field.AsFloat;
      end else

      if FFooter.FKind = fkCount then //count
      begin
        if nCol.AuxValue = NULL then
             nCol.AuxValue := 1
        else nCol.AuxValue := nCol.AuxValue + 1;
      end;
    end;
  finally
    SyncUnlock;
  end;
end;

//Date: 2021-06-27
//Parm: 数据列
//Desc: 显示nCol合计结果
procedure TGridHelper.DoColumnSummaryResult(nCol: TUniDBGridColumn;
  nValue: Variant; nAttribs: TUniCellAttribs; var nResult: string);
var nF: Double;
    nI: Integer;
    nEntity: PDictEntity;
begin
  SyncLock;
  try
    if not FDictEntity.TryGetValue(nCol.Grid, nEntity) then Exit;
    //no bind datadict

    with nEntity.FItems[nCol.Tag] do
    begin
      if FFooter.FKind = fkSum then //sum
      begin
        if nCol.AuxValue = Null then Exit;
        nF := nCol.AuxValue;
        nResult := FormatFloat(FFooter.FFormat, nF );

        nAttribs.Font.Style := [fsBold];
        nAttribs.Font.Color := clNavy;
      end else

      if FFooter.FKind = fkCount then //count
      begin
        if nCol.AuxValue = Null then Exit;
        nI := nCol.AuxValue;
        nResult := FormatFloat(FFooter.FFormat, nI);

        nAttribs.Font.Style := [fsBold];
        nAttribs.Font.Color := clNavy;
      end;
    end;

    nCol.AuxValue := NULL;
  finally
    SyncUnlock;
  end;
end;

class function TGridHelper.GridExportExcel(const nGrid: TUniDBGrid;
  const nFile: string): string;
begin

end;

initialization
  TWebSystem.Init(True);
  TGridHelper.Init(True);
finalization
  TWebSystem.Release;
  TGridHelper.Release;
end.


