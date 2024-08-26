/*
 * This file was automatically generated by tecsgen.
 * This file is not intended to be edited.
 */
#ifndef tPutLogSIOPort_TECSGEN_H
#define tPutLogSIOPort_TECSGEN_H

/*
 * celltype          :  tPutLogSIOPort
 * global name       :  tPutLogSIOPort
 * multi-domain      :  no
 * idx_is_id(actual) :  no(no)
 * singleton         :  yes
 * has_CB            :  no
 * has_INIB          :  no
 * rom               :  yes
 * CB initializer    :  yes
 */

/* global header #_IGH_# */
#include "global_tecsgen.h"

/* signature header #_ISH_# */
#include "sPutLog_tecsgen.h"
#include "sSIOPort_tecsgen.h"

#ifndef TOPPERS_MACRO_ONLY

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */
/* cell CB (dummy) type definition #_CCDP_# */
typedef struct tag_tPutLogSIOPort_CB {
    int  dummy;
} tPutLogSIOPort_CB;
/* singleton cell CB prototype declaration #_SCP_# */


/* celltype IDX type #_CTIX_# */
typedef int   tPutLogSIOPort_IDX;

/* prototype declaration of entry port function #_EPP_# */
/* sPutLog */
void         tPutLogSIOPort_ePutLog_putChar( char c);
#ifdef __cplusplus
}
#endif /* __cplusplus */
#endif /* TOPPERS_MACRO_ONLY */

/* to get the definition of CB type of referenced celltype for optimization #_ICT_# */
#ifndef  TOPPERS_CB_TYPE_ONLY
#define  tPutLogSIOPort_CB_TYPE_ONLY
#define TOPPERS_CB_TYPE_ONLY
#endif  /* TOPPERS_CB_TYPE_ONLY */
#include "tSIOPortCT11MPCoreMain_tecsgen.h"
#ifdef  tPutLogSIOPort_CB_TYPE_ONLY
#undef TOPPERS_CB_TYPE_ONLY
#endif /* tPutLogSIOPort_CB_TYPE_ONLY */
#ifndef TOPPERS_CB_TYPE_ONLY


/* celll CB macro #_GCB_# */
#define tPutLogSIOPort_GET_CELLCB(idx) ((void *)0)
#ifndef TECSFLOW
 /* call port function macro #_CPM_# */
#define tPutLogSIOPort_cSIOPort_open( ) \
	  tSIOPortCT11MPCoreMain_eSIOPort_open( \
	   (tSIOPortCT11MPCoreMain_IDX)0 )
#define tPutLogSIOPort_cSIOPort_close( ) \
	  tSIOPortCT11MPCoreMain_eSIOPort_close( \
	   (tSIOPortCT11MPCoreMain_IDX)0 )
#define tPutLogSIOPort_cSIOPort_putChar( c ) \
	  tSIOPortCT11MPCoreMain_eSIOPort_putChar( \
	   (tSIOPortCT11MPCoreMain_IDX)0, (c) )
#define tPutLogSIOPort_cSIOPort_getChar( ) \
	  tSIOPortCT11MPCoreMain_eSIOPort_getChar( \
	   (tSIOPortCT11MPCoreMain_IDX)0 )
#define tPutLogSIOPort_cSIOPort_enableCBR( cbrtn ) \
	  tSIOPortCT11MPCoreMain_eSIOPort_enableCBR( \
	   (tSIOPortCT11MPCoreMain_IDX)0, (cbrtn) )
#define tPutLogSIOPort_cSIOPort_disableCBR( cbrtn ) \
	  tSIOPortCT11MPCoreMain_eSIOPort_disableCBR( \
	   (tSIOPortCT11MPCoreMain_IDX)0, (cbrtn) )

#else  /* TECSFLOW */
#define tPutLogSIOPort_cSIOPort_open( ) \
	  (p_that)->cSIOPort.open__T( \
 )
#define tPutLogSIOPort_cSIOPort_close( ) \
	  (p_that)->cSIOPort.close__T( \
 )
#define tPutLogSIOPort_cSIOPort_putChar( c ) \
	  (p_that)->cSIOPort.putChar__T( \
 (c) )
#define tPutLogSIOPort_cSIOPort_getChar( ) \
	  (p_that)->cSIOPort.getChar__T( \
 )
#define tPutLogSIOPort_cSIOPort_enableCBR( cbrtn ) \
	  (p_that)->cSIOPort.enableCBR__T( \
 (cbrtn) )
#define tPutLogSIOPort_cSIOPort_disableCBR( cbrtn ) \
	  (p_that)->cSIOPort.disableCBR__T( \
 (cbrtn) )

#endif /* TECSFLOW */
#endif /* TOPPERS_CB_TYPE_ONLY */

#ifndef TOPPERS_MACRO_ONLY

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

/* prototype declaration of entry port function (referenced when VMT useless optimise enabled) #_EPSP_# */

#ifndef TOPPERS_CB_TYPE_ONLY

#endif /* TOPPERS_CB_TYPE_ONLY */

#ifdef __cplusplus
}
#endif /* __cplusplus */
#endif /* TOPPERS_MACRO_ONLY */

#ifndef TOPPERS_CB_TYPE_ONLY


/* cell CB macro (abbrev) #_GCBA_# */
#define GET_CELLCB(idx)  tPutLogSIOPort_GET_CELLCB(idx)

/* CELLCB type (abbrev) #_CCT_# */
#define CELLCB	tPutLogSIOPort_CB

/* celltype IDX type (abbrev) #_CTIXA_# */
#define CELLIDX	tPutLogSIOPort_IDX

/* call port function macro (abbrev) #_CPMA_# */
#define cSIOPort_open( ) \
          tPutLogSIOPort_cSIOPort_open( )
#define cSIOPort_close( ) \
          tPutLogSIOPort_cSIOPort_close( )
#define cSIOPort_putChar( c ) \
          tPutLogSIOPort_cSIOPort_putChar( c )
#define cSIOPort_getChar( ) \
          tPutLogSIOPort_cSIOPort_getChar( )
#define cSIOPort_enableCBR( cbrtn ) \
          tPutLogSIOPort_cSIOPort_enableCBR( cbrtn )
#define cSIOPort_disableCBR( cbrtn ) \
          tPutLogSIOPort_cSIOPort_disableCBR( cbrtn )




/* entry port function macro (abbrev) #_EPM_# */
#define ePutLog_putChar  tPutLogSIOPort_ePutLog_putChar

/* CB initialize macro #_CIM_# */
#define INITIALIZE_CB()
#define SET_CB_INIB_POINTER(i,p_that)\
	/* empty */
#endif /* TOPPERS_CB_TYPE_ONLY */

#ifndef TOPPERS_MACRO_ONLY

#endif /* TOPPERS_MACRO_ONLY */

#endif /* tPutLogSIOPort_TECSGENH */
