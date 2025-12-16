
# Searching for Text in All Files on WSL (Linux)
A quick practical note for finding words, signals, or patterns inside any project directory.

---

## 1. Search all files in the current directory
```bash
grep -R "your_text" .
```

## 2. Show filename + line number
```bash
grep -Rn "your_text" .
```

## 3. Search in specific file types
Example: Verilog files
```bash
grep -R --include="*.v" "your_text" .
```

Multiple extensions:
```bash
grep -R --include="*.v" --include="*.sv" "your_text" .
```

## 4. Case‑insensitive search
```bash
grep -Rni "your_text" .
```

## 5. List only filenames
```bash
grep -Rl "your_text" .
```

## 6. Exclude folders
```bash
grep -R --exclude-dir=build "your_text" .
```

---

## Quick Examples
Search Wishbone:
```bash
grep -Rn "wb_ack" ../src
```

Search MAX30100 registers:
```bash
grep -Rn "I2C_ADDRESS" .
```

Search RTL modules:
```bash
grep -Rn "module dmem" .
```
