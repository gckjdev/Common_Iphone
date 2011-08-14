/**
 * @file    qisr.h
 * @brief   iFLY Speech Recognizer Header File
 * 
 *  This file contains the quick application programming interface (API) declarations 
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
 * @date    2008/12/12
 * 
 * @see        
 * 
 * History:
 * index    version        date            author        notes
 * 0        1.0            2008/12/12      Speech        Create this file
 */

#ifndef __QISR_H__
#define __QISR_H__

#include "isr_types.h"
#include "isr_ep.h"
#include "isr_rec.h"

#ifdef __cplusplus
extern "C" {
#endif /* C++ */

/** 
 * @fn		QISRSessionBegin
 * @brief	Begin a Recognizer Session
 * 
 *  Create a recognizer session to recognize audio data
 * 
 * @return	return sessionID of current session, NULL is failed.
 * @param	const char* grammarList		- [in] grammars list, inline grammar support only one.
 * @param	const char* params			- [in] parameters when the session created.
 * @param	int *errorCode				- [out] return 0 on success, otherwise return error code.
 * @see		
 */
const char* ISRAPI QISRSessionBegin(const char* grammarList, const char* params, int* errorCode);
typedef const char* (ISRAPI *Proc_QISRSessionBegin)(const char* grammarList, const char* params, int *result);
#ifdef MSP_WCHAR_SUPPORT
const wchar_t* ISRAPI QISRSessionBeginW(const wchar_t* grammarList, const wchar_t* params, int *result);
typedef const wchar_t* (ISRAPI *Proc_QISRSessionBeginW)(const wchar_t* grammarList, const wchar_t* params, int *result);
#endif

/** 
 * @fn		QISRGrammarActivate
 * @brief	Activate a grammar
 * 
 *  Activate a string or file grammar
 * 
 * @return	int ISRAPI	- Return 0 in success, otherwise return error code.
 * @param	const char* sessionID	- [in] the session id
 * @param	const char* grammar	- [in] grammar uri or string to activate
 * @param	const char* type	- [in] grammar type
 * @param	int weight	- [in] grammar weight
 * @see		
 */
int ISRAPI QISRGrammarActivate(const char* sessionID, const char* grammar, const char* type, int weight);
typedef int (ISRAPI *Proc_QISRGrammarActivate)(const char* sessionID, const char* grammar, const char* type, int weight);
#ifdef MSP_WCHAR_SUPPORT
int ISRAPI QISRGrammarActivateW(const wchar_t* sessionID, const wchar_t* grammar, const wchar_t* type, int weight);
typedef int (ISRAPI *Proc_QISRGrammarActivateW)(const wchar_t* sessionID, const wchar_t* grammar, const wchar_t* type, int weight);
#endif

/** 
 * @fn		QISRAudioWrite
 * @brief	Write Audio Data to Recognizer Session
 * 
 *  Writing binary audio data to recognizer.
 * 
 * @return	int ISRAPI	- Return 0 in success, otherwise return error code.
 * @param	const char* sessionID	- [in] The session id returned by recog_begin
 * @param	const void* waveData	- [in] Binary data of waveform
 * @param	unsigned int waveLen	- [in] Waveform data size in bytes
 * @param	int audioStatus			- [in] Audio status, can be 
 * @param	int *epStatus			- [out] ISRepState
 * @param	int *recogStatus		- [out] ISRrecRecognizerStatus, see isr_rec.h
 * @see		
 */
int ISRAPI QISRAudioWrite(const char* sessionID, const void* waveData, unsigned int waveLen, int audioStatus, int *epStatus, int *recogStatus);
typedef int (ISRAPI *Proc_QISRAudioWrite)(const char* sessionID, const void* waveData, unsigned int waveLen, int audioStatus, int *epStatus, int *recogStatus);
#ifdef MSP_WCHAR_SUPPORT
int ISRAPI QISRAudioWriteW(const wchar_t* sessionID, const void* waveData, unsigned int waveLen, int audioStatus, int *epStatus, int *recogStatus);
typedef int (ISRAPI *Proc_QISRAudioWriteW)(const wchar_t* sessionID, const void* waveData, unsigned int waveLen, int audioStatus, int *epStatus, int *recogStatus);
#endif

/** 
 * @fn		QISRGetResult
 * @brief	Get Recognize Result in Specified Format
 * 
 *  Get recognize result in Specified format.
 * 
 * @return	int ISRAPI	- Return 0 in success, otherwise return error code.
 * @param	const char* sessionID	- [in] session id returned by session begin
 * @param	int* rsltStatus			- [out] status of recognition result, 0: success, 1: no match, 2: incomplete, 5:speech complete
 * @param	int *errorCode			- [out] return 0 on success, otherwise return error code.
 * @see		
 */
const char * ISRAPI QISRGetResult(const char* sessionID, int* rsltStatus, int waitTime, int *errorCode);
typedef const char * (ISRAPI *Proc_QISRGetResult)(const char* sessionID, int* rsltStatus, int waitTime, int *errorCode);
#ifdef MSP_WCHAR_SUPPORT
const wchar_t* ISRAPI QISRGetResultW(const wchar_t* sessionID, int* rsltStatus, int waitTime, int *errorCode);
typedef const wchar_t* (ISRAPI *Proc_QISRGetResultW)(const wchar_t* sessionID, int* rsltStatus, int waitTime, int *errorCode);
#endif

/** 
 * @fn		QISRUploadData
 * @brief	Upload User Specific Data
 * 
 *  Upload data such as user config,custom grammar,etc.
 * 
 * @return	const char* ISRAPI		- extern info return by Server, used for special command.
 * @param	const char* sessionID	- [in] session id returned by session begin,if without session, set NULL
 * @param	const char* dataName	- [in] data name,should be unique to diff other data.
 * @param	void* data				- [in] the data buffer pointer, data could be binary.
 * @param	unsigned int dataLen	- [in] length of data.
 * @param	const char* dataType	- [in] data type, set this param so that server could preprocess it.Could set NULL
 * @param	int* errorCode			- [out] Return 0 in success, otherwise return error code.
 * @see		
 */
const char* ISRAPI QISRUploadData(const char* sessionID, const char* dataName, void* data, unsigned int dataLen, const char* dataType, int* errorCode);
typedef const char* (ISRAPI* Proc_QISRUploadData)(const char* sessionID, const char* dataName, void* data, unsigned int dataLen, const char* dataType, int* errorCode);
#ifdef MSP_WCHAR_SUPPORT
const wchar_t* ISRAPI QISRUploadDataW(const wchar_t* sessionID, const wchar_t* dataName, void* data, unsigned int dataLen, const wchar_t* dataType, int* errorCode);
typedef const wchar_t* (ISRAPI* Proc_QISRUploadDataW)(const wchar_t* sessionID, const wchar_t* dataName, void* data, unsigned int dataLen, const wchar_t* dataType, int* errorCode);
#endif

/** 
 * @fn		QISRDownloadData
 * @brief	Download User Specific Data
 * 
 *  Download data such as user config, etc.
 * 
 * @return	int ISRAPI	- Return 0 in success, otherwise return error code.
 * @param	const char* sessionID	- [in] session id returned by session begin,if without session, set NULL
 * @param	const char* dataName	- [in] data name,should be unique to diff other data.
 * @param	void** data				- [out] received data buffer pointer, data could be binary.
 * @param	unsigned int* dataLen	- [out] length of received data.
 * @see		
 */
int ISRAPI QISRDownloadData(const char* sessionID, const char* dataName, void** data, unsigned int* dataLen);
typedef int (ISRAPI* Proc_QISRDownloadData)(const char* sessionID, const char* dataName, void** data, unsigned int* dataLen);
#ifdef MSP_WCHAR_SUPPORT
int ISRAPI QISRDownloadDataW(const wchar_t* sessionID, const wchar_t* dataName, void** data, unsigned int* dataLen);
typedef int (ISRAPI* Proc_QISRDownloadDataW)(const wchar_t* sessionID, const wchar_t* dataName, void** data, unsigned int* dataLen);
#endif

/** 
 * @fn		QISRSessionEnd
 * @brief	End a Recognizer Session
 * 
 *  End the recognizer session, release all resource.
 * 
 * @return	int ISRAPI	- Return 0 in success, otherwise return error code.
 * @param	const char* sessionID	- [in] session id string to end
 * @param	const char* hints	- [in] user hints to end session, hints will be logged to CallLog
 * @see		
 */
int ISRAPI QISRSessionEnd(const char* sessionID, const char* hints);
typedef int (ISRAPI *Proc_QISRSessionEnd)(const char* sessionID, const char* hints);
#ifdef MSP_WCHAR_SUPPORT
int ISRAPI QISRSessionEndW(const wchar_t* sessionID, const wchar_t* hints);
typedef int (ISRAPI *Proc_QISRSessionEndW)(const wchar_t* sessionID, const wchar_t* hints);
#endif

/** 
 * @fn		QISRGetParam
 * @brief	get params related with msc
 * 
 *  the params could be local or server param, we only support netflow params "upflow" & "downflow" now
 * 
 * @return	int	- Return 0 if success, otherwise return errcode.
 * @param	const char* sessionID	- [in] session id of related param, set NULL to got global param
 * @param	const char* paramName	- [in] param name,could pass more than one param split by ','';'or'\n'
 * @param	const char* paramValue	- [in] param value buffer, malloced by user
 * @param	int *valueLen			- [in, out] pass in length of value buffer, and return length of value string
 * @see		
 */
int ISRAPI QISRGetParam(const char* sessionID, const char* paramName, char* paramValue, unsigned int* valueLen);
typedef int (ISRAPI *Proc_QISRGetParam)(const char* sessionID, const char* paramName, char* paramValue, unsigned int* valueLen);
#ifdef MSP_WCHAR_SUPPORT
int ISRAPI QISRGetParamW(const wchar_t* sessionID, const wchar_t* paramName, wchar_t* paramValue, unsigned int* valueLen);
typedef int (ISRAPI *Proc_QISRGetParamW)(const wchar_t* sessionID, const wchar_t* paramName, wchar_t* paramValue, unsigned int* valueLen);
#endif

/** 
 * @fn		QISRWaveformRecog
 * @brief	Recognize a Waveform File
 * 
 *  Recognize a waveform file and return XML result
 * 
 * @return	const char*	- Return rec result in string format, NULL if failed, result is error code.
 * @param	const char* waveFile	- [in] waveform file uri to recognize
 * @param	const char* waveFmt		- [in] waveform format string
 * @param	const char* grammarList	- [in] grammars used by recognizer
 * @param	const char* params		- [in] parameters
 * @param	int *recogStatus		- [out] recognize status
 * @param	int *result				- [out] return 0 on success, otherwise return error code.
 * @see		
 */
const char* ISRAPI QISRWaveformRecog(const char* sessionID, const char* waveFile, const char* waveFmt, const char* grammarList, const char* params, int *recogStatus, int *result);
typedef const char* (ISRAPI *Proc_QISRWaveformRecog)(const char* sessionID, const char* waveFile, const char* waveFmt, const char* grammarList, const char* params, int *recogStatus, int *result);
#ifdef MSP_WCHAR_SUPPORT
const wchar_t* ISRAPI QISRWaveformRecogW(const wchar_t* sessionID, const wchar_t* waveFile, const wchar_t* waveFmt, const wchar_t* grammarList, const wchar_t* params, int *recogStatus, int *result);
typedef const wchar_t* (ISRAPI *Proc_QISRWaveformRecogW)(const wchar_t* sessionID, const wchar_t* waveFile, const wchar_t* waveFmt, const wchar_t* grammarList, const wchar_t* params, int *recogStatus, int *result);
#endif

/*
 * Initialize and fini, these functions is optional.
 * To call them in some cases necessarily.
 */

/** 
 * @fn		QISRInit
 * @brief	Initialize API
 * 
 *  Load API module with specified configurations.
 * 
 * @date	2009/11/26
 * @return	int ISRAPI	- Return 0 in success, otherwise return error code.
 * @param	const char* configs	- [in] configurations to initialize
 * @see		
 */
int ISRAPI QISRInit(const char* configs);
typedef int (ISRAPI *Proc_QISRInit)(const char* configs);
#ifdef MSP_WCHAR_SUPPORT
int ISRAPI QISRInitW(const wchar_t* configs);
typedef int (ISRAPI *Proc_QISRInitW)(const wchar_t* configs);
#endif

/** 
 * @fn		QISRFini
 * @brief	Uninitialize API
 * 
 *  Unload API module, the last function to be called.
 * 
 * @author	jdyu
 * @date	2009/11/26
 * @return	int ISRAPI	- Return 0 in success, otherwise return error code.
 * @see		
 */
int ISRAPI QISRFini(void);
typedef int (ISRAPI *Proc_QISRFini)(void);

/*
 * Internal interface for debugging use.
 * To call them in some cases necessarily.
 */

/** 
 * @fn		QISRLogEvent
 * @brief	Log user events to ISR call-logging
 * 
 *  Logging user events to ISR call-logging, useful to tag user's comments.
 * 
 * @return	int ISRAPI	- Return 0 in success, otherwise return error code.
 * @param	const char* sessionID	- [in] session id returned by session begin
 * @param	const char *event		- [in] event name.
 * @param	const char *value		- [in] event message string.
 * @see		
 */
int ISRAPI QISRLogEvent(const char* sessionID, const char* event, const char* value);
typedef int (ISRAPI *Proc_QISRLogEvent)(const char* sessionID, const char* event, const char* value);
#ifdef MSP_WCHAR_SUPPORT
int ISRAPI QISRLogEventW(const wchar_t* sessionID, const wchar_t* event, const wchar_t* value);
typedef int (ISRAPI *Proc_QISRLogEventW)(const wchar_t* sessionID, const wchar_t* event, const wchar_t* value);
#endif

/** 
 * @fn		QISRInterpret
 * @brief	Recognize a string using activated grammar
 * 
 *  To recognize a user string using activated grammars, and return the recognize result.
 * 
 * @return	int ISRAPI	- Return result string, otherwise return NULL, error code specified by errorCode parameter.
 * @param	const char* sessionID	- [in] session id returned by session begin
 * @param	ISRrecRecognizerStatus *recogStatus		- [out] recognize status.
 * @param	ISRrecResultType *type		- [out] result type.
 * @param	int *errorCode - [out] return error code.
 * @see		
 */
const char* ISRAPI QISRInterpret(const char* sessionID, const wchar_t *sent, ISRrecRecognizerStatus *recogStatus, ISRrecResultType *type, int *errorCode);
typedef const char* (ISRAPI *Proc_QISRInterpret)(const char* sessionID, const wchar_t *sent, ISRrecRecognizerStatus *recogStatus, ISRrecResultType *type, int *errorCode);
#ifdef MSP_WCHAR_SUPPORT
int ISRAPI QISRInterpretW(const wchar_t* sessionID, const wchar_t *sent, ISRrecRecognizerStatus *recogStatus, ISRrecResultType *type, int *errorCode);
typedef int (ISRAPI *Proc_QISRInterpretW)(const wchar_t* sessionID, ISRrecRecognizerStatus *recogStatus, ISRrecResultType *type, int *errorCode);
#endif

#ifdef __cplusplus
} /* extern "C" */
#endif /* C++ */

#endif /* __QISR_H__ */
