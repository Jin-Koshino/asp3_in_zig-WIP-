/*
 * This file was automatically generated by tecsgen.
 * This file is not intended to be edited.
 */
#ifndef siEventflag_TECSGEN_H
#define siEventflag_TECSGEN_H

/*
 * signature   :  siEventflag
 * global name :  siEventflag
 * context     :  non-task
 */

#ifndef TOPPERS_MACRO_ONLY

/* signature descriptor #_SD_# */
struct tag_siEventflag_VDES {
    struct tag_siEventflag_VMT *VMT;
};

/* signature function table #_SFT_# */
struct tag_siEventflag_VMT {
    ER             (*set__T)( const struct tag_siEventflag_VDES *edp, FLGPTN setPattern );
};

/* signature descriptor #_SDES_# for dynamic join */
#ifndef Descriptor_of_siEventflag_Defined
#define  Descriptor_of_siEventflag_Defined
typedef struct { struct tag_siEventflag_VDES *vdes; } Descriptor( siEventflag );
#endif
#endif /* TOPPERS_MACRO_ONLY */

/* function id */
#define	FUNCID_SIEVENTFLAG_SET                 (1)

#endif /* siEventflag_TECSGEN_H */
