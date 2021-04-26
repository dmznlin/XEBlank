{*******************************************************************************
  ����: dmzn@ylsoft.com 2018-03-15
  ����: ��Ŀͨ�ó�,�������嵥Ԫ
*******************************************************************************}
unit USysConst;

interface

uses
  SysUtils, Classes, Data.DB, uniPageControl, ULibFun;

const
  cSBar_Date            = 0;                         //�����������
  cSBar_Time            = 1;                         //ʱ���������
  cSBar_User            = 2;                         //�û��������
  cRecMenuMax           = 5;                         //���ʹ�õ����������Ŀ��

  {*Command*}
  cCmd_RefreshData      = $0002;                     //ˢ������
  cCmd_ViewSysLog       = $0003;                     //ϵͳ��־

  cCmd_ModalResult      = $1001;                     //Modal����
  cCmd_FormClose        = $1002;                     //�رմ���
  cCmd_AddData          = $1003;                     //�������
  cCmd_EditData         = $1005;                     //�޸�����
  cCmd_ViewData         = $1006;                     //�鿴����
  cCmd_GetData          = $1007;                     //ѡ������

type
  TSystemImage = record
    FBgLogin    : string;                            //����:��¼����
    FBgMain     : string;                            //����:������
    FImgLogo    : string;                            //ͼƬ:��¼����Logo
    FImgKey     : string;                            //ͼƬ:��¼��������װ��
  end;

  PSystemParam = ^TSystemParam;
  TSystemParam = record
    FMain       : TApplicationHelper.TAppParam;      //�����ò���
    FImages     : TSystemImage;                      //ͼƬ��Դ����
  end;
  //ϵͳ����

  TUserParam = record
    FUserID     : string;                            //�û���ʶ
    FUserName   : string;                            //��ǰ�û�
    FUserPwd    : string;                            //�û�����
    FGroupID    : string;                            //������
    FIsAdmin    : Boolean;                           //�Ƿ����Ա

    FOSUser     : string;                            //����ϵͳ
    FUserAgent  : string;                            //���������
  end;

  TModuleItemType = (mtFrame, mtForm);
  //ģ������

  PMenuModuleItem = ^TMenuModuleItem;
  TMenuModuleItem = record
    FMenuID: string;                                 //�˵�����
    FModule: string;                                 //ģ������
    FTabSheet: TUniTabSheet;                         //����ҳ��
    FItemType: TModuleItemType;                      //ģ������
  end;

  TMenuModuleItems = array of TMenuModuleItem;       //ģ���б�

  PFormCommandParam = ^TFormCommandParam;
  TFormCommandParam = record
    FCommand: integer;                               //����
    FParamA: Variant;
    FParamB: Variant;
    FParamC: Variant;
    FParamD: Variant;
    FParamE: Variant;                                //����A-E
  end;

  TFormModalResult = reference to  procedure(const nResult: Integer;
    const nParam: PFormCommandParam = nil);
  //ģʽ�������ص�

//------------------------------------------------------------------------------
var
  gPath: string;                                     //��������·��
  gSystem: TSystemParam;                             //���򻷾�����

ResourceString
  sProgID             = 'DMZN';                      //Ĭ�ϱ�ʶ
  sAppTitle           = 'DMZN';                      //�������
  sMainCaption        = 'DMZN';                      //�����ڱ���

  sHint               = '��ʾ';                      //�Ի������
  sWarn               = '����';                      //==
  sAsk                = 'ѯ��';                      //ѯ�ʶԻ���
  sError              = '����';                      //����Ի���

  sDate               = '����:��%s��';               //����������
  sTime               = 'ʱ��:��%s��';               //������ʱ��
  sUser               = '�û�:��%s��';               //�������û�

  sLogDir             = 'Logs\';                     //��־Ŀ¼
  sLogExt             = '.log';                      //��־��չ��
  sLogField           = #9;                          //��¼�ָ���

  sImageDir           = 'Images\';                   //ͼƬĿ¼
  sReportDir          = 'Report\';                   //����Ŀ¼
  sBackupDir          = 'Backup\';                   //����Ŀ¼
  sCameraDir          = 'Camera\';                   //ץ��Ŀ¼

  sConfigFile         = 'Config.Ini';                //�������ļ�
  sConfigSec          = 'Config';                    //������С��
  sVerifyCode         = ';Verify:';                  //У������
  sFormConfig         = 'FormInfo.ini';              //��������

  sExportExt          = '.txt';                      //����Ĭ����չ��
  sExportFilter       = '�ı�(*.txt)|*.txt|�����ļ�(*.*)|*.*';
                                                     //������������ 

  sInvalidConfig      = '�����ļ���Ч���Ѿ���';    //�����ļ���Ч
  sCloseQuery         = 'ȷ��Ҫ�˳�������?';         //�������˳�

implementation

initialization

finalization

end.


