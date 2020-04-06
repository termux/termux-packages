/*
Copyright 1996-2017 Han The Thanh, <thanh@pdftex.org>

This file is part of pdfTeX.

pdfTeX is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

pdfTeX is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
This is based on the patch texlive-poppler-0.59.patch <2017-09-19> at
https://git.archlinux.org/svntogit/packages.git/plain/texlive-bin/trunk
by Arch Linux. A little modifications are made to avoid a crash for
some kind of pdf images, such as figure_missing.pdf in gnuplot.
The poppler should be 0.86.0 or newer versions.
POPPLER_VERSION should be defined.
*/

/* Do this early in order to avoid a conflict between
   MINGW32 <rpcndr.h> defining 'boolean' as 'unsigned char' and
   <kpathsea/types.h> defining Pascal's boolean as 'int'.
*/
#include <w2c/config.h>
#include <kpathsea/lib.h>

#include <stdlib.h>
#include <math.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>

#ifdef POPPLER_VERSION
#include <dirent.h>
#include <poppler-config.h>
#include <goo/GooString.h>
#include <goo/gmem.h>
#include <goo/gfile.h>
#define GString GooString
#else
#error POPPLER_VERSION should be defined.
#endif
#include <assert.h>

#include "Object.h"
#include "Stream.h"
#include "Array.h"
#include "Dict.h"
#include "XRef.h"
#include "Catalog.h"
#include "Link.h"
#include "Page.h"
#include "GfxFont.h"
#include "PDFDoc.h"
#include "GlobalParams.h"
#include "Error.h"

// This file is mostly C and not very much C++; it's just used to interface
// the functions of xpdf, which are written in C++.

extern "C" {
#include <pdftexdir/ptexmac.h>
#include <pdftexdir/pdftex-common.h>

// These functions from pdftex.web gets declared in pdftexcoerce.h in the
// usual web2c way, but we cannot include that file here because C++
// does not allow it.
extern int getpdfsuppresswarningpagegroup(void);
extern integer getpdfsuppressptexinfo(void);
extern integer zround(double);
}

// The prefix "PTEX" for the PDF keys is special to pdfTeX;
// this has been registered with Adobe by Hans Hagen.

#define pdfkeyprefix "PTEX"

#define MASK_SUPPRESS_PTEX_FULLBANNER 0x01
#define MASK_SUPPRESS_PTEX_FILENAME   0x02
#define MASK_SUPPRESS_PTEX_PAGENUMBER 0x04
#define MASK_SUPPRESS_PTEX_INFODICT   0x08

// When copying the Resources of the selected page, all objects are copied
// recusively top-down. Indirect objects however are not fetched during
// copying, but get a new object number from pdfTeX and then will be
// appended into a linked list. Duplicates are checked and removed from the
// list of indirect objects during appending.

enum InObjType {
    objFont,
    objFontDesc,
    objOther
};

struct InObj {
    Ref ref;                    // ref in original PDF
    InObjType type;             // object type
    InObj *next;                // next entry in list of indirect objects
    int num;                    // new object number in output PDF
    fd_entry *fd;               // pointer to /FontDescriptor object structure
    int enc_objnum;             // Encoding for objFont
    int written;                // has it been written to output PDF?
};

struct UsedEncoding {
    int enc_objnum;
    GfxFont *font;
    UsedEncoding *next;
};

static InObj *inObjList;
static UsedEncoding *encodingList;
static bool isInit = false;

// --------------------------------------------------------------------
// Maintain list of open embedded PDF files
// --------------------------------------------------------------------

struct PdfDocument {
    char *file_name;
    PDFDoc *doc;
    XRef *xref;
    InObj *inObjList;
    int occurences;             // number of references to the document; the doc can be
    // deleted when this is negative
    PdfDocument *next;
};

static PdfDocument *pdfDocuments = 0;

static XRef *xref = 0;

// Returns pointer to PdfDocument record for PDF file.
// Creates a new record if it doesn't exist yet.
// xref is made current for the document.

static PdfDocument *find_add_document(char *file_name)
{
    PdfDocument *p = pdfDocuments;
    while (p && strcmp(p->file_name, file_name) != 0)
        p = p->next;
    if (p) {
        xref = p->xref;
        (p->occurences)++;
        return p;
    }
    p = new PdfDocument;
    p->file_name = xstrdup(file_name);
    p->xref = xref = 0;
    p->occurences = 0;
    GString *docName = new GString(p->file_name);
    p->doc = new PDFDoc(docName);       // takes ownership of docName
    if (!p->doc->isOk() || !p->doc->okToPrint()) {
        pdftex_fail("xpdf: reading PDF image failed");
    }
    p->inObjList = 0;
    p->next = pdfDocuments;
    pdfDocuments = p;
    return p;
}

