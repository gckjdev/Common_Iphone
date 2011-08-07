/**
 * @file    isr_rec.h
 * @brief   iFLY Speech Recognizer Header File
 * 
 *  This file contains the application programming interface (API) declarations 
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

#ifndef __ISR_REC_H__
#define __ISR_REC_H__

#include "isr_errors.h"
#include "isr_types.h"

#ifdef __cplusplus
extern "C" {
#endif

/*
 *  Opaque data types
 */

typedef struct ISRrecRecognizer { void *internal_; } ISRrecRecognizer, * ISR_REC_INST;
typedef struct ISRrecResultData { void *internal_; } ISRrecResultData, * ISR_REC_RESULT;


/* -- start recognizer interface -- */

/*
 * The following are generic errors that should always be checked for:
 * ISR_ERROR_NOTINIT if ISRrecInitialize hasn't been called
 * ISR_ERROR_INVALID_PARA if any required parameters are NULL or
 *   zero-length strings, etc
 * ISR_ERROR_OUT_OF_MEMORY if a memory allocation failed
 * Other codes not in isr_error.h  if some
 *   non-memory-allocation OS request fails
 *
 * ISR_ERROR_FAIL unspecified failure
 * ISR_ERROR_GENERAL unspecified error
 * ISR_ERROR_EXCEPTION unspecified fatal error
 */

/**
 * Global initialization.
 * Should be invoked once at process start-up.
 * This function can only be called once per process.
 *
 * @param engine Engine name or path to initialized.
 *
 * @return ISR_SUCCESS on success
 * @return ISR_ERROR_BUSY
 *         if it has been called previously.
 * @return ISR_ERROR_INVALID_LANGUAGE if default language is invalid
 * @return ISRrec_ERROR_INITPROC 
 *      any unspecified error during initialization (e.g. license failure)
 */
int ISRAPI ISRrecInitialize(const wchar_t * engine, void * reserved);
typedef int (ISRAPI * Proc_ISRrecInitialize)(const wchar_t * engine, void * reserved);


/**
 * Global shutdown.
 * Should be invoked once at process termination.
 * This function can only be called once per process.
 * This function can be called even when there are outstanding recognitions.
 *
 * @return ISR_SUCCESS on success
 * @return ISR_ERROR_BUSY
 *         if it has been called previously or ISRrecInit was never called
 */
int ISRAPI ISRrecUninitialize(void);
typedef int (ISRAPI * Proc_ISRrecUninitialize)(void);


/**
 * Create a recognizer resource.
 *
 * @param rec Recognizer handle
 * @param params  Not currently used in local version. Pass NULL.
 *				  In network version, can specify the recognize server address to use,
 *                the address may be "serverAddr=ip:port" or "serverAddr=name:port" format
 *                NULL or empty string will select a server automatic.
 *
 * @return ISR_ERROR_NO_LICENSE
 *         in "default" licensing mode, no more licenses are available
 * @return ISR_SUCCESS on success
 */
int ISRAPI ISRrecRecognizerCreate(ISR_REC_INST *rec, const wchar_t *params);
typedef int (ISRAPI * Proc_ISRrecRecognizerCreate)(ISR_REC_INST *rec, const wchar_t *params);


/**
 * Destroy and de-register a recognizer resource.
 *
 * @param rec Recognizer handle
 *
 * @return ISR_SUCCESS on success
 * @return ISR_ERROR_BUSY
 *         if called while recognition is active.
 */
int ISRAPI ISRrecRecognizerDestroy(ISR_REC_INST rec);
typedef int (ISRAPI * Proc_ISRrecRecognizerDestroy)(ISR_REC_INST rec);


