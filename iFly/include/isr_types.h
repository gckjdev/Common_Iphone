/**
 * @file    isr_types.h
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
 *  Copyright (C)    1999 - 2007 by ANHUI USTC IFLYTEK. Co,LTD.
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

#ifndef __ISR_TYPES_H__
#define __ISR_TYPES_H__

/**
 * C/C++ wchar_t support
 */
# include <wchar.h>

/**
 * ISR handle type
 */
typedef void* ISR_HANDLE;

/**
 * ISR API type
 */
#if defined(_MSC_VER)            /* Microsoft Visual C++ */
  #if !defined(ISRAPI)
    #define ISRAPI __stdcall
  #endif
  #pragma pack(push, 8)
#elif defined(__BORLANDC__)      /* Borland C++ */
  #if !defined(ISRAPI)
    #define ISRAPI __stdcall
  #endif
  #pragma option -a8
#elif defined(__WATCOMC__)       /* Watcom C++ */
  #if !defined(ISRAPI)
    #define ISRAPI __stdcall
  #endif
  #pragma pack(push, 8)
#else                            /* Any other including Unix */
  #if !defined(ISRAPI)
    #define ISRAPI
  #endif
#endif

/**
 * True and false
 */
#ifndef FALSE
#define FALSE		0
#endif	/* FALSE */

#ifndef TRUE
#define TRUE		1
#endif	/* TRUE */

/**
 *  ISRrecSampleStatus indicates how the sample buffer should be handled
 *  ISR_AUDIO_SAMPLE_FIRST The sample buffer is the start of audio
 *                         If recognizer was already recognizing, it will discard
 *                         audio received to date and re-start the recognition
 *  ISR_AUDIO_SAMPLE_CONTINUE The sample buffer is continuing audio
 *  ISR_AUDIO_SAMPLE_LAST The sample buffer is the end of audio
 *                        The recognizer will cease processing audio and
 *                        return results
 *  ISR_AUDIO_SAMPLE_SUPPRESSED The sample buffer contains suppressed samples
 *                              Buffer may be empty; length should indicate
 *                              number of bytes of suppressed data
 *  ISR_AUDIO_SAMPLE_LOST The sample buffer contains lost samples
 *                        Buffer may be empty; length should indicate number of
 *                        bytes of lost data
 *  ISR_AUDIO_SAMPLE_NEW_CHUNK The sample buffer is the start of a new chunk
 *                             (used for magic_word and selective_barge_in)
 *  ISR_AUDIO_SAMPLE_END_CHUNK The sample buffer is the end of a chunk
 *                             (used for magic_word and selective_barge_in)
 *  Note that sample statii can be combined; for example, for file-based input
 *  the entire file can be written with SAMPLE_FIRST | SAMPLE_LAST as the
 *  status.
 *  Other flags may be added in future to indicate other special audio
 *  conditions such as the presence of AGC
 */
enum
{
	ISR_AUDIO_SAMPLE_INIT           = 0x00,
    ISR_AUDIO_SAMPLE_FIRST          = 0x01,
    ISR_AUDIO_SAMPLE_CONTINUE       = 0x02,
    ISR_AUDIO_SAMPLE_LAST           = 0x04,
    ISR_AUDIO_SAMPLE_SUPPRESSED     = 0x08,
    ISR_AUDIO_SAMPLE_LOST           = 0x10,
    ISR_AUDIO_SAMPLE_NEW_CHUNK      = 0x20,
    ISR_AUDIO_SAMPLE_END_CHUNK      = 0x40,

    ISR_AUDIO_SAMPLE_VALIDBITS      = 0x7f /* to validate the value of sample->status */
};


/**
 * Audio sample data
 */
typedef struct ISRAudioSamples
{
    /**
     * Audio sample data.  An audio sample of zero length can be used to
     * indicate last buffer status without including any additional audio
     * samples.
     *
     * @param samples Sample buffer
     * @param len Length of sample buffer, in bytes
     * @param type MEDIA type of samples
     *   "audio/basic" 8-bit 8 KHz u-law encoding [unsigned char *]
     *   "audio/x-alaw-basic" 8-bit 8 KHz A-law encoding [unsigned char *]
     *   "audio/L16;rate=8000" 16-bit 8 KHz linear encoding [short *]
     * @param status Sample status: first buffer, last buffer
     */
    void *          samples;
    unsigned int    len;
    const wchar_t * type;
    int             status;

} ISRAudioSamples;


/**
 * Grammar data detail
 */
typedef struct ISRrecGrammarData
{
    /**
     * Grammar identifier
     *
     * @param type Grammar type ("uri", "uri/2.0", "string", or "string/2.0")
     * @param data 
     *        type uri, uri/2.0: a pointer to the uri
     *        type string: a pointer to the string grammar
     *        type string/2.0: NULL
     * @param media_type 
     *        type uri,string: should be NULL
     *        type string/2.0: "text/xml", "application/srgs+xml", 
     *                         "application/x-isr-grammar"
     *        type uri/2.0: all of the string/2.0 types + NULL
     * @param binary_data
     *        type uri,uri/2.0,string: should be NULL
     *        type string/2.0: a pointer to the data
     * @param binary_length length of binary_data (if set)
     * @param reserved reserved, must be NULL
     */
    const wchar_t * type;
    const wchar_t * data;
    const wchar_t * media_type;
    void *		    binary_data;
    unsigned int    binary_length;
    void *          reserved;

} ISRrecGrammarData;

/* Reset the structure packing alignments for different compilers. */
#if defined(_MSC_VER)            /* Microsoft Visual C++ */
  #pragma pack(pop)
#elif defined(__BORLANDC__)      /* Borland C++ */
  #pragma option -a.
#elif defined(__WATCOMC__)       /* Watcom C++ */
  #pragma pack(pop)
#endif

#endif /* __ISR_TYPES_H__ */
