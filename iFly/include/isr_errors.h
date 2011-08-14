/**
 * @file    isr_rec.h
 * @brief   iFLY Speech Recognizer Header File
 * 
 *  This file contains the error code declarations 
 *  of ISR. Developer can include this file in your project to build applications.
 *  For more information, please read the developer guide.
 
 *  Use of this software is subject to certain restrictions and limitations set
 *  forth in a license agreement entered into between iFLYTEK, Co,LTD.
 *  and the licensee of this software.  Please refer to the license
 *  agreement for license use rights and restrictions.
 *
 *  Copyright (C)    1999 - 2007 by ANHUI USTC iFLYTEK, Co,LTD.
 *                   All rights reserved.
 * 
 * @author  Speech Dept. iFLYTEK.
 * @version 1.0
 * @date    2007/04/17
 * 
 * @see        
 * 
 * History:
 * index    version        date            author        notes
 * 0        1.0            2007/04/17      Speech        Create this file
 */

#ifndef __ISR_ERRORS_H__
#define __ISR_ERRORS_H__

/**
 * The enumeration ISR_ERROR enumerates possible error codes
 *  ISR_SUCCESS function completed successfully
 *  ISR_ERROR_OUT_OF_MEMORY out of memory
 *  ISR_ERROR_SYSTEM_ERROR general system error
 *  ISR_ERROR_UNSUPPORTED operation unsupported
 *  ISR_ERROR_BUSY the recognizer is busy
 *  ISR_ERROR_INVALID_PARA invalid parameter
 *  ISR_ERROR_INVALID_PARA_VALUE invalid parameter value
 *  ISR_ERROR_INVALID_DATA input data is not valid
 *  ISR_ERROR_INVALID_RULE grammar contains invalid rule
 *  ISR_ERROR_INVALID_WORD grammar contains invalid word
 *  ISR_ERROR_INVALID_NBEST_INDEX input nbestIndex is out of range
 *  ISR_ERROR_URI_NOT_FOUND input URI is not found
 *  ISR_ERROR_REC_GRAMMAR_ERROR error during grammar parsing (often ECMAscript 
 *   bug)
 *  ISRrec_ERROR_AUDIO_OVERFLOW audio buffer overflow
 *  ISR_ERROR_OVERFLOW grammar/string/data buffer overflow
 *  ISR_ERROR_REC_NO_ACTIVE_GRAMMARS recognition is started with no grammars
 *   active
 *  ISR_ERROR_REC_GRAMMAR_NOT_ACTIVATED can't deactivate a grammar that has
 *   not been activated
 *  ISR_ERROR_REC_NO_SESSION_NAME recognition can't start until session names
 *   are defined
 *  ISR_ERROR_REC_INACTIVE recognition has not begun
 *  ISR_ERROR_NODATA no data is present
 *
 *  ISR_ERROR_NO_LICENSE a call to ISRrecRecognizerStart() or
 *   ISRrecParseDTMFResults()was attempted but the recognizer does not have
 *   a valid license checked out from the license server -OR- calls to
 *   ISRrecResourceAllocate/Free() fail because no license server is
 *   available
 *
 *  ISR_ERROR_INVALID_MEDIA_TYPE an api or server supplied media type is
 *   invalid
 *
 *  ISR_REC_ERROR_URI_TIMEOUT a uri fetch resulted in a timeout
 *  ISR_REC_ERROR_URI_FETCH_ERROR a uri fetch resulted in an error
 *
 *  ISR_REC_ERROR_INVALID_LANGUAGE a language is not supported
 *  ISR_REC_ERROR_DUPLICATE_GRAMMAR an activate of the same grammar is
 *   attempted twice
 *
 *  ISR_REC_ERROR_INVALID_CHAR an invalid character is passed in an api call
 *   (for example, all uri's must use ascii characters also surrogate pairs
 *    are illegal)
 *
 *  ISR_ERROR_FAIL generic failure condition, retry is possible
 *  ISR_ERROR_GENERAL generic recoverable error occurred
 *  ISR_ERROR_GENERIC_FATAL_ERROR generic fatal error occurred
 *
 */
enum
{
	/* Generic Error defines */
	ISR_SUCCESS								=  0,
	ISR_ERROR_FAIL							= -1,
	ISR_ERROR_EXCEPTION						= -2,