// Deallocate a PdfDocument with all its resources

static void delete_document(PdfDocument * pdf_doc)
{
    PdfDocument **p = &pdfDocuments;
    while (*p && *p != pdf_doc)
        p = &((*p)->next);
    // should not happen:
    if (!*p)
        return;
    // unlink from list
    *p = pdf_doc->next;
    // free pdf_doc's resources
    InObj *r, *n;
    for (r = pdf_doc->inObjList; r != 0; r = n) {
        n = r->next;
        delete r;
    }
    xref = pdf_doc->xref;
    delete pdf_doc->doc;
    xfree(pdf_doc->file_name);
    delete pdf_doc;
}

// --------------------------------------------------------------------

static int addEncoding(GfxFont * gfont)
{
    UsedEncoding *n;
    n = new UsedEncoding;
    n->next = encodingList;
    encodingList = n;
    n->font = gfont;
    n->enc_objnum = pdfnewobjnum();
    return n->enc_objnum;
}

#define addFont(ref, fd, enc_objnum) \
        addInObj(objFont, ref, fd, enc_objnum)

// addFontDesc is only used to avoid writing the original FontDescriptor
// from the PDF file.

#define addFontDesc(ref, fd) \
        addInObj(objFontDesc, ref, fd, 0)

#define addOther(ref) \
        addInObj(objOther, ref, 0, 0)

static int addInObj(InObjType type, Ref ref, fd_entry * fd, int e)
{
    InObj *p, *q, *n = new InObj;
    if (ref.num == 0)
        pdftex_fail("PDF inclusion: invalid reference");
    n->ref = ref;
    n->type = type;
    n->next = 0;
    n->fd = fd;
    n->enc_objnum = e;
    n->written = 0;
    if (inObjList == 0)
        inObjList = n;
    else {
        for (p = inObjList; p != 0; p = p->next) {
            if (p->ref.num == ref.num && p->ref.gen == ref.gen) {
                delete n;
                return p->num;
            }
            q = p;
        }
        // it is important to add new objects at the end of the list,
        // because new objects are being added while the list is being
        // written out.
        q->next = n;
    }
    if (type == objFontDesc)
        n->num = get_fd_objnum(fd);
    else
        n->num = pdfnewobjnum();
    return n->num;
}

#if 0 /* unusewd */
static int getNewObjectNumber(Ref ref)
{
    InObj *p;
    if (inObjList == 0) {
        pdftex_fail("No objects copied yet");
    } else {
        for (p = inObjList; p != 0; p = p->next) {
            if (p->ref.num == ref.num && p->ref.gen == ref.gen) {
                return p->num;
            }
        }
        pdftex_fail("Object not yet copied: %i %i", ref.num, ref.gen);
    }
#ifdef _MSC_VER
    /* Never reached, but without __attribute__((noreturn)) for pdftex_fail()
       MSVC 5.0 requires an int return value.  */
    return -60000;
#endif
}
#endif

static void copyObject(Object *);

static void copyName(char *s)
{
    pdf_puts("/");
    for (; *s != 0; s++) {
        if (isdigit(*s) || isupper(*s) || islower(*s) || *s == '_' ||
            *s == '.' || *s == '-' || *s == '+')
            pdfout(*s);
        else
            pdf_printf("#%.2X", *s & 0xFF);
    }
}

static void copyDictEntry(Object * obj, int i)
{
    Object obj1;
    copyName((char *)obj->dictGetKey(i));
    pdf_puts(" ");
    obj1 = obj->dictGetValNF(i).copy();
    copyObject(&obj1);
    pdf_puts("\n");
}

static void copyDict(Object * obj)
{
    int i, l;
    if (!obj->isDict())
        pdftex_fail("PDF inclusion: invalid dict type <%s>",
                    obj->getTypeName());
    for (i = 0, l = obj->dictGetLength(); i < l; ++i)
        copyDictEntry(obj, i);
}

static void copyFontDict(Object * obj, InObj * r)
{
    int i, l;
    char *key;
    if (!obj->isDict())
        pdftex_fail("PDF inclusion: invalid dict type <%s>",
                    obj->getTypeName());
    pdf_puts("<<\n");
    assert(r->type == objFont); // FontDescriptor is in fd_tree
    for (i = 0, l = obj->dictGetLength(); i < l; ++i) {
        key = (char *)obj->dictGetKey(i);
        if (strncmp("FontDescriptor", key, strlen("FontDescriptor")) == 0
            || strncmp("BaseFont", key, strlen("BaseFont")) == 0
            || strncmp("Encoding", key, strlen("Encoding")) == 0)
            continue;           // skip original values
        copyDictEntry(obj, i);
    }
    // write new FontDescriptor, BaseFont, and Encoding
    pdf_printf("/FontDescriptor %d 0 R\n", get_fd_objnum(r->fd));
    pdf_printf("/BaseFont %d 0 R\n", get_fn_objnum(r->fd));
    pdf_printf("/Encoding %d 0 R\n", r->enc_objnum);
    pdf_puts(">>");
}

