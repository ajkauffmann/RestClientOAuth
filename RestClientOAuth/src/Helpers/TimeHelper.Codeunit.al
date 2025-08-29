codeunit 50319 TimeHelper
{
    procedure GetEpochTimestamp(ToDateTime: DateTime) Timestamp: BigInteger
    var
        EpochStartDateTime: DateTime;
        CurrentDateTimeInUTC: DateTime;
        ElapsedMilliseconds: Duration;
    begin
        EpochStartDateTime := CreateDateTime(19700101D, 0T);
        CurrentDateTimeInUTC := GetDateTimeInUtc(ToDateTime);

        // Calculate the number of milliseconds since the Unix epoch
        // We cannot substract the two DateTime values directly because the result is one hour off in Daylight Saving Time
        // Just adding one hour to the result is not a good solution because there are timezones with a 30 minutes offset
        Timestamp := ((DT2Date(CurrentDateTimeInUTC) - DT2Date(EpochStartDateTime)) * 86400) +
                     (Round((DT2Time(CurrentDateTimeInUTC) - DT2Time(EpochStartDateTime)) / 1000, 1, '='));
    end;

    procedure GetDateTimeInUtc(Input: DateTime) UTC: DateTime
    var
        TimeZone: Codeunit "Time Zone";
        Offset: Duration;
    begin
        Offset := TimeZone.GetTimezoneOffset(Input);
        UTC := Input - Offset;
    end;
}