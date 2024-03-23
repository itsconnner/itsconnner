class HexDump(gdb.Command):
	def __init__(self):
		super(HexDump, self).__init__("hexdump", gdb.COMMAND_DATA)

	def invoke(self, arg, from_tty):
		args = gdb.string_to_argv(arg)
		if len(args) != 2:
			raise gdb.GdbError('hexdump requires 2 arguments: address and length')

		address = int(gdb.parse_and_eval(args[0]))
		length = int(gdb.parse_and_eval(args[1]))

		for i in range(0, length, 16):
			line_address = address + i

			memory = gdb.selected_inferior().read_memory(line_address, 16)
			bytes_list = bytearray(memory)

			hex_values = ' '.join('{:02x}'.format(b) for b in bytes_list)
			ascii_values = ''.join(chr(b) if 32 <= b < 127 else '.' for b in bytes_list)

			print(f"{line_address:#010x}: {hex_values:<48} |{ascii_values}|")

HexDump()