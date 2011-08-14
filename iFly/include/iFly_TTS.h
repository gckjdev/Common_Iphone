/**
 * @file    iFly_TTS.h
 * @brief   iFLY TTS SDK header file
 * 
 * This file contains the TTS application programming interface(API) declarations 
 * of iFLYTEK. TTS developer can include this file in your project to build applications.
 * For more information, please read the developer guide.
 * Copyright (C)    1999 - 2004 by ANHUI USTC IFLYTEK. Co.,LTD.
 *                  All rights reserved.
 * 
 * @author  Speech Dept. iFLYTEK.
 * @version 1.2
 * @date    2000/10/21
 * 
 * @see        
 * 
 * Histroy:
 * index    version        date            author        notes
 * 0        1.1            2000/10/21      jdyu          Create this file
 * 1        1.1            2001/02/16      Yan Jun       Add more comments, modify VID macros
 * 2        1.1            2002/05/10      jdyu          Modify TTSLoadUserLib function
 * 3        1.1            2002/08/30      Gao Yi        Add macros to read number and english
 * 4        1.1            2003/11/13      wbli          Remove unicode char definition(No support)
 * 5        1.2            2004/05/20      Jet           Add new functions
 */

#ifndef IFLY_TTS_H
#define IFLY_TTS_H

#include "TTSErrcode.h"

