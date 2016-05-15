
<%@ Page Language="C#" %>

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
            Response.Write("{\"number\":\"" + Application["_ok_records"]
                + "\",\"error\":\"" + Application["_error_records"]
                + "\",\"total\":\"" + Application["_total_records"] + "\"}");
            return;
        }

        string bizData = Request["paragraphText"];

        DataParagrapher paragraph = new DataParagrapher();

        int ok = 0, err = 0;
        int count = paragraph.DoParagraph(bizData);

        //_processed_records = 0;
        //_total_records = count;
        Application["_ok_records"] = 0;
        Application["_error_records"] = 0;
        Application["_total_records"] = count;
        //Response.ContentType = "text/plain";
        //Response.Write("{\"type\":\"status\",\"message\":\"total " + count + "paragraphs will be processed.\"}");
        //Response.Flush();
        //Response.End();

        DataRecordItem dri = new DataRecordItem();

        string json = "{\n"
            + "  \"type\": \"data\",\n"
            + "  \"count\": \"" + count + "\",\n"
            + "  \"records\": [\n";

        for (int i = 0; i < count; i++)
        {
            DataParagraph para = paragraph.paragraphs[i];

            ParseError status;
            string message;

            try
            {
                char[] trimChars = { '\r', ' ', '.', '¡£', ';', '£»' };
                string data = para.text
                    .Trim(trimChars)
                    .Replace(" ", "");

                dri.Reset();

                DataParser dp = DataParser.GetParser(data);

                dp.Parse(data, ref dri);

                status = ParseError.Okay;
                message = "OK";
                //_processed_records += 1;

                Application["_ok_records"] = ++ok;
            }
            catch (DataParseException e)
            {
                status = e.code;
                message = "½âÎö³öÏÖ´íÎó:" + e.Message.Replace("\r\n", "<br>");
                Application["_error_records"] = ++err;
            }

            json += "{"
                + "\"valid\":\"" + (status == ParseError.Okay ? "true" : "false") + "\""
                + ", \"accused\":\"" + dri.accused + "\""
                + ", \"accuser\":\"" + dri.accuser + "\""
                + ", \"type\":\"" + (int)dri.type + "\""
                + ", \"court\":\"" + dri.court + "\""
                + ", \"courtRoom\":\"" + dri.courtRoom + "\""
                + ", \"telephone\":\"" + dri.telephone + "\""
                + ", \"caseTitle\":\"" + dri.caseTitle + "\""
                + ", \"status\":\"" + (int)status + "\""
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

        Response.Write(json);        
    }
</script>