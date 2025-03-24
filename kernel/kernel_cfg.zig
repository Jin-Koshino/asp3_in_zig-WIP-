///
///  システムコンフィギュレーションファイル向けの宣言
///
///
///  コンフィギュレーションオプションの取り込み
///
pub const option = @import("../include/option.zig");

///
///  アプリケーションと共通の定義ファイル
///
pub const zig = @import("kernel");
//usingnamespace zig;

////
const t_stddef = zig.t_stddef;

const ID = t_stddef.ID;
const ATR = t_stddef.ATR;
const STAT = t_stddef.STAT;
const PRI = t_stddef.PRI;
const TMO = t_stddef.TMO;
const EXINF = t_stddef.EXINF;
const RELTIM = t_stddef.RELTIM;
const PRCTIM = t_stddef.PRCTIM;
const castToExinf = t_stddef.castToExinf;
const TA_NULL = t_stddef.TA_NULL;
const FLGPTN = zig.FLGPTN;
const INTNO = zig.INTNO;
const INHNO = zig.INHNO;
const EXCNO = zig.EXCNO;
const TASK = zig.TASK;
const TMEHDR = zig.TMEHDR;
const OVRHDR = zig.OVRHDR;
const ISR = zig.ISR;
const INTHDR = zig.INTHDR;
const EXCHDR = zig.EXCHDR;
const INIRTN = zig.INIRTN;
const TERRTN = zig.TERRTN;
const T_CTSK = zig.T_CTSK;
const T_RTSK = zig.T_RTSK;
const T_CSEM = zig.T_CSEM;
const T_RSEM = zig.T_RSEM;
const T_CFLG = zig.T_CFLG;
const T_RFLG = zig.T_RFLG;
const T_CDTQ = zig.T_CDTQ;
const T_RDTQ = zig.T_RDTQ;
const T_CPDQ = zig.T_CPDQ;
const T_RPDQ = zig.T_RPDQ;
const T_CMTX = zig.T_CMTX;
const T_RMTX = zig.T_RMTX;
const T_CMPF = zig.T_CMPF;
const T_RMPF = zig.T_RMPF;
const T_NFYINFO = zig.T_NFYINFO;
const T_NFYI = zig.T_NFYI;
const T_CCYC = zig.T_CCYC;
const T_RCYC = zig.T_RCYC;
const T_CALM = zig.T_CALM;
const T_RALM = zig.T_RALM;
const T_DOVR = zig.T_DOVR;
const T_ROVR = zig.T_ROVR;
const T_CINT = zig.T_CINT;
const T_CISR = zig.T_CISR;
const T_DINH = zig.T_DINH;
const T_DEXC = zig.T_DEXC;
const T_DICS = zig.T_DICS;
const T_AINI = zig.T_AINI;
const T_ATER = zig.T_ATER;
const TNFY_HANDLER = zig.TNFY_HANDLER;
const TNFY_SETVAR = zig.TNFY_SETVAR;
const TNFY_INCVAR = zig.TNFY_INCVAR;
const TNFY_ACTTSK = zig.TNFY_ACTTSK;
const TNFY_WUPTSK = zig.TNFY_WUPTSK;
const TNFY_SIGSEM = zig.TNFY_SIGSEM;
const TNFY_SETFLG = zig.TNFY_SETFLG;
const TNFY_SNDDTQ = zig.TNFY_SNDDTQ;
const TENFY_SETVAR = zig.TENFY_SETVAR;
const TENFY_INCVAR = zig.TENFY_INCVAR;
const TENFY_ACTTSK = zig.TENFY_ACTTSK;
const TENFY_WUPTSK = zig.TENFY_WUPTSK;
const TENFY_SIGSEM = zig.TENFY_SIGSEM;
const TENFY_SETFLG = zig.TENFY_SETFLG;
const TENFY_SNDDTQ = zig.TENFY_SNDDTQ;
////

///
///  静的APIの記述を楽にするための関数
///
pub fn CTSK(tskatr: ATR, exinf: anytype, task_main: TASK, itskpri: PRI, stksz: usize, stk: ?[*]u8) T_CTSK {
    return T_CTSK{
        .tskatr = tskatr,
        .exinf = comptime castToExinf(exinf),
        .task = task_main,
        .itskpri = itskpri,
        .stksz = stksz,
        .stk = stk,
    };
}

pub fn CSEM(sematr: ATR, isemcnt: c_uint, maxsem: c_uint) T_CSEM {
    return T_CSEM{
        .sematr = sematr,
        .isemcnt = isemcnt,
        .maxsem = maxsem,
    };
}

pub fn CFLG(flgatr: ATR, iflgptn: FLGPTN) T_CFLG {
    return T_CFLG{
        .flgatr = flgatr,
        .iflgptn = iflgptn,
    };
}

