/*
 * This file was automatically generated by tecsgen.
 * This file is not intended to be edited.
 */
#ifndef tSIOPortCT11MPCoreMain_TECSGEN_H
#define tSIOPortCT11MPCoreMain_TECSGEN_H

/*
 * celltype          :  tSIOPortCT11MPCoreMain
 * global name       :  tSIOPortCT11MPCoreMain
 * multi-domain      :  no
 * idx_is_id(actual) :  no(no)
 * singleton         :  no
 * has_CB            :  no
 * has_INIB          :  no
 * rom               :  yes
 * CB initializer    :  yes
 */

/* global header #_IGH_# */
#include "global_tecsgen.h"

/* signature header #_ISH_# */
#include "sSIOPort_tecsgen.h"
#include "siSIOCBR_tecsgen.h"
#include "sInterruptRequest_tecsgen.h"

#ifndef TOPPERS_MACRO_ONLY

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */
/* cell CB (dummy) type definition #_CCDP_# */
typedef struct tag_tSIOPortCT11MPCoreMain_CB {
    int  dummy;
} tSIOPortCT11MPCoreMain_CB;
/* singleton cell CB prototype declaration #_MCPB_# */

/* celltype IDX type #_CTIX_# */
typedef int   tSIOPortCT11MPCoreMain_IDX;

/* prototype declaration of entry port function #_EPP_# */
/* sSIOPort */
Inline void         tSIOPortCT11MPCoreMain_eSIOPort_open(tSIOPortCT11MPCoreMain_IDX idx);
Inline void         tSIOPortCT11MPCoreMain_eSIOPort_close(tSIOPortCT11MPCoreMain_IDX idx);
Inline bool_t       tSIOPortCT11MPCoreMain_eSIOPort_putChar(tSIOPortCT11MPCoreMain_IDX idx, char c);
Inline int_t        tSIOPortCT11MPCoreMain_eSIOPort_getChar(tSIOPortCT11MPCoreMain_IDX idx);
Inline void         tSIOPortCT11MPCoreMain_eSIOPort_enableCBR(tSIOPortCT11MPCoreMain_IDX idx, uint_t cbrtn);
Inline void         tSIOPortCT11MPCoreMain_eSIOPort_disableCBR(tSIOPortCT11MPCoreMain_IDX idx, uint_t cbrtn);
/* siSIOCBR */
Inline void         tSIOPortCT11MPCoreMain_eiSIOCBR_readySend(tSIOPortCT11MPCoreMain_IDX idx);
Inline void         tSIOPortCT11MPCoreMain_eiSIOCBR_readyReceive(tSIOPortCT11MPCoreMain_IDX idx);
#ifdef __cplusplus
}
#endif /* __cplusplus */
#endif /* TOPPERS_MACRO_ONLY */

/* to get the definition of CB type of referenced celltype for optimization #_ICT_# */
#ifndef  TOPPERS_CB_TYPE_ONLY
#define  tSIOPortCT11MPCoreMain_CB_TYPE_ONLY
#define TOPPERS_CB_TYPE_ONLY
#endif  /* TOPPERS_CB_TYPE_ONLY */
#include "tSerialPortMain_tecsgen.h"
#include "tUartPL011_tecsgen.h"
#include "tInterruptRequest_tecsgen.h"
#ifdef  tSIOPortCT11MPCoreMain_CB_TYPE_ONLY
#undef TOPPERS_CB_TYPE_ONLY
#endif /* tSIOPortCT11MPCoreMain_CB_TYPE_ONLY */
#define tSIOPortCT11MPCoreMain_ID_BASE        (1)  /* ID Base  #_NIDB_# */
#define tSIOPortCT11MPCoreMain_N_CELL        (1)  /*  number of cells  #_NCEL_# */

/* IDX validation macro #_CVI_# */
#define tSIOPortCT11MPCoreMain_VALID_IDX(IDX) (1)

/* optional call port test macro #_TOCP_# */
#define tSIOPortCT11MPCoreMain_is_ciSIOCBR_joined(p_that) \
	  (1)

/* celll CB macro #_GCB_# */
#define tSIOPortCT11MPCoreMain_GET_CELLCB(idx) ((void *)0)
#ifndef TECSFLOW
 /* call port function macro #_CPM_# */
