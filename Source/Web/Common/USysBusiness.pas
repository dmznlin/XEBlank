{*******************************************************************************
  ����: dmzn@163.com 2020-06-23
  ����: ҵ���嵥Ԫ
*******************************************************************************}
unit USysBusiness;

{$I Link.Inc}
interface

uses
  Windows, Classes, ComCtrls, Controls, Messages, Forms, SysUtils, IniFiles,
  Data.DB, Data.Win.ADODB, Datasnap.Provider, Datasnap.DBClient,
  System.SyncObjs, Vcl.Grids, Vcl.DBGrids, Vcl.Graphics,
  //----------------------------------------------------------------------------
  uniGUIAbstractClasses, uniGUITypes, uniGUIClasses, uniGUIBaseClasses,
  uniGUISessionManager, uniGUIApplication, uniTreeView, uniGUIForm,
  uniDBGrid, uniStringGrid, uniComboBox,
  //----------------------------------------------------------------------------
  UBaseObject, UManagerGroup, ULibFun, USysDB, USysConst, USysFun, USysRemote,
  DBGrid2Excel;

implementation

var
  gSyncLock: TCriticalSection;
  //ȫ����ͬ������

//Date: 2020-06-23
//Desc: ȫ��ͬ������
procedure GlobalSyncLock;
begin
  gSyncLock.Enter;
end;

//Date: 2020-06-23
//Desc: ȫ��ͬ�������Ӵ�
procedure GlobalSyncRelease;
begin
  gSyncLock.Leave;
end;

initialization
  gSyncLock := TCriticalSection.Create;
finalization
  FreeAndNil(gSyncLock);
end.


