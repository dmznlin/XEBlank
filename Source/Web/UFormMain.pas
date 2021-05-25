{*******************************************************************************
  作者: dmzn@163.com 2020-06-23
  描述: 主窗口,调度其它模块
*******************************************************************************}
unit UFormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIRegClasses, uniGUIForm, uniTreeView, uniPageControl,
  uniButton, uniBitBtn, UniFSButton, uniMultiItem, uniComboBox, uniPanel,
  uniStatusBar, uniLabel, uniImage, uniGUIBaseClasses, uniSplitter,
  UniFSConfirm, UniFSToast, Vcl.Menus, uniMainMenu;

type
  TfFormMain = class(TUniForm)
    PanelTop: TUniSimplePanel;
    ImageRight: TUniImage;
    ImageLeft: TUniImage;
    LabelHint: TUniLabel;
    StatusBar1: TUniStatusBar;
    PanelClient: TUniSimplePanel;
    PanelMenus: TUniContainerPanel;
    PanelLeftTop: TUniPanel;
    PanelLeft: TUniContainerPanel;
    EditSearch: TUniComboBox;
    BtnGetMsg: TUniFSButton;
    BtnExpand: TUniFSButton;
    BtnCollasp: TUniFSButton;
    PageWork: TUniPageControl;
    SheetWelcome: TUniTabSheet;
    SplitterLeft: TUniSplitter;
    ImageWelcome: TUniImage;
    LabelCopyRight: TUniLabel;
    FSToast1: TUniFSToast;
    FSConfirm1: TUniFSConfirm;
    PMenu1: TUniPopupMenu;
    N1: TUniMenuItem;
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormDestroy(Sender: TObject);
    procedure BtnExpandClick(Sender: TObject);
    procedure EditSearchTriggerEvent(Sender: TUniCustomComboBox;
      AButtonId: Integer);
  private
    { Private declarations }
    FMenus: TList;
    FActiveMenu: TUniTreeView;
    {*菜单数据*}
    procedure BuildSystemMenu;
    procedure BuildMenus(const nTree: TUniTreeView; const nPNode: TUniTreeNode;
      const nList: TList);
    {*构建菜单*}
    procedure OnMenuAjaxEvent(Sender: TComponent; nEvent: string;
      nParams: TUniStrings);
    procedure OnMenuMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OnMenuItemDblClick(Sender: TObject);
    {*菜单事件*}
  public
    { Public declarations }
  end;

function fFormMain: TfFormMain;

implementation

{$R *.dfm}

uses
  uniGUIVars, uniGUIApplication, MainModule, UManagerGroup, UMenuManager,
  USysBusiness, USysMenu, USysConst;

function fFormMain: TfFormMain;
begin
  Result := TfFormMain(UniMainModule.GetFormInstance(TfFormMain));
end;

procedure TfFormMain.UniFormCreate(Sender: TObject);
var nStr: string;
    nInt: Integer;
begin
  FActiveMenu := nil;
  FMenus := TList.Create;
  UniMainModule.FSToast1 := FSToast1;
  UniMainModule.FSConfirm1 := FSConfirm1;

  ImageLeft.Url := gSystem.FImages.FImgMainTL.FFile;
  ImageRight.Url := gSystem.FImages.FImgMainTR.FFile;
  LabelHint.Caption := gSystem.FMain.FActive.FDeployName;
  LabelCopyRight.Caption := gSystem.FMain.FActive.FCopyRight;

  with ImageWelcome do
  begin
    Url := gSystem.FImages.FImgWelcome.FFile;
    Width := gSystem.FImages.FImgWelcome.FWidth;
    Height := gSystem.FImages.FImgWelcome.FHeight;

    case gSystem.FImages.FImgWelcome.FPosition of
     ipTL, ipTM, ipTR: SheetWelcome.LayoutAttribs.Align := 'top';
     ipML, ipMM, ipMR: SheetWelcome.LayoutAttribs.Align := 'middle';
     ipBL, ipBM, ipBR: SheetWelcome.LayoutAttribs.Align := 'bottom';
    end;

    case gSystem.FImages.FImgWelcome.FPosition of
     ipTL, ipML, ipBL: SheetWelcome.LayoutAttribs.Pack := 'start';
     ipTM, ipMM, ipBM: SheetWelcome.LayoutAttribs.Pack := 'center';
     ipTR, ipMR, ipBR: SheetWelcome.LayoutAttribs.Pack := 'end';
    end;
  end;

  with UniMainModule,UniSession,UniApplication.ClientInfoRec do
  begin
    nStr := '※.用户:【%s】 来自:【%s】 系统:【%s,%s】 浏览器:【%s】';
    nStr := Format(nStr, [FUser.FUserName, RemoteIP, OSType, BrowserType, UserAgent]);
    StatusBar1.SimpleText := nStr;
  end;

  with TWebSystem.UserConfigFile do
  try
    nInt := ReadInteger(Name, 'PanelLeft', 200);
    if nInt < 100 then nInt := 100;
    PanelLeft.Width := nInt;
  finally
    Free;
  end;

  BuildSystemMenu;
  //构建菜单
end;

procedure TfFormMain.UniFormDestroy(Sender: TObject);
begin
  gMenuManager.ClearMenus(FMenus, True);
  with TWebSystem.UserConfigFile do
  try
    WriteInteger(Name, 'PanelLeft', PanelLeft.Width);
  finally
    Free;
  end;
end;