#define tSIOPortCT11MPCoreMain_ciSIOCBR_readySend( p_that ) \
	  tSerialPortMain_eiSIOCBR_readySend( \
	   &tSerialPortMain_CB_tab[0] )
#define tSIOPortCT11MPCoreMain_ciSIOCBR_readyReceive( p_that ) \
	  tSerialPortMain_eiSIOCBR_readyReceive( \
	   &tSerialPortMain_CB_tab[0] )
#define tSIOPortCT11MPCoreMain_cSIOPort_open( p_that ) \
	  tUartPL011_eSIOPort_open( \
	   &tUartPL011_CB_tab[0] )
#define tSIOPortCT11MPCoreMain_cSIOPort_close( p_that ) \
	  tUartPL011_eSIOPort_close( \
	   &tUartPL011_CB_tab[0] )
#define tSIOPortCT11MPCoreMain_cSIOPort_putChar( p_that, c ) \
	  tUartPL011_eSIOPort_putChar( \
	   &tUartPL011_CB_tab[0], (c) )
#define tSIOPortCT11MPCoreMain_cSIOPort_getChar( p_that ) \
	  tUartPL011_eSIOPort_getChar( \
	   &tUartPL011_CB_tab[0] )
#define tSIOPortCT11MPCoreMain_cSIOPort_enableCBR( p_that, cbrtn ) \
	  tUartPL011_eSIOPort_enableCBR( \
	   &tUartPL011_CB_tab[0], (cbrtn) )
#define tSIOPortCT11MPCoreMain_cSIOPort_disableCBR( p_that, cbrtn ) \
	  tUartPL011_eSIOPort_disableCBR( \
	   &tUartPL011_CB_tab[0], (cbrtn) )
#define tSIOPortCT11MPCoreMain_cInterruptRequest_disable( p_that ) \
	  tInterruptRequest_eInterruptRequest_disable( \
	   &tInterruptRequest_INIB_tab[0] )
#define tSIOPortCT11MPCoreMain_cInterruptRequest_enable( p_that ) \
	  tInterruptRequest_eInterruptRequest_enable( \
	   &tInterruptRequest_INIB_tab[0] )
#define tSIOPortCT11MPCoreMain_cInterruptRequest_clear( p_that ) \
	  tInterruptRequest_eInterruptRequest_clear( \
	   &tInterruptRequest_INIB_tab[0] )
#define tSIOPortCT11MPCoreMain_cInterruptRequest_raise( p_that ) \
	  tInterruptRequest_eInterruptRequest_raise( \
	   &tInterruptRequest_INIB_tab[0] )
#define tSIOPortCT11MPCoreMain_cInterruptRequest_probe( p_that ) \
	  tInterruptRequest_eInterruptRequest_probe( \
	   &tInterruptRequest_INIB_tab[0] )

#else  /* TECSFLOW */
#define tSIOPortCT11MPCoreMain_ciSIOCBR_readySend( p_that ) \
	  (p_that)->ciSIOCBR.readySend__T( \
 )
#define tSIOPortCT11MPCoreMain_ciSIOCBR_readyReceive( p_that ) \
	  (p_that)->ciSIOCBR.readyReceive__T( \
 )
#define tSIOPortCT11MPCoreMain_cSIOPort_open( p_that ) \
	  (p_that)->cSIOPort.open__T( \
 )
#define tSIOPortCT11MPCoreMain_cSIOPort_close( p_that ) \
	  (p_that)->cSIOPort.close__T( \
 )
#define tSIOPortCT11MPCoreMain_cSIOPort_putChar( p_that, c ) \
	  (p_that)->cSIOPort.putChar__T( \
 (c) )
#define tSIOPortCT11MPCoreMain_cSIOPort_getChar( p_that ) \
	  (p_that)->cSIOPort.getChar__T( \
 )
#define tSIOPortCT11MPCoreMain_cSIOPort_enableCBR( p_that, cbrtn ) \
	  (p_that)->cSIOPort.enableCBR__T( \
 (cbrtn) )
#define tSIOPortCT11MPCoreMain_cSIOPort_disableCBR( p_that, cbrtn ) \
	  (p_that)->cSIOPort.disableCBR__T( \
 (cbrtn) )
