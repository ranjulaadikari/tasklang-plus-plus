TASK nightlyCheck {
    RUN "check.sh"
    AT 23:00
    IF success
}
