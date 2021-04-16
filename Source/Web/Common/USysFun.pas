{*******************************************************************************
  作者: dmzn@163.com 2020-06-23
  描述: 项目通用函数定义单元
*******************************************************************************}
unit USysFun;

interface

uses
  Vcl.Forms, System.SysUtils, System.IniFiles, ULibFun, UBaseObject, USysConst;

procedure InitSystemEnvironment;
//初始化系统运行环境的变量
procedure LoadSysParameter(nIni: TIniFile = nil);
//载入系统配置参数
function SwtichPathDelim(const nPath: string; const nFrom: string = '\';
  const nTo: string = '/'): string;
//切换路径分隔符

implementation

//---------------------------------- 配置运行环境 ------------------------------
//Date: 2020-06-23
//Desc: 初始化运行环境
procedure InitSystemEnvironment;
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
procedure LoadSysParameter(nIni: TIniFile = nil);
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
//Parm: 文件路径;原、目标
//Desc: 将nPatn中的路径分隔符转为特定风格
function SwtichPathDelim(const nPath,nFrom,nTo: string): string;
begin
  Result := StringReplace(nPath, nFrom, nTo, [rfReplaceAll]);
end;

end.


