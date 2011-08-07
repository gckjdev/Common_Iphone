/** 
 * @file    TTSErrcode.h
 * @brief   define iFLY error codes
 * 
 * This file contains the iFLY application return error codes. Developer can 
 * include this file in your project to find errro reason.
 * For more information, please read the developer guide.
 * Copyright (C)    1999 - 2004 by ANHUI USTC IFLYTEK. Co.,LTD.
 *                  All rights reserved.
 * 
 * @author  Speech Dept. iFLYTEK.
 * @version 1.0
 * @date    2001-05-05
 * 
 * @see     
 * 
 * Histroy:
 * index    version     date            author      notes
 * 0        1.1         2001/06/05      alex        Create this file
 * 1        1.1         2004/05/20      jet         Add more comments
 * 
 */
#ifndef _TTSERRCODE_H_
#define _TTSERRCODE_H_

/** 
 * @brief	
 *   Macro Name:    TTS_ERRCHECK_SEVERE
 *   If defined:    Severely check TTS error code (Treat warning as error)
 *  Not defined:    Not severely check TTS error code (Only report real error)
 */
#define TTS_ERRCHECK_SEVERE     1

/**
 *
 *  TTSERRVALs are 32 bit values layed out as follows:
 *
 *   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
 *   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
 *  +-+-+-+-+-+---------------------+-------------------------------+
 *  |S|R|C|N|r|    Facility         |               Code            |
 *  +-+-+-+-+-+---------------------+-------------------------------+
 *
 *  where
 *
 *      S - Severity - indicates success/fail
 *
 *          0 - Success
 *          1 - Fail (COERROR)
 *
 *      R - reserved portion of the facility code, corresponds to NT's
 *              second severity bit.
 *
 *      C - reserved portion of the facility code, corresponds to NT's
 *              C field.
 *
 *      N - reserved portion of the facility code. Used to indicate a
 *              mapped NT status value.
 *
 *      r - reserved portion of the facility code. Reserved for internal
 *              use. Used to indicate HRESULT values that are not status
 *              values, but are instead message ids for display strings.
 *
 *      Facility - is the facility code
 *
 *      Code - is the facility's status code
 */

#ifndef MAKE_SCODE
#define MAKE_SCODE(sev,fac,code) \
    ((SCODE) (((unsigned long)(sev)<<31) | ((unsigned long)(fac)<<16) | ((unsigned long)(code))) )
#endif

#ifndef SEVERITY_SUCCESS
#define SEVERITY_SUCCESS    0
#endif
#ifndef SEVERITY_ERROR
#define SEVERITY_ERROR      1
#endif

/** 
 * @brief   Error Macros
 * Using macro TTSAPIERROR and TTSAPIWARNING to generate a TTS error (or warning) code.
 * For example,
 *  nRet = TTSAPIERROR(TTSERR_READFILE);
 *  nRet = TTSAPIWARNING(TTSERR_INVALIDPTR);
 */
#define FACILITY_TTSAPI   (0x65)
#define TTSAPIERROR(x)    MAKE_SCODE(SEVERITY_ERROR,   FACILITY_TTSAPI, (x & 0x0000FFFF))
#define TTSAPIWARNING(x)  MAKE_SCODE(SEVERITY_SUCCESS, FACILITY_TTSAPI, (x & 0x0000FFFF))

/** 
 * @brief   Error Macros
 * Using macro TTSERRCHECK to check the return code of TTS function.
 * For example, 
 *  if (!TTSERRCHECK(nRet))
 *  {
 *      printf("Error! Function return %d!\n", nRet);
 *  }
 * If define macro TTS_ERRCHECK_SEVERE, warning will be treated as error.
 */
#ifdef TTS_ERRCHECK_SEVERE
#define TTSERRCHECK(x) (x == TTSERR_OK)
#else
#define TTSERRCHECK(x) SUCCEEDED(x)
#endif

#define TTSGETFACCODE(x) (((x) & 0x07FF0000) >> 16)
#define TTSGETERRCODE(x) ((x) & 0x0000FFFF)

