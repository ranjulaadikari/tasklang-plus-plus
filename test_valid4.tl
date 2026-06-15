TASK alertAdmin {
    RUN "alert.sh"
    AFTER backupDB
    IF failure
}