//Date: 2021-05-25
//Desc: 构建系统菜单
procedure TfFormMain.BuildSystemMenu;
var nStr: string;
    nIdx: Integer;
    nMenu: PMenuItem;
    nPanel: TUniPanel;
    nTree: TUniTreeView;
begin
  with gSystem.FMain,UniMainModule do
  begin
    for nIdx := Low(FPrograms) to High(FPrograms) do
    begin
      gMenuManager.GetMenus(FActive.FDeployType, FPrograms[nIdx].FProgram,
        sEntity_Main, FUser.FLangID, FMenus);
      //main menu

      gMenuManager.GetMenus(FActive.FDeployType, FPrograms[nIdx].FProgram,
        sEntity_User, FUser.FLangID, FMenus, FUser.FUserID);
      //user define menu
    end;

    for nIdx := 0 to FMenus.Count - 1 do
    begin
      nMenu := FMenus[nIdx];
      if nMenu.FType <> mtProg then Continue;

      nPanel := TUniPanel.Create(Self);
      with nPanel do
      begin
        Name := 'PanelMenu' + gMG.FSerialIDManager.GetSID;
        Parent := PanelMenus;
        Layout := 'fit';

        TitleVisible := True;
        Title := nMenu.FTitle;
        Images := SmallImages;

        if nMenu.FImgIndex < 0  then
             ImageIndex := 22
        else ImageIndex := nMenu.FImgIndex;

        nStr := 'expand=function expand(p, eOpts){ajaxRequest(%s, ''%s'', [])}';
        nStr := Format(nStr, [Self.Name + '.' + nPanel.Name, 'expand']);
        ClientEvents.ExtEvents.Add(nStr);
        //添加前端事件

        OnAjaxEvent := OnMenuAjaxEvent;
        //响应前端事件
      end;

      nTree := TUniTreeView.Create(Self);
      with nTree do
      begin
        Parent := nPanel;
        Align := alClient;
        Images := SmallImages;

        PopupMenu := PMenu1;
        OnMouseDown := OnMenuMouseDown;
        OnDblClick := OnMenuItemDblClick;

        if not Assigned(FActiveMenu) then
          FActiveMenu := nTree;
        //xxxxx
      end;

      if Assigned(nMenu.FSubItems) then
        BuildMenus(nTree, nil, nMenu.FSubItems);
      //构建菜单项
    end;
  end;
end;

//Date: 2021-05-25
//Parm: 菜单树;父节点;菜单数据
//Desc: 在nTree中构建nPNode的子菜单
procedure TfFormMain.BuildMenus(const nTree: TUniTreeView;
  const nPNode: TUniTreeNode; const nList: TList);
var nIdx: Integer;
    nMenu: PMenuItem;
    nNode: TUniTreeNode;
begin
  for nIdx := 0 to nList.Count - 1 do
  begin
    nMenu := nList[nIdx];
    nNode := nTree.Items.AddChild(nPNode, nMenu.FTitle);

    with nNode do
    begin
      Data := nMenu;
      if nMenu.FImgIndex < 0 then
      begin
        if Assigned(nMenu.FSubItems) then
             ImageIndex := 22
        else ImageIndex := 4;
      end else
      begin
        ImageIndex := nMenu.FImgIndex;
      end;

      if Assigned(nMenu.FSubItems) then
        BuildMenus(nTree, nNode, nMenu.FSubItems);
      //sub menus
    end;

    if not Assigned(nPNode) then
      nNode.Expanded := True;
    //xxxxx
  end;
end;

//Date: 2021-05-25
//Desc: 执行菜单业务
procedure TfFormMain.OnMenuItemDblClick(Sender: TObject);
var nMenu: PMenuItem;
begin
  with Sender as TUniTreeView do
  if Assigned(Selected) and (not Selected.HasChildren) then
  begin
    nMenu := Selected.Data;
    if nMenu.FType <> mtItem then Exit;
    
    UniMainModule.ShowMsg(nMenu.FMenuID);
  end;
end;

//Date: 2021-05-25
//Desc: 弹出快捷菜单
procedure TfFormMain.OnMenuMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  with Sender as TUniTreeView do
  if (Button = mbRight) and Assigned(Selected) then
    PMenu1.Popup(X, Y, Sender);
  //xxxxx
end;

//Date: 2021-05-25
//Parm: 事件;参数
//Desc: 处理菜单前端事件
procedure TfFormMain.OnMenuAjaxEvent(Sender: TComponent; nEvent: string;
  nParams: TUniStrings);
var nIdx: Integer;
begin
  if not (Sender is TUniPanel) then Exit;
  //invalid control

  with Sender as TUniPanel do
   for nIdx := ControlCount-1 downto 0 do
    if Controls[nIdx] is TUniTreeView then
    begin
      FActiveMenu := Controls[nIdx] as TUniTreeView;
      Break;
    end;
end;

//Date: 2021-05-25
//Desc: 展开or收起菜单
procedure TfFormMain.BtnExpandClick(Sender: TObject);
begin
  if not Assigned(FActiveMenu) then Exit;
  //invalid

  if Sender = BtnExpand then
       FActiveMenu.FullExpand
  else FActiveMenu.FullCollapse;
end;

//Date: 2021-05-25
//Desc: 筛选匹配的菜单项
procedure TfFormMain.EditSearchTriggerEvent(Sender: TUniCustomComboBox;
  AButtonId: Integer);
begin
  if not Assigned(FActiveMenu) then Exit;
  //invalid
end;

initialization
  RegisterAppFormClass(TfFormMain);

end.