pub fn CDTQ(dtqatr: ATR, dtqcnt: c_uint, dtqmb: ?[*]u8) T_CDTQ {
    return T_CDTQ{
        .dtqatr = dtqatr,
        .dtqcnt = dtqcnt,
        .dtqmb = dtqmb,
    };
}

pub fn CPDQ(pdqatr: ATR, pdqcnt: c_uint, maxdpri: PRI, pdqmb: ?[*]u8) T_CPDQ {
    return T_CPDQ{
        .pdqatr = pdqatr,
        .pdqcnt = pdqcnt,
        .maxdpri = maxdpri,
        .pdqmb = pdqmb,
    };
}

pub fn CMTX(mtxatr: ATR, ceilpri: PRI) T_CMTX {
    return T_CMTX{
        .mtxatr = mtxatr,
        .ceilpri = ceilpri,
    };
}

pub fn CMPF(mpfatr: ATR, blkcnt: c_uint, blksz: c_uint, mpf: ?[*]u8, mpfmb: ?[*]u8) T_CMPF {
    return T_CMPF{
        .mpfatr = mpfatr,
        .blkcnt = blkcnt,
        .blksz = blksz,
        .mpf = mpf,
        .mpfmb = mpfmb,
    };
}

pub fn DEXC(excatr: ATR, exchdr: EXCHDR) T_DEXC {
    return T_DEXC{
        .excatr = excatr,
        .exchdr = exchdr,
    };
}

pub fn CCYC(cycatr: ATR, nfyinfo: T_NFYINFO, cyctim: RELTIM, cycphs: RELTIM) T_CCYC {
    return T_CCYC{
        .cycatr = cycatr,
        .nfyinfo = nfyinfo,
        .cyctim = cyctim,
        .cycphs = cycphs,
    };
}

pub fn CALM(almatr: ATR, nfyinfo: T_NFYINFO) T_CALM {
    return T_CALM{
        .almatr = almatr,
        .nfyinfo = nfyinfo,
    };
}

pub fn DOVR(ovratr: ATR, ovrhdr: OVRHDR) T_DOVR {
    return T_DOVR{
        .ovratr = ovratr,
        .ovrhdr = ovrhdr,
    };
}

pub fn CINT(intatr: ATR, intpri: PRI) T_CINT {
    return T_CINT{
        .intatr = intatr,
        .intpri = intpri,
    };
}

pub fn DINH(inhatr: ATR, inthdr: INTHDR) T_DINH {
    return T_DINH{
        .inhatr = inhatr,
        .inthdr = inthdr,
    };
}

pub fn CISR(isratr: ATR, exinf: anytype, intno: INTNO, isr_main: ISR, isrpri: PRI) T_CISR {
    return T_CISR{
        .isratr = isratr,
        .exinf = comptime castToExinf(exinf),
        .intno = intno,
        .isr = isr_main,
        .isrpri = isrpri,
    };
}

pub fn DICS(istksz: usize, comptime istk: *u8) T_DICS {
    const dics = comptime T_DICS{
        .istksz = istksz,
        .istk = istk,
    };
    _ = dics;
}

pub fn AINI(iniatr: ATR, exinf: anytype, inirtn_main: INIRTN) T_AINI {
    return T_AINI{
        .iniatr = iniatr,
        .exinf = comptime castToExinf(exinf),
        .inirtn = inirtn_main,
    };
}

pub fn ATER(teratr: ATR, exinf: anytype, comptime terrtn_main: TERRTN) T_ATER {
    return T_ATER{
        .teratr = teratr,
        .exinf = comptime castToExinf(exinf),
        .terrtn = terrtn_main,
    };
}

pub fn NFY_TMEHDR(comptime exinf: anytype, comptime tmehdr: TMEHDR) T_NFYINFO {
    return T_NFYINFO{ .nfy = .{ .Handler = .{
        .exinf = comptime castToExinf(exinf),
        .tmehdr = @ptrCast(tmehdr),
    } } };
}