static void copyStream(Stream * str)
{
    int c, c2 = 0;
    str->reset();
    while ((c = str->getChar()) != EOF) {
        pdfout(c);
        c2 = c;
    }
    pdflastbyte = c2;
}

static void copyProcSet(Object * obj)
{
    int i, l;
    Object procset;
    if (!obj->isArray())
        pdftex_fail("PDF inclusion: invalid ProcSet array type <%s>",
                    obj->getTypeName());
    pdf_puts("/ProcSet [ ");
    for (i = 0, l = obj->arrayGetLength(); i < l; ++i) {
        procset = obj->arrayGetNF(i).copy();
        if (!procset.isName())
            pdftex_fail("PDF inclusion: invalid ProcSet entry type <%s>",
                        procset.getTypeName());
        copyName((char *)procset.getName());
        pdf_puts(" ");
    }
    pdf_puts("]\n");
}

#define REPLACE_TYPE1C true

static bool embeddableFont(Object * fontdesc)
{
    Object fontfile, ffsubtype;

    if (!fontdesc->isDict())
        return false;
    fontfile = fontdesc->dictLookup("FontFile");
    if (fontfile.isStream())
        return true;
    if (REPLACE_TYPE1C) {
        fontfile = fontdesc->dictLookup("FontFile3");
        if (!fontfile.isStream())
            return false;
        ffsubtype = fontfile.streamGetDict()->lookup("Subtype");
        return ffsubtype.isName() && !strcmp(ffsubtype.getName(), "Type1C");
    }
    return false;
}

static void copyFont(char *tag, Object * fontRef)
{
    Object fontdict, subtype, basefont, fontdescRef, fontdesc, charset,
        stemV;
    GfxFont *gfont;
    fd_entry *fd;
    fm_entry *fontmap;
    // Check whether the font has already been embedded before analysing it.
    InObj *p;
    Ref ref = fontRef->getRef();
    for (p = inObjList; p; p = p->next) {
        if (p->ref.num == ref.num && p->ref.gen == ref.gen) {
            copyName(tag);
            pdf_printf(" %d 0 R ", p->num);
            return;
        }
    }
    // Only handle included Type1 (and Type1C) fonts; anything else will be copied.
    // Type1C fonts are replaced by Type1 fonts, if REPLACE_TYPE1C is true.
    fontdict = fontRef->fetch(xref);
    fontdesc = Object(objNull);
    if (fontdict.isDict()) {
        subtype = fontdict.dictLookup("Subtype");
        basefont = fontdict.dictLookup("BaseFont");
        fontdescRef = fontdict.dictLookupNF("FontDescriptor").copy();
        if (fontdescRef.isRef()) {
            fontdesc = fontdescRef.fetch(xref);
        }
    }
    if (!fixedinclusioncopyfont && fontdict.isDict()
        && subtype.isName()
        && !strcmp(subtype.getName(), "Type1")
        && basefont.isName()
        && fontdescRef.isRef()
        && fontdesc.isDict()
        && embeddableFont(&fontdesc)
        && (fontmap = lookup_fontmap((char *)basefont.getName())) != NULL) {
        // round /StemV value, since the PDF input is a float
        // (see Font Descriptors in PDF reference), but we only store an
        // integer, since we don't want to change the struct.
        stemV = fontdesc.dictLookup("StemV");
        fd = epdf_create_fontdescriptor(fontmap, zround(stemV.getNum()));
        charset = fontdesc.dictLookup("CharSet");
        if (!charset.isNull() &&
            charset.isString() && is_subsetable(fontmap))
            epdf_mark_glyphs(fd, (char *)charset.getString()->c_str());
        else
            embed_whole_font(fd);
        addFontDesc(fontdescRef.getRef(), fd);
        copyName(tag);
        gfont = GfxFont::makeFont(xref, tag, fontRef->getRef(),
                                  fontdict.getDict());
        pdf_printf(" %d 0 R ", addFont(fontRef->getRef(), fd,
                                       addEncoding(gfont)));
    } else {
        copyName(tag);
        pdf_puts(" ");
        copyObject(fontRef);
    }
}

