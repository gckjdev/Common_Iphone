/** 
 * @file	qtts.h
 * @brief   iFLY Speech Synthesizer Header File
 * 
 *  This file contains the quick application programming interface (API) declarations 
 *  of TTS. Developer can include this file in your project to build applications.
 *  For more information, please read the developer guide.
 
 *  Use of this software is subject to certain restrictions and limitations set
 *  forth in a license agreement entered into between iFLYTEK, Co,LTD.
 *  and the licensee of this software.  Please refer to the license
 *  agreement for license use rights and restrictions.
 *
 *  Copyright (C)    1999 - 2009 by ANHUI USTC iFLYTEK, Co,LTD.
 *                   All rights reserved.
 * 
 * @author	Speech Dept.
 * @version	1.0
 * @date	2009/11/26
 * 
 * @see		
 * 
 * <b>History:</b><br>
 * <table>
 *  <tr> <th>Version	<th>Date		<th>Author	<th>Notes</tr>
 *  <tr> <td>1.0		<td>2009/11/26	<td>Speech	<td>Create this file</tr>
 * </table>
 * 
 */
#ifndef __QTTS_H__
#define __QTTS_H__

#include "TTSErrcode.h"
#include "iFly_TTS.h"

#ifdef _UNICODE
#define MSP_WCHAR_SUPPORT 1
#endif

