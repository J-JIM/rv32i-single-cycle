# RV32I single-cycle CPU — iverilog 빌드
#   make list            tb 목록
#   make run-alu         tb 하나 컴파일+실행   (sim/alu_tb 생성, sw/ 에서 실행 → program.hex 상대경로 유지)
#   make all             tb 전부 실행
#   make clean           sim/ 비우기
# 규칙: 산출물은 sim/ 에만. rtl/ 은 DUT, tb/ 는 테스트벤치, 옛 버전은 archive/.

IVERILOG ?= iverilog
VVP      ?= vvp
IFLAGS   ?=

RTL := $(shell find rtl -name '*.v' | sort)
TBS := $(patsubst %_tb,%,$(notdir $(basename $(wildcard tb/*_tb.v tb/*/*_tb.v))))

vpath %_tb.v tb/alu tb/control tb/memory tb/register tb

.PHONY: all list clean $(addprefix run-,$(TBS))

all: $(addprefix run-,$(TBS))

list:
	@printf '%s\n' $(TBS)

sim:
	@mkdir -p sim

# sim/<name>_tb  ←  tb/*/<name>_tb.v + rtl 전체 (-s 로 최상위를 tb 하나로 고정)
sim/%_tb: %_tb.v $(RTL) | sim
	$(IVERILOG) $(IFLAGS) -s $*_tb -o $@ $< $(RTL)

$(addprefix run-,$(TBS)): run-%: sim/%_tb
	@echo "===== $* ====="
	@cd sw && $(VVP) ../$<

clean:
	rm -f sim/*