/**
 * Load a complete grammar from a URI or string.
 *    The grammar has to be activated.
 *    The grammar is identified by use of the same URI/string identifier.
 *    There is support for recursive loading of grammars
 *       (i.e. a grammar definition that includes another grammar).
 *    This recursively is handled at the recognizer level (URL fetching).
 *    There is no support for cross-reference grammars
 *    Support for VoiceXML built-in types (e.g., grammar
 *            src=builtin:grammar/digits?length=5).
 *
 * @param rec Recognizer handle
 * @param grammar An object containing the URI and fetch params, or string
 *
 * @return ISR_SUCCESS on success
 * @return ISR_ERROR_BUSY if
 *         called while recognition is active.
 * @return ISR_ERROR_NO_SESSION_NAME if recognizer doesn't have a session 
 *         name
 * @return ISR_ERROR_INVALIDPARA
 *         if grammar type is not valid
 * @return ISR_ERROR_INVALIDPARA if the grammar
 *         sets a config parameter to an invalid value via a <meta> tag".
 * @return ISR_ERROR_INVALID_DATA if data is
 *         not a valid grammar string (for string grammars);
 *         if value of <meta> parameter in the grammar is invalid
 * @return ISRrec_ERROR_URI_NOT_FOUND,URI_TIMEOUT,URI_FETCH_ERROR
 *         A URI fetch that was necessary to complete the task was not found,
 *         or resulted in a timeout or error
 * @return ISR_ERROR_INVALID_DATA if URI
 *         does not point to a valid grammar or if any import URIs do not
 *         point to a valid grammar.
 * @return ISR_ERROR_INVALID_MEDIA_TYPE
 *         if media type supplied in structure or by server is invalid
 * @return ISR_ERROR_INVALID_LANGUAGE
 *         if language specified in grammar or any imports is invalid
 */
int ISRAPI ISRrecGrammarLoad(ISR_REC_INST rec, const ISRrecGrammarData *grammar);
typedef int (ISRAPI * Proc_ISRrecGrammarLoad)(ISR_REC_INST rec, const ISRrecGrammarData *grammar);


/**
 * Compile a grammar to a memory buffer.
 * See GrammarLoad for error return codes when there is an error in the
 * grammar specification.
 *
 * @param rec Recognizer handle
 * @param grammar An object containing the URI and fetch params, or string
 * @param buffer Pointer to compiled grammar
 * @param len_bytes Length (in bytes) of buffer passed in;
 *             if too short, required length will be returned here
 *             and ISR_ERROR_NO_ENOUGH_BUFFER will be returned.
 *
 * @return ISR_SUCCESS on success
 * @return ISR_ERROR_BUSY if called while recognition is active.
 * @return ISR_ERROR_NO_ENOUGH_BUFFER if buffer is too small
 * @return ISR_ERROR_INVALIDPARA
 *         if grammar type is not valid
 * @return ISR_ERROR_INVALID_DATA if data is
 *         not a valid grammar string (for string grammars)
 * @return ISRrec_ERROR_URI_NOT_FOUND,URI_TIMEOUT,URI_FETCH_ERROR
 *         A URI fetch that was necessary to complete the task was not found,
 *         or resulted in a timeout or error
 * @return ISR_ERROR_INVALID_DATA if URI
 *         does not point to a valid grammar or if any import URIs do not
 *         point to a valid grammar.
 * @return ISR_ERROR_INVALID_MEDIA_TYPE
 *         if media type supplied in structure or by server is invalid
 * @return ISR_ERROR_INVALID_LANGUAGE
 *         if language specified in grammar or any imports is invalid
 */
int ISRAPI ISRrecGrammarCompile(ISR_REC_INST rec, const ISRrecGrammarData *grammar, void *buffer, unsigned int *lenBytes);
typedef int (ISRAPI * Proc_ISRrecGrammarCompile)(ISR_REC_INST rec, const ISRrecGrammarData *grammar, void *buffer, unsigned int *lenBytes);


/**
 * Activate a grammar for subsequent recognition calls.
 * More than one grammar can be activated at any given time.
 * The grammar must have been loaded with GrammarLoad().
 * See GrammarLoad for error return codes when there is an error in the grammar
 * specification.
 *
 * @param rec Recognizer handle
 * @param grammar An object containing the URI and fetch params, or string
 * @param weight Relative weight to assign to this grammar vs. other activated
 *               grammars
 * @param grammar_id The ID that is returned for the ISR_grammarName key to
 *               identify which grammar each nbest answer the answer came from
 *
 * @return ISR_SUCCESS on success
 * @return ISR_ERROR_BUSY if
 *         called while recognition is active.
 * @return ISR_ERROR_DUPLICATE_GRAMMAR
 *         if the same grammar has already been activated
 * @return ISR_ERROR_NO_SESSION_NAME if recognizer doesn't have session name
 * @return GrammarLoad-errors 
 *         Grammar activation may cause a grammar load so all those errors may 
 *         be returned.
 */
