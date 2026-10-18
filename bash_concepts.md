# Bash Scripting Concepts

## Covered so far

### 1. Arguments and special variables
- `$1`, `$2`, ... positional arguments
- `$@` all arguments; `"$@"` keeps each argument as a separate word (preserves spaces)
- `$*` all arguments as a single string; `"$*"` joins them with the first char of IFS
- `$#` number of arguments passed
- `$?` exit code of the last executed command (check it immediately)
- `$0` the script's own name

### 2. Safety flags
```bash
set -euo pipefail
```
- `-e` exit immediately if any command fails
- `-u` error out on unset variables instead of silently using empty string
- `-o pipefail` makes a pipeline fail if ANY command in it fails, not just the last

### 3. Test constructs
- `[ ]` POSIX test command, needs quoting, no `==`, no `&&`/`||` inside, no regex
- `[[ ]]` bash builtin, safer, supports `==`, glob patterns, `=~` regex, `&&`/`||` inside
- `(( ))` arithmetic context, use for numeric comparisons and math (`(( x > 5 ))`, `(( x++ ))`)
- `=` vs `==`: use `=` in `[ ]` (POSIX-correct), either works in `[[ ]]`, never use string equality for numbers (use `(( ))`)
- Negation: `!` not `not` (e.g. `[[ ! -d "$dir" ]]` or `! [[ -d "$dir" ]]`)

### 4. File/directory test flags
- `-f` regular file exists
- `-d` directory exists
- `-z` string is empty / `-n` string is non-empty

### 5. Capturing output and exit codes
```bash
output=$(some_command)
exit_code=$?
```
Check `$?` immediately, any command run after overwrites it.

### 6. String case conversion
- `${var,,}` lowercase the whole string
- `${var^^}` uppercase the whole string

### 7. Redirection
- `>&2` redirect to stderr (not `>$2`, which tries to redirect into a filename)
- `>` overwrite a file, `>>` append to a file

### 8. Globs vs regex
- `"$1"/*` is a glob, expanded by bash BEFORE the loop runs, into one path per match
- Glob does not match dotfiles by default, does not recurse into subdirectories
- `[[ "$file" == *.sh ]]` glob pattern match (not regex)
- `[[ "$str" =~ ^[a-z]+$ ]]` regex match, only works inside `[[ ]]`

### 9. Loops
```bash
for file in "$dir"/*; do
  [[ -f "$file" ]] || continue
  echo "$file"
done
```

**`while` loop** — runs while a condition stays true (vs `for`, which iterates a fixed list):
```bash
count=1
while [ "$count" -le 5 ]; do
  echo "count is $count"
  count=$((count + 1))
done
```
Numeric comparisons for `[ ]`/`[[ ]]`: `-lt`, `-le`, `-gt`, `-ge`, `-eq`, `-ne`.

Reading a file line by line (preferred over `for line in $(cat file)`, which word-splits on spaces and breaks multi-word lines):
```bash
while read -r line; do
  echo "Line: $line"
done < myfile.txt
```

Infinite loop with manual exit:
```bash
while true; do
  read -p "Enter a number (0 to quit): " num
  [ "$num" -eq 0 ] && break
  echo "You entered $num"
done
```
`break` exits the loop, `continue` skips to the next iteration.

### 10. `$` and quoting rules
- `$` reads a variable's value; omit it when assigning (`counter=5`, not `$counter=5`)
- Inside `(( ))` / `$(( ))`, `$` on variable names is optional, bash already treats bare names as values: `counter=$(( counter - 1 ))`
- Unquoted variables risk word-splitting and glob expansion:
  ```bash
  name="John Smith"
  greet $name     # BUG: two args, "John" and "Smith"
  greet "$name"   # correct: one arg, "John Smith"
  ```
  ```bash
  file="*.txt"
  echo $file      # expands the glob, unexpected
  echo "$file"    # prints literal string *.txt
  ```
- Safe default: quote every variable expansion (`"$var"`) except inside `(( ))`, or when you deliberately want word-splitting/glob expansion

### 11. Functions
```bash
myfunc () {
  local x="$1"
  echo "$x"
  return 0
}
myfunc "$@"
```
- `return` sets a function's exit status (only inside functions)
- `exit` ends the whole script with a status code
- `local` scopes a variable to the function

## Still to cover

- Arrays (`arr=(a b c)`, `"${arr[@]}"`, `${#arr[@]}`)
- Associative arrays (`declare -A map`)
- `case` statements for multi-branch matching
- `until` loops (opposite of `while`, runs until a condition becomes true)
- Here-documents (`<<EOF`) and here-strings (`<<<`)
- Trap handling (`trap 'cleanup' EXIT`, signal handling like SIGINT)
- Process substitution (`<(command)`) and command substitution nesting
- String manipulation: `${var#pattern}`, `${var%pattern}`, `${var/find/replace}`, substring `${var:0:3}`
- Default/fallback values: `${var:-default}`, `${var:=default}`
- Exit codes and conventions (0 = success, non-zero = failure, meaningful custom codes)
- Working with `getopts` for proper flag/option parsing (`-v`, `--verbose`, etc.)
- Subshells `( )` vs current shell execution, and when variables don't persist
- Background jobs, `&`, `wait`, `jobs`
- Debugging: `bash -x script.sh`, `set -x` / `set +x`
- Shellcheck and linting scripts
- File descriptors beyond stdin/stdout/stderr, `exec` redirection tricks
- Signal-safe cleanup patterns (temp file handling with `trap`)
- Parsing JSON/CSV with `jq`/`awk`/`cut` in scripts
- Portability: bashisms vs POSIX sh differences
