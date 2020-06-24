{*******************************************************************************
  作者: dmzn@163.com 2020-06-13
  描述: 用户登录窗口
*******************************************************************************}
unit UFormLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Forms, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore, dxSkinsDefaultPainters,
  cxControls, cxContainer, cxEdit, dxGDIPlusClasses, cxImage, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, Vcl.Controls, cxGroupBox,
  Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls, dxBevel;

type
  TfFormLogin = class(TForm)
    Bevel1: TdxBevel;
    PMenu1: TPopupMenu;
    Group1: TcxGroupBox;
    EditUser: TcxComboBox;
    EditPassword: TcxTextEdit;
    BtnLogin: TcxButton;
    LabelUser: TcxLabel;
    LabelPwd: TcxLabel;
    ImageUser: TcxImage;
    LabelCopyRight: TcxLabel;
    ImageTop: TcxImage;
    BtnSetup: TcxButton;
    MenuSkin: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure BuildSkinMenu;
    procedure OnSkinMenuClick(Sender: TObject);
    {*皮肤主题*}
  public
    { Public declarations }
  end;

var
  fFormLogin: TfFormLogin;

implementation

{$R *.dfm}
uses
  UStyleModule, USysDB;

procedure TfFormLogin.FormCreate(Sender: TObject);
begin
  ActiveControl := EditUser;
  BuildSkinMenu();
end;

//Date: 2020-06-13
//Desc: 构建主题菜单
procedure TfFormLogin.BuildSkinMenu;
var nIdx: Integer;
    nList: TStrings;
    nItem: TMenuItem;
begin
  nList := TStringList.Create;
  try
    FSM.LoadSkinNames(nList);
    for nIdx := 0 to nList.Count - 1 do
    begin
      nItem := TMenuItem.Create(PMenu1);
      MenuSkin.Add(nItem);

      nItem.Caption := nList[nIdx];
      nItem.OnClick := OnSkinMenuClick;
      nItem.RadioItem := True;

      if FSM.SkinManager.SkinName = nList[nIdx] then
        nItem.Checked := True;
      //default skin
    end;
  finally
  end;
end;

//Date: 2020-06-13
//Desc: 切换主题
procedure TfFormLogin.OnSkinMenuClick(Sender: TObject);
begin
  FSM.SwitchSkin(TMenuItem(Sender).Caption, False);
end;

end.
