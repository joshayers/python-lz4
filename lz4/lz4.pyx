from c_lz4 cimport LZ4_compress, LZ4_uncompress, LZ4_compressBound

from numpy cimport uint8_t, uint32_t
import numpy as np


cdef int hdr_size = sizeof(uint32_t)


cpdef inline store_size(uint8_t [::1] buf, uint32_t size):
    buf[0] = size & <uint32_t> 0xff
    buf[1] = (size >> 8) & <uint32_t> 0xff
    buf[2] = (size >> 16) & <uint32_t> 0xff
    buf[3] = (size >> 24) & <uint32_t> 0xff


cpdef inline uint32_t load_size(uint8_t [::1] buf):
    cdef uint32_t result
    result = buf[0] | (buf[1] << 8) | (buf[2] << 16) | (buf[3] << 24)
    return result


def compress(uint8_t [::1] source):

    cdef Py_ssize_t source_size, dest_size, osize
    cdef uint8_t [::1] dest

    source_size = source.shape[0]
    dest_size = hdr_size + LZ4_compressBound(source_size)
    dest = np.empty((dest_size, ), 'u1')
    store_size(dest, source_size)
    osize = LZ4_compress(<char*> &source[0], <char*> &dest[hdr_size],
                         source_size)
    return np.array(dest[:osize + hdr_size], copy=False)


def uncompress(uint8_t [::1] source):
    cdef int osize
    cdef Py_ssize_t dest_size
    cdef uint8_t [::1] result

    dest_size = load_size(source)
    result = np.empty((dest_size), 'u1')
    osize = LZ4_uncompress(<char*> &source[hdr_size], <char*> &result[0],
                           dest_size)
    return np.array(result, copy=False)
