VIVADO_BAT = C:\\Xilinx\\Vivado\\2024.1\\bin\\vivado.bat
VIVADO_DIR = D:\\Github\\final_thesis\\hw\\vivado
SCRIPT_SRC = D:\\Github\\final_thesis\\hw\\scripts\\create_project.tcl
all:
	@echo "hello"
vivado:
	mkdir -p vivado
	cmd.exe /c "cd /d $(VIVADO_DIR) && $(VIVADO_BAT) -source $(SCRIPT_SRC)"
clean:
	rm -rf vivado
