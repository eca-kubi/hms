SELECT
    *,
    ISNULL(C1, 0)+ISNULL(C2, 0)+ISNULL(C3, 0)+ISNULL(C4, 0)+ISNULL(C5, 0)+ISNULL(C6, 0)+ISNULL(C7, 0)+ISNULL(C8, 0)+ISNULL(C9, 0)+ISNULL(C10, 0)+ISNULL(C11, 0)+ISNULL(C12, 0) AS [Total]
FROM
    (
        SELECT
            Company,
            [ss12].[C1] AS [C1],
            [ss12].[C2] AS [C2],
            [ss12].[C3] AS [C3],
            [ss12].[C4] AS [C4],
            [ss12].[C5] AS [C5],
            [ss12].[C6] AS [C6],
            [ss12].[C7] AS [C7],
            [ss12].[C8] AS [C8],
            [ss12].[C9] AS [C9],
            [ss12].[C10] AS [C10],
            [ss12].[C11] AS [C11],
            (SELECT
            ISNULL(SUM([m].[cost]), 0) AS [A1]
        FROM
            [MedicalHistories] AS [m]
        LEFT OUTER JOIN [PatientBioDatas] AS [p] ON [m].[boiDataId] = [p].[bioDataId]
        WHERE
            DatePart(year, [m].[date]) = @year12
            AND DatePart(month, [m].[date]) = @month12
            AND [ss12].[company] = [p].[company]) AS [C12]
        FROM
            (
                SELECT
                    Company,
                    [ss11].[C1] AS [C1],
                    [ss11].[C2] AS [C2],
                    [ss11].[C3] AS [C3],
                    [ss11].[C4] AS [C4],
                    [ss11].[C5] AS [C5],
                    [ss11].[C6] AS [C6],
                    [ss11].[C7] AS [C7],
                    [ss11].[C8] AS [C8],
                    [ss11].[C9] AS [C9],
                    [ss11].[C10] AS [C10],
                    (SELECT
                    ISNULL(SUM([m].[cost]), 0) AS [A1]
                FROM
                    [MedicalHistories] AS [m]
                LEFT OUTER JOIN [PatientBioDatas] AS [p] ON [m].[boiDataId] = [p].[bioDataId]
                WHERE
                    DatePart(year, [m].[date]) = @year11
                    AND DatePart(month, [m].[date]) = @month11
                    AND [ss11].[company] = [p].[company]) AS [C11]
                FROM
                    (
                        SELECT
                            Company,
                            [ss10].[C1] AS [C1],
                            [ss10].[C2] AS [C2],
                            [ss10].[C3] AS [C3],
                            [ss10].[C4] AS [C4],
                            [ss10].[C5] AS [C5],
                            [ss10].[C6] AS [C6],
                            [ss10].[C7] AS [C7],
                            [ss10].[C8] AS [C8],
                            [ss10].[C9] AS [C9],
                            (SELECT
                            ISNULL(SUM([m].[cost]), 0) AS [A1]
                        FROM
                            [MedicalHistories] AS [m]
                        LEFT OUTER JOIN [PatientBioDatas] AS [p] ON [m].[boiDataId] = [p].[bioDataId]
                        WHERE
                            DatePart(year, [m].[date]) = @year10
                            AND DatePart(month, [m].[date]) = @month10
                            AND [ss10].[company] = [p].[company]) AS [C10]
                        FROM
                            (
                                SELECT
                                    Company,
                                    [ss9].[C1] AS [C1],
                                    [ss9].[C2] AS [C2],
                                    [ss9].[C3] AS [C3],
                                    [ss9].[C4] AS [C4],
                                    [ss9].[C5] AS [C5],
                                    [ss9].[C6] AS [C6],
                                    [ss9].[C7] AS [C7],
                                    [ss9].[C8] AS [C8],
                                    (SELECT
                                    ISNULL(SUM([m].[cost]), 0) AS [A1]
                                FROM
                                    [MedicalHistories] AS [m]
                                LEFT OUTER JOIN [PatientBioDatas] AS [p] ON [m].[boiDataId] = [p].[bioDataId]
                                WHERE
                                    DatePart(year, [m].[date]) = @year9
                                    AND DatePart(month, [m].[date]) = @month9
                                    AND [ss9].[company] = [p].[company]) AS [C9]
                                FROM
                                    (
                                        SELECT
                                            Company,
                                            [ss8].[C1] AS [C1],
                                            [ss8].[C2] AS [C2],
                                            [ss8].[C3] AS [C3],
                                            [ss8].[C4] AS [C4],
                                            [ss8].[C5] AS [C5],
                                            [ss8].[C6] AS [C6],
                                            [ss8].[C7] AS [C7],
                                            (SELECT
                                            ISNULL(SUM([m].[cost]), 0) AS [A1]
                                        FROM
                                            [MedicalHistories] AS [m]
                                        LEFT OUTER JOIN [PatientBioDatas] AS [p] ON [m].[boiDataId] = [p].[bioDataId]
                                        WHERE
                                            DatePart(year, [m].[date]) = @year8
                                            AND DatePart(month, [m].[date]) = @month8
                                            AND [ss8].[company] = [p].[company]) AS [C8]
                                        FROM
                                            (
                                                SELECT
                                                    Company,
                                                    [ss7].[C1] AS [C1],
                                                    [ss7].[C2] AS [C2],
                                                    [ss7].[C3] AS [C3],
                                                    [ss7].[C4] AS [C4],
                                                    [ss7].[C5] AS [C5],
                                                    [ss7].[C6] AS [C6],
                                                    (SELECT
                                                    ISNULL(SUM([m].[cost]), 0) AS [A1]
                                                FROM
                                                    [MedicalHistories] AS [m]
                                                LEFT OUTER JOIN [PatientBioDatas] AS [p] ON [m].[boiDataId] = [p].[bioDataId]
                                                WHERE
                                                    DatePart(year, [m].[date]) = @year7
                                                    AND DatePart(month, [m].[date]) = @month7
                                                    AND [ss7].[company] = [p].[company]) AS [C7]
                                                FROM
                                                    (
                                                        SELECT
                                                            Company,
                                                            [ss6].[C1] AS [C1],
                                                            [ss6].[C2] AS [C2],
                                                            [ss6].[C3] AS [C3],
                                                            [ss6].[C4] AS [C4],
                                                            [ss6].[C5] AS [C5],
                                                            (SELECT
                                                            ISNULL(SUM([m].[cost]), 0) AS [A1]
                                                        FROM
                                                            [MedicalHistories] AS [m]
                                                        LEFT OUTER JOIN [PatientBioDatas] AS [p] ON [m].[boiDataId] = [p].[bioDataId]
                                                        WHERE
                                                            DatePart(year, [m].[date]) = @year6
                                                            AND DatePart(month, [m].[date]) = @month6
                                                            AND [ss6].[company] = [p].[company]) AS [C6]
                                                        FROM
                                                            (
                                                                SELECT
                                                                    Company,
                                                                    [ss5].[C1] AS [C1],
                                                                    [ss5].[C2] AS [C2],
                                                                    [ss5].[C3] AS [C3],
                                                                    [ss5].[C4] AS [C4],
                                                                    (SELECT
                                                                    ISNULL(SUM([m].[cost]), 0) AS [A1]
                                                                FROM
                                                                    [MedicalHistories] AS [m]
                                                                LEFT OUTER JOIN [PatientBioDatas] AS [p] ON [m].[boiDataId] = [p].[bioDataId]
                                                                WHERE
                                                                    DatePart(year, [m].[date]) = @year5
                                                                    AND DatePart(month, [m].[date]) = @month5
                                                                    AND [ss5].[company] = [p].[company]) AS [C5]
                                                                FROM
                                                                    (
                                                                        SELECT
                                                                            Company,
                                                                            [ss4].[C1] AS [C1],
                                                                            [ss4].[C2] AS [C2],
                                                                            [ss4].[C3] AS [C3],
                                                                            (SELECT
                                                                            ISNULL(SUM([m].[cost]), 0) AS [A1]
                                                                        FROM
                                                                            [MedicalHistories] AS [m]
                                                                        LEFT OUTER JOIN [PatientBioDatas] AS [p] ON [m].[boiDataId] = [p].[bioDataId]
                                                                        WHERE
                                                                            DatePart(year, [m].[date]) = @year4
                                                                            AND DatePart(month, [m].[date]) = @month4
                                                                            AND [ss4].[company] = [p].[company]) AS [C4]
                                                                        FROM
                                                                            (
                                                                                SELECT
                                                                                    Company,
                                                                                    [ss3].[C1] AS [C1],
                                                                                    [ss3].[C2] AS [C2],
                                                                                    (SELECT
                                                                                    ISNULL(SUM([m].[cost]), 0) AS [A1]
                                                                                FROM
                                                                                    [MedicalHistories] AS [m]
                                                                                LEFT OUTER JOIN [PatientBioDatas] AS [p] ON [m].[boiDataId] = [p].[bioDataId]
                                                                                WHERE
                                                                                    DatePart(year, [m].[date]) = @year3
                                                                                    AND DatePart(month, [m].[date]) = @month3
                                                                                    AND [ss3].[company] = [p].[company]) AS [C3]
                                                                                FROM
                                                                                    (
                                                                                        SELECT
                                                                                            Company,
                                                                                            [ss2].[C1] AS [C1],
                                                                                            (SELECT
                                                                                            ISNULL(SUM([m].[cost]), 0) AS [A1]
                                                                                        FROM
                                                                                            [MedicalHistories] AS [m]
                                                                                        LEFT OUTER JOIN [PatientBioDatas] AS [p] ON [m].[boiDataId] = [p].[bioDataId]
                                                                                        WHERE
                                                                                            DatePart(year, [m].[date]) = @year2
                                                                                            AND DatePart(month, [m].[date]) = @month2
                                                                                            AND [ss2].[company] = [p].[company]) AS [C2]
                                                                                        FROM
                                                                                            (
                                                                                                SELECT
                                                                                                    Company,
                                                                                                    (SELECT
                                                                                                    ISNULL(SUM([m].[cost]), 0) AS [A1]
                                                                                                FROM
                                                                                                    [MedicalHistories] AS [m]
                                                                                                LEFT OUTER JOIN [PatientBioDatas] AS [p] ON [m].[boiDataId] = [p].[bioDataId]
                                                                                                WHERE
                                                                                                    DatePart(year, [m].[date]) = @year1
                                                                                                    AND DatePart(month, [m].[date]) = @month1
                                                                                                    AND [ss1].[company] = [p].[company]) AS [C1]
                                                                                                FROM
                                                                                                    (
                                                                                                        SELECT DISTINCT
                                                                                                            [p].[company] AS [Company]
                                                                                                        FROM
                                                                                                            [MedicalHistories] AS [m]
                                                                                                        LEFT OUTER JOIN [PatientBioDatas] AS [p] ON [m].[boiDataId] = [p].[bioDataId]
                                                                                                        WHERE
                                                                                                            DatePart(year, [m].[date]) = @year0
                                                                                                            AND company is not null
                                                                                                    ) AS [ss1]
                                                                                            ) AS [ss2]
                                                                                    ) AS [ss3]
                                                                            ) AS [ss4]
                                                                    ) AS [ss5]
                                                            ) AS [ss6]
                                                    ) AS [ss7]
                                            ) AS [ss8]
                                    ) AS [ss9]
                            ) AS [ss10]
                    ) AS [ss11]
            ) AS [ss12]
    ) AS [final] ORDER BY
            company ASC