using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;

public class SQLHelper
{
    public static String GetQueryString(String sqlFile)
    {
        string path = HttpContext.Current.Server.MapPath("/App_Data/SQLQuery/" + sqlFile);
        return @"" + File.ReadAllText(path);
    }

    public static DataTable GetCompanyDataTable(int? year = null)
    {
        String connectionString = ConfigurationManager.ConnectionStrings["HMDB"].ConnectionString;
        SqlConnection connection = new SqlConnection(connectionString);
        SqlDataAdapter adapter = new SqlDataAdapter();
        string query = GetQueryString(year != null? "distinct_companies_by_year.sql" : "distinct_companies.sql");
        adapter.SelectCommand = new SqlCommand(query, connection);
        if(year != null)
        adapter.SelectCommand.Parameters.AddWithValue("@year0", year);

        DataTable myDataTable = new DataTable();

        connection.Open();
        try
        {
            adapter.Fill(myDataTable);
        }
        finally
        {
            connection.Close();
        }

        return myDataTable;
    }

    public static DataTable GetAllPatients()
    {
        string query = GetQueryString("all_patients.sql");
        String connectionString = ConfigurationManager.ConnectionStrings["HMDB"].ConnectionString;
        SqlConnection connection = new SqlConnection(connectionString);
        using (SqlDataAdapter adapter = new SqlDataAdapter())
        {
            adapter.SelectCommand = new SqlCommand(query, connection);

            DataTable myDataTable = new DataTable();

            connection.Open();
            try
            {
                adapter.Fill(myDataTable);
            }
            catch (Exception e)
            {
                Console.Write(e.ToString());
            }
            finally
            {
                connection.Close();
            }
            return myDataTable;
        }
    }

    public static DataTable GetPatientBiodata(int boidataID)
    {
        string query = GetQueryString("patient_biodata.sql");
        string connectionString = ConfigurationManager.ConnectionStrings["HMDB"].ConnectionString;
        SqlConnection connection = new SqlConnection(connectionString);
        using (SqlDataAdapter adapter = new SqlDataAdapter())
        {
            adapter.SelectCommand = new SqlCommand(query, connection);
            adapter.SelectCommand.Parameters.AddWithValue("@biodata_id", boidataID);

            DataTable myDataTable = new DataTable();

            connection.Open();
            try
            {
                adapter.Fill(myDataTable);
            }
            finally
            {
                connection.Close();
            }
            return myDataTable;
        }
    }

    public static DataTable GetPatientHistory(int biodata_id)
    {
        string query = GetQueryString("patient_history.sql");
        string connectionString = ConfigurationManager.ConnectionStrings["HMDB"].ConnectionString;
        SqlConnection connection = new SqlConnection(connectionString);
        using (SqlDataAdapter adapter = new SqlDataAdapter())
        {
            adapter.SelectCommand = new SqlCommand(query, connection);
            adapter.SelectCommand.Parameters.AddWithValue("@biodata_id", biodata_id);

            DataTable myDataTable = new DataTable();

            connection.Open();
            try
            {
                adapter.Fill(myDataTable);
            }
            finally
            {
                connection.Close();
            }

            return myDataTable;
        }
    }

    public static DataTable GetDistinctPeriodicPatientsFromCompany(string company, string startDate, string endDate)
    {
        string query = GetQueryString("distinct_patients_from_company.sql");
        String connectionString = ConfigurationManager.ConnectionStrings["HMDB"].ConnectionString;
        SqlConnection connection = new SqlConnection(connectionString);
        using (SqlDataAdapter adapter = new SqlDataAdapter())
        {
            adapter.SelectCommand = new SqlCommand(query, connection);
            adapter.SelectCommand.Parameters.AddWithValue("@company", company);
            adapter.SelectCommand.Parameters.AddWithValue("@start_date", startDate);
            adapter.SelectCommand.Parameters.AddWithValue("@end_date", endDate);

            DataTable myDataTable = new DataTable();

            connection.Open();
            try
            {
                adapter.Fill(myDataTable);
            }
            finally
            {
                connection.Close();
            }

            return myDataTable;
        }
    }


    public static DataTable GetPeriodicBillingHistoryForCompany(string startDate, string endDate, string company)
    {
        String connectionString = ConfigurationManager.ConnectionStrings["HMDB"].ConnectionString;
        String query = GetQueryString("billing_history_per_company.sql");
        SqlConnection connection = new SqlConnection(connectionString);
        using (SqlDataAdapter adapter = new SqlDataAdapter())
        {
            adapter.SelectCommand = new SqlCommand(query, connection);

            adapter.SelectCommand.Parameters.AddWithValue("@start_date", startDate);
            adapter.SelectCommand.Parameters.AddWithValue("@end_date", endDate);
            adapter.SelectCommand.Parameters.AddWithValue("@company", company);

            DataTable myDataTable = new DataTable();

            connection.Open();
            try
            {
                adapter.Fill(myDataTable);
            }
            finally
            {
                connection.Close();
            }

            return myDataTable;
        }
    }
}