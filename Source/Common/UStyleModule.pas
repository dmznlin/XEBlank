{*******************************************************************************
  作者: dmzn@163.com 2019-02-26
  描述: 界面风格管理单元
*******************************************************************************}
unit UStyleModule;

interface

uses
  System.SysUtils, System.Classes, dxSkinsCore, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Silver, dxSkinCaramel,
  dxSkinSpringTime, dxSkinSummer2008, dxSkinValentine, dxSkinXmas2008Blue,
  System.ImageList, Vcl.ImgList, Vcl.Controls, cxImageList, cxGraphics,
  cxLookAndFeels, dxSkinsForm, cxClasses, cxEdit, cxLookAndFeelPainters,
  dxAlertWindow, dxSkinsDefaultPainters, dxLayoutLookAndFeels, cxContainer;

type
  TVerifyUIData = reference to procedure (const nCtrl: TControl;
   var nResult: Boolean; var nHint: string);
  //验证组件数据

  TFSM = class(TDataModule)
    EditStyle1: TcxDefaultEditStyleController;
    SkinManager: TdxSkinController;
    Image16: TcxImageList;
    AlertManager1: TdxAlertWindowManager;
    Image32: TcxImageList;
    dxLayout1: TdxLayoutLookAndFeelList;
    dxLayoutWeb1: TdxLayoutWebLookAndFeel;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadSkinNames(const nList: TStrings);
    {*主题列表*}
    procedure SwitchSkinRandom;
    procedure SwitchSkin(const nSkin: string; const nVerify: Boolean);
    {*切换主题*}
    procedure ShowMsg(const nMsg: string; nTitle: string = '');
    {*消息框*}
    procedure ShowDlg(const nMsg: string; nTitle: string = '';
      nHwnd: integer = -1);
    function QueryDlg(const nMsg: string; nTitle: string = '';
      nHwnd: integer = -1): Boolean;
    {*提示框*}
    function VerifyUIData(const nParent: TWinControl;
      const nVerify: TVerifyUIData; const nShowMsg: Boolean = True;
      const nVerifySub: Boolean = True): Boolean;
    {*验证数据*}
  end;

var
  FSM: TFSM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  Winapi.Windows, System.IniFiles, Vcl.Forms, ULibFun, UManagerGroup;

procedure TFSM.DataModuleCreate(Sender: TObject);
var nStr: string;
    nIni: TIniFile;
begin
  nIni := TIniFile.Create(TApplicationHelper.gFormConfig);
  try
    nStr := nIni.ReadString('Config', 'Theme', '');
    if nStr <> '' then
      SwitchSkin(nStr, True);
    //xxxxx
  finally
    nIni.Free;
  end;
end;

//Date: 2019-02-27
//Parm: 列表
//Desc: 当前可用的皮肤列表
procedure TFSM.LoadSkinNames(const nList: TStrings);
var nIdx: Integer;
begin
  nList.Clear;
  for nIdx := 0 to cxLookAndFeelPaintersManager.Count - 1 do
   with cxLookAndFeelPaintersManager[nIdx] do
    if (LookAndFeelStyle = lfsSkin) and (not IsInternalPainter) then
     nList.Add(LookAndFeelName);
  //xxxxx
end;

//Date: 2019-02-27
//Parm: 主题名称;验证主题是否有效
//Desc: 切换主题为nSkin
procedure TFSM.SwitchSkin(const nSkin: string; const nVerify: Boolean);
var nList: TStrings;
begin
  nList := nil;
  try
    if nVerify then
    begin
      nList := gMG.FObjectPool.Lock(TStrings) as TStrings;
      LoadSkinNames(nList);
      if nList.IndexOf(nSkin) < 0 then Exit;
    end;

    if SkinManager.SkinName <> nSkin then
      SkinManager.SkinName := nSkin;
    //xxxxx
  finally
    gMG.FObjectPool.Release(nList);
  end;
end;

//Date: 2020-10-26
//Desc: 随机切换主题
procedure TFSM.SwitchSkinRandom;
var nIdx: Integer;
    nList: TStrings;
begin
  nList := nil;
  try
    nList := gMG.FObjectPool.Lock(TStrings) as TStrings;
    FSM.LoadSkinNames(nList);
    nIdx := Random(nList.Count);

    if nIdx < nList.Count then
      FSM.SwitchSkin(nList[nIdx], False);
    //xxxxx
  finally
    gMG.FObjectPool.Release(nList);
  end;
end;

//Date: 2019-03-01
//Parm: 父容器;验证函数;是否弹消息框;验证子容器
//Desc: 验证nParent下的所有控件数据有效
function TFSM.VerifyUIData(const nParent: TWinControl;
  const nVerify: TVerifyUIData; const nShowMsg,nVerifySub: Boolean): Boolean;
var nStr: string;
    nIdx: Integer;
begin
  Result := True;
  for nIdx := 0 to nParent.ControlCount - 1 do
  begin
    nVerify(nParent.Controls[nIdx], Result, nStr);
    //call-back to verify data

    if not Result then
    begin
      if nShowMsg then
      begin
        if nStr <> '' then
          ShowMsg(nStr);
        //xxxxx

        if nParent.Controls[nIdx] is TWinControl then
          (nParent.Controls[nIdx] as TWinControl).SetFocus;
        //xxxxx
      end;

      Exit;
    end;

    if nVerifySub and (nParent.Controls[nIdx] is TWinControl) then
    begin
      Result := VerifyUIData(nParent.Controls[nIdx] as TWinControl,
        nVerify, nShowMsg);
      if not Result then Exit;      
    end;
  end;
end;

//Date: 2019-02-28
//Parm: 消息内容;标题
//Desc: 弹出消息框
procedure TFSM.ShowMsg(const nMsg: string; nTitle: string);
begin
  if nTitle = '' then
    nTitle := '提示';
  AlertManager1.Show(nTitle, nMsg, 5);
end;

//Date: 2021-03-29
//Parm: 消息;标题;窗口句柄
//Desc: 提示对话框
procedure TFSM.ShowDlg(const nMsg: string; nTitle: string; nHwnd: integer);
begin
  if nTitle = '' then
    nTitle := '提示';
  //xxxxx

  if nHwnd < 0 then
    nHwnd := GetActiveWindow;
  //xxxxx

  Messagebox(nHwnd, PChar(nMsg), PChar(nTitle), mb_Ok + Mb_IconInformation);
end;

//Date: 2021-03-29
//Parm: 消息;标题;窗口句柄
//Desc: 询问对话框
function TFSM.QueryDlg(const nMsg: string; nTitle: string; nHwnd: integer): Boolean;
begin
  if nTitle = '' then
    nTitle := '询问';
  //xxxxx

  if nHwnd < 0 then
    nHwnd := GetActiveWindow;
  //xxxxx

  Result := Messagebox(nHwnd, PChar(nMsg),
            PChar(nTitle), Mb_YesNo + MB_ICONQUESTION) = IDYes;
end;

end.