int ISRAPI ISRrecGrammarActivate(ISR_REC_INST rec, const ISRrecGrammarData *grammar, unsigned int weight, const char *grammarID);
typedef int (ISRAPI * Proc_ISRrecGrammarActivate)(ISR_REC_INST rec, const ISRrecGrammarData *grammar, unsigned int weight, const char *grammarID);


/**
 * Deactivate a loaded grammar for subsequent recognition calls.
 * See GrammarLoad for error return codes when there is an error in the
 * grammar specification.
 *
 * @param rec Recognizer handle
 * @param grammar An object containing the URI and fetch params, or string
 *                NULL deactivates all grammars
 *
 * @return ISR_SUCCESS on success
 * @return ISR_ERROR_BUSY if
 *         called while recognition is active.
 * @return ISR_ERROR_REC_GRAMMAR_NOT_ACTIVATED
 *         if the grammar is not currently active.
 */
int ISRAPI ISRrecGrammarDeactivate(ISR_REC_INST rec, const ISRrecGrammarData *grammar);
typedef int (ISRAPI * Proc_ISRrecGrammarDeactivate)(ISR_REC_INST rec, const ISRrecGrammarData *grammar);


/**
 * Signal rec interface that grammar is no longer needed.
 * The interface can recover resources as it sees fit.
 *
 * @param rec Recognizer handle
 * @param grammar An object containing the URI and fetch params, or string
 *
 * @return ISR_SUCCESS on success
 * @return ISR_ERROR_BUSY if
 *         called while recognition is active.
 * @return ISR_ERROR_NO_SESSION_NAME if recognizer doesn't have a session 
 *         name
 */
int ISRAPI ISRrecGrammarFree(ISR_REC_INST rec, const ISRrecGrammarData *grammar);
typedef int (ISRAPI * Proc_ISRrecGrammarFree)(ISR_REC_INST rec, const ISRrecGrammarData *grammar);


/**
 * Set recognition parameters
 * Parameter values are valid for the during of a single recognition.
 * Must be called before RecognizerStart() and will take effect for the next
 * recognition.
 * Refer to the reference documentation for parameter descriptions
 * and legal values.
 *
 * @param rec Recognizer handle
 * @param param Parameter name
 * @param value String value to set
 *
 * @return ISR_SUCCESS on success
 * @return ISR_ERROR_BUSY if
 *         called while recognition is active.
 * @return ISR_ERROR_INVALIDPARA
 *         if param is not a valid parameter.
 * @return ISR_ERROR_INVALIDPARA
 *         if value is not valid.
 */
int ISRAPI ISRrecRecognizerSetParameter(ISR_REC_INST rec, const wchar_t *param, const wchar_t *value);
typedef int (ISRAPI * Proc_ISRrecRecognizerSetParameter)(ISR_REC_INST rec, const wchar_t *param, const wchar_t *value);


/**
 * Get recognition parameters
 * Parameter values are valid for the during of a single recognition.
 * Not all parameter values may be retrieved
 * Refer to the reference documentation for parameter descriptions
 * and legal values.
 *
 * @param rec Recognizer handle
 * @param param Parameter name
 * @param value Pointer to parameter string retrieved
 * @param len Length of string buffer passed in;
 *             if too short, required length will be returned here
 *             and ISR_ERROR_NO_ENOUGH_BUFFER will be set
 *
 * @return ISR_SUCCESS on success
 * @return ISR_ERROR_NO_ENOUGH_BUFFER when size of value string is too small
 * @return ISR_ERROR_BUSY if
 *         called while recognition is active.
 * @return ISR_ERROR_INVALIDPARA if
 *         param is not a valid parameter.
 */
int ISRAPI ISRrecRecognizerGetParameter(ISR_REC_INST rec, const wchar_t *param, wchar_t *value, unsigned int *len);
typedef int (ISRAPI * Proc_ISRrecRecognizerGetParameter)(ISR_REC_INST rec, const wchar_t *param, wchar_t *value, unsigned int *len);


