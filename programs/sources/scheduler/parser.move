module scheduler::parser {
    use std::vector::Self;

    use scheduler::string_utils;
    use scheduler::vector_utils;
    use scheduler::crontab_error::crontab_error;

    const ECRONTAB_INVALID_FORMAT : u64 = 1;
    const ECRONTAB_WRONG_PARSE_OUTPUT : u64 = 2;

    struct ScheduleComponents has drop {
        /// Minutes in the schedule.
        /// Range [0,59] inclusive.
        minutes: vector<u64>,

        /// Hours in the schedule.
        /// Range [0,23] inclusive.
        hours: vector<u64>,

        /// Days of the month in the schedule.
        /// Range [1,31] inclusive.
        days: vector<u64>,

        /// Months in the schedule.
        /// Range [1,12] inclusive.
        months: vector<u64>,

        /// Days of the week in the schedule.
        /// Range [0,6] inclusive.
        weekdays: vector<u64>,
    }

    fun parse_cron(schedule: &vector<u8>) : ScheduleComponents {
        let sep = b" ";
        let fields = string_utils::split(schedule, &sep);

        let fields_length = vector::length(&fields);
        assert!(fields_length == 5, crontab_error(
            ECRONTAB_INVALID_FORMAT
        ));
        
        let minutes = parse_field(vector::borrow(&fields, 0), 0, 59); // minutes
        let hours = parse_field(vector::borrow(&fields, 1), 0, 23); // hours
        let days = parse_field(vector::borrow(&fields, 2), 1, 31); // days
        let months = parse_field(vector::borrow(&fields, 3), 1, 12); // months
        let weekdays = parse_field(vector::borrow(&fields, 4), 0, 6); // weekdays

        ScheduleComponents {
            minutes,
            hours,
            days,
            months,
            weekdays
        }
    }

    fun parse_field(field: &vector<u8>, field_min: u64, field_max: u64) : vector<u64>{
        if (*field == b"*") {
            return vector_utils::populate_u64_vector(field_min, field_max, 1)
        };
        let field_parts = string_utils::split(field, &b",");
        let l = vector::length(&field_parts);
        let i = 0;

        let components = &mut vector::empty();
        while (i < l){
            let part = vector::borrow(&field_parts, i);
            let min = &mut field_min;
            let max = &mut field_max;
            let step = &mut 1;

            // stepped, eg. */2 or 1-45/3
            let stepped = string_utils::split(part, &b"/");
            let stepped_len = vector::length(&stepped);

            std::debug::print(&stepped);

            // ranges, eg. 1-30
            let numerator_stepped = vector::borrow(&stepped, 0);
            let range = string_utils::split(numerator_stepped, &b"-");
            let range_len = vector::length(&range);

            if (stepped_len == 2){
                let denominator_stepped = vector::borrow(&stepped, 1);
                step = &mut string_utils::ascii_number_vec_to_u64(*denominator_stepped);
            };

            if (range_len == 2) {
                let s_range = vector::borrow(&range, 0);
                min = &mut string_utils::ascii_number_vec_to_u64(*s_range);

                let e_range = vector::borrow(&range, 1);
                max = &mut string_utils::ascii_number_vec_to_u64(*e_range);
            };

            if (stepped_len == 1 && range_len == 1 && part != &b"*") {
                min = &mut string_utils::ascii_number_vec_to_u64(*part);
                max = &mut *min;
            };

            let values = vector_utils::populate_u64_vector(*min, *max, *step);
            vector::append(components, values);

            i = i + 1;
        };
        
        *components
    }

    #[test]
    #[expected_failure]
    fun test_invalid_patterns_A(){
        parse_cron(&b"* * 15");
    }

    #[test]
    #[expected_failure]
    fun test_invalid_patterns_B(){
        parse_cron(&b"* * 15");
    }

    #[test]
    fun test_valid_range(){
        let schedule = parse_cron(&b"40-59 9,18 25-31 4-8 1-5/2");
        assert!(vector::length(&schedule.minutes) == 20, crontab_error(
            ECRONTAB_WRONG_PARSE_OUTPUT
        ));
        assert!(vector::length(&schedule.hours) == 2, crontab_error(
            ECRONTAB_WRONG_PARSE_OUTPUT
        ));
    }

    #[test]
    fun test_every_mintue_cron() {
        let schedule = parse_cron(&b"* * * * *");
        assert!(vector::length(&schedule.minutes) == 60, crontab_error(
            ECRONTAB_WRONG_PARSE_OUTPUT
        ));
        assert!(vector::length(&schedule.hours) == 24, crontab_error(
            ECRONTAB_WRONG_PARSE_OUTPUT
        ));
        assert!(vector::length(&schedule.days) == 31, crontab_error(
            ECRONTAB_WRONG_PARSE_OUTPUT
        ));
        assert!(vector::length(&schedule.months) == 12, crontab_error(
            ECRONTAB_WRONG_PARSE_OUTPUT
        ));
        assert!(vector::length(&schedule.weekdays) == 7, crontab_error(
            ECRONTAB_WRONG_PARSE_OUTPUT
        ));
    }
}
