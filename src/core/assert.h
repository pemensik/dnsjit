/*
 * Copyright (c) 2018-2021, OARC, Inc.
 * All rights reserved.
 *
 * This file is part of dnsjit.
 *
 * dnsjit is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * dnsjit is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with dnsjit.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef __dnsjit_core_assert_h
#define __dnsjit_core_assert_h

#include <dnsjit/core/log.h>

#define mlassert_self() \
    if (!self)          \
    core_log_fatal(&_log, __FILE__, __LINE__, "self is nil")
#define glassert_self() \
    if (!self)          \
    core_log_fatal(0, __FILE__, __LINE__, "self is nil")

#define lassert(expression, msg...) \
    if (!(expression))              \
    core_log_fatal(&self->_log, __FILE__, __LINE__, msg)
#define lpassert(expression, msg...) \
    if (!(expression))               \
    core_log_fatal(self->_log, __FILE__, __LINE__, msg)
#define mlassert(expression, msg...) \
    if (!(expression))               \
    core_log_fatal(&_log, __FILE__, __LINE__, msg)
#define glassert(expression, msg...) \
    if (!(expression))               \
    core_log_fatal(0, __FILE__, __LINE__, msg)

#endif