/**
 * Marks the beginning of a call session.
 * 
 * @param channelName specifies the value for the CHAN token in the call log 
 *                    in all records.  This argument is mandatory, it may not be
 *                    NULL or empty string, and must be unique for all
 *                    Recognizer/Detector handles in the process.
 * @param params	  User parameters to set in the session.
 *					  Can be used in format "param_name=param_value", use comma ',' to set multi-parameters.
 */
int ISRAPI ISRrecSessionBegin(ISR_REC_INST rec, const wchar_t *channelName, const wchar_t *params);
typedef int (ISRAPI * Proc_ISRrecSessionBegin)(ISR_REC_INST rec, const wchar_t *channelName, const wchar_t *params);


/**
 * Marks the end of the call session that began in ISRrecSessionStart().
 */
int ISRAPI ISRrecSessionEnd(ISR_REC_INST rec);
typedef int (ISRAPI * Proc_ISRrecSessionEnd)(ISR_REC_INST rec);


/**
 * Start recognition using currently active grammars, variable bindings,
 * and property values.  This function returns immediately.  Results can
 * be computed by calling RecognizerCompute().
 *
 * @param rec Recognizer handle
 *
 * @return ISR_SUCCESS on success
 * @return ISRrec_ERROR_NO_ACTIVE_GRAMMARS if no grammars have been activated.
 * @return ISR_ERROR_BUSY if
 *         called while recognition is active (RecognizerStart has already
 *         been called without RecognizerStop being called or normal
 *         termination of recognition).
 * @return ISR_ERROR_NO_SESSION_NAME if SetSessionName has not been called.
 * @return ISR_ERROR_NO_LICENSE
 *         if license checkout request fails (JIT mode) or no license checked
 *         out (explicit mode)
 */
int ISRAPI ISRrecRecognizerStart(ISR_REC_INST rec);
typedef int (ISRAPI * Proc_ISRrecRecognizerStart)(ISR_REC_INST rec);


/**
 * Send audio samples to recognizer during recognition.
 * This function returns immediately.
 * The recognizer will return an appropriate audio status event via
 * RecognizerCompute() as soon as one of the following conditions
 * is detected:
 *  - The audio input is definitely not speech.
 *  - The audio input is definitely speech.
 *  - An end-of-speech or max-speech condition has been reached.
 * Only one of the first two state will be returned per recognition.
 * AudioWrite can be called before RecognizerStart.  When RecognizerStart
 * is called, audio buffers are ignored until one is found with
 * ISR_AUDIO_SAMPLE_FIRST.
 *
 * @param rec Recognizer handle
 * @param samples Sample data object
 *
 * @return ISR_SUCCESS on success
 * @return ISR_ERROR_INVALIDPARA
 *         if a. invalid status specified b. samples->len < 0 
 *         c. invalid combination of samples->len, samples->samples, and audio
 *         type
 * @return ISR_ERROR_NO_SESSION_NAME if recognizer doesn't have a session 
 *         name
 * @return ISR_ERROR_NO_ENOUGH_BUFFER samples->len > 4000
 * @return ISR_ERROR_INVALID_MEDIA_TYPE 
 *         if audio-media type is invalid
 */
int ISRAPI ISRrecAudioWrite(ISR_REC_INST rec, ISRAudioSamples *samples);
typedef int (ISRAPI * Proc_ISRrecAudioWrite)(ISR_REC_INST rec, ISRAudioSamples *samples);


/*
 *  The enumeration ISRrecRecognizerStatus contains the recognition status
 *  ISR_REC_STATUS_SUCCESS successful recognition with complete results
 *  ISR_REC_STATUS_NO_MATCH recognition failure or rejected magic word candidate
 *  ISR_REC_STATUS_INCOMPLETE recognizer needs more time to compute results
 *                           partial results may be returned
 *  ISR_REC_STATUS_NON_SPEECH_DETECTED input to date has been identified
 *                                    as not being speech
 *  ISR_REC_STATUS_SPEECH_DETECTED input to date has been identified as speech
 *  ISR_REC_STATUS_SPEECH_COMPLETE recognizer will not process any more speech
 *  ISR_REC_STATUS_MAX_CPU_TIME CPU time limit exceeded
 *  ISR_REC_STATUS_MAX_SPEECH maximum speech length exceeded
 *                           complete results may be returned
 *  ISR_REC_STATUS_STOPPED recognition was stopped
 *  ISR_REC_STATUS_REJECTED magic word chunk rejected due to low confidence
 */
