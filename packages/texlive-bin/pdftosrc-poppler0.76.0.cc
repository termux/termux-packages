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
by Arch Linux. The poppler should be 0.76.0 or newer versions.
POPPLER_VERSION should be defined.
*/

#include <w2c/config.h>

#include <stdlib.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>

#ifdef POPPLER_VERSION
#define GString GooString
#define xpdfVersion POPPLER_VERSION
#include <dirent.h>
#include <goo/GooString.h>
#include <goo/gmem.h>
#include <goo/gfile.h>
#else
#error POPPLER_VERSION should be defined.
#endif
#include <assert.h>

#include "Object.h"
#include "Stream.h"
#include "Lexer.h"
#include "Parser.h"
#include "Array.h"
#include "Dict.h"
#include "XRef.h"
#include "Catalog.h"
#include "Page.h"
#include "GfxFont.h"
#include "PDFDoc.h"
#include "GlobalParams.h"
#include "Error.h"

static XRef *xref = 0;

int main(int argc, char *argv[])
{
    char *p, buf[1024];
    PDFDoc *doc;
    GString *fileName;
    Stream *s;
    Object srcStream, srcName, catalogDict;
    FILE *outfile;
    char *outname;
    int objnum = 0, objgen = 0;
    bool extract_xref_table = false;
    int c;
    fprintf(stderr, "pdftosrc version %s\n", xpdfVersion);
    if (argc < 2) {
        fprintf(stderr,
                "Usage: pdftosrc <PDF-file> [<stream-object-number>]\n");
        exit(1);
    }
    fileName = new GString(argv[1]);
    globalParams = new GlobalParams();
    doc = new PDFDoc(fileName);
    if (!doc->isOk()) {
        fprintf(stderr, "Invalid PDF file\n");
        exit(1);
    }
    if (argc >= 3) {
        objnum = atoi(argv[2]);
        if (argc >= 4)
            objgen = atoi(argv[3]);
    }
    xref = doc->getXRef();
    catalogDict = xref->getCatalog();
    if (!catalogDict.isDict("Catalog")) {
        fprintf(stderr, "No Catalog found\n");
        exit(1);
    }
    srcStream = Object(objNull);
    if (objnum == 0) {
        srcStream = catalogDict.dictLookup("SourceObject");
        static char const_SourceFile[] = "SourceFile";
        if (!srcStream.isStream(const_SourceFile)) {
            fprintf(stderr, "No SourceObject found\n");
            exit(1);
        }
        srcName = srcStream.getStream()->getDict()->lookup("SourceName");
        if (!srcName.isString()) {
            fprintf(stderr, "No SourceName found\n");
            exit(1);
        }
        outname = (char *)srcName.getString()->c_str();
        // We cannot free srcName, as objname shares its string.
        // srcName.free();
    } else if (objnum > 0) {
        srcStream = xref->fetch(objnum, objgen);
        if (!srcStream.isStream()) {
            fprintf(stderr, "Not a Stream object\n");
            exit(1);
        }
        sprintf(buf, "%s", fileName->c_str());
        if ((p = strrchr(buf, '.')) == 0)
            p = strchr(buf, 0);
        if (objgen == 0)
            sprintf(p, ".%i", objnum);
        else
            sprintf(p, ".%i+%i", objnum, objgen);
        outname = buf;
    } else {                    // objnum < 0 means we are extracting the XRef table
        extract_xref_table = true;
        sprintf(buf, "%s", fileName->c_str());
        if ((p = strrchr(buf, '.')) == 0)
            p = strchr(buf, 0);
        sprintf(p, ".xref");
        outname = buf;
    }
    if (!(outfile = fopen(outname, "wb"))) {
        fprintf(stderr, "Cannot open file \"%s\" for writing\n", outname);
        exit(1);
    }
    if (extract_xref_table) {
        int size = xref->getNumObjects();
        int i;
        for (i = 0; i < size; i++) {
            if (xref->getEntry(i)->offset == 0xffffffff)
                break;
        }
        size = i;
        fprintf(outfile, "xref\n");
        fprintf(outfile, "0 %i\n", size);
        for (i = 0; i < size; i++) {
            XRefEntry *e = xref->getEntry(i);
            if (e->type != xrefEntryCompressed)
                fprintf(outfile, "%.10lu %.5i %s\n",
                        (long unsigned) e->offset, e->gen,
                        (e->type == xrefEntryFree ? "f" : "n"));
            else {              // e->offset is the object number of the object stream
                Stream *str;
                Lexer *lexer;
                Parser *parser;
                Object objStr, obj1, obj2;
                int nObjects, first, n;
                int localOffset = 0;
                unsigned int firstOffset;

                objStr = xref->fetch(e->offset, 0);
                assert(objStr.isStream());
                obj1 = objStr.streamGetDict()->lookup("N");
                nObjects = obj1.getInt();
                obj1 = objStr.streamGetDict()->lookup("First");
                first = obj1.getInt();
                firstOffset = objStr.getStream()->getBaseStream()->getStart() + first;

                // parse the header: object numbers and offsets
                objStr.streamReset();
                str = new EmbedStream(objStr.getStream(), Object(objNull), true, first);
                parser = new Parser(xref, str, false);
                for (n = 0; n < nObjects; ++n) {
                    obj1 = parser->getObj();
                    obj2 = parser->getObj();
                    if (n == e->gen)
                        localOffset = obj2.getInt();
                }
                while (str->getChar() != EOF) ;
                delete parser;

                fprintf(outfile, "%.10lu 00000 n\n",
                        (long unsigned)(firstOffset + localOffset));
            }
        }
    } else {
        s = srcStream.getStream();
        s->reset();
        while ((c = s->getChar()) != EOF)
            fputc(c, outfile);
    }
    if (objnum == 0)
        fprintf(stderr, "Source file extracted to %s\n", outname);
    else if (objnum > 0)
        fprintf(stderr, "Stream object extracted to %s\n", outname);
    else
        fprintf(stderr, "Cross-reference table extracted to %s\n", outname);
    fclose(outfile);
    delete doc;
    delete globalParams;
}