#ifdef __cplusplus
extern "C" {
#endif /* C++ */

/** 
 * @fn		QTTSSessionBegin
 * @brief	Begin a TTS Session
 * 
 *  Create a tts session to synthesize data.
 * 
 * @return	const char* - Return the new session id in success, otherwise return NULL, error code.
 * @param	const char* params			- [in] parameters when the session created.
 * @param	const char** sessionID		- [out] return a string to this session.
 * @see		
 */
TTSLIBAPI const char* QTTSSessionBegin(const char* params, int* errorCode);
typedef const char* (*Proc_QTTSSessionBegin)(const char* params, int* errorCode);
#ifdef MSP_WCHAR_SUPPORT
TTSLIBAPI const wchar_t* QTTSSessionBeginW(const wchar_t* params, int* errorCode);
typedef const wchar_t* (*Proc_QTTSSessionBeginW)(const wchar_t* params, int* errorCode);
#endif

/** 
 * @fn		QTTSTextPut
 * @brief	Put Text Buffer to TTS Session
 * 
 *  Writing text string to synthesizer.
 * 
 * @return	int TTSLIBAPI	- Return 0 in success, otherwise return error code.
 * @param	const char* sessionID	- [in] The session id returned by sesson begin
 * @param	const char* textString	- [in] text buffer
 * @param	unsigned int textLen	- [in] text size in bytes
 * @see		
 */
int TTSLIBAPI QTTSTextPut(const char* sessionID, const char* textString, unsigned int textLen, const char* params);
typedef int (*Proc_QTTSTextPut)(const char* sessionID, const char* textString, unsigned int textLen, const char* params);
#ifdef MSP_WCHAR_SUPPORT
int TTSLIBAPI QTTSTextPutW(const wchar_t* sessionID, const wchar_t* textString, unsigned int textLen, const wchar_t* params);
typedef int (*Proc_QTTSTextPutW)(const wchar_t* sessionID, const wchar_t* textString, unsigned int textLen, const wchar_t* params);
#endif

/** 
 * @fn		QTTSTextSynth
 * @brief	Synthesize text to audio
 * 
 *  Synthesize text to audio, and return audio information.
 * 
 * @return	const void*	- Return current synthesized audio data buffer, size returned by QTTSTextSynth.
 * @param	const char* sessionID	- [in] session id returned by session begin
 * @param	unsigned int* audioLen 	- [out] synthesized audio size in bytes
 * @param	int* synthStatus	- [out] synthesizing status
 * @param	int* errorCode	- [out] error code if failed, 0 to success.
 * @see		
 */
const void* TTSLIBAPI QTTSAudioGet(const char* sessionID, unsigned int* audioLen, int* synthStatus, int* errorCode);
typedef const void* (*Proc_QTTSAudioGet)(const char* sessionID, unsigned int* audioLen, int* synthStatus, int* errorCode);
#ifdef MSP_WCHAR_SUPPORT
const void* TTSLIBAPI QTTSAudioGetW(const wchar_t* sessionID, unsigned int* audioLen, int* synthStatus, int* errorCode);
typedef const void* (*Proc_QTTSAudioGetW)(const wchar_t* sessionID, unsigned int* audioLen, int* synthStatus, int* errorCode);
#endif

/** 
 * @fn		QTTSAudioInfo
 * @brief	Get Synthesized Audio information
 * 
 *  Get synthesized audio data information.
 * 
 * @return	const char * - Return audio info string.
 * @param	const char* sessionID	- [in] session id returned by session begin
 * @see		
 */
const char* TTSLIBAPI QTTSAudioInfo(const char* sessionID);
typedef const char* (*Proc_QTTSAudioInfo)(const char* sessionID);
#ifdef MSP_WCHAR_SUPPORT
const wchar_t* TTSLIBAPI QTTSAudioInfoW(const wchar_t* sessionID);
typedef const wchar_t* (*Proc_QTTSAudioInfoW)(const wchar_t* sessionID);
#endif

/** 
 * @fn		QTTSSessionEnd
 * @brief	End a Recognizer Session
 * 
 *  End the recognizer session, release all resource.
 * 
 * @return	int TTSLIBAPI	- Return 0 in success, otherwise return error code.
 * @param	const char* session_id	- [in] session id string to end
 * @param	const char* hints	- [in] user hints to end session, hints will be logged to CallLog
 * @see		
 */
int TTSLIBAPI QTTSSessionEnd(const char* sessionID, const char* hints);
typedef int (*Proc_QTTSSessionEnd)(const char* sessionID, const char* hints);
#ifdef MSP_WCHAR_SUPPORT
int TTSLIBAPI QTTSSessionEndW(const wchar_t* sessionID, const wchar_t* hints);
typedef int (*Proc_QTTSSessionEndW)(const wchar_t* sessionID, const wchar_t* hints);
#endif

/** 
 * @fn		QTTSGetParam
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
int TTSLIBAPI QTTSGetParam(const char* sessionID, const char* paramName, char* paramValue, unsigned int* valueLen);
typedef int (TTSLIBAPI *Proc_QTTSGetParam)(const char* sessionID, const char* paramName, char* paramValue, unsigned int* valueLen);
#ifdef MSP_WCHAR_SUPPORT
int TTSLIBAPI QTTSGetParamW(const wchar_t* sessionID, const wchar_t* paramName, wchar_t* paramValue, unsigned int* valueLen);
typedef int (TTSLIBAPI *Proc_QTTSGetParamW)(const wchar_t* sessionID, const wchar_t* paramName, wchar_t* paramValue, unsigned int* valueLen);
#endif

/** 
 * @fn		QTTSSynthToFile
 * @brief	Synthesize Text to a Waveform File
 * 
 *  Synthesize the specified text string/file to a waveform file.
 * 
 * @return	int TTSLIBAPI	- Return 0 in success, otherwise return error code.
 * @param	const char* text	- [in] Input text buffer or file
 * @param	int type			- [in] Input text is a text buffer (0) or a text file (1)
 * @param	const char* waveFile	- [in] Output waveform file path name.
 * @param	const char* params	- [in] parameters used in this synthesis.
 * @see		
 */
int TTSLIBAPI QTTSSynthToFile(const char* sessionID, const char* text, int type, const char* waveFile, const char* params);
typedef int (*Proc_QTTSSynthToFile)(const char* sessionID, const char* text, int type, const char* waveFile, const char* params);
#ifdef MSP_WCHAR_SUPPORT
int TTSLIBAPI QTTSSynthToFileW(const wchar_t* sessionID, const wchar_t* text, int type, const wchar_t* waveFile, const wchar_t* params);
typedef int (*Proc_QTTSSynthToFileW)(const wchar_t* sessionID, const wchar_t* text, int type, const wchar_t* waveFile, const wchar_t* params);
#endif

/*
 * Initialize and fini, these functions is optional.
 * To call them in some cases necessarily.
 */

/** 
 * @fn		QTTSInit
 * @brief	Initialize API
 * 
 *  Load API module with specified configurations.
 * 
 * @date	2009/11/26
 * @return	int TTSLIBAPI	- Return 0 in success, otherwise return error code.
 * @param	const char* configs	- [in] configurations to initialize
 * @see		
 */
int TTSLIBAPI QTTSInit(const char* configs);
typedef int (*Proc_QTTSInit)(const char* configs);
#ifdef MSP_WCHAR_SUPPORT
int TTSLIBAPI QTTSInitW(const wchar_t* configs);
typedef int (*Proc_QTTSInitW)(const wchar_t* configs);
#endif

/** 
 * @fn		QTTSFini
 * @brief	Uninitialize API
 * 
 *  Unload API module, the last function to be called.
 * 
 * @author	jdyu
 * @date	2009/11/26
 * @return	int TTSLIBAPI	- Return 0 in success, otherwise return error code.
 * @see		
 */
int TTSLIBAPI QTTSFini(void);
typedef int (*Proc_QTTSFini)(void);

/** 
 * @fn		QTTSLogEvent
 * @brief	Log user events to TTS call-logging
 * 
 *  Logging user events to TTS call-logging, useful to tag user's comments.
 * 
 * @return	int TTSLIBAPI	- Return 0 in success, otherwise return error code.
 * @param	const char* sessionID	- [in] session id returned by session begin
 * @param	const char *event		- [in] event name.
 * @param	const char *value		- [in] event message string.
 * @see		
 */
int TTSLIBAPI QTTSLogEvent(const char* sessionID, const char* event, const char* value);
typedef int (*Proc_QTTSLogEvent)(const char* sessionID, const char* event, const char* value);
#ifdef MSP_WCHAR_SUPPORT
int TTSLIBAPI QTTSLogEventW(const wchar_t* sessionID, const wchar_t* event, const wchar_t* value);
typedef int (*Proc_QTTSLogEventW)(const wchar_t* sessionID, const wchar_t* event, const wchar_t* value);
#endif

#ifdef __cplusplus
} /* extern "C" */
#endif /* C++ */

#endif /* __QTTS_H__ */
