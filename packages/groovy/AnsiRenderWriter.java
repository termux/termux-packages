/*
 * Copyright (C) 2009 the original author(s).
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.fusesource.jansi;

import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.Writer;
import java.util.Locale;

import static org.fusesource.jansi.AnsiRenderer.*;

/**
 * Print writer which supports automatic ANSI color rendering via {@link AnsiRenderer}.
 *
 * @author <a href="mailto:jason@planet57.com">Jason Dillon</a>
 * @author <a href="http://hiramchirino.com">Hiram Chirino</a>
 * @since 1.1
 */
public class AnsiRenderWriter
    extends PrintWriter
{

    public AnsiRenderWriter(final OutputStream out) {
        super(out);
    }

    public AnsiRenderWriter(final OutputStream out, final boolean autoFlush) {
        super(out, autoFlush);
    }

    public AnsiRenderWriter(final Writer out) {
        super(out);
    }

    public AnsiRenderWriter(final Writer out, final boolean autoFlush) {
        super(out, autoFlush);
    }

    @Override
    public void write(final String s) {
        if (test(s)) {
            super.write(render(s));
        }
        else {
            super.write(s);
        }
    }

    //
    // Need to prevent partial output from being written while formatting or we will get rendering exceptions
    //

    @Override
    public PrintWriter format(final String format, final Object... args) {
        print(String.format(format, args));
        return this;
    }

    @Override
    public PrintWriter format(final Locale l, final String format, final Object... args) {
        print(String.format(l, format, args));
        return this;
    }
}
