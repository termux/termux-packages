export function srcOver(src, dst, ops = 1) {
    src.a *= ops;
    const a = dst.a + src.a - dst.a * src.a;
    const r = (src.r * src.a + dst.r * dst.a * (1 - src.a)) / a;
    const g = (src.g * src.a + dst.g * dst.a * (1 - src.a)) / a;
    const b = (src.b * src.a + dst.b * dst.a * (1 - src.a)) / a;
    return { r, g, b, a };
}
export function dstOver(src, dst, ops = 1) {
    src.a *= ops;
    const a = dst.a + src.a - dst.a * src.a;
    const r = (dst.r * dst.a + src.r * src.a * (1 - dst.a)) / a;
    const g = (dst.g * dst.a + src.g * src.a * (1 - dst.a)) / a;
    const b = (dst.b * dst.a + src.b * src.a * (1 - dst.a)) / a;
    return { r, g, b, a };
}
export function multiply(src, dst, ops = 1) {
    src.a *= ops;
    const a = dst.a + src.a - dst.a * src.a;
    const sra = src.r * src.a;
    const sga = src.g * src.a;
    const sba = src.b * src.a;
    const dra = dst.r * dst.a;
    const dga = dst.g * dst.a;
    const dba = dst.b * dst.a;
    const r = (sra * dra + sra * (1 - dst.a) + dra * (1 - src.a)) / a;
    const g = (sga * dga + sga * (1 - dst.a) + dga * (1 - src.a)) / a;
    const b = (sba * dba + sba * (1 - dst.a) + dba * (1 - src.a)) / a;
    return { r, g, b, a };
}
export function add(src, dst, ops = 1) {
    src.a *= ops;
    const a = dst.a + src.a - dst.a * src.a;
    const sra = src.r * src.a;
    const sga = src.g * src.a;
    const sba = src.b * src.a;
    const dra = dst.r * dst.a;
    const dga = dst.g * dst.a;
    const dba = dst.b * dst.a;
    const r = (sra + dra) / a;
    const g = (sga + dga) / a;
    const b = (sba + dba) / a;
    return { r, g, b, a };
}
export function screen(src, dst, ops = 1) {
    src.a *= ops;
    const a = dst.a + src.a - dst.a * src.a;
    const sra = src.r * src.a;
    const sga = src.g * src.a;
    const sba = src.b * src.a;
    const dra = dst.r * dst.a;
    const dga = dst.g * dst.a;
    const dba = dst.b * dst.a;
    const r = (sra * dst.a +
        dra * src.a -
        sra * dra +
        sra * (1 - dst.a) +
        dra * (1 - src.a)) /
        a;
    const g = (sga * dst.a +
        dga * src.a -
        sga * dga +
        sga * (1 - dst.a) +
        dga * (1 - src.a)) /
        a;
    const b = (sba * dst.a +
        dba * src.a -
        sba * dba +
        sba * (1 - dst.a) +
        dba * (1 - src.a)) /
        a;
    return { r, g, b, a };
}
export function overlay(src, dst, ops = 1) {
    src.a *= ops;
    const a = dst.a + src.a - dst.a * src.a;
    const sra = src.r * src.a;
    const sga = src.g * src.a;
    const sba = src.b * src.a;
    const dra = dst.r * dst.a;
    const dga = dst.g * dst.a;
    const dba = dst.b * dst.a;
    const r = (2 * dra <= dst.a
        ? 2 * sra * dra + sra * (1 - dst.a) + dra * (1 - src.a)
        : sra * (1 + dst.a) + dra * (1 + src.a) - 2 * dra * sra - dst.a * src.a) /
        a;
    const g = (2 * dga <= dst.a
        ? 2 * sga * dga + sga * (1 - dst.a) + dga * (1 - src.a)
        : sga * (1 + dst.a) + dga * (1 + src.a) - 2 * dga * sga - dst.a * src.a) /
        a;
    const b = (2 * dba <= dst.a
        ? 2 * sba * dba + sba * (1 - dst.a) + dba * (1 - src.a)
        : sba * (1 + dst.a) + dba * (1 + src.a) - 2 * dba * sba - dst.a * src.a) /
        a;
    return { r, g, b, a };
}
export function darken(src, dst, ops = 1) {
    src.a *= ops;
    const a = dst.a + src.a - dst.a * src.a;
    const sra = src.r * src.a;
    const sga = src.g * src.a;
    const sba = src.b * src.a;
    const dra = dst.r * dst.a;
    const dga = dst.g * dst.a;
    const dba = dst.b * dst.a;
    const r = (Math.min(sra * dst.a, dra * src.a) +
        sra * (1 - dst.a) +
        dra * (1 - src.a)) /
        a;
    const g = (Math.min(sga * dst.a, dga * src.a) +
        sga * (1 - dst.a) +
        dga * (1 - src.a)) /
        a;
    const b = (Math.min(sba * dst.a, dba * src.a) +
        sba * (1 - dst.a) +
        dba * (1 - src.a)) /
        a;
    return { r, g, b, a };
}
export function lighten(src, dst, ops = 1) {
    src.a *= ops;
    const a = dst.a + src.a - dst.a * src.a;
    const sra = src.r * src.a;
    const sga = src.g * src.a;
    const sba = src.b * src.a;
    const dra = dst.r * dst.a;
    const dga = dst.g * dst.a;
    const dba = dst.b * dst.a;
    const r = (Math.max(sra * dst.a, dra * src.a) +
        sra * (1 - dst.a) +
        dra * (1 - src.a)) /
        a;
    const g = (Math.max(sga * dst.a, dga * src.a) +
        sga * (1 - dst.a) +
        dga * (1 - src.a)) /
        a;
    const b = (Math.max(sba * dst.a, dba * src.a) +
        sba * (1 - dst.a) +
        dba * (1 - src.a)) /
        a;
    return { r, g, b, a };
}
export function hardLight(src, dst, ops = 1) {
    src.a *= ops;
    const a = dst.a + src.a - dst.a * src.a;
    const sra = src.r * src.a;
    const sga = src.g * src.a;
    const sba = src.b * src.a;
    const dra = dst.r * dst.a;
    const dga = dst.g * dst.a;
    const dba = dst.b * dst.a;
    const r = (2 * sra <= src.a
        ? 2 * sra * dra + sra * (1 - dst.a) + dra * (1 - src.a)
        : sra * (1 + dst.a) + dra * (1 + src.a) - 2 * dra * sra - dst.a * src.a) /
        a;
    const g = (2 * sga <= src.a
        ? 2 * sga * dga + sga * (1 - dst.a) + dga * (1 - src.a)
        : sga * (1 + dst.a) + dga * (1 + src.a) - 2 * dga * sga - dst.a * src.a) /
        a;
    const b = (2 * sba <= src.a
        ? 2 * sba * dba + sba * (1 - dst.a) + dba * (1 - src.a)
        : sba * (1 + dst.a) + dba * (1 + src.a) - 2 * dba * sba - dst.a * src.a) /
        a;
    return { r, g, b, a };
}
export function difference(src, dst, ops = 1) {
    src.a *= ops;
    const a = dst.a + src.a - dst.a * src.a;
    const sra = src.r * src.a;
    const sga = src.g * src.a;
    const sba = src.b * src.a;
    const dra = dst.r * dst.a;
    const dga = dst.g * dst.a;
    const dba = dst.b * dst.a;
    const r = (sra + dra - 2 * Math.min(sra * dst.a, dra * src.a)) / a;
    const g = (sga + dga - 2 * Math.min(sga * dst.a, dga * src.a)) / a;
    const b = (sba + dba - 2 * Math.min(sba * dst.a, dba * src.a)) / a;
    return { r, g, b, a };
}
export function exclusion(src, dst, ops = 1) {
    src.a *= ops;
    const a = dst.a + src.a - dst.a * src.a;
    const sra = src.r * src.a;
    const sga = src.g * src.a;
    const sba = src.b * src.a;
    const dra = dst.r * dst.a;
    const dga = dst.g * dst.a;
    const dba = dst.b * dst.a;
    const r = (sra * dst.a +
        dra * src.a -
        2 * sra * dra +
        sra * (1 - dst.a) +
        dra * (1 - src.a)) /
        a;
    const g = (sga * dst.a +
        dga * src.a -
        2 * sga * dga +
        sga * (1 - dst.a) +
        dga * (1 - src.a)) /
        a;
    const b = (sba * dst.a +
        dba * src.a -
        2 * sba * dba +
        sba * (1 - dst.a) +
        dba * (1 - src.a)) /
        a;
    return { r, g, b, a };
}
export const names = [
    srcOver,
    dstOver,
    multiply,
    add,
    screen,
    overlay,
    darken,
    lighten,
    hardLight,
    difference,
    exclusion,
];
//# sourceMappingURL=composite-modes.js.map