static void copyFontResources(Object * obj)
{
    Object fontRef;
    int i, l;
    if (!obj->isDict())
        pdftex_fail("PDF inclusion: invalid font resources dict type <%s>",
                    obj->getTypeName());
    pdf_puts("/Font << ");
    for (i = 0, l = obj->dictGetLength(); i < l; ++i) {
        fontRef = obj->dictGetValNF(i).copy();
        if (fontRef.isRef())
            copyFont((char *)obj->dictGetKey(i), &fontRef);
        else if (fontRef.isDict()) {   // some programs generate pdf with embedded font object
            copyName((char *)obj->dictGetKey(i));
            pdf_puts(" ");
            copyObject(&fontRef);
        }
        else
            pdftex_fail("PDF inclusion: invalid font in reference type <%s>",
                        fontRef.getTypeName());
    }
    pdf_puts(">>\n");
}

static void copyOtherResources(Object * obj, char *key)
{
    // copies all other resources (write_epdf handles Fonts and ProcSets),

    // if Subtype is present, it must be a name
    if (strcmp("Subtype", key) == 0) {
        if (!obj->isName()) {
            pdftex_warn("PDF inclusion: Subtype in Resources dict is not a name"
                        " (key '%s', type <%s>); ignored.",
                        key, obj->getTypeName());
            return;
        }
    } else if (!obj->isDict()) {
        //FIXME: Write the message only to the log file
        pdftex_warn("PDF inclusion: invalid other resource which is no dict"
                    " (key '%s', type <%s>); ignored.",
                    key, obj->getTypeName());
        return;
    }
    copyName(key);
    pdf_puts(" ");
    copyObject(obj);
}

// Function onverts double to string; very small and very large numbers
// are NOT converted to scientific notation.
// n must be a number or real conforming to the implementation limits
// of PDF as specified in appendix C.1 of the PDF Ref.
// These are:
// maximum value of ints is +2^32
// maximum value of reals is +2^15
// smalles values of reals is 1/(2^16)

static char *convertNumToPDF(double n)
{
    static const int precision = 6;
    static const int fact = (int) 1E6;  // must be 10^precision
    static const double epsilon = 0.5E-6;       // 2epsilon must be 10^-precision
    static char buf[64];
    // handle very small values: return 0
    if (fabs(n) < epsilon) {
        buf[0] = '0';
        buf[1] = '\0';
    } else {
        char ints[64];
        int bindex = 0, sindex = 0;
        int ival, fval;
        // handle the sign part if n is negative
        if (n < 0) {
            buf[bindex++] = '-';
            n = -n;
        }
        n += epsilon;           // for rounding
        // handle the integer part, simply with sprintf
        ival = (int) floor(n);
        n -= ival;
        sprintf(ints, "%d", ival);
        while (ints[sindex] != 0)
            buf[bindex++] = ints[sindex++];
        // handle the fractional part up to 'precision' digits
        fval = (int) floor(n * fact);
        if (fval) {
            // set a dot
            buf[bindex++] = '.';
            sindex = bindex + precision;
            buf[sindex--] = '\0';
            // fill up trailing zeros with the string terminator NULL
            while (((fval % 10) == 0) && (sindex >= bindex)) {
                buf[sindex--] = '\0';
                fval /= 10;
            }
            // fill up the fractional part back to front
            while (sindex >= bindex) {
                buf[sindex--] = (fval % 10) + '0';
                fval /= 10;
            }
        } else
            buf[bindex++] = 0;
    }
    return (char *) buf;
}

static void copyObject(Object * obj)
{
    Object obj1;
    int i, l, c;
    Ref ref;
    char *p;
    GString *s;
    if (obj->isBool()) {
        pdf_printf("%s", obj->getBool()? "true" : "false");
    } else if (obj->isInt()) {
        pdf_printf("%i", obj->getInt());
    } else if (obj->isReal()) {
        pdf_printf("%s", convertNumToPDF(obj->getReal()));
    } else if (obj->isNum()) {
        pdf_printf("%s", convertNumToPDF(obj->getNum()));
    } else if (obj->isString()) {
        s = (GooString *)obj->getString();
        p = (char *)s->c_str();
        l = s->getLength();
        if (strlen(p) == (unsigned int) l) {
            pdf_puts("(");
            for (; *p != 0; p++) {
                c = (unsigned char) *p;
                if (c == '(' || c == ')' || c == '\\')
                    pdf_printf("\\%c", c);
                else if (c < 0x20 || c > 0x7F)
                    pdf_printf("\\%03o", c);
                else
                    pdfout(c);
            }
            pdf_puts(")");
        } else {
            pdf_puts("<");
            for (i = 0; i < l; i++) {
                c = s->getChar(i) & 0xFF;
                pdf_printf("%.2x", c);
            }
            pdf_puts(">");
        }
    } else if (obj->isName()) {
        copyName((char *)obj->getName());
    } else if (obj->isNull()) {
        pdf_puts("null");
    } else if (obj->isArray()) {
        pdf_puts("[");
        for (i = 0, l = obj->arrayGetLength(); i < l; ++i) {
            obj1 = obj->arrayGetNF(i).copy();
            if (!obj1.isName())
                pdf_puts(" ");
            copyObject(&obj1);
        }
        pdf_puts("]");
    } else if (obj->isDict()) {
        pdf_puts("<<\n");
        copyDict(obj);
        pdf_puts(">>");
    } else if (obj->isStream()) {
        pdf_puts("<<\n");
        copyDict(obj->getStream()->getDictObject());
        pdf_puts(">>\n");
        pdf_puts("stream\n");
        copyStream(obj->getStream()->getUndecodedStream());
        pdf_puts("\nendstream");
    } else if (obj->isRef()) {
        ref = obj->getRef();
        if (ref.num == 0) {
            pdftex_fail
                ("PDF inclusion: reference to invalid object"
                 " (is the included pdf broken?)");
        } else
            pdf_printf("%d 0 R", addOther(ref));
    } else {
        pdftex_fail("PDF inclusion: type <%s> cannot be copied",
                    obj->getTypeName());
    }
}

