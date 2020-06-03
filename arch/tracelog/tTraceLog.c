/*
 *  TOPPERS Software
 *      Toyohashi Open Platform for Embedded Real-Time Systems
 * 
 *  Copyright (C) 2000-2003 by Embedded and Real-Time Systems Laboratory
 *                              Toyohashi Univ. of Technology, JAPAN
 *  Copyright (C) 2005-2020 by Embedded and Real-Time Systems Laboratory
 *              Graduate School of Information Science, Nagoya Univ., JAPAN
 * 
 *  上記著作権者は，以下の(1)〜(4)の条件を満たす場合に限り，本ソフトウェ
 *  ア（本ソフトウェアを改変したものを含む．以下同じ）を使用・複製・改
 *  変・再配布（以下，利用と呼ぶ）することを無償で許諾する．
 *  (1) 本ソフトウェアをソースコードの形で利用する場合には，上記の著作
 *      権表示，この利用条件および下記の無保証規定が，そのままの形でソー
 *      スコード中に含まれていること．
 *  (2) 本ソフトウェアを，ライブラリ形式など，他のソフトウェア開発に使
 *      用できる形で再配布する場合には，再配布に伴うドキュメント（利用
 *      者マニュアルなど）に，上記の著作権表示，この利用条件および下記
 *      の無保証規定を掲載すること．
 *  (3) 本ソフトウェアを，機器に組み込むなど，他のソフトウェア開発に使
 *      用できない形で再配布する場合には，次のいずれかの条件を満たすこ
 *      と．
 *    (a) 再配布に伴うドキュメント（利用者マニュアルなど）に，上記の著
 *        作権表示，この利用条件および下記の無保証規定を掲載すること．
 *    (b) 再配布の形態を，別に定める方法によって，TOPPERSプロジェクトに
 *        報告すること．
 *  (4) 本ソフトウェアの利用により直接的または間接的に生じるいかなる損
 *      害からも，上記著作権者およびTOPPERSプロジェクトを免責すること．
 *      また，本ソフトウェアのユーザまたはエンドユーザからのいかなる理
 *      由に基づく請求からも，上記著作権者およびTOPPERSプロジェクトを
 *      免責すること．
 * 
 *  本ソフトウェアは，無保証で提供されているものである．上記著作権者お
 *  よびTOPPERSプロジェクトは，本ソフトウェアに関して，特定の使用目的
 *  に対する適合性も含めて，いかなる保証も行わない．また，本ソフトウェ
 *  アの利用により直接的または間接的に生じたいかなる損害に関しても，そ
 *  の責任を負わない．
 * 
 *  $Id: tTraceLog.c 1248 2019-07-21 18:08:49Z ertl-hiro $
 */

/*
 *		トレースログ機能
 */

#include "tTraceLog_tecsgen.h"
#include <kernel.h>
#include <sil.h>
#include <log_output.h>
#include "target_syssvc.h"

/*
 *  トレース時刻の取り出し
 *
 *  デフォルトでは，ログ時刻として，高分解能タイマのカウント値を用いて
 *  いる．ターゲット依存で変更する場合には，TRACE_GET_LOGTIMに，ログ時
 *  刻を取り出すマクロを定義する．
 */
#ifndef TRACE_GET_LOGTIM
extern HRTCNT _kernel_target_hrt_get_current(void);
#define TRACE_GET_LOGTIM(p_logtim) \
				(*(p_logtim) = _kernel_target_hrt_get_current())
#endif /* TRACE_GET_TIM */

/*
 *  トレースログの開始（受け口関数）
 */
ER
eTraceLog_start(MODE mode)
{
	if ((mode & TRACE_CLEAR) != 0U) {
		VAR_count = 0U;
		VAR_head = 0U;
		VAR_tail = 0U;
		mode &= ~TRACE_CLEAR;
	}
	VAR_mode = mode;
	return(E_OK);
}     

/* 
 *  トレースログの書込み（受け口関数）
 */
