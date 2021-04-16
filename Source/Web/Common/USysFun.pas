{*******************************************************************************
  ����: dmzn@163.com 2020-06-23
  ����: ��Ŀͨ�ú������嵥Ԫ
*******************************************************************************}
unit USysFun;

interface

uses
  Vcl.Forms, System.SysUtils, System.IniFiles, ULibFun, UBaseObject, USysConst;

procedure InitSystemEnvironment;
//��ʼ��ϵͳ���л����ı���
procedure LoadSysParameter(nIni: TIniFile = nil);
//����ϵͳ���ò���
function SwtichPathDelim(const nPath: string; const nFrom: string = '\';
  const nTo: string = '/'): string;
//�л�·���ָ���

implementation

//---------------------------------- �������л��� ------------------------------
//Date: 2020-06-23
//Desc: ��ʼ�����л���
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
//Desc: ����ϵͳ���ò���
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
//Parm: �ļ�·��;ԭ��Ŀ��
//Desc: ��nPatn�е�·���ָ���תΪ�ض����
function SwtichPathDelim(const nPath,nFrom,nTo: string): string;
begin
  Result := StringReplace(nPath, nFrom, nTo, [rfReplaceAll]);
end;

end.