pub fn NFYINFO(comptime args: anytype, comptime cfg_data: *CfgData) T_NFYINFO {
    // 通知モードを変数に格納
    const nfymode: u32 = args.@"0";
    const nfymode1 = nfymode & @as(u32, 0x0f);
    const nfymode2 = nfymode & ~@as(u32, 0x0f);

    // 不要なエラー通知処理が設定されている場合［NGKI3721］
    if (nfymode1 == TNFY_HANDLER or nfymode1 == TNFY_SETVAR or nfymode1 == TNFY_INCVAR) {
        if (nfymode2 != 0) {
            @compileError("illegal error notification mode.");
        }
    }

    // 通知処理のパラメータ数を求める
    const numpar =
        if (nfymode1 != TNFY_HANDLER and nfymode1 != TNFY_SETVAR and nfymode1 != TNFY_SETFLG and nfymode1 != TNFY_SNDDTQ) 1 else 2;

    // エラー通知処理のパラメータ数を求める
    const numepar =
        if (nfymode2 == 0) 0 else if (nfymode2 != TENFY_SETFLG) 1 else 2;

    // パラメータが足りない場合
    if (args.len < 1 + numpar + numepar) {
        @compileError("too few parameters for notification information.");
    }

    // パラメータが多すぎる場合
    if (args.len > 1 + numpar + numepar) {
        @compileError("too may parameters for notification information.");
    }

    // 通知処理のパラメータを変数に格納
    const par1 = comptime if (args.len > 1) args.@"1" else null;
    const par2 = comptime if (args.len > 2) args.@"2" else null;

    // エラー通知処理のパラメータを変数に格納
    const epar1 =
        comptime if (numpar == 2) (if (args.len > 3) args.@"3" else null) else (if (args.len > 2) args.@"2" else null);
    const epar2 =
        comptime if (numpar == 2) (if (args.len > 4) args.@"4" else null) else (if (args.len > 3) args.@"3" else null);

    return T_NFYINFO{
        .nfy = switch (nfymode1) {
            TNFY_HANDLER => .{ .Handler = .{
                .exinf = castToExinf(par1),
                .tmehdr = @ptrCast(par2),
            } },
            TNFY_SETVAR => .{ .SetVar = .{
                .p_var = @ptrCast(par1),
                .value = par2,
            } },
            TNFY_INCVAR => .{ .IncVar = .{
                .p_var = @ptrCast(par1),
            } },
            TNFY_ACTTSK => .{ .ActTsk = .{
                .tskid = cfg_data.getTskId(par1),
            } },
            TNFY_WUPTSK => .{ .WupTsk = .{
                .tskid = cfg_data.getTskId(par1),
            } },
            TNFY_SIGSEM => .{ .SigSem = .{
                .semid = cfg_data.getSemId(par1),
            } },
            TNFY_SETFLG => .{ .SetFlg = .{
                .flgid = cfg_data.getFlgId(par1),
                .flgptn = par2,
            } },
            TNFY_SNDDTQ => .{ .SndDtq = .{
                .dtqid = cfg_data.getDtqId(par1),
                .data = par2,
            } },
            else => {
                // 不正な通知モード（E_PAR）［NGKI3730］
                @compileError("illegal notification mode.");
            },
        },
        .enfy = switch (nfymode2) {
            0 => null,
            TENFY_SETVAR => .{ .SetVar = .{
                .p_var = @ptrCast(epar1),
            } },
            TENFY_INCVAR => .{ .IncVar = .{
                .p_var = @ptrCast(epar1),
            } },
            TENFY_ACTTSK => .{ .ActTsk = .{
                .tskid = cfg_data.getTskId(epar1),
            } },
            TENFY_WUPTSK => .{ .WupTsk = .{
                .tskid = cfg_data.getTskId(epar1),
            } },
            TENFY_SIGSEM => .{ .SigSem = .{
                .semid = cfg_data.getSemId(epar1),
            } },
            TENFY_SETFLG => .{ .SetFlg = .{
                .flgid = cfg_data.getFlgId(epar1),
                .flgptn = epar2,
            } },
            TENFY_SNDDTQ => .{ .SndDtq = .{
                .dtqid = cfg_data.getDtqId(epar1),
            } },
            else => {
                // 不正なエラー通知モード（E_PAR）［NGKI3730］
                @compileError("illegal error notification mode.");
            },
        },
    };
}

///
///  静的APIの処理プログラム（コンフィギュレータ）
///
const static_api = @import("static_api.zig");
pub const CfgData = static_api.CfgData;
pub const GenCfgData = static_api.GenCfgData;

///
///  システムコンフィギュレーション記述のターゲット依存部
///
pub const target = @import("../target/ct11mpcore_gcc/target_cfg.zig");

///
///  C言語の変数へのポインタの取り込み
///
///  Zigの機能制限の回避のため（thanks to 河田君）
///
pub fn importSymbol(comptime T: type, comptime name: []const u8) *T {
    return &struct {
        var placeholder: T = undefined;
        comptime {
            @export(placeholder, .{
                .name = name,
                .linkage = .Weak,
                .section = ".discard",
            });
        }
    }.placeholder;
}

///
///  静的APIの読み込みとコンフィギュレーションデータの生成
///
///  genConfigをここで定義することが可能と思われるが，configurationの
///  型が不一致というコンパイルエラーになる（そのためpubにしていない）．
///  コンパイラの不具合ではないかと思われる．
///
fn genConfig(comptime configuration: fn (*CfgData) void) type {
    @setEvalBranchQuota(10000);
    comptime var cfg = CfgData{};
    configuration(&cfg);
    return GenCfgData(&cfg);
}
