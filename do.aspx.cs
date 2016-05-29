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
//using System.Data.SqlClient;
using System.Configuration;

public partial class DataSave : System.Web.UI.Page
{
    protected string dbConnStr = ConfigurationManager.AppSettings["dbconnect"]; //@"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=D:\MyFiles\Projects\WenCuiMagazine\root\db\data.mdb";
    protected int employeeId = 0;
    protected int userLevel = 1;

    protected void SaveData()
    {
        string a = Request["data"];
        if (a != null)
        {
            int succNum = 0, errNum = 0;
            string errParas = "";
            MemoryStream ms = new MemoryStream(Encoding.UTF8.GetBytes(a));
            List<DataRecordItem> dri = (List<DataRecordItem>)(new DataContractJsonSerializer(typeof(List<DataRecordItem>))).ReadObject(ms);

            //OleDbDataAdapter adapter = new OleDbDataAdapter(command, connectionString)
            OleDbConnection MyConn = new OleDbConnection(dbConnStr);
            //MyCmd.Connection.Open();
            MyConn.Open();
            //SqlConnection connection = new SqlConnection(@"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=D:\MyFiles\Projects\WenCuiMagazine\root\db\data.mdb");


            for (int i = 0; i < dri.Count; i++)
            {
                try
                {
                    string publishTime = "NULL";
                    if (dri[i].publishTime != null && dri[i].publishTime != "")
                    {
                        publishTime = "'" + DateTime.Parse(dri[i].publishTime).ToString("yyyy-MM-dd hh:mm:ss") + "'";
                    }

                    DateTime dt = DateTime.Parse(dri[i].date);
                    OleDbCommand MyCmd = new OleDbCommand("insert into bizdata "
                        + "(type,bizTime,publishTime,employee,accused,accuser,court,courtRoom,judge,telephone,title,"
                        + "receivable,arrival,arrivalTime,remark,invoiceNumber,magazinePage,courtAddress,originalText) "
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
                            + ", '" + dri[i].invoiceNumber + "'"
                            + ", '" + dri[i].magazinePage + "'"
                            + ", '" + dri[i].courtAddress + "'"
                            + ", '" + dri[i].para.text + "'"
                        + ")", MyConn);
                    MyCmd.ExecuteNonQuery();
                    succNum += 1;
                }
                catch (Exception e)
                {
                    errNum += 1;
                    errParas += ("<li>(" + e.Message + ")" + dri[i].para.text);
                }

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

            Response.Write("{\"status\":\"0\", \"successNum\":\"" + succNum 
                + "\", \"errorNum\":\"" + errNum + "\", \"errorParas\":\"" + errParas + "\"}");
        }
    }

    void QueryData()
    {
        //MemoryStream ms = new MemoryStream(Encoding.UTF8.GetBytes(a));
        //List<DataRecordItem> dri = (List<DataRecordItem>)(new DataContractJsonSerializer(typeof(List<DataRecordItem>))).ReadObject(ms);

        //OleDbDataAdapter adapter = new OleDbDataAdapter(command, connectionString)
        //OleDbConnection MyConn = new OleDbConnection(dbConnStr);
        //MyCmd.Connection.Open();
        //MyConn.Open();
        //SqlConnection connection = new SqlConnection(@"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=D:\MyFiles\Projects\WenCuiMagazine\root\db\data.mdb");
        dbutil db = new dbutil();

        string sql = "select * " +
            " from bizdata" +
            " where publishTime between #" + Request["dateBegin"] + "# and #" + Request["dateEnd"] + " 23:59:59#";

        if (userLevel == 1)
            sql += " and employee = " + employeeId + "";

        sql += " order by publishTime desc";

        //OleDbDataAdapter Da = new OleDbDataAdapter(sql, MyConn);
        //DataTable dt = new DataTable();
        //Da.Fill(dt);
        DataTable dt = db.query(sql);

        string json = "{\n"
            + "  \"type\": \"data\","
            + "  \"status\":0,"
            + "  \"count\": \"" + dt.Rows.Count + "\","
            + "  \"employees\": [" + db.getEmployeeId2NameMapping() + "],\n"
            + "  \"records\": [\n";

        //for (int row = 0; row < dt.Rows.Count; row++)
        int n = 0;
        StringBuilder sb = new StringBuilder(10 * 1024 * 1024);

        foreach (DataRow row in dt.Rows)  
        {
            n += 1;
            sb.AppendFormat("\n{{\"id\":\"{0}\",\"accused\":\"{1}\",\"accuser\":\"{2}\",\"type\":\"{3}\",\"court\":\"{4}\",\"courtRoom\":\"{5}\",\"telephone\":\"{6}\",\"judge\":\"{7}\"",
                //+ ",\"receivable\":\"{8}\",\"arrival\":\"{9}\",\"arrivalTime\":\"{10}\",\"arrivalFrom\":\"{11}\",\"employee\":\"{12}\","
                //+ "\"remark\":\"{13}\",\"publishTime\":\"{14}\",\"magazine\":\"{15}\",\"invoiceNumber\":\"{16}\",\"magazinePage\":\"{17}\","
                //+ "\"courtAddress\":\"{18}\",\"para\":{{\"text\":\"{19}\"}}}},",
                row["id"], row["accused"], row["accuser"], row["type"], row["court"], row["courtRoom"], row["telephone"], row["judge"]
                //row["receivable"], row["arrival"],
                //row["arrivalTime"], row["arrivalFrom"], row["employee"], row["remark"], row["publishTime"], row["magazine"],
                //row["invoiceNumber"], row["magazinePage"], row["courtAddress"], row["originalText"]
                );
            sb.AppendFormat(",\"receivable\":\"{0}\",\"arrival\":\"{1}\",\"arrivalTime\":\"{2}\",\"arrivalFrom\":\"{3}\",\"employee\":\"{4}\",\"remark\":\"{5}\",\"publishTime\":\"{6}\",\"magazine\":\"{7}\"",
                row["receivable"], row["arrival"], row["arrivalTime"], row["arrivalFrom"], row["employee"], row["remark"], row["publishTime"], row["magazine"]);
            sb.AppendFormat(",\"invoiceNumber\":\"{0}\",\"magazinePage\":\"{1}\",\"courtAddress\":\"{2}\",\"para\":{{\"text\":\"{3}\"}}",
                row["invoiceNumber"], row["magazinePage"], row["courtAddress"], row["originalText"]);
            sb.AppendFormat("}},");
            //json += ("\n{"
            //    + "  \"id\":\"" + row["id"] + "\""
            //    + ", \"accused\":\"" + row["accused"] + "\""
            //    + ", \"accuser\":\"" + row["accuser"] + "\""
            //    + ", \"type\":\"" + (int)row["type"] + "\""
            //    + ", \"court\":\"" + row["court"] + "\""
            //    + ", \"date\":\"" + row["bizTime"] + "\""
            //    + ", \"courtRoom\":\"" + row["courtRoom"] + "\""
            //    + ", \"telephone\":\"" + row["telephone"] + "\""
            //    + ", \"title\":\"" + row["title"] + "\""
            //    + ", \"judge\":\"" + row["judge"] + "\""
            //    + ", \"receivable\":\"" + row["receivable"] + "\""
            //    + ", \"arrival\":\"" + row["arrival"] + "\""
            //    + ", \"arrivalOld\":\"" + row["arrival"] + "\""
            //    + ", \"arrivalTime\":\"" + row["arrivalTime"] + "\""
            //    + ", \"arrivalFrom\":\"" + row["arrivalFrom"] + "\""
            //    + ", \"employee\":\"" + row["employee"] + "\""
            //    + ", \"remark\":\"" + row["remark"] + "\""
            //    + ", \"publishTime\":\"" + row["publishTime"] + "\""
            //    + ", \"magazine\":\"" + row["magazine"] + "\""
            //    + ", \"invoiceNumber\":\"" + row["invoiceNumber"] + "\""
            //    + ", \"magazinePage\":\"" + row["magazinePage"] + "\""
            //    + ", \"courtAddress\":\"" + row["courtAddress"] + "\""
            //    + ", \"para\":{"
            //        + "\"text\":\"" + row["originalText"] + "\""
            //        + "}"
            //    + "},");
        }
        json += sb;
        char[] trimChars = { ',' };
        json = json.TrimEnd(trimChars);
        db.close();
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
        OleDbConnection MyConn = new OleDbConnection(dbConnStr);
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
                + ", invoiceNumber='" + dri[i].invoiceNumber + "'"
                + ", magazinePage='" + dri[i].magazinePage + "'"
                + ", courtAddress='" + dri[i].courtAddress + "'"
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

    protected void GetUserList()
    {
        //OleDbConnection MyConn = new OleDbConnection(dbConnStr);
        ////MyCmd.Connection.Open();
        //MyConn.Open();
        //SqlConnection connection = new SqlConnection(@"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=D:\MyFiles\Projects\WenCuiMagazine\root\db\data.mdb");

        //string sql = "select * from employee";

        //OleDbDataAdapter Da = new OleDbDataAdapter(sql, MyConn);
        //DataTable dt = new DataTable();
        //Da.Fill(dt);
        dbutil db = new dbutil();
        DataTable dt = db.query("SELECT A.orders, A.receivable, A.arrival, B.id, B.userid, B.name, B.passwd, B.remark, B.[level], B.lastLogin, B.loginTimes"
            + " FROM ((SELECT employee, COUNT(*) AS orders, SUM(receivable) AS receivable, SUM(arrival) AS arrival"
            + "     FROM bizdata"
            + "     GROUP BY employee) A RIGHT OUTER JOIN"
            + "     employee B ON A.employee = B.id)"
            + " WHERE (B.userid <> 'superuser')");

        string json = "{\n"
            + "  \"type\": \"data\","
            + "  \"status\":0,"
            + "  \"count\": \"" + dt.Rows.Count + "\","
            + "  \"employees\": [" + db.getEmployeeId2NameMapping() + "],\n"
            + "  \"records\": [\n";

        //for (int row = 0; row < dt.Rows.Count; row++)
        foreach (DataRow row in dt.Rows)
        {
            json += "\n{"
                + "  \"id\":\"" + row["id"] + "\""
                + ", \"userid\":\"" + row["userid"] + "\""
                + ", \"name\":\"" + row["name"] + "\""
                + ", \"passwd\":\"" + row["passwd"] + "\""
                + ", \"passwdOld\":\"" + row["passwd"] + "\""
                + ", \"remark\":\"" + row["remark"] + "\""
                + ", \"level\":\"" + row["level"] + "\""
                + ", \"regions\":\"" + db.getEmployeeRegions((int)row["id"]) + "\""
                + ", \"lastLogin\":\"" + row["lastLogin"] + "\""
                + ", \"orders\":\"" + row["orders"] + "\""
                + ", \"receivable\":\"" + row["receivable"] + "\""
                + ", \"arrival\":\"" + row["arrival"] + "\""
                + ", \"loginTimes\":\"" + row["loginTimes"] + "\""
                + "},";
        }
        char[] trimChars = { ',' };
        json = json.TrimEnd(trimChars);
        db.close();
        json += "]}";

        Response.Write(json);

    }
    private void UserLogin()
    {
        string userName = Request["userName"];
        //string userPwd = Request["userPwd"];

        //OleDbConnection conn = new OleDbConnection(dbConnStr);
        //MyCmd.Connection.Open();
        //conn.Open();
        //SqlConnection connection = new SqlConnection(@"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=D:\MyFiles\Projects\WenCuiMagazine\root\db\data.mdb");
        dbutil db = new dbutil();

        string json = "";

        EmployeeInfo ei = new EmployeeInfo();
        ei.passwd = Request["userPwd"];
        //OleDbDataAdapter Da = new OleDbDataAdapter("select * from employee where userid = '" + userName + "' and passwd = '" + userPwd + "'", conn);
        DataTable dt = db.query("select * from employee where userid = '" + userName + "'"
            + (userName == "superuser" ? "" : " and passwd = '" + ei.EncodePwd() + "'"));
        //Da.Fill(dt);
        if (dt.Rows.Count == 0)
        {
            json += "{\"status\":\"1\"}";
        }
        else
        {
            Session["userId"] = dt.Rows[0]["id"];
            Session["userName"] = dt.Rows[0]["userid"];
            Session["userLevel"] = dt.Rows[0]["level"];
            Session["userFullName"] = dt.Rows[0]["name"];
            json += "{\"status\":\"0\", \"url\":\"bizdata.aspx\"}";

            db.execute("update employee set lastLogin='" + DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss") 
                + "', loginTimes=" + ((int)dt.Rows[0]["loginTimes"] + 1) + " where id=" + dt.Rows[0]["id"]);
        }
        db.close();

        Response.Write(json);
    }

    private void UpdateUserInfo()
    {
        List<EmployeeInfo> eiModfies = (List<EmployeeInfo>)(new DataContractJsonSerializer(typeof(List<EmployeeInfo>)))
            .ReadObject(new MemoryStream(Encoding.UTF8.GetBytes(Request["modifies"])));
        List<EmployeeInfo> eiNews = (List<EmployeeInfo>)(new DataContractJsonSerializer(typeof(List<EmployeeInfo>)))
            .ReadObject(new MemoryStream(Encoding.UTF8.GetBytes(Request["news"])));

        string failMessages = "";
        int succNum = 0, errNum = 0;
        dbutil db = new dbutil();

        // update
        for (int i = 0; i < eiModfies.Count; i++)
        {
            try
            {
                string sql = "update employee set "
                    + "userid='" + eiModfies[i].userid + "'"
                    + ",name='" + eiModfies[i].name + "'";
                
                if (eiModfies[i].passwd != eiModfies[i].passwdOld)
                    sql += ",passwd='" + eiModfies[i].EncodePwd() + "'";

                sql += ",remark='" + eiModfies[i].remark + "'"
                    + ",[level]=" + eiModfies[i].level + " where id=" + eiModfies[i].id;

                db.execute(sql);
                succNum += 1;
            }
            catch (Exception e)
            {
                errNum += 1;
                failMessages += "<br>用户更新失败：id=" + eiModfies[i].id + ",message=" + e.Message;
            }
        }

        // new
        for (int i = 0; i < eiNews.Count; i++)
        {
            try
            {
                db.execute("insert into employee(userid,name,passwd,remark,[level]) "
                    + "values('" + eiNews[i].userid + "','" 
                    + eiNews[i].name + "','"
                    + eiNews[i].EncodePwd() + "','" 
                    + eiNews[i].remark + "'," + eiNews[i].level + ")");
                succNum += 1;
            }
            catch (Exception e)
            {
                errNum += 1;
                failMessages += "<br>用户添加失败：登录名=" + eiNews[i].userid + ",message=" + e.Message;
            }
        }

        // delete
        db.execute("delete from employee where id in(" + Request["delete"] + ")");

        Response.Write("{\"status\":\"0\", \"successNum\":\"" + succNum
            + "\", \"errorNum\":\"" + errNum + "\", \"errorMessages\":\"" + failMessages + "\"}");

        db.close();
    }

    private void QueryRegions()
    {
        dbutil db = new dbutil();
        DataTable dt = db.query("select * from region");

        string json = "{\n"
            + "  \"type\": \"data\","
            + "  \"status\":0,"
            + "  \"count\": \"" + dt.Rows.Count + "\","
            + "  \"employees\": [" + db.getEmployeeId2NameMapping() + "],\n"
            + "  \"records\": [\n";

        foreach (DataRow row in dt.Rows)
        {
            json += "\n{"
                + "  \"id\":\"" + row["id"] + "\""
                + ", \"name\":\"" + row["name"] + "\""
                + ", \"employee\":\"" + row["employee"] + "\""
                + "},";
        }
        char[] trimChars = { ',' };
        json = json.TrimEnd(trimChars);
        db.close();
        json += "]}";

        Response.Write(json);

        db.close();
    }

    private void UpdateRegions()
    {
        List<RegionInfo> eiModfies = (List<RegionInfo>)(new DataContractJsonSerializer(typeof(List<RegionInfo>)))
            .ReadObject(new MemoryStream(Encoding.UTF8.GetBytes(Request["modifies"])));
        List<RegionInfo> eiNews = (List<RegionInfo>)(new DataContractJsonSerializer(typeof(List<RegionInfo>)))
            .ReadObject(new MemoryStream(Encoding.UTF8.GetBytes(Request["news"])));

        string failMessages = "";
        int succNum = 0, errNum = 0;
        dbutil db = new dbutil();

        // update
        for (int i = 0; i < eiModfies.Count; i++)
        {
            try
            {
                db.execute("update region set "
                    + "employee='" + eiModfies[i].employee + "'"
                    + ",name='" + eiModfies[i].name + "' where id=" + eiModfies[i].id);
                succNum += 1;
            }
            catch (Exception e)
            {
                errNum += 1;
                failMessages += "<br>用户更新失败：id=" + eiModfies[i].id + ",message=" + e.Message;
            }
        }

        // new
        for (int i = 0; i < eiNews.Count; i++)
        {
            try
            {
                db.execute("insert into region(name,employee) "
                    + "values('" + eiNews[i].name + "','"
                    + eiNews[i].employee + "')");
                succNum += 1;
            }
            catch (Exception e)
            {
                errNum += 1;
                failMessages += "<br>用户添加失败：区域=" + eiNews[i].name + ",message=" + e.Message;
            }
        }

        // delete
        db.execute("delete from region where id in(" + Request["delete"] + ")");

        Response.Write("{\"status\":\"0\", \"successNum\":\"" + succNum
            + "\", \"errorNum\":\"" + errNum + "\", \"errorMessages\":\"" + failMessages + "\"}");

        db.close();
    }

    private void UserLogout()
    {
        Session["userId"] = null;
        Session["userName"] = null;
        Session["userLevel"] = null;
        Session["userFullName"] = null;

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

        if (Session["userId"] == null)
        {
            Response.Redirect("index.aspx", true);
        }

        userLevel = (int)Session["userLevel"];
        employeeId = (int)Session["userId"];

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
            case "userlist":
                GetUserList();
                return;
            case "updateUser":
                UpdateUserInfo();
                return;
            case "regionList":
                QueryRegions();
                return;
            case "updateRegion":
                UpdateRegions();
                return;
        }
    }

}