#define TTSERR_OK       0x0L
#define TTSERR_FALSE    0x1L
#define TTSERR_FAIL     0x80000000L

/* Base code of general error */
#define TTSERR_GENBASE     0x0
#define TTSERR_GENERR(x)   ((x) + TTSERR_GENBASE)
/* Base code of system error */
#define TTSERR_SYSBASE     0x100
#define TTSERR_SYSERR(x)   ((x) + TTSERR_SYSBASE)
/* Base code of memory error */
#define TTSERR_MEMBASE     0x200
#define TTSERR_MEMERR(x)   ((x) + TTSERR_MEMBASE)

/* Base code of file error */
#define TTSERR_FILEBASE    0x300
#define TTSERR_FILEERR(x)  ((x) + TTSERR_FILEBASE)

/* Base code of network error */
#define TTSERR_NETBASE     0x400
#define TTSERR_NETERR(x)   ((x) + TTSERR_NETBASE)

/* Base code of resource error */
#define TTSERR_RESBASE     0x500
#define TTSERR_RESERR(x)   ((x) + TTSERR_RESBASE)

/* Base code of lexicon error */
#define TTSERR_LEXBASE     0x800
#define TTSERR_LEXERR(x)   ((x) + TTSERR_LEXBASE)

/* Base code of synth error */
#define TTSERR_SYNTHBASE   0x900
#define TTSERR_SYNTHERR(x) ((x) + TTSERR_SYNTHBASE)

/* General errors 0x000 */
#define TTSERR_UNKNOWN          TTSERR_GENERR(0x1)      /* Unkown error */
#define TTSERR_EXCEPTION        TTSERR_GENERR(0x2)      /* Exception */
#define TTSERR_NOTSUPP          TTSERR_GENERR(0x3)      /* Not supported */
#define TTSERR_NOTIMPL          TTSERR_GENERR(0x4)      /* Not implemented */
#define TTSERR_UNKNOWNCMD       TTSERR_GENERR(0x5)      /* Unkown command */
#define TTSERR_INVALIDPARA      TTSERR_GENERR(0x6)      /* Invalid parameter */
#define TTSERR_DATASIZE         TTSERR_GENERR(0x7)      /* Data size */
#define TTSERR_ALREADYEXIST     TTSERR_GENERR(0x8)      /* Object already exist */
#define TTSERR_OVERFLOW         TTSERR_GENERR(0x9)      /* Overflow */
#define TTSERR_NOTRESPONSE      TTSERR_GENERR(0xA)      /* Not response */
#define TTSERR_STOPPED          TTSERR_GENERR(0xB)      /* Stopped */
#define TTSERR_CANCELED         TTSERR_GENERR(0xC)      /* Canceled */
#define TTSERR_TOOMANYREQ       TTSERR_GENERR(0xD)      /* Too many request */
#define TTSERR_TIMEOUT          TTSERR_GENERR(0xE)      /* Time out */
#define TTSERR_NOTCONNECT       TTSERR_GENERR(0xF)      /* Not connect */
#define TTSERR_INITFAIL         TTSERR_GENERR(0x10)     /* Init fail */
#define TTSERR_NOTINIT          TTSERR_GENERR(0x11)     /* Not Initialized */
#define TTSERR_CLOSED           TTSERR_GENERR(0x12)     /* Closed */
#define TTSERR_NOMOREDATA       TTSERR_GENERR(0x13)     /* No more data */
#define TTSERR_VERSIONCHECK     TTSERR_GENERR(0x14)     /* Not pass version check */
#define TTSERR_PRECONDITION     TTSERR_GENERR(0x15)     /* Not meet preconditon */
#define TTSERR_NOTREGISTERED    TTSERR_GENERR(0x16)     /* Not registered */
#define TTSERR_INVALIDCONFIG    TTSERR_GENERR(0x17)     /* Invalid configuration. */

