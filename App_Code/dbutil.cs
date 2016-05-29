
using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
//using System.Runtime.Serialization.Json;
//using System.Web.Script.Serialization;
using System.Text;
using System.Data.OleDb;
using System.Configuration;

public class dbutil
{
    private OleDbConnection _db;
    public dbutil()
    {
        _db = new OleDbConnection(ConfigurationManager.AppSettings["dbconnect"]);
        _db.Open();
    }

    public void close()
    {
        _db.Close();
    }

    public DataTable query(string sql)
    {
        OleDbDataAdapter da = new OleDbDataAdapter(sql, _db);
        DataTable dt = new DataTable();
        da.Fill(dt);
        return dt;
    }

    public int execute(string sql)
    {
        OleDbCommand cmd = new OleDbCommand(sql, _db);
        return cmd.ExecuteNonQuery();
    }

    public string concatRows(ref DataTable dt, string field, string delimiter = ",")
    {
        string t = "";

        for (int i = 0; i < dt.Rows.Count; i++ )
        {
            t += dt.Rows[i][field];
            if (i != dt.Rows.Count - 1)
                t += delimiter;
        }

        return t;
    }

    public int guessEmployeeByCourt(string court)
    {
        DataTable dt = query("SELECT employee FROM region WHERE (InStr('" + court + "', name) > 0)");
        if (dt.Rows.Count != 1)
            return 0;
        return (int)dt.Rows[0][0];
    }

    public string getEmployeeRegions(int employee)
    {
        DataTable dt = query("SELECT name FROM region WHERE (employee = " + employee + ")");
        return concatRows(ref dt, "name");
    }

    public string getEmployeeId2NameMapping()
    {
        string json = "";

        DataTable dt = query("SELECT id,name FROM employee where userid <> 'superuser' and [level] <= 1");

        for (int i = 0; i < dt.Rows.Count; i++)
        {
            json += "{\"id\":\"" + dt.Rows[i]["id"] + "\", \"name\":\"" + dt.Rows[i]["name"] + "\"}";
            if (i != dt.Rows.Count - 1)
                json += ",";
        }

        return json;
    }
}