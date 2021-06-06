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

  sCMD_Exit    = 'ExitSystem';        //�˳�ϵͳ

  sMenuCommands: array[0..0] of string = (sCMD_Exit);
  //����ָ���б�

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
      AddM('A01', '�л�����').
      AddM('A02', '�޸�����').
      AddM('A03', '��̬����').
      AddM('A04', '�˳�ϵͳ', maExecute, sCMD_Exit).
    SetParent('B00').SetType(mtItem).                //B00
      AddM('B01', 'B01', maNewForm, 'formB01').
      AddM('B02', 'B02').
      AddM('B03', 'B03').
      AddM('B04', 'B04').
      AddM('B05', 'B05');
  //RunSoft.MAIN

  gMenuManager.AddEntity(sProg_Admin, '������', sEntity_Main, '���˵�', nList).
    SetParent('').SetType(mtItem).                   //1 level
      AddM('A00', 'ϵͳ����').
      AddM('B00', '������Ϣ').
    SetParent('A00').SetType(mtItem).
      AddM('A01', '���ݱ���').
      AddM('A02', '���ݻָ�').
      AddM('A03', '������־').
      AddM('A04', '��Ϣ����').
      AddM('A05', '��ȫ��Ȩ').
    SetParent('B00').SetType(mtItem).
      AddM('B01', 'ϵͳ����').
      AddM('B02', '��֯�ṹ').
      AddM('B03', '�û�����').
      AddM('B04', 'Ȩ�޹���').
      AddM('B05', 'ͨѶ��ַ').
      AddM('B06', 'ͨѶ��ʽ');
  //RunAdmin.MAIN
end;

initialization
  if Assigned(gMenuManager) then
    gMenuManager.AddMenuBuilder(SystemMenus);
  //���˵����ύ���˵�������
end.


