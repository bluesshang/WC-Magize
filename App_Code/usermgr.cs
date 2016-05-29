
using System.Security.Cryptography;  

public class EmployeeInfo
{
    public int id;
    public string userid;
    public string name;
    public string passwd;
    public string passwdOld;
    public string remark;
    public int level;

    public string EncodePwd()
    {
        string md5 = "";
        //MD5 md5 = new MD5CryptoServiceProvider();
        byte[] result = new MD5CryptoServiceProvider().ComputeHash(System.Text.Encoding.Default.GetBytes(passwd));
        for (int i = 0; i < result.Length; i++)
        {
            md5 += result[i].ToString("X");
        }
        //return System.Text.Encoding.Default.GetString(result);  
        return md5;
    }
}

public class RegionInfo
{
    public int id;
    public string name;
    public int employee;
}