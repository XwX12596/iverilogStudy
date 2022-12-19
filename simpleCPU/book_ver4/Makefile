source := cpu.v
top := cputop.v
target := cpu.o
$(target) : $(source)
	@iverilog -o $(target)  $(top)
	@echo "build over"

run : $(target)
	@vvp $(target)
.PHONY  : clean scan
clean :
	@rm -rfv $(target)
scan :
	@find . -name "*.v" > files.lst