static void writeRefs()
{
    InObj *r;
    for (r = inObjList; r != 0; r = r->next) {
        if (!r->written) {
            r->written = 1;
            Object obj1 = xref->fetch(r->ref.num, r->ref.gen);
            if (r->type == objFont) {
                assert(!obj1.isStream());
                pdfbeginobj(r->num, 2);         // \pdfobjcompresslevel = 2 is for this
                copyFontDict(&obj1, r);
                pdf_puts("\n");
                pdfendobj();
            } else if (r->type != objFontDesc) {        // /FontDescriptor is written via write_fontdescriptor()
                if (obj1.isStream())
                    pdfbeginobj(r->num, 0);
                else
                    pdfbeginobj(r->num, 2);     // \pdfobjcompresslevel = 2 is for this
                copyObject(&obj1);
                pdf_puts("\n");
                pdfendobj();
            }
        }
    }
}

static void writeEncodings()
{
    UsedEncoding *r, *n;
    char *glyphNames[256], *s;
    int i;
    for (r = encodingList; r != 0; r = r->next) {
        for (i = 0; i < 256; i++) {
            if (r->font->isCIDFont()) {
                pdftex_fail
                    ("PDF inclusion: CID fonts are not supported"
                     " (try to disable font replacement to fix this)");
            }
            if ((s = (char *)((Gfx8BitFont *) r->font)->getCharName(i)) != 0)
                glyphNames[i] = s;
            else
                glyphNames[i] = notdef;
        }
        epdf_write_enc(glyphNames, r->enc_objnum);
    }
    for (r = encodingList; r != 0; r = n) {
        n = r->next;
#ifdef POPPLER_VERSION
        r->font->decRefCnt();
#else
#error POPPLER_VERSION should be defined.
#endif
        delete r;
    }
}

// get the pagebox according to the pagebox_spec
static const PDFRectangle *get_pagebox(Page * page, int pagebox_spec)
{
    if (pagebox_spec == pdfboxspecmedia)
        return page->getMediaBox();
    else if (pagebox_spec == pdfboxspeccrop)
        return page->getCropBox();
    else if (pagebox_spec == pdfboxspecbleed)
        return page->getBleedBox();
    else if (pagebox_spec == pdfboxspectrim)
        return page->getTrimBox();
    else if (pagebox_spec == pdfboxspecart)
        return page->getArtBox();
    else
        pdftex_fail("PDF inclusion: unknown value of pagebox spec (%i)",
                    (int) pagebox_spec);
    return page->getMediaBox(); // to make the compiler happy
}


// Reads various information about the PDF and sets it up for later inclusion.
// This will fail if the PDF version of the PDF is higher than
// minor_pdf_version_wanted or page_name is given and can not be found.
// It makes no sense to give page_name _and_ page_num.
// Returns the page number.

