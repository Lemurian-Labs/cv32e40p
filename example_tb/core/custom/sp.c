#define Square(a) ((a)*(a))

typedef unsigned char u8;

typedef int s32;
typedef unsigned int u32;


typedef struct {
  u8 *KernelTileBase;
  u8 *ActivationTileBase;
  u8 *DestBase;
} single_tile;

#define SA_SIZE (8)
#define L2_SIZE (1024) // TODO(Jesse): ?
#define L1_SIZE (Square(SA_SIZE))

u8 L2[L2_SIZE];

u8 DestL1[L1_SIZE];
u8 ActivationL1[L1_SIZE];
u8 KernelL1[L1_SIZE];


int main()
{
  single_tile Tile = {
    .KernelTileBase     = L2,
    .ActivationTileBase = L2 + L1_SIZE,
    .DestBase           = L2 + L1_SIZE + L1_SIZE
  };

  u8 *KernelLine     = Tile.KernelTileBase;
  u8 *ActivationLine = Tile.ActivationTileBase;
  u8 *DestLine       = Tile.DestBase;

  // NOTE(Jesse): Feeding the ingress L1s
  for (u32 LineIndex = 0; LineIndex < SA_SIZE; ++LineIndex)
  {
    KernelL1[LineIndex] = KernelLine[LineIndex];
    ActivationL1[LineIndex] = ActivationLine[LineIndex];

    ++KernelLine;
    ++ActivationLine;
  }

  // NOTE(Jesse): Pulling from the egress L1s
  for (u32 LineIndex = 0; LineIndex < SA_SIZE; ++LineIndex)
  {
    DestLine[LineIndex] = DestL1[LineIndex];
    ++DestLine;
  }


}
