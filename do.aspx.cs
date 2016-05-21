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
    protected string employeeId = null;
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
                DateTime dt = DateTime.Parse(dri[i].date);
                OleDbCommand MyCmd = new OleDbCommand("insert into bizdata "
                    + "(type,bizTime,employee,accused,accuser,court,courtRoom,judge,telephone,title,receivable,arrival,arrivalTime,remark,originalText) "
                    + "values(" + (int)dri[i].type
                        + ", '" + dt.ToString("yyyy-MM-dd hh:mm:ss") + "'"
                        + ", '" + employeeId + "'"
                        + ", '" + dri[i].accused + "'"
                        + ", '" + dri[i].accuser + "'"
                        + ", '" + dri[i].court + "'"
                        + ", '" + dri[i].courtRoom + "'"
                        + ", '" + dri[i].judge + "'"
                        + ", '" + dri[i].telephone + "'"
                        + ", '" + dri[i].title + "'"
                        + ", '" + dri[i].receivable + "'"
                        + ", '" + dri[i].arrival + "'"
                        + ", " + (dri[i].arrival != 0.0 ? "'" + DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss") + "'" : "NULL")
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

        OleDbDataAdapter Da = new OleDbDataAdapter("select A.*, B.name as employeeName " +
            "from bizdata A, employee B " +
            "where A.employee = B.id and bizTime between #" + Request["dateBegin"] + "# and #" + Request["dateEnd"] + " 23:59:59#", MyConn);
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
                + ", \"arrivalTime\":\"" + row["arrivalTime"] + "\""
                + ", \"employeeId\":\"" + row["employee"] + "\""
                + ", \"employeeName\":\"" + row["employeeName"] + "\""
                + ", \"remark\":\"" + row["remark"] + "\""
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
            DateTime dt = DateTime.Parse(dri[i].date);
            OleDbCommand MyCmd = new OleDbCommand("update bizdata set " +
                "type=" + (int)dri[i].type
                + ", accused='" + dri[i].accused + "'"
                + ", accuser='" + dri[i].accuser + "'"
                + ", court='" + dri[i].court + "'"
                + ", courtRoom='" + dri[i].courtRoom + "'"
                + ", telephone='" + dri[i].telephone + "'"
                + ", title='" + dri[i].title + "'"
                + ", judge='" + dri[i].judge + "'"
                + ", receivable='" + dri[i].receivable + "'"
                + ", arrival='" + dri[i].arrival + "'"
                + ", remark='" + dri[i].remark + "'"
                + ", arrivalTime=" + (dri[i].arrival != 0.0 ? "'" + DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss") + "'" : "NULL")
                + " where id=" + dri[i].id, MyConn);
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
        string sql = "SELECT datepart('m', bizTime) AS [month], SUM(receivable) AS receivable, SUM(arrival) AS arrival, COUNT(*) AS records"
            + " FROM bizdata"
            + " WHERE (DatePart('yyyy', bizTime) = '" + DateTime.Now.Year + "')"
            + " GROUP BY DatePart('m', bizTime)";

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
        sql = "SELECT COUNT(*) AS records, SUM(receivable) AS amount FROM bizdata WHERE (arrival = 0)";
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
    protected void Page_Load(object sender, EventArgs e)
    {
        employeeId = Request["employeeId"];

        string op = Request["op"];
        
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