int
read_pdf_info(char *image_name, char *page_name, int page_num,
              int pagebox_spec, int major_pdf_version_wanted, int minor_pdf_version_wanted,
              int pdf_inclusion_errorlevel)
{
    PdfDocument *pdf_doc;
    Page *page;
    const PDFRectangle *pagebox;
#ifdef POPPLER_VERSION
    int pdf_major_version_found, pdf_minor_version_found;
#else
#error POPPLER_VERSION should be defined.
#endif
    // initialize
    if (!isInit) {
        globalParams = std::unique_ptr<GlobalParams>(new GlobalParams());
        globalParams->setErrQuiet(false);
        isInit = true;
    }
    // open PDF file
    pdf_doc = find_add_document(image_name);
    epdf_doc = (void *) pdf_doc;

    // check PDF version
    // this works only for PDF 1.x -- but since any versions of PDF newer
    // than 1.x will not be backwards compatible to PDF 1.x, pdfTeX will
    // then have to changed drastically anyway.
#ifdef POPPLER_VERSION
    pdf_major_version_found = pdf_doc->doc->getPDFMajorVersion();
    pdf_minor_version_found = pdf_doc->doc->getPDFMinorVersion();
    if ((pdf_major_version_found > major_pdf_version_wanted)
     || (pdf_minor_version_found > minor_pdf_version_wanted)) {
        const char *msg =
            "PDF inclusion: found PDF version <%d.%d>, but at most version <%d.%d> allowed";
        if (pdf_inclusion_errorlevel > 0) {
            pdftex_fail(msg, pdf_major_version_found, pdf_minor_version_found, major_pdf_version_wanted, minor_pdf_version_wanted);
        } else if (pdf_inclusion_errorlevel < 0) {
            ; /* do nothing */
        } else { /* = 0, give warning */
            pdftex_warn(msg, pdf_major_version_found, pdf_minor_version_found, major_pdf_version_wanted, minor_pdf_version_wanted);
        }
    }
#else
#error POPPLER_VERSION should be defined.
#endif
    epdf_num_pages = pdf_doc->doc->getCatalog()->getNumPages();
    if (page_name) {
        // get page by name
        GString name(page_name);
        std::unique_ptr<LinkDest> link = pdf_doc->doc->findDest(&name);
        if (link == 0 || !link->isOk())
            pdftex_fail("PDF inclusion: invalid destination <%s>", page_name);
        Ref ref = link->getPageRef();
        page_num = pdf_doc->doc->getCatalog()->findPage(ref);
        if (page_num == 0)
            pdftex_fail("PDF inclusion: destination is not a page <%s>",
                        page_name);
    } else {
        // get page by number
        if (page_num <= 0 || page_num > epdf_num_pages)
            pdftex_fail("PDF inclusion: required page does not exist <%i>",
                        epdf_num_pages);
    }
    // get the required page
    page = pdf_doc->doc->getCatalog()->getPage(page_num);

    // get the pagebox (media, crop...) to use.
    pagebox = get_pagebox(page, pagebox_spec);
    if (pagebox->x2 > pagebox->x1) {
        epdf_orig_x = pagebox->x1;
        epdf_width = pagebox->x2 - pagebox->x1;
    } else {
        epdf_orig_x = pagebox->x2;
        epdf_width = pagebox->x1 - pagebox->x2;
    }
    if (pagebox->y2 > pagebox->y1) {
        epdf_orig_y = pagebox->y1;
        epdf_height = pagebox->y2 - pagebox->y1;
    } else {
        epdf_orig_y = pagebox->y2;
        epdf_height = pagebox->y1 - pagebox->y2;
    }

    // get page rotation
    epdf_rotate = page->getRotate() % 360;
    if (epdf_rotate < 0)
        epdf_rotate += 360;

    // page group
    if (page->getGroup() != NULL)
        epdf_has_page_group = 1;    // only flag that page group is present;
                                    // the actual object number will be
                                    // generated in pdftex.web
    else
        epdf_has_page_group = 0;    // no page group present

    pdf_doc->xref = pdf_doc->doc->getXRef();
    return page_num;
}

// writes the current epf_doc.
// Here the included PDF is copied, so most errors that can happen during PDF
// inclusion will arise here.

