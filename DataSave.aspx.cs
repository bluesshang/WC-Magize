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
    protected void Page_Load(object sender, EventArgs e)
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
                OleDbCommand MyCmd = new OleDbCommand("insert into bizdata (type,accused,accuser,court,courtRoom,originalText) " +
                    "values(" + (int)dri[i].type
                        + ", '" + dri[i].accused + "'"
                        + ", '" + dri[i].accuser + "'"
                        + ", '" + dri[i].court + "'"
                        + ", '" + dri[i].courtRoom + "'"
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
}