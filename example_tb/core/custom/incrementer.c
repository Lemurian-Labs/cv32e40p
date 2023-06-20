typedef unsigned char u8;

typedef int s32;
typedef unsigned int u32;

#define SA_SIZE (8)

u32 readd;  // Read data
u32 writed;  // Read data
int main()
{
//writed = 4;

for (u32 LineIndex = 0; LineIndex < SA_SIZE; LineIndex++)
  {
  // Control and Status Register Read
  // pseudoinstruction: expands to csrrs rd, csr, x0
  //__asm__ volatile("csrr %0, 0x7B2" : "=r"(readd));
  //writed = LineIndex;
  __asm__ volatile("csrrw %0, 0x340, %1" : "=r"(readd) : "rm"(LineIndex));
  }


}
