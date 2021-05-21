{*******************************************************************************
  作者: dmzn@163.com 2021-05-10
  描述: 系统菜单定义
*******************************************************************************}
unit USysMenu;

{$I Link.inc}
interface

uses
  SysUtils, Classes, UMenuManager;

const
  sProg_Main   = 'RunSoft';           //主程序标识
  sProg_Admin  = 'RunAdmin';          //管理程序标识
  sEntity_Main = 'MAIN';              //主菜单标识
  sEntity_User = 'USER';              //用户菜单标识

implementation

//Desc: 系统菜单项
procedure SystemMenus(const nList: TList);
begin
  gMenuManager.AddEntity(sProg_Main, '主程序', sEntity_Main, '主菜单', nList).
    SetParent('').SetType(mtItem).                 //1 level
      AddM('A00', '系统').
      AddM('B00', '网络').
      AddM('C00', '参数').
      AddM('D00', '业务').
      AddM('E00', '帮助').
    SetParent('A00').SetType(mtItem).                //A00
      AddM('A01', 'A01').
      AddM('A02', 'A02').
      AddM('A03', 'A03').
      AddM('A04', 'A04').
      AddM('A05', 'A05').
    SetParent('B00').SetType(mtItem).                //B00
      AddM('B01', 'B01', maNewForm, 'formB01').
      AddM('B02', 'B02').
      AddM('B03', 'B03').
      AddM('B04', 'B04').
      AddM('B05', 'B05');
  //RunSoft.MAIN

  gMenuManager.AddEntity(sProg_Admin, '管理工具', sEntity_Main, '主菜单', nList).
    SetParent('').SetType(mtItem).                   //1 level
      AddM('A01', 'A01').
      AddM('A02', 'A02').
      AddM('A03', 'A03').
      AddM('A04', 'A04').
      AddM('A05', 'A05');
  //RunAdmin.MAIN
end;

initialization
  if Assigned(gMenuManager) then
    gMenuManager.AddMenuBuilder(SystemMenus);
  //将菜单项提交至菜单管理器
end.


