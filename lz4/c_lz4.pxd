
cdef extern from "lz4.h" nogil:
    int LZ4_compress(const char *src, char *dest, int isize)
    int LZ4_uncompress(const char *src, char *dest, int osize)
    int LZ4_compressBound(int isize)
