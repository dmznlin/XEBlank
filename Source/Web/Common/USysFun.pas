{*******************************************************************************
  作者: dmzn@163.com 2020-06-23
  描述: 项目通用函数定义单元
*******************************************************************************}
unit USysFun;

interface

uses
  Vcl.Forms, System.SysUtils, System.IniFiles, Global.USysFun, ULibFun,
  UBaseObject, USysConst;

procedure InitSystemEnvironment;
//初始化系统运行环境的变量
procedure LoadSysParameter(const nIni: TIniFile = nil);
//载入系统配置参数

implementation

//---------------------------------- 配置运行环境 ------------------------------
//Date: 2020-06-23
//Desc: 初始化运行环境
procedure InitSystemEnvironment;
begin
  Randomize;
  gPath := ExtractFilePath(Application.ExeName);
  TApplicationHelper.gPath := gPath;

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
procedure LoadSysParameter(const nIni: TIniFile = nil);
var nTmp: TIniFile;
begin
  if Assigned(nIni) then
       nTmp := nIni
  else nTmp := TIniFile.Create(gPath + sConfigFile);

  try
    with gSystem, nTmp do
    begin
      FillChar(gSystem, SizeOf(TSystemParam), #0);
      //初始化全局参数

      FGroupID := ReadString(sConfigSec, 'GroupID', sProgID);
      //集团代码
      FFactory := ReadString(sConfigSec, 'FactoryID', sProgID);
      //工厂代码
      FProgID := ReadString(sConfigSec, 'ProgID', sProgID);
      //系统代码

      FAppTitle   := ReadString(FProgID, 'AppTitle', sAppTitle);
      FMainTitle  := ReadString(FProgID, 'MainTitle', sMainCaption);
      FHintText   := ReadString(FProgID, 'HintText', '');
      FCopyRight  := ReadString(FProgID, 'CopyRight', '');

      FSystemInit := ReadString('Server', 'SystemInit', 'N') = 'Y';
      FPort       := ReadInteger('Server', 'Port', 8077);
      FFavicon    := ReplaceGlobalPath(ReadString('Server', 'Favicon', ''));
      FDBMain     := ReadString('Database', 'Main', '');
    end;
  finally
    if not Assigned(nIni) then nTmp.Free;
  end;
end;

end.


