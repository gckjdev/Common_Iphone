/**
* @file    isr_ep.h
* @brief   iFLY Speech Recognizer Header File
* 
*  This file contains Speech Detector API declarations 
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

#ifndef __ISR_EP_H__
#define __ISR_EP_H__

#include "isr_types.h"
#include "isr_errors.h"

#ifdef __cplusplus
extern "C" {
#endif

/*
 *  Opaque data types
 */
typedef void * ISR_EP_INST;

/*
 * @enum   ISRepStopCode
 * @brief  ISRepStop requires a stop code indicating why the speech detection 
 *         action was terminated. The reason code is used for better
 *         adaptation within a call boundary and to log information
 *         for tuning.
 */
typedef enum
{
    ISR_EP_STOP_SPEECH          = 0, /* Caller used speech */
    ISR_EP_STOP_DTMF            = 1, /* Caller used DTMF */
    ISR_EP_STOP_HANGUP          = 2, /* Caller hung up */
    ISR_EP_STOP_TIMEOUT		    = 4, /* No speech detected; timeout */
    ISR_EP_STOP_OTHER           = 8  /* Other reason not covered above */
} ISRepStopCode;

/*
 * @enum   ISRepMode
 * @brief  endpointer detecting mode 
 */
typedef enum
{
    ISR_EP_BEGIN_END            = 0,
    ISR_EP_BEGIN_ONLY           = 1, /* never returns end */
    ISR_EP_END_ONLY             = 2, /* currently same as BEGIN_END */
    ISR_EP_MAGIC_WORD           = 4,
    ISR_EP_SELECTIVE_BARGEIN    = 5,
    ISR_EP_DISABLED             = -1
} ISRepMode;


/* start of new definitions */

/**
 * The following are generic errors that should always be checked for:
 * ISR_ERROR_SYSTEM_ERROR if a system error has occurred 
 * ISR_ERROR_INVALID_PARAMETER_VALUE if any required parameters are NULL or zero-length strings, etc
 * ISR_ERROR_OUT_OF_MEMORY if a memory allocation failed
 * ISR_ERROR_LICENSE_COMPROMISE license server has been unreachable for
    greater than the allowed "downtime" window (61-89 seconds). Correct the problem by
    by destroying all endpointer instances, shutting down the process using ISRepTerminate(),
    resolving the broken connection to the license server, and restarting the process.
 */

/** Global initialization; should be invoked once at process start-up
 *
 * @return ISR_SUCCESS on success
 * @return ISR_ERROR_NO_LICENSE if no licenses are available
 */
int ISRAPI ISRepOpen(const wchar_t *engine, void *reserved);
typedef int (ISRAPI *Proc_ISRepOpen)(const wchar_t *engine, void *reserved);


/** Global shutdown; should be invoked once at process termination
 *
 * @return ISR_SUCCESS on success
 * @return ISR_ERROR_BUSY if hasn't been initialized
 */
int ISRAPI ISRepClose(void);
typedef int(ISRAPI *Proc_ISRepClose)(void);


/**
 * Allocates endpointer state and structures and initializes the state
 *
 * @param ep Double pointer to detector handle (returned)
 * @param params Not used currently, pass NULL
 *
 * @return ISR_SUCCESS on success
 * @return ISR_ERROR_INIT_STATE_FAILED if license object couldn't be created
 *    (most likely memory allocation or config-related problem)
 * @return ISR_ERROR_NO_LICENSE if all licenses are in use
 * @return ISR_ERROR_GENERIC_ERROR unspecified error
 */
int ISRAPI ISRepDetectorCreate(ISR_EP_INST *ep, const wchar_t *params);
typedef int (ISRAPI *Proc_ISRepDetectorCreate)(ISR_EP_INST *ep, const wchar_t *params);


/**
 * Destroys the endpointer state and buffer structures
 * @param handle Pointer to detector handle
 *
 * @return ISR_SUCCESS on success
 */
int ISRAPI ISRepDetectorDestroy(ISR_EP_INST ep);
typedef int (ISRAPI *Proc_ISRepDetectorDestroy)(ISR_EP_INST ep);


/** Reset acoustic state; must be called at start of each new call
 *
 * @param handle Pointer to detector handle
 *
 * @return ISR_SUCCESS on success
 * @return ISR_ERROR_BUSY if endpointer has already been started
 */
int ISRAPI ISRepStateReset(ISR_EP_INST ep);
typedef int (ISRAPI *Proc_ISRepStateReset)(ISR_EP_INST ep);


