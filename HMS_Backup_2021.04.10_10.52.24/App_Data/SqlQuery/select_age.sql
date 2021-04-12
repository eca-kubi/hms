SELECT [Age] = (0+ FORMAT(GETDATE(),'yyyyMMdd') - FORMAT(BirthDate,'yyyyMMdd') ) /10000 from
PatientBiodatas