#define tSIOPortCT11MPCoreMain_cInterruptRequest_disable( p_that ) \
	  (p_that)->cInterruptRequest.disable__T( \
 )
#define tSIOPortCT11MPCoreMain_cInterruptRequest_enable( p_that ) \
	  (p_that)->cInterruptRequest.enable__T( \
 )
#define tSIOPortCT11MPCoreMain_cInterruptRequest_clear( p_that ) \
	  (p_that)->cInterruptRequest.clear__T( \
 )
#define tSIOPortCT11MPCoreMain_cInterruptRequest_raise( p_that ) \
	  (p_that)->cInterruptRequest.raise__T( \
 )
#define tSIOPortCT11MPCoreMain_cInterruptRequest_probe( p_that ) \
	  (p_that)->cInterruptRequest.probe__T( \
 )

#endif /* TECSFLOW */
#ifndef TOPPERS_MACRO_ONLY

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

/* prototype declaration of entry port function (referenced when VMT useless optimise enabled) #_EPSP_# */

#ifdef __cplusplus
}
#endif /* __cplusplus */
#endif /* TOPPERS_MACRO_ONLY */

/* IDX validation macro (abbrev.) #_CVIA_# */
#define VALID_IDX(IDX)  tSIOPortCT11MPCoreMain_VALID_IDX(IDX)


/* cell CB macro (abbrev) #_GCBA_# */
#define GET_CELLCB(idx)  tSIOPortCT11MPCoreMain_GET_CELLCB(idx)

/* CELLCB type (abbrev) #_CCT_# */
#define CELLCB	tSIOPortCT11MPCoreMain_CB

/* celltype IDX type (abbrev) #_CTIXA_# */
#define CELLIDX	tSIOPortCT11MPCoreMain_IDX

/* call port function macro (abbrev) #_CPMA_# */
#define ciSIOCBR_readySend( ) \
          ((void)p_cellcb, tSIOPortCT11MPCoreMain_ciSIOCBR_readySend( p_cellcb ))
#define ciSIOCBR_readyReceive( ) \
          ((void)p_cellcb, tSIOPortCT11MPCoreMain_ciSIOCBR_readyReceive( p_cellcb ))
#define cSIOPort_open( ) \
          ((void)p_cellcb, tSIOPortCT11MPCoreMain_cSIOPort_open( p_cellcb ))
#define cSIOPort_close( ) \
          ((void)p_cellcb, tSIOPortCT11MPCoreMain_cSIOPort_close( p_cellcb ))
#define cSIOPort_putChar( c ) \
          ((void)p_cellcb, tSIOPortCT11MPCoreMain_cSIOPort_putChar( p_cellcb, c ))
#define cSIOPort_getChar( ) \
          ((void)p_cellcb, tSIOPortCT11MPCoreMain_cSIOPort_getChar( p_cellcb ))
#define cSIOPort_enableCBR( cbrtn ) \
          ((void)p_cellcb, tSIOPortCT11MPCoreMain_cSIOPort_enableCBR( p_cellcb, cbrtn ))
#define cSIOPort_disableCBR( cbrtn ) \
          ((void)p_cellcb, tSIOPortCT11MPCoreMain_cSIOPort_disableCBR( p_cellcb, cbrtn ))
#define cInterruptRequest_disable( ) \
          ((void)p_cellcb, tSIOPortCT11MPCoreMain_cInterruptRequest_disable( p_cellcb ))
#define cInterruptRequest_enable( ) \
          ((void)p_cellcb, tSIOPortCT11MPCoreMain_cInterruptRequest_enable( p_cellcb ))
#define cInterruptRequest_clear( ) \
          ((void)p_cellcb, tSIOPortCT11MPCoreMain_cInterruptRequest_clear( p_cellcb ))
#define cInterruptRequest_raise( ) \
          ((void)p_cellcb, tSIOPortCT11MPCoreMain_cInterruptRequest_raise( p_cellcb ))
#define cInterruptRequest_probe( ) \
          ((void)p_cellcb, tSIOPortCT11MPCoreMain_cInterruptRequest_probe( p_cellcb ))