	/* Common errors */
	ISR_ERROR_GENERAL						= 10000,	/* 0x2710 Generic Error */
	ISR_ERROR_OUT_OF_MEMORY					= 10001,	/* 0x2711 */
	ISR_ERROR_FILE_NOT_FOUND				= 10002,	/* 0x2712 */
	ISR_ERROR_NOT_SUPPORT					= 10003,	/* 0x2713 */
	ISR_ERROR_NOT_IMPLEMENT					= 10004,	/* 0x2714 */
	ISR_ERROR_ACCESS						= 10005,	/* 0x2715 */
	ISR_ERROR_INVALID_PARA					= 10006,	/* 0x2716 */
	ISR_ERROR_INVALID_PARA_VALUE			= 10007,	/* 0x2717 */
	ISR_ERROR_INVALID_HANDLE				= 10008,	/* 0x2718 */
	ISR_ERROR_INVALID_DATA					= 10009,	/* 0x2719 */
	ISR_ERROR_NO_LICENSE					= 10010,	/* 0X271A */
	ISR_ERROR_NOT_INIT						= 10011,	/* 0X271B */
	ISR_ERROR_NULL_HANDLE					= 10012,	/* 0X271C */
	ISR_ERROR_OVERFLOW						= 10013,	/* 0X271D */
	ISR_ERROR_TIME_OUT						= 10014,	/* 0X271E */
	ISR_ERROR_OPEN_FILE						= 10015,	/* 0X271F */
	ISR_ERROR_NOT_FOUND						= 10016,	/* 0X2720 */
	ISR_ERROR_NO_ENOUGH_BUFFER				= 10017,	/* 0x2721 */
	ISR_ERROR_NO_DATA						= 10018,	/* 0x2722 */
	ISR_ERROR_NO_MORE_DATA					= 10019,	/* 0x2723 */
	ISR_ERROR_RES_MISSING					= 10020,	/* 0x2724 */
	ISR_ERROR_SKIPPED						= 10021,	/* 0x2725 */
	ISR_ERROR_ALREADY_EXIST					= 10022,	/* 0x2726 */
	ISR_ERROR_LOAD_MODULE					= 10023,	/* 0x2727 */
	ISR_ERROR_BUSY							= 10024,	/* 0x2728 */
	ISR_ERROR_INVALID_CONFIG				= 10025,	/* 0x2729 */
	ISR_ERROR_VERSION_CHECK                 = 10026,    /* 0x272A */
	ISR_ERROR_CANCELED						= 10027,    /* 0x272B */
	ISR_ERROR_INVALID_MEDIA_TYPE			= 10028,    /* 0x272C */	

	/* Error codes of Recognizer */
	ISR_ERROR_REC_GENERAL					= 10100,	/* 0x2774 */
	ISR_ERROR_REC_INACTIVE					= 10101,	/* 0x2775 */
	ISR_ERROR_REC_NO_SESSION_NAME			= 10102,	/* 0x2776 */
	ISR_ERROR_REC_GRAMMAR_ERROR				= 10103,	/* 0x2777 */
	ISR_ERROR_REC_NO_ACTIVE_GRAMMARS		= 10104,	/* 0x2778 */
	ISR_ERROR_REC_GRAMMAR_NOT_LOADED		= 10105,	/* 0x2779 */
	ISR_ERROR_REC_GRAMMAR_NOT_ACTIVATED		= 10106,	/* 0x277A */
	ISR_ERROR_REC_DUPLICATE_GRAMMAR			= 10107,	/* 0x277B */
	ISR_ERROR_REC_INVALID_MEDIA_TYPE		= 10108,	/* 0x277C */
	ISR_ERROR_REC_INVALID_LANGUAGE			= 10109,	/* 0x277D */
	ISR_ERROR_REC_INVALID_RULE				= 10110,	/* 0x277E */
	ISR_ERROR_REC_INVALID_WORD				= 10111,	/* 0x277F */
	ISR_ERROR_REC_INVALID_CHAR				= 10112,	/* 0x2780 */
	ISR_ERROR_REC_URI_NOT_FOUND				= 10113,	/* 0x2781 */
	ISR_ERROR_REC_URI_TIMEOUT				= 10114,	/* 0x2782 */
	ISR_ERROR_REC_URI_FETCH_ERROR			= 10115,	/* 0x2783 */

	/* Error codes of Speech Detector */
	ISR_ERROR_EP_GENERAL					= 10200,	/* 0x27D8 */
	ISR_ERROR_EP_NO_SESSION_NAME            = 10201,    /* 0x27D9 */
	ISR_ERROR_EP_INACTIVE                   = 10202,    /* 0x27DA */
	ISR_ERROR_EP_INITIALIZED                = 10203,    /* 0x27DB */

};

#endif /* __ISR_ERRORS_H__ */
