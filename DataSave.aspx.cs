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

public partial class DataSave : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string a = Request["data"];
        if (a != null)
        {
            MemoryStream ms = new MemoryStream(Encoding.UTF8.GetBytes(a));
            List<DataRecordItem> dri = (List<DataRecordItem>)(new DataContractJsonSerializer(typeof(List<DataRecordItem>))).ReadObject(ms);

            Response.Write("{\"status\":\"0\", \"successNum\":\"" + dri.Count + "\", \"message\":\"操作成功。\"}");
        }
    }
}