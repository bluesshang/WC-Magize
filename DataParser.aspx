
<%@ Page Language="C#" ValidateRequest="False"  %>

<%@ import namespace="System" %>
<%@ import namespace="System.Data" %>
<%@ import namespace="System.Configuration" %>
<%@ import namespace="System.Collections" %>
<%@ import namespace="System.Configuration" %>
<%@ import namespace="System.Web" %>
<%@ import namespace="System.Web.Security" %>
<%@ import namespace="System.Web.UI" %>
<%@ import namespace="System.Web" %>
<%@ import namespace="System.Web.UI.WebControls" %>
<%@ import namespace="System.Web.UI.WebControls.WebParts" %>
<%@ import namespace="System.Web.UI.HtmlControls" %>
<%@ import namespace="System.Data.OleDb" %>
<%@ import namespace="System.Runtime.Serialization.Json" %>
<%@ import namespace="System.Web.Script.Serialization" %>
<%@ import namespace="System.IO" %>

<script runat="server">
    public class Person
    {
        public string name, phone;
        //[DataMember(Order = 2)]
        public string address;
        public int age;
    }
    protected void Page_Load(object sender, EventArgs args)
    {
        /*string a = Request["data"];
        if (a != null)
        {
            MemoryStream ms = new MemoryStream(Encoding.UTF8.GetBytes(a));
            List<Person> pers = (List<Person>)(new DataContractJsonSerializer(typeof(List<Person>))).ReadObject(ms);
        }*/

        if (Request["get_status"] == "true")
        {
            Response.Write("{\"number\":\"" + Session["_ok_records"]
                + "\",\"error\":\"" + Session["_error_records"]
                + "\",\"total\":\"" + Session["_total_records"] + "\"}");
            return;
        }

        string bizData = Request["paragraphText"];

        DataParagrapher paragraph = new DataParagrapher();

        dbutil db = new dbutil();
        
        int ok = 0, err = 0;
        int count = paragraph.DoParagraph(bizData);

        //_processed_records = 0;
        //_total_records = count;
        Session["_ok_records"] = 0;
        Session["_error_records"] = 0;
        Session["_total_records"] = count;
        //Response.ContentType = "text/plain";
        //Response.Write("{\"type\":\"status\",\"message\":\"total " + count + "paragraphs will be processed.\"}");
        //Response.Flush();
        //Response.End();

        DataRecordItem dri = new DataRecordItem();

        string json = "{\n"
            + "  \"type\": \"data\",\n"
            + "  \"count\": \"" + count + "\",\n"
            + "  \"employees\": [" + db.getEmployeeId2NameMapping() + "],\n"
            + "  \"records\": [\n";

        for (int i = 0; i < count; i++)
        {
            DataParagraph para = paragraph.paragraphs[i];

            ParseError status;
            string message;

            try
            {
                char[] trimChars = { '\r', ' ', '.', '��', ';', '��' };
                string data = para.text
                    .Trim(trimChars)
                    .Replace(" ", "")
                    .Replace("\t", "");

                dri.Reset();

                DataParser dp = DataParser.GetParser(data);

                dp.Parse(data, ref dri);

                status = ParseError.Okay;
                message = "OK";
                //_processed_records += 1;

                Session["_ok_records"] = ++ok;
            }
            catch (DataParseException e)
            {
                status = e.code;
                message = "�������ִ���:" + e.Message.Replace("\r\n", "<br>");
                Session["_error_records"] = ++err;
            }

            json += "{"
                + "\"valid\":\"" + (status == ParseError.Okay ? "true" : "false") + "\""
                + ", \"id\":\"" + (i + 1) + "\""
                + ", \"accused\":\"" + dri.accused + "\""
                + ", \"accuser\":\"" + dri.accuser + "\""
                + ", \"type\":\"" + (int)dri.type + "\""
                + ", \"court\":\"" + dri.court + "\""
                + ", \"judge\":\"" + dri.judge + "\""
                + ", \"date\":\"" + DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss") + "\""
                + ", \"courtRoom\":\"" + dri.courtRoom + "\""
                + ", \"telephone\":\"" + dri.telephone + "\""
                + ", \"title\":\"" + dri.title + "\""
                + ", \"status\":\"" + (int)status + "\""
                + ", \"receivable\":\"\""
                + ", \"arrival\":\"\""
                + ", \"employee\":\"" + db.guessEmployeeByCourt(dri.court) + "\""
                + ", \"magazine\":\"0\""
                + ", \"arrivalFrom\":\"\""
                + ", \"remark\":\"\""
                + ", \"message\":\"" + message.Replace("\"", "\\\"") + "\""
                + ", \"para\":{"
                    + "\"begin\":\"" + para.begin + "\""
                    + ", \"end\":\"" + para.end + "\""
                    + ", \"text\":\"" + para.text
                       .Replace("\r\n", "<br>")
                       .Replace("\n", "<br>") + "\""
                    + "}"
                + "}" + (i == count - 1 ? "" : ",") + "\n";
        }

        json += "]}";
        db.close();
        
        Response.Write(json);        
    }
</script>