#ifdef __cplusplus
extern "C" {
#endif

#ifndef IFLYTTS

#if defined(WIN32)
# if defined(IFLYTTS_EXPORTS)
#  define TTSLIBAPI __declspec(dllexport)
# elif defined(IFLYTTS_IMPORTS)
#  define TTSLIBAPI __declspec(dllimport)
# else
#  define TTSLIBAPI
# endif
#else /* defined(WIN32) */
# define TTSLIBAPI
#endif /* defined(WIN32) */

/*
 * Basic Data Types
 */

/* Integer types */
typedef long int            TTSINT32;
typedef short               TTSINT16;

/* Handles */
typedef void*               HTTSINSTANCE;
typedef TTSINT32            HTTSUSERLIB;

/* Char type */
typedef char                TTSCHAR;
typedef char*               PTTSCHAR;

/* Cardinal types */
#define TTSVOID             void
#define PTTSVOID            void*

typedef unsigned char       TTSUNS8;
typedef unsigned long int   TTSUNS32;
typedef unsigned short      TTSU16;
typedef float               TTSFLOAT;
typedef unsigned long       TTSDWORD;
typedef unsigned short      TTSWORD;

/* Boolean */
typedef unsigned int        TTSBOOL;

#ifndef TRUE
#define TRUE                1
#endif
#ifndef FALSE
#define FALSE               0
#endif

/* TTS Return value type */
typedef TTSINT32            TTSRETVAL;

#endif /* #ifndef IFLYTTS*/

/* iFly-TTS SDK Version */
#define IFLYTTS_SDK_VER     0x0101
/* Reserved Length */
#define TTS_RESERVED_LEN    0x000E

/* 
 *    TTS common defines
 */
#define TTS_CONNECT_STRUCT_VERSION        0x0100
#define TTS_SERVICE_UID_MAX               60
#define TTS_USER_NAME_MAX                 20
#define TTS_COMPANY_NAME_MAX              28
#define TTS_SERIAL_NO_MAX                 24
#define TTS_CONNECT_STR_MAX               128
#define TTS_PRODUCT_NAME_MAX              20
#define TTS_IP_MAXLEN                     32

/* Use TTS default configurations */

/* Synthesizing process flags */
enum
{
    TTS_FLAG_STILL_HAVE_DATA        =    1,
    TTS_FLAG_DATA_END               =    2,
    TTS_FLAG_CMD_CANCELED           =    4,
};

/* Language ID */
enum
{
    TTS_LANG_UND                    =    0x0000,        /* Undefined */
    TTS_LANG_ZHO                    =    0x0804,        /* Chinese (PRC) */
    TTS_LANG_ZHO_CAN                =    0x0C04,        /* Chinese (Hong Kong SAR, PRC) */
    TTS_LANG_ENG_USA                =    0x0409,        /* English (United States) */
    TTS_LANG_ENG_UK                 =    0x0809,        /* English (United Kingdom) */
    TTS_LANG_FRA                    =    0x040C,        /* French (Standard) */
    TTS_LANG_DEU                    =    0x0407,        /* German (Standard) */
    TTS_LANG_JPN                    =    0x0411,        /* Japanese */
    TTS_LANG_KOR                    =    0x0412,        /* Korean */
    TTS_LANG_RUS                    =    0x0419,        /* Russian */
    TTS_LANG_ITA                    =    0x0410,        /* Italian (Standard) */
    TTS_LANG_SPA                    =    0x040a,        /* Spanish (Spain, Traditional Sort) */
    TTS_LANG_BAQ                    =    0x042d,        /* Basque*/
    TTS_LANG_DAN                    =    0x0406,        /* Danish */
    TTS_LANG_DUT_NLD                =    0x0413,        /* Dutch (Netherlands) */
    TTS_LANG_DUT_BLM                =    0x0813,        /* Dutch (Belgium) */
    TTS_LANG_ENG_AUS                =    0x0c09,        /* English (Australian) */
    TTS_LANG_ENG_IRE                =    0x1809,        /* English (Ireland) */
    TTS_LANG_FRA_CAN                =    0x0c0c,        /* French (Canadian) */
    TTS_LANG_GRE                    =    0x0408,        /* Greek */
    TTS_LANG_NOR                    =    0x0414,        /* Norwegian (Bokmal) */
    TTS_LANG_POL                    =    0x0415,        /* Polish */ 
    TTS_LANG_POR                    =    0x0816,        /* Portuguese (Portugal) */
    TTS_LANG_POR_BRA                =    0x0416,        /* Portuguese (Brazil) */
    TTS_LANG_SPA_MX                 =    0x080a,        /* Spanish (Mexican) */
    TTS_LANG_SWE                    =    0x041d,        /* Swedish */

};

/* Chinese code page type */
enum
{
    TTS_CP_AUTO                     =    0,
    TTS_CP_GB2312                   =    1,
    TTS_CP_GBK                      =    2,
    TTS_CP_BIG5                     =    3,
    TTS_CP_UNICODE                  =    4,
    TTS_CP_GB18030                  =    5,
    TTS_CP_UTF8                     =    6,
};

/* Pause and transition in melody */
enum
{
    TTS_SSL_NORMAL                  =    0,    /* Normal */
    TTS_SSL_STALL                   =    1,    /* A little stall */
    TTS_SSL_SNATCHY                 =    2,    /* Evident snatchy */
    TTS_SSL_UNCEASING               =    3,    /* Unceasing */
    TTS_SSL_VERBOSE                 =    4,    /* Verbose */
};

/* Output audio data formats */
enum
{
    TTS_ADF_DEFAULT                 =    0,
    TTS_ADF_PCM8K8B1C               =    1,
    TTS_ADF_PCM16K8B1C              =    2,
    TTS_ADF_PCM8K16B1C              =    3,
    TTS_ADF_PCM16K16B1C             =    4,
    TTS_ADF_PCM11K8B1C              =    5,
    TTS_ADF_PCM11K16B1C             =    6,
    TTS_ADF_PCM6K8B1C               =    7,
    TTS_ADF_PCM6K16B1C              =    8,
    TTS_ADF_ALAW16K1C               =    9,
    TTS_ADF_ULAW16K1C               =    10,
    TTS_ADF_ALAW8K1C                =    11,
    TTS_ADF_ULAW8K1C                =    12,
    TTS_ADF_ALAW11K1C               =    13,
    TTS_ADF_ULAW11K1C               =    14,
    TTS_ADF_ALAW6K1C                =    15,
    TTS_ADF_ULAW6K1C                =    16,
    TTS_ADF_ADPCMG7218K4B1C         =    17,
    TTS_ADF_ADPCMG7216K4B1C         =    18,
    TTS_ADF_ADPCMG7233B1C           =    19,
    TTS_ADF_ADPCMG7235B1C           =    20,
    TTS_ADF_VOX6K1C                 =    21,
    TTS_ADF_VOX8K1C                 =    22,
    TTS_ADF_AMR6K1C                 =    23,
    TTS_ADF_AMR8K1C                 =    24,
    TTS_ADF_AMR11K1C                =    25,
    TTS_ADF_AMR16K1C                =    26,
    TTS_ADF_MP36K1C                 =    27,
    TTS_ADF_MP38K1C                 =    28,
    TTS_ADF_MP311K1C                =    29,
    TTS_ADF_MP316K1C                =    30,
};

/* Audio data head type */
enum
{
    TTS_AHF_DEFAULT                 =    0,    /* Audio data head has 44 byte */
    TTS_AHF_NONE                    =    1,    /* No audio data head */
    TTS_AHF_STAND                   =    2,    /* Standard audio data head */
};

/* These macros are used when setting/getting TTS_PARAM_ENTERTREAT */
enum
{
    TTS_ET_AUTO                     =    0,    /* Automatically treat <enter> char(s) */
    TTS_ET_SPLITSEN                 =    1,    /* When meeting <enter> char(s), split sentence */
    TTS_ET_NOTHING                  =    2,    /* Treat <enter> char(s) as noting */
    TTS_ET_SPACE                    =    3,    /* Treat <enter> char(s) as space char */
};

/* These macros are used when setting/getting TTS_PARM_AVAILABLEVID */
enum
{
    TTS_AVID_MAXAVAVIDCOUNT         =    30,   /* Max available VID count */
};

/* These macros are used when setting/getting TTS_PARM_READNUMBER */
enum
{
    TTS_RN_AUTO_VALUE               =    0,    /* Auto, read as value if not sure */
    TTS_RN_VALUE                    =    1,    /* Read as value */
    TTS_RN_DIGIT                    =    2,    /* Read as string */
    TTS_RN_AUTO_DIGIT               =    3,    /* Auto, read as string if not sure */
};

/* These macros are used when setting/getting TTS_PARM_READENGLISH */
enum
{
    TTS_RE_AUTO_WORD                =    0,    /* Auto, read as word if not sure */
    TTS_RE_LETTER                   =    1,    /* Read as letter */
    TTS_RE_AUTO_LETTER              =    2,    /* Auto, read as letter if not sure */
};

/* These macros are used when setting/getting TTS_PARAM_TEXTTYPE */
enum
{
    TTS_TT_AUTO                     =    0,    /* auto, read as plain text if not sure */
    TTS_TT_PLAINTEXT                =    1,    /* read as plain text */
    TTS_TT_CSSMLTEXT                =    2,    /* read as CSSML text */
    TTS_TT_SSMLTEXT                 =    3,    /* read as SSML text */
    TTS_TT_EMAILTEXT                =    4,    /* read as EMail text */
};

/* audio data and its head byte-order when TTS_PARAM_BYTEORDER */
enum
{
    TTS_BO_DEFAULT                  =    0,    /* default same as host */
    TTS_BO_LITTLEENDIAN             =    1,    /* Intel x86 */
    TTS_BO_BIGENDIAN                =    2,    /* Sun/Macintosh */
};

/* These macros are used when setting/getting TTS_PARAM_VPTTREAT */
enum
{
    TTS_VPT_DISABLE                 =    0,    /* Disable replacing matching sentence with prompt voice */
    TTS_VPT_ENABLE                  =    1,    /* Replace matching sentence with prompt voice */
};

/* These macros are used when setting/getting TTS_SYNTHURL */
enum
{
    TTS_URL_NORMAL                  =    0,    /* Processing the URL as normal string */
    TTS_URL_SYNTH                   =    1,    /* Retrieving the URL target and synthesizing it */
};

/* About type */
enum
{
    TTS_ABOUT_PRODUCTINFO           =    0,    /* Information about TTS kernel product */
};

/* Sound Effect Value */
enum
{
    TTS_SNDEFFECT_NONE              =    0,    /* none sndeffect */
    TTS_SNDEFFECT_AMPLIFY           =    1,    /* amplify sndeffect */
    TTS_SNDEFFECT_ECHO              =    2,    /* echo sndeffect */
    TTS_SNDEFFECT_UNDERWATER        =    3,    /* underwater sndeffect */
    TTS_SNDEFFECT_REVERB            =    4,    /* reverb sndeffect */
    TTS_SNDEFFECT_CHORUS            =    5,    /* chorus sndeffect */
};

/* Synth Mode Value */
enum
{
    TTS_SYNMOD_NORMAL               =    0,    /* normal synth mode */
    TTS_SYNMOD_DSS,                            /* dss mode, it's dss client */
    TTS_SYNMOD_DSSSVR,                         /* dss mode, it's dss server */
};

/* Phrase bundle style */
enum
{
    TTS_PHRASE_NORMAL                =    0,   /* normal phrase bundle */
    TTS_PHRASE_SLOW,                           /* slow phrase bundle */
};

/* Digit bundle style */
enum
{
    TTS_DIGIT_NORMAL                =    0,    /* normal digit bundle */
    TTS_DIGIT_SLOW,                            /* slow digit bundle */
};

/* Mood Value */
enum
{
    TTS_MOOD_AUTO                    =    0,   /* auto, read with no mood if not sure */    
    TTS_MOOD_STATEMENT,                        /* statement */
    TTS_MOOD_ENQUIRY,                          /* enquiry */
    TTS_MOOD_EXCLAMATION,                      /* exclamation */
};

/* Emotion Value */
enum
{
    TTS_EMOTION_NEUTRAL                =    0, /* normal emotion */
    TTS_EMOTION_HAPPY,                         /* happy */
    TTS_EMOTION_SAD,                           /* sad */
};

/* TTS parameters category base */
#define TTS_PARAM_LOCAL_BASE        0x0000
#define TTS_PARAM_SERVER_BASE       0x0100
#define TTS_PARAM_CLIENT_BASE       0x0200

/**
 * @brief    TTS parameters used by Set/Get TTS parameter
 */
enum
{
    /* Get maximum buffer size (in bytes) for storing input text data */
    TTS_PARAM_INBUFSIZE             =    (TTS_PARAM_LOCAL_BASE + 1),
    /* Get/Set maximum buffer size (in bytes) for storing output audio data */
    TTS_PARAM_OUTBUFSIZE            =    (TTS_PARAM_LOCAL_BASE + 2),
    /* Get/Set current voice library format ID */
    TTS_PARAM_VID                   =    (TTS_PARAM_LOCAL_BASE + 3),
    /* Get/Set current Chinese code page type */
    TTS_PARAM_CODEPAGE              =    (TTS_PARAM_LOCAL_BASE + 4),
    /* Get/Set current audio data format */
    TTS_PARAM_AUDIODATAFMT          =    (TTS_PARAM_LOCAL_BASE + 5),
    /* Get/Set current speed value */
    TTS_PARAM_SPEED                 =    (TTS_PARAM_LOCAL_BASE + 6),
    /* Get/Set current audio data head type */
    TTS_PARAM_AUDIOHEADFMT          =    (TTS_PARAM_LOCAL_BASE + 7),
    /* Get/Set current volume value of audio data */
    TTS_PARAM_VOLUME                =    (TTS_PARAM_LOCAL_BASE + 8),
    /* Get/Set current pitch value of audio data */
    TTS_PARAM_PITCH                 =    (TTS_PARAM_LOCAL_BASE + 9),
    /* Set/Get treatment of <enter> char(s) when split sentence */
    TTS_PARAM_ENTERTREAT            =    (TTS_PARAM_LOCAL_BASE + 10),
    /* Set/Get max length of the split sentence (default is 128 chars, cannot less than 10) */
    TTS_PARAM_MAXSENLEN             =    (TTS_PARAM_LOCAL_BASE + 11),
    /* Get current available voice library list */
    TTS_PARAM_AVAILABLEVID          =    (TTS_PARAM_LOCAL_BASE + 12),
    /* Get/Set whether to read all marks or not */
    TTS_PARAM_READALLMARKS          =    (TTS_PARAM_LOCAL_BASE + 13),
    /* Get/Set pause and transition in melody */
    TTS_PARAM_STALL_STYLE           =    (TTS_PARAM_LOCAL_BASE + 14),
    /* Get/Set How to pronounce number, value or digit */
    TTS_PARAM_READNUMBER            =    (TTS_PARAM_LOCAL_BASE + 15),
    /* Get/Set How to pronounce English, letter or word */
    TTS_PARAM_READENGLISH           =    (TTS_PARAM_LOCAL_BASE + 16),
    /* Get/Set default text type */
    TTS_PARAM_TEXTTYPE              =    (TTS_PARAM_LOCAL_BASE + 17),
    /* Get/Set byte-order */
    TTS_PARAM_BYTEORDER             =    (TTS_PARAM_LOCAL_BASE + 18),
    /* Get/Set Prompt voice treat, only supported by InterPhonic CE 3.0 or later */
    TTS_PARAM_VPTTREAT              =    (TTS_PARAM_LOCAL_BASE + 19),
    /* Get/Set background sound id, only supported by InterPhonic CE 3.0 or later */
    TTS_PARAM_BGSOUND               =    (TTS_PARAM_LOCAL_BASE + 20),
    /* Get/Set mode of processing URL in text, requiring InterPhonic 4.0 or later */
    TTS_PARAM_SYNTHURL              =    (TTS_PARAM_LOCAL_BASE + 21),
    /* Get/Set mode of sound effect, requiring InterPhonic 5.0 or later */
    TTS_PARAM_SNDEFFECT             =    (TTS_PARAM_LOCAL_BASE + 25),
    /* Get/Set mode of synth, requiring InterPhonic 5.5 or later */
    TTS_PARAM_SYNTHMODE             =    (TTS_PARAM_LOCAL_BASE + 26),
    /* Get/Set mode of mood, only supported by ViviVoice2.0 or later */
    TTS_PARAM_MOOD                  =    (TTS_PARAM_LOCAL_BASE + 27),
    /* Get/Set mode of emotion, only supported by ViviVoice2.0 or later */
    TTS_PARAM_EMOTION               =    (TTS_PARAM_LOCAL_BASE + 28),
    /* Get/Set bundle style of phrase, normal or slow */
    TTS_PARAM_PHRASE_STYLE          =    (TTS_PARAM_LOCAL_BASE + 29),
    /* Get/Set bundle style of digit, normal or slow */
    TTS_PARAM_DIGIT_STYLE           =    (TTS_PARAM_LOCAL_BASE + 30),

	TTS_PARAM_VID_INFO				=	 (TTS_PARAM_LOCAL_BASE + 31),
    

    /* Parameters used in network only */

    /* Set/Get current network send timeout */
    TTS_PARAM_SERVER_SNDTO          =    (TTS_PARAM_SERVER_BASE + 1),
    /* Set/Get current network receive timeout */
    TTS_PARAM_SERVER_RCVTO          =    (TTS_PARAM_SERVER_BASE + 2),
    /* Set/Get current network idle timeout */
    TTS_PARAM_SERVER_IDLETO         =    (TTS_PARAM_SERVER_BASE + 3),
    /* Get current network active connection count */
    TTS_PARAM_SERVER_ACTCNT         =    (TTS_PARAM_SERVER_BASE + 4),
    /* Get current network maximum connection count */
    TTS_PARAM_SERVER_MAXCNT         =    (TTS_PARAM_SERVER_BASE + 5),
    /* Set/get net connect timeout */
    TTS_PARAM_SERVER_CNTTO          =    (TTS_PARAM_SERVER_BASE + 6),

    /* Set/Get current client send timeout */
    TTS_PARAM_CLIENT_SNDTO          =    (TTS_PARAM_CLIENT_BASE + 1),
    /* Set/Get current client receive timeout */
    TTS_PARAM_CLIENT_RCVTO          =    (TTS_PARAM_CLIENT_BASE + 2),
};

/*
 * TTS Data Structures
 */

#pragma pack(2)

/** 
 * @class    TTSConnectStruct
 * @brief    The connection information structure used by TTSConnect
 * This structure used by client in TTSConnect function.
 */
typedef struct tagTTSConnectStruct
{
    TTSDWORD     dwSDKVersion;                           /* [in]  The client TTS SDK version */
    TTSCHAR      szUserName[TTS_USER_NAME_MAX];          /* [in]  User name */
    TTSCHAR      szCompanyName[TTS_COMPANY_NAME_MAX];    /* [in]  Company name */
    TTSCHAR      szSerialNumber[TTS_SERIAL_NO_MAX];      /* [in]  Serial Number has form as "xxxxxx-xxxxxx-xxxxxx" */
    PTTSVOID     pfnConnectCB;                           /* [in]  Callback function to asynchronous TTSConnect, see TTSCONNECTCB */
    PTTSVOID     pfnDisconnectCB;                        /* [in]  Callback function to asynchronous TTSDisconnect, see TTSCONNECTCB */
    TTSDWORD     dwUserData;                             /* [in]  User defined data to connect/disconnect callback function */
    TTSCHAR      szConnectStr[TTS_CONNECT_STR_MAX];      /* [in]  Connect string to specify instance feature, format as: */
                                                         /*       [4=3 6=1 17=2 ...] */
    TTSCHAR      szServiceUID[TTS_SERVICE_UID_MAX];      /* [in]  TTS Service sign, format as: */
                                                         /*       [ename="intp40/ce30/..." QoS="high/normal/low"] or [lang="0x804" QoS="..."] */
    TTSCHAR      szProductName[TTS_PRODUCT_NAME_MAX];    /* [in]  Client program name */
    TTSCHAR      szTTSServerIP[TTS_IP_MAXLEN];           /* [in]  The IP address of TTS Server */
    TTSDWORD     dwServiceID;                            /* [out] TTS service ID return by Service Module */
    TTSDWORD     dwErrorCode;                            /* [out] The error code return by Service Module */
    TTSBOOL      bSetParams;                             /* [in]  Determine whether the following setting is valid or not */
    TTSINT16     nCodePage;                              /* [in]  Default codepage type */
    TTSINT16     nVID;                                   /* [in]  Default TTS voice lib */
    TTSINT16     nAudioFmt;                              /* [in]  Default audio data format */
    TTSINT16     nSpeed;                                 /* [in]  Default speed */
    TTSINT16     nVolume;                                /* [in]  Default volume */
    TTSINT16     nPitch;                                 /* [in]  Default pitch */
    TTSINT16     nAudioHeadFmt;                          /* [in]  Default audio head fmt */
    TTSINT16     nTextType;                              /* [in]  Default text type */
    TTSDWORD     dwReserved[TTS_RESERVED_LEN];           /* [in/out] Reserved field, set it to zero */
} TTSConnectStruct, *PTTSConnectStruct;

/** 
 * @class    TTSData
 * @brief    TTSData structure
 * The structure used in synthesizing process
 */
typedef struct tagTTSData
{
    TTSDWORD    dwServiceID;    /* [in]  Connect's service ID */
    TTSDWORD    dwInBufSize;    /* [in]  Text buffer size */
    TTSDWORD    dwOutBufSize;   /* [out] Output audio data length */
    TTSDWORD    dwInFlags;      /* [in]  Input data flag */
    TTSDWORD    dwOutFlags;     /* [out] Output data flag */
    TTSWORD     wAudioHeadLen;  /* [out] Output audio data head length */
#ifndef WIN32
    TTSWORD     wReserved;      /* [in/out] Reserved for alignment */
#endif
    TTSDWORD    dwCurStart;     /* [out] The start position of current synthesizing text in szInBuf */
    TTSDWORD    dwCurEnd;       /* [out] The end position of current synthesizing text in szInBuf */
    TTSDWORD    dwErrorCode ;   /* [out] The error code returned by service module */

    TTSCHAR     *szInBuf;       /* [in]  Input text buffer pointer, allocated by caller */
    PTTSVOID    pOutBuf;        /* [out] Output audio data pointer, allocated by TTS service module */
    PTTSCHAR    pszPYBuf;       /* [out] Output PinYin string buf,  allocated by TTS service mudule */

    TTSDWORD    dwReserved;     /* [in/out] Reserved field */
} TTSData, *PTTSData;

/**
 * TTS Event ID define
 */
enum
{
    TTS_EVENT_NULL            =    0,   /* NULL event */
    TTS_EVENT_MARK            =    1,   /* Book mark event id */
};

/**
 * The prototype of callback functions used in synthesizing process
 */

/* Connect and Disconnect callback */
typedef TTSRETVAL (*TTSCONNECTCB)(HTTSINSTANCE hTTSInst, PTTSConnectStruct pConnect, TTSINT32 lParam, TTSDWORD dwUserData);

/* Synthesize data process callback */
typedef TTSRETVAL (*TTSPROCESSCB)(HTTSINSTANCE hTTSInst, PTTSData pTTSData, TTSINT32 lParam, PTTSVOID pUserData);

/* Synthesize events callback */
typedef TTSRETVAL (*TTSEVENTCB)  (HTTSINSTANCE hTTSInst, PTTSData pTTSData, TTSINT16 nNotify, TTSINT32 lParam, PTTSVOID pUserData);

/* Callback data structure */
typedef struct tagTTSCallBacks
{
    TTSINT32        nNumCallbacks;      /* [in] Number of callback functions */
    TTSPROCESSCB    pfnTTSProcessCB;    /* [in] Synthesizing process callback function */
    TTSEVENTCB      pfnTTSEventCB;      /* [in] Event notifies in synthesizing process */
} TTSCallBacks, *PTTSCallBacks;

#pragma pack()

/*==========================================================================
    Declaration of Interface Functions
 ==========================================================================*/

/** 
 * @brief   TTSInitializeEx
 * 
 * Global initialize TTS system, it is the first function to be called.
 * 
 * @author  iFLYTEK
 * @return  TTSRETVAL TTSLIBAPI    - Return 0 in success, otherwise return error code.
 * @param   const char* pszEngine  - [in] The engine name or path to initialize
 * @param   void* pvReserved       - [in,out] Reserved, must be NULL
 * @see     
 */
TTSRETVAL TTSLIBAPI TTSInitializeEx(const char* pszEngine, void* pvReserved);
typedef TTSRETVAL (*Proc_TTSInitializeEx)(const char* pszEngine, void* pvReserved);

/** 
 * @brief   TTSUninitialize
 * 
 * Global uninitialize TTS, it is the last function to be called
 * 
 * @author  iFLYTEK
 * @return  TTSRETVAL - Return 0 in success, otherwise return error code.
 * @see     
 */
TTSRETVAL TTSLIBAPI TTSUninitialize();
typedef TTSRETVAL (*Proc_TTSUninitialize)();

/** 
 * @brief   TTSConnect
 * 
 * TTSConnect create a instance to TTS Core service, and return the instance handle
 *
 * @author  iFLYTEK
 * @return  HTTSINSTANCE - Return a handle to the TTS Instance, otherwise return NULL.
 * @param   PTTSConnectStruct pConnect - [in,out] The connect structure pointer
 * @see     
 */
HTTSINSTANCE TTSLIBAPI TTSConnect(PTTSConnectStruct pConnect);
typedef HTTSINSTANCE (*Proc_TTSConnect)(PTTSConnectStruct pConnect);

/** 
 * @brief   TTSDisconnect
 * 
 * TTSDiconnect destroy the connected instance created by TTSConnect
 * 
 * @author  iFLYTEK
 * @return  TTSRETVAL - Return 0 in success, otherwise return error code.
 * @param   HTTSINSTANCE hTTSInst    - [in] The TTS handle returned by TTSConnect function
 * @see     
 */
TTSRETVAL TTSLIBAPI TTSDisconnect(HTTSINSTANCE hTTSInst);
typedef TTSRETVAL (*Proc_TTSDisconnect)(HTTSINSTANCE hTTSInst);

/** 
 * @brief   TTSSynthText
 * 
 * Begin synthesize text, send text to engine
 * 
 * @author  iFLYTEK
 * @return  TTSRETVAL - Return 0 in success, otherwise return error code.
 * @param   HTTSINSTANCE hTTSInst    - [in] The instance handle returned by TTSConnect function
 * @param   PTTSData pTTSData        - [in,out] Pointer to TTSData structure
 * @see     TTSSynthTextEx
 */
TTSRETVAL TTSLIBAPI TTSSynthText(HTTSINSTANCE hTTSInst, PTTSData pTTSData);
typedef TTSRETVAL (*Proc_TTSSynthText)(HTTSINSTANCE hTTSInst, PTTSData pTTSData);

/** 
 * @brief   TTSFetchNext
 * 
 * Fetch the remains audio data clip until OutFlag is TTS_DATA_FLAG_END
 * 
 * @author  iFLYTEK
 * @return  TTSRETVAL - Return 0 in success, otherwise return error code.
 * @param   HTTSINSTANCE hTTSInst    - [in] The instance handle returned by TTSConnect function
 * @param   PTTSData pTTSData        - [in,out] Pointer to TTSData structure
 * @see     TTSData
 */
TTSRETVAL TTSLIBAPI TTSFetchNext(HTTSINSTANCE hTTSInst, PTTSData pTTSData);
typedef TTSRETVAL (*Proc_TTSFetchNext)(HTTSINSTANCE hTTSInst, PTTSData pTTSData);

/** 
 * @brief   TTSSynthTextEx
 * 
 * Begin synthesize text in synchronous or asynchronous callback mode
 * 
 * @author  iFLYTEK
 * @return  TTSRETVAL - Return 0 in success, otherwise return error code.
 * @param   HTTSINSTANCE hTTSInst        - [in] The instance handle returned by TTSConnect function
 * @param   PTTSData pTTSData            - [in,out] Pointer to TTSData structure
 * @param   PTTSCallBacks pTTSCallBacks  - [in] Pointer to TTSCallbacks structure
 * @param   TTSBOOL bASynch              - [in] The mode is asynchronous or not
 * @param   PTTSVOID pUserData           - [in] User defined data, will send to the callback function
 * @see     TTSSynthText, TTSCallBacks
 */
TTSRETVAL TTSLIBAPI TTSSynthTextEx(HTTSINSTANCE hTTSInst, PTTSData pTTSData, PTTSCallBacks pTTSCallBacks, TTSBOOL bASynch, PTTSVOID pUserData);
typedef TTSRETVAL (*Proc_TTSSynthTextEx)(HTTSINSTANCE hTTSInst, PTTSData pTTSData, PTTSCallBacks pTTSCallBacks, TTSBOOL bASynch, PTTSVOID pUserData);

/** 
 * @brief   TTSSynthText2File
 * 
 * Synthesize text to audio file. If the file exists, this function will append audio data to the wave file.
 * 
 * @author  iFLYTEK
 * @return  TTSRETVAL - Return 0 in success, otherwise return error code.
 * @param   HTTSINSTANCE hTTSInst        - [in] The instance handle returned by TTSConnect function
 * @param   PTTSData pTTSData            - [in,out] Pointer to TTSData structure
 * @param   const char* pszOutFile       - [in] Output file full path name
 * @param   PTTSCallBacks pTTSCallBacks  - [in] Pointer to TTSCallbacks structure
 * @param   TTSBOOL bASynch              - [in] The mode is asynchronous or not
 * @param   PTTSVOID pUserData           - [in] User defined data, will send to the callback function
 * @see     TTSSynthTextEx
 */
TTSRETVAL TTSLIBAPI TTSSynthText2File(HTTSINSTANCE hTTSInst, PTTSData pTTSData, const char* pszOutFile, PTTSCallBacks pTTSCallBacks, TTSBOOL bASynch, PTTSVOID pUserData);
typedef TTSRETVAL (*Proc_TTSSynthText2File)(HTTSINSTANCE hTTSInst, PTTSData pTTSData, const char* pszOutFile, PTTSCallBacks pTTSCallBacks, TTSBOOL bASynch, PTTSVOID pUserData);

/** 
 * @brief   TTSClean
 * 
 * Reset the TTS status to initial status, free memory allocated in synthesizing process
 * 
 * @author  iFLYTEK
 * @return  TTSRETVAL - Return 0 in success, otherwise return error code.
 * @param   HTTSINSTANCE hTTSInst   - [in] The instance handle returned by TTSConnect function
 * @see     
 */
TTSRETVAL TTSLIBAPI TTSClean(HTTSINSTANCE hTTSInst);
typedef TTSRETVAL (*Proc_TTSClean)(HTTSINSTANCE hTTSInst);

/** 
 * @brief   TTSGetParam
 * 
 * Get the parameters of the the engine instance
 * 
 * @author  iFLYTEK
 * @return  TTSRETVAL - Return 0 in success, otherwise return error code.
 * @param   HTTSINSTANCE hTTSInst   - [in] The instance handle returned by TTSConnect function
 * @param   TTSDWORD dwParamType    - [in] Parameter type to set
 * @param   TTSINT32 *pParam        - [out] Return the parameter value specified
 * @param   TTSINT32* pnSize        - [in,out] Pointer to a variable that specifies the size(in BYTEs) of the buffer pointed to by the pParam
 *                                      and when returns contain the length of the param value stored in the buffer.
 * @see     TTSGetSynthParam
 */
TTSRETVAL TTSLIBAPI TTSGetParam(HTTSINSTANCE hTTSInst, TTSDWORD dwParamType, void *pParam, TTSINT32* pnSize);
typedef TTSRETVAL (*Proc_TTSGetParam)(HTTSINSTANCE hTTSInst, TTSDWORD dwParamType, void *pParam, TTSINT32* pnSize);

/** 
 * @brief   TTSSetParam
 * 
 * Set the parameters of the engine instance
 * 
 * @author  iFLYTEK
 * @return  TTSRETVAL - Return 0 in success, otherwise return error code.
 * @param   HTTSINSTANCE hTTSInst   - [in] The instance handle returned by TTSConnect function
 * @param   TTSDWORD dwParamType    - [in] Parameter type to set
 * @param   void *pParam            - [in] Parameter value buffer to set
 * @param   TTSINT32 nSize          - [in] The parameter value buffer size
 * @see     TTSSetSynthParam
 */
TTSRETVAL TTSLIBAPI TTSSetParam(HTTSINSTANCE hTTSInst, TTSDWORD dwParamType, void *pParam, TTSINT32 nSize);
typedef TTSRETVAL (*Proc_TTSSetParam)(HTTSINSTANCE hTTSInst, TTSDWORD dwParamType, void *pParam, TTSINT32 nSize);

/** 
 * @brief   TTSLoadUserLib
 * 
 * Load a user defined library to the engine
 * 
 * @author  iFLYTEK
 * @return  TTSRETVAL - Return 0 in success, otherwise return error code.
 * @param   HTTSINSTANCE hTTSInst   - [in] The instance handle returned by TTSConnect function
 * @param   HTTSUSERLIB* lphUserLib - [out] Return handle of the user library
 * @param   PTTSVOID pUserLib       - [in] User library path or name
 * @param   TTSINT32 nSize          - [in] sizeof lpUserLibPath data
 * @see     
 */
TTSRETVAL TTSLIBAPI TTSLoadUserLib(HTTSINSTANCE hTTSInst, HTTSUSERLIB* lphUserLib, PTTSVOID pUserLib, TTSINT32 nSize);
typedef TTSRETVAL (*Proc_TTSLoadUserLib)(HTTSINSTANCE hTTSInst, HTTSUSERLIB* lphUserLib, PTTSVOID pUserLib, TTSINT32 nSize);

/** 
 * @brief   TTSUnloadUserLib
 * 
 * Remove a user defined library from the engine
 * 
 * @author  iFLYTEK
 * @return  TTSRETVAL - Return 0 in success, otherwise return error code.
 * @param   HTTSINSTANCE hTTSInst   - [in] The instance handle returned by TTSConnect function
 * @param   HTTSUSERLIB hUserLib    - [in] The user library handle returned by TTSLoadUserLib
 * @see     
 */
TTSRETVAL TTSLIBAPI TTSUnloadUserLib(HTTSINSTANCE hTTSInst, HTTSUSERLIB hUserLib);
typedef TTSRETVAL (*Proc_TTSUnloadUserLib)(HTTSINSTANCE hTTSInst, HTTSUSERLIB hUserLib);


/*==========================================================================
    Accessories functions
 ===========================================================================*/

/** 
 * @brief   TTSFormatMessage
 * 
 * Format a TTS error code to error description string
 * 
 * @author  iFLYTEK
 * @return  TTSRETVAL - Return 0 in success, otherwise return error code.
 * @param   TTSDWORD dwTTSErrCode   - [in] TTS error code
 * @param   PTTSVOID pMsgBuf        - [in,out] Pointer to a buffer(allocated by user) 
 * @param   TTSINT16* pnSize        - [in,out] Pointer to a variable that specifies the size(in BYTEs) of the buffer pointed to by the pMsgBuf
 *                                      and when returns contain the length of the param value stored in the buffer.
 * @see     
 */
TTSRETVAL TTSLIBAPI TTSFormatMessage(TTSDWORD dwTTSErrCode, PTTSVOID pMsgBuf, TTSINT16* pnSize);
typedef TTSRETVAL (*Proc_TTSFormatMessage)(TTSDWORD dwTTSErrCode, PTTSVOID pMsgBuf, TTSINT16* pnSize);

/** 
 * @brief   TTSAbout
 * 
 * Get TTS System information of current version
 * 
 * @author  iFLYTEK
 * @return  TTSRETVAL - Return 0 in success, otherwise return error code.
 * @param   TTSDWORD dwAboutType    - [in] TTS About type
 * @param   PTTSVOID pContent       - [in,out] TTS About content buffer(allocated by user)
 * @param   TTSINT32* pnSize        - [in,out] Pointer to a variable that specifies the size(in BYTEs) of the buffer pointed to by the pAboutContent
 *                                      and when returns contain the length of the param value stored in the buffer.
 * @see     
 */
TTSRETVAL TTSLIBAPI TTSAbout(TTSDWORD dwAboutType, PTTSVOID pContent, TTSINT16* pnSize);
typedef TTSRETVAL (*Proc_TTSAbout)(TTSDWORD dwAboutType, PTTSVOID pContent, TTSINT16* pnSize);

/*==========================================================================
    Obsolete functions
 ===========================================================================*/

/** 
 * @brief   TTSInitialize
 * 
 * Global initialize TTS, it is the first function to be called.
 * This function is obsolete, provided only for compatibility with old system.
 * New applications should call TTSInitializeEx instead of TTSInitialize
 * 
 * @author  iFLYTEK
 * @return  TTSRETVAL - Return 0 in success, otherwise return error code
 * @see     TTSInitializeEx
 */
TTSRETVAL TTSLIBAPI TTSInitialize();
typedef TTSRETVAL (*Proc_TTSInitialize)();

/** 
 * @brief   TTSGetSynthParam
 * 
 * Get the parameters of the TTS system
 * This function is obsolete, provided only for compatibility with old system.
 * New applications should call TTSGetParam instead of TTSGetSynthParam
 * 
 * @author  iFLYTEK
 * @return  TTSRETVAL - Return 0 in success, otherwise return error code.
 * @param   HTTSINSTANCE hTTSInst   - [in] The instance handle returned by TTSConnect function
 * @param   TTSDWORD dwParamType    - [in] Parameter type to set
 * @param   TTSINT32 *pnParam       - [out] Return the parameter value specified
 * @see     
 */
TTSRETVAL TTSLIBAPI TTSGetSynthParam(HTTSINSTANCE hTTSInst, TTSDWORD dwParamType, TTSINT32 *pnParam);
typedef TTSRETVAL (*Proc_TTSGetSynthParam)(HTTSINSTANCE hTTSInst, TTSDWORD dwParamType, TTSINT32 *pnParam);

/** 
 * @brief   TTSSetSynthParam
 * 
 * Set the parameters of the engine
 * This function is obsolete, provided only for compatibility with old system.
 * New applications should call TTSSetParam instead of TTSSetSynthParam
 * 
 * @author  iFLYTEK
 * @return  TTSRETVAL - Return 0 in success, otherwise return error code.
 * @param   HTTSINSTANCE hTTSInst   - [in] The instance handle returned by TTSConnect function
 * @param   TTSDWORD dwParamType    - [in] Parameter type to set
 * @param   TTSINT32 nParam         - [in] Parameter value to set
 * @see     
 */
TTSRETVAL TTSLIBAPI TTSSetSynthParam(HTTSINSTANCE hTTSInst, TTSDWORD dwParamType, TTSINT32 nParam);
typedef TTSRETVAL (*Proc_TTSSetSynthParam)(HTTSINSTANCE hTTSInst, TTSDWORD dwParamType, TTSINT32 nParam);

/** 
* @brief   AddURL
* 
* Begin synthesize text, send text to engine
* 
* @author  iFLYTEK
* @return  TTSRETVAL - Return 0 in success, otherwise return error code.
* @param   HTTSINSTANCE hTTSInst    - [in] The instance handle returned by TTSConnect function
* @param   PTTSData pTTSData        - [in,out] Pointer to TTSData structure
* @see     TTSSynthTextEx
*/
TTSRETVAL TTSLIBAPI AddURL(HTTSINSTANCE hTTSInst, PTTSData pTTSData);
typedef TTSRETVAL (*Proc_AddURL)(HTTSINSTANCE hTTSInst, PTTSData pTTSData);

/** 
* @brief   GetURL
* 
* Begin synthesize text, send text to engine
* 
* @author  iFLYTEK
* @return  TTSRETVAL - Return 0 in success, otherwise return error code.
* @param   HTTSINSTANCE hTTSInst    - [in] The instance handle returned by TTSConnect function
* @param   PTTSData pTTSData        - [in,out] Pointer to TTSData structure
* @see     TTSSynthTextEx
*/
TTSRETVAL TTSLIBAPI GetURL(HTTSINSTANCE hTTSInst, PTTSData pTTSData);
typedef TTSRETVAL (*Proc_GetURL)(HTTSINSTANCE hTTSInst, PTTSData pTTSData);
#ifdef __cplusplus
} /*extern "C"*/
#endif

#endif /* #ifndef IFLY_TTS_H */
