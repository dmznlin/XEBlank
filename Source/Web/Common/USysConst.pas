{*******************************************************************************
  ����: dmzn@ylsoft.com 2018-03-15
  ����: ��Ŀͨ�ó�,�������嵥Ԫ
*******************************************************************************}
unit USysConst;

interface

uses
  SysUtils, Classes, Data.DB, uniPageControl, ULibFun;

const
  {*Command*}
  cCmd_RefreshData      = $0002;                     //ˢ������
  cCmd_ViewSysLog       = $0003;                     //ϵͳ��־

  cCmd_ModalResult      = $1001;                     //Modal����
  cCmd_FormClose        = $1002;                     //�رմ���
  cCmd_AddData          = $1003;                     //�������
  cCmd_EditData         = $1005;                     //�޸�����
  cCmd_DeleteData       = $1004;                     //ɾ������
  cCmd_ViewData         = $1006;                     //�鿴����
  cCmd_GetData          = $1007;                     //ѡ������
  cCmd_EditFile         = $1008;                     //�༭�ļ�
  cCmd_ViewFile         = $1009;                     //�鿴�ļ�

type
  TImagePosition = (ipDefault, ipTL, ipTM, ipTR,
                               ipML, ipMM, ipMR,
                               ipBL, ipBM, ipBR);
  //ͼƬλ��: Top,Left,Middle,Right,Bottom

  PImageData = ^TImageData;
  TImageData = record
    FFile       : string;                            //ͼƬ·��
    FWidth      : Integer;                           //ͼƬ���
    FHeight     : Integer;                           //ͼƬ�߶�
    FPosition   : TImagePosition;                    //ͼƬλ��
  end;

  TSystemImage = record
    FBgLogin    : TImageData;                        //����:��¼����
    FBgMain     : TImageData;                        //����:������
    FImgLogo    : TImageData;                        //ͼƬ:��¼����Logo
    FImgKey     : TImageData;                        //ͼƬ:��¼��������װ��
    FImgMainTL  : TImageData;                        //ͼƬ:������Top-Left
    FImgMainTR  : TImageData;                        //ͼƬ:������Top-Right
    FImgWelcome : TImageData;                        //ͼƬ:�����ڻ�ӭ
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
  sLocalDir           = 'Local\';                    //��������
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


