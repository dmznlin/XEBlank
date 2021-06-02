{*******************************************************************************
  ����: dmzn@163.com 2020-06-23
  ����: ������,��������ģ��
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
    BtnCollapse: TUniFSButton;
    PageWork: TUniPageControl;
    SheetWelcome: TUniTabSheet;
    SplitterLeft: TUniSplitter;
    ImageWelcome: TUniImage;
    LabelCopyRight: TUniLabel;
    FSToast1: TUniFSToast;
    FSConfirm1: TUniFSConfirm;
    PMenu1: TUniPopupMenu;
    MenuEdit: TUniMenuItem;
    MenuS1: TUniMenuItem;
    MenuExpand: TUniMenuItem;
    MenuCollapse: TUniMenuItem;
    MenuDel: TUniMenuItem;
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormDestroy(Sender: TObject);
    procedure BtnExpandClick(Sender: TObject);
    procedure EditSearchTriggerEvent(Sender: TUniCustomComboBox;
      AButtonId: Integer);
    procedure EditSearchChange(Sender: TObject);
    procedure MenuEditClick(Sender: TObject);
    procedure MenuDelClick(Sender: TObject);
  private
    type
      TMenuSearch = record
        FMenu: TObject;             //menu tree
        FSearch: string;            //search text
      end;
  private
    { Private declarations }
    FMenus: TList;
    FActiveMenu: TUniTreeView;
    FSearchText: array of TMenuSearch;
    {*�˵�����*}
    procedure BuildSystemMenu;
    procedure BuildMenus(const nTree: TUniTreeView; const nPNode: TUniTreeNode;
      const nList: TList);
    {*�����˵�*}
    procedure OnMenuAjaxEvent(Sender: TComponent; nEvent: string;
      nParams: TUniStrings);
    procedure OnMenuMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OnMenuItemDblClick(Sender: TObject);
    {*�˵��¼�*}
    procedure SearchMenu(nText: string);
    function SearchMenuIndex(const nMenu: TObject): Integer;
    {*�����˵���*}
  public
    { Public declarations }
  end;

function fFormMain: TfFormMain;

implementation

{$R *.dfm}

uses
  uniGUIVars, uniGUIApplication, MainModule, UManagerGroup, UMenuManager,
  UFormBase, USysBusiness, USysMenu, USysConst;

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
  SetLength(FSearchText, 0);

  UniMainModule.FSToast1 := FSToast1;
  UniMainModule.FSConfirm1 := FSConfirm1;
  LabelHint.Caption := gSystem.FMain.FActive.FDeployName;
  LabelCopyRight.Caption := gSystem.FMain.FActive.FCopyRight;

  with TWebSystem,gSystem.FImages do
  begin
    SetImageData(PanelTop, ImageLeft, @FImgMainTL);
    SetImageData(PanelTop, ImageRight, @FImgMainTR);
    SetImageData(SheetWelcome, ImageWelcome, @FImgWelcome);
  end;

  with UniMainModule,UniSession,UniApplication.ClientInfoRec do
  begin
    nStr := '��.�û�:��%s�� ����:��%s�� ϵͳ:��%s,%s�� �����:��%s��';
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
  //�����˵�
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
//Desc: ����ϵͳ�˵�
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
        //���ǰ���¼�

        OnAjaxEvent := OnMenuAjaxEvent;
        //��Ӧǰ���¼�
      end;

      nTree := TUniTreeView.Create(Self);
      with nTree do
      begin
        Parent := nPanel;
        Align := alClient;
        Images := SmallImages;
        OnMouseDown := OnMenuMouseDown;
        OnDblClick := OnMenuItemDblClick;

        if not Assigned(FActiveMenu) then
          FActiveMenu := nTree;
        //xxxxx
      end;

      if Assigned(nMenu.FSubItems) then
        BuildMenus(nTree, nil, nMenu.FSubItems);
      //�����˵���
    end;
  end;
end;

//Date: 2021-05-25
//Parm: �˵���;���ڵ�;�˵�����
//Desc: ��nTree�й���nPNode���Ӳ˵�
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
      Expanded := nMenu.FExpaned;

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
  end;
end;

//Date: 2021-05-25
//Desc: ִ�в˵�ҵ��
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
//Desc: ������ݲ˵�
procedure TfFormMain.OnMenuMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var nMenu: PMenuItem;
begin
  with Sender as TUniTreeView do
  begin
    if (Button = mbRight) and (Sender = FActiveMenu) then
    begin
      if Assigned(Selected) then
        nMenu := Selected.Data;
      //xxxxx

      MenuDel.Enabled := Assigned(Selected) and (not Selected.HasChildren) and
                         (nMenu.FUserID <> '');
      //user define menu
      MenuEdit.Enabled := Assigned(Selected);
      PMenu1.Popup(X, Y, Sender);
    end;
  end;
end;

//Date: 2021-05-25
//Parm: �¼�;����
//Desc: ����˵�ǰ���¼�
procedure TfFormMain.OnMenuAjaxEvent(Sender: TComponent; nEvent: string;
  nParams: TUniStrings);
var nIdx,nInt: Integer;
begin
  if (Sender is TUniPanel) and (nEvent = 'expand') then
  begin
    with Sender as TUniPanel do
     for nIdx := ControlCount-1 downto 0 do
      if Controls[nIdx] is TUniTreeView then
      begin
        FActiveMenu := Controls[nIdx] as TUniTreeView;
        nInt := SearchMenuIndex(FActiveMenu);
        EditSearch.Text := FSearchText[nInt].FSearch;
        Break;
      end;
  end;
end;

//Date: 2021-05-27
//Parm: �˵�����
//Desc: ����nMenu��Ӧ������
function TfFormMain.SearchMenuIndex(const nMenu: TObject): Integer;
var nIdx: Integer;
begin
  for nIdx := Low(FSearchText) to High(FSearchText) do
  if FSearchText[nIdx].FMenu = nMenu then
  begin
    Result := nIdx;
    Exit;
  end;

  Result := Length(FSearchText);
  SetLength(FSearchText, Result + 1);
  //new item

  with FSearchText[Result] do
  begin
    FMenu := nMenu;
    FSearch := '';
  end;
end;

//Date: 2021-05-27
//Parm: ����
//Desc: ��������nText�Ĳ˵�
procedure TfFormMain.SearchMenu(nText: string);
var nMenu: PMenuItem;
    nIdx,nSearch: Integer;
begin
  if not Assigned(FActiveMenu) then Exit;
  //invalid
  nSearch := SearchMenuIndex(FActiveMenu);

  with FSearchText[nSearch] do
  begin
    nText := LowerCase(Trim(nText));
    if nText = FSearch then Exit;
    FSearch := nText;

    FActiveMenu.BeginUpdate;
    try
      FActiveMenu.ResetData;
      for nIdx := FActiveMenu.Items.Count-1 downto 0 do
      begin
        nMenu := FActiveMenu.Items[nIdx].Data;
        FActiveMenu.Items[nIdx].Visible := (nText = '') or
          (Pos(nText, LowerCase(nMenu.FTitle)) > 0) or
          (Pos(nText, LowerCase(nMenu.FMenuID)) > 0) or
          (Pos(nText, LowerCase(nMenu.FActionData)) > 0);
        //visible

        if nText = '' then
             FActiveMenu.Items[nIdx].Expanded := nMenu.FExpaned
        else FActiveMenu.Items[nIdx].Expanded := True;
      end;
    finally
      FActiveMenu.EndUpdate;
    end;
  end;
end;

//Date: 2021-05-25
//Desc: չ��or����˵�
procedure TfFormMain.BtnExpandClick(Sender: TObject);
begin
  if not Assigned(FActiveMenu) then Exit;
  //invalid

  if (Sender = BtnExpand) or (Sender = MenuExpand) then
       FActiveMenu.FullExpand
  else FActiveMenu.FullCollapse;
end;

//Date: 2021-05-25
//Desc: ɸѡƥ��Ĳ˵���
procedure TfFormMain.EditSearchTriggerEvent(Sender: TUniCustomComboBox;
  AButtonId: Integer);
begin
  SearchMenu(EditSearch.Text);
end;

//Date: 2021-05-27
//Desc: �û������ɸѡ
procedure TfFormMain.EditSearchChange(Sender: TObject);
begin
  if Length(EditSearch.Text) <> 1 then
    SearchMenu(EditSearch.Text);
  //xxxxx
end;

//Date: 2021-05-27
//Desc: �༭��ǰ�˵�
procedure TfFormMain.MenuEditClick(Sender: TObject);
var nMenu: PMenuItem;
    nData: TFormCommandParam;
    nResult: TFormModalResult;
begin
  nMenu := FActiveMenu.Selected.Data;
  nData.FCommand := cCmd_EditData;
  nData.FParamP := nMenu;

  nResult := procedure(const nRes: Integer; const nParam: PFormCommandParam)
  begin
    if nRes = mrOk then
    begin
      if nMenu.FImgIndex > -1 then
        FActiveMenu.Selected.ImageIndex := nMenu.FImgIndex;
      FActiveMenu.Selected.Text := nMenu.FTitle;
    end;
  end;

  TWebSystem.ShowModalForm('TfFormEditSysMenu', @nData, nResult);
end;

//Date: 2021-06-02
//Desc: ɾ����ǰ�˵�
procedure TfFormMain.MenuDelClick(Sender: TObject);
var nMenu: PMenuItem;
begin
  nMenu := FActiveMenu.Selected.Data;
  UniMainModule.QueryDlg(Format('ȷ��Ҫɾ��[ %s ]�˵���?', [nMenu.FTitle]),
    procedure (const nType: TButtonClickType)
    begin
      if nType = ctYes then
      begin
        gMenuManager.DeleteMenu(nMenu);
        FActiveMenu.Items.Delete(FActiveMenu.Selected);
      end;
    end);
end;

initialization
  RegisterAppFormClass(TfFormMain);

end.
