SELECT LTRIM(RTRIM(dbo.fnToProperCase(FullName))) as FullName,
BiodataID,
Photo,
PatientID,
Company,
Gender
FROM PatientBiodatas 
WHERE BiodataID = @biodata_id;