typedef enum
{
	ISR_REC_STATUS_SUCCESS              = 0,
	ISR_REC_STATUS_NO_MATCH             = 1,
	ISR_REC_STATUS_INCOMPLETE			= 2,
	ISR_REC_STATUS_NON_SPEECH_DETECTED  = 3,
	ISR_REC_STATUS_SPEECH_DETECTED      = 4,
	ISR_REC_STATUS_SPEECH_COMPLETE      = 5,
	ISR_REC_STATUS_MAX_CPU_TIME         = 6,
	ISR_REC_STATUS_MAX_SPEECH           = 7,
	ISR_REC_STATUS_STOPPED              = 8,
	ISR_REC_STATUS_REJECTED             = 9,
	ISR_REC_STATUS_NO_SPEECH_FOUND      = 10,
	ISR_REC_STATUS_FAILURE = ISR_REC_STATUS_NO_MATCH,
} ISRrecRecognizerStatus;

/*
 *  The enumeration ISRrecResultType enumerates possible result types
 *  ISR_REC_RESULT_TYPE_COMPLETE complete results from full recognition of
 *    audio
 *  ISR_REC_RESULT_TYPE_PARTIAL partial results if there is a match to grammar
 *   (must be enabled with grammar parameter isrrec_allow_partial_results)
 *  ISR_REC_RESULT_TYPE_NONE no results at this time
 */
typedef enum
{
	ISR_REC_RESULT_TYPE_COMPLETE        = 0,
	ISR_REC_RESULT_TYPE_PARTIAL         = 1,
	ISR_REC_RESULT_TYPE_NONE            = 2
} ISRrecResultType;


/**
 * Compute results for current recognition.
 * Blocks until recognizer produces complete or partial recognition results
 * (as requested); or is halted; or returns an audio status.
 *
 * The results data are valid until the next call to RecognizerStart(),
 * RecognizerCompute(), or ParseDTMFResults().  If the status returned by
 * RecognizerCompute() is SUCCESS, FAILURE, STOPPED, MAX_SPEECH, or
 * MAX_CPU_TIME, and complete results were requested, then subsequent calls
 * to RecognizerCompute() return the same status value until the next call to
 * RecognizerStart().
 *
 * @param rec Recognizer handle
 * @param maxComputeTime Maximum time to compute results during this call
 *                       (in ms of real time); -1 indicates block until
 *                       completion or change in state; 
 * @param status Status of recognition upon completion
 * @param type Type of results returned.
 * @param resultData Result vector containing results of current
 *                   recognition including, recognized string,
 *                   confidence, key/value list w/ confidences.
 *                   Results are only returned if result type is
 *                   PARTIAL or COMPLETE.
 *
 * @return ISR_SUCCESS on success
 * @return ISR_ERROR_REC_GRAMMAR_ERROR
 *         run-time error during grammar parsing (usually ECMAscript bug)
 * @return ISR_ERROR_INVALIDPARA
 *         input parameter maxComputeTime is 0
 * @return ISR_ERROR_REC_INACTIVE if
 *         RecognizerStart has not been called.
 */
int ISRAPI ISRrecRecognizerCompute(ISR_REC_INST rec, int maxComputeTime, ISRrecRecognizerStatus *status, ISRrecResultType *type, ISR_REC_RESULT *resultData);
typedef int (ISRAPI * Proc_ISRrecRecognizerCompute)(ISR_REC_INST rec, int maxComputeTime, ISRrecRecognizerStatus *status, ISRrecResultType *type, ISR_REC_RESULT *resultData);


/**
 * Retrieve the waveform for the last recognition utterance
 * This function will succeed only if isrrec_return_waveform was set for this
 * recognition
 * The waveform is in 8 Khz u-law format
 *
 * @param resultData Results data structure
 * @param type Parameter-value pair indicating what kind of transformation to 
 *             perform on waveform, e.g. 
 *             "silence_suppression=begin+end+interword"
 * @param waveform Pointer to waveform buffer within results data
 * @param len Length of waveform in bytes
 *
 * @return ISR_SUCCESS on success
 * @return ISR_ERROR_NODATA
 *         if waveform saving was not enabled or recognition failed
 */
