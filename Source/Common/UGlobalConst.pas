{*******************************************************************************
  ����: dmzn@ylsoft.com 2021-10-08
  ����: ��Ŀ����ģ�鹫�ó����������嵥Ԫ
*******************************************************************************}
unit UGlobalConst;

interface

uses
  SysUtils, Classes, ULibFun;

const
  sOrganizationNames: array[TApplicationHelper.TOrganizationStructure] of
    string = ('����', '����', '����');
  //��֯�ṹ����

type
  POrganizationItem = ^TOrganizationItem;
  TOrganizationItem = record
    FID     : string;                                    //��¼��ʶ
    FName   : string;                                    //��֯����
    FParent : string;                                    //�ϼ���ʶ
    FType   : TApplicationHelper.TOrganizationStructure; //��֯����
  end;
  TOrganizationItems = TArray<TOrganizationItem>;

implementation

end.


