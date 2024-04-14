import argparse

def parse_args():
  parser = argparse.ArgumentParser(
    prog="Prepare Hex Files",
    description="Modifies the generated .hex files to convert from word-addressable to byte-addressable memory",
  )

  parser.add_argument("filename")

  return parser.parse_args()

def main():
  # args = parse_args()
  
  filename = "build/asm/load_test.hex"

  new_file = []
  with open(filename, "r") as f:
    for line in f:
      if line.startswith("@"):
        word_addressable_address = int(line[1:-1], 16)
        byte_addressable_address = word_addressable_address // 4
        new_file.append("@{:08x}".format(byte_addressable_address))
      else:
        new_file.append(line)
  
  with open(filename, "w") as f:
    for line in new_file:
      if line[-1] != "\n":
        f.write(f"{line}\n")
      else:
        f.write(f"{line}")

if __name__ == "__main__":
  main()