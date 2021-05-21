{*******************************************************************************
  作者: dmzn@163.com 2020-06-23
  描述: 业务定义单元
*******************************************************************************}
unit USysBusiness;

{$I Link.Inc}
interface

uses
  Vcl.Controls, System.Classes, System.SysUtils, Data.DB, System.SyncObjs,
  System.IniFiles,
  //----------------------------------------------------------------------------
  uniGUIAbstractClasses, uniGUITypes, uniGUIClasses, uniGUIBaseClasses,
  uniGUISessionManager, uniGUIApplication, uniTreeView, uniGUIForm,
  uniDBGrid, uniStringGrid, uniComboBox, MainModule, UFormBase,
  //----------------------------------------------------------------------------
  UBaseObject, UManagerGroup, ULibFun, USysDB, USysConst, USysRemote;

type
  ///<summary>System Function: 系统级别的通用函数</summary>
  TWebSystem = class
  private
    class var
      FSyncLock: TCriticalSection;
      {*全局同步锁*}
  public
    class var
      Forms: array of TfFormClass;
      {*窗体列表*}
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
    {*注册窗体类*}
    class function GetForm(const nClass: string;
      const nException: Boolean = False): TUniForm; static;
    {*获取窗体*}
    class procedure ShowModalForm(const nClass: string;
      const nParams: PFormCommandParam = nil;
      const nResult: TFormModalResult = nil); static;
    {*显示模式窗体*}
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
var nStr: string;
    nBool: Boolean;
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
      nStr       := SwtichPathDelim(sImageDir);
      FBgLogin   := nStr + ExtractFileName(ReadString(sMain, 'BgLogin', ''));
      FBgMain    := nStr + ExtractFileName(ReadString(sMain, 'BgMain', ''));
      FImgLogo   := nStr + ExtractFileName(ReadString(sMain, 'ImgLogo', ''));
      FImgKey    := nStr + ExtractFileName(ReadString(sMain, 'ImgKey', ''));
      FImgMainTL := nStr + ExtractFileName(ReadString(sMain, 'ImgMainTL', ''));
      FImgMainTR := nStr + ExtractFileName(ReadString(sMain, 'ImgMainTR', ''));
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

initialization
  TWebSystem.Init(True);
finalization
  TWebSystem.Release;
end.


