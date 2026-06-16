# TaskLang++ 🗓️
> A Domain-Specific Language (DSL) for Task Scheduling and Automation

![Language](https://img.shields.io/badge/Language-C-blue)
![Lexer](https://img.shields.io/badge/Lexer-Flex-green)
![Parser](https://img.shields.io/badge/Parser-Bison-orange)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen)

---

## 📌 Overview

TaskLang++ is a custom-built Domain-Specific Language designed to simplify task scheduling and automation. Instead of writing complex Bash or Python scripts, users can define tasks in a clean, readable syntax — specifying what to run, when to run it, what it depends on, and under what conditions it executes.

This project was built as part of the SE2052 Programming Paradigms module at SLIIT, implementing a full lexer using Flex and a parser using Bison.

---

## ✨ Features

- ✅ Task definition with script execution
- ✅ Time-based scheduling (daily, weekly, specific time)
- ✅ Task dependencies using `AFTER` keyword
- ✅ Conditional execution using `IF success` / `IF failure`
- ✅ Circular dependency detection
- ✅ Meaningful lexical and syntax error reporting
- ✅ Comment support using `#`

---

## 🛠️ Built With

| Tool | Purpose |
|------|---------|
| Flex | Lexical analysis (tokenizer) |
| Bison (Yacc) | Syntax analysis (parser) |
| C (GCC) | Implementation language |
| Make | Build automation |

---

## 📁 Project Structure
tasklang-plus-plus/

├── lexer.l          # Flex lexer — tokenizes TaskLang++ input

├── parser.y         # Bison parser — validates grammar rules

├── Makefile         # Build automation

├── test_valid1.tl   # Simple daily scheduled task

├── test_valid2.tl   # Multi-step workflow with dependencies

├── test_valid3.tl   # AT time only task

├── test_valid4.tl   # Failure condition handler

├── test_invalid1.tl # Invalid — missing RUN statement

└── test_invalid2.tl # Invalid — malformed TIME token

---

## 🚀 How to Run

### Prerequisites
```bash
sudo apt install flex bison gcc make -y
```

### Compile
```bash
make
```

### Run a test
```bash
./tasklang < test_valid1.tl
./tasklang < test_valid2.tl
./tasklang < test_invalid1.tl
```

---

## 📝 TaskLang++ Syntax

### Simple Daily Task
TASK dailyReport {

RUN "report.py"

EVERY DAY AT 06:00

}

### Multi-Step Workflow with Dependencies
TASK backupDB {

RUN "backup.sh"

EVERY DAY AT 02:00

}
TASK sendReport {

RUN "report.py"

AFTER backupDB

IF success

}
TASK cleanup {

RUN "cleanup.sh"

EVERY WEEK ON SUNDAY AT 03:00

}

### Failure Handler
TASK alertAdmin {

RUN "alert.sh"

AFTER backupDB

IF failure

}

---

## 📤 Sample Output
Parsing TaskLang++ input...
--- EXECUTION START ---
Executing Task: backupDB

Script: "backup.sh"

Schedule: EVERY DAY AT 02:00
Executing Task: sendReport

Script: "report.py"

Depends on: backupDB

Condition: success
--- EXECUTION COMPLETE ---

[No circular dependencies found.]

---

## ⚠️ Error Handling

| Error Type | Example | Message |
|------------|---------|---------|
| Lexical Error | `AT 9:00` instead of `09:00` | `Lexical Error: Unknown character` |
| Syntax Error | Missing `RUN` statement | `Syntax Error at line X` |
| Circular Dependency | Task A depends on B, B depends on A | `WARNING: Circular dependency detected` |

---

## 📚 Grammar (EBNF)
program         ::= task+

task            ::= "TASK" IDENTIFIER "{" run_stmt statement* "}"

run_stmt        ::= "RUN" STRING

schedule_stmt   ::= "EVERY" "DAY" "AT" TIME

| "EVERY" "WEEK" "ON" DAYNAME "AT" TIME

| "AT" TIME

dependency_stmt ::= "AFTER" IDENTIFIER

condition_stmt  ::= "IF" "success" | "IF" "failure"

---

## 👩‍💻 Author

**Ranjula Adikari**
- GitHub: [@ranjulaadikari](https://github.com/ranjulaadikari)
- University: Sri Lanka Institute of Information Technology (SLIIT)
- Module: SE2052 Programming Paradigms

---

## 📄 License

This project is for academic purposes — SE2052 Programming Paradigms, SLIIT.
