///
///  TOPPERS/ASP Kernel
///      Toyohashi Open Platform for Embedded Real-Time Systems/
///      Advanced Standard Profile Kernel
///
///  Copyright (C) 2000-2003 by Embedded and Real-Time Systems Laboratory
///                                 Toyohashi Univ. of Technology, JAPAN
///  Copyright (C) 2005-2020 by Embedded and Real-Time Systems Laboratory
///                 Graduate School of Informatics, Nagoya Univ., JAPAN
///
///  上記著作権者は，以下の(1)〜(4)の条件を満たす場合に限り，本ソフトウェ
///  ア（本ソフトウェアを改変したものを含む．以下同じ）を使用・複製・改
///  変・再配布（以下，利用と呼ぶ）することを無償で許諾する．
///  (1) 本ソフトウェアをソースコードの形で利用する場合には，上記の著作
///      権表示，この利用条件および下記の無保証規定が，そのままの形でソー
///      スコード中に含まれていること．
///  (2) 本ソフトウェアを，ライブラリ形式など，他のソフトウェア開発に使
///      用できる形で再配布する場合には，再配布に伴うドキュメント（利用
///      者マニュアルなど）に，上記の著作権表示，この利用条件および下記
///      の無保証規定を掲載すること．
///  (3) 本ソフトウェアを，機器に組み込むなど，他のソフトウェア開発に使
///      用できない形で再配布する場合には，次のいずれかの条件を満たすこ
///      と．
///    (a) 再配布に伴うドキュメント（利用者マニュアルなど）に，上記の著
///        作権表示，この利用条件および下記の無保証規定を掲載すること．
///    (b) 再配布の形態を，別に定める方法によって，TOPPERSプロジェクトに
///        報告すること．
///  (4) 本ソフトウェアの利用により直接的または間接的に生じるいかなる損
///      害からも，上記著作権者およびTOPPERSプロジェクトを免責すること．
///      また，本ソフトウェアのユーザまたはエンドユーザからのいかなる理
///      由に基づく請求からも，上記著作権者およびTOPPERSプロジェクトを
///      免責すること．
///
///  本ソフトウェアは，無保証で提供されているものである．上記著作権者お
///  よびTOPPERSプロジェクトは，本ソフトウェアに関して，特定の使用目的
///  に対する適合性も含めて，いかなる保証も行わない．また，本ソフトウェ
///  アの利用により直接的または間接的に生じたいかなる損害に関しても，そ
///  の責任を負わない．
///
///  $Id$
///
///
///  システム時刻管理機能
///
const kernel_impl = @import("kernel_impl.zig");
///usingnamespace time_event;
const time_event = kernel_impl.time_event;
///usingnamespace check;
const check = kernel_impl.check;

////
const zig = kernel_impl.zig;
const t_stddef = zig.t_stddef;

const SYSTIM = t_stddef.SYSTIM;
const ItronError = t_stddef.ItronError;
const traceLog = kernel_impl.traceLog;
const checkContextTaskUnlock = check.checkContextTaskUnlock;
const target_impl = kernel_impl.target_impl;
const update_current_evttim = time_event.update_current_evttim;
const checkContextUnlock = check.checkContextUnlock;
const checkParameter = check.checkParameter;
const TMIN_ADJTIM = zig.TMIN_ADJTIM;
const TMAX_ADJTIM = zig.TMAX_ADJTIM;
const check_adjtim = time_event.check_adjtim;
const EVTTIM = time_event.EVTTIM;
const BOUNDARY_MARGIN = time_event.BOUNDARY_MARGIN;
const set_hrt_event = time_event.set_hrt_event;
const HRTCNT = t_stddef.HRTCNT;
const sil = kernel_impl.sil;
const target_timer = kernel_impl.target_timer;
////

///
///  システム時刻の設定［NGKI3563］
///
pub fn set_tim(systim: SYSTIM) ItronError!void {
    traceLog("setTimEnter", .{systim});
    errdefer |err| traceLog("setTimLeave", .{err});
    try checkContextTaskUnlock(); //［NGKI3564］［NGKI3565］
    {
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpu();
        defer target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpu();

        update_current_evttim(); //［ASPD1059］
        time_event.systim_offset = systim -% time_event.monotonic_evttim; //［ASPD1060］
    }
    traceLog("setTimLeave", .{null});
}

///
///  システム時刻の参照［NGKI2349］
///
pub fn get_tim(p_systim: *SYSTIM) ItronError!void {
    traceLog("getTimEnter", .{p_systim});
    errdefer |err| traceLog("getTimLeave", .{ err, p_systim });
    try checkContextTaskUnlock(); //［NGKI2350］［NGKI2351］
    {
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpu();
        defer target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpu();

        update_current_evttim(); //［ASPD1057］
        p_systim.* = time_event.systim_offset +% time_event.monotonic_evttim; //［ASPD1058］
    }
    traceLog("getTimLeave", .{ null, p_systim });
}

///
///  システム時刻の調整［NGKI3581］
///
pub fn adj_tim(adjtim: i32) ItronError!void {
    traceLog("adjTimEnter", .{adjtim});
    errdefer |err| traceLog("adjTimLeave", .{err});
    try checkContextUnlock(); //［NGKI3583］
    try checkParameter(TMIN_ADJTIM <= adjtim and adjtim <= TMAX_ADJTIM);
    //［NGKI3584］
    {
        target_impl.mpcore_kernel_impl.core_kernel_impl.lockCpu();
        defer target_impl.mpcore_kernel_impl.core_kernel_impl.unlockCpu();

        update_current_evttim(); //［ASPD1051］
        if (check_adjtim(adjtim)) { //［ASPD1052］
            return ItronError.ObjectStateError;
        } else {
            const previous_evttim = time_event.current_evttim;

            if (adjtim > 0) { //［ASPD1053］
                time_event.current_evttim +%= @as(EVTTIM, @intCast(adjtim));
            } else {
                time_event.current_evttim -%= @as(EVTTIM, @intCast(-adjtim));
            }
            time_event.boundary_evttim = time_event.current_evttim -% BOUNDARY_MARGIN;
            //［ASPD1055］
            if (adjtim > 0 and time_event.monotonic_evttim -% previous_evttim < @as(EVTTIM, @intCast(adjtim))) {
                if (time_event.current_evttim < time_event.monotonic_evttim) {
                    time_event.systim_offset +%= @as(SYSTIM, 1) << @bitSizeOf(EVTTIM);
                }
                time_event.monotonic_evttim = time_event.current_evttim; //［ASPD1054］
            }
            if (!time_event.in_signal_time) {
                set_hrt_event();
            }
        }
    }
    traceLog("adjTimLeave", .{null});
}

///
///  高分解能タイマの参照［NGKI3569］
///
pub fn fch_hrt() HRTCNT {
    traceLog("fchHrtEnter", .{});
    const silLock = sil.PRE_LOC();
    sil.LOC_INT(&silLock);
    const hrtcnt = target_timer.hrt.get_current();
    sil.UNL_INT(&silLock);
    traceLog("fchHrtLeave", .{hrtcnt});
    return hrtcnt;
}