/** Query size of acoustic state
 *
 * @param handle Pointer to detector handle
 * @param size Returned size
 *
 * @return ISR_SUCCESS on success
 * @return ISR_ERROR_BUSY if endpointer has already been started
 */
int ISRAPI ISRepStateQuerySize(ISR_EP_INST ep, unsigned int *size);
typedef int (ISRAPI *Proc_ISRepStateQuerySize)(ISR_EP_INST ep, unsigned int *size);


/**
 * Read acoustic state from a memory buffer
 *
 * @param handle Pointer to detector handle
 * @param buffer Pointer to buffer (of size len) that contains data
 * @param len Length of buffer
 *
 * @return ISR_SUCCESS on success
 * @return ISR_ERROR_BUSY if endpointer has already been started
 * @return ISR_ERROR_OVERFLOW if buffer is too small to fit the data
 * @return ISR_ERROR_INVALID_DATA if data is invalid
 */
int ISRAPI ISRepStateLoad(ISR_EP_INST ep, void *buffer, int len);
typedef int (ISRAPI *Proc_ISRepStateLoad)(ISR_EP_INST ep, void *buffer, int len);


/**
 * Save acoustic state to a memory buffer
 *
 * @param handle Pointer to detector handle
 * @param buffer Pointer to buffer (of size len) that contains data
 * @param len Length of buffer
 *
 * @return ISR_SUCCESS on success
 * @return ISR_ERROR_BUSY if endpointer has already been started
 * @return ISRep_ERROR_BUFFER_OVERFLOW if buffer is too small to fit the data
 */
int ISRAPI ISRepStateSave(ISR_EP_INST ep, void *buffer, unsigned int len);
typedef int (ISRAPI *Proc_ISRepStateSave)(ISR_EP_INST ep, void *buffer, unsigned int len);


/**
 * Resets utt-specific state, prepares endpointer for a new utterance
 *
 * @param handle Pointer to detector handle
 *
 * @return ISR_SUCCESS on success
 * @return ISR_ERROR_BUSY if endpointer has already been started
 * @return ISR_ERROR_NO_LICENSE if can't obtain a new license
 *         or no license previously allocated
 */
int ISRAPI ISRepStart(ISR_EP_INST ep);
typedef int (ISRAPI *Proc_ISRepStart)(ISR_EP_INST ep);


/**
* Indicate that the current utterance is complete.
 *
 * @param handle Pointer to detector handle
 * @param code   reason code for terminating the ongoing speech detection action
 * @param hints  RESERVED. Pass NULL.
 *
 * @return ISR_SUCCESS on success
 * @return ISR_ERROR_INACTIVE if endpointer is not active
*/
int ISRAPI ISRepStop(ISR_EP_INST ep, ISRepStopCode code, const wchar_t *hints);
typedef int (ISRAPI *Proc_ISRepStop)(ISR_EP_INST ep, ISRepStopCode code, const wchar_t *hints);


/**
 * Called when the prompt is done playing; affects endpointer thresholds
 *
 * @param handle Pointer to detector handle
 *
 * @return ISR_SUCCESS on success
 * @return ISR_ERROR_INACTIVE if endpointer is not active
 */
int ISRAPI ISRepPromptDone(ISR_EP_INST ep);
typedef int (ISRAPI *Proc_ISRepPromptDone)(ISR_EP_INST ep);


/**
 * Set one of the endpointer parameters wchar_t
 *
 * @param handle Pointer to detector handle
 * @param name name of parameter to set
 * @param value value to set to
 *
 * @return ISR_SUCCESS on success
 * @return ISR_ERROR_BUSY if endpointer has already been started
 * @return ISRep_ERROR_INVALID_PARAMETER_VALUE
 *    - value contains non-ascii chars
 *    - value contains data of wrong type (eg chars instead of ints)
 *    - value is out of range for parameter
 * @return ISRep_ERROR_INVALID_PARAMETER if 'name' is unrecognized param
 */
int ISRAPI ISRepSetParameter(ISR_EP_INST ep, const wchar_t *param, const wchar_t *value);
typedef int (ISRAPI *Proc_ISRepSetParameter)(ISR_EP_INST ep, const wchar_t *param, const wchar_t *value);


