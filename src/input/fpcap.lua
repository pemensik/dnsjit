-- Copyright (c) 2018, OARC, Inc.
-- All rights reserved.
--
-- This file is part of dnsjit.
--
-- dnsjit is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- dnsjit is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with dnsjit.  If not, see <http://www.gnu.org/licenses/>.

-- dnsjit.input.fpcap
-- Read input from a PCAP file using fopen()
--   local input = require("dnsjit.input.fpcap").new()
--   input:open("file.pcap")
--   input:receiver(filter_or_output)
--   input:run()
--
-- Read input from a PCAP file using standard library function
-- .B fopen()
-- and parse the PCAP without libpcap.
-- After opening a file and reading the PCAP header, the attributes are
-- populated.
-- .SS Attributes
-- .TP
-- is_swapped
-- Indicate if the byte order in the PCAP is in reverse order of the host.
-- .TP
-- is_nanosec
-- Indicate if the time stamps are in nanoseconds or not.
-- .TP
-- magic_number
-- Magic number.
-- .TP
-- version_major
-- Major version number.
-- .TP
-- version_minor
-- Minor version number.
-- .TP
-- thiszone
-- GMT to local correction.
-- .TP
-- sigfigs
-- Accuracy of timestamps.
-- .TP
-- snaplen
-- Max length of captured packets, in octets.
-- .TP
-- network
-- Data link type.
module(...,package.seeall)

require("dnsjit.input.fpcap_h")
local ffi = require("ffi")
local C = ffi.C

local t_name = "input_fpcap_t"
local input_fpcap_t = ffi.typeof(t_name)
local Fpcap = {}

-- Create a new Fpcap input.
function Fpcap.new()
    local self = {
        _receiver = nil,
        obj = input_fpcap_t(),
    }
    C.input_fpcap_init(self.obj)
    ffi.gc(self.obj, C.input_fpcap_destroy)
    return setmetatable(self, { __index = Fpcap })
end

-- Return the Log object to control logging of this instance or module.
function Fpcap:log()
    if self == nil then
        return C.input_fpcap_log()
    end
    return self.obj._log
end

-- Set the receiver to pass queries to.
function Fpcap:receiver(o)
    self.obj._log:debug("receiver()")
    self.obj.recv, self.obj.ctx = o:receive()
    self._receiver = o
end

-- Open a PCAP file for processing and read the PCAP header.
-- Returns 0 on success.
function Fpcap:open(file)
    return C.input_fpcap_open(self.obj, file)
end

-- Enable (true) or disable (false) usage of shared objects, if
-- .I bool
-- is not specified then return the current state.
function Fpcap:use_shared(bool)
    if bool == nil then
        if self.obj.use_shared == 1 then
            return true
        else
            return false
        end
    elseif bool == true then
        self.obj.use_shared = 1
    else
        self.obj.use_shared = 0
    end
end

-- Start processing packets.
-- Returns 0 on success.
function Fpcap:run()
    return C.input_fpcap_run(self.obj)
end

-- Return the seconds and nanoseconds (as a list) of the start time for
-- .BR Fpcap:run() .
function Fpcap:start_time()
    return tonumber(self.obj.ts.sec), tonumber(self.obj.ts.nsec)
end

-- Return the seconds and nanoseconds (as a list) of the stop time for
-- .BR Fpcap:run() .
function Fpcap:end_time()
    return tonumber(self.obj.te.sec), tonumber(self.obj.te.nsec)
end

-- Return the number of packets seen.
function Fpcap:packets()
    return tonumber(self.obj.pkts)
end

return Fpcap