/* System errors 0x100 */
#define TTSERR_CREATEHANDLE     TTSERR_SYSERR(0x1)      /* Create system handle */
#define TTSERR_NULLHANDLE       TTSERR_SYSERR(0x2)      /* Handle is NULL */
#define TTSERR_INVALIDHANDLE    TTSERR_SYSERR(0x3)      /* Handle is invalid */
#define TTSERR_OPENDEV          TTSERR_SYSERR(0x4)      /* Open device */
#define TTSERR_SETHOOK          TTSERR_SYSERR(0x5)      /* Set hook */
#define TTSERR_REMOVEHOOK       TTSERR_SYSERR(0x6)      /* Remove hook */
#define TTSERR_LOADDLL          TTSERR_SYSERR(0x7)      /* Load dll */
#define TTSERR_GETPROCADDR      TTSERR_SYSERR(0x8)      /* Get procedure address */
#define TTSERR_SYNC             TTSERR_SYSERR(0x9)      /* Synchronize */
#define TTSERR_CREATEOBJECT     TTSERR_SYSERR(0xA)      /* Create system object */
#define TTSERR_OBJECTEXIST      TTSERR_SYSERR(0xB)      /* System object already exist */
#define TTSERR_WAITTIMEOUT      TTSERR_SYSERR(0xC)      /* Wait system object time out */
#define TTSERR_OBJECTABANDON    TTSERR_SYSERR(0xD)      /* System object abandoned */
#define TTSERR_INVALIDOBJECT    TTSERR_SYSERR(0xE)      /* Invalid system object */

/* Memory errors 0x200 */
#define TTSERR_MALLOC           TTSERR_MEMERR(0x1)      /* Malloc (or new) memory */
#define TTSERR_REMALLOC         TTSERR_MEMERR(0x2)      /* Remalloc memory */
#define TTSERR_OVERFLOWBUF      TTSERR_MEMERR(0x3)      /* Memory buffer overflow */
#define TTSERR_INVALIDPTR       TTSERR_MEMERR(0x4)      /* Invalid memory pointer */
#define TTSERR_NULLPTR          TTSERR_MEMERR(0x5)      /* Memory pointer is NULL */
#define TTSERR_READMEM          TTSERR_MEMERR(0x6)      /* Read memory */
#define TTSERR_WRITEMEM         TTSERR_MEMERR(0x7)      /* Write memory */
#define TTSERR_NOENOUGHMEM      TTSERR_MEMERR(0x8)      /* No enough memory */
#define TTSERR_NOENOUGHBUF      TTSERR_MEMERR(0x9)      /* Buffer size is not enough */
#define TTSERR_BADACCESS        TTSERR_MEMERR(0xA)      /* Memory is bad read/write */

/* File errors 0x300 */
#define TTSERR_OPENFILE         TTSERR_FILEERR(0x1)     /* Open file */
#define TTSERR_READFILE         TTSERR_FILEERR(0x2)     /* Read file */
#define TTSERR_WRITEFILE        TTSERR_FILEERR(0x3)     /* Write file */
#define TTSERR_RENAMEFILE       TTSERR_FILEERR(0x4)     /* Rename file */
#define TTSERR_MOVEFILE         TTSERR_FILEERR(0x5)     /* Move file */
#define TTSERR_EMPTYFILE        TTSERR_FILEERR(0x6)     /* File is empty */

