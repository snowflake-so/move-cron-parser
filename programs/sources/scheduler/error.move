module scheduler::crontab_error {
    use std::error;
    
    const CRONTAB_ERROR : u64 = 0xF;
    
    public fun crontab_error(r: u64): u64 { error::canonical(CRONTAB_ERROR, r) }
}