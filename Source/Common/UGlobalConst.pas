{*******************************************************************************
  ����: dmzn@ylsoft.com 2021-10-08
  ����: ��Ŀ����ģ�鹫�ó����������嵥Ԫ
*******************************************************************************}
unit UGlobalConst;

interface

uses
  SysUtils, Classes, ULibFun;

type
  TOrganizationStructure = (osGroup, osArea, osFactory, osPost);
  TOrganizationStructures = set of TOrganizationStructure;
  //��֯�ܹ�: ����,����,����,��λ

const
  sOrganizationNames: array[TOrganizationStructure] of string = ('����', '����',
    '����', '��λ');
  //��֯�ṹ����

type
  POrganizationItem = ^TOrganizationItem;
  TOrganizationItem = record
    FID     : string;                                    //��¼��ʶ
    FName   : string;                                    //��֯����
    FParent : string;                                    //�ϼ���ʶ
    FType   : TOrganizationStructure;                    //��֯����
  end;
  TOrganizationItems = TArray<TOrganizationItem>;

  POrgAddress = ^TOrgAddress;
  TOrgAddress = record
    FID       : string;                                  //��¼��ʶ
    FName     : string;                                  //����
    FPost     : string;                                  //�ʱ�
    FAddr     : string;                                  //��ַ
    FOwner    : string;                                  //ӵ����

    FValid    : Boolean;                                 //��Ч��ʶ
    FModified : Boolean;                                 //�Ķ���ʶ
    FSelected : Boolean;                                 //ѡ�б�ʶ
  end;
  TOrgAddressItems = TArray<TOrgAddress>;

  POrgContact = ^TOrgContact;
  TOrgContact = record
    FID       : string;                                  //��¼��ʶ
    FName     : string;                                  //����
    FPhone    : string;                                  //�绰
    FMail     : string;                                  //�ʼ�
    FOwner    : string;                                  //ӵ����

    FValid    : Boolean;                                 //��Ч��ʶ
    FModified : Boolean;                                 //�Ķ���ʶ
    FSelected : Boolean;                                 //ѡ�б�ʶ
  end;
  TOrgContactItems = TArray<TOrgContact>;

  TGlobalBusiness = class
  public
    class function Name2Organization(const nName: string):
      TOrganizationStructure; static;
    {*����ת��֯�ṹ����*}
  end;

implementation

//Date: 2021-10-15
//Parm: ��֯�ṹ����
//Desc: ����nName��Ӧ����֯�ṹ����
class function TGlobalBusiness.Name2Organization(
  const nName: string): TOrganizationStructure;
var nIdx: TOrganizationStructure;
begin
  for nIdx := Low(sOrganizationNames) to High(sOrganizationNames) do
   if sOrganizationNames[nIdx] = nName then
   begin
     Result := nIdx;
     Exit;
   end;

  Result := osFactory;
  //for default
end;

end.