/* Network errors 0x400 */
#define TTSERR_OPENSOCK         TTSERR_NETERR(0x1)      /* Open socket */
#define TTSERR_CONNECTSOCK      TTSERR_NETERR(0x2)      /* Connect socket */
#define TTSERR_ACCEPTSOCK       TTSERR_NETERR(0x3)      /* Accept socket */
#define TTSERR_SENDSOCK         TTSERR_NETERR(0x4)      /* Send socket data */
#define TTSERR_RECVSOCK         TTSERR_NETERR(0x5)      /* Recv socket data */
#define TTSERR_INVALIDSOCK      TTSERR_NETERR(0x6)      /* Invalid socket handle */
#define TTSERR_SERVICEID        TTSERR_NETERR(0x7)      /* Invalid service ID */
#define TTSERR_BADADDRESS       TTSERR_NETERR(0x8)      /* Bad network address */
#define TTSERR_BINDSEQUENCE     TTSERR_NETERR(0x9)      /* Bind after listen/connect */
#define TTSERR_NOTOPENSOCK      TTSERR_NETERR(0xA)      /* Socket is not opened */
#define TTSERR_NOTBOUND         TTSERR_NETERR(0xB)      /* Socket is not bound to an address */
#define TTSERR_NOTLISTEN        TTSERR_NETERR(0xC)      /* Socket is not listenning */
#define TTSERR_CONNECTCLOSE     TTSERR_NETERR(0xD)      /* The other side of connection is closed */
#define TTSERR_NOTDGRAMSOCK     TTSERR_NETERR(0xE)      /* The socket is not datagram type */

/* Resource errors 0x500 */
#define TTSERR_RESLOAD          TTSERR_RESERR(0x1)      /* Load resource */
#define TTSERR_RESFREE          TTSERR_RESERR(0x2)      /* Free resource */
#define TTSERR_RESMISSING       TTSERR_RESERR(0x3)      /* Resource File Missing */
#define TTSERR_INVALID_RESNAME  TTSERR_RESERR(0x4)      /* Invalid resource file name */
#define TTSERR_INVALID_RESID    TTSERR_RESERR(0x5)      /* Invalid resource ID */
#define TTSERR_INVALID_RESIMG   TTSERR_RESERR(0x6)      /* Invalid resource image pointer */
#define TTSERR_RESWRITE         TTSERR_RESERR(0x7)      /* Write read-only resource */
#define TTSERR_RESLEAK          TTSERR_RESERR(0x8)      /* Resource leak out */
#define TTSERR_RESHEAD          TTSERR_RESERR(0x9)      /* Resource head currupt */
#define TTSERR_RESDATA          TTSERR_RESERR(0xA)      /* Resource data currupt */
#define TTSERR_RESSKIP          TTSERR_RESERR(0xB)      /* Resource file skipped */

/* Lexicon errors 0x800 */
#define TTSERR_CONVERT          TTSERR_LEXERR(0x1)      /* Convert */
#define TTSERR_MATCH            TTSERR_LEXERR(0x2)      /* Match */
#define TTSERR_GETPOS           TTSERR_LEXERR(0x3)      /* Get position */
#define TTSERR_LOADINDEX        TTSERR_LEXERR(0x4)      /* Load Index */
#define TTSERR_INDEX            TTSERR_LEXERR(0x5)      /* Index */
#define TTSERR_TEXTEND          TTSERR_LEXERR(0x6)      /* Meet text end */
#define TTSERR_NOTFOUND         TTSERR_LEXERR(0x7)      /* Not found */
#define TTSERR_PARSESTR         TTSERR_LEXERR(0x8)      /* Parse String */
#define TTSERR_STRFORMAT        TTSERR_LEXERR(0x9)      /* String Format */

/* Synth errors 0x900 */
#define TTSERR_INVALIDSN        TTSERR_SYNTHERR(0x1)    /* Invalid SN code */
#define TTSERR_GETSTATUS        TTSERR_SYNTHERR(0x2)    /* Get status info */
#define TTSERR_GETPARAM         TTSERR_SYNTHERR(0x3)    /* Get synth parameter */
#define TTSERR_SETPARAM         TTSERR_SYNTHERR(0x4)    /* Set synth parameter */
#define TTSERR_NOLICENCE        TTSERR_SYNTHERR(0x5)    /* Have no licence to run */
#define TTSERR_VLIBUNKNOWN      TTSERR_SYNTHERR(0x6)    /* Unknown voclib */
#define TTSERR_NODELEVEL        TTSERR_SYNTHERR(0x7)    /* Synth tree node level */

#endif /* _TTSERRCODE_H_ */