/* optional call port test macro (abbrev) #_TOCPA_# */
#define is_ciSIOCBR_joined()\
		tSIOPortCT11MPCoreMain_is_ciSIOCBR_joined(p_cellcb)

/* entry port function macro (abbrev) #_EPM_# */
#define eSIOPort_open    tSIOPortCT11MPCoreMain_eSIOPort_open
#define eSIOPort_close   tSIOPortCT11MPCoreMain_eSIOPort_close
#define eSIOPort_putChar tSIOPortCT11MPCoreMain_eSIOPort_putChar
#define eSIOPort_getChar tSIOPortCT11MPCoreMain_eSIOPort_getChar
#define eSIOPort_enableCBR tSIOPortCT11MPCoreMain_eSIOPort_enableCBR
#define eSIOPort_disableCBR tSIOPortCT11MPCoreMain_eSIOPort_disableCBR
#define eiSIOCBR_readySend tSIOPortCT11MPCoreMain_eiSIOCBR_readySend
#define eiSIOCBR_readyReceive tSIOPortCT11MPCoreMain_eiSIOCBR_readyReceive

/* iteration code (FOREACH_CELL) (niether CB, nor NIB exit) #_NFEC_# */
#define FOREACH_CELL(i,p_cb)   \
    for((i)=0;(i)<0;(i)++){

#define END_FOREACH_CELL   }

/* CB initialize macro #_CIM_# */
#define INITIALIZE_CB(p_that)	(void)(p_that);
#define SET_CB_INIB_POINTER(i,p_that)\
	/* empty */
#ifndef TOPPERS_MACRO_ONLY

/*  include inline header #_INL_# */
#include "tSIOPortCT11MPCoreMain_inline.h"

#endif /* TOPPERS_MACRO_ONLY */

#ifdef TOPPERS_CB_TYPE_ONLY

/* undef for inline #_UDF_# */
#undef VALID_IDX
#undef GET_CELLCB
#undef CELLCB
#undef CELLIDX
#undef tSIOPortCT11MPCoreMain_IDX
#undef FOREACH_CELL
#undef END_FOREACH_CELL
#undef INITIALIZE_CB
#undef SET_CB_INIB_POINTER
#undef is_ciSIOCBR_joined
#undef tSIOPortCT11MPCoreMain_ciSIOCBR_readySend
#undef ciSIOCBR_readySend
#undef tSIOPortCT11MPCoreMain_ciSIOCBR_readyReceive
#undef ciSIOCBR_readyReceive
#undef tSIOPortCT11MPCoreMain_cSIOPort_open
#undef cSIOPort_open
#undef tSIOPortCT11MPCoreMain_cSIOPort_close
#undef cSIOPort_close
#undef tSIOPortCT11MPCoreMain_cSIOPort_putChar
#undef cSIOPort_putChar
#undef tSIOPortCT11MPCoreMain_cSIOPort_getChar
#undef cSIOPort_getChar
#undef tSIOPortCT11MPCoreMain_cSIOPort_enableCBR
#undef cSIOPort_enableCBR
#undef tSIOPortCT11MPCoreMain_cSIOPort_disableCBR
#undef cSIOPort_disableCBR
#undef tSIOPortCT11MPCoreMain_cInterruptRequest_disable
#undef cInterruptRequest_disable
#undef tSIOPortCT11MPCoreMain_cInterruptRequest_enable
#undef cInterruptRequest_enable
#undef tSIOPortCT11MPCoreMain_cInterruptRequest_clear
#undef cInterruptRequest_clear
#undef tSIOPortCT11MPCoreMain_cInterruptRequest_raise
#undef cInterruptRequest_raise
#undef tSIOPortCT11MPCoreMain_cInterruptRequest_probe
#undef cInterruptRequest_probe
#undef eSIOPort_open
#undef eSIOPort_close
#undef eSIOPort_putChar
#undef eSIOPort_getChar
#undef eSIOPort_enableCBR
#undef eSIOPort_disableCBR
#undef eiSIOCBR_readySend
#undef eiSIOCBR_readyReceive
#endif /* TOPPERS_CB_TYPE_ONLY */

#endif /* tSIOPortCT11MPCoreMain_TECSGENH */
