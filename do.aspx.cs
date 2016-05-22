using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Runtime.Serialization.Json;
using System.Web.Script.Serialization;
using System.Text;
using System.Data.OleDb;
using System.Data.SqlClient;

public partial class DataSave : System.Web.UI.Page
{
    protected string dbConnStr = @"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=D:\MyFiles\Projects\WenCuiMagazine\root\db\data.mdb";
    protected int employeeId = 0;
    protected int userLevel = 1;

    protected void SaveData()
    {
        string a = Request["data"];
        if (a != null)
        {
            MemoryStream ms = new MemoryStream(Encoding.UTF8.GetBytes(a));
            List<DataRecordItem> dri = (List<DataRecordItem>)(new DataContractJsonSerializer(typeof(List<DataRecordItem>))).ReadObject(ms);

            //OleDbDataAdapter adapter = new OleDbDataAdapter(command, connectionString)
            OleDbConnection MyConn = new OleDbConnection(@"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=D:\MyFiles\Projects\WenCuiMagazine\root\db\data.mdb");
            //MyCmd.Connection.Open();
            MyConn.Open();
            //SqlConnection connection = new SqlConnection(@"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=D:\MyFiles\Projects\WenCuiMagazine\root\db\data.mdb");


            for (int i = 0; i < dri.Count; i++)
            {
                string publishTime = "NULL";
                if (dri[i].publishTime != null && dri[i].publishTime != "")
                {
                    publishTime = "'" + DateTime.Parse(dri[i].publishTime).ToString("yyyy-MM-dd hh:mm:ss") + "'";
                }

                DateTime dt = DateTime.Parse(dri[i].date);
                OleDbCommand MyCmd = new OleDbCommand("insert into bizdata "
                    + "(type,bizTime,publishTime,employee,accused,accuser,court,courtRoom,judge,telephone,title,receivable,arrival,arrivalTime,remark,originalText) "
                    + "values(" + (int)dri[i].type
                        + ", '" + dt.ToString("yyyy-MM-dd hh:mm:ss") + "'"
                        + ", " + publishTime
                        + ", '" + dri[i].employee + "'"
                        + ", '" + dri[i].accused + "'"
                        + ", '" + dri[i].accuser + "'"
                        + ", '" + dri[i].court + "'"
                        + ", '" + dri[i].courtRoom + "'"
                        + ", '" + dri[i].judge + "'"
                        + ", '" + dri[i].telephone + "'"
                        + ", '" + dri[i].title + "'"
                        + ", " + (dri[i].receivable != 88888888 ? "'" + dri[i].receivable + "'" : "NULL")
                        + ", " + (dri[i].arrival != 88888888 ? "'" + dri[i].arrival + "'" : "NULL")
                        + ", " + (dri[i].arrival != 88888888 ? "'" + DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss") + "'" : "NULL")
                        + ", '" + dri[i].remark + "'"
                        + ", '" + dri[i].para.text + "'"
                    + ")", MyConn);
                MyCmd.ExecuteNonQuery();

                //SqlDataAdapter adapter = new SqlDataAdapter("select * from bizdata", connection);
                //DataTable dataTable = new DataTable();
                //adapter.Fill(dataTable);
                ////添加数据
                //DataRow newRow = dataTable.NewRow();
                ////newRow["id"] = "tesr";
                //newRow["accused"] = dri[i].accused;
                //newRow["accuser"] = dri[i].accuser;
                //newRow["court"] = dri[i].court;
                //newRow["courtRoom"] = dri[i].courtRoom;
                //newRow["originalText"] = dri[i].para.text;

                //dataTable.Rows.Add(newRow);
                //SqlCommandBuilder builder = new SqlCommandBuilder(adapter);
                //adapter.Update(dataTable); //更新到数据库
            }

            //MyCmd.ExecuteNonQuery()
            //SqlDataAdapter
            //OleDbDataReader Dr = MyCmd.ExecuteReader();
            //dt = GetDataTableFromDataReader(Dr);
            //MyConn.ex
            //MyCmd.Connection.q
            //MyCmd.ExecuteNonQuery();

            //connection.Close();
            MyConn.Close();

            Response.Write("{\"status\":\"0\", \"successNum\":\"" + dri.Count + "\", \"message\":\"操作成功。\"}");
        }
    }

    void QueryData()
    {
        //MemoryStream ms = new MemoryStream(Encoding.UTF8.GetBytes(a));
        //List<DataRecordItem> dri = (List<DataRecordItem>)(new DataContractJsonSerializer(typeof(List<DataRecordItem>))).ReadObject(ms);

        //OleDbDataAdapter adapter = new OleDbDataAdapter(command, connectionString)
        OleDbConnection MyConn = new OleDbConnection(@"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=D:\MyFiles\Projects\WenCuiMagazine\root\db\data.mdb");
        //MyCmd.Connection.Open();
        MyConn.Open();
        //SqlConnection connection = new SqlConnection(@"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=D:\MyFiles\Projects\WenCuiMagazine\root\db\data.mdb");

        string sql = "select * " +
            " from bizdata" +
            " where bizTime between #" + Request["dateBegin"] + "# and #" + Request["dateEnd"] + " 23:59:59#";

        if (userLevel != 0)
            sql += " and employee = " + employeeId + "";

        sql += " order by bizTime desc";

        OleDbDataAdapter Da = new OleDbDataAdapter(sql, MyConn);
        DataTable dt = new DataTable();
        Da.Fill(dt);

        string json = "{\n"
            + "  \"type\": \"data\","
            + "  \"status\":0,"
            + "  \"count\": \"" + dt.Rows.Count + "\","
            + "  \"records\": [\n";

        //for (int row = 0; row < dt.Rows.Count; row++)
        foreach (DataRow row in dt.Rows)  
        {
            json += "\n{"
                + "  \"id\":\"" + row["id"] + "\""
                + ", \"accused\":\"" + row["accused"] + "\""
                + ", \"accuser\":\"" + row["accuser"] + "\""
                + ", \"type\":\"" + (int)row["type"] + "\""
                + ", \"court\":\"" + row["court"] + "\""
                + ", \"date\":\"" + row["bizTime"] + "\""
                + ", \"courtRoom\":\"" + row["courtRoom"] + "\""
                + ", \"telephone\":\"" + row["telephone"] + "\""
                + ", \"title\":\"" + row["title"] + "\""
                + ", \"judge\":\"" + row["judge"] + "\""
                + ", \"receivable\":\"" + row["receivable"] + "\""
                + ", \"arrival\":\"" + row["arrival"] + "\""
                + ", \"arrivalOld\":\"" + row["arrival"] + "\""
                + ", \"arrivalTime\":\"" + row["arrivalTime"] + "\""
                + ", \"arrivalFrom\":\"" + row["arrivalFrom"] + "\""
                + ", \"employee\":\"" + row["employee"] + "\""
                + ", \"remark\":\"" + row["remark"] + "\""
                + ", \"publishTime\":\"" + row["publishTime"] + "\""
                + ", \"magazine\":\"" + row["magazine"] + "\""
                + ", \"para\":{"
                    + "\"text\":\"" + row["originalText"] + "\""
                    + "}"
                + "},";
        }
        char[] trimChars = { ',' };
        json = json.TrimEnd(trimChars);
        MyConn.Close();
        json += "]}";

        Response.Write(json);
        //for (int i = 0; i < dri.Count; i++)
        //{
        //    DateTime dt = DateTime.Parse(dri[i].date);
        //    OleDbCommand MyCmd = new OleDbCommand("insert into bizdata (type,bizTime,accused,accuser,court,courtRoom,receivable,arrival,arrivalTime,originalText) " +
        //        "values(" + (int)dri[i].type
        //            + ", '" + dt.ToString("yyyy-MM-dd hh:mm:ss") + "'"
        //            + ", '" + dri[i].accused + "'"
        //            + ", '" + dri[i].accuser + "'"
        //            + ", '" + dri[i].court + "'"
        //            + ", '" + dri[i].courtRoom + "'"
        //            + ", '" + dri[i].receivable + "'"
        //            + ", '" + dri[i].arrival + "'"
        //            + ", " + (dri[i].arrival != 0.0 ? "'" + DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss") + "'" : "NULL")
        //            + ", '" + dri[i].para.text + "'"
        //        + ")", MyConn);
        //    MyCmd.ExecuteNonQuery();



        //    //SqlDataAdapter adapter = new SqlDataAdapter("select * from bizdata", connection);
        //    //DataTable dataTable = new DataTable();
        //    //adapter.Fill(dataTable);
        //    ////添加数据
        //    //DataRow newRow = dataTable.NewRow();
        //    ////newRow["id"] = "tesr";
        //    //newRow["accused"] = dri[i].accused;
        //    //newRow["accuser"] = dri[i].accuser;
        //    //newRow["court"] = dri[i].court;
        //    //newRow["courtRoom"] = dri[i].courtRoom;
        //    //newRow["originalText"] = dri[i].para.text;

        //    //dataTable.Rows.Add(newRow);
        //    //SqlCommandBuilder builder = new SqlCommandBuilder(adapter);
        //    //adapter.Update(dataTable); //更新到数据库
        //}

        //MyCmd.ExecuteNonQuery()
        //SqlDataAdapter
        //OleDbDataReader Dr = MyCmd.ExecuteReader();
        //dt = GetDataTableFromDataReader(Dr);
        //MyConn.ex
        //MyCmd.Connection.q
        //MyCmd.ExecuteNonQuery();

        //connection.Close();
    }

    protected void UpdateData()
    {
        string jsonModify = Request["modify"];

        MemoryStream ms = new MemoryStream(Encoding.UTF8.GetBytes(jsonModify));
        List<DataRecordItem> dri = (List<DataRecordItem>)(new DataContractJsonSerializer(typeof(List<DataRecordItem>))).ReadObject(ms);

        //OleDbDataAdapter adapter = new OleDbDataAdapter(command, connectionString)
        OleDbConnection MyConn = new OleDbConnection(@"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=D:\MyFiles\Projects\WenCuiMagazine\root\db\data.mdb");
        //MyCmd.Connection.Open();
        MyConn.Open();
        //SqlConnection connection = new SqlConnection(@"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=D:\MyFiles\Projects\WenCuiMagazine\root\db\data.mdb");

        for (int i = 0; i < dri.Count; i++)
        {
            string publishTime = "NULL";
            if (dri[i].publishTime != null && dri[i].publishTime != "")
            {
                publishTime = "'" + DateTime.Parse(dri[i].publishTime).ToString("yyyy-MM-dd hh:mm:ss") + "'";
            }
            //DateTime dt = DateTime.Parse(dri[i].date);
            string sql = "update bizdata set " +
                "type=" + (int)dri[i].type
                + ", accused='" + dri[i].accused + "'"
                + ", accuser='" + dri[i].accuser + "'"
                + ", court='" + dri[i].court + "'"
                + ", publishTime=" + publishTime
                + ", employee='" + dri[i].employee + "'"
                + ", courtRoom='" + dri[i].courtRoom + "'"
                + ", telephone='" + dri[i].telephone + "'"
                + ", title='" + dri[i].title + "'"
                + ", judge='" + dri[i].judge + "'"
                + ", magazine='" + dri[i].magazine + "'"
                + ", remark='" + dri[i].remark + "'"
                + ", arrivalFrom='" + dri[i].arrivalFrom + "'"
                + ", receivable=" + (dri[i].receivable != 88888888 ? "'" + dri[i].receivable + "'" : "NULL");
            if (dri[i].arrival == 88888888)
            {
                sql += ", arrival=NULL, arrivalTime=NULL";
            }
            else if (dri[i].arrival != dri[i].arrivalOld)
            {
                sql += ", arrivalTime='" + DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss") + "'"
                    + ", arrival='" + dri[i].arrival + "'";
            }
            sql += " where id=" + dri[i].id;

            OleDbCommand MyCmd = new OleDbCommand(sql, MyConn);
            MyCmd.ExecuteNonQuery();
        }

        OleDbCommand delCmd = new OleDbCommand("delete from bizdata where id in (" + Request["delete"] + ")", MyConn);
        delCmd.ExecuteNonQuery();

        MyConn.Close();

        string json = "{\n"
            + "  \"status\":0}";
        Response.Write(json);
    }

    protected void RealtimeInfo()
    {
        //string sql = "SELECT datepart('m', bizTime) AS [month], SUM(receivable) AS receivable, SUM(arrival) AS arrival, COUNT(*) AS records"
        //    + " FROM bizdata"
        //    + " WHERE DatePart('yyyy', bizTime) = '" + DateTime.Now.Year + "'";

        //if (userLevel != 0)
        //    sql += " and employee = " + employeeId + "";

        // sql += " GROUP BY DatePart('m', bizTime)";

         string sql =
             " SELECT B.[month], A.arrival, B.receivable, B.records" +
             " FROM ((SELECT DatePart('m', arrivalTime) AS [month], SUM(arrival) AS arrival" +
             "       FROM bizdata" +
             "       WHERE DatePart('yyyy', arrivalTime) = '" + DateTime.Now.Year + "'";
             if (userLevel != 0)
                 sql += " and employee = " + employeeId + "";

         sql += "       GROUP BY DatePart('m', arrivalTime)) A " +
             "     RIGHT OUTER JOIN" +
             "      (SELECT DatePart('m', bizTime) AS [month], SUM(receivable) AS receivable, COUNT(*) as records" +
             "       FROM bizdata " +
             "       WHERE DatePart('yyyy', bizTime) = '" + DateTime.Now.Year + "'";
             if (userLevel != 0)
                 sql += " and employee = " + employeeId + "";

        sql += "       GROUP BY DatePart('m', bizTime)) B " +
            "		ON A.[month] = B.[month])";

        OleDbConnection conn = new OleDbConnection(dbConnStr);
        //MyCmd.Connection.Open();
        conn.Open();
        //SqlConnection connection = new SqlConnection(@"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=D:\MyFiles\Projects\WenCuiMagazine\root\db\data.mdb");

        OleDbDataAdapter Da = new OleDbDataAdapter(sql, conn);
        DataTable dt = new DataTable();
        Da.Fill(dt);

        string json = "{\n"
            + "  \"status\":0,"
            + "  \"monthStat\": [\n";

        //for (int row = 0; row < dt.Rows.Count; row++)
        foreach (DataRow row in dt.Rows)
        {
            json += "\n{"
                + "  \"month\":\"" + row["month"] + "\""
                + ", \"receivable\":\"" + row["receivable"] + "\""
                + ", \"arrival\":\"" + row["arrival"] + "\""
                + ", \"records\":\"" + row["records"] + "\""
                + "},";
        }
        char[] trimChars = { ',' };
        json = json.TrimEnd(trimChars);
        json += "],";

        // unarrival records
        sql = "SELECT COUNT(*) AS records, SUM(receivable) AS amount FROM bizdata WHERE (arrival is NULL or receivable is NULL)";
        if (userLevel != 0)
            sql += " and employee = " + employeeId + "";

        Da = new OleDbDataAdapter(sql, conn);
        dt = new DataTable();
        Da.Fill(dt);
        if (dt.Rows.Count > 0)
        {
            json += "\"unarrivals\": {\"records\":\"" + dt.Rows[0]["records"] + "\""
                + ", \"amount\":\"" + dt.Rows[0]["amount"] + "\""
                + "},";
        }
        else
        {
            json += "unarrivals: {\"records\":\"0\"},";
        }

        // today's records
        sql = "SELECT COUNT(*) AS records, SUM(receivable) AS amount"
            + " FROM bizdata"
            + " WHERE (bizTime BETWEEN #" + DateTime.Now.ToString("yyyy-M-dd") + "# AND #" + DateTime.Now.ToString("yyyy-M-dd") + " 23:59:59#)";
        if (userLevel != 0)
            sql += " and employee = " + employeeId + "";

        Da = new OleDbDataAdapter(sql, conn);
        dt = new DataTable();
        Da.Fill(dt);
        if (dt.Rows.Count > 0)
        {
            json += "\"today\": {\"records\":\"" + dt.Rows[0]["records"] + "\""
                + ", \"amount\":\"" + dt.Rows[0]["amount"] + "\""
                + "},";
        }
        else
        {
            json += "today: {\"records\":\"0\"},";
        }

        // end of json
        json += "\"end\":\"1\"";
        json += "}";

        conn.Close();

        Response.Write(json);
    }
    private void UserLogin()
    {
        string userName = Request["userName"];
        string userPwd = Request["userPwd"];

        OleDbConnection conn = new OleDbConnection(dbConnStr);
        //MyCmd.Connection.Open();
        conn.Open();
        //SqlConnection connection = new SqlConnection(@"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=D:\MyFiles\Projects\WenCuiMagazine\root\db\data.mdb");

        string json = "";

        OleDbDataAdapter Da = new OleDbDataAdapter("select * from employee where userid = '" + userName + "' and passwd = '" + userPwd + "'", conn);
        DataTable dt = new DataTable();
        Da.Fill(dt);
        if (dt.Rows.Count == 0)
        {
            json += "{\"status\":\"1\"}";
        }
        else
        {
            Application["userId"] = dt.Rows[0]["id"];
            Application["userName"] = dt.Rows[0]["userid"];
            Application["userLevel"] = dt.Rows[0]["level"];
            Application["userFullName"] = dt.Rows[0]["name"];
            json += "{\"status\":\"0\", \"url\":\"bizdata.aspx\"}";
        }
        conn.Close();

        Response.Write(json);
    }

    private void UserLogout()
    {
        Application["userId"] = null;
        Application["userName"] = null;
        Application["userLevel"] = null;
        Application["userFullName"] = null;

        Response.Redirect("index.aspx", true);
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        string op = Request["op"];

        if (op == "login")
        {
            UserLogin();
            return;
        }
        if (op == "logout")
        {
            UserLogout();
            return;
        }

        if (Application["userId"] == null)
        {
            Response.Redirect("index.aspx", true);
        }

        userLevel = (int)Application["userLevel"];
        employeeId = (int)Application["userId"];

        switch (op)
        {
            case "save":
                SaveData();
                return;
            case "query":
                QueryData();
                return;
            case "update":
                UpdateData();
                return;
            case "rtinfo":
                RealtimeInfo();
                return;
        }
    }

}