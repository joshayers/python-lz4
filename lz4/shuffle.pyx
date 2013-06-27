from libc.stdio cimport printf
from numpy cimport uint32_t

cdef extern from "emmintrin.h" nogil:
    ctypedef struct __m128i:
        pass

    __m128i _mm_unpacklo_epi32(__m128i a, __m128i b)
    __m128i _mm_unpackhi_epi32(__m128i a, __m128i b)
    __m128i _mm_unpacklo_epi64(__m128i a, __m128i b)
    __m128i _mm_unpackhi_epi64(__m128i a, __m128i b)
    __m128i _mm_set_epi32(int a, int b, int c, int d)


cdef printxmm(__m128i xmm0):

    cdef uint32_t *buf
    buf = <uint32_t*> &xmm0
    printf("%d,%d,%d,%d\n", buf[0], buf[1], buf[2], buf[3])


def test1():

    """Copies high 64 bits without any change.

    0xe4 = 11 10 01 00 = 3 2 1 0 = no change
    0xd8 = 11 01 10 00 = 3 1 2 0 = swap two middle bytes
    0x4e = 01 00 11 10 = 1 0 3 2
    """

    cdef __m128i row1 = _mm_set_epi32(3, 2, 1, 0)
    cdef __m128i row2 = _mm_set_epi32(7, 6, 5, 4)
    cdef __m128i row3 = _mm_set_epi32(11, 10, 9, 8)
    cdef __m128i row4 = _mm_set_epi32(15, 14, 13, 12)
    cdef __m128i row5 = _mm_set_epi32(19, 18, 17, 16)
    cdef __m128i row6 = _mm_set_epi32(23, 22, 21, 20)
    cdef __m128i row7 = _mm_set_epi32(27, 26, 25, 24)
    cdef __m128i row8 = _mm_set_epi32(31, 30, 29, 28)
    printxmm(row1)
    printxmm(row2)
    printxmm(row3)
    printxmm(row4)
    printxmm(row5)
    printxmm(row6)
    printxmm(row7)
    printxmm(row8)
    printf("\n")
    cdef __m128i t1 = _mm_unpacklo_epi32(row1, row2)
    cdef __m128i t2 = _mm_unpacklo_epi32(row3, row4)
    cdef __m128i t3 = _mm_unpackhi_epi32(row1, row2)
    cdef __m128i t4 = _mm_unpackhi_epi32(row3, row4)
    cdef __m128i t5 = _mm_unpacklo_epi32(row5, row6)
    cdef __m128i t6 = _mm_unpacklo_epi32(row7, row8)
    cdef __m128i t7 = _mm_unpackhi_epi32(row5, row6)
    cdef __m128i t8 = _mm_unpackhi_epi32(row7, row8)
    printxmm(t1)
    printxmm(t2)
    printxmm(t3)
    printxmm(t4)
    printxmm(t5)
    printxmm(t6)
    printxmm(t7)
    printxmm(t8)
    printf("\n")
    cdef __m128i o1 = _mm_unpacklo_epi64(t1, t2)
    cdef __m128i o2 = _mm_unpacklo_epi64(t5, t6)
    cdef __m128i o3 = _mm_unpackhi_epi64(t1, t2)
    cdef __m128i o4 = _mm_unpackhi_epi64(t5, t6)
    cdef __m128i o5 = _mm_unpacklo_epi64(t3, t4)
    cdef __m128i o6 = _mm_unpacklo_epi64(t7, t8)
    cdef __m128i o7 = _mm_unpackhi_epi64(t3, t4)
    cdef __m128i o8 = _mm_unpackhi_epi64(t7, t8)
    printxmm(o1)
    printxmm(o2)
    printxmm(o3)
    printxmm(o4)
    printxmm(o5)
    printxmm(o6)
    printxmm(o7)
    printxmm(o8)
    printf("\n")