int ISRAPI ISRrecGetWaveform(ISR_REC_RESULT resultData, const wchar_t *type, void **waveform, unsigned int *len);
typedef int (ISRAPI * Proc_ISRrecGetWaveform)(ISR_REC_RESULT resultData, const wchar_t *type, void **waveform, unsigned int *len);


/*
 *  The enumeration ISRrecParseStatus contains parser status
 *   (for parsing DTMF strings)
 *  ISRrec_PARSE_COMPLETE valid parse, no further input possible
 *  ISRrec_PARSE_VALID_PREFIX valid parse, further input possible
 *  ISRrec_PARSE_INCOMPLETE invalid parse, valid parse possible with
 *                          further input
 *  ISRrec_PARSE_INVALID valid parse not possible
 */
typedef enum
{
	ISR_REC_PARSE_COMPLETE		= 0,
	ISR_REC_PARSE_VALID_PREFIX	= 1,
	ISR_REC_PARSE_INCOMPLETE	= 2,
	ISR_REC_PARSE_INVALID		= 3
} ISRrecParseStatus;


/**
 * Return an XML result
 *
 * As with other result functions, the results are valid until the
 * next call to RecognizerStart(), RecognizerCompute(), or this
 * function again
 *
 * @param resultData Result vector containing results of current recognition 
 *                   including, recognized string, confidence, key/value list
 *                   w/ confidences
 * @param format     Format of the XML grammar
 * @param xmlResult  XML result to be returned
 *
 * @return ISR_SUCCESS on success
 * @return ISR_ERROR_INVALID_MEDIA_TYPE
 *         if format is invalid
 */
int ISRAPI ISRrecGetXMLResult(ISR_REC_RESULT resultData, const wchar_t *format, const wchar_t **xmlResult);
typedef int (ISRAPI * Proc_ISRrecGetXMLResult)(ISR_REC_RESULT resultData, const wchar_t *format, const wchar_t **xmlResult);


/**
 * Parse a DTMF string against the currently active grammars
 * At least one active grammar must specify rules for parsing DTMF input
 * Aborts recognition of speech and discards all audio input
 *
 * The results data are valid until the next call to RecognizerStart(),
 * RecognizerCompute(), or ParseDTMFResults().
 *
 * @param rec Recognizer handle
 * @param str DTMF string
 * @param status Status of parse
 * @param resultData  Result vector containing results of current
 *                    recognition including, recognized string,
 *                    confidence, key/value list w/ confidences
 *
 * @return ISR_SUCCESS on success
 * @return ISR_ERROR_BUSY if
 *         called while recognition is active.
 * @return ISR_ERROR_INVALIDPARA
 *         if str is not a valid DTMF string.
 */
int ISRAPI ISRrecParseDTMFResults(ISR_REC_INST rec, const char *str, ISRrecParseStatus *status, ISR_REC_RESULT *resultData);
typedef int (ISRAPI * Proc_ISRrecParseDTMFResults)(ISR_REC_INST rec, const char *str, ISRrecParseStatus *status, ISR_REC_RESULT *resultData);


/**
 * Write an event and related information into the recognizer event log
 *
 * @param rec Recognizer handle
 * @param event Event name
 * @param value String to be logged.  This value is recommended to be composed 
 *              of a token/value list which matches the recognizer logging
 *              format.
 *
 * @return ISR_SUCCESS on success
 */
int ISRAPI ISRrecLogEvent(ISR_REC_INST rec, const wchar_t *event, const wchar_t *value);
typedef int (ISRAPI * Proc_ISRrecLogEvent)(ISR_REC_INST rec, const wchar_t *event, const wchar_t *value);


/**
 * ISRrecStopCode specifies reasons why the recognizer was stopped
 * 
 * @enum   ISRrecStopCode
 * @brief  The reason code is used for better adaptation within a call boundary 
 *         and to log information for tuning.
 */
