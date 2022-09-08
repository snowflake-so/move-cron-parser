# Move language: Cron Parser

A cron parser library for Move language.

**Author:** This library is written by **Snowflake Network**.

## Quick start guide

Add a library to the dependency list in `Move.toml`. Use the library by add the line `use cron::parser`. Now you are ready to parse a cron expression!

### Input

```rust
let schedule = parser::parse_cron(&b"* * * * *");
```

### Output

```rust
ScheduleComponents {
 minutes: [0..60],
 hours: [0..24],
 days: [1..31],
 months: [1..12],
 weekdays: [0..6]
}
```
