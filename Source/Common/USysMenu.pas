{*******************************************************************************
  ����: dmzn@163.com 2021-05-10
  ����: ϵͳ�˵�����
*******************************************************************************}
unit USysMenu;

{$I Link.inc}
interface

uses
  SysUtils, Classes, UMenuManager;

const
  sProg_Main   = 'RunSoft';           //�������ʶ
  sProg_Admin  = 'RunAdmin';          //��������ʶ
  sEntity_Main = 'MAIN';              //���˵���ʶ
  sEntity_User = 'USER';              //�û��˵���ʶ

implementation

//Desc: ϵͳ�˵���
procedure SystemMenus(const nList: TList);
begin
  gMenuManager.AddEntity(sProg_Main, '������', sEntity_Main, '���˵�', nList).
    SetParent('').SetType(mtItem).                 //1 level
      AddM('A00', 'ϵͳ').
      AddM('B00', '����').
      AddM('C00', '����').
      AddM('D00', 'ҵ��').
      AddM('E00', '����').
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

  gMenuManager.AddEntity(sProg_Admin, '������', sEntity_Main, '���˵�', nList).
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
  //���˵����ύ���˵�������
end.


