def reverse_endianness(hex_string):
    # Split the hex string into pairs of characters
    pairs = [hex_string[i : i + 2] for i in range(0, len(hex_string), 2)]

    # Reverse the order of the pairs
    reversed_pairs = pairs[::-1]

    # Join the reversed pairs to get the reversed hex string
    reversed_hex = "".join(reversed_pairs)

    return reversed_hex


filename = "key_hex.txt"
out = "f_key_hex.txt"

# Open the input file for reading and the output file for writing
with open(filename, "r") as input_file, open(out, "w") as output_file:
    # Read hex numbers from the input file, process them, and write to the output file
    for line in input_file:
        hex_number = line.strip()  # Remove leading/trailing whitespace
        modified_hex = " ".join(
            reverse_endianness(hex_number[i : i + 8])
            for i in range(0, len(hex_number), 8)
        )
        output_file.write(modified_hex + "\n")