/**
 * Get the value for one of the endpointer parameters
 *
 * @param handle Pointer to detector handle
 * @param param name of parameter to set
 * @param value buffer to return parameter value
 * @param len length of buffer
 *
 * @return ISR_SUCCESS on success
 * @return ISR_ERROR_BUSY if endpointer has already been started
 * @return ISRep_ERROR_BUFFER_OVERFLOW if buffer isn't large enough
 * @return ISRep_ERROR_INVALID_PARAMETER if 'param' is unrecognized param
 */
int ISRAPI ISRepGetParameter(ISR_EP_INST ep, wchar_t const *param, wchar_t *value, unsigned int *len);
typedef int (ISRAPI *Proc_ISRepGetParameter)(ISR_EP_INST ep, wchar_t const *param, wchar_t *value, unsigned int *len);


/**
 * The enumeration ISRepState contains the current endpointer state
 *  ISR_EP_LOOKING_FOR_SPEECH Have not yet found the beginning of speech
 *  ISR_EP_IN_SPEECH Have found the beginning, but not the end of speech
 *  ISRep_AFTER_SPEECH Have found the beginning and end of speech
 *  ISRep_AUDIO_ERROR The endpointer has encountered a serious error
 */
typedef enum
{
	ISR_EP_LOOKING_FOR_SPEECH   = 0,
	ISR_EP_IN_SPEECH            = 1,
	ISR_EP_AFTER_SPEECH         = 3,
	ISR_EP_TIMEOUT              = 4,
	ISR_EP_ERROR                = 5,
	ISR_EP_MAX_SPEECH           = 6,
	ISR_EP_IDLE                 = 7  // internal state after stop and before start
} ISRepState;


/**
 * Send in some speech samples; gets back the current endpointer
 * state.  At utterance start, beginSample and endSample are set to -1;
 * whenever they are known, they are set to the proper values, relative to
 * the start of the utterance
 * The amount of begin- and end-of-speech padding used is determined
 * by the relevant endpointer parameters
 *
 * @param handle Pointer to detector handle
 * @param samples audio samples
 * @param state endpointer state (returned)
 * @param beginSample BOS (returned)
 * @param endSample   EOS (returned)
 *
 * @return ISR_SUCCESS on success
 * @return ISR_ERROR_OVERFLOW if # of bytes in packet exceeds max of 4000
 * @return ISR_ERROR_INVALID_MEDIA_TYPE if samples->type is not valid
 * @return ISR_ERROR_INACTIVE if endpointer is not active
 */
int ISRAPI ISRepWrite(ISR_EP_INST ep, ISRAudioSamples *samples, ISRepState *state, int *beginSample, int *endSample);
typedef int (ISRAPI *Proc_ISRepWrite)(ISR_EP_INST ep, ISRAudioSamples *samples, ISRepState *state, int *beginSample, int *endSample);


/**
 * Get speech samples from endpointer's internal buffer
 *
 * @param handle Pointer to detector handle
 * @param samples audio samples (returned)
 * @param state endpointer state (returned)
 * @param maximum length of sample data returned
 *
 * @return ISR_SUCCESS on success
 * @return ISR_ERROR_INVALID_MEDIA_TYPE if samples->type is not valid
 * @return ISR_ERROR_OVERFLOW if # of bytes in packet exceeds maxLen
 */
int ISRAPI ISRepRead(ISR_EP_INST ep, ISRAudioSamples *samples, ISRepState *state, unsigned int maxLen);
typedef int (ISRAPI *Proc_ISRepRead)(ISR_EP_INST ep, ISRAudioSamples *samples, ISRepState *state, unsigned int maxLen);


/**
 * Marks the beginning of a new call boundary.
 * 
 * @param channelName specifies the value for the CHAN token in the call log 
 *                    in all records.  This argument is mandatory,
 *                    it may not be NULL or empty string, and must
 *                    be unique for all Recognizer/Detector handles
 *                    in the process.
 * @param params      RESERVED. Pass NULL.
*/
int ISRAPI ISRepSessionBegin(ISR_EP_INST ep, const wchar_t *channelName, const wchar_t *params);
typedef int (ISRAPI *Proc_ISRepSessionBegin)(ISR_EP_INST ep, const wchar_t *channelName, const wchar_t *params);


/**
 * Marks the end of a call boundary. Event information is written to
 * the call logs for analysis.
 */
int ISRAPI ISRepSessionEnd(ISR_EP_INST ep);
typedef int (ISRAPI *Proc_ISRepSessionEnd)(ISR_EP_INST ep);


#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* __ISR_EP_H__ */
