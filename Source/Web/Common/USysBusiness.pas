{*******************************************************************************
  ����: dmzn@163.com 2020-06-23
  ����: ҵ���嵥Ԫ
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
  ///<summary>System Function: ϵͳ�����ͨ�ú���</summary>
  TSysFun = class
  private
    class var
      FSyncLock: TCriticalSection;
      {*ȫ��ͬ����*}
  public
    class procedure Init; static;
    {*��ʼ��*}
    class procedure Release; static;
    {*�ͷ���Դ*}
    class procedure SyncLock; static;
    class procedure SyncUnlock; static;
    {*ȫ��ͬ��*}
    class procedure InitSystemEnvironment; static;
    {*��ʼ��ϵͳ���л����ı���*}
    class procedure LoadSysParameter(nIni: TIniFile = nil); static;
    {*����ϵͳ���ò���*}
    class function SwtichPathDelim(const nPath: string;
      const nFrom: string = '\'; const nTo: string = '/'): string; static;
    {*�л�·���ָ���*}
    class function GetForm(const nClass: string;
      const nException: Boolean = False): TUniForm; static;
    {*��ȡ����*}
    class procedure ShowModalForm(const nClass: string;
      const nParams: PFormCommandParam = nil;
      const nResult: TFormModalResult = nil); static;
    {*��ʾģʽ����*}
  end;

implementation

class procedure TSysFun.Init;
begin
  FSyncLock := TCriticalSection.Create;
end;

class procedure TSysFun.Release;
begin
  FreeAndNil(FSyncLock);
end;

//Date: 2020-06-23
//Desc: ȫ��ͬ������
class procedure TSysFun.SyncLock;
begin
  FSyncLock.Enter;
end;

//Date: 2020-06-23
//Desc: ȫ��ͬ���������
class procedure TSysFun.SyncUnlock;
begin
  FSyncLock.Leave;
end;

//---------------------------------- �������л��� ------------------------------
//Date: 2020-06-23
//Desc: ��ʼ�����л���
class procedure TSysFun.InitSystemEnvironment;
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
//Desc: ����ϵͳ���ò���
class procedure TSysFun.LoadSysParameter(nIni: TIniFile = nil);
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
    TApplicationHelper.LoadParameters(gSystem.FMain, nIni);
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
    finally
      nIni.Free;
    end;
  end;
end;

//Date: 2021-04-16
//Parm: �ļ�·��;ԭ��Ŀ��
//Desc: ��nPatn�е�·���ָ���תΪ�ض����
class function TSysFun.SwtichPathDelim(const nPath,nFrom,nTo: string): string;
begin
  Result := StringReplace(nPath, nFrom, nTo, [rfReplaceAll]);
end;

//---------------------------------- ������� ----------------------------------
//Date: 2021-04-26
//Parm: ��������
//Desc: ��ȡnClass��Ķ���
class function TSysFun.GetForm(const nClass: string;
  const nException: Boolean): TUniForm;
var nCls: TClass;
begin
  nCls := GetClass(nClass);
  if Assigned(nCls) then
       Result := TUniForm(UniMainModule.GetFormInstance(nCls))
  else Result := nil;

  if (not Assigned(Result)) and nException then
    UniMainModule.ShowMsg(Format('������[ %s ]��Ч.', [nClass]), True);
  //xxxxx
end;

//Date: 2021-04-27
//Parm: ������;�������;�������
//Desc: ��ʾ����ΪnClass��ģʽ����
class procedure TSysFun.ShowModalForm(const nClass: string;
  const nParams: PFormCommandParam; const nResult: TFormModalResult);
var nForm: TUniForm;
begin
  nForm := TSysFun.GetForm(nClass);
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
  TSysFun.Init;
finalization
  TSysFun.Release;
end.


