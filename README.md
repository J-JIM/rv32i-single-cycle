# RV32I single-cycle CPU — 밑바닥부터 (2026 여름)

반가산기 → 전가산기 → 32비트 가산기 → 래치 → D-FF → 레지스터 → 레지스터 파일 → PC → 메모리 → 컨트롤 유닛까지
**모든 부품을 직접 짜고, 부품마다 테스트벤치 + 고의 결함(fault) 주입으로 검증**했다. 도구는 Icarus Verilog.
설계 원전: Patterson & Hennessy 『컴퓨터 구조 및 설계 RISC-V』 2판 4장 (그림 4.19 데이터패스).

## 폴더 구조

```
rtl/        DUT (설계) — 한 모듈 = 한 파일
  alu/        halfadder fulladder CRA32 sub32 alu
  control/    control alu_control
  memory/     signextend immgen ismem dmem
  register/   Dlatch DFF register Decoder532 parallel32 programcounter(PC) registerfile
  top.v       ← 조립(배선). 부품 8개 + MUX 2개, 전부 명시적 포트 연결 (2026-10-26)
tb/         테스트벤치 (rtl 과 같은 하위 폴더, 이름은 <모듈>_tb.v)
sim/        컴파일 산출물 — 전부 재생성 가능, 지워도 됨
sw/         program.hex (ismem 이 $readmemh 로 읽음 → 실행은 sw/ 에서)
archive/    옛 버전·연습 — 코드 경로에 없음
  2026-06_교재연습/       hello, example, example5, tb
  CRA32_v2_4비트블록판/   CRA4×8 방식의 CRA32_v2 + 그 tb (비교 후 FA 직결 방식 채택)
  미완성_stub/            register32.v (빈 모듈)
Makefile
CLAUDE.md   작업 규칙 (Mac·노트북 공통) — 하드웨어·커밋·답변 방식
```

## 실행

```bash
make list              # tb 목록
make run-alu           # 하나: 컴파일(sim/alu_tb) + 실행
make all               # 전부
make clean
```

새 규칙 두 개 — **산출물은 `sim/`에만** (`iverilog -o` 를 직접 칠 땐 `sim/` 으로) · **옛 버전은 `archive/`로**, rtl 에 같은 모듈 두 개 두지 않기.

## 부품 지도

| 층 | 부품 | 파일 | 한 줄 |
|---|---|---|---|
| 그림 4.19 직접 등장 | PC | `rtl/register/programcounter.v` | parallel32 + CRA32(pc+4) 되먹임, reset 으로 X 탈출 |
| | 명령어 메모리 | `rtl/memory/ismem.v` | `$readmemh` 로 `sw/program.hex` 적재 |
| | 레지스터 파일 | `rtl/register/registerfile.v` | 32×32, 읽기 MUX 2개, x0 은 읽기에서 0 가로채기, `RegWrite` 로 디코더 one-hot 게이팅 |
| | 부호 확장 | `rtl/memory/signextend.v` | 12 → 32 비트 |
| | ALU | `rtl/alu/alu.v` | add/sub/and/or, CRA32·sub32 위에 |
| | 데이터 메모리 | `rtl/memory/dmem.v` | `always @(posedge clk)` + `<=` 첫 사용 |
| | 컨트롤 유닛 | `rtl/control/control.v` | opcode → RegWrite/MemWrite/… 7개, default 는 저장 잠금 |
| | ALU 컨트롤 | `rtl/control/alu_control.v` | 책 ALUOp 암호 ↔ 내 alu op 암호 통역 |
| 하위 부품 | 가산기 | `halfadder` `fulladder` `CRA32` `sub32` | CRA32 = FA 32개 직결 (10,006회 채점 Fail 0) |
| | 저장 소자 | `Dlatch` `DFF` `register` `parallel32` | DFF = Dlatch 2개 + 인버터, `always` 없이 |
| | 디코더 | `Decoder532` | 5→32 |

## 검증 상태

- 부품별 검증 풀 사이클(tb 작성 → 엣지 대본 → fault 주입 → 통과) **12회 완주**.
- tb 15개가 `tb/` 에 있음. **`CRA32.v`(FA 직결)만 전용 tb 가 없다** — `CRA32_tb.v` 는 v2(4비트 블록판)용이라 archive 에 있음. alu_tb·sub32_tb 가 간접 검증.
- ⚠️ **현재 `make all` 은 전부 실패한다** — `rtl/memory/immgen.v`(뼈대만)와 `rtl/control/control.v:15`(localparam 구두점)가 컴파일되지 않는데, `Makefile` 이 `rtl` 전체를 긁기 때문에 tb 하나도 못 짓는다. 마지막 정상 상태는 `ad0d4c3`.
- 참고 노트(옵시디언): `Verilog_함정_체크리스트` · `CPU_부품_지도` · `Verilog_재발_추적` · 각 `*_구현_정리`.

### 알려진 미완 (2026-10-29)

| | 내용 |
|---|---|
| 🔴 `rtl/control/control.v:15` | `localparam` 목록이 `addi` 에서 **세미콜론**으로 끊겨 16~19행(`lui`·`auipc`·`jal`·`jalr`)이 선언 밖으로 빠짐 → syntax error |
| 🔴 `rtl/memory/immgen.v` | 뼈대만. `case` 가지에 실행할 문장이 없고(주석뿐), 포트는 `Imm` 인데 대입은 `imm` — 대소문자 불일치 |
| 🟡 `rtl/top.v` | **출력 포트가 없다.** 시뮬은 `uut.regfile.slot[5]` 로 내부를 들여다보지만 합성기엔 그 창이 없어 **CPU 전체가 최적화로 제거된다** → FPGA 전에 디버그 읽기 포트가 필요 |
| 🟡 `tb/control/control_tb.v` | `addi`(`0010011`) 행이 없다 — 그 가지의 근거가 `top_tb` 의 `30` 하나뿐 |
| 🟡 `tb/register/registerfile_tb.v` | `wr_en=0` 케이스가 전부 **빈 슬롯**을 겨눠 `X !== X` 로 통과 — **보존 기능 미검증**. 값이 든 슬롯에 wr=0 케이스 한 줄 필요 |
| 🟡 `branch` · `zero` | beq 용. `programcounter` 에 분기 입력 포트가 없어 미연결 |
| 🟡 `rtl/memory/dmem.v:4` | 주석의 "조합 논리 사용" 은 틀림 — 읽기만 조합이고 쓰기는 `always @(posedge clk)` 순차 |

## 다음

1. 🔴 **빌드 복구** — `control.v` 구두점 + `immgen.v` case 가지 → `make all` 되살리기
2. **beq** — ImmGen(I·S·SB) · 분기 Add · `PCSrc = branch & zero` · PC 에 분기 입력 포트
3. **FPGA (PYNQ-Z2)** — `top.v` 에 디버그 읽기 포트 → Vivado 합성·타이밍 리포트(CRA32 캐리 체인 확인) → 보드
   - ⚠️ 합성은 **x86 리눅스 노트북에서만**. 디바이스는 **Zynq-7000** — 자세한 건 `CLAUDE.md`
4. 컴파일한 C 프로그램 실행 → 커버리지 → 파이프라인 (컴퓨터구조 수업 진도와 함께)
