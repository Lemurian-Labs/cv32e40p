typedef unsigned char u8;

typedef int s32;
typedef unsigned int u32;

#define SA_SIZE (5)

u32 readd;  // Read data
u32 writed;  // Read data
int main()
{
// Load first half of 16 rows of Matrix (Quadrant 1)
__asm__ volatile("csrwi 0x340, 0x0");
__asm__ volatile("csrwi 0x340, 0x1");
__asm__ volatile("csrwi 0x340, 0x2");
__asm__ volatile("csrwi 0x340, 0x3");
__asm__ volatile("csrwi 0x340, 0x4");
__asm__ volatile("csrwi 0x340, 0x5");
__asm__ volatile("csrwi 0x340, 0x6");
__asm__ volatile("csrwi 0x340, 0x7");
__asm__ volatile("csrwi 0x340, 0x8");
__asm__ volatile("csrwi 0x340, 0x9");
__asm__ volatile("csrwi 0x340, 0xA");
__asm__ volatile("csrwi 0x340, 0xB");
__asm__ volatile("csrwi 0x340, 0xC");
__asm__ volatile("csrwi 0x340, 0xD");
__asm__ volatile("csrwi 0x340, 0xF");

// Load 2nd half of 16 rows of Matrix (Quadrant 2)
__asm__ volatile("csrwi 0x340, 0x10");
__asm__ volatile("csrwi 0x340, 0x11");
__asm__ volatile("csrwi 0x340, 0x12");
__asm__ volatile("csrwi 0x340, 0x13");
__asm__ volatile("csrwi 0x340, 0x14");
__asm__ volatile("csrwi 0x340, 0x15");
__asm__ volatile("csrwi 0x340, 0x16");
__asm__ volatile("csrwi 0x340, 0x17");
__asm__ volatile("csrwi 0x340, 0x18");
__asm__ volatile("csrwi 0x340, 0x19");
__asm__ volatile("csrwi 0x340, 0x1A");
__asm__ volatile("csrwi 0x340, 0x1B");
__asm__ volatile("csrwi 0x340, 0x1C");
__asm__ volatile("csrwi 0x340, 0x1D");
__asm__ volatile("csrwi 0x340, 0x1E");
__asm__ volatile("csrwi 0x340, 0x1F");

//for (u32 LineIndex = 0; LineIndex < SA_SIZE; LineIndex++)
 // {
  // Control and Status Register Read
  // pseudoinstruction: expands to csrrs rd, csr, x0
  //__asm__ volatile("csrr %0, 0x7B2" : "=r"(readd));
  //writed = LineIndex;
  //__asm__ volatile("csrrs %0, 0x340, %1" : "=r"(readd) : "rm"(LineIndex));
  //__asm__ volatile("csrs 0x340, %0" : "=r"(LineIndex));
  //__asm__ volatile("addi %0, 0x340, %1" : "=r"(readd) : "rm"(LineIndex));
  //ADDI x4,x6,123 
 // }


}
