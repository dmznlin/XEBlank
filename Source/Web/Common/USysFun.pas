{*******************************************************************************
  ����: dmzn@163.com 2020-06-23
  ����: ��Ŀͨ�ú������嵥Ԫ
*******************************************************************************}
unit USysFun;

interface

uses
  Vcl.Forms, System.SysUtils, System.IniFiles, Global.USysFun, ULibFun,
  UBaseObject, USysConst;

procedure InitSystemEnvironment;
//��ʼ��ϵͳ���л����ı���
procedure LoadSysParameter(const nIni: TIniFile = nil);
//����ϵͳ���ò���

implementation

//---------------------------------- �������л��� ------------------------------
//Date: 2020-06-23
//Desc: ��ʼ�����л���
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
//Desc: ����ϵͳ���ò���
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
      //��ʼ��ȫ�ֲ���

      FGroupID := ReadString(sConfigSec, 'GroupID', sProgID);
      //���Ŵ���
      FFactory := ReadString(sConfigSec, 'FactoryID', sProgID);
      //��������
      FProgID := ReadString(sConfigSec, 'ProgID', sProgID);
      //ϵͳ����

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


