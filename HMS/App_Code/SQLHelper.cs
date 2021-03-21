using System;
using System.IO;
using System.Web;

public class SQLHelper
{
    public static String GetQueryString(String sqlFile)
    {
        string path = HttpContext.Current.Server.MapPath("/App_Data/SQLQuery/" + sqlFile);
        return @"" + File.ReadAllText(path);
    }

}