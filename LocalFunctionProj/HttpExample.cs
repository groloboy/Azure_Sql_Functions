using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System.Data.SqlClient;
using System.Threading.Tasks;
using System.Collections.Generic;

namespace LocalFunctionProj
{
    public static class HttpExample
    {
        [FunctionName("HttpExample")]
        public static async Task<IActionResult> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = null)] HttpRequest req, ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            string name = req.Query["name"];
            string newName = req.Query["newName"];
            
            // Get the connection string from app settings and use it to create a connection.
            var str = "Server=tcp:server-5005.database.windows.net,1433;Initial Catalog=mySampleDatabase;Persist Security Info=False;User ID=azureuser;Password=Azure1234567!;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=60;";
            var res = new List<string>();
            using (SqlConnection conn = new SqlConnection(str))
            {
                conn.Open();
                var text="";
                if (name != null && newName != null){
                    text = "UPDATE [SalesLT].[ProductCategory] " +
                            "SET [name] = '"+newName+"'  WHERE [name] = '"+name+"'";
                }
                else{
                    text = "select name from [SalesLT].[ProductCategory];";
                }
                using (SqlCommand cmd = new SqlCommand(text, conn))
                {
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.HasRows)
                    {
                        while (reader.Read())
                        {
                            res.Add(reader.GetString(0));
                        }
                    }
                    reader.Close();
                    conn.Close();

                }
            }
            return new OkObjectResult(res);
        }
    }
}