void write_epdf(void)
{
    Page *page;
    Ref *pageRef;
    Dict *pageDict;
    Object contents, obj1, obj2, pageObj, dictObj;
    Object groupDict;
    bool writeSepGroup = false;
    Object info;
    char *key;
    char s[256];
    int i, l;
    int rotate;
    double scale[6] = { 0, 0, 0, 0, 0, 0 };
    bool writematrix = false;
    int suppress_ptex_info = getpdfsuppressptexinfo();
    static const char *pageDictKeys[] = {
        "LastModified",
        "Metadata",
        "PieceInfo",
        "SeparationInfo",
//         "Group",
//         "Resources",
        NULL
    };

    PdfDocument *pdf_doc = (PdfDocument *) epdf_doc;
    (pdf_doc->occurences)--;
    xref = pdf_doc->xref;
    inObjList = pdf_doc->inObjList;
    encodingList = 0;
    page = pdf_doc->doc->getCatalog()->getPage(epdf_selected_page);
    pageRef = pdf_doc->doc->getCatalog()->getPageRef(epdf_selected_page);
    pageObj = xref->fetch(pageRef->num, pageRef->gen);
    pageDict = pageObj.getDict();
    rotate = page->getRotate();
    const PDFRectangle *pagebox;
    // write the Page header
    pdf_puts("/Type /XObject\n");
    pdf_puts("/Subtype /Form\n");
    pdf_puts("/FormType 1\n");

    // write additional information
    if ((suppress_ptex_info & MASK_SUPPRESS_PTEX_FILENAME) == 0) {
        pdf_printf("/%s.FileName (%s)\n", pdfkeyprefix,
                   convertStringToPDFString(pdf_doc->file_name,
                                            strlen(pdf_doc->file_name)));
    }
    if ((suppress_ptex_info & MASK_SUPPRESS_PTEX_PAGENUMBER) == 0) {
        pdf_printf("/%s.PageNumber %i\n", pdfkeyprefix, (int) epdf_selected_page);
    }
    if ((suppress_ptex_info & MASK_SUPPRESS_PTEX_INFODICT) == 0) {
        info = pdf_doc->doc->getDocInfoNF().copy();
        if (info.isRef()) {
            // the info dict must be indirect (PDF Ref p. 61)
            pdf_printf("/%s.InfoDict ", pdfkeyprefix);
            pdf_printf("%d 0 R\n", addOther(info.getRef()));
        }
    }
    // get the pagebox (media, crop...) to use.
    pagebox = get_pagebox(page, epdf_page_box);

    // handle page rotation
    if (rotate != 0) {
        if (rotate % 90 == 0) {
            // this handles only the simple case: multiple of 90s but these
            // are the only values allowed according to the reference
            // (v1.3, p. 78).
            // the image is rotated around its center.
            // the /Rotate key is clockwise while the matrix is
            // counterclockwise :-%
            tex_printf(", page is rotated %d degrees", rotate);
            switch (rotate) {
            case 90:
                scale[1] = -1;
                scale[2] = 1;
                scale[4] = pagebox->x1 - pagebox->y1;
                scale[5] = pagebox->y1 + pagebox->x2;
                writematrix = true;
                break;
            case 180:
                scale[0] = scale[3] = -1;
                scale[4] = pagebox->x1 + pagebox->x2;
                scale[5] = pagebox->y1 + pagebox->y2;
                writematrix = true;
                break;          // width and height are exchanged
            case 270:
                scale[1] = 1;
                scale[2] = -1;
                scale[4] = pagebox->x1 + pagebox->y2;
                scale[5] = pagebox->y1 - pagebox->x1;
                writematrix = true;
                break;
            }
            if (writematrix) {  // The matrix is only written if the image is rotated.
                sprintf(s, "/Matrix [%.8f %.8f %.8f %.8f %.8f %.8f]\n",
                        scale[0],
                        scale[1], scale[2], scale[3], scale[4], scale[5]);
                pdf_puts(stripzeros(s));
            }
        }
    }

    sprintf(s, "/BBox [%.8f %.8f %.8f %.8f]\n",
            pagebox->x1, pagebox->y1, pagebox->x2, pagebox->y2);
    pdf_puts(stripzeros(s));

    // Metadata validity check (as a stream it must be indirect)
    dictObj = pageDict->lookupNF("Metadata").copy();
    if (!dictObj.isNull() && !dictObj.isRef())
        pdftex_warn("PDF inclusion: /Metadata must be indirect object");

    // copy selected items in Page dictionary except Resources & Group
    for (i = 0; pageDictKeys[i] != NULL; i++) {
        dictObj = pageDict->lookupNF(pageDictKeys[i]).copy();
        if (!dictObj.isNull()) {
            pdf_newline();
            pdf_printf("/%s ", pageDictKeys[i]);
            copyObject(&dictObj); // preserves indirection
        }
    } 

    // handle page group
    dictObj = pageDict->lookupNF("Group").copy();
    if (!dictObj.isNull()) {
        if (pdfpagegroupval == 0) { 
            // another pdf with page group was included earlier on the
            // same page; copy the Group entry as is.  See manual for
            // info on why this is a warning.
            if (getpdfsuppresswarningpagegroup() == 0) {
                pdftex_warn
    ("PDF inclusion: multiple pdfs with page group included in a single page");
            }
            pdf_newline();
            pdf_puts("/Group ");
            copyObject(&dictObj);
        } else {
            // write Group dict as a separate object, since the Page dict also refers to it
            dictObj = pageDict->lookup("Group");
            if (!dictObj.isDict())
                pdftex_fail("PDF inclusion: /Group dict missing");
            writeSepGroup = true;
/*
This part is only a single line
            groupDict = Object(page->getGroup());
in the original patch. In this case, however, pdftex crashes at
"delete pdf_doc->doc" in "delete_document()" for inclusion of some
kind of pdf images, for example, figure_missing.pdf in gnuplot.
A change
            groupDict = Object(page->getGroup()).copy();
does not improve the situation.
The changes below seem to work fine. 
*/
// begin modification
            groupDict = pageDict->lookup("Group");
            const Dict& dic1 = page->getGroup();
            const Dict& dic2 = groupDict.getDict();
            // replace dic2 in groupDict with dic1
            l = dic2.getLength();
            for (i = 0; i < l; i++) {
                groupDict.dictRemove(dic2.getKey(i));
            }
            l = dic1.getLength();
            for (i = 0; i < l; i++) {
                groupDict.dictAdd((const char *)copyString(dic1.getKey(i)),
                                  dic1.getValNF(i).copy());
            }
// end modification
            pdf_printf("/Group %ld 0 R\n", (long)pdfpagegroupval);
        }
    }

    // write the Resources dictionary
    if (page->getResourceDict() == NULL) {
        // Resources can be missing (files without them have been spotted
        // in the wild); in which case the /Resouces of the /Page will be used.
        // "This practice is not recommended".
        pdftex_warn
            ("PDF inclusion: /Resources missing. 'This practice is not recommended' (PDF Ref)");
    } else {
        Object *obj1 = page->getResourceDictObject();
        if (!obj1->isDict())
            pdftex_fail("PDF inclusion: invalid resources dict type <%s>",
                        obj1->getTypeName());
        pdf_newline();
        pdf_puts("/Resources <<\n");
        for (i = 0, l = obj1->dictGetLength(); i < l; ++i) {
            obj2 = obj1->dictGetVal(i);
            key = (char *)obj1->dictGetKey(i);
            if (strcmp("Font", key) == 0)
                copyFontResources(&obj2);
            else if (strcmp("ProcSet", key) == 0)
                copyProcSet(&obj2);
            else
                copyOtherResources(&obj2, (char *)key);
        }
        pdf_puts(">>\n");
    }

    // write the page contents
    contents = page->getContents();
    if (contents.isStream()) {

        // Variant A: get stream and recompress under control
        // of \pdfcompresslevel
        //
        // pdfbeginstream();
        // copyStream(contents->getStream());
        // pdfendstream();

        // Variant B: copy stream without recompressing
        //
        obj1 = contents.streamGetDict()->lookup("F");
        if (!obj1.isNull()) {
            pdftex_fail("PDF inclusion: Unsupported external stream");
        }
        obj1 = contents.streamGetDict()->lookup("Length");
        assert(!obj1.isNull());
        pdf_puts("/Length ");
        copyObject(&obj1);
        pdf_puts("\n");
        obj1 = contents.streamGetDict()->lookup("Filter");
        if (!obj1.isNull()) {
            pdf_puts("/Filter ");
            copyObject(&obj1);
            pdf_puts("\n");
            obj1 = contents.streamGetDict()->lookup("DecodeParms");
            if (!obj1.isNull()) {
                pdf_puts("/DecodeParms ");
                copyObject(&obj1);
                pdf_puts("\n");
            }
        }
        pdf_puts(">>\nstream\n");
        copyStream(contents.getStream()->getUndecodedStream());
        pdfendstream();
    } else if (contents.isArray()) {
        pdfbeginstream();
        for (i = 0, l = contents.arrayGetLength(); i < l; ++i) {
            Object contentsobj = contents.arrayGet(i);
            copyStream(contentsobj.getStream());
            if (i < l - 1)
                pdf_newline();  // add a newline after each stream except the last
        }
        pdfendstream();
    } else {                    // the contents are optional, but we need to include an empty stream
        pdfbeginstream();
        pdfendstream();
    }

    // write out all indirect objects
    writeRefs();

    // write out all used encodings (and delete list)
    writeEncodings();

    // write the Group dict if needed
    if (writeSepGroup) {
        pdfbeginobj(pdfpagegroupval, 2);
        copyObject(&groupDict);
        pdf_puts("\n");
        pdfendobj();
        pdfpagegroupval = 0;    // only the 1st included pdf on a page gets its
                                // Group included in the Page dict
    }

    // save object list, xref
    pdf_doc->inObjList = inObjList;
    pdf_doc->xref = xref;
}

// Called when an image has been written and it's resources in image_tab are
// freed and it's not referenced anymore.

void epdf_delete()
{
    PdfDocument *pdf_doc = (PdfDocument *) epdf_doc;
    xref = pdf_doc->xref;
    if (pdf_doc->occurences < 0) {
        delete_document(pdf_doc);
    }
}

// Called when PDF embedding system is finalized.
// Now deallocate all remaining PdfDocuments.

void epdf_check_mem()
{
    if (isInit) {
        PdfDocument *p, *n;
        for (p = pdfDocuments; p; p = n) {
            n = p->next;
            delete_document(p);
        }
    }
}