typedef enum
{
    ISR_REC_STOP_SPEECH         = 0,  /* Caller used speech */
    ISR_REC_STOP_DTMF           = 1,  /* Caller used DTMF */
    ISR_REC_STOP_HANGUP         = 2,  /* Caller hung up */
    ISR_REC_STOP_TIMEOUT        = 4,  /* No speech detected; timeout */
    ISR_REC_STOP_OTHER          = 8   /* Other reason not covered above */
} ISRrecStopCode;


/**
 * Stop current recognition.
 * Aborts recognition of speech, discards all audio input, and discard all
 * temporary recognition storage for this utterance.
 *
 * This function should be called to interrupt a currently active
 * ISRrecRecognizerCompute() or after ISRrecRecognizerCompute() returns if no
 * more recognition is required on the current utterance.
 * This function must be called before RecognizerStart() can be called unless
 * RecognizerCompute() returned a status (NOT return code) of:
 * SUCCESS, FAILURE, MAX_SPEECH, or MAX_CPU_TIME.
 * Subsequent calls to RecognizerCompute() will return a STOPPED status until
 * RecognizerStart() is called.  Subsequent calls to ParseDTMFResults() are
 * still valid.
 *
 * @param rec Recognizer handle
 * @param code Reason for the stop.  This should be one of: ISRrec_STOP_SPEECH,
 *             ISRrec_STOP_DTMF, ISRrec_STOP_HANGUP, ISRrec_STOP_TIMEOUT, 
 *             ISRrec_STOP_OTHER
 *
 * @return ISR_SUCCESS on success
 * @return ISR_ERROR_INACTIVE if recognition is not active.
 */
int ISRAPI ISRrecRecognizerStop(ISR_REC_INST rec, ISRrecStopCode code);
typedef int (ISRAPI * Proc_ISRrecRecognizerStop)(ISR_REC_INST rec, ISRrecStopCode code);


/**
 * Read the acoustic state from a memory buffer.
 *
 * @param rec Recognizer handle
 * @param buffer Pointer to memory
 * @param len Length of buffer
 *
 * @return ISR_SUCCESS on success
 * @return ISR_ERROR_NO_ENOUGH_BUFFER
 *         if buffer is too small
 * @return ISR_ERROR_BUSY if
 *         called while recognition is active.
 * @return ISR_ERROR_INVALID_DATA if buffer
 *         contents do not represent acoustic state information.
 */
int ISRAPI ISRrecAcousticStateLoad(ISR_REC_INST rec, const void *buffer, unsigned int len);
typedef int (ISRAPI * Proc_ISRrecAcousticStateLoad)(ISR_REC_INST rec, const void *buffer, unsigned int len);


/**
 * Write the acoustic state to a memory buffer.
 *
 * @param rec Recognizer handle
 * @param buffer Pointer to memory
 * @param len Space available in buffer, in bytes
 *
 * @return ISR_SUCCESS on success
 * @return ISR_ERROR_NO_ENOUGH_BUFFER
 *         if buffer is too small
 * @return ISR_ERROR_BUSY if
 *         called while recognition is active.
 */
int ISRAPI ISRrecAcousticStateSave(ISR_REC_INST rec, void *buffer, unsigned int len);
typedef int (ISRAPI * Proc_ISRrecAcousticStateSave)(ISR_REC_INST rec, void *buffer, unsigned int len);


/**
 * Reset acoustic state of a recognizer.
 * Must be called at start of each new call.
 *
 * @param rec Recognizer handle
 *
 * @return ISR_SUCCESS on success
 * @return ISR_ERROR_BUSY if
 *         called while recognition is active.
 */
int ISRAPI ISRrecAcousticStateReset(ISR_REC_INST rec);
typedef int (ISRAPI * Proc_ISRrecAcousticStateReset)(ISR_REC_INST rec);


/**
 * Query size of acoustic state.
 * Should be used to query buffer size for AcousticStateSave.
 *
 * @param rec Recognizer handle
 * @param size Size of acoustic state object
 *
 * @return ISR_SUCCESS on success
 * @return ISR_ERROR_BUSY if
 *         called while recognition is active.
 */
int ISRAPI ISRrecAcousticStateQuerySize(ISR_REC_INST rec, unsigned int *size);
typedef int (ISRAPI * Proc_ISRrecAcousticStateQuerySize)(ISR_REC_INST rec, unsigned int *size);


#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* __ISR_REC_H__ */