ER
eTraceLog_write(const TRACE *p_trace)
{
	SIL_PRE_LOC;

	if ((VAR_mode & (TRACE_RINGBUF | TRACE_AUTOSTOP)) != 0U) {
		SIL_LOC_INT();

		/*
		 *  トレース時刻の設定
		 */
		TRACE_GET_LOGTIM(&(((SYSLOG *) p_trace)->logtim));

		/*
		 *  トレースバッファに記録
		 */
		VAR_logBuffer[VAR_tail] = *p_trace;
		VAR_tail++;
		if (VAR_tail >= ATTR_logBufferSize) {
			VAR_tail = 0U;
		}
		if (VAR_count < ATTR_logBufferSize) {
			VAR_count++;
			if (VAR_count >= ATTR_logBufferSize
						&& (VAR_mode & TRACE_AUTOSTOP) != 0U) {
				VAR_mode = TRACE_STOP;
			}
		}
		else {
			VAR_head = VAR_tail;
		}

		SIL_UNL_INT();
	}
	return(E_OK);
}

/*
 *  トレースログの読出し（受け口関数）
 */
ER
eTraceLog_read(TRACE* p_trace)
{
	ER_UINT	ercd;
	SIL_PRE_LOC;

	SIL_LOC_INT();

	/*
	 *  トレースログバッファからの取出し
	 */
	if (VAR_count > 0U) {
		*p_trace = VAR_logBuffer[VAR_head];
		VAR_count--;
		VAR_head++;
		if (VAR_head >= ATTR_logBufferSize) {
			VAR_head = 0U;
		}
		ercd = E_OK;
	}
	else {
		ercd = E_OBJ;
	}

	SIL_UNL_INT();
	return(ercd);
}

/* 
 *  カーネル情報の取出し
 */
extern intptr_t _kernel_get_tskid(intptr_t info);
extern intptr_t _kernel_get_tskstat(intptr_t info);
#ifdef TOPPERS_SUPPORT_PROTECT
extern intptr_t _kernel_get_somid(intptr_t info);
extern intptr_t _kernel_get_twd_domid(intptr_t info);
#endif /* TOPPERS_SUPPORT_PROTECT */

/* 
 *  トレースログの表示
 */
static void
trace_print(TRACE *p_trace, void (*putc)(char))
{
	intptr_t	traceinfo[TNUM_LOGPAR + 1];
	const char	*tracemsg;
	int_t		i;

	traceinfo[0] = (intptr_t)(p_trace->logtim);
	syslog_printf("[%d] ", traceinfo, putc);

	switch (p_trace->logtype) {
	case LOG_TYPE_TSKSTAT:
		traceinfo[0] = _kernel_get_tskid(p_trace->logpar[0]);
		traceinfo[1] = _kernel_get_tskstat(p_trace->logpar[1]);
		tracemsg = "task %d becomes %s.";
		break;
	case LOG_TYPE_DSP|LOG_LEAVE:
		traceinfo[0] = _kernel_get_tskid(p_trace->logpar[0]);
		tracemsg = "dispatch to task %d.";
		break;

#ifdef TOPPERS_SUPPORT_PROTECT
	case LOG_TYPE_SCYC|LOG_START:
		traceinfo[0] = _kernel_get_somid(p_trace->logpar[0]);
		tracemsg = "system cycle starts with system operating mode %d.";
		break;
	case LOG_TYPE_TWD|LOG_START:
		if (p_trace->logpar[0] == 0) {
			tracemsg = "idle window starts.";
		}
		else {
			traceinfo[0] = _kernel_get_twd_domid(p_trace->logpar[0]);
			tracemsg = "time window for domain %d starts.";
		}
		break;
#endif /* TOPPERS_SUPPORT_PROTECT */

	case LOG_TYPE_COMMENT:
		for (i = 1; i < TNUM_LOGPAR; i++) {
			traceinfo[i-1] = p_trace->logpar[i];
		}
		tracemsg = (const char *)(p_trace->logpar[0]);
		break;
	case LOG_TYPE_ASSERT:
		traceinfo[0] = p_trace->logpar[0];
		traceinfo[1] = p_trace->logpar[1];
		traceinfo[2] = p_trace->logpar[2];
		tracemsg = "%s:%u: Assertion `%s' failed.";
		break;
	default:
		traceinfo[0] = p_trace->logtype;
		tracemsg = "unknown trace log type: %d.";
		break;
	}
	syslog_printf(tracemsg, traceinfo, putc);
	(*putc)('\n');
}

/*
 *  低レベル出力の呼出し関数
 */
static void
low_putchar(char c)
{
	cPutLog_putChar(c);
}

/*
 *  トレースログのダンプ（受け口関数）
 */
void
eDump_main(uintptr_t exinf)
{
	TRACE	trace;

	while (trace_rea_log(&trace) >= 0) {
		trace_print(&trace, low_putchar);